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

local draw_SimpleText = draw.SimpleText
local ScrW = ScrW
local Arbitrage = Arbitrage
local Color = Color
local math_sin = math.sin
local math_abs = math.abs
local CurTime = CurTime

local version_color = Color(255, 255, 255, 25)

function PLUGIN:HUDPaint()
    if SETTINGS.options.Get("show_gamemode_info") then
        local a = ScrW() - W(10)

        local title_color = Color(255, 255, 255, 40 + math_abs(math_sin(CurTime() * 2) * 30))

        do
            local w, _ = draw_SimpleText("v" .. Arbitrage.version, "arb.Font_FuturaPTBook_5", a, H(8), version_color, TEXT_ALIGN_RIGHT)
            draw_SimpleText("Arbitrage Framework", "arb.Font_FuturaPTBook_6", a - w - 10, H(5), title_color, TEXT_ALIGN_RIGHT)
        end

        do
            local w, _ = draw_SimpleText("v" .. asterionlib.version, "arb.Font_FuturaPTBook_5", a, H(25), version_color, TEXT_ALIGN_RIGHT)
            draw_SimpleText("AsterionLibrary", "arb.Font_FuturaPTBook_6", a - w - 10, H(22), title_color, TEXT_ALIGN_RIGHT)
        end

        local dev_color = Color(255, 255, 255, math_sin(CurTime()) * 20)
        draw_SimpleText("❤ Made with love by Asterion", "arb.Font_FuturaPTBook_4", a, H(50), dev_color, TEXT_ALIGN_RIGHT)
    end
end