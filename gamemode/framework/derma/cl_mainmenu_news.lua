local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(S(410), S(133))
    self:SetAlpha(0)
    self:AlphaTo(255, 1)

    self.stored = {}
    self.selectIdx = 1

    local topPanel = self:Add("Panel")
    topPanel:Dock(FILL)
    topPanel:DockMargin(0, 0, 0, S(16))

    local leftArrowMat = Material("asterion/academy/ui/icons/arrow2_left.png", "smooth")
    local leftButton = topPanel:Add("DButton")
    leftButton:SetText("")
    leftButton:Dock(LEFT)
    leftButton:SetWide(S(25))
    leftButton.alpha = 0.4
    leftButton.DoClick = function()
        if self.selectIdx <= 1 then return end

        self:OpenNew(self.selectIdx - 1)
    end
    leftButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or (self.selectIdx <= 1 and 0.1 or 0.4))

        local color = Arbitrage.theme:GetVisForeground()
        surface.SetDrawColor(color.r, color.g, color.b, 255 * this.alpha)
        surface.SetMaterial(leftArrowMat)
        surface.DrawTexturedRect(0, h / 2 - w / 2, w, w)
    end

    local rightArrowMat = Material("asterion/academy/ui/icons/arrow2_right.png", "smooth")
    local rightButton = topPanel:Add("DButton")
    rightButton:SetText("")
    rightButton:Dock(RIGHT)
    rightButton:SetWide(S(25))
    rightButton.alpha = 0.4
    rightButton.DoClick = function()
        if self.selectIdx >= #self.stored then return end

        self:OpenNew(self.selectIdx + 1)
    end
    rightButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha,
            this:IsHovered() and 1 or (self.selectIdx >= #self.stored and 0.1 or 0.4))

        local color = Arbitrage.theme:GetVisForeground()
        surface.SetDrawColor(color.r, color.g, color.b, 255 * this.alpha)
        surface.SetMaterial(rightArrowMat)
        surface.DrawTexturedRect(0, h / 2 - w / 2, w, w)
    end

    self.imagePanel = topPanel:Add("DButton")
    self.imagePanel:SetText("")
    self.imagePanel:SetAlpha(0)
    self.imagePanel:Dock(FILL)
    self.imagePanel:DockMargin(S(10), 0, S(10), 0)
    self.imagePanel.Paint = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(0, 0, w, h)

        local new = self.stored[self.selectIdx]
        if !new then return end

        local mat = self.stored[self.selectIdx].mat
        if mat then
            local texWidth = mat:Width()
            local texHeight = mat:Height()

            local widthRatio = w / texWidth
            local heightRatio = h / texHeight

            local drawWidth, drawHeight
            local x, y

            local scale = math.max(widthRatio, heightRatio)

            drawWidth = texWidth * scale
            drawHeight = texHeight * scale

            x = (w - drawWidth) / 2
            y = (h - drawHeight) / 2

            -- print("test:", drawHeight)
            -- print("h:", h)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(x, y, drawWidth, drawHeight)
        end
    end
    self.imagePanel.DoClick = function()
        local new = self.stored[self.selectIdx]
        if !new then return end

        new.callback()
    end

    self:InitNews()
    self:RebuildFlippingPanel()
    self:OpenNew(1)
end

function PANEL:InitNews()
    self:AddNew(1, "https://i.ibb.co/BVstSKBc/MAX-PUMP-NEWS.png", function()
        gui.OpenURL("https://discord.com/channels/1507709773427245206/1508055078731255941/1508480995178053794")
    end)

    self:AddNew(2, "https://i.ibb.co/4Rvj4ddQ/Max-Payne-RELEASE.png", function()
        gui.OpenURL("https://discord.gg/Ynx4VkEbZmd")
    end)

    -- self:AddNew(3, "https://i.ibb.co/pjxbZmSW/STEAM-0-1-91455907-1760181303.jpg", function()
    --     gui.OpenURL("https://discord.com/channels/744899300277878796/1116322080531697706/1305513992701345824")
    -- end)

    -- self:AddNew(4, "https://i.ibb.co/PGRVQ9Kw/STEAM-0-1-127526733-1760159820.jpg", function()
    --     gui.OpenURL("https://discord.com/channels/744899300277878796/1116322080531697706/1305513992701345824")
    -- end)
end

function PANEL:AddNew(idx, imageUrl, callback)
    self.stored[idx] = {
        url = imageUrl,
        mat = nil,
        callback = callback
    }

    asterionlib.downloader:Image(imageUrl, function(mat)
        self.stored[idx].mat = mat
    end)
end

function PANEL:OpenNew(idx)
    self.selectIdx = idx

    self.imagePanel:SetAlpha(0)
    self.imagePanel:AlphaTo(255, 0.25)
end

function PANEL:RebuildFlippingPanel()
    if IsValid(self.flipPanel) then
        self.flipPanel:Remove()
    end

    self.flipPanel = self:Add("Panel")
    self.flipPanel:Dock(BOTTOM)
    self.flipPanel:SetTall(S(10))

    for idx, new in ipairs(self.stored) do
        local button = self.flipPanel:Add("DButton")
        button:SetText("")
        button:Dock(LEFT)
        button:SetWide(self.flipPanel:GetTall())
        button.color = Arbitrage.theme:GetVisBackground()
        button.Paint = function(this, w, h)
            this.color = LerpColor(FrameTime() * 10, this.color,
                (idx == self.selectIdx or this:IsHovered()) and Arbitrage.theme:GetVisForeground() or
                Arbitrage.theme:GetVisBackground())

            surface.SetDrawColor(this.color)
            surface.DrawRect(0, 0, w, h)
        end
        button.DoClick = function()
            self:OpenNew(idx)
        end

        if idx == 1 then
            local wide = self:GetWide() / 2 - (button:GetWide() * #self.stored)

            button:DockMargin(wide, 0, 0, 0)
        else
            button:DockMargin(S(10), 0, 0, 0)
        end
    end
end

function PANEL:Paint()
end

vgui.Register("arb.mainmenu:News", PANEL, "Panel")
