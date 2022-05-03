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
local CurTime = CurTime

function PLUGIN:HUDPaint()
    if SETTINGS.options.Get("show_gamemode_info") then
        local a = ScrW() - W(10)

        draw_SimpleText("yeah! arbitrage works :)", "arb.Font_FuturaPTBook_5", a, H(10), Color(14, 255, 151, 10), TEXT_ALIGN_RIGHT)

        draw_SimpleText("GM-Arbitrage Framework", "arb.Font_FuturaPTBook_7", a, H(35), Color(255, 255, 255, 40), TEXT_ALIGN_RIGHT)
        draw_SimpleText("v" .. Arbitrage.version, "arb.Font_FuturaPTBook_6", a, H(52), Color(255, 255, 255, 25), TEXT_ALIGN_RIGHT)

        draw_SimpleText("This gamemode is still in the early stages of development!\nIf you find any errors, please let us know.", "arb.Font_FuturaPTBook_5", a, H(80), Color(255, 255, 255, 7), TEXT_ALIGN_RIGHT)

        local alpha = math_sin(CurTime() * 1) * 7
        draw_SimpleText("❤ Made with love by Asterion", "arb.Font_FuturaPTBook_4", a, H(110), Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT)
    end
end