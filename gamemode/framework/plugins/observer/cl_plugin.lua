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

-- Localize Global Calls
local math_abs = math.abs
local math_sin = math.sin
local CurTime = CurTime
local draw_SimpleText = draw.SimpleText
local ScrW = ScrW
local ScrH = ScrH
local Color = Color

function PLUGIN:HUDPaint()
    local client = LocalPlayer()

    if Arbitrage.lawEnable then return end

    local isObserver = client:GetLocalVar("observer")
    local isSpectating = client:IsSpectating()
    if !isObserver and !isSpectating then return end

    local text = "#observer_status_invisible"
    if isSpectating then
        text = "#observer_status_spectate"

        if isObserver then
            text = text .. " #observer_status_and_invisible"
        end
    end

    local alpha = math_abs(math_sin(CurTime() * 1)) * 100
    draw_SimpleText(F("#observer_status_prefix " .. text .. "!"), "arb.Font_FuturaPTDemi_8", ScrW() / 2, ScrH() * 0.97, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
end

function PLUGIN:DrawPhysgunBeam(client, physgun, enabled, target, bone, hitPos)
    if client != LocalPlayer() then
        return false
    end
end

function PLUGIN:PrePlayerDraw(client)
    if client:IsNocliping() and !client:InVehicle() then
        return true
    end
end