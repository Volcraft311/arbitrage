local PANEL = {}

local stagesData = {
    ["category"] = function(panel)
        local parent = panel:GetParent()

        if IsValid(panel.categoryPanel) then
            panel.categoryPanel:Remove()
        end

        panel.categoryOpPanel = parent:RegisterCategory(panel, panel:GetWide() - W(150) - W(336), H(60), W(336), H(62))
        :AddButton("Претенденты", W(180), function()
            if IsValid(panel.charactersPanel) then panel.charactersPanel:Remove() end
            if IsValid(panel.charactersInfo) then panel.charactersInfo:Remove() end

            panel.titleText = "ВЫБОР ГЛАВЫ"
            panel.titleDesc = "Выбираем класс претендентов"
            panel.titleAlpha = 0

            panel.categoryPanel = panel:Add("Panel")
            panel.categoryPanel:SetPos(ScrW() / 2 - W(1480) / 2, H(270))
            panel.categoryPanel:SetSize(W(1480), H(540))

            panel:InitCategory()
        end, true)
        :AddSlash()
        :AddButton("Ведущие", W(125), function()
            local data = {}

            for k, v in pairs(Arbitrage.teams.data) do
                v.key = k

                if v.monokuma then
                    data[#data + 1] = v
                end
            end

            panel:OpenStages(false, "character", data)
            panel.select = "monokuma"
        end)
    end,
    ["character"] = function(panel, data)
        local parent = panel:GetParent()

        panel.titleText = "ВЫБОР ПРЕТЕНДЕНТА"
        panel.titleDesc = "Выбираем, за кого будем играть"
        panel.titleAlpha = 0

        panel.categoryPanel:Remove()

        panel.charactersPanel = panel:Add("DIconLayout")
        panel.charactersPanel:SetZPos(101)
        panel.charactersPanel:SetPos(W(238), H(210))
        panel.charactersPanel:SetSize(W(673), H(660))
        panel.charactersPanel:SetSpaceY(Arbitrage.ResolutionH(35))
        panel.charactersPanel:SetAlpha(0)
        panel.charactersPanel:AlphaTo(255, 0.5)
        panel.charactersPanel.character = -1

        local parsed = Arbitrage.markup.Parse("<font=arb.Font_FuturaPTBook_7><img=materials/danganronpa/ui/warning.png, 15x15, 255, 255, 255><colour=255,61,96,255> Данный персонаж уже выбран</colour></font>")
        local parsed2 = Arbitrage.markup.Parse("<font=arb.Font_FuturaPTBook_7><img=materials/danganronpa/ui/warning.png, 15x15, 255, 255, 255><colour=255,61,96,255> Данный персонаж доступен лишь игровым мастерам</colour></font>")

        panel.charactersInfo = panel:Add("DPanel")
        panel.charactersInfo:SetZPos(100)
        panel.charactersInfo:SetPos(ScrW() - W(220) - W(660), H(210))
        panel.charactersInfo:SetSize(W(660), H(660))
        panel.charactersInfo.alpha = 0
        panel.charactersInfo.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 2, _.alpha, 1)

            if panel.charactersPanel.character == -1 then
                surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
                surface.SetMaterial(Arbitrage.GetMaterial("danganronpa/ui/unknown.png"))
                surface.DrawTexturedRect(0, 0, w, h)

                draw.DrawText("Кликните по портрету для\nпросмотра персонажа", "arb.Font_FuturaPTBook_10", w / 2, h - H(100), Color(255, 234, 238, 5 * _.alpha), TEXT_ALIGN_CENTER)
            else
                local faction = Arbitrage.teams.Get(panel.charactersPanel.character)
                if !faction then return end

                local splash = Arbitrage.GetMaterial(faction.splash or "err.png")

                surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
                surface.SetMaterial(splash)
                surface.DrawTexturedRect(0, 0, w, h)

                draw.DrawText(faction.name, "arb.Font_FuturaPTDemi_15", w / 2, H(400), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)

                surface.SetDrawColor(255, 234, 238, 15 * _.alpha)
                surface.DrawRect(W(155), H(467), W(350), H(2))

                draw.DrawText(faction.description, "arb.Font_FuturaPTBook_10", w / 2, H(485), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)

                local count = 0
                for k, v in ipairs(player.GetAll()) do
                    local vFaction = v:Team()

                    if vFaction == panel.charactersPanel.character then
                        count = count + 1
                    end
                end

                if count > 0 then
                    parsed:draw(w / 2, H(524), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
                else
                    if faction.admin then
                        parsed2:draw(w / 2, H(524), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
                    end
                end
            end
        end

        local acceptButton = panel.charactersInfo:Add("DButton")
        acceptButton:SetText("")
        acceptButton:SetAlpha(0)
        acceptButton:SetPos(W(192), H(588))
        acceptButton:SetSize(W(276), H(52))
        acceptButton.Paint = function(_, w, h)
            parent:DesignButton(_, "Подтвердить выбор", w, h)
        end
        acceptButton.DoClick = function()
            local id = panel.charactersPanel.character
            if id == -1 then return end

            local faction = Arbitrage.teams.Get(id)
            if !faction then return end

            if faction.admin and !LocalPlayer():IsAdmin() then return end

            netstream.Start("arb.SelectCharacter", id)
            parent:ClosePanel()
        end

        for k, v in ipairs(data) do
            local mat = Arbitrage.GetMaterial(v.logo or "err.png")

            local character = panel.charactersPanel:Add("DPanel")
            character:SetAlpha(0)
            character:AlphaTo(255, 1)
            character:SetSize(W(165), H(135))
            character.alpha = 0.1
            character.alpha2 = 0
            character.Paint = function(_, w, h)
                local selected = panel.charactersPanel.character == v.key

                local x, y = character:GetWide() / 2 - W(100) / 2, H(2)

                surface.SetDrawColor(27, 10, 13, 204 * character.alpha)
                surface.DrawRect(x, y, W(100), H(100))

                Arbitrage.DrawTextBlur(v.name, "arb.Font_FuturaPTBook_7", w / 2, h - H(25), Color(255, 238, 177, 255 * _.alpha2), TEXT_ALIGN_CENTER)

                if !selected then
                    draw.DrawText(v.name, "arb.Font_FuturaPTBookBlurN_7", w / 2, h - H(25), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
                end

                surface.SetDrawColor(255, 61, 96, 165.75 * (_.alpha + 0.5))
                surface.DrawOutlinedRect(x, y, W(100), H(100), 2)

                Arbitrage.DrawOutlinedRectBlur(x, y, W(100), H(100), Color(255, 238, 177, 255 * _.alpha2), 2, 4)
            end

            local button = character:Add("DButton")
            button:SetText("")
            button:SetPos(character:GetWide() / 2 - W(100) / 2, H(2))
            button:SetSize(W(100), H(100))
            button.Paint = function(_, w, h)
                local selected = panel.charactersPanel.character == v.key

                character.alpha = Lerp(FrameTime() * 10, character.alpha, _:IsHovered() and 1 or 0.1)
                character.alpha2 = Lerp(FrameTime() * 10, character.alpha2, selected and 1 or -0.1)

                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(6, 6, w - 12, w - 12)
            end
            button.DoClick = function(_, w, h)
                panel.charactersInfo.alpha = 0
                acceptButton:AlphaTo(255, 0.3)
                panel.charactersPanel.character = v.key

                local count = 0
                for k, v in ipairs(player.GetAll()) do
                    local vFaction = v:Team()

                    if vFaction == panel.charactersPanel.character then
                        count = count + 1
                    end
                end

                local faction = Arbitrage.teams.Get(v.key)
                if faction and faction.max and faction.max > 0 and count >= faction.max then
                    acceptButton:SetDisabled(true)
                else
                    acceptButton:SetDisabled(false)
                end
            end
        end
    end
}

function PANEL:Init()
    local parent = self:GetParent()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)
    self:SetSize(ScrW(), ScrH())

    self.titleText = ""
    self.titleDesc = ""
    self.select = ""
    self.categorys = {}
    self.pressedCD = RealTime()
    self.titleAlpha = 0

    self.optionPanel = self:Add("Panel")
    self.optionPanel:SetTall(H(24))
    self.optionPanel:Dock(BOTTOM)
    self.optionPanel:DockMargin(W(150), 0, W(150), H(80))

    self:AddCategory({
        name = "TRIGGER HAPPY HAVOC",
        desc = "Играйте за одного из 16 оригинальных\nперсонажей из игры Danganronpa:\nTrigger Happy Havoc",
        image = Arbitrage.GetMaterial("danganronpa/ui/category/trigger_happy_havoc.png")
    })

    self:AddCategory({
        name = "GOODBYE DESPAIR",
        desc = "Играйте за одного из 16 оригинальных\nперсонажей из игры Danganronpa:\nGoodbye Despair",
        image = Arbitrage.GetMaterial("danganronpa/ui/category/goodbye_dispair.png")
    })

    self:AddCategory({
        name = "KILLING HARMONY",
        desc = "Играйте за одного из 16 оригинальных\nперсонажей из игры Danganronpa:\nKilling Harmony",
        image = Arbitrage.GetMaterial("danganronpa/ui/category/killing_harmony.png")
    })

    self:AddCategory({
        name = "ULTRA DESPAIR GIRLS",
        desc = "Играйте за одного из 12 оригинальных\nперсонажей из игры Danganronpa:\nUltra Despair Girls",
        image = Arbitrage.GetMaterial("danganronpa/ui/category/ultra_despair_girls.png")
    })

    parent:AddOption(self.optionPanel, "ESC", "Назад", W(50), W(100))

    self:OpenStages(true, "category")
end

function PANEL:ClearGarbage()
    local data = {
        -- self.categoryPanel,
        self.categoryOpPanel,
        self.charactersPanel,
        self.charactersInfo
    }

    for k, v in ipairs(data) do
        if !IsValid(v) then continue end

        v:Remove()
    end
end

function PANEL:Think()
    local parent = self:GetParent()

    if RealTime() <= self.pressedCD then return end

    if input.IsKeyDown(KEY_ESCAPE) then
        if self.select == "category" or self.select == "monokuma" then
            self:AlphaTo(0, 0.3, 0, function()
                self:Remove()
                parent:Bluring(false)
                parent:ShowLogo(true)
                parent.menu:Show(true)
            end)

            self.pressedCD = RealTime() + 0.3
        elseif self.select == "character" then
            self:OpenStages(true, "category")
            self.pressedCD = RealTime() + 0.3
        end
    end
end

function PANEL:OpenStages(bClear, data, ...)
    if !stagesData[data] then return end

    if bClear then
        self:ClearGarbage()
    end

    stagesData[data](self, ...)

    self.select = data
end

function PANEL:AddCategory(data)
    self.categorys[#self.categorys + 1] = data
end

function PANEL:InitCategory()
    for k, v in ipairs(self.categorys) do
        local a = k - 1
        local b = k >= 2 and W(40) or 0

        local panel = self.categoryPanel:Add("DButton")
        panel:SetText("")
        panel:SetAlpha(0)
        panel:AlphaTo(255, 1)
        panel:SetPos(a * W(340) + a * b, 0)
        panel:SetSize(W(340), H(540))
        panel.alpha = 0.2
        panel.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.2)

            local size = panel.alpha * 0.02

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(v.image)
            surface.DrawTexturedRect(0 - w * size, 0 - h * size, w + (w * size) * 2, h + (h * size) * 2)

            surface.SetDrawColor(0, 0, 0, 255 * (1 - _.alpha))
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(155, 35, 57, 255 * panel.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            draw.DrawText(v.name, "arb.Font_FuturaPTDemi_12", w / 2, H(392), Color(255, 234, 238, 255 * panel.alpha), TEXT_ALIGN_CENTER)
            draw.DrawText(v.desc, "arb.Font_FuturaPTBook_8", w / 2, H(437), Color(255, 234, 238, 50 * panel.alpha), TEXT_ALIGN_CENTER)
        end
        panel.DoClick = function()
            local data = {}

            for k2, v2 in pairs(Arbitrage.teams.data) do
                v2.key = k2

                if v2.category == v.name then
                    data[#data + 1] = v2
                end
            end

            self:OpenStages(true, "character", data)
        end
    end
end

function PANEL:Paint(w, h)
    self.titleAlpha = Lerp(FrameTime() * 3, self.titleAlpha, 1)

    draw.DrawText(self.titleText, "arb.Font_FuturaPTDemi_17", W(150), H(60), Color(255, 234, 238, 255 * self.titleAlpha), TEXT_ALIGN_LEFT)

    surface.SetFont("arb.Font_FuturaPTDemi_17")
    local width, _ = surface.GetTextSize(self.titleText)

    draw.DrawText(self.titleDesc, "arb.Font_FuturaPTBook_10", width + W(170), H(74), Color(255, 234, 238, 20 * self.titleAlpha), TEXT_ALIGN_LEFT)
end

vgui.Register("arb.MainRemake:Characters", PANEL, "EditablePanel")