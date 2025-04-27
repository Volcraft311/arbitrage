--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Arbitrage.theme = Arbitrage.library.Add("theme")
Arbitrage.theme.stored = Arbitrage.theme.stored or {}
Arbitrage.theme.default = "red"
Arbitrage.theme.convar = CreateClientConVar("arb_theme", Arbitrage.theme.default, true, true)

function Arbitrage.theme:Add(uniqueID, data)
    data.images = data.images or {}

    Arbitrage.theme.stored[uniqueID] = data
end

function Arbitrage.theme:Get(theme_id)
    return self.stored[theme_id]
end

function Arbitrage.theme:GetActive()
    local theme_id = self.convar:GetString()
    local theme = self:Get(theme_id)

    return theme or self:Get(self.default)
end

function Arbitrage.theme:GetInformation()
    local theme = Arbitrage.theme:GetActive()
    local informationColor = theme.information

    return Color(informationColor.r, informationColor.g, informationColor.b)
end

function Arbitrage.theme:GetForeground()
    local theme = Arbitrage.theme:GetActive()
    local foregroundColor = theme.foreground

    return Color(foregroundColor.r, foregroundColor.g, foregroundColor.b)
end

function Arbitrage.theme:GetBackground()
    local theme = Arbitrage.theme:GetActive()
    local backgroundColor = theme.background

    return Color(backgroundColor.r, backgroundColor.g, backgroundColor.b)
end

-- Основная тема красного цвета
Arbitrage.theme:Add("red", {
    information = Color(218, 19, 40),
    foreground = Color(255, 255, 255),
    background = Color(255, 255, 255),
    images = {

    }
})

Arbitrage.theme:Add("test", {
    information = Color(255, 211, 116),
    foreground = Color(255, 255, 255),
    background = Color(255, 255, 255),
    images = {

    }
})