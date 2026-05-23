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


local PLUGIN = PLUGIN
PLUGIN.name = "Arbitrage Weapon"

function PLUGIN:GetOffsetsMultiplier(client)
    local multiplier = 1

    if client:Crouching() then
        multiplier = multiplier * 0.5
    elseif client.IsProne and client:IsProne() then
        multiplier = multiplier * 0.15
    end

    local multHandShaking = hook.Run("MultiplierHandShaking", client)
    if multHandShaking then
        multiplier = multiplier * multHandShaking
    end

    return multiplier
end

local tfaRecoilsList = {}
local tfaFearList = {}
function PLUGIN:GetOffsets(client)
    local time = CurTime()

    local multiplier = self:GetOffsetsMultiplier(client)
    local cameraShakeStrength = 0.125
    local weaponShakeStrength = 0.4

    -- cameraShakeStrength = cameraShakeStrength + (tfaFearList[client] or 0)
    weaponShakeStrength = weaponShakeStrength + (tfaFearList[client] or 0)

    cameraShakeStrength = cameraShakeStrength * multiplier
    weaponShakeStrength = weaponShakeStrength * multiplier

    local cameraOffsetX = math.sin(time * 2) * cameraShakeStrength
    local cameraOffsetY = math.cos(time * 2.5) * cameraShakeStrength
    local cameraOffsetZ = math.sin(time * 3) * cameraShakeStrength

    local weaponOffsetX = math.cos(time * 2) * weaponShakeStrength
    local weaponOffsetY = math.sin(time * 2.5) * weaponShakeStrength

    weaponOffsetX = weaponOffsetX + (tfaRecoilsList[client] or 0)

    return {
        cameraOffset = Vector(cameraOffsetX, cameraOffsetY, cameraOffsetZ),
        weaponOffset = Angle(weaponOffsetX, weaponOffsetY, 0),
        cameraShakeStrength = cameraShakeStrength,
        weaponShakeStrength = weaponShakeStrength
    }
end

hook("PlayerPostThink", function(client)
    local weapon = client:GetActiveWeapon()
    if IsValid(weapon) and weapon:IsTFA() then
        -- отдача от оружия
        tfaRecoilsList[client] = tfaRecoilsList[client] or 0

        local dataRecoil = client:GetLocalVar("tfa:recoil", 0)
        if tfaRecoilsList[client] < dataRecoil - 0.001 or tfaRecoilsList[client] > dataRecoil + 0.001 then
            tfaRecoilsList[client] = Lerp(0.05, tfaRecoilsList[client], dataRecoil)
        else
            if tfaRecoilsList[client] <= 0.001 then
                tfaRecoilsList[client] = 0
            end
        end

        -- страх
        tfaFearList[client] = tfaFearList[client] or 0

        local dataFear = client:GetLocalVar("tfa:fear", 0)
        if tfaRecoilsList[client] > 0 then
            dataFear = dataFear * 2
        end

        if tfaFearList[client] < dataFear - 0.001 or tfaFearList[client] > dataFear + 0.001 then
            tfaFearList[client] = Lerp(0.05, tfaFearList[client], dataFear)
        else
            if tfaFearList[client] <= 0.001 then
                tfaFearList[client] = 0
            end
        end
    end
end)

hook("MultiplierHandShaking", function(client)
    local t_status_effects = client:GetTemporaryStatusEffects()
    for _, array in ipairs(t_status_effects) do
        local uniqueID = array.uniqueID
        local info = Medical.t_status_effects[uniqueID]

        local _hook = info.hooks.MultiplierHandShaking
        if !_hook then continue end

        local value = _hook(client)
        if value != nil then
            return value
        end
    end
end)

hook("MultiplierFear", function(client)
    local t_status_effects = client:GetTemporaryStatusEffects()
    for _, array in ipairs(t_status_effects) do
        local uniqueID = array.uniqueID
        local info = Medical.t_status_effects[uniqueID]

        local _hook = info.hooks.MultiplierFear
        if !_hook then continue end

        local value = _hook(client)
        if value != nil then
            return value
        end
    end
end)

hook("MultiplierRecoil", function(client)
    local t_status_effects = client:GetTemporaryStatusEffects()
    for _, array in ipairs(t_status_effects) do
        local uniqueID = array.uniqueID
        local info = Medical.t_status_effects[uniqueID]

        local _hook = info.hooks.MultiplierRecoil
        if !_hook then continue end

        local value = _hook(client)
        if value != nil then
            return value
        end
    end
end)

hook("ChanceRandomShot", function(client)
    local time = RealTime()

    local t_status_effects = client:GetTemporaryStatusEffects()
    for _, array in ipairs(t_status_effects) do
        local uniqueID = array.uniqueID
        local info = Medical.t_status_effects[uniqueID]

        local _hook = info.hooks.ChanceRandomShot
        if !_hook then continue end

        local value = tonumber(_hook(client))
        if value != nil and math.random() <= value then
            client.chanceRandomShot = client.chanceRandomShot or time

            if time > client.chanceRandomShot then
                client.chanceRandomShot = time + 60

                -- на сервере ивент не обрабатывается
                if CLIENT then
                    Medical:AddTemporaryStatusEffect(uniqueID, 15)
                end

                return true
            end
        end
    end
end)


local statEdits = {
    ["Primary.RecoilLUT_ViewPunchMult"] = 8,
    ["Primary.StaticRecoilFactor"] = 0.2
}

hook("TFA_GetStat", function(weapon, name, value)
    local mulValue = statEdits[name]

    if mulValue then
        local client = weapon:GetOwner()

        -- if IsValid(client) and client:IsPlayer() and weapon:GetIronSights(client) then
        if IsValid(client) and client:IsPlayer() then
            local multiplier = PLUGIN:GetOffsetsMultiplier(client)

            return value * mulValue * multiplier
        end
    end
end)


local PLAYER = FindMetaTable("Player")

PLAYER.oldGetAimVector = PLAYER.oldGetAimVector or PLAYER.GetAimVector
function PLAYER:GetAimVector()
    local data = self:oldGetAimVector()

    local weapon = self:GetActiveWeapon()
    -- if IsValid(weapon) and weapon:IsTFA() and weapon:GetIronSights(self) then
    if IsValid(weapon) and weapon:IsTFA() then
        local offsets = PLUGIN:GetOffsets(self)

        local modifiedVector = Vector(data)
        local angle = modifiedVector:Angle()

        angle:RotateAroundAxis(angle:Right(), offsets.weaponOffset.pitch * 2.2)
        angle:RotateAroundAxis(angle:Up(), offsets.weaponOffset.yaw * 2.2)

        modifiedVector = angle:Forward()

        return modifiedVector
    end

    return data
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")