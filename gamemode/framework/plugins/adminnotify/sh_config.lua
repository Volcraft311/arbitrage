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

PLUGIN.guiTime = 30

PLUGIN.groupAccess = {
    ["owner"] = true,
    ["founder"] = true,
    ["superadmin"] = true,
    ["admin"] = true,
    ["senior_administrator"] = true,
    ["regular_administrator"] = true,
    ["junior_administrator"] = true,
    ["gamemaster"] = true,
    ["game_master"] = true,
    ["guard"] = true
}

PLUGIN:AddNewNotify("killed", function(client, target, weapon)
    return Color(223, 66, 66), client, color_white, " убил игрока ", Color(74, 114, 202), target, color_white, weapon and (" при помощи " .. weapon) or ""
end)

PLUGIN:AddNewNotify("joincharacter", function(clientSt, character)
    return Color(74, 114, 202), clientSt, color_white, " зашел за персонажа ", Color(216, 204, 34), character
end)

PLUGIN:AddNewNotify("spawn", function(client)
    return Color(74, 114, 202), client, color_white, " возродился"
end)

PLUGIN:AddNewNotify("join", function(client)
    return Color(50, 211, 77), client, color_white, " подключился к серверу"
end)

PLUGIN:AddNewNotify("connect", function(name, steamid)
    return Color(211, 147, 50), name .. "(" .. steamid .. ")", color_white, " начал подключаться к серверу"
end)

PLUGIN:AddNewNotify("disconnect", function(client)
    return Color(202, 74, 74), client, color_white, " отключился от сервера"
end)

PLUGIN:AddNewNotify("transfercharacter", function(client, target, faction)
    local factionData = Character.team:GetByID(faction)

    return Color(63, 162, 184), client, color_white, " перенес игрока ", Color(197, 181, 60), target, color_white, " во фракцию ", Color(48, 218, 187), factionData.name .. " (" .. faction .. ")"
end)

PLUGIN:AddNewNotify("monocommand", function(client, command, target)
    return Color(63, 162, 184), client, color_white, " выполнил команду ", Color(48, 218, 187), command, color_white, " на игроке ", Color(197, 181, 60), target
end)

PLUGIN:AddNewNotify("monocommandc", function(client, command, target)
    return Color(63, 162, 184), client, color_white, " выполнил команду ", Color(48, 218, 187), command
end)

PLUGIN:AddNewNotify("setstats", function(client, data, target, amount)
    return Color(63, 162, 184), client, color_white, " установил ", Color(48, 218, 187), data, color_white, " игроку ", Color(197, 181, 60), target, color_white, " на ", Color(48, 218, 187), amount
end)

PLUGIN:AddNewNotify("setspeed", function(client, data, target, speed)
    return Color(63, 162, 184), client, color_white, " изменил скорость ", Color(48, 218, 187), data, color_white, " игроку ", Color(197, 181, 60), target, color_white, " на ", Color(48, 218, 187), speed or 1
end)

PLUGIN:AddNewNotify("setplace", function(client, data, target)
    return Color(63, 162, 184), client, color_white, " установил место в суде игроку ", Color(197, 181, 60), target, color_white, " на ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("giveweapon", function(client, target, data)
    return Color(63, 162, 184), client, color_white, " выдал игроку ", Color(197, 181, 60), target, color_white, " оружие ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("setfakename", function(client, target, data)
    return Color(63, 162, 184), client, color_white, " изменил имя игроку ", Color(197, 181, 60), target, color_white, " на ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("setchapter", function(client, data)
    return Color(63, 162, 184), client, color_white, " установил главу ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("removewhitelist", function(client, data)
    return Color(63, 162, 184), client, color_white, " удалил из WhiteList-а ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("addwhitelist", function(client, data)
    return Color(63, 162, 184), client, color_white, " добавил в WhiteList ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("settingswhitelist", function(client, data)
    return Color(63, 162, 184), client, color_white, " сделал сервер ", Color(48, 218, 187), data and "Общедоступным" or "Приватным"
end)

PLUGIN:AddNewNotify("setmodel", function(client, target, data)
    return Color(63, 162, 184), client, color_white, " изменил игроку ", Color(197, 181, 60), target, color_white, " модель на ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("changecolormodify", function(client, key, data)
    return Color(63, 162, 184), client, color_white, " изменил значение цветокоррекции ", Color(197, 181, 60), key, color_white, " на ", Color(48, 218, 187), data
end)

PLUGIN:AddNewNotify("standartcolormodify", function(client)
    return Color(63, 162, 184), client, color_white, " вернул стандартную цветокоррекцию"
end)

PLUGIN:AddNewNotify("resetstats", function(client, target)
    return Color(63, 162, 184), client, color_white, " обнулил характеристики игроку ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("changestatus", function(client, target, state)
    return Color(63, 162, 184), client, color_white, " изменил игровой статус игроку ", Color(197, 181, 60), target, color_white, " на ", Color(48, 218, 187), state
end)

PLUGIN:AddNewNotify("returngame", function(client, target)
    return Color(63, 162, 184), client, color_white, " вернул в игру игрока ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("removegame", function(client, target)
    return Color(63, 162, 184), client, color_white, " убрал из игры игрока ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("addgame", function(client, target)
    return Color(63, 162, 184), client, color_white, " добавил в игру игрока ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("claerinventory", function(client, target)
    return Color(63, 162, 184), client, color_white, " очистил инвентарь игроку ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("openinventory", function(client, target)
    return Color(63, 162, 184), client, color_white, " открыл инвентарь игрока ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("addhost", function(client, target)
    return Color(63, 162, 184), client, color_white, " сделал ведущим игрока ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("removehost", function(client, target)
    return Color(63, 162, 184), client, color_white, " убрал из ведущих игрока ", Color(48, 218, 187), target
end)

PLUGIN:AddNewNotify("registeritem", function(client, uniqueID)
    return Color(63, 162, 184), client, color_white, " создал предмет с ID ", Color(48, 218, 187), uniqueID
end)

PLUGIN:AddNewNotify("edititem", function(client, uniqueID)
    return Color(63, 162, 184), client, color_white, " изменил предмет с ID ", Color(48, 218, 187), uniqueID
end)

PLUGIN:AddNewNotify("removeitem", function(client, uniqueID)
    return Color(63, 162, 184), client, color_white, " удалил предмет с ID ", Color(48, 218, 187), uniqueID
end)

PLUGIN:AddNewNotify("protectitem", function(client, uniqueID)
    return Color(63, 162, 184), client, color_white, " снял/установил защиту на предмет с ID ", Color(48, 218, 187), uniqueID
end)

PLUGIN:AddNewNotify("changecharter", function(client)
    return Color(63, 162, 184), client, color_white, " изменил устав академии"
end)

PLUGIN:AddNewNotify("startsplashscreen", function(client)
    return Color(63, 162, 184), client, color_white, " запустил заставку (глава)"
end)

PLUGIN:AddNewNotify("startendgame", function(client)
    return Color(63, 162, 184), client, color_white, " запустил заставку (endgame)"
end)