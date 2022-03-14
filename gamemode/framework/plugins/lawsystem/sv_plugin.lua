--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

function PLUGIN:GameStart()
    local num = 1

    Arbitrage.players = Arbitrage.players or {}
    for k, v in pairs(Arbitrage.players) do
        local client = player.GetBySteamID(k)

        client:SetNetVar("arbLaw", num, client)
        Arbitrage.players[k].place = num

        num = num + 1
    end
end

function PLUGIN:DrawSprites(client, bState)
    if !IsValid(client) then return end

    client:SetNoDraw(bState)
    client:SetNotSolid(bState)
    client:DrawWorldModel(!bState)
    client:DrawShadow(bState)
    client:SetNoTarget(!bState)
end

function Arbitrage:StartLaw()
    Arbitrage.lawEnable = true
    SetNetVar("arb.StartLaw", Arbitrage.lawEnable)
    for k, v in ipairs(player.GetAll()) do
        v:SyncVars()
    end

    ScriptMusic:ChangeTheme("law", true)
    netstream.Start(nil, "arb.StartLaw")

    for k, v in ipairs(player.GetAll()) do
        v:SetNetVar("arbEmojiShow", nil)
        v:SetMoveType(MOVETYPE_WALK)
        v:SelectWeapon("tfa_arcade_key")
    end

    timer.Simple(2, function()
        local players_ignore = {}

        for k, v in pairs(Arbitrage.players) do
            local client = player.GetBySteamID(k)

            local place = tonumber(v.place)
            if place == -1 then continue end -- Место неуказано

            if IsValid(client) and client:Alive() and client:InGame() then
                local pos = place == 0 and PLUGIN.monokumPlace[game.GetMap()].pos or (PLUGIN.placesList[game.GetMap()][place] and PLUGIN.placesList[game.GetMap()][place].pos or nil)
                local ang = place == 0 and PLUGIN.monokumPlace[game.GetMap()].ang or (PLUGIN.placesList[game.GetMap()][place] and PLUGIN.placesList[game.GetMap()][place].ang or nil)

                if pos and ang then
                    players_ignore[k] = true

                    client:SetPos(pos)
                    client:SetEyeAngles(ang)
                    client:SetNetVar("arbEmojiShow", place)
                end
            else
                -- Типо игрока нету понял?
            end
        end


        for k, v in ipairs(player.GetAll()) do
            if !players_ignore[v:SteamID()] then
                v.arbOldPos = v:GetPos()

                v:SetPos(PLUGIN.camPosEnd[game.GetMap()])
            end

            timer.Simple(0.1, function()
                v:Freeze(true)
                PLUGIN:DrawSprites(v, true)
            end)
        end
    end)

    PLUGIN.talk_entity = nil
    PLUGIN.interruption = nil
end

function Arbitrage:EndLaw()
    Arbitrage.lawEnable = false
    SetNetVar("arb.StartLaw", Arbitrage.lawEnable)

    ScriptMusic:ChangeTheme("none", true)

    netstream.Start(nil, "arb.EndLaw")
    timer.Simple(2, function()
        for k, v in ipairs(player.GetAll()) do
            v:SyncVars()
            v:Freeze(false)
            PLUGIN:DrawSprites(v, false)

            if v.arbOldPos then
                v:SetPos(v.arbOldPos)
                v.arbOldPos = nil -- reset
            end
        end
    end)

    PLUGIN.talk_entity = nil
    PLUGIN.interruption = nil
end

function PLUGIN:ChangeEmoji(client, data)
    if !data then return end

    local charTeam = Arbitrage.teams.Get(client:Team())
    if !charTeam then return end

    local emojiList = charTeam.emodjiList
    if !emojiList then return end
    if !emojiList[data] then return end

    client:SetNetVar("emoji", emojiList[data])
end

function PLUGIN:StartVoice(client, anim)
    if !self.interruption or CurTime() >= self.interruption and self.talk_entity != client then
        netstream.Start(nil, "arb.LawTalking", client, anim)

        self.talk_entity = client
        self.interruption = CurTime() + 5

        print(client, anim)
    end
end

function PLUGIN:PlayerInitialSpawn(client)
    if !Arbitrage.lawEnable then return end

    timer.Simple(3, function()
        local steamid = client:SteamID()

        client:SetNetVar("arbEmojiShow", nil)
        client:SetMoveType(MOVETYPE_WALK)
        client:SelectWeapon("tfa_arcade_key")

        netstream.Start(client, "arb.StartLaw")

        if Arbitrage.players[steamid] then
            if IsValid(client) and client:Alive() and client:InGame() then
                local place = tonumber(Arbitrage.players[steamid].place)
                if !place then return end

                local pos = place == 0 and PLUGIN.monokumPlace[game.GetMap()].pos or (PLUGIN.placesList[game.GetMap()][place] and PLUGIN.placesList[game.GetMap()][place].pos or nil)
                local ang = place == 0 and PLUGIN.monokumPlace[game.GetMap()].ang or (PLUGIN.placesList[game.GetMap()][place] and PLUGIN.placesList[game.GetMap()][place].ang or nil)

                if pos and ang then
                    client:SetPos(pos)
                    client:SetEyeAngles(ang)
                    client:SetNetVar("arbEmojiShow", place)
                end
            end
        else
            client.arbOldPos = client:GetPos()

            client:SetPos(PLUGIN.camPosEnd[game.GetMap()])
        end

        timer.Simple(0.1, function()
            client:Freeze(true)
            PLUGIN:DrawSprites(v, true)
        end)
    end)
end

netstream.Hook("arb.ChangeEmoji", function(client, data)
    PLUGIN:ChangeEmoji(client, data)
end)

netstream.Hook("arb.StartVoice", function(client)
    if client:InGame() and client:Alive() then
        PLUGIN:StartVoice(client, math.random(1, #PLUGIN.CamAnimData))
    end
end)

netstream.Hook("arb.ShowEvidence", function(client, data)
    if !client:InGame() then return end
    if !client:Alive() then return end

    if (!PLUGIN.ShowEvidenceCD or CurTime() >= PLUGIN.ShowEvidenceCD) then
        local evidence = Evidence:GetEvidence(data)
        if !evidence then return end

        local mat = evidence.image
        netstream.Start(nil, "arb.ShowEvidence", client, mat, data)

        for k, v in ipairs(player.GetAll()) do
            v:AddEvidence(data)
        end

        PLUGIN.ShowEvidenceCD = CurTime() + 10
    end
end)