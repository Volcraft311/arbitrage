local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.alpha = 0
    self.alphaStandUp = 0
    self.timeStart = RealTime()
    self.oldHealth = LocalPlayer():Health()
    self.alphaDamage = 0
    self.standUpTime = nil
end

function PANEL:SetEntityIdx(index)
    self.ragdoll = index
end

function PANEL:SetStandUpTime(time)
    self.standUpTime = isnumber(time) and time or nil
end

function PANEL:GetRagdoll()
    local idx = self.ragdoll
    local entity = idx and Entity(idx) or nil

    entity = (idx and (IsValid(entity) and entity:GetClass() == "prop_ragdoll")) and entity or nil
    if !IsValid(entity) then return end

    if entity:EntIndex() == tonumber(LocalPlayer():GetNetVar("ragdoll")) then
        return entity
    end
end

function PANEL:SendNetStandUp()
    if isnumber(self.standUpTime) and self.standUpTime <= -1 then return end
    if IsValid(Arbitrage.gui.action) then return end

    if RealTime() <= self.timeStart + 5 then return end

    local ragdoll = self:GetRagdoll()
    if RealTime() >= (self.cdNetTime or 0) and IsValid(ragdoll) then
        netstream.Start("RagdollSystem:StandUp", ragdoll, self.standUpTime)

        self.cdNetTime = RealTime() + 2
    end
end

function PANEL:RenderPaint(client, w, h, ragdoll)
    local origin = client:EyePos()
    local angles = client:EyeAngles()
    if IsValid(ragdoll) then
        local idx = ragdoll:LookupAttachment("eyes")

        if idx then
            local attach = ragdoll:GetAttachment(idx)

            if attach then
                origin = attach.Pos
                angles = attach.Ang
            end
        end

        local x, y = self:GetPos()
        local old = DisableClipping(true)
        render.RenderView( {
            origin = origin,
            angles = angles,
            x = x,
            y = y,
            w = w,
            h = h
        })
        DisableClipping(old)
    end
end

function PANEL:BlurPaint(ft, w, h, ragdoll)
    self.alpha = Lerp(ft, self.alpha, (IsValid(ragdoll) and !self.bClose) and 500 or -10)

    if self.alpha >= 0.05 then
        asterionlib.DrawBlurAt(0, 0, w, h, 30 + self.alphaDamage, nil, self.alpha + self.alphaDamage)
    elseif self.alpha <= -5 then
        self:Remove()
    end
end

function PANEL:DamagePaint(client, w, h)
    local ft = FrameTime()

    if client:Health() < self.oldHealth then
        self.alphaDamage = 800
        self.timeStart = RealTime() + 5
    end

    self.oldHealth = client:Health()

    self.alphaDamage = Lerp(ft * 1.5, self.alphaDamage, 0)
    if self.alphaDamage > 0.1 then
        surface.SetDrawColor(0, 0, 0, self.alphaDamage * 0.3)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 0, 0, self.alphaDamage * 0.1)
        surface.DrawRect(0, 0, w, h)
    end
end

function PANEL:TextPaint(ft, w, h, ragdoll)
    local _, height = draw.SimpleText("Ваш персонаж находится без сознания" .. ("."):rep(RealTime() * 1.5 % 3), "arb.Font_FuturaPTDemi_14", w / 2, h * 0.7, Color(255, 255, 255, self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if !IsValid(ragdoll) then return end

    if self.standUpTime != nil then return end
    if isnumber(self.standUpTime) and self.standUpTime <= -1 then return end

    local length = ragdoll:GetVelocity():Length()
    local bAllowStand = length <= 1

    self.alphaStandUp = Lerp(ft * 5, self.alphaStandUp, (RealTime() > self.timeStart + 5 and bAllowStand and !IsValid(Arbitrage.gui.action)) and 255 or 0)

    if self.alphaStandUp >= 0.5 then
        draw.SimpleText("Нажмите 'ПРОБЕЛ', чтобы встать", "arb.Font_FuturaPTBook_10", w / 2, h * 0.7 + height, Color(255, 255, 255, self.alphaStandUp), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if self.alphaStandUp >= 150 and input.IsKeyDown(KEY_SPACE) and !vgui.CursorVisible() then
            self:SendNetStandUp()
        end
    end
end

function PANEL:AutoStandUp(ragdoll)
    if self.standUpTime == nil then return end
    if isnumber(self.standUpTime) and self.standUpTime <= -1 then return end

    if !IsValid(ragdoll) then return end

    local length = ragdoll:GetVelocity():Length()
    local bAllowStand = length <= 1

    if bAllowStand then
        self:SendNetStandUp()
    end
end

function PANEL:Paint(w, h)
    local ft = FrameTime()
    local client = LocalPlayer()
    local ragdoll = self:GetRagdoll()

    self:RenderPaint(client, w, h, ragdoll)

    self:BlurPaint(ft, w, h, ragdoll)
    self:TextPaint(ft, w, h, ragdoll)
    self:DamagePaint(client, w, h)

    self:AutoStandUp(ragdoll)
end

vgui.Register("RagdollSystem:FallOverMenu", PANEL, "DPanel")