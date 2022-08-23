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

local function compactDir(array)
    local data = {}

    for _, value in ipairs(array) do
        local id = tonumber(value)

        if id then
            data[id] = true
        end
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


--[[
    HOOKS
]]--
function PLUGIN:PlayerInitialSpawnForRealz(client)
    local data = self:GetList()

    netstream.Start(client, "Workshop:List", data)
end

function PLUGIN:InitPostEntity()
    local info = asterionlib.data:Get("workshop", {}, true)
    local _, directories = file.Find("addons/*", "GAME")

    local dirList = compactDir(directories)
    for id, author in pairs(info) do
        id = tonumber(id)

        if dirList[id] then
            resource.AddWorkshop(tostring(id))
        end
    end
end


--[[
    NETSTREAMS
]]--
netstream.Hook("Workshop:Add", function(client, id)
    id = tonumber(id)

    if !client:IsAdmin() then return end
    if !isnumber(id) then return end

    local data = asterionlib.data:Get("workshop", {}, true)

    if data[id] then
        return Arbitrage.commands.Notify(client, "Это дополнение уже находится в списке! (" .. id .. ")")
    end

    data[id] = client:SteamName() .. " (" .. client:SteamID() .. ")"
    asterionlib.data:Set("workshop", data)

    PLUGIN:OpenMenu(client)

    Arbitrage.commands.Notify(client, "Ваше дополнение было добавлено на проверку! (" .. id .. ")")
end)

netstream.Hook("Workshop:Remove", function(client, id)
    id = tonumber(id)

    if !client:IsSuperAdmin() then return end
    if !isnumber(id) then return end

    local data = asterionlib.data:Get("workshop", {}, true)
    if !data[id] then return end

    data[id] = nil
    asterionlib.data:Set("workshop", data)

    PLUGIN:Delete(id)
    PLUGIN:OpenMenu(client)

    Arbitrage.commands.Notify(client, "Вы успешно удалили " .. id .. " из дополнений!")
end)

netstream.Hook("Workshop:Install", function(client, id)
    id = tonumber(id)

    if !client:IsSuperAdmin() then return end
    if !isnumber(id) then return end

    local data = asterionlib.data:Get("workshop", {}, true)
    if !data[id] then return end

    PLUGIN:Install(id)
    PLUGIN:OpenMenu(client)

    netstream.Start(nil, "Workshop:Install", tostring(id))
    resource.AddWorkshop(tostring(id))

    Arbitrage.commands.Notify(client, "Дополнение " .. id .. " было добавлено на сервер! Установка может занять достаточно много времени (от 10 секунд до 5 минут), по этому обновится в категории не сразу.")
end)