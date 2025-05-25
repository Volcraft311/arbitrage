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

function PLUGIN:OpenMonoMenu(client, bRefresh)
    local data = {character = {}, notcharacter = {}}
    Arbitrage.players = Arbitrage.players or {}

    for k, v in pairs(Arbitrage.players) do
        v.steamid = k
        v.client = player.GetBySteamID(k)
        v.alive = IsValid(v.client) and v.client:Alive() or false

        data.character[k] = v
    end

    for k, v in ipairs(player.GetAll()) do
        local steamid = v:SteamID()

        if !Arbitrage.players[steamid] then
            data.notcharacter[steamid] = {
                client = v,
                faction = v:Team(),
                place = v:LawPlace(),
                steamid = steamid,
                steamname = v:SteamName(),
                alive = v:Alive()
            }
        end
    end

    if bRefresh then
        asterionlib.netgui:Call(client, "arb.MonoMenu", "SetData", data)
    else
        asterionlib.netgui:Rebuild(client, "arb.MonoMenu", nil, "SetData", data)
    end
end

local function CheckVoting(players, data)
    if #players <= 0 then return true end -- прерываем голосование т.к. нету участников

    local sendData = {}
    local num_voting = table.Count(data)

    for k, v in pairs(data) do
        sendData[v] = sendData[v] or 0
        sendData[v] = sendData[v] + 1
    end

    return num_voting >= #players, sendData
end

function PLUGIN:StartVoting()
    ScriptMusic:ChangeTheme("voting", true)

    self.voteTime = RealTime() + 60
    self.votingData = {}
    local showingList = {}

    local data = {}
    for k, v in pairs(Arbitrage.players) do
        local steamid = v.steamid
        local faction = v.faction
        local alive = v.alive

        if !IsHost(steamid) and IsPlaying(faction) then
            data[#data + 1] = {
                steamid,
                faction,
                alive
            }

            local client = player.GetBySteamID(steamid)
            if IsValid(client) and client:Alive() then
                showingList[#showingList + 1] = client
            end
        end
    end

    for k, v in ipairs(player.GetAll()) do
        asterionlib.netgui:Create(v, "arb.VoteScreen", nil, "SetData", data, showingList)
    end

    timer.Remove("arb.CheckVotes")
    timer.Create("arb.CheckVotes", 1, 0, function()
        local isAllVoting, votingList = CheckVoting(showingList, self.votingData)

        if RealTime() >= self.voteTime or isAllVoting then
            timer.Remove("arb.CheckVotes")

            local newData = {}
            local faction

            if votingList and table.Count(votingList) >= 1 then
                for k, v in pairs(votingList) do newData[#newData + 1] = {k, v} end

                table.sort(newData, function(a, b) return a[2] > b[2] end)

                local winning = newData[1] and newData[1][1] or ""
                local clientData = Arbitrage.players[winning]

                if clientData then
                    faction = clientData.faction
                end
            end

            local str = "#monomenu_vote_info \n"
            for k, v in ipairs(newData) do
                local steamid = v[1]
                local num = v[2]

                local clientData = Arbitrage.players[steamid]
                local factionData = Character.team:GetByID(clientData.faction)

                local info = factionData.name .. " (" .. steamid .. ")"

                str = str .. info .. ". #monomenu_vote_amount  " .. num .. "\n"
            end

            for k, v in ipairs(player.GetAll()) do
                asterionlib.netgui:Call(v, "arb.VoteScreen", "End", faction, self.votingData)

                if v:IsHost() then
                    netstream.Start(v, "arb.SendMessage", str)
                end
            end

            timer.Simple(2, function()
                ScriptMusic:ChangeTheme("execution", true)

                timer.Remove("arb.VoteThemeClear")
                timer.Create("arb.VoteThemeClear", 240, 1, function()
                    timer.Remove("arb.VoteThemeClear")

                    ScriptMusic:ChangeTheme("none", true)
                end)
            end)
        end
    end)
end

netstream.Hook("arb.OpenMonoMenu", function(client)
    if !client:IsAdmin() then return end

    PLUGIN:OpenMonoMenu(client)
end)

hook("ChatAddText", function(client, message)
    for k, v in ipairs(player.GetAdmins()) do
        local data = v:GetLocalVar("spectatescommand", {})

        if data[client:SteamID()] then
            netstream.Start(v, "arb.SendMessage", Color(255, 0, 0), "#monomenu_spectate_main ", team.GetColor(client:Team()), client:FullName(), Color(238, 220, 194), " #monomenu_spectate_chat ", "'", message, "'")
        end
    end
end)

netstream.Hook("arb.StartSpectateCommand", function(client, steamid)
    if !client:IsAdmin() then return end

    local target = player.GetBySteamID(steamid)
    if !IsValid(target) then return end

    local data = client:GetLocalVar("spectatescommand", {})
    if !data[steamid] then
        data[steamid] = true
        client:ChatNotify("#monomenu_spectate_started " .. target:FullName())

        client:SetLocalVar("spectatescommand", data)
    end
end)

netstream.Hook("arb.EndSpectateCommand", function(client, steamid)
    if !client:IsAdmin() then return end

    local target = player.GetBySteamID(steamid)
    if !IsValid(target) then return end

    local data = client:GetLocalVar("spectatescommand", {})
    if data[steamid] then
        data[steamid] = nil
        client:ChatNotify("#monomenu_spectate_stopped " .. target:FullName())

        client:SetLocalVar("spectatescommand", data)
    end
end)

local actionList = {
    ["setfaction"] = function(client, steamid, faction, bRespawn)
        local factionData = Character.team:GetByID(faction)
        if !factionData then return end

        local data = Arbitrage.players[steamid]
        if data then
            data.faction = faction
        end

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        if IsValid(target) then
            Character.team:Join(target, faction, bRespawn)
        end

        AdminNotify:SendNotify("transfercharacter", client:FullName(), m_target, faction)
    end,
    ["addgame"] = function(client, target)
        if !IsValid(target) then return end

        local count = table.Count(Arbitrage.players)
        local id = Arbitrage.placesList and math.Clamp(count + 1, 1, #Arbitrage.placesList) or -1

        Arbitrage.players[target:SteamID()] = {
            faction = target:Team(),
            place = id,
            steamname = target:SteamName()
        }

        target:SetNetVar("arbLaw", id)

        AdminNotify:SendNotify("addgame", client:FullName(), target:FullName())
    end,
    ["removegame"] = function(client, steamid)
        if !Arbitrage.players[steamid] then return end

        Arbitrage.players[steamid] = nil

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        if IsValid(target) then
            target:SetNetVar("arbLaw", -1)
        end

        AdminNotify:SendNotify("removegame", client:FullName(), m_target)
    end,
    ["returngame"] = function(client, target)
        if !IsValid(target) then return end

        local data = target:GetNetVar("arb.oldData")
        if !data then return end

        target:SetNetVar("arb.oldData", nil)
        Character.team:Join(target, data[1], true)

        timer.Simple(0.1, function()
            target:SetPos(data[2])
            Arbitrage.player.SetupHealth(target)
        end)

        for k, v in ipairs(ents.FindByClass("prop_ragdoll")) do
            if v:GetNetVar("sIsPersistent") != target:SteamID() then continue end

            target:LoadSaverInfo(v:GetSaverInfo(), true)

            local inventory = v:GetInventory() or v._containerInventory
            if !inventory then continue end

            for x = 1, inventory.w do
                for y = 1, inventory.h do
                    local item = inventory:GetItemAt(x, y)
                    if !item then continue end

                    item:Transfer(target:GetInventory():GetID(), x, y)
                end
            end

            v:Remove()
        end

        AdminNotify:SendNotify("returngame", client:FullName(), target:FullName())
    end,
    ["setfakename"] = function(client, target, name)
        if !IsValid(target) then return end

        target:SetFakeName(name)

        AdminNotify:SendNotify("setfakename", client:FullName(), target:FullName(), name)
    end,
    ["changestatus"] = function(client, target, state)
        if !IsValid(target) then return end

        target:SetNetVar("arbAlive", state)

        AdminNotify:SendNotify("changestatus", client:FullName(), target:FullName(), state == nil and "#monomenu_spectate_alive" or "#monomenu_spectate_dead")
    end,
    ["setplace"] = function(client, steamid, place)
        if !Arbitrage.players[steamid] then return end

        Arbitrage.players[steamid].place = place

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        if IsValid(target) then
            target:SetNetVar("arbLaw", place)
        end

        AdminNotify:SendNotify("setplace", client:FullName(), place, m_target)
    end,
    ["setmodel"] = function(client, target, model)
        if !IsValid(target) then return end

        target:SetModel(model)

        timer.Simple(2, function()
            target:SetupHands()
        end)

        Arbitrage.player.SetupViewOffset(target)

        AdminNotify:SendNotify("setmodel", client:FullName(), target:FullName(), model)
    end,
    ["resetstats"] = function(client, target)
        if !IsValid(target) then return end

        local health, armor = ARBITRAGE_HEALTH, ARBITRAGE_ARMOR

        local id = target:Team()
        local character = Character.team:GetByID(id)
        if character then
            health = character:GetHealth()
            armor = character:GetArmor()
        end

        target:SetHealth(health)
        target:SetArmor(armor)

        for k, v in pairs(Arbitrage.statistics.list) do
            Arbitrage.statistics.Set(target, v.data, 100)
        end

        AdminNotify:SendNotify("resetstats", client:FullName(), target:FullName())
    end,
    ["globalvoice"] = function(client, target, value)
        if !IsValid(target) then return end

        value = value and true or nil

        target:SetNetVar("arbGlobalVoice", value)

        if client != target then
            target:ChatNotify(value and "monomenu_on_global_voice_chat" or "monomenu_off_global_voice_chat")
        end

        AdminNotify:SendNotify("globalvoice", client:FullName(), target:FullName(), value)
    end,
    ["mutevoice"] = function(client, target, value)
        if !IsValid(target) then return end

        value = value and true or nil

        target:SetNetVar("arb.MuteVoice", value)

        if value then
            target.isTalking = nil
        end

        if client != target then
            target:ChatNotify(value and "#monomenu_ban_voice_chat" or "#monomenu_unban_voice_chat")
        end

        AdminNotify:SendNotify("mutevoice", client:FullName(), target:FullName(), value)
    end,
    ["mutenonrpchat"] = function(client, target, value)
        if !IsValid(target) then return end

        value = value and true or nil

        target:SetNetVar("arb.MuteNonRPChat", value)

        if client != target then
            target:ChatNotify(value and "#monomenu_ban_nonrp_chat" or "#monomenu_unban_nonrp_chat")
        end

        AdminNotify:SendNotify("mutenonrpchat", client:FullName(), target:FullName(), value)
    end,
    ["setdescription"] = function(client, target, data)
        if !IsValid(target) then return end

        data = tostring(data)
        if !data then return end

        data = string.Trim(data)
        if data == "" then
            data = nil
        end

        target:SetNetVar("description", data)

        if client != target then
            target:ChatNotify("#monomenu_description_change")
        end

        AdminNotify:SendNotify("setdescription", client:FullName(), target:FullName())
    end,
    ["setforceddescription"] = function(client, target, data)
        if !IsValid(target) then return end

        data = tostring(data)
        if !data then return end

        data = string.Trim(data)
        if data == "" then
            data = nil
        end

        target:SetNetVar("forced_description", data)

        AdminNotify:SendNotify("setforceddescription", client:FullName(), target:FullName())
    end,
    ["setscale"] = function(client, target, data)
        if !IsValid(target) then return end

        data = tonumber(data)
        if !data then return end

        target:SetModelScale(data)
        Character.team:EstablishHull(target)

        AdminNotify:SendNotify("setscale", client:FullName(), target:FullName(), data)
    end,
    ["setstats"] = function(client, target, data, amount)
        if !IsValid(target) then return end

        if data == "health" then
            target:SetHealth(amount)
        elseif data == "armor" then
            target:SetArmor(amount)
        elseif data == "hunger" then
            Arbitrage.statistics.Set(target, "Hunger", amount)
        elseif data == "thirst" then
            Arbitrage.statistics.Set(target, "Thirst", amount)
        elseif data == "sleep" then
            Arbitrage.statistics.Set(target, "Sleep", amount)
        else
            return
        end

        AdminNotify:SendNotify("setstats", client:FullName(), data, target:FullName(), amount)
    end,
    ["setspeed"] = function(client, target, data, speed)
        if !IsValid(target) then return end

        speed = tonumber(speed)
        if !speed then return end

        if speed == 1 then
            speed = nil
        end

        if data == "walk" then
            target.arb_walkSpeed = speed
        elseif data == "run" then
            target.arb_runSpeed = speed
        end

        AdminNotify:SendNotify("setspeed", client:FullName(), data, target:FullName(), speed)
    end,
    ["claerinventory"] = function(client, target)
        if !IsValid(target) then return end

        local inventory = target:GetInventory()
        if !inventory then return client:ChatNotify("#monomenu_inventory_not_found") end

        local items = inventory:GetItems()
        for k, v in pairs(items) do
            if v:GetData("equip") then
                v:UnEquip(target, v)
            end

            v:Remove()
        end

        AdminNotify:SendNotify("claerinventory", client:FullName(), target:FullName())
    end,
    ["openinventory"] = function(client, target)
        if !IsValid(target) then return end

        if client == target then return client:ChatNotify("#monomenu_inventory_own_open") end

        local inventory = target:GetInventory()
        if !inventory then return client:ChatNotify("#monomenu_inventory_not_found") end

        InventoryBase.Open(client, inventory:GetID(), target:Name())

        AdminNotify:SendNotify("openinventory", client:FullName(), target:FullName())
    end,
    ["scaleinventory"] = function(client, target, x, y)
        if !IsValid(target) then return end

        local inventory = target:GetInventory()
        if !inventory then return client:ChatNotify("#monomenu_inventory_not_found") end

        x, y = tonumber(x), tonumber(y)

        if !x then return end
        if !y then return end

        inventory:SetSize(x, y)
        inventory:Sync()

        AdminNotify:SendNotify("scaleinventory", client:FullName(), target:FullName(), x, y)
    end,
    ["addhost"] = function(client, steamid)
        if IsHost(steamid) then return end

        local data = GetNetVar("hostList", {})
        data[steamid] = true

        SetNetVar("hostList", data)

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        AdminNotify:SendNotify("addhost", client:FullName(), m_target)
    end,
    ["removehost"] = function(client, steamid)
        if !IsHost(steamid) then return end

        local data = GetNetVar("hostList", {})
        data[steamid] = nil

        SetNetVar("hostList", data)

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        AdminNotify:SendNotify("removehost", client:FullName(), m_target)
    end,
    ["addtemporarystatuseffect"] = function(client, target, uniqueID, delay)
        if !isnumber(delay) then return end

        local message = target:AddTemporaryStatusEffect(uniqueID, delay)
        if message then
            client:ChatNotify(message)
        end

        AdminNotify:SendNotify("addstatuseffect", client:FullName(), target:FullName(), uniqueID, delay)
    end,
    ["removetemporarystatuseffect"] = function(client, target, uniqueID)
        if !IsValid(target) then return end

        local message = target:RemoveTemporaryStatusEffect(uniqueID)
        if message then
            client:ChatNotify(message)
        end

        AdminNotify:SendNotify("removestatuseffect", client:FullName(), target:FullName(), uniqueID)
    end,
    ["cleartemporarystatuseffects"] = function(client, target)
        if !IsValid(target) then return end

        local message = target:ClearTemporaryStatusEffects()
        if message then
            client:ChatNotify(message)
        end

        AdminNotify:SendNotify("clearstatuseffect", client:FullName(), target:FullName(), uniqueID)
    end,
    ["setfallover"] = function(client, target, delay)
        if !IsValid(target) then return end

        target:FallOver(delay)

        AdminNotify:SendNotify("setfallover", client:FullName(), target:FullName(), delay)
    end,
    ["setstandup"] = function(client, target)
        if !IsValid(target) then return end

        target:StandUp()

        AdminNotify:SendNotify("setstandup", client:FullName(), target:FullName())
    end
}

netstream.Hook("arb.MonoRunCommand", function(client, id, ...)
    if !client:IsAdmin() then return end

    local action = actionList[id]
    if !action then return end

    local data = {client, ...}
    action(unpack(data))

    timer.Simple(0.2, function()
        PLUGIN:OpenMonoMenu(client, true)
    end)
end)

netstream.Hook("arb.MonoRunCommandC", function(client, type_id, button_id)
    if !client:IsAdmin() then return end

    local tableData = type_id == 1 and PLUGIN.GameData or PLUGIN.AdminData

    local data = tableData[button_id]
    if !data then return end

    if data.onCreate then
        local bState = data.onCreate(client)

        if !bState then return end
    end

    local function notify()
        timer.Simple(0.2, function()
            PLUGIN:OpenMonoMenu(client)
        end)

        local str = isfunction(data.data) and data.data() or tostring(data.data)
        AdminNotify:SendNotify("monocommandc", client:FullName(), str)
    end

    local isCheckBox = data.isCheckBox

    if isCheckBox then
        local func = data.OnCheck(client) and data.onDisable or data.onEnable
        func(client)

        notify()
    else
        if data.onRun then
            local bState = data.onRun(client)
            if bState == false then return end

            notify()
        end
    end
end)

netstream.Hook("arb.MonoSetChapter", function(client, chapter_id)
    if !client:IsAdmin() then return end

    SetNetVar("arb.Chapter", chapter_id)
    AdminNotify:SendNotify("setchapter", client:FullName(), chapter_id)
end)

netstream.Hook("arb.MonoAddRules", function(client, title, description, image)
    if !client:IsAdmin() then return end

    local data = Arbitrage.GetAcademyRules()
    table.insert(data, {image, title, description})

    SetNetVar("arb.Rules", data)
    netstream.Start(nil, "MonoPad:EditRulesNotify", #data)
    MonoPad:SendNotify(nil)

    AdminNotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoEditRules", function(client, title, description, image, id)
    if !client:IsAdmin() then return end

    local data = Arbitrage.GetAcademyRules()
    if !data[id] then return end

    data[id] = {image, title, description}

    SetNetVar("arb.Rules", data)
    netstream.Start(nil, "MonoPad:EditRulesNotify", id)
    MonoPad:SendNotify(nil)

    AdminNotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoRemoveRules", function(client, id)
    if !client:IsAdmin() then return end

    local data = Arbitrage.GetAcademyRules()
    table.remove(data, id)

    SetNetVar("arb.Rules", data)

    AdminNotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoDefaultRules", function(client)
    if !client:IsAdmin() then return end

    SetNetVar("arb.Rules", nil)
    netstream.Start(nil, "MonoPad:EditRulesNotify", nil)
    MonoPad:SendNotify(nil)

    AdminNotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoAddGameLog", function(client, array)
    if !client:IsAdmin() then return end

    local a, b, c, d, e = array[1], array[2], array[3], array[4], array[5]
    e = e or Time:GetUnformated()

    local data = Arbitrage.GetGameLogs()
    table.insert(data, {a, b, c, d, e})

    SetNetVar("arb.GameLogs", data)
    netstream.Start(nil, "MonoPad:EditGameLogNotify")

    MonoPad:SendNotify(nil)
end)

netstream.Hook("arb.MonoEditGameLog", function(client, array)
    if !client:IsAdmin() then return end

    local a, b, c, d, e, f = array[1], array[2], array[3], array[4], array[5], array[6]
    e = e or Time:GetUnformated()

    local data = Arbitrage.GetGameLogs()
    if !data[f] then return end

    data[f] = {a, b, c, d, e}
    SetNetVar("arb.GameLogs", data)
    netstream.Start(nil, "MonoPad:EditGameLogNotify")
end)

netstream.Hook("arb.MonoRemoveGameLog", function(client, id)
    if !client:IsAdmin() then return end

    local data = Arbitrage.GetGameLogs()
    table.remove(data, id)

    SetNetVar("arb.GameLogs", data)
end)

netstream.Hook("arb.MonoSplashScreen", function(client, data)
    if !client:IsAdmin() then return end

    local el = {{}, {}, data[1], data[2], data[3]}

    for k, v in pairs(Arbitrage.players) do
        local steamid = v.steamid
        local faction = v.faction
        local alive = v.alive

        if !IsHost(steamid) and IsPlaying(faction) then
            el[1][#el[1] + 1] = {
                k,
                faction
            }

            if !alive then
                el[2][#el[2] + 1] = k
            end
        end
    end

    ScriptMusic:ChangeTheme("splashscreen", true)

    if data[4] == true then
        SetNetVar("arb.Chapter", data[1])
    end

    for k, v in ipairs(player.GetAll()) do
        asterionlib.netgui:Create(v, "arb.SplashScreen", nil, "SetData", el)
    end

    AdminNotify:SendNotify("startsplashscreen", client:FullName())

    timer.Simple(23, function()
        ScriptMusic:ChangeTheme("none", true)
    end)
end)

netstream.Hook("arb.MonoEndGame", function(client, title, attackerID, targetID, text1, text2)
    if !client:IsAdmin() then return end

    local factionAttacker = Character.team:GetByID(attackerID)
    if !factionAttacker then return end

    local factionTarget = Character.team:GetByID(targetID)
    if !factionTarget then return end

    for k, v in ipairs(player.GetAll()) do
        asterionlib.netgui:Create(v, "arb.MonoEndGame", nil, "SetData", title, attackerID, targetID, text1, text2)
    end

    AdminNotify:SendNotify("startendgame", client:FullName())
end)

netstream.Hook("arb.MonoChangeStyle", function(client, text, r, g, b)
    if !client:IsAdmin() then return end

    for k, v in ipairs(player.GetAll()) do
        asterionlib.netgui:Create(v, "arb.ChangeStyle", nil, "SetData", text, r, g, b)
    end
end)

netstream.Hook("arb.SendVote", function(client, data)
    if !client:InGame() then return end
    if !Arbitrage.players[data] then return end

    PLUGIN.votingData[client:SteamID()] = data
end)