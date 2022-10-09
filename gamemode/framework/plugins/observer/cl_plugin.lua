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

function PLUGIN:HUDPaint()
    if Arbitrage.lawEnable then return end
    if !LocalPlayer():GetLocalVar("observer") then return end

    local alpha = math.abs(math.sin(CurTime() * 1)) * 100
    draw.SimpleText("Вы находитесь в невидимости!", "arb.Font_FuturaPTDemi_8", ScrW() / 2, ScrH() * 0.97, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
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