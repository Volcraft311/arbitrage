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
PLUGIN.guiTime = 30

local client_color = Color(63, 162, 184)
local danger_color = Color(223, 66, 66)
local info_color = Color(197, 181, 60)
local info2_color = Color(48, 218, 187)

PLUGIN:AddNewNotify("killed", function(client, target, weapon)
    return danger_color, client, color_white, " убил игрока ", client_color, target, color_white, weapon and (" при помощи " .. weapon) or ""
end)

PLUGIN:AddNewNotify("joincharacter", function(clientSt, character)
    return client_color, clientSt, color_white, " зашел за персонажа ", info_color, character
end)

PLUGIN:AddNewNotify("spawn", function(client)
    return client_color, client, color_white, " возродился"
end)

PLUGIN:AddNewNotify("join", function(client)
    return Color(50, 211, 77), client, color_white, " подключился к серверу"
end)

PLUGIN:AddNewNotify("connect", function(name, steamid)
    return Color(211, 147, 50), name .. "(" .. steamid .. ")", color_white, " начал подключаться к серверу"
end)

PLUGIN:AddNewNotify("disconnect", function(client)
    return danger_color, client, color_white, " отключился от сервера"
end)

PLUGIN:AddNewNotify("transfercharacter", function(client, target, faction)
    local character = Character.team:GetByID(faction)

    return client_color, client, color_white, " перенес игрока ", info_color, target, color_white, " во фракцию ", info2_color, character.name .. " (" .. faction .. ")"
end)

PLUGIN:AddNewNotify("monocommand", function(client, command, target)
    return client_color, client, color_white, " выполнил команду ", info2_color, command, color_white, " на игроке ", info_color, target
end)

PLUGIN:AddNewNotify("monocommandc", function(client, command, target)
    return client_color, client, color_white, " выполнил команду ", info2_color, command
end)

PLUGIN:AddNewNotify("setstats", function(client, data, target, amount)
    return client_color, client, color_white, " установил ", info2_color, data, color_white, " игроку ", info_color, target, color_white, " на ", info2_color, amount
end)

PLUGIN:AddNewNotify("setspeed", function(client, data, target, speed)
    return client_color, client, color_white, " изменил скорость ", info2_color, data, color_white, " игроку ", info_color, target, color_white, " на ", info2_color, speed or 1
end)

PLUGIN:AddNewNotify("setplace", function(client, data, target)
    return client_color, client, color_white, " установил место в суде игроку ", info_color, target, color_white, " на ", info2_color, data
end)

PLUGIN:AddNewNotify("giveweapon", function(client, target, data)
    return client_color, client, color_white, " выдал игроку ", info_color, target, color_white, " оружие ", info2_color, data
end)

PLUGIN:AddNewNotify("setfakename", function(client, target, data)
    return client_color, client, color_white, " изменил имя игроку ", info_color, target, color_white, " на ", info2_color, data
end)

PLUGIN:AddNewNotify("setchapter", function(client, data)
    return client_color, client, color_white, " установил главу ", info2_color, data
end)

PLUGIN:AddNewNotify("removewhitelist", function(client, data)
    return client_color, client, color_white, " удалил из WhiteList-а ", info_color, data
end)

PLUGIN:AddNewNotify("addwhitelist", function(client, data)
    return client_color, client, color_white, " добавил в WhiteList ", info_color, data
end)

PLUGIN:AddNewNotify("settingswhitelist", function(client, data)
    return client_color, client, color_white, " сделал сервер ", info2_color, data and "Общедоступным" or "Приватным"
end)

PLUGIN:AddNewNotify("setmodel", function(client, target, data)
    return client_color, client, color_white, " изменил игроку ", info_color, target, color_white, " модель на ", info2_color, data
end)

PLUGIN:AddNewNotify("changecolormodify", function(client, key, data)
    return client_color, client, color_white, " изменил значение цветокоррекции ", info_color, key, color_white, " на ", info2_color, data
end)

PLUGIN:AddNewNotify("standartcolormodify", function(client)
    return client_color, client, color_white, " вернул стандартную цветокоррекцию"
end)

PLUGIN:AddNewNotify("resetstats", function(client, target)
    return client_color, client, color_white, " обнулил характеристики игроку ", info_color, target
end)

PLUGIN:AddNewNotify("changestatus", function(client, target, state)
    return client_color, client, color_white, " изменил игровой статус игроку ", info_color, target, color_white, " на ", info2_color, state
end)

PLUGIN:AddNewNotify("returngame", function(client, target)
    return client_color, client, color_white, " вернул в игру игрока ", info_color, target
end)

PLUGIN:AddNewNotify("removegame", function(client, target)
    return client_color, client, color_white, " убрал из игры игрока ", info_color, target
end)

PLUGIN:AddNewNotify("addgame", function(client, target)
    return client_color, client, color_white, " добавил в игру игрока ", info_color, target
end)

PLUGIN:AddNewNotify("claerinventory", function(client, target)
    return client_color, client, color_white, " очистил инвентарь игроку ", info_color, target
end)

PLUGIN:AddNewNotify("openinventory", function(client, target)
    return client_color, client, color_white, " открыл инвентарь игрока ", info_color, target
end)

PLUGIN:AddNewNotify("scaleinventory", function(client, target, x, y)
    return client_color, client, color_white, " изменил размер инвентаря игрока ", info_color, target, color_white, " на ", info2_color, x, color_white, " и ", info2_color, y
end)

PLUGIN:AddNewNotify("globalvoice", function(client, target, value)
    return client_color, client, color_white, info2_color, value and " включил" or " выключил", color_white, " глобальный голосовой чат игроку ", info_color, target
end)

PLUGIN:AddNewNotify("mutevoice", function(client, target, value)
    return client_color, client, color_white, info2_color, value and " выключил" or " включил", color_white, " голосовой чат игроку ", info_color, target
end)

PLUGIN:AddNewNotify("mutenonrpchat", function(client, target, value)
    return client_color, client, color_white, info2_color, value and " запретил" or " разрешил", color_white, " писать в NonRP чат игроку ", info_color, target
end)

PLUGIN:AddNewNotify("addhost", function(client, target)
    return client_color, client, color_white, " сделал ведущим игрока ", info_color, target
end)

PLUGIN:AddNewNotify("removehost", function(client, target)
    return client_color, client, color_white, " убрал из ведущих игрока ", info_color, target
end)

PLUGIN:AddNewNotify("setdescription", function(client, target)
    return client_color, client, color_white, " изменил обычное описание игроку ", info_color, target
end)

PLUGIN:AddNewNotify("setforceddescription", function(client, target)
    return client_color, client, color_white, " изменил принудительное описание игроку ", info_color, target
end)

PLUGIN:AddNewNotify("registeritem", function(client, uniqueID)
    return client_color, client, color_white, " создал предмет с ID ", info2_color, uniqueID
end)

PLUGIN:AddNewNotify("edititem", function(client, uniqueID)
    return client_color, client, color_white, " изменил предмет с ID ", info2_color, uniqueID
end)

PLUGIN:AddNewNotify("removeitem", function(client, uniqueID)
    return client_color, client, color_white, " удалил предмет с ID ", info2_color, uniqueID
end)

PLUGIN:AddNewNotify("protectitem", function(client, uniqueID)
    return client_color, client, color_white, " снял/установил защиту на предмет с ID ", info2_color, uniqueID
end)

PLUGIN:AddNewNotify("changecharter", function(client)
    return client_color, client, color_white, " изменил устав академии"
end)

PLUGIN:AddNewNotify("startsplashscreen", function(client)
    return client_color, client, color_white, " запустил заставку (глава)"
end)

PLUGIN:AddNewNotify("startendgame", function(client)
    return client_color, client, color_white, " запустил заставку (endgame)"
end)

PLUGIN:AddNewNotify("setfallover", function(client, target, delay)
    return client_color, client, color_white, " опрокинул игрока ", info_color, target, color_white, " на ", info2_color, delay or 1, color_white, " секунд"
end)

PLUGIN:AddNewNotify("setstandup", function(client, target, delay)
    return client_color, client, color_white, " поднял игрока ", info_color, target
end)

PLUGIN:AddNewNotify("addstatuseffect", function(client, target, uniqueID, delay)
    return client_color, client, color_white, " выдал статус эффект ", info2_color, uniqueID, color_white, " игроку ", info_color, target, color_white, " на ", info2_color, delay
end)

PLUGIN:AddNewNotify("removestatuseffect", function(client, target, uniqueID)
    return client_color, client, color_white, " убрал статус эффект ", info2_color, uniqueID, color_white, " игроку ", info_color, target
end)

PLUGIN:AddNewNotify("clearstatuseffect", function(client, target)
    return client_color, client, color_white, " убрал все статус эффекты игроку ", info_color, target
end)

PLUGIN:AddNewNotify("setscale", function(client, target, delay)
    return client_color, client, color_white, " изменил размер модели игроку ", info_color, target, color_white, " на ", info2_color, delay
end)

PLUGIN:AddNewNotify("triggercreated", function(client, trigger)
    return client_color, client, color_white, " создал триггер ", info_color, trigger
end)

PLUGIN:AddNewNotify("triggerremoved", function(client, trigger)
    return client_color, client, color_white, " удалил триггер ", info_color, trigger
end)

PLUGIN:AddNewNotify("triggerchanged", function(client, name)
    return client_color, client, color_white, " изменил триггер ", info_color, name
end)

PLUGIN:AddNewNotify("triggerloadconfig", function(client)
    return client_color, client, color_white, " загрузил конфигурацию для триггеров"
end)

PLUGIN:AddNewNotify("triggerremoveall", function(client)
    return client_color, client, color_white, " удалил все триггеры"
end)

PLUGIN:AddNewNotify("triggerlistsreset", function(client)
    return client_color, client, color_white, " перезарядил триггер"
end)

