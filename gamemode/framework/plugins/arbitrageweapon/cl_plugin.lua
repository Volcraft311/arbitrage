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

RunConsoleCommand("cl_tfa_fx_gasblur", 0)
RunConsoleCommand("cl_tfa_fx_muzzleflashsmoke", 0)
RunConsoleCommand("cl_tfa_fx_muzzlesmoke", 0)
RunConsoleCommand("cl_tfa_fx_muzzlesmoke_limited", 0)
RunConsoleCommand("cl_tfa_fx_ejectionsmoke", 0)
RunConsoleCommand("cl_tfa_fx_impact_enabled", 0)
RunConsoleCommand("cl_tfa_fx_impact_ricochet_enabled", 0)
RunConsoleCommand("cl_tfa_legacy_shells", 0)
RunConsoleCommand("cl_tfa_fx_ads_dof", 0)
RunConsoleCommand("cl_tfa_fx_ads_dof_hd", 0)
RunConsoleCommand("cl_tfa_fx_ejectionlife", 0)
RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparks", 0)
RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparklife", 0)
RunConsoleCommand("cl_tfa_ballistics_fx_bullet", 0)
RunConsoleCommand("cl_tfa_ballistics_fx_tracers_adv", 0)
RunConsoleCommand("cl_tfa_hud_hitmarker_enabled", 0)

hook.Remove("PrePlayerDraw", "TFACleanupProjectedTextures")
hook.Remove("PreDrawOpaqueRenderables", "tfaweaponspredrawopaque")
-- hook.Remove("ContextMenuOpen", "TFAContextBlock")
-- hook.Remove("Think", "TFAInspectionMenu")

local bAimedPlayer = false
function PLUGIN:OnAimedPlayer()
    if !bAimedPlayer then
        netstream.Start("TFA:OnAimedPlayer")

        timer.Remove("OnNotAimedPlayer")
    end

    bAimedPlayer = true
end

function PLUGIN:OnNotAimedPlayer()
    if bAimedPlayer then
        timer.Create("OnNotAimedPlayer", 5, 1, function()
            netstream.Start("TFA:OnNotAimedPlayer")
        end)
    end

    bAimedPlayer = false
end

hook("TFA_DrawCrosshair", function()
    return true
end)

local lastShakeOffset = Angle(0, 0, 0)
local shakingHandsPitch = 0
local shakingHandsYaw = 0
local shakingHandsTime = 0
hook("CalcView", function(client, pos, angles, fov)
    local weapon = client:GetActiveWeapon()
    if !IsValid(weapon) or !weapon:IsTFA() then return PLUGIN:OnNotAimedPlayer() end

    local ft = FrameTime()
    local offsets = PLUGIN:GetOffsets(client)

    local smoothWeaponShakeOffset = Angle(
        Lerp(ft * 15, lastShakeOffset.pitch, offsets.weaponOffset.pitch),
        Lerp(ft * 15, lastShakeOffset.yaw, offsets.weaponOffset.yaw),
        0
    )

    lastShakeOffset = smoothWeaponShakeOffset

    if weapon.ang_cached then
        weapon.ang_cached.pitch = weapon.ang_cached.pitch + smoothWeaponShakeOffset.pitch
        weapon.ang_cached.yaw = weapon.ang_cached.yaw + smoothWeaponShakeOffset.yaw

        if client:GetLocalVar("tfa:fear", 0) > 0 then
            if RealTime() > shakingHandsTime then
                local multiplier = PLUGIN:GetOffsetsMultiplier(client)

                shakingHandsPitch = (math.random() * 2 - 1) * 0.15 * multiplier
                shakingHandsYaw = (math.random() * 2 - 1) * 0.15 * multiplier

                shakingHandsTime = RealTime() + 0.065

                local chanceRandomShot = hook.Run("ChanceRandomShot", client)
                if chanceRandomShot then
                    RunConsoleCommand("+attack")

                    timer.Simple(0, function()
                        RunConsoleCommand("-attack")
                    end)
                end
            end

            weapon.ang_cached.pitch = weapon.ang_cached.pitch + shakingHandsPitch
            weapon.ang_cached.yaw = weapon.ang_cached.yaw + shakingHandsYaw
        end
    end

    if weapon:GetIronSights(client) or weapon:GetStatus() == 30 or weapon:GetStatus() == 31 then
    -- if weapon:GetStatus() == 30 or weapon:GetStatus() == 31 then
        angles:RotateAroundAxis(angles:Right(), offsets.cameraOffset.x)
        angles:RotateAroundAxis(angles:Up(), offsets.cameraOffset.y)
        angles:RotateAroundAxis(angles:Forward(), offsets.cameraOffset.z)

        local entity = client:GetEyeTrace().Entity
        if IsValid(entity) and (entity:IsPlayer() or entity:IsNPC()) and entity:GetPos():DistToSqr(EyePos()) < 160000 then
            PLUGIN:OnAimedPlayer()
        else
            PLUGIN:OnNotAimedPlayer()
        end
    else
        PLUGIN:OnNotAimedPlayer()
    end

    return {origin = pos, angles = angles, fov = fov}
end)

netstream.Hook("TFA:CreationLight", function(startPos, endPos, entity)
    local idx = LocalPlayer():EntIndex()

    local startLight = DynamicLight(idx + math.random(1, 999))
    if startLight then
        startLight.pos = startPos
        startLight.r = 255
        startLight.g = 200
        startLight.b = 150
        startLight.brightness = 3
        startLight.decay = 500
        startLight.size = 125
        startLight.dietime = CurTime() + 0.1
    end

    if (IsValid(entity) and (entity:IsPlayer() or entity:IsNPC())) or !IsValid(entity) then
        local endLight = DynamicLight(idx + math.random(1, 999))
        if endLight then
            endLight.pos = endPos
            endLight.r = 255
            endLight.g = 100
            endLight.b = 50
            endLight.brightness = 0.5
            endLight.decay = 150
            endLight.size = 50
            endLight.dietime = CurTime() + 0.05
        end
    end
end)


local vignitte_a = 0
local vignitte = surface.GetTextureID("vgui/vignette")
hook("HUDPaint", function()
    local ft = FrameTime()
    local client = LocalPlayer()
    local data = client:GetLocalVar("tfa:fear", 0)
    local bFear = data > 0

    if (bFear and vignitte_a < 255 - 0.005) or (!bFear and vignitte_a > 0 + 0.005) then
        vignitte_a = Lerp(ft * 1, vignitte_a, bFear and 255 or 0)
    end

    if vignitte_a > 1 then
        surface.SetTexture(vignitte)
        surface.SetDrawColor(255, 255, 255, vignitte_a)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end


    -- DEBUG
    --[[
    local weapon = client:GetActiveWeapon()
    if !IsValid(weapon) or !weapon:IsTFA() then return end

    -- if !weapon:GetIronSights(client) then return end

    local tr = {}
    tr.start = LocalPlayer():GetShootPos()
    tr.endpos = tr.start + LocalPlayer():GetAimVector() * 0x7FFF
    tr.filter = LocalPlayer()
    tr.mask = MASK_SHOT
    local trace = util.TraceLine(tr)

    local bulletBoxSize = Vector(5, 5, 5)
    debugoverlay.Box(trace.HitPos, bulletBoxSize * -0.5, bulletBoxSize * 0.5, 0.1, Color(255, 0, 0), true)

    local offsets = PLUGIN:GetOffsets(client)
    draw.SimpleText("cameraOffset: " .. tostring(offsets.cameraOffset), "Default", ScrW() / 2, ScrH() / 2 + 300, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("weaponOffset: " .. tostring(offsets.weaponOffset), "Default", ScrW() / 2, ScrH() / 2 + 325, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("cameraShakeStrength: " .. tostring(offsets.cameraShakeStrength), "Default", ScrW() / 2, ScrH() / 2 + 350, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("weaponShakeStrength: " .. tostring(offsets.weaponShakeStrength), "Default", ScrW() / 2, ScrH() / 2 + 375, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("weaponRecoil: " .. tostring(client:GetLocalVar("tfa:recoil", 0)), "Default", ScrW() / 2, ScrH() / 2 + 400, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("weaponFear: " .. tostring(client:GetLocalVar("tfa:fear", 0)), "Default", ScrW() / 2, ScrH() / 2 + 425, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    ]]--
end)