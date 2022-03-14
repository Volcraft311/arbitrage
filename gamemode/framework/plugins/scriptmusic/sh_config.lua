--[[
        © Asterion Project 2022.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

PLUGIN:AddEvent("freetime_day", {
    name = "Дневная музыка (свободное время)",
    volume = 30
})

PLUGIN:AddEvent("freetime_night", {
    name = "Ночная музыка (свободное время)",
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

PLUGIN:AddEvent("other", {
    name = "Разное",
    volume = 30
})