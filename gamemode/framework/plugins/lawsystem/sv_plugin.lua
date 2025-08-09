--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN
PLUGIN.InterruptionCD = 5

local function randomID(old)
    local new = math.random(1, #PLUGIN.CamAnimData)

    if old != new then
        return new
    else
        return randomID(old)
    end
end

function PLUGIN:StartRebuttalShowdowns(client1, client2)
    if !Arbitrage.lawEnable then return end
    if self.IsRebuttalShowdowns then return end
    if Arbitrage.OffRebuttalShowdown() then return end

    self.RS_players = {
        [client1] = true,
        [client2] = true
    }

    self.RebuttalShowdownsMuted = CurTime() + 6.5
    self.IsRebuttalShowdowns = true
    self.RC_size = 0

    netstream.Start(nil, "arb.StartRebuttalShowdowns", client1, client2)

    hook.Add("Think", "arb.RebuttalShowdowns", function()
        if !IsValid(client1) or !IsValid(client2) then
            return self:EndRebuttalShowdowns()
        end

        if client1:GetLocalVar("rs_stopvoting") and client2:GetLocalVar("rs_stopvoting") then
            return self:EndRebuttalShowdowns()
        end

        local speed = FrameTime() * 0.2

        if client1.RC_speak then
            self.RC_size = Lerp(speed, self.RC_size, 1)
        end

        if client2.RC_speak then
            self.RC_size = Lerp(speed, self.RC_size, -1)
        end
    end)

    timer.Create("RebuttalShowdowns:Sync", 0.1, 0, function()
        SetNetVar("rc_size", self.RC_size)
    end)
end

function PLUGIN:EndRebuttalShowdowns()
    if !self.IsRebuttalShowdowns then return end

    for client in pairs(self.RS_players or {}) do
        if IsValid(client) then
            client:SetLocalVar("rs_stopvoting", false)
        end
    end

    self.RS_players = {}
    self.IsRebuttalShowdowns = false
    self.RC_size = 0

    self.RC_interruption = nil
    self.talk_entity = nil
    self.interruption = CurTime()
    self.focusCD = CurTime()
    self.interruptionCD = CurTime()
    self.oldAnimID = -1

    netstream.Start(nil, "arb.EndRebuttalShowdowns")

    hook.Remove("Think", "arb.RebuttalShowdowns")
    timer.Remove("RebuttalShowdowns:Sync")
end

concommand.Add("arb_stop_rebuttalshowdowns", function(client)
    if !Arbitrage.lawEnable then return end
    if !PLUGIN.IsRebuttalShowdowns then return end
    if !client:IsAdmin() then return end

    if client:InGame() then
        netstream.Start(nil, "arb.LawInterruption", client, client)

        timer.Simple(1.5, function()
            PLUGIN:EndRebuttalShowdowns()
        end)
    else
        PLUGIN:EndRebuttalShowdowns()
    end
end)

concommand.Add("arb_interruption_cd", function(client, cmd, args)
    if !client:IsAdmin() then return end

    local time = tonumber(args[1])
    if !time then return end

    PLUGIN.InterruptionCD = time
    client:ChatNotify(L(client, "#notify_changed_camera_interruption", time))
end)

concommand.Add("arb_sprites_size", function(client, cmd, args)
    if !client:IsAdmin() then return end

    local size = tonumber(args[1])
    if !size then return end

    SetNetVar("arb.SpritesSize", size)
    client:ChatNotify("Вы изменили максимальный размер спрайтов на " .. size .. "!")
end)

function Arbitrage:StartLaw()
    PLUGIN:EndRebuttalShowdowns()

    Arbitrage.lawEnable = true
    SetNetVar("arb.StartLaw", Arbitrage.lawEnable)

    ScriptMusic:ChangeTheme("law", true)
    for k, v in ipairs(player.GetAll()) do
        v:SendLua([=[RunConsoleCommand("stopsound")]=])
    end

    netstream.Start(nil, "arb.StartLaw")

    for k, v in ipairs(player.GetAll()) do
        v:SetNetVar("arbLaw", nil)
        v:SetMoveType(MOVETYPE_WALK)
        v:SelectWeapon("academy_key")

        v:ExitAction()
        v:ExitVehicle()
        v:SetNWBool("SitGroundSitting", false)
        v:StandUp()

        if v.IsProne and v:IsProne() then
            prone.Exit(v)
        end

        if v:IsSpectating() then
            v:ConCommand("spectate")
        end
    end

    timer.Simple(2, function()
        local players_ignore = {}

        for k, v in pairs(Arbitrage.players) do
            local client = player.GetBySteamID(k)

            local place = tonumber(v.place)
            if place == -1 then continue end -- Место неуказано

            if IsValid(client) and client:Alive() and client:InGame() then
                local info = Arbitrage.placesList[place]
                local pos = info and info[1]
                local ang = info and info[2]

                if pos and ang then
                    players_ignore[k] = true

                    client:SetPos(pos)
                    client:SetEyeAngles(ang)
                    client:SetNetVar("arbLaw", place)

                    client.oldScale = client:GetModelScale()
                    client:SetModelScale(0.1)
                end
            end
        end


        for k, v in ipairs(player.GetAll()) do
            if !players_ignore[v:SteamID()] then
                v.arbOldPos = v:GetPos()

                v:SetPos(Arbitrage.camPosEnd)
            end

            v:Freeze(true)
        end
    end)

    PLUGIN.talk_entity = nil
    PLUGIN.interruption = nil

    hook.Add("SetupPlayerVisibility", "LawCamera", function(client)
        local entity = PLUGIN.talk_entity
        if IsValid(entity) then
            AddOriginToPVS(entity:GetPos())
        end

        for k, v in ipairs({"camPosEnd"}) do
            local pos = Arbitrage[v]

            if pos then
                AddOriginToPVS(pos)
            end
        end
    end)
end

function Arbitrage:EndLaw()
    if PLUGIN.IsRebuttalShowdowns then
        PLUGIN:EndRebuttalShowdowns()
    end

    Arbitrage.lawEnable = false
    SetNetVar("arb.StartLaw", Arbitrage.lawEnable)

    ScriptMusic:ChangeTheme("none", true)

    netstream.Start(nil, "arb.EndLaw")
    timer.Simple(2, function()
        for k, v in ipairs(player.GetAll()) do
            v:Freeze(false)

            if v.arbOldPos then
                v:SetPos(v.arbOldPos)
                v.arbOldPos = nil -- reset
            else
                if !v:IsPlaying() then
                    local vector, _ = Arbitrage.lobbyList and table.Random(Arbitrage.lobbyList) or Vector(0, 0, 0)
                    v:SetPos(vector)
                end
            end

            if v.oldScale then
                v:SetModelScale(v.oldScale)
                v.oldScale = nil -- reset
            end

            v:CheckStuck(0.2)
        end
    end)

    PLUGIN.talk_entity = nil
    PLUGIN.interruption = nil

    hook.Remove("SetupPlayerVisibility", "LawCamera")
end

function PLUGIN:ChangeEmoji(client, index)
    if !index then return end

    local faction = Character.team:GetByID(client:Team())
    if !faction then return end

    local emoji = Character.emoji:GetByUniqueID(faction:GetUniqueID())
    if !emoji then return end

    local big, _ = emoji:GetByIndex(index)

    if big then
        client:SetNetVar("emoji", index)
    end
end

function PLUGIN:StartVoice(client, anim)
    if self.IsRebuttalShowdowns then return end

    if !self.interruption or CurTime() >= self.interruption and self.talk_entity != client then
        netstream.Start(nil, "arb.LawTalking", client, anim)

        self.talk_entity = client
        self.interruption = CurTime() + self.InterruptionCD

        self.oldAnimID = anim
    end
end

function PLUGIN:Focus(client, anim)
    if self.IsRebuttalShowdowns then return end
    if self.talk_entity == client then return end

    if !self.focusCD or CurTime() >= self.focusCD then
        netstream.Start(nil, "arb.LawTalking", client, anim, true)

        self.talk_entity = client
        self.interruption = CurTime() + 6
        self.focusCD = CurTime() + 10

        self.oldAnimID = anim
    end
end

function PLUGIN:Interruption(client, anim)
    if self.IsRebuttalShowdowns then return end

    if self.RC_interruption == client then
        if IsValid(self.RC_lastClient) and self.RC_lastClient != client and !Arbitrage.OffRebuttalShowdown() then
            return PLUGIN:StartRebuttalShowdowns(self.RC_lastClient, client)
        end
    else
        if !self.RC_interruption then
            self.RC_lastClient = self.talk_entity
        end
    end

    if self.talk_entity == client then return end
    if !self.interruptionCD or CurTime() >= self.interruptionCD then
        netstream.Start(nil, "arb.LawInterruption", client, self.RC_lastClient)

        timer.Simple(2.5, function()
            netstream.Start(nil, "arb.LawTalking", client, anim)

            self.RC_interruption = nil
        end)

        self.RC_interruption = client
        self.talk_entity = client
        self.interruption = CurTime() + 10
        self.focusCD = CurTime() + 10
        self.interruptionCD = CurTime() + 15

        self.oldAnimID = anim
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

        client.oldScale = client:GetModelScale()
        client:SetModelScale(0.1)

        netstream.Start(client, "arb.StartLaw")

        if Arbitrage.players[steamid] then
            if IsValid(client) and client:Alive() and client:InGame() then
                local place = tonumber(Arbitrage.players[steamid].place)
                if !place then return end

                local info = Arbitrage.placesList[place]
                local pos = info and info[1]
                local ang = info and info[2]

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

            if PLUGIN.IsRebuttalShowdowns then
                local data = {}

                for k, v in pairs(self.RS_players) do
                    data[#data + 1] = k
                end

                netstream.Start(client, "arb.StartRebuttalShowdowns", data[1], data[2])
            end
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
        PLUGIN:StartVoice(client, randomID(PLUGIN.oldAnimID))

        if PLUGIN.IsRebuttalShowdowns and PLUGIN.RS_players[client] then
            if CurTime() < (LawSystem.RebuttalShowdownsMuted or 0) then
                return
            end

            client.RC_speak = true

            if !client.RC_ChangeAnim or CurTime() >= client.RC_ChangeAnim then
                local anim = randomID(client.RC_oldAnim)
                netstream.Start(nil, "arb.LawTalking", client, anim)

                client.RC_oldAnim = anim
                client.RC_ChangeAnim = CurTime() + 5
            end
        end
    end
end)

netstream.Hook("arb.EndVoice", function(client)
    if !Arbitrage.lawEnable then return end

    if client:InGame() and client:Alive() then
        -- other

        if PLUGIN.IsRebuttalShowdowns and PLUGIN.RS_players[client] then
            client.RC_speak = false
        end
    end
end)

netstream.Hook("arb.LawFocus", function(client)
    if !Arbitrage.lawEnable then return end

    if client:InGame() and client:Alive() then
        PLUGIN:Focus(client, randomID(PLUGIN.oldAnimID))
    end
end)

netstream.Hook("arb.LawInterruption", function(client)
    if !Arbitrage.lawEnable then return end

    if client:InGame() and client:Alive() then
        PLUGIN:Interruption(client, randomID(PLUGIN.oldAnimID))
    end
end)

netstream.Hook("arb.StopRebuttalShowdowns", function(client)
    if !PLUGIN.IsRebuttalShowdowns then return end

    if PLUGIN.RS_players[client] then
        client:SetLocalVar("rs_stopvoting", true)

        for _client in pairs(PLUGIN.RS_players or {}) do
            if _client != client then
                _client:ChatNotify("#notify_player_two_voted_end_debate")
            end
        end
    end
end)

netstream.Hook("arb.ShowEvidence", function(client, data)
    if !Arbitrage.lawEnable then return end
    if !client:InGame() then return end
    if !client:Alive() then return end

    if (!PLUGIN.ShowEvidenceCD or CurTime() >= PLUGIN.ShowEvidenceCD) then
        local evidence = Evidence:GetEvidence(data)
        if !evidence then return end

        local time = client:HasEvidence(data)
        if !time then return end

        local mat = evidence.image
        netstream.Start(nil, "arb.ShowEvidence", client, mat, data)

        for k, v in ipairs(player.GetAll()) do
            v:AddEvidence(data, time)
        end

        local evidencesList = Arbitrage.GetShowEvidences()
        if !evidencesList[data] then
            evidencesList[data] = {time, client:Name()}
            SetNetVar("arb.ShowEvidences", evidencesList)
        else
            local oldTime = evidencesList[data][1]

            if time < oldTime then
                evidencesList[data] = {time, client:Name()}
                SetNetVar("arb.ShowEvidences", evidencesList)
            end
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