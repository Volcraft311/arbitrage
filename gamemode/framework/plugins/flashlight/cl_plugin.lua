--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


-- данный хук запускается в CalcView (сделано чтобы не было проблем с переопределением хуков)
function Flashlight:FlashlightDraw(client)
    local idx = client:GetLocalVar("sharedflashlight", nil)
    if !idx then return end

    local entity = Entity(idx)
    if !IsValid(entity) then return end

    entity:SetPos(client:EyePos() + client:EyeAngles():Forward() * 15)
    entity:SetAngles(client:EyeAngles())
end

local flashlight_class = "academy_flashlight"
function Flashlight:StartCommand(client, cmd)
    if cmd:GetImpulse() == 100 then
        cmd:SetImpulse(0)

        local weapon = client:GetActiveWeapon()
        if IsValid(weapon) and weapon:GetClass() == flashlight_class then
            RunConsoleCommand("lastinv")
        else
            RunConsoleCommand("use", flashlight_class)
        end
    end
end