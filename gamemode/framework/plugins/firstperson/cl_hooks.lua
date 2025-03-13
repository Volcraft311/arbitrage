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

PLUGIN.isAllow = false

-- Localize Global Calls
local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")
local VECTOR = FindMetaTable("Vector")
local CUSERCMD = FindMetaTable("CUserCmd")

local IsValid = IsValid
local RealFrameTime = RealFrameTime
local LerpAngle = LerpAngle
local Angle = Angle
local math_Approach = math.Approach
local Lerp = Lerp
local math_Clamp = math.Clamp
local Vector = Vector
local util_TraceLine = util.TraceLine
local select = select
local concommand_Add = concommand.Add
local timer_Simple = timer.Simple
local surface_GetTextureID = surface.GetTextureID
local FrameTime = FrameTime
local surface_SetTexture = surface.SetTexture
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local math_sin = math.sin
local math_NormalizeAngle = math.NormalizeAngle
local RealTime = RealTime
local vgui_CursorVisible = vgui.CursorVisible

local IsNocliping = PLAYER.IsNocliping
local oldAlive = PLAYER.oldAlive
local IsPlaying = PLAYER.IsPlaying
local IsPlayingTaunt = PLAYER.IsPlayingTaunt
local IsSpectating = PLAYER.IsSpectating
local GetActiveWeapon = PLAYER.GetActiveWeapon
local GetAction = PLAYER.GetAction
local InVehicle = PLAYER.InVehicle
local Team = PLAYER.Team
local GetAimVector = PLAYER.GetAimVector
local KeyDown = PLAYER.KeyDown
local HasTemporaryStatusEffect = PLAYER.HasTemporaryStatusEffect
local SetEyeAngles = PLAYER.SetEyeAngles

local GetClass = ENTITY.GetClass
local GetAttachment = ENTITY.GetAttachment
local LookupAttachment = ENTITY.LookupAttachment
local EyeAngles = ENTITY.EyeAngles
local GetVelocity = ENTITY.GetVelocity
local GetRight = ENTITY.GetRight
local IsOnGround = ENTITY.IsOnGround
local WaterLevel = ENTITY.WaterLevel

local Length2D = VECTOR.Length2D

local GetViewAngles = CUSERCMD.GetViewAngles
local SetViewAngles = CUSERCMD.SetViewAngles

timer_Simple(0, function() -- overwrite gamemodes...
    IsNocliping = PLAYER.IsNocliping
    oldAlive = PLAYER.oldAlive
    IsPlaying = PLAYER.IsPlaying
    IsSpectating = PLAYER.IsSpectating
    GetAction = PLAYER.GetAction
    HasTemporaryStatusEffect = PLAYER.HasTemporaryStatusEffect
end)


PLUGIN.name = "First Person"

local ViewOffsetUp = 0
local ViewOffsetForward = 3
local ViewOffsetForward2 = 0
local ViewOffsetLeftRight = 0
local RollDependency = 0.1
local CurView = nil
local traceHit = false
local eyeAtt

local d_weapon = {
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true
}

local weaponData = {
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["academy_key"] = true,
    ["academy_first"] = true,
    ["weapon_broom"] = true
}

local function allow()
    local client = LocalPlayer()

    if Arbitrage.IsThirdPerson() then return false end
    if Arbitrage.lawEnable then return false end
    if IsNocliping(client) then return false end

    if !IsValid(client) then return true end
    if !oldAlive(client) then return false end
    if !IsPlaying(client) then return false end
    if IsPlayingTaunt(client) then return false end
    if IsSpectating(client) then return false end

    local weapon = GetActiveWeapon(client)
    if !IsValid(weapon) then return true end

    local class = GetClass(weapon)
    if !class then return true end

    if class == "academy_first" and weapon:GetAttack() then
        return false
    end

    local bThirdPerson = select(3, GetAction(client))
    if bThirdPerson then return false end

    if d_weapon[class] then return false end

    return weaponData[class]
end

function PLUGIN:ShouldDrawLocalPlayer()
    if !self.isAllow then return end

    if traceHit and !InVehicle(LocalPlayer()) then
        return false
    else
        return true
    end
end

local bCloserLook = false
local fovShift = 0
local bobTime = 0
local bobSpeed = 0
local bobAmount = 0
local leanAmount = 0
local lastMouseX = 0
local mouseLeanAmount = 0
local wasInAir = false
local shakeAmount = 0

function getCameraPos(client)
    if !IsValid(client) then return end

    local character = Character.team.instances[Team(client)]
    if character then
        local characterCameraPos = character.cameraPos
        if characterCameraPos then
            return character.cameraPos
        end
    end
end

function PLUGIN:CalcViewHandler(client, pos, angles, fov)
    local forwardVec = GetAimVector(client)
    local FT = FrameTime()
    local eyeAngles = EyeAngles(client)

    eyeAtt = GetAttachment(client, LookupAttachment(client, "eyes"))

    if (traceHit and !InVehicle(client)) or !eyeAtt then
        return
    end

    local camera_smoothness = SETTINGS.options.Get("camera_smoothness")
    local viewbob_strength = SETTINGS.options.Get("viewbob_strength") / 100

    if !CurView then
        CurView = angles
    else
        CurView = LerpAngle(FT * camera_smoothness, CurView, angles + Angle(0, 0, eyeAtt.Ang.r * RollDependency))
    end

    if camera_smoothness >= 25 then
        CurView = angles + Angle(0, 0, eyeAtt.Ang.r * RollDependency)
    end

    ViewOffsetLeftRight = math_Approach(ViewOffsetLeftRight, 0, 0.5)

    local velocity = Length2D(GetVelocity(client))
    local isMoving = velocity > 10
    local isSprinting = KeyDown(client, IN_SPEED)
    local stamina = Stamina:GetStamina(client) or 100

    if isMoving and viewbob_strength > 0 then
        bobSpeed = isSprinting and 10 or 6
        bobAmount = Lerp(0.1 * viewbob_strength, bobAmount, math_Clamp(velocity / 200, 0, 1) * (1 - stamina / 100))
        bobTime = bobTime + FT * bobSpeed
    else
        bobAmount = 0
    end

    local bobOffset = viewbob_strength > 0 and Vector(math_sin(bobTime * 0.5) * bobAmount * 0.5, math_sin(bobTime) * bobAmount * 0.3, math_sin(bobTime * 0.5) * bobAmount * 0.5) or Vector(0, 0, 0)

    local leanTarget = 0
    if KeyDown(client, IN_MOVELEFT) then
        leanTarget = 2.8
    elseif KeyDown(client, IN_MOVERIGHT) then
        leanTarget = -2.8
    end

    local leanSpeedFactor = math_Clamp(velocity / 200, 0, 1)
    leanAmount = viewbob_strength > 0 and Lerp(FT * 2 * viewbob_strength, leanAmount, leanTarget * leanSpeedFactor * 0.75) or 0

    local mouseDeltaX = eyeAngles.y - lastMouseX
    local delta = math_NormalizeAngle(mouseDeltaX)
    lastMouseX = eyeAngles.y

    local targetLeanAmount = delta * 0.8
    mouseLeanAmount = viewbob_strength > 0 and Lerp(FT * 2 * viewbob_strength, mouseLeanAmount, targetLeanAmount) or 0

    ViewOffsetUp = math_Approach(ViewOffsetUp, math_Clamp(eyeAngles.p * -0.1, 0, 10), 0.5)
    ViewOffsetForward = math_Approach(ViewOffsetForward, 5 + math_Clamp(eyeAngles.p * 0.1, 0, 5), 0.5)
    RollDependency = viewbob_strength > 0 and Lerp(FT * 15 * viewbob_strength, RollDependency, 0.05) or 0

    local waterLevel = WaterLevel(client)
    local isInAir = !IsOnGround(client)

    if isInAir and waterLevel < 1 then
        shakeAmount = viewbob_strength > 0 and math_sin(RealTime() * 5) * 1 or 0
    elseif !isInAir and wasInAir then
        shakeAmount = viewbob_strength > 0 and math.random() * 1 or 0
    end

    wasInAir = isInAir
    shakeAmount = viewbob_strength > 0 and Lerp(FT * 1 * viewbob_strength, shakeAmount, 0) or 0

    local shakeOffset = Vector(shakeAmount, shakeAmount, shakeAmount)
    local shakeAngle = Angle(shakeAmount, shakeAmount, 0)

    local baseOffset = Vector(forwardVec.x * (ViewOffsetForward + ViewOffsetForward2), forwardVec.y * (ViewOffsetForward + ViewOffsetForward2 - 0.3), 0)
    local viewOrigin = eyeAtt.Pos + baseOffset + Vector(0, 0, ViewOffsetUp) + GetRight(client) * ViewOffsetLeftRight + bobOffset + shakeOffset

    local shift = velocity * 0.035
    local value = 0
    if KeyDown(client, IN_FORWARD) then
        value = shift
    elseif KeyDown(client, IN_BACK) then
        value = -shift
    end

    if HasTemporaryStatusEffect(client, "berserk") then
        value = value + 15
    end

    value = math_Clamp(value, -8, 8)

    if !vgui_CursorVisible() and SETTINGS.binds.IsClampedID("closerlook") then
        value = value - 35
        bCloserLook = true
    end

    fovShift = Lerp(FT * (bCloserLook and 5 or 3), fovShift, value)

    local cameraPos = getCameraPos(client)
    if cameraPos then
        viewOrigin = viewOrigin + cameraPos
    end

    if !eyeAtt then return end

    return {
        origin = viewOrigin,
        angles = CurView + Angle(0, 0, leanAmount + mouseLeanAmount) + shakeAngle,
        fov = fov + fovShift
    }
end

function PLUGIN:CalcView(client, pos, angles, fov)
    bCloserLook = false
    Flashlight:FlashlightDraw(client)

    local view = self:CalcViewHandler(client, pos, angles, fov)
    if !view then return end

    if !self.isAllow then return end

    return GAMEMODE:CalcView(client, view.origin, view.angles, view.fov)
end

function PLUGIN:Think()
    self.isAllow = allow()
    if !self.isAllow then return end

    local client = LocalPlayer()
    if eyeAtt then
        local forwardVec = GetAimVector(client)

        local tr = {}
        tr.start = eyeAtt.Pos
        tr.endpos = tr.start + Vector(forwardVec.x, forwardVec.y, 0) * 20
        tr.filter = client

        local trace = util_TraceLine(tr)
        if trace.Hit then
            traceHit = true
        else
            traceHit = false
        end
    end
end

local vignitte_a = 0
local vignitte = surface_GetTextureID("vgui/vignette")
function PLUGIN:HUDPaint()
    if !self.isAllow then return end

    if (bCloserLook and vignitte_a < 254) or (!bCloserLook and vignitte_a > 0.1) then
        vignitte_a = Lerp(FrameTime() * 4, vignitte_a, bCloserLook and 255 or 0)
    end

    if vignitte_a <= 0.5 then return end

    surface_SetTexture(vignitte)
    surface_SetDrawColor(255, 255, 255, vignitte_a)
    surface_DrawTexturedRect(0, 0, ScrW(), ScrH())
end


function PLUGIN:CreateMove(ucmd)
    if !self.isAllow then return end

    local m = 75 -- LocalPlayer():Team() == TEAM_HIFUMI and 55 or 75
    local s = 90 -- LocalPlayer():Team() == TEAM_MONDO and 32 or 90

    local eyeAng = GetViewAngles(ucmd)
    SetViewAngles(ucmd, Angle(math_Clamp(eyeAng.p, -s, m), eyeAng.y, eyeAng.r))
end


concommand_Add("arb_camerafix", function(client, cmd, args)
    local ang = EyeAngles(client)

    SetEyeAngles(client, Angle(ang.p, ang.y, 0))
end)