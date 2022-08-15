--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

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

    ScriptMusic:ChangeTheme("law", true)
    netstream.Start(nil, "arb.StartLaw")

    for k, v in ipairs(player.GetAll()) do
        v:SetNetVar("arbLaw", nil)
        v:SetMoveType(MOVETYPE_WALK)
        v:SelectWeapon("academy_key")
    end

    timer.Simple(2, function()
        local players_ignore = {}

        for k, v in pairs(Arbitrage.players) do
            local client = player.GetBySteamID(k)

            local place = tonumber(v.place)
            if place == -1 then continue end -- Место неуказано

            if IsValid(client) and client:Alive() and client:InGame() then
                local pos = Arbitrage.placesList[place] and Arbitrage.placesList[place][1]
                local ang = Arbitrage.placesList[place] and Arbitrage.placesList[place][2]

                if pos and ang then
                    players_ignore[k] = true

                    client:SetPos(pos)
                    client:SetEyeAngles(ang)
                    client:SetNetVar("arbLaw", place)
                end
            else
                -- Типо игрока нету понял?
            end
        end


        for k, v in ipairs(player.GetAll()) do
            if !players_ignore[v:SteamID()] then
                v.arbOldPos = v:GetPos()

                v:SetPos(Arbitrage.camPosEnd)
            end

            timer.Simple(0.1, function()
                v:Freeze(true)
                PLUGIN:DrawSprites(v, true)
            end)
        end
    end)

    PLUGIN.talk_entity = nil
    PLUGIN.interruption = nil

    hook.Add("SetupPlayerVisibility", "LawCamera", function(pPlayer, pViewEntity)
        for k, v in ipairs(player.GetAll()) do
            if v:LawPlace() >= 0 then
                AddOriginToPVS(v:GetPos())
            end
        end
    end)
end

function Arbitrage:EndLaw()
    Arbitrage.lawEnable = false
    SetNetVar("arb.StartLaw", Arbitrage.lawEnable)

    ScriptMusic:ChangeTheme("none", true)

    netstream.Start(nil, "arb.EndLaw")
    timer.Simple(2, function()
        for k, v in ipairs(player.GetAll()) do
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

    hook.Remove("SetupPlayerVisibility", "LawCamera")
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
    end
end

function PLUGIN:Focus(client, anim)
    if !self.focusCD or CurTime() >= self.focusCD then
        netstream.Start(nil, "arb.LawTalking", client, anim, true)

        self.talk_entity = client
        self.interruption = CurTime() + 20
        self.focusCD = CurTime() + 30
    end
end

function PLUGIN:Interruption(client, anim)
    if !self.interruptionCD or CurTime() >= self.interruptionCD then
        netstream.Start(nil, "arb.LawInterruption", client:Team())

        timer.Simple(2.5, function()
            netstream.Start(nil, "arb.LawTalking", client, anim)
        end)

        self.talk_entity = client
        self.interruption = CurTime() + 10
        self.focusCD = CurTime() + 10
        self.interruptionCD = CurTime() + 15
    end
end

function PLUGIN:PlayerInitialSpawn(client)
    local steamid = client:SteamID()

    timer.Simple(3, function()
        if Arbitrage.players[steamid] then
            local place = tonumber(Arbitrage.players[steamid].place)

            if place then
                client:SetNetVar("arbLaw", place)
            end
        end
    end)

    if !Arbitrage.lawEnable then return end

    timer.Simple(3, function()
        client:SetNetVar("arbLaw", nil)
        client:SetMoveType(MOVETYPE_WALK)
        client:SelectWeapon("academy_key")

        netstream.Start(client, "arb.StartLaw")

        if Arbitrage.players[steamid] then
            if IsValid(client) and client:Alive() and client:InGame() then
                local place = tonumber(Arbitrage.players[steamid].place)
                if !place then return end

                local pos = place == 0 and Arbitrage.monokumPlace[1] or (Arbitrage.placesList[place] and Arbitrage.placesList[place][1] or nil)
                local ang = place == 0 and Arbitrage.monokumPlace[2] or (Arbitrage.placesList[place] and Arbitrage.placesList[place][2] or nil)

                if pos and ang then
                    client:SetPos(pos)
                    client:SetEyeAngles(ang)
                    client:SetNetVar("arbLaw", place)
                end
            end
        else
            client.arbOldPos = client:GetPos()

            client:SetPos(Arbitrage.camPosEnd)
        end

        timer.Simple(0.1, function()
            client:Freeze(true)
            PLUGIN:DrawSprites(client, true)
        end)
    end)
end

netstream.Hook("arb.ChangeEmoji", function(client, data)
    if !Arbitrage.lawEnable then return end

    PLUGIN:ChangeEmoji(client, data)
end)

netstream.Hook("arb.StartVoice", function(client)
    if !Arbitrage.lawEnable then return end

    if client:InGame() and client:Alive() then
        PLUGIN:StartVoice(client, math.random(1, #PLUGIN.CamAnimData))
    end
end)

netstream.Hook("arb.LawFocus", function(client)
    if !Arbitrage.lawEnable then return end

    if client:InGame() and client:Alive() then
        PLUGIN:Focus(client, math.random(1, #PLUGIN.CamAnimData))
    end
end)

netstream.Hook("arb.LawInterruption", function(client)
    if !Arbitrage.lawEnable then return end

    if client:InGame() and client:Alive() then
        PLUGIN:Interruption(client, math.random(1, #PLUGIN.CamAnimData))
    end
end)

netstream.Hook("arb.ShowEvidence", function(client, data)
    if !Arbitrage.lawEnable then return end
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

netstream.Hook("arb.ShowItem", function(client, id)
    if !Arbitrage.lawEnable then return end
    if !client:InGame() then return end
    if !client:Alive() then return end

    if (!PLUGIN.ShowItemCD or CurTime() >= PLUGIN.ShowItemCD) then
        local item = ItemBase.instances[id]
        if !item then return end

        local inventory = client:GetInventory()
        if !inventory:HasItem(id) then return end

        item:Sync()

        local mat = item:GetIcon()
        netstream.Start(nil, "arb.ShowItem", client, mat, id)

        PLUGIN.ShowItemCD = CurTime() + 10
    end
end)

netstream.Hook("arb.InspectItem", function(client, id)
    if !Arbitrage.lawEnable then return end
    if !client:InGame() then return end
    if !client:Alive() then return end

    local item = ItemBase.instances[id]
    if !item then return end

    local action = item.lawInspect
    if !action then return end

    item.player = client

    local actionList = item:GetValidActions()
    local actionInfo = actionList[action]
    if actionInfo then
        local actionRun = actionInfo.OnRun

        if actionRun then
            local data = actionRun(item)

            if data != false then
                item:Remove()
            end
        end
    end

    item.player = nil
end)