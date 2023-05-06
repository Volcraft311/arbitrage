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

function PLUGIN:HUDPaint()
    local client = LocalPlayer()

    if Arbitrage.lawEnable then return end

    local isObserver = client:GetLocalVar("observer")
    local isSpectating = client:IsSpectating()
    if !isObserver and !isSpectating then return end

    local text = "невидимости"
    if isSpectating then
        text = "режиме наблюдения"

        if isObserver then
            text = text .. " и невидимости"
        end
    end

    local alpha = math.abs(math.sin(CurTime() * 1)) * 100
    draw.SimpleText("Вы находитесь в " .. text .. "!", "arb.Font_FuturaPTDemi_8", ScrW() / 2, ScrH() * 0.97, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
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