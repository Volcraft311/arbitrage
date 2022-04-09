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

local sliderMat = Arbitrage.GetMaterial("danganronpa/ui/slider.png")

local PANEL = {}

function PANEL:Init()
    local sizeX, sizeY, sizeT = W(1200), H(800), H(46)

    Arbitrage.gui.wardrobe = self

    self:SetPos(ScrW() / 2 - sizeX / 2, ScrH() / 2 - sizeY / 2)
    self:SetSize(0, sizeT)
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.skin = 0
    self.bg = {}
    self.categoryPanels = {}

    self:SizeTo(sizeX, sizeT, 0.3, 0, -1, function()
        self:SizeTo(self:GetWide(), sizeY, 0.3)
    end)

    local titlePanel = self:Add("DPanel")
    titlePanel:SetTall(sizeT)
    titlePanel:Dock(TOP)
    titlePanel.Paint = function(_, w, h)
        local tW = draw.SimpleText("Гардероб", "arb.Font_FuturaPTDemi_13", 71, H(5), Color(255, 234, 238), TEXT_ALIGN_LEFT)
        draw.SimpleText("Смените образ своего персонажа", "arb.Font_FuturaPTBook_7", tW + 71 + W(22), H(19), Color(255, 234, 238, 30), TEXT_ALIGN_LEFT)
    end

    local closeButton = titlePanel:Add("DButton")
    closeButton:SetText("")
    closeButton:SetWide(sizeT)
    closeButton:Dock(RIGHT)
    closeButton.alpha = 0.1
    closeButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 5, _.alpha, _:IsHovered() and 1 or 0.1)

        draw.SimpleText("X", "arb.Font_FuturaPTDemi_10", w / 2, H(10), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
    end
    closeButton.DoClick = function()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end

    local leftPanel = self:Add("Panel")
    leftPanel:SetWide(sizeX * 0.3)
    leftPanel:Dock(LEFT)

	self.modelPanel = leftPanel:Add( "DModelPanel" )
	self.modelPanel:Dock(FILL)
	self.modelPanel:SetFOV(40)
	self.modelPanel:SetDirectionalLight(BOX_RIGHT, Color( 255, 160, 80, 255 ))
	self.modelPanel:SetDirectionalLight(BOX_LEFT, Color( 80, 160, 255, 255 ))
	self.modelPanel:SetAmbientLight(Vector( -64, -64, -64 ))
	self.modelPanel:SetAnimated(true)
	self.modelPanel.Angles = Angle(0, 50, 0)

	self.modelPanel.DragMousePress = function(this)
		this.PressX, this.PressY = gui.MousePos()
		this.Pressed = true
	end

	self.modelPanel.DragMouseRelease = function(this)
		this.Pressed = false
	end

	self.modelPanel.LayoutEntity = function(this, entity)
		local scrW, scrH = ScrW(), ScrH()
	    local xRatio = gui.MouseX() / scrW
	    local yRatio = gui.MouseY() / scrH
	    local x, _ = this:LocalToScreen(sizeX / 2)
	    local xRatio2 = x / scrW

	    entity:SetPoseParameter("head_pitch", yRatio * 90 - 30)
	    entity:SetPoseParameter("head_yaw", (xRatio - xRatio2) * 90 - 5)
	    entity:SetIK(false)

		if this.Pressed then
			local mx = gui.MousePos()
			this.Angles = this.Angles - Angle(0, ((this.PressX or mx) - mx) / 2, 0)

			this.PressX, this.PressY = gui.MousePos()
		end

		entity:SetAngles(this.Angles)
	end

	local rightPanel = self:Add("Panel")
	rightPanel:Dock(FILL)
	rightPanel:DockMargin(W(50), 0, W(200), 0)

	self.bgPanel = rightPanel:Add("DScrollPanel")
	self.bgPanel:Dock(FILL)
	self.bgPanel:DockMargin(0, 50, 0, 0)

	local bar = self.bgPanel:GetVBar()
	bar:SetWide(30)
	bar:DockMargin(0, 0, 0, 0)

	bar.Paint = function(_, w, h)
	    surface.SetDrawColor(255, 255, 255, 3)
	    surface.DrawRect(20 + 7, 30, w, h - 60)
	end
	bar.btnUp.Paint = function(_, w, h) end
	bar.btnDown.Paint = function(_, w, h) end
	bar.btnGrip.Paint = function(_, w, h)
	    surface.SetDrawColor(255, 255, 255)
	    surface.DrawRect(20 + 7, 0, w, h)
	end

	local saveButton = rightPanel:Add("DButton")
	saveButton:SetText("")
	saveButton:SetTall(H(30))
	saveButton:Dock(BOTTOM)
	saveButton:DockMargin(0, 0, 0, H(10))
	saveButton.alpha = 0.1
	saveButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.1)

	    surface.SetDrawColor(15, 5, 6, 255 * _.alpha)
	    surface.DrawRect(0, 0, w, h)

	    surface.SetDrawColor(99, 17, 32, 255 * _.alpha)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    draw.SimpleText("Сохранить изменения", "arb.Font_FuturaPTBook_8", w / 2, H(2), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
	end
	saveButton.DoClick = function()
	    netstream.Start("arb.WardrobeChange", self.bg, self.skin)

	    self:SizeTo(self:GetWide(), 0, 0.2)
	    self:AlphaTo(0, 0.2, 0, function()
	        self:Remove()
	    end)
	end
end

function PANEL:SetData(model)
    self.modelPanel:SetModel(model)
    self.modelPanel.Entity:SetAngles(Angle(0, 45, 0))

    local ent = self.modelPanel.Entity

    if ent:SkinCount() > 1 then
        local category = self:AddCategory("Скин")

        local iconLayout = category:Add("DIconLayout")
        iconLayout:Dock(FILL)
        iconLayout:DockMargin(0, H(28), 0, 0)
        iconLayout:SetSpaceX(W(8))
        iconLayout:SetSpaceY(H(3))

        for i2 = 0, ent:SkinCount() - 1 do
            local ListItem = iconLayout:Add("DButton")
            ListItem:SetText("")
            ListItem:SetSize(W(66), H(30))
            ListItem.alpha = 0.1
            ListItem.Paint = function(_, w, h)
                local bSelect = self.skin == i2
                _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or bSelect) and 1 or 0.05)

                surface.SetDrawColor(15, 5, 6, 255 * _.alpha)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(99, 17, 32, 255 * _.alpha)
                surface.DrawOutlinedRect(0, 0, w, h, 2)

                draw.SimpleText(i2, "arb.Font_FuturaPTBook_8", w / 2, H(2), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
            end
            ListItem.DoClick = function()
                ent:SetSkin(i2)
                self.skin = i2
            end
        end

        local size = category:GetTall()
        local t = math.ceil(ent:SkinCount() / 8)

        category:SetTall(size + t * H(30) + t * H(6))
    end

    for i = 0, ent:GetNumBodyGroups() - 1 do
        local count = ent:GetBodygroupCount(i)
        if count <= 1 then continue end
        count = count - 1

        local name = ent:GetBodygroupName(i)

        self.bg[name] = 0

        local category = self:AddCategory(name)

        local iconLayout = category:Add("DIconLayout")
        iconLayout:Dock(FILL)
        iconLayout:DockMargin(0, H(28), 0, 0)
        iconLayout:SetSpaceX(W(8))
        iconLayout:SetSpaceY(H(3))

        for i2 = 0, count do
            local ListItem = iconLayout:Add("DButton")
            ListItem:SetText("")
            ListItem:SetSize(W(66), H(30))
            ListItem.alpha = 0.1
            ListItem.Paint = function(_, w, h)
                local bSelect = self.bg[name] == i2
                _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or bSelect) and 1 or 0.05)

                surface.SetDrawColor(15, 5, 6, 255 * _.alpha)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(99, 17, 32, 255 * _.alpha)
                surface.DrawOutlinedRect(0, 0, w, h, 2)

                draw.SimpleText(i2, "arb.Font_FuturaPTBook_8", w / 2, H(2), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
            end
            ListItem.DoClick = function()
                ent:SetBodygroup(i, i2)
                self.bg[name] = i2
            end
        end

        local size = category:GetTall()
        local t = math.ceil(count / 8)

        category:SetTall(size + t * H(30) + t * H(6))
    end
end

function PANEL:AddCategory(name)
    self.categoryPanels[name] = self.bgPanel:Add("DPanel")
    self.categoryPanels[name]:Dock(TOP)
    self.categoryPanels[name]:SetTall(H(28))
    self.categoryPanels[name].Paint = function(_, w, h)
        surface.SetDrawColor(255, 234, 238, 20)
        surface.DrawRect(0, h - 2, w, 2)

        draw.SimpleText(name, "arb.Font_FuturaPTBook_7", 0, 0, Color(255, 234, 238, 30), TEXT_ALIGN_LEFT)
    end

    return self.categoryPanels[name]
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(4, 2, 2)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("arb.OpenWardrobe", PANEL, "EditablePanel")


concommand.Add("arb_close_wardrobemenu", function(client, command, arguments)
    if IsValid(Arbitrage.gui.wardrobe) then
        Arbitrage.gui.wardrobe:Remove()
    end
end)