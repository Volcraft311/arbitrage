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

function PLUGIN:OpenMonoMenu(client, bRefresh)
    local data = {character = {}, notcharacter = {}}
    Arbitrage.players = Arbitrage.players or {}

    for k, v in pairs(Arbitrage.players) do
        v.steamid = k
        v.client = player.GetBySteamID(k)
        v.alive = IsValid(v.client) and v.client:Alive() or false

        data.character[k] = v
    end

    for k, v in pairs(player.GetAll()) do
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

            local str = "Информация о голосовании: \n"
            for k, v in ipairs(newData) do
                local steamid = v[1]
                local num = v[2]

                local clientData = Arbitrage.players[steamid]
                local factionData = Character.team:GetByID(clientData.faction)

                local info = factionData.name .. " (" .. steamid .. ")"

                str = str .. info .. ". Количество голосов:  " .. num .. "\n"
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

function PLUGIN:ChatAddText(client, message)
    for k, v in ipairs(player.GetAdmins()) do
        local data = v:GetLocalVar("spectatescommand", {})

        if data[client:SteamID()] then
            netstream.Start(v, "arb.SendMessage", Color(255, 0, 0), "[Слежка] ", team.GetColor(client:Team()), client:FullName(), Color(238, 220, 194), " написал в чат: ", "\"", message, "\"")
        end
    end
end

-- function PLUGIN:SetupPlayerVisibility(client, viewEntity)
--     if client:IsAdmin() and client:IsNocliping() then
--         for k, v in ipairs(player.GetAll()) do
--             AddOriginToPVS(v:GetPos())
--         end
--     end
-- end

netstream.Hook("arb.StartSpectateCommand", function(client, steamid)
    if !client:IsAdmin() then return end

    local target = player.GetBySteamID(steamid)
    if !IsValid(target) then return end

    local data = client:GetLocalVar("spectatescommand", {})
    if !data[steamid] then
        data[steamid] = true
        client:ChatNotify("Вы начали слежку за командами игрока: " .. target:FullName())
    else
        data[steamid] = nil
        client:ChatNotify("Вы перестали следить за командами игрока: " .. target:FullName())
    end

    client:SetLocalVar("spectatescommand", data)
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

        Arbitrage.adminnotify:SendNotify("transfercharacter", client:FullName(), m_target, faction)
    end,
    ["addgame"] = function(client, target)
        if !IsValid(target) then return end

        local count = table.Count(Arbitrage.players)

        Arbitrage.players[target:SteamID()] = {
            faction = target:Team(),
            place = Arbitrage.placesList and math.Clamp(count + 1, 1, #Arbitrage.placesList) or -1,
            steamname = target:SteamName()
        }

        target:SetNetVar("arbLaw", count + 1)

        Arbitrage.adminnotify:SendNotify("addgame", client:FullName(), target:FullName())
    end,
    ["removegame"] = function(client, steamid)
        if !Arbitrage.players[steamid] then return end

        Arbitrage.players[steamid] = nil

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        if IsValid(target) then
            target:SetNetVar("arbLaw", -1)
        end

        Arbitrage.adminnotify:SendNotify("removegame", client:FullName(), m_target)
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
            if v.client == target then
                local inventory = v:GetInventory()
                if inventory then
                    for x = 1, inventory.w do
                        for y = 1, inventory.h do
                            local item = inventory:GetItemAt(x, y)

                            if item then
                                item:Transfer(target:GetInventory():GetID(), x, y)
                            end
                        end
                    end
                end

                v:Remove()
            end
        end

        Arbitrage.adminnotify:SendNotify("returngame", client:FullName(), target:FullName())
    end,
    ["setfakename"] = function(client, target, name)
        if !IsValid(target) then return end

        target:SetFakeName(name)

        Arbitrage.adminnotify:SendNotify("setfakename", client:FullName(), target:FullName(), name)
    end,
    ["changestatus"] = function(client, target, state)
        if !IsValid(target) then return end

        target:SetNetVar("arbAlive", state)

        Arbitrage.adminnotify:SendNotify("changestatus", client:FullName(), target:FullName(), state == nil and "Живой" or "Мертвый")
    end,
    ["setplace"] = function(client, steamid, place)
        if !Arbitrage.players[steamid] then return end

        Arbitrage.players[steamid].place = place

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        if IsValid(target) then
            target:SetNetVar("arbLaw", place)
        end

        Arbitrage.adminnotify:SendNotify("setplace", client:FullName(), place, m_target)
    end,
    ["setmodel"] = function(client, target, model)
        if !IsValid(target) then return end

        target:SetModel(model)

        timer.Simple(2, function()
            target:SetupHands()
        end)

        Arbitrage.player.SetupViewOffset(target)

        Arbitrage.adminnotify:SendNotify("setmodel", client:FullName(), target:FullName(), model)
    end,
    ["resetstats"] = function(client, target)
        if !IsValid(target) then return end

        target:SetHealth(ARBITRAGE_HEALTH)
        target:SetArmor(ARBITRAGE_ARMOR)

        for k, v in pairs(Arbitrage.statistics.list) do
            Arbitrage.statistics.Set(target, v.data, 100)
        end

        Arbitrage.adminnotify:SendNotify("resetstats", client:FullName(), target:FullName())
    end,
    ["setstats"] = function(client, target, data, amount)
        if !IsValid(target) then return end

        amount = math.Clamp(tonumber(amount), 0, 1000)

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

        Arbitrage.adminnotify:SendNotify("setstats", client:FullName(), data, target:FullName(), amount)
    end,
    ["claerinventory"] = function(client, target)
        if !IsValid(target) then return end

        local inventory = target:GetInventory()
        if inventory then
            local items = inventory:GetItems()

            for k, v in pairs(items) do
                if v:GetData("equip") then
                    v:UnEquip(target, v)
                end

                v:Remove()
            end
        end

        Arbitrage.adminnotify:SendNotify("claerinventory", client:FullName(), target:FullName())
    end,
    ["openinventory"] = function(client, target)
        if !IsValid(target) then return end

        if client == target then
            return Arbitrage.commands.Notify(client, "Нельзя открыть собственный инвентарь!")
        end

        local inventory = target:GetInventory()
        if inventory then
            InventoryBase.Open(client, inventory:GetID(), target:Name())

            Arbitrage.adminnotify:SendNotify("openinventory", client:FullName(), target:FullName())
        else
            Arbitrage.commands.Notify(client, "У данного игрока не инициализирован инвентарь!")
        end
    end,
    ["addhost"] = function(client, steamid)
        if IsHost(steamid) then return end

        local data = GetNetVar("hostList", {})
        data[steamid] = true

        SetNetVar("hostList", data)

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        Arbitrage.adminnotify:SendNotify("addhost", client:FullName(), m_target)
    end,
    ["removehost"] = function(client, steamid)
        if !IsHost(steamid) then return end

        local data = GetNetVar("hostList", {})
        data[steamid] = nil

        SetNetVar("hostList", data)

        local target = player.GetBySteamID(steamid)
        local m_target = IsValid(target) and target:FullName() or steamid

        Arbitrage.adminnotify:SendNotify("removehost", client:FullName(), m_target)
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
        Arbitrage.adminnotify:SendNotify("monocommandc", client:FullName(), str)
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
    Arbitrage.adminnotify:SendNotify("setchapter", client:FullName(), chapter_id)
end)

netstream.Hook("arb.MonoAddRules", function(client, title, description, image)
    if !client:IsAdmin() then return end

    local data = Arbitrage.GetAcademyRules()
    table.insert(data, {image, title, description})

    SetNetVar("arb.Rules", data)
    netstream.Start(nil, "MonoPad:EditRulesNotify", #data)
    MonoPad:SendNotify(nil)

    Arbitrage.adminnotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoEditRules", function(client, title, description, image, id)
    if !client:IsAdmin() then return end

    local data = Arbitrage.GetAcademyRules()
    if !data[id] then return end

    data[id] = {image, title, description}

    SetNetVar("arb.Rules", data)
    netstream.Start(nil, "MonoPad:EditRulesNotify", id)
    MonoPad:SendNotify(nil)

    Arbitrage.adminnotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoRemoveRules", function(client, id)
    if !client:IsAdmin() then return end

    local data = Arbitrage.GetAcademyRules()
    table.remove(data, id)

    SetNetVar("arb.Rules", data)

    Arbitrage.adminnotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoDefaultRules", function(client)
    if !client:IsAdmin() then return end

    SetNetVar("arb.Rules", nil)
    netstream.Start(nil, "MonoPad:EditRulesNotify", nil)
    MonoPad:SendNotify(nil)

    Arbitrage.adminnotify:SendNotify("changecharter", client:FullName())
end)

netstream.Hook("arb.MonoAddGameLog", function(client, array)
    if !client:IsAdmin() then return end

    local a, b, c, d, e = array[1], array[2], array[3], array[4], array[5]
    e = e or Arbitrage.ReturnTime()

    local data = Arbitrage.GetGameLogs()
    table.insert(data, {a, b, c, d, e})

    SetNetVar("arb.GameLogs", data)
    netstream.Start(nil, "MonoPad:EditGameLogNotify")
    MonoPad:SendNotify(nil)
end)

netstream.Hook("arb.MonoEditGameLog", function(client, array)
    if !client:IsAdmin() then return end

    local a, b, c, d, e, f = array[1], array[2], array[3], array[4], array[5], array[6]
    e = e or Arbitrage.ReturnTime()

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

    for k, v in ipairs(player.GetAll()) do
        asterionlib.netgui:Create(v, "arb.SplashScreen", nil, "SetData", el)
    end

    Arbitrage.adminnotify:SendNotify("startsplashscreen", client:FullName())

    timer.Simple(23, function()
        ScriptMusic:ChangeTheme("none", true)
    end)
end)

netstream.Hook("arb.MonoEndGame", function(client, title, attackerID, targetID)
    if !client:IsAdmin() then return end

    local factionAttacker = Character.team:GetByID(attackerID)
    if !factionAttacker then return end

    local factionTarget = Character.team:GetByID(targetID)
    if !factionTarget then return end

    for k, v in ipairs(player.GetAll()) do
        asterionlib.netgui:Create(v, "arb.MonoEndGame", nil, "SetData", title, attackerID, targetID)
    end

    Arbitrage.adminnotify:SendNotify("startendgame", client:FullName())
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