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

local draw_SimpleText = draw.SimpleText
local Color = Color

local version_color = Color(255, 255, 255, 25)
local title_color = Color(255, 255, 255, 70)

function PLUGIN:HUDPaint()
    if SETTINGS.options.Get("show_gamemode_info") then
        local a = ScrW() - 10
        local y = 8

        do
            local w, h = draw_SimpleText("v" .. Arbitrage.version, "arb.Font_FuturaPTBook_5", a, y, version_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw_SimpleText("Arbitrage Framework", "arb.Font_FuturaPTBook_6", a - w - 10, y, title_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            y = y + h
        end

        do
            local w = draw_SimpleText("v" .. asterionlib.version, "arb.Font_FuturaPTBook_5", a, y, version_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw_SimpleText("AsterionLibrary", "arb.Font_FuturaPTBook_6", a - w - 10, y, title_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end
end