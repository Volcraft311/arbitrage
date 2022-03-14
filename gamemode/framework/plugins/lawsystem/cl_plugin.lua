--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

function PLUGIN:StartPointing()
    self._angles = Vector(0, 0, 0)

    self._fov = 90
    self._entity = NULL
    self.oldEntity = self._entity
    self.__camPos = self.camPosEnd[game.GetMap()]

    self.animID = 1

    timer.Simple(0.5, function()
        self._movescene = true
    end)

    timer.Simple(6, function()
        hook.Add("ArbitrageVoiceStart", "arb.LawStartVoice", function(client)
            if !Arbitrage.lawEnable then return end

            if client == Arbitrage.Client() and self._entity != Arbitrage.Client() then
                netstream.Start("arb.StartVoice")
            end
        end)

        vgui.Create("arb.LawAction")
        vgui.Create("arb.LawPlayerTable")
        vgui.Create("arb.LawTimer")
    end)

    hook.Add("CalcView", "arb.LawStartPointing", function(client, pos, angles, fov)
        --local __camPos = self.__camPos
        --if self.oldEntity != self._entity then
            --self.oldEntity = self._entity -- Старый игрок который говорил
        --end

        -- if (!self.interruption or CurTime() >= self.interruption) then
        --     for k, v in SortedPairs(player.GetAll()) do
        --         if v:IsPlaying() and v:IsSpeaking() and v != self._entity then
        --             self._entity = v
        --             self.interruption = CurTime() + 5
        --             break
        --         end
        --     end
        -- end

        if IsValid(self._entity) then
            --local isKuma = self._entity:Team() == TEAM_MONOKUMA
            --local a = self.monokumCam
            --local b = self.camPosEnd

            --self.__camPos = Lerp(FrameTime() * 5, self.__camPos, isKuma and a or b)

            -- local WPos = self._entity:LocalToWorld(Vector(0, 0, 0))
            -- local Ang = WPos - self.__camPos
            -- Ang = Ang:Angle()

            -- if self.oldEntity != self._entity then
            --     self.animID = math.random(1, #self.CamAnimData)
            -- end

            self:ReplaceVariables()
            self.__camPos, self._angles, self._fov, self._entity = self.CamAnimData[self.animID](
                self,
                self.__camPos,
                self._angles,
                self._fov,
                self._entity
            )

            -- for k, v in pairs({"x", "y", "z"}) do
            --     local speed = 5
            --     if self._angles.y >= Ang.y - 5 and self._angles.y <= Ang.y + 5 then
            --         speed = 1
            --     end

            --     self._angles[v] = Lerp(FrameTime() * speed, self._angles[v], Ang[v])
            -- end

            -- if self._angles.y >= Ang.y - 5 and self._angles.y <= Ang.y + 5 and self._entity:IsSpeaking() then
            --     self._fov = Lerp(FrameTime() * 3, self._fov, 88.5)
            -- else
            --     self._fov = Lerp(FrameTime() * 5, self._fov, 90)
            -- end
            --self._fov = Lerp(FrameTime() * 5, self._fov, 90)
        else
            self._angles.y = CurTime() % 20 * 18
        end

        local angRot = IsValid(self._entity) and 0 or 2

        local view = {
            origin = self.__camPos - Vector(0, 0, 10),
            angles = Angle(0, self._angles.y, self._angles.z - angRot),
            fov = self._fov - 40,
            drawviewer = true
        }

        self.oldEntity = self._entity -- Старый игрок который говорил

        return view
    end)
end

function PLUGIN:RednessScreen()
    hook.Add("RenderScreenspaceEffects", "arb.LawRednessScreen", function()
        --surface.SetDrawColor(255, 61, 96, 5)
        --surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
    end)
end

function PLUGIN:TransferCamPos(id)
    local data = self.camPos[game.GetMap()][id]
    self._camPos = data.pos
    self._angCam = 0
    self._movescene = false
    self.__movescene = 0
    self._angUp = 0

    -- hook.Add("RenderScreenspaceEffects", "arb.LawTransferCamPos", function()
    --     self._camPos = Lerp(FrameTime(), self._camPos, self.camPosEnd)
    --     self.__movescene = Lerp(FrameTime(), self.__movescene, self._movescene and ScrH() * 0.1 or 0)
    -- end)

    hook.Add("CalcView", "arb.LawTransferCamPos", function(client, pos, angles, fov)
        self._camPos = Lerp(FrameTime() * 1.3, self._camPos, self.camPosEnd[game.GetMap()])
        --self.__movescene = Lerp(FrameTime(), self.__movescene, self._movescene and ScrH() * 0.1 or 0)

        local frame = FrameTime() * 60
        self._angCam = (id % 2 == 1 and (self._angCam + frame) or (self._angCam - frame))
        self._angUp = Lerp(FrameTime(), self._angUp, 30)

        local view = {
            origin = self._camPos,
            angles = data.ang + Angle(0, self._angCam, 0) - Angle(self._angUp, 0, 0),
            fov = fov,
            drawviewer = true
        }

        --local dist = self._camPos:Distance(self.camPosEnd)
        --if dist <= 50 then
            --hook.Remove("CalcView", "arb.LawTransferCamPos")
            --self:StartPointing()
        --end

        return view
    end)
end

local nsb_path = "danganronpa/law/nsb/%s.png"
local nsb_1, nsb_1_l = Arbitrage.GetMaterial(string.format(nsb_path, "1")), Arbitrage.GetMaterial(string.format(nsb_path, "1_l"))
local nsb_2, nsb_2_l = Arbitrage.GetMaterial(string.format(nsb_path, "2")), Arbitrage.GetMaterial(string.format(nsb_path, "2_l"))
local nsb_3, nsb_3_l = Arbitrage.GetMaterial(string.format(nsb_path, "3")), Arbitrage.GetMaterial(string.format(nsb_path, "3_l"))
local nsb_4, nsb_4_l = Arbitrage.GetMaterial(string.format(nsb_path, "4")), Arbitrage.GetMaterial(string.format(nsb_path, "4_l"))
local nsb_5, nsb_5_l = Arbitrage.GetMaterial(string.format(nsb_path, "5")), Arbitrage.GetMaterial(string.format(nsb_path, "5_l"))

function PLUGIN:SendIntroText()
    local size = 400
    local rightMove = 0

    local textTable = {
        [1] = {nsb_1, 30, 255, 0, nsb_1_l},
        [2] = {nsb_2, 280, 255, 0, nsb_2_l},
        [3] = {nsb_3, 440, 255, 65, nsb_3_l},
        [4] = {nsb_4, 690, 255, 50, nsb_4_l},
        [5] = {nsb_5, 965, 255, 0, nsb_5_l},
    }

    for k, v in SortedPairs(textTable) do
        v.alpha = 255
        v.x = -size
        v.ToX = v.x
        v.color = Color(0, 0, 0)

        timer.Simple(math.abs(k - 4) / 10, function()
            v.ToX = (ScrW() / 2 + v[2]) - 965 / 2 - (size / 2)

            timer.Simple(0.1, function()
                v.color = Color(255, 61, 96)

                timer.Simple(1.3, function()
                    v[3] = 0
                end)
            end)
        end)
    end

    hook.Add("RenderScreenspaceEffects", "arb.LawIntroText", function()
        for k, v in SortedPairs(textTable) do
            surface.SetDrawColor(ColorAlpha(v.color, v.alpha))
            surface.SetMaterial(v[1])
            surface.DrawTexturedRect(v.x + rightMove - 450, ScrH() / 2 - size / 2 + v[4], size, size)

            surface.SetDrawColor(ColorAlpha(Color(255, 255, 255), v.alpha * 2))
            surface.SetMaterial(v[5])
            surface.DrawTexturedRect(v.x + rightMove - 450, ScrH() / 2 - size / 2 + v[4], size, size)

            v.alpha = Lerp(FrameTime() * 20, v.alpha, v[3])
            v.x = Lerp(FrameTime() * 20, v.x, v.ToX)
            rightMove = rightMove + FrameTime() * 100

            for k1, v1 in pairs({"r", "g", "b"}) do
                v.color[v1] = Lerp(FrameTime(), v.color[v1], 0)
            end
        end
    end)
end

local circleMat = Arbitrage.GetMaterial("danganronpa/law/circle.png")
local circleMatB = Arbitrage.GetMaterial("danganronpa/law/circle_b.png")
local startMat = Arbitrage.GetMaterial("danganronpa/law/start.png")
function PLUGIN:SendStartText()
    local size = 0
    local alpha = 255
    local alphaTo = alpha
    local rot = 0

    hook.Add("RenderScreenspaceEffects", "arb.LawStartText", function()
        size = Lerp(FrameTime() * 3, size, 400)
        alpha = Lerp(FrameTime() * 10, alpha, alphaTo)
        rot = Lerp(FrameTime() * 2, rot, 180)

        surface.SetDrawColor(ColorAlpha(Color(255, 61, 96), alpha * 0.3))
        surface.SetMaterial(circleMat)
        surface.DrawTexturedRectRotated(ScrW() / 2, ScrH() / 2, size * 3, size * 3, rot)

        surface.SetDrawColor(ColorAlpha(Color(255, 61, 96), alpha * 0.3))
        surface.SetMaterial(circleMatB)
        surface.DrawTexturedRectRotated(ScrW() / 2, ScrH() / 2, size * 3, size * 3, rot)

        surface.SetDrawColor(ColorAlpha(Color(255, 61, 96), alpha))
        surface.SetMaterial(startMat)
        surface.DrawTexturedRect(ScrW() / 2 - (size * 2.5) / 2, ScrH() / 2 - size / 2, size * 2.5, size)
    end)

    timer.Simple(1, function()
        alphaTo = 0
    end)
end

function PLUGIN:Clear()
    hook.Remove("CalcView", "arb.LawCameraTwist")
    hook.Remove("CalcView", "arb.LawTransferCamPos")
    hook.Remove("CalcView", "arb.LawStartPointing")
    hook.Remove("RenderScreenspaceEffects", "arb.LawTransferCamPos")
    hook.Remove("RenderScreenspaceEffects", "arb.LawBlackScreen")
    hook.Remove("RenderScreenspaceEffects", "arb.LawIntroText")
    hook.Remove("RenderScreenspaceEffects", "arb.LawStartText")
    hook.Remove("RenderScreenspaceEffects", "arb.LawRednessScreen")
    hook.Remove("HUDPaint", "arb.LawCylinder")
    hook.Remove("RenderScreenspaceEffects", "arb.LawCylinder")
    hook.Remove("ArbitrageVoiceStart", "arb.LawStartVoice")
end

-- function PLUGIN:TransferCamPos(id)
--     local data = self.camPos[id]
--     self._camPos = data.pos
--     self._alpha = 1000
--     self._angCam = 0
--     self._movescene = false
--     self.__movescene = 0

--     hook.Add("RenderScreenspaceEffects", "arb.TransferCamPos", function()
--         self._camPos = Lerp(FrameTime(), self._camPos, self.camPosEnd)
--         self._alpha = Lerp(FrameTime() * 3, self._alpha, 0)
--         self.__movescene = Lerp(FrameTime(), self.__movescene, self._movescene and ScrH() * 0.1 or 0)

--         surface.SetDrawColor(0, 0, 0, self._alpha)
--         surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)

--         surface.SetDrawColor(0, 0, 0, 255)
--         surface.DrawRect(-1, -1 - self.__movescene, ScrW() + 2, ScrH() * 0.1)
--         surface.DrawRect(-1, (ScrH() - ScrH() * 0.1) + self.__movescene, ScrW() + 2, ScrH() * 0.1)
--     end)

--     hook.Add("CalcView", "arb.TransferCamPos", function(client, pos, angles, fov)
--         self._angCam = (id % 2 == 1 and (self._angCam + FrameTime() * 15) or (self._angCam - FrameTime() * 15))

--         local view = {
--             origin = self._camPos,
--             angles = data.ang + Angle(0, self._angCam, 0),
--             fov = fov,
--             drawviewer = true
--         }

--         local dist = self._camPos:Distance(self.camPosEnd)
--         if dist <= 50 then
--             if id >= #self.camPos then
--                 hook.Remove("CalcView", "arb.TransferCamPos")
--                 self._alpha = 1000

--                 self:StartPointing()
--             else
--                 self:TransferCamPos(id + 1)
--             end
--         end

--         return view
--     end)
-- end

function PLUGIN:Interruption(client)
    if !IsValid(client) then return end

    -- тут типо анимация должна быть охуенная да?
end

function PLUGIN:Talking(client, anim)
    if !IsValid(client) then return end

    self.animID = anim
    self._entity = client
end

PLUGIN.bulletList = {}
function PLUGIN:CreateBullet(data)
    self.bulletList[#self.bulletList + 1] = data

    return self.bulletList[#self.bulletList], #self.bulletList
end

function PLUGIN:PostDrawTranslucentRenderables()
    if !Arbitrage.lawEnable then return end

    for k, v in pairs(player.GetAll()) do
        local charTeam = Arbitrage.teams.Get(v:Team())
        if !charTeam then continue end

        local emojiList = charTeam.emodjiList
        if emojiList and #emojiList > 0 and v:GetNetVar("arbEmojiShow") then
            local mat = Arbitrage.GetMaterial(v:GetNetVar("emoji", emojiList[1]))

            local size = 1.26

            local w = 45 * size
            local h = 75 * size

            local shift = 28

            do
                local ang = Angle(0, v:EyeAngles()[2] + 90, 90)
                local pos = v:GetPos() + Vector(0, 0, h) + v:EyeAngles():Right() * shift

                cam.Start3D2D(pos, ang, 1) surface.SetDrawColor(255, 255, 255) surface.SetMaterial(mat) surface.DrawTexturedRect(0, 0, w, h) cam.End3D2D()
            end

            do
                local ang = Angle(0, v:EyeAngles()[2] - 90, 90)
                local pos = v:GetPos() + Vector(0, 0, h) + v:EyeAngles():Right() * -shift

                cam.Start3D2D(pos, ang, 1) surface.SetDrawColor(0, 0, 0) surface.SetMaterial(mat) surface.DrawTexturedRectUV(0, 0, w, h, 1, 0, 0, 1) cam.End3D2D()
            end
        end

        --::skip::
    end
end

local bulletColors = {
    Color(255, 61, 96),
    Color(255, 92, 102),
    Color(255, 35, 75)
}

local gradientUp = surface.GetTextureID("vgui/gradient-u")
local gradientDown = surface.GetTextureID("vgui/gradient-d")
local bulletMat = Arbitrage.GetMaterial("danganronpa/law/bullet.png")
local bulletMatL = Arbitrage.GetMaterial("danganronpa/law/bullet_l.png")

function PLUGIN:HUDPaint()
    if !self.placesList[game.GetMap()] then return end

    local client = Arbitrage.Client()
    local var = client:GetNetVar("arbLaw", -1)
    local place = self.placesList[game.GetMap()][var]

    if var >= 0 and place then
        local vec = place.pos - Vector(0, 0, 10)
        local alpha = math.Clamp(255 - client:GetPos():Distance(vec), 0, 255)

        if !Arbitrage.lawEnable and alpha > 0 then
            Arbitrage.evidence.CreateText({
                pos = vec,
                name = "Суд",
                desc = "Ваше место находится тут!",
                class = nil,
                data = "Law"
            })
        end
    end

    if !Arbitrage.lawEnable then return end

    for k, v in pairs(self.bulletList) do
        v.alphato = v.alphato or v.alpha
        v.alphato = Lerp(FrameTime() * 5, v.alphato, v.alpha)

        local col = ColorAlpha(v.color, v.alphato * 0.3)
        local size = v.size / 2

        surface.SetDrawColor(col)
        surface.SetTexture(gradientDown)
        surface.DrawTexturedRect(-ScrW() * 2 + v.x, v.y, ScrW() * 2, size)

        surface.SetDrawColor(col)
        surface.SetTexture(gradientUp)
        surface.DrawTexturedRect(-ScrW() * 2 + v.x, v.y + size * 0.7, ScrW() * 2, size)

        surface.SetDrawColor(col)
        surface.SetMaterial(bulletMat)
        surface.DrawTexturedRect(-ScrW() * 2 + v.x + ScrW() * 2 - 5, v.y + size * 0.7 - (v.size / 2) + 2, v.size * 2.5, v.size)

        surface.SetDrawColor(ColorAlpha(v.color, v.alphato))
        surface.SetMaterial(bulletMatL)
        surface.DrawTexturedRect(-ScrW() * 2 + v.x + ScrW() * 2, v.y + size * 0.7 - (v.size / 2), v.size * 2.5, v.size)

        v.x = Lerp(FrameTime() * v.speed, v.x, ScrW() * 1.4)
    end
end

local tab = {
    ["$pp_colour_addr"] = 0.05,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = -0.2,
    ["$pp_colour_contrast"] = 1.2,
    ["$pp_colour_colour"] = 0.7,
    ["$pp_colour_mulr"] = 0.5,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

function PLUGIN:RenderScreenspaceEffects()
    if !Arbitrage.lawEnable then return end

    DrawColorModify(tab)
end

function PLUGIN:PostDrawOpaqueRenderables()
    if !Arbitrage.lawEnable then return end

    local pos = self.camPosEnd[game.GetMap()]
    if !pos then return end

    local angle = Angle(90, 0, 0)
    local radius = 250
    local seg = 360

    do
        for d = 1, 4 do
            local i = d * 90 + CurTime() * 10 % 360
            local ang = (math.pi * 2) / (seg - 1) * i

            local x = math.sin(ang)
            local y = math.cos(ang)

            local right = angle:Right() * x * radius
            local forward = angle:Up() * y * radius

            local Pos = pos + right + forward
            Pos = Pos + Vector(0, 0, 6)

            local WPos = Pos
            local Ang = WPos - pos
            Ang = Ang:Angle()

            local ang_t = Angle(0, Ang.y, Ang.z)
            ang_t:RotateAroundAxis(ang_t:Forward(), 90)
            ang_t:RotateAroundAxis(ang_t:Right(), 90)

            cam.Start3D2D(Pos, ang_t, 0.3)
                draw.DrawText("class trial", "arb.Font_Nebula_35", 2, 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
                draw.DrawText("class trial", "arb.Font_Nebula_35", 0, 0, Color(253, 8, 53, 255), TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end

function PLUGIN:DrawPhysgunBeam(client, physgun, enabled, target, bone, hitPos)
    if Arbitrage.lawEnable then
        return false
    end
end

function PLUGIN:PrePlayerDraw(client)
    if Arbitrage.lawEnable then
        return true
    end
end

function PLUGIN:BlackScreen(data, speed)
    local alpha = 0

    hook.Add("RenderScreenspaceEffects", "arb.LawBlackScreen", function()
        alpha = Lerp(FrameTime() * (speed * 4), alpha, 257)

        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
    end)

    timer.Simple(data or 5, function()
        hook.Add("RenderScreenspaceEffects", "arb.LawBlackScreen", function()
            alpha = Lerp(FrameTime() * speed, alpha, -3)

            surface.SetDrawColor(0, 0, 0, alpha)
            surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
        end)

        timer.Simple(data + 5, function()
            hook.Remove("RenderScreenspaceEffects", "arb.LawBlackScreen")
        end)
    end)
end

function PLUGIN:CameraTwist()
    hook.Add("CalcView", "arb.LawCameraTwist", function(ply, pos, angles, fov)
        local view = {
            origin = self.camPosEnd[game.GetMap()],
            angles = Angle(0, -CurTime() % 2 * 180, 0),
            fov = fov,
            drawviewer = true
        }

        return view
    end)
end

-- local cylinderMat = Arbitrage.GetMaterial("danganronpa/law/cylinder.png")
-- local cbulletMat = Arbitrage.GetMaterial("danganronpa/law/big_bullet.png")
-- local cbulletMatBlur = Arbitrage.GetMaterial("danganronpa/law/big_bullet_blur.png")
-- function PLUGIN:StartCylinder()
--     local size = ScrH() / 1.3
--     local _size = size
--     local cylinder_x = -size / 2
--     local alpha = 0
--     local cylinder_lerp = 0
--     local _cylinder_lerp = cylinder_lerp
--     local csize = ScrH() / 1.5
--     local c_bullets = {}

--     hook.Add("HUDPaint", "arb.LawCylinder", function()
--         alpha = Lerp(FrameTime() * 5, alpha, 255)
--         cylinder_x = Lerp(FrameTime() * 10, cylinder_x, 0)
--         cylinder_lerp = Lerp(FrameTime() * 10, cylinder_lerp, _cylinder_lerp)
--         size = Lerp(FrameTime() * 10, size, _size)

--         surface.SetDrawColor(255 - 10, 61 - 10, 96 - 10, alpha - 10)
--         surface.SetMaterial(cylinderMat)
--         surface.DrawTexturedRectRotated(cylinder_x + 0 + size / 4, ScrH() - size / 4, size, size, -CurTime() % 20 * 18 - cylinder_lerp)

--         for k, v in pairs(c_bullets) do
--             v.alpha = Lerp(FrameTime() * 15, v.alpha, v._alpha)
--             v.move = Lerp(FrameTime() * 15, v.move, v._move)

--             surface.SetDrawColor(255, 61, 96, v.alpha / 2)
--             surface.SetMaterial(cbulletMatBlur)
--             surface.DrawTexturedRect(v.x + v.move, ScrH() - size / 1.6 + v.y, csize / 2, csize / 2 * 0.2)

--             surface.SetDrawColor(255, 61, 96, v.alpha)
--             surface.SetMaterial(cbulletMat)
--             surface.DrawTexturedRect(v.x + v.move, ScrH() - size / 1.6 + v.y, csize / 2, csize / 2 * 0.2)
--         end
--     end)

--     for i = 1, 3 do
--         timer.Simple(i * 0.5, function()
--             c_bullets[i] = c_bullets[i] or {
--                 text = "Monokuma File" .. i,
--                 x = i * 20,
--                 y = csize / 2 * 0.1 + (i * (csize / 2 * 0.1 + 20)),
--                 move = 0,
--                 _move = size / 3,
--                 alpha = 0,
--                 _alpha = 255,
--             }

--             _cylinder_lerp = _cylinder_lerp - 6

--             timer.Simple(0.1, function()
--                 _cylinder_lerp = _cylinder_lerp + 55
--             end)
--         end)

--         timer.Simple(2.5, function()
--             _size = ScrH() / 2

--             for k, v in pairs(c_bullets) do
--                 if k == 1 then
--                     -- eh...
--                 else
--                     c_bullets[k]._alpha = 0
--                 end
--             end
--         end)
--     end
-- end

surface.CreateFont( "arb.LawBulletFont", {
    font = "Futura PT Book",
    extended = true,
    size = ScreenScale(12),
    weight = 400,
    --italic = true,
})

local mat = Arbitrage.GetMaterial("danganronpa/law/cylinder.png")
local bullet = Arbitrage.GetMaterial("danganronpa/law/big_bullet.png")
local bulletblur = Arbitrage.GetMaterial("danganronpa/law/big_bullet_blur.png")
local interface = Arbitrage.GetMaterial("danganronpa/law/interface.png")

local moving = 0
local _moving = moving

local function hideRender()
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
end

local function showRender()
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
end

local function disableRender()
    render.SetStencilEnable(false)
    render.ClearStencil()
end


function PLUGIN:StartCylinder()
    local cyl = {}
    for i = 1, 4 do
        cyl[i] = 100
    end

    local cyl2 = {}
    for k, v in pairs(cyl) do
        cyl2[k] = v
    end

    local function RegNewCylinder()
        local x = 0
        hook.Add("RenderScreenspaceEffects", "arb.LawCylinder", function()
            x = Lerp(FrameTime() * 1, x, ScrW() / 1)

            local w, h = ScrW(), ScrH()
            local center = Vector(w / 2, h / 2)
            local alpha = math.abs(math.sin(CurTime() * 7) * 255)

            local bulletSizeW = ScrW() * 0.2
            local bulletSizeH = ScrH() * 0.08

            hideRender()

            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, 0, x, h)

            showRender()

            do
                local center2 = Vector(w / 2, h / 1.95)
                local m = Matrix()
                m:Translate( center2 )
                m:Rotate(Angle( 0, -50, 0 ))
                m:Scale(Vector(0.9, 1.3, 1))
                m:Translate( -center2 )

                cam.PushModelMatrix(m)
                    surface.SetDrawColor(255, 61, 96, 200)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRectRotated(ScrW() * 0.052, ScrH() * 0.24, ScrW() * 0.104, ScrW() * 0.104, -CurTime() % 360 * 10)
                cam.PopModelMatrix()
            end

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(interface)
            surface.DrawTexturedRect(ScrW() * 0.035, ScrH() * 0.61, ScrW() * 0.28125, ScrH() * 0.41666666666)

            do
                local m = Matrix()
                m:Translate(center)
                m:Rotate(Angle(0, -3, 0))
                m:Translate(-center)

                cam.PushModelMatrix(m)
                    surface.SetDrawColor(255, 61, 96, alpha)
                    surface.SetMaterial(bulletblur)
                    surface.DrawTexturedRect(ScrW() * 0.11, ScrH() * 0.789, bulletSizeW, bulletSizeH)

                    surface.SetDrawColor(208, 61, 88)
                    surface.SetMaterial(bullet)
                    surface.DrawTexturedRect(ScrW() * 0.11, ScrH() * 0.789, bulletSizeW, bulletSizeH)

                    draw.DrawText("Monokuma File 1", "arb.LawBulletFont", ScrW() * 0.13, ScrH() * 0.805, Color(0, 0, 0), TEXT_ALIGN_LEFT)
                cam.PopModelMatrix()
            end

            disableRender()
        end)
    end


    local function RegCylinder()
        local x = 0
        local _x = 1.5

        local w, h = ScrW(), ScrH()
        --local alpha = math.abs(math.sin(CurTime() * 7) * 255)

        local bulletSizeW = ScrW() * 0.15
        local bulletSizeH = ScrH() * 0.057

        hook.Add("RenderScreenspaceEffects", "arb.LawCylinder", function()
            x = Lerp(FrameTime() * 10, x, _x)
            _moving = Lerp(FrameTime() * 10 , _moving, moving)
            local center = Vector(w / 2.1, h / x)

            do
                local m = Matrix()
                m:Translate( center )
                m:Rotate(Angle( 0, -50, 0 ))
                m:Scale(Vector(0.9, 1.3, 1))
                m:Translate( -center )

                cam.PushModelMatrix(m)
                    surface.SetDrawColor(255, 61, 96, 200)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRectRotated(ScrW() * 0.152, ScrH() * 0.34, ScrW() * 0.304, ScrW() * 0.304, -CurTime() % 360 * 10 - _moving)
                cam.PopModelMatrix()
            end

            for i = 1, 4 do
                timer.Simple(i * 0.3, function()
                    if cyl[i] == -1 or cyl[i] == 101 then return end
                    cyl[i] = -1

                    timer.Simple(0.1, function()
                        moving = moving + 50
                    end)
                end)

                cyl2[i] = Lerp(FrameTime() * 20, cyl2[i], cyl[i])

                local center2 = Vector(w * -1, h * cyl2[i])

                local m = Matrix()
                m:Translate(center2)
                m:Rotate(Angle(0, -3, 0))
                m:Translate(-center2)

                cam.PushModelMatrix(m)
                    surface.SetDrawColor(255, 61, 96, 216)
                    surface.SetMaterial(bulletblur)
                    surface.DrawTexturedRect(i * 20 + ScrW() * 0.11, ScrH() * 0.78 + (i - 1) * (ScrH() * 0.05), bulletSizeW, bulletSizeH)

                    surface.SetDrawColor(208, 61, 88)
                    surface.SetMaterial(bullet)
                    surface.DrawTexturedRect(i * 20 + ScrW() * 0.11, ScrH() * 0.78 + (i - 1) * (ScrH() * 0.05), bulletSizeW, bulletSizeH)

                    draw.DrawText("Monokuma File " .. i, "arb.LawBulletFont", i * 20 + ScrW() * 0.125, ScrH() * 0.788 + (i - 1) * (ScrH() * 0.05), Color(0, 0, 0), TEXT_ALIGN_LEFT)
                cam.PopModelMatrix()
            end
        end)

        timer.Simple(3, function()
            _x = 0
            for i = 1, 4 do
                cyl[i] = 101
            end

            timer.Simple(0.2, function() RegNewCylinder() end)
        end)
    end

    RegCylinder()
end


netstream.Hook("arb.StartLaw", function()
    PLUGIN:ReplaceVariables()
    PLUGIN:Clear()

    PLUGIN:BlackScreen(4, 1)
    timer.Simple(4, function()
        Arbitrage.lawEnable = true
        PLUGIN:RednessScreen()
        PLUGIN:CameraTwist()

        timer.Simple(1, function()
            PLUGIN:BlackScreen(1, 3)
        end)
    end)

    timer.Simple(6, function()
        hook.Remove("CalcView", "arb.LawCameraTwist")
        PLUGIN:TransferCamPos(1)
    end)

    timer.Simple(6.5, function()
        for i = 1, 5 do
            timer.Simple(i * math.random(100, 150) / 1000, function()
                local bulletData, id = PLUGIN:CreateBullet({
                    x = 0,
                    y = ScrH() / 2 + math.random(-10, 10) * 20 + 35,
                    size = math.random(15, 30),
                    color = table.Random(bulletColors),
                    alpha = math.random(200, 255),
                    speed = 5
                })

                timer.Simple(math.random(100, 300) / 200, function()
                    if !bulletData then return end

                    bulletData.alpha = 0

                    timer.Simple(1, function()
                        PLUGIN.bulletList[id] = nil
                    end)
                end)
            end)
        end

        timer.Simple(0.15, function()
            PLUGIN:SendIntroText()
        end)
    end)

    timer.Simple(9, function()
        hook.Remove("RenderScreenspaceEffects", "arb.LawIntroText")
        PLUGIN:SendStartText()

        timer.Simple(1.5, function()
            hook.Remove("CalcView", "arb.LawTransferCamPos")
            PLUGIN:StartPointing()

            for i = 1, 8 do
                timer.Simple(i * math.random(100, 150) / 1000, function()
                    local bulletData, id = PLUGIN:CreateBullet({
                        x = 0,
                        y = ScrH() / 2 + math.random(-10, 10) * 50,
                        size = math.random(10, 75),
                        color = table.Random(bulletColors),
                        alpha = math.random(200, 255),
                        speed = 3
                    })

                    timer.Simple(0.3, function()
                        if !bulletData then return end

                        bulletData.alpha = 0

                        timer.Simple(1, function()
                            PLUGIN.bulletList[id] = nil
                        end)
                    end)
                end)
            end

            timer.Simple(2, function()
                --PLUGIN:StartCylinder()
                --RegCylinder()
                PLUGIN:StartCylinder()
            end)
        end)
    end)
end)

netstream.Hook("arb.EndLaw", function()
    PLUGIN:ReplaceVariables()
    PLUGIN:BlackScreen(4, 1)

    timer.Simple(2, function()
        Arbitrage.lawEnable = false
        PLUGIN:Clear()
    end)

    if IsValid(Arbitrage.gui.lawaction) then
        Arbitrage.gui.lawaction:AlphaTo(0, 0.5, 0, function()
            Arbitrage.gui.lawaction:Remove()
        end)
    end

    if IsValid(Arbitrage.gui.playertable) then
        Arbitrage.gui.playertable:AlphaTo(0, 0.5, 0, function()
            Arbitrage.gui.playertable:Remove()
        end)
    end

    if IsValid(Arbitrage.gui.timer) then
        Arbitrage.gui.timer:AlphaTo(0, 0.5, 0, function()
            Arbitrage.gui.timer:Remove()
        end)
    end
end)

netstream.Hook("arb.ClearLaw", function()
    Arbitrage.lawEnable = false

    PLUGIN:Clear()
    PLUGIN:ReplaceVariables()

    if IsValid(Arbitrage.gui.lawaction) then
        Arbitrage.gui.lawaction:AlphaTo(0, 0.5, 0, function()
            Arbitrage.gui.lawaction:Remove()
        end)
    end

    if IsValid(Arbitrage.gui.playertable) then
        Arbitrage.gui.playertable:AlphaTo(0, 0.5, 0, function()
            Arbitrage.gui.playertable:Remove()
        end)
    end

    if IsValid(Arbitrage.gui.timer) then
        Arbitrage.gui.timer:AlphaTo(0, 0.5, 0, function()
            Arbitrage.gui.timer:Remove()
        end)
    end
end)




netstream.Hook("arb.DrawSprites", function()
    Arbitrage.drawSprites = true
end)

netstream.Hook("arb.LawInterruption", function(client)
    PLUGIN:Interruption(client)
end)

netstream.Hook("arb.LawTalking", function(client, anim)
    PLUGIN:Talking(client, anim)

    if IsValid(Arbitrage.gui.playertable) then
        Arbitrage.gui.playertable:SetPlayer(client)
    end
end)

netstream.Hook("arb.ShowEvidence", function(client, data, indx)
    local d = Evidence.icons
    local icon = Arbitrage.GetMaterial(d[data] and d[data] or d[1])

    local prestation = vgui.Create("arb.Prestation")
    prestation:AddMaterial(icon)

    local panel = Arbitrage.gui.lawaction
    if !IsValid(panel) then return end

    if !panel.evidences[indx] then
        panel.evidences[indx] = client:Name()
    end

    timer.Simple(1, function()
        if panel.select == 2 then
            for i = 1, 2 do -- upd
                panel.panels[i].DoClick()
            end
        end
    end)
end)