local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.bAddEntity = false
    self.bClose = false
    self.blurAlpha = 0
    self.darkAlpha = 0
    self.darkLowerAlpha = 0
    self.bedColdDown = RealTime()

    self.eyePos = Vector(0, 0, 0)
    self.eyeAng = Angle(0, 0, 0)
end

function PANEL:SetBedData(entity, eyePos, eyeAng)
    self.bedEntity = entity

    -- убираем отрисовку локального игрока когда мы ложимься, чтобы его не было видно)
    if IsValid(entity) then
        local client = LocalPlayer()

        client:DrawHide()

        timer.Simple(5, function()
            client:ReDraw()
        end)

        self.bAddEntity = true
    end

    if eyePos then
        self.eyePos = eyePos
    end

    if eyeAng then
        self.eyeAng = eyeAng
    end
end

function PANEL:GetBedEntity()
    local entity = self.bedEntity
    if IsValid(entity) then
        return entity
    end
end

function PANEL:RenderPaint(client, w, h, entity)
    if !IsValid(entity) then return end

    local ft = FrameTime()
    local posinfo = BedSystem.allowBed[entity:GetModel()].eye

    self.eyePos = LerpVector(ft * 1, self.eyePos, posinfo.pos(entity:GetPos(), entity:GetAngles()))

    for i = 1, 3, 2 do
        self.eyeAng[i] = Lerp(ft * 1, self.eyeAng[i], entity:GetAngles()[i] + posinfo.ang[i])
    end

    local x, y = self:GetPos()
    local old = DisableClipping(true)
    render.RenderView( {
        origin = self.eyePos,
        angles = self.eyeAng,
        x = x,
        y = y,
        w = w,
        h = h,
        drawviewmodel = false
    })
    DisableClipping(old)
end

function PANEL:BlurPaint(w, h, entity)
    local ft = FrameTime()

    self.blurAlpha = Lerp(ft, self.blurAlpha, !self.bClose and 500 or -1)
    self.darkAlpha = Lerp(ft, self.darkAlpha, !self.bClose and 256 or -100)
    self.darkLowerAlpha = Lerp(ft, self.darkLowerAlpha, (self.bAddEntity and RealTime() >= self.bedColdDown) and 256 or -100)

    if self.blurAlpha >= 0.05 then
        asterionlib.DrawBlurAt(0, 0, w, h, 30, nil, self.blurAlpha)
    end

    if self.darkAlpha > 0.05 then
        surface.SetDrawColor(0, 0, 0, self.darkAlpha)
        surface.DrawRect(0, 0, w, h)

        local _w, _h = draw.SimpleText("Вы спите" .. string.rep(".", RealTime() * 1 % 4), "arb.Font_FuturaPTDemi_20", w / 2, h * 0.35, Color(255, 255, 255, self.darkAlpha), TEXT_ALIGN_CENTER)
        draw.SimpleText("Нажмите 'SPACE' чтобы проснуться", "arb.Font_FuturaPTBook_10", w / 2, h * 0.9, Color(255, 255, 255, self.darkLowerAlpha), TEXT_ALIGN_CENTER)
    end
end

function PANEL:Paint(w, h)
    local client = LocalPlayer()
    local entity = self:GetBedEntity()

    self:RenderPaint(client, w, h, entity)
    self:BlurPaint(w, h, entity)

    if input.IsKeyDown(KEY_SPACE) and RealTime() >= self.bedColdDown then
        netstream.Start("BedSystem:GetUpBed")

        self.bedColdDown = RealTime() + 10
    end
end

vgui.Register("BedSystem:Menu", PANEL, "DPanel")