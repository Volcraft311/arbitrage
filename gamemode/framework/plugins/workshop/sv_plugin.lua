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
PLUGIN.requestList = PLUGIN.requestList or {}
PLUGIN.requestProcessed = PLUGIN.requestProcessed or false

local function compactDir(array)
    local data = {}

    for _, value in ipairs(array) do
        local id = tonumber(value)
        if !id then continue end

        data[id] = true
    end

    return data
end

local function installedAddons()
    local data = {}
    local info = asterionlib.data:Get("workshop", {}, true)
    local _, directories = file.Find("addons/*", "GAME")

    local dirList = compactDir(directories)
    for id, author in pairs(info) do
        id = tonumber(id)
        if !id then continue end
        if !dirList[id] then continue end

        data[#data + 1] = id
    end

    return data
end

local function getIP()
    return game.GetIPAddress():match("%d+%.%d+%.%d+%.%d+")
end


--[[
    METHODS
]]--
function PLUGIN:OpenMenu(client)
    if !client:IsAdmin() then return end

    local data = {{}, {}}
    local info = asterionlib.data:Get("workshop", {}, true)

    local _, directories = file.Find("addons/*", "GAME")

    local dirList = compactDir(directories)
    for id, author in pairs(info) do
        id = tonumber(id)

        local bInstall = dirList[id]
        local stored = bInstall and 2 or 1

        data[stored][id] = author
    end

    asterionlib.netgui:Create(client, "WORKSHOP:Menu", nil, "SetData", data)
end

function PLUGIN:GetList()
    local data = {}

    local info = asterionlib.data:Get("workshop", {}, true)
    for id in pairs(info) do
        data[#data + 1] = id
    end

    return data
end

local token = "686vki3arxqrut4u"
function PLUGIN:Install(id)
    id = tostring(id)

    local ip = getIP()
    asterionlib.Post("http://" .. ip .. "/api/downloader", {
        token = token,
        id = id,
        ip = ip
    })
end

function PLUGIN:Delete(id)
    id = tostring(id)

    local ip = getIP()
    asterionlib.Post("http://" .. ip .. "/api/remove", {
        token = token,
        id = id,
        ip = ip
    })
end

function PLUGIN:AddLog(type, array)
    netstream.Start(player.GetAdmins(), "WORKSHOP:AddLog", type, array)
end


--[[
    HOOKS
]]--
function PLUGIN:PlayerInitialSpawnForRealz(client)
    local data = installedAddons()

    netstream.Start(client, "Workshop:List", data)
end

function PLUGIN:InitPostEntity()
    local data = installedAddons()

    for k, v in ipairs(data) do
        resource.AddWorkshop(tostring(v))
    end
end


--[[
    NETSTREAMS
]]--
local function add(client, id)
    id = tonumber(id)
    if !id then return end

    local data = asterionlib.data:Get("workshop", {}, true)
    if data[id] then return end

    data[id] = client:SteamName() .. " (" .. client:SteamID() .. ")"
    asterionlib.data:Set("workshop", data)
end
netstream.Hook("Workshop:Add", function(client, id)
    if !client:IsAdmin() then return end

    local logInfo = ""
    if istable(id) then
        logInfo = logInfo .. "("

        for k, v in ipairs(id) do
            add(client, v)
            logInfo = logInfo .. v

            if k < #id then
                logInfo = logInfo .. ", "
            end
        end

        logInfo = logInfo .. ")"
    else
        add(client, id)
        logInfo = logInfo .. id
    end

    PLUGIN:AddLog("add", {client:FullName(true), logInfo})
    PLUGIN:OpenMenu(client)
end)

local function cancel(id)
    id = tonumber(id)
    if !id then return end

    local data = asterionlib.data:Get("workshop", {}, true)
    if !data[id] then return end

    data[id] = nil
    asterionlib.data:Set("workshop", data)
end
netstream.Hook("Workshop:Cancel", function(client, array)
    if !client:IsSuperAdmin() then return end

    local logInfo = "("
    local i = 1
    local count = table.Count(array)
    for id in pairs(array) do
        cancel(id)
        logInfo = logInfo .. id

        if i < count then
            logInfo = logInfo .. ", "
        end

        i = i + 1
    end

    logInfo = logInfo .. ")"

    PLUGIN:AddLog("cancel", {client:FullName(true), logInfo})
    PLUGIN:OpenMenu(client)
end)

local function remove(id)
    id = tonumber(id)
    if !id then return end

    local data = asterionlib.data:Get("workshop", {}, true)
    if !data[id] then return end

    table.insert(PLUGIN.requestList, {
        2,
        id
    })
end
netstream.Hook("Workshop:Remove", function(client, array)
    if !client:IsSuperAdmin() then return end

    local logInfo = "("
    local i = 1
    local count = table.Count(array)
    for id in pairs(array) do
        remove(id)
        logInfo = logInfo .. id

        if i < count then
            logInfo = logInfo .. ", "
        end

        i = i + 1
    end

    logInfo = logInfo .. ")"

    PLUGIN:AddLog("removeReq", {client:FullName(true), logInfo})
    PLUGIN:OpenMenu(client)

    netstream.Start(player.GetAdmins(), "WORKSHOP:RequestList", PLUGIN.requestList)
end)

local function install(id)
    id = tonumber(id)
    if !id then return end

    local data = asterionlib.data:Get("workshop", {}, true)
    if !data[id] then return end

    table.insert(PLUGIN.requestList, {
        1,
        id
    })

    netstream.Start(nil, "Workshop:Install", tostring(id))
    resource.AddWorkshop(tostring(id))
end
netstream.Hook("Workshop:Install", function(client, array)
    if !client:IsSuperAdmin() then return end

    local logInfo = "("
    local i = 1
    local count = table.Count(array)
    for id in pairs(array) do
        install(id)
        logInfo = logInfo .. id

        if i < count then
            logInfo = logInfo .. ", "
        end

        i = i + 1
    end

    logInfo = logInfo .. ")"

    PLUGIN:AddLog("installReq", {client:FullName(true), logInfo})
    PLUGIN:OpenMenu(client)

    netstream.Start(player.GetAdmins(), "WORKSHOP:RequestList", PLUGIN.requestList)
end)

netstream.Hook("WORKSHOP:GetStatus", function(client)
    if !client:IsAdmin() then return end

    local ip = getIP()
    asterionlib.Fetch("http://" .. ip .. "/api/ping", function(body)
        if body == "successfully" then
            netstream.Start(client, "WORKSHOP:SuccessfullyStatus", 1)
        end
    end)

    asterionlib.Fetch("http://" .. ip .. ":228/api/ping", function(body)
        netstream.Start(client, "WORKSHOP:SuccessfullyStatus", 2)
    end)
end)

local function skip()
    timer.Remove("WORKSHOP:Processed")

    table.remove(PLUGIN.requestList, 1)
    netstream.Start(player.GetAdmins(), "WORKSHOP:RequestList", PLUGIN.requestList)
end

local attempt = 0
local function findAddon(id)
    if attempt >= 10 then
        PLUGIN:AddLog("skip", {id})

        return skip()
    end

    local find = false
    local _, directories = file.Find("addons/*", "GAME")

    for k, v in ipairs(directories) do
        if !tonumber(v) then continue end

        if tonumber(v) == tonumber(id) then
            find = true
        end
    end

    attempt = attempt + 1
    PLUGIN:AddLog("search", {id, attempt})

    return find
end

timer.Create("WORKSHOP:UpdateRequest", 5, 0, function()
    local array = PLUGIN.requestList
    if #array <= 0 then return timer.Remove("WORKSHOP:Processed") end

    local info = array[1]
    if !info then return end

    if timer.Exists("WORKSHOP:Processed") then return end

    attempt = 0
    local type, id = info[1], info[2]
    if type == 1 then -- установка
        PLUGIN:AddLog("startInstall", {id})
        PLUGIN:Install(id)

        timer.Create("WORKSHOP:Processed", 10, 0, function()
            local find = findAddon(id)
            if find == nil then return end

            if find then
                PLUGIN:AddLog("intall", {id})
                skip()
            end
        end)
    elseif type == 2 then -- удаление
        PLUGIN:AddLog("startRemove", {id})
        PLUGIN:Delete(id)

        timer.Create("WORKSHOP:Processed", 15, 0, function()
            local find = findAddon(id)
            if find == nil then return end

            if !find then
                PLUGIN:AddLog("remove", {id})
                skip()

                local data = asterionlib.data:Get("workshop", {}, true)
                data[id] = nil
                asterionlib.data:Set("workshop", data)
            end
        end)
    end
end)