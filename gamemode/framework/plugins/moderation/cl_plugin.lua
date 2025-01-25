--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Moderation.helpTargets = Moderation.helpTargets or {}

local color_green = Color(86, 253, 9)
local color_red = Color(245, 35, 35)
local color_white = Color(255, 255, 255)

netstream.Hook("Moderation:Log", function(uniqueID, info)
    info = info:gsub("%(<https://steamcommunity.com/profiles/%d+>%),?", "")

    MsgC(color_green, "[Moderation]", color_red, " [" .. uniqueID .. "]", color_white, " " .. info .. "\n")
end)

RegisterCommand("goto", "Телепортироваться к игроку.", {"player"})
RegisterCommand("bring", "Телепортировать игрока к себе.", {"player"})
RegisterCommand("tp", "Телепортировать игрока туда куда вы смотрите.", {"player"})
RegisterCommand("pm", "Написать пользователю в личные сообщения.", {"player", "text"})
RegisterCommand("return", "Вернуть игрока на прошлую точку до телепортации.", {"player"})

for _, command in ipairs({"unanonymous", "unincognito", "returnrank", "rr"}) do
    RegisterCommand(command, "Вернуть себе права равные статическому рангу.", {})
end

for _, command in ipairs({"anonymous", "incognito", "takerank", "tr"}) do
    RegisterCommand(command, "Временно снять с себя привилегии статического ранга.", {})
end

for _, command in ipairs({"a", "admin"}) do
    RegisterCommand(command, "Отправить сообщение в чат администрации", {"text"})
end

for _, command in ipairs({"help", "report"}) do
    RegisterCommand(command, "Обратиться за помощью к администрации.", {"text"})
end

for _, command in ipairs({"hp", "health"}) do
    RegisterCommand(command, "Выдать указанному пользователю здоровье.", {"player", "number"})
end

for _, command in ipairs({"ar", "armor"}) do
    RegisterCommand(command, "Выдать указанному пользователю броню.", {"player", "number"})
end

RegisterCommand("hunger", "Установить голод указанному пользователю.", {"player", "number"})
RegisterCommand("thirst", "Установить жажду указанному пользователю.", {"player", "number"})
RegisterCommand("sleep", "Установить сон указанному пользователю.", {"player", "number"})
RegisterCommand("cleardecals", "Очистить всем игрока декали.", {})

RegisterCommand("freezeprops", "Заморозить все физические пропы.")

for _, command in ipairs({"unignite", "unfire", "extinguish"}) do
    RegisterCommand(command, "Потушить указанного пользователя.", {"player"})
end

for _, command in ipairs({"ignite", "fire"}) do
    RegisterCommand(command, "Поджечь указанного пользователя.", {"player"}, {"number"})
end

for _, command in ipairs({"kill", "slay"}) do
    RegisterCommand(command, "Убить указанного пользователя.", {"player"})
end

RegisterCommand("slap", "Пнуть указанного пользователя.", {"player"})

for _, command in ipairs({"map", "changemap", "changelevel"}) do
    RegisterCommand(command, "Сменить карту на указанную.", {"string"})
end

for _, command in ipairs({"getmaps", "maps"}) do
    RegisterCommand(command, "Получить список имеющихся карт на сервере.", {})
end

RegisterCommand("kick", "Кикнуть указанного пользователя с сервера.", {"player", "text"})

RegisterCommand("runconsolecommand", "Выполнить консольную команду на стороне сервера.", {"text"})

RegisterCommand("reset", "Сбросить все характеристики игроку.", {"player"})
RegisterCommand("respawn", "Возродить/Пересоздать игрока.", {"player"})
RegisterCommand("model", "Изменить модель игроку на указанную.", {"player", "string"})
RegisterCommand("guard", "Выдать права администрирования указанному игроку.", {"player", "string"})
RegisterCommand("unguard", "Забрать права администратора указанного игрока.", {"player"})

RegisterCommand("restartserver", "Перезапустить сервер через указанное время.", {"number"})
RegisterCommand("unrestartserver", "Отменить перезапуск сервера.")

RegisterCommand("freeze", "Заморозить указанного пользователя.", {"player"})
RegisterCommand("unfreeze", "Разморозить указанного пользователя.", {"player"})

for _, command in ipairs({"strip", "strips", "stripweapons", "stripsweapons"}) do
    RegisterCommand(command, "Забрать оружие у указанного пользователя.", {"player"})
end

RegisterCommand("removesoundscape", "Удалить все объекты связанные со звуком на карте.")


function Moderation:HUDPaint()
    local client = LocalPlayer()
    if !client:IsAdmin() then return end

    local curTime = CurTime()

    for steamID, data in pairs(Moderation.helpTargets) do
        if data.endTime > curTime then
            if !IsValid(data.target) then
                data.target = player.GetBySteamID(steamID)
            end

            local progress = (curTime - data.startTime) / (data.endTime - data.startTime)
            if progress > 1 then progress = 1 end

            local r = progress * 255
            local g = 255 - (progress * 255)
            local b = 0

            outline.Add({data.target}, Color(r, g, b), 0)
        else
            Moderation.helpTargets[steamID] = nil
        end
    end
end


netstream.Hook("Moderation:HelpTarget", function(steamID)
    Moderation.helpTargets[steamID] = {
        target = nil,
        startTime = CurTime(),
        endTime = CurTime() + 60
    }
end)