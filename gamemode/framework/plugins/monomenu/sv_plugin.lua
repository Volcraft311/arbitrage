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

function PLUGIN:OpenMonoMenu(client)
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
                place = v:GetNetVar("arbLaw", -1),
                steamid = steamid,
                steamname = v:SteamName(),
                alive = v:Alive()
            }
        end
    end

    netstream.Start(client, "arb.OpenMonoMenu", data)
end

function PLUGIN:OpenMonoWhiteList(client)
    local data = self:GetData()

    netstream.Start(client, "arb.OpenMonoWhiteList", data)
end

local function CheckVoting(players, data)
    if #players <= 0 then return true end -- прерываем голосование т.к. нету участников

    local sendData = {}
    local num_voting = table.Count(data)

    if num_voting >= #players then
        for k, v in pairs(data) do
            sendData[v] = sendData[v] or 0
            sendData[v] = sendData[v] + 1
        end

        return true, sendData
    end

    return false
end

function PLUGIN:StartVoting()
    ScriptMusic:ChangeTheme("voting", true)

    self.votingData = {}

    local showingList = {}

    local data = {}
    for k, v in pairs(Arbitrage.players) do
        if !IsMonoKum(v.faction) then
            data[#data + 1] = {
                v.steamid,
                v.faction,
                v.alive
            }

            local client = player.GetBySteamID(v.steamid)
            if IsValid(client) and v.alive then
                showingList[#showingList + 1] = client
            end
        end
    end

    for k, v in pairs(Arbitrage.players) do
        if !IsMonoKum(v.faction) then
            local client = player.GetBySteamID(v.steamid)

            if IsValid(client) and v.alive then
                netstream.Start(client, "arb.OpenVotingScreen", data)
            end
        end
    end

    local time = RealTime() + 60

    timer.Create("arb.CheckVotes", 1, 0, function()
        local isAllVoting, votingList = CheckVoting(showingList, self.votingData)

        if RealTime() >= time or isAllVoting then
            timer.Remove("arb.CheckVotes")

            local newData = {}
            local faction -- = -1

            if votingList and table.Count(votingList) >= 1 then
                for k, v in pairs(votingList) do newData[#newData + 1] = {k, v} end

                table.sort(newData, function(a, b) return a[2] > b[2] end)

                local winning = newData[1] and newData[1][1] or ""
                local clientData = Arbitrage.players[winning]

                if clientData then
                    faction = clientData.faction
                end
            end

            for k, v in pairs(showingList) do
                if !IsValid(v) then continue end

                netstream.Start(v, "arb.EndVoting", faction)
            end

            local str = "Информация о голосовании: \n"
            for k, v in ipairs(newData) do
                local steamid = v[1]
                local num = v[2]

                local client = player.GetBySteamID(steamid)
                local info = (client and client:Name() or "НЕИЗВЕСТНО") .. "(" .. steamid .. ")"

                str = str .. info .. ". Количество голосов:  " .. num .. "\n"
            end

            for k, v in ipairs(player.GetAll()) do
                if !v:IsAdmin() then continue end

                netstream.Start(v, "arb.SendMessage", str)
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

function PLUGIN:CheckPassword(steamID64)
    local steamid = util.SteamIDFrom64(steamID64)
    local data = self:GetData()

    if data.settings then return true end
    if self.WhiteListStandart[steamid] then return true end
    data.players = data.players or {}

    return data.players[steamid] and true or false, "У вас нет доступа к серверу! Если вы записаны на игру, то обратитесь в тех. поддержку нашего сервера.\n\nНаш дискорд: https://discord.gg/Kqyn2uKrej"
end

netstream.Hook("arb.OpenMonoMenu", function(client)
    if !client:IsAdmin() then return end

    PLUGIN:OpenMonoMenu(client)
end)

netstream.Hook("arb.MonoRunCommand", function(client, target, category_id, button_id)
    if !client:IsAdmin() then return end

    local data = PLUGIN.ActionData[category_id] and (PLUGIN.ActionData[category_id][button_id] and PLUGIN.ActionData[category_id][button_id])
    if !data then return end

    if data.onCreate then
        local bState = data.onCreate(target)

        if !bState then return end
    end

    if data.onRun then
        local bState = data.onRun(target)
        if bState == false then return end

        timer.Simple(0.2, function()
            PLUGIN:OpenMonoMenu(client)
        end)

        if !IsValid(target.client) then return end
        Arbitrage.adminnotify:SendNotify("monocommand", client:Name() .. " (" .. client:SteamName() .. ")", data.data, target.client:Name() .. " (" .. target.client:SteamName() .. ")")
    end
end)

netstream.Hook("arb.MonoSetTeam", function(client, target, faction, bRespawn)
    if !client:IsAdmin() then return end

    local factionData = Arbitrage.teams.Get(faction)
    if !factionData then return end

    local data = Arbitrage.players[target.client:SteamID()]
    if data then
        data.faction = faction
    end

    if !IsValid(target.client) then return end
    Arbitrage.player.SetTeam(target.client, faction, bRespawn)

    timer.Simple(0.2, function()
        PLUGIN:OpenMonoMenu(client)
    end)


    Arbitrage.adminnotify:SendNotify("transfercharacter", client:Name() .. " (" .. client:SteamName() .. ")", target.client:Name() .. " (" .. target.client:SteamName() .. ")", faction)
end)

netstream.Hook("arb.MonoSetStats", function(client, target, data, amount)
    if !client:IsAdmin() then return end
    if !IsValid(target.client) then return end

    amount = math.Clamp(tonumber(amount), 0, 1000)

    if data == "health" then
        target.client:SetHealth(amount)
    elseif data == "armor" then
        target.client:SetArmor(amount)
    elseif data == "hunger" then
        Arbitrage.statistics.Set(target.client, "Hunger", amount)
    elseif data == "thirst" then
        Arbitrage.statistics.Set(target.client, "Thirst", amount)
    elseif data == "sleep" then
        Arbitrage.statistics.Set(target.client, "Sleep", amount)
    else
        return
    end

    timer.Simple(0.2, function()
        PLUGIN:OpenMonoMenu(client)
    end)

    Arbitrage.adminnotify:SendNotify("setstats", client:Name() .. " (" .. client:SteamName() .. ")", data, target.client:Name() .. " (" .. target.client:SteamName() .. ")", amount)
end)

netstream.Hook("arb.MonoSetPlace", function(client, steamid, place)
    if !client:IsAdmin() then return end

    place = math.Clamp(tonumber(place), -1, #Arbitrage.law.placesList[game.GetMap()])

    if Arbitrage.players[steamid] then
        Arbitrage.players[steamid].place = place
    end

    local target = player.GetBySteamID(steamid)
    if IsValid(target) then
        target:SetNetVar("arbLaw", place, target)
    end

    timer.Simple(0.2, function()
        PLUGIN:OpenMonoMenu(client)
    end)

    Arbitrage.adminnotify:SendNotify("setplace", client:Name() .. " (" .. client:SteamName() .. ")", place, target and (target:Name() .. " (" .. target:SteamName() .. ")") or steamid)
end)

netstream.Hook("arb.MonoGiveWeapon", function(client, target, weapon_id)
    if !client:IsAdmin() then return end

    if IsValid(target.client) then
        target.client:Give(weapon_id)

        timer.Simple(0.2, function()
            PLUGIN:OpenMonoMenu(client)
        end)
        Arbitrage.adminnotify:SendNotify("giveweapon", client:Name() .. " (" .. client:SteamName() .. ")", target.client:Name() .. " (" .. target.client:SteamName() .. ")", weapon_id)
    end
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

    if data.onRun then
        local bState = data.onRun(client)
        if bState == false then return end

        timer.Simple(0.2, function()
            PLUGIN:OpenMonoMenu(client)
        end)

        Arbitrage.adminnotify:SendNotify("monocommandc", client:Name() .. " (" .. client:SteamName() .. ")", data.data)
    end
end)

netstream.Hook("arb.MonoSetChapter", function(client, chapter_id)
    if !client:IsAdmin() then return end

    chapter_id = math.Clamp(chapter_id, 0, 9)

    SetNetVar("arb.Chapter", chapter_id)
    Arbitrage.adminnotify:SendNotify("setchapter", client:Name() .. " (" .. client:SteamName() .. ")", chapter_id)

    for k, v in pairs(player.GetAll()) do
        v:SyncVars()
    end
end)

netstream.Hook("arb.MonoRemoveWhiteList", function(client, id)
    if !client:IsAdmin() then return end

    local data = PLUGIN:GetData()
    data.players = data.players or {}
    data.settings = data.settings or false

    if data.players[id] then
        Arbitrage.adminnotify:SendNotify("removewhitelist", client:Name() .. " (" .. client:SteamName() .. ")", id)

        data.players[id] = nil

        PLUGIN:SetData(data)
        PLUGIN:OpenMonoWhiteList(client)
    end
end)

netstream.Hook("arb.MonoAddWhiteList", function(client, steamid, description)
    if !client:IsAdmin() then return end
    if !string.find(steamid, "STEAM_(%d+):(%d+):(%d+)") then return end

    local data = PLUGIN:GetData()
    data.players = data.players or {}
    data.settings = data.settings or false

    if data.players[steamid] then return end

    data.players[steamid] = description

    PLUGIN:SetData(data)
    PLUGIN:OpenMonoWhiteList(client)

    Arbitrage.adminnotify:SendNotify("addwhitelist", client:Name() .. " (" .. client:SteamName() .. ")", steamid)
end)

concommand.Add("whitelist_add", function(client, cmd, args)
    if IsValid(client) then return end

    local steamid = util.SteamIDFrom64(args[1])
    local description = args[2]

    if !string.find(steamid, "STEAM_(%d+):(%d+):(%d+)") then return end

    local data = PLUGIN:GetData()
    data.players = data.players or {}
    data.settings = data.settings or false

    if data.players[steamid] then return end

    data.players[steamid] = description

    PLUGIN:SetData(data)
    print("Add " .. steamid)
end)

netstream.Hook("arb.MonoSetSettings", function(client, bData)
    if !client:IsAdmin() then return end

    local data = PLUGIN:GetData()
    data.settings = bData

    PLUGIN:SetData(data)
    PLUGIN:OpenMonoWhiteList(client)

    Arbitrage.adminnotify:SendNotify("settingswhitelist", client:Name() .. " (" .. client:SteamName() .. ")", bData)
end)

netstream.Hook("arb.MonoSetCharter", function(client, data)
    if !client:IsAdmin() then return end

    SetNetVar("arb.Charter", data)
    for k, v in pairs(player.GetAll()) do
        v:SyncVars()
    end
end)

netstream.Hook("arb.MonoSetModel", function(client, target, model)
    if !client:IsAdmin() then return end
    if !IsValid(target.client) then return end

    target.client:SetModel(model)

    timer.Simple(0.2, function()
        PLUGIN:OpenMonoMenu(client)
    end)

    Arbitrage.adminnotify:SendNotify("setmodel", client:Name() .. " (" .. client:SteamName() .. ")", target.client:Name() .. " (" .. target.client:SteamName() .. ")", model)
end)

netstream.Hook("arb.MonoSplashScreen", function(client, data)
    if !client:IsAdmin() then return end

    local el = {{}, {}, data[1], data[2], data[3]}

    for k, v in pairs(Arbitrage.players) do
        if !IsMonoKum(v.faction) then
            el[1][#el[1] + 1] = {
                k,
                v.faction
            }

            if !v.alive then
                el[2][#el[2] + 1] = k
            end
        end
    end

    ScriptMusic:ChangeTheme("splashscreen", true)
    netstream.Start(nil, "arb.OpenSplashScreen", el)

    timer.Simple(23, function()
        ScriptMusic:ChangeTheme("none", true)
    end)
end)

netstream.Hook("arb.SendVote", function(client, data)
    if !client:InGame() then return end
    if !Arbitrage.players[data] then return end

    PLUGIN.votingData[client:SteamID()] = data
end)