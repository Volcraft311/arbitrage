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
ColorModify = PLUGIN

PLUGIN.colorMod = {
    brightness = 0,
    contrast = 1,
    enabled = false,
    color = 1,
    mulr = 0,
    mulg = 0,
    mulb = 0,
    addr = 0,
    addg = 0,
    addb = 0,
    players = false,
    playersList = {}
}

function PLUGIN:Default()
    return table.Copy(self.colorMod)
end

function PLUGIN:Get()
    return GetNetVar("colormodify", self:Default())
end

local info = {
    ["brightness"] = {name = "Яркость", minimum = -2, maximum = 2, decimals = 2},
    ["contrast"] = {name = "Контраст", minimum = 0, maximum = 10, decimals = 2},
    ["color"] = {name = "Цвет", minimum = 0, maximum = 5, decimals = 2},
    ["addr"] = {name = "Добавить красный цвет", minimum = 0, maximum = 255, decimals = 0},
    ["addg"] = {name = "Добавить зеленый цвет", minimum = 0, maximum = 255, decimals = 0},
    ["addb"] = {name = "Добавить синий цвет", minimum = 0, maximum = 255, decimals = 0},
    ["mulr"] = {name = "Умножить красные цвета", minimum = 0, maximum = 255, decimals = 0},
    ["mulg"] = {name = "Умножить зеленые цвета", minimum = 0, maximum = 255, decimals = 0},
    ["mulb"] = {name = "Умножить синие цвета", minimum = 0, maximum = 255, decimals = 0}
}

function PLUGIN:GetInfo(key)
    return info[key]
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")