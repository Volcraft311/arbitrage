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

PLUGIN:AddEvent("freetime_day", {
    name = "Свободное время (дневное)",
    volume = 30
})

PLUGIN:AddEvent("freetime_night", {
    name = "Свободное время (ночное)",
    volume = 30
})

PLUGIN:AddEvent("investigation", {
    name = "Расследование",
    volume = 30
})

PLUGIN:AddEvent("law", {
    name = "Суд",
    volume = 30
})

PLUGIN:AddEvent("voting", {
    name = "Голосование",
    volume = 30
})

PLUGIN:AddEvent("execution", {
    name = "Казнь",
    volume = 30
})

PLUGIN:AddEvent("splashscreen", {
    name = "Заставка",
    volume = 30
})

PLUGIN:AddEvent("startgame", {
    name = "Начало игры",
    volume = 30
})

PLUGIN:AddEvent("endgame", {
    name = "Конец игры",
    volume = 30
})

PLUGIN:AddEvent("tension", {
    name = "Напряженность",
    volume = 30
})

PLUGIN:AddEvent("mystery", {
    name = "Загадка",
    volume = 30
})

PLUGIN:AddEvent("mono_lesson", {
    name = "Моно-урок",
    volume = 30
})

for i = 1, 5 do
    PLUGIN:AddEvent("other_" .. i, {
        name = "Разное " .. i,
        volume = 30
    })
end