--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PANEL = {}

function PANEL:Init()
    local parent = self:GetParent()

    self:Welcome()
    MonoPad:StartRegisterMeta(self)

    local monopad = MonoPad:GetObject()
    if !monopad then return end

    local validMap = MonoPad.miniMapList[game.GetMap()]
    local panel = self:CreateButton("navigation", "#monopad_title_navigation", "#monopad_desc_navigation", 50, 158, "danganronpa/monopad/category/navigation.png", function()
        parent:DrawLoading(function()
            self:Remove()

            local map = parent:Add("MonoPad:MiniMap")
            map:Dock(FILL)

            local parent2 = IsValid(parent) and parent:GetParent()
            if IsValid(parent2) then
                parent:GetParent().selectPanel = map
            end
        end)
    end)
    panel:SetAlpha(validMap and 255 or 15)
    panel:SetDisabled(true)

    self:CreateButton("rules", "#monopad_title_rules", "#monopad_desc_rules", 335, 158, "danganronpa/monopad/category/charter.png", function()
        parent:DrawLoading(function()
            self:Remove()

            local rules = parent:Add("MonoPad:Rules")
            rules:Dock(FILL)

            local parent2 = IsValid(parent) and parent:GetParent()
            if IsValid(parent2) then
                parent:GetParent().selectPanel = rules
            end
        end)
    end, function()
        return table.Count(monopad.rulesNotify or {}) > 0
    end)

    self:CreateButton("messenger", "#monopad_title_messenger", "#monopad_desc_messenger", 620, 158, "danganronpa/monopad/category/messenger.png", function()
        parent:DrawLoading(function()
            self:Remove()

            local messager = parent:Add("MonoPad:Messenger")
            messager:Dock(FILL)

            local parent2 = IsValid(parent) and parent:GetParent()
            if IsValid(parent2) then
                parent:GetParent().selectPanel = messager
            end
        end)
    end, function()
        return monopad.messagesNotify > 0
    end)

    self:CreateButton("gamelog", "#monopad_title_gamelog", "#monopad_desc_gamelog", 50, 343, "danganronpa/monopad/category/gamelog.png", function()
        parent:DrawLoading(function()
            self:Remove()

            local gamelog = parent:Add("MonoPad:GameLog")
            gamelog:Dock(FILL)

            local parent2 = IsValid(parent) and parent:GetParent()
            if IsValid(parent2) then
                parent:GetParent().selectPanel = gamelog
            end
        end)
    end, function()
        return monopad.gamelogNotify
    end)

    self:CreateButton("notes", "#monopad_title_notes", "#monopad_desc_notes", 335, 343, "danganronpa/monopad/category/notes.png", function()
        parent:DrawLoading(function()
            self:Remove()

            local notes = parent:Add("MonoPad:Notes")
            notes:Dock(FILL)

            local parent2 = IsValid(parent) and parent:GetParent()
            if IsValid(parent2) then
                parent:GetParent().selectPanel = notes
            end
        end)
    end)

    self:CreateButton("special", "#monopad_title_special", "#monopad_desc_special", 620, 343, "danganronpa/monopad/category/special.png", function()
        parent:DrawLoading(function()
            self:Remove()

            local special = parent:Add("MonoPad:Special")
            special:Dock(FILL)

            local parent2 = IsValid(parent) and parent:GetParent()
            if IsValid(parent2) then
                parent:GetParent().selectPanel = special
            end
        end)
    end, function()
        return monopad.specialNotify
    end)
end

function PANEL:Welcome()
    local name = "#monopad_unknown"

    local monopad = MonoPad:GetObject()
    local faction = Character.team:GetByID(monopad:GetTeam())
    if faction then
        name = faction:GetName()
    end

    local welcomeText = F(("#monopad_welcome, %s!"):format(name))

    local panel = self:Add("Panel")
    panel:Dock(TOP)
    panel:SetTall(120)
    panel.Paint = function(_, w, h)
        draw.SimpleText(welcomeText, MonoPad:GetFont("welcome"), w / 2, 48, color_white, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 255, 255, 7.65)
        surface.DrawRect(50, h - 2, w - 100, 2)
    end
end

local circleMat = Material("danganronpa/ui/circle.png")
function PANEL:CreateButton(uniqueID, text, desc, x, y, image, callback, isNotify)
    local mat = Material(image)

    local button = self:Add("DButton")
    button:SetText("")
    button:SetPos(x, y)
    button:SetSize(256, 158)
    button.alpha = 0.2
    button.circleList = {}
    button.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 8, _.alpha, _:IsHovered() and 1 or 0.2)
        local size = _.alpha * 0.06

        asterionlib.DrawRender(function()
            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, 0, w, h)
        end, function()
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(0 - w * size, 0 - h * size, w + (w * size) * 2, h + (h * size) * 2)
        end)

        surface.SetDrawColor(0, 0, 0, 250 - 250 * _.alpha)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(L(text), MonoPad:GetFont("category_title"), 14, 100, color_white, TEXT_ALIGN_LEFT)
        draw.SimpleText(L(desc), MonoPad:GetFont("category_desc"), 14, 128.5, color_white, TEXT_ALIGN_LEFT)

        local isnotify = isNotify and isNotify()
        if isnotify then
            surface.SetDrawColor(14, 9, 3, 170)
            surface.DrawRect(8, 8, 127, 23)

            MonoPad:DrawTextBlur("#monopad_newmod", MonoPad:GetFont("category_notify"), 14, 9, Color(255, 176, 56), TEXT_ALIGN_LEFT, Color(255, 176, 56, 150))
        end

        surface.SetDrawColor(15, 15, 15)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        button:DrawCircles(w, h)
    end

    button.CreateCircle = function(_, w, h)
        table.insert(button.circleList, {
            x = math.random(0, w),
            y = math.random(h / 2, h / 2 + h / 2),
            size = math.random(2, 15),
            speed = math.random(10, 20),
            alpha = 0,
            addalpha = math.random(1, 100)
        })
    end

    button.DrawCircles = function(_, w, h)
        if #button.circleList < 20 and button:IsHovered() and (!button.cdTime or RealTime() >= button.cdTime) then
            button:CreateCircle(w, h)

            button.cdTime = RealTime() + 0.1
        end

        local time = FrameTime() * 10
        for k, v in ipairs(button.circleList) do
            local size = v.size

            surface.SetDrawColor(255, 61, 96, v.alpha)
            surface.SetMaterial(circleMat)
            surface.DrawTexturedRect(v.x - size, v.y - size, size * 2, size * 2)

            local isAbroad = v.y < 0

            v.alpha = Lerp(time, v.alpha, isAbroad and -10 or 20 + v.addalpha)
            v.y = v.y - v.speed * 0.03

            if v.alpha <= -5 then
                table.remove(button.circleList, k)
            end
        end
    end

    local parent = self:GetParent():GetParent()
    if callback then
        button.DoClick = function()
            parent.selectcategory = uniqueID

            local icon = MonoPad.icons[uniqueID] or "danganronpa/monopad/icons/home.png"

            local monopad = MonoPad:GetObject()
            table.insert(monopad.history, {uniqueID, text, icon, {}})
            parent.historyID = #monopad.history

            local panel = parent:AddButton(uniqueID, text, icon, function()
                if IsValid(parent.mainmenu) then
                    parent.mainmenu:Remove()
                end

                local action = MonoPad.categoryActions[uniqueID]
                if action then
                    local ui = action(unpack(monopad.history[parent:GetActiveHistoryID()][4]))
                    ui:SetAlpha(0)
                    ui:AlphaTo(255, 0.3)

                    MonoPad:GetUI().selectPanel = ui
                end

                MonoPad:SyncHistory(monopad)
            end, parent.historyID)
            panel:SetWide(110)

            parent.historyPanels[#parent.historyPanels + 1] = panel

            if #monopad.history > 4 then
                table.remove(monopad.history, 1)

                for k, v in ipairs(parent.historyPanels or {}) do
                    if !IsValid(v) then continue end

                    if v.historyID == 1 then
                        v:Remove()
                    else
                        v.historyID = v.historyID - 1
                    end
                end

                parent.historyID = parent.historyID - 1
            end

            callback(button)
            asterionlib.EmitSound(MonoPad.sounds.planshet_beep)
            MonoPad:SyncHistory(monopad)
        end
    end

    return button
end

vgui.Register("MonoPad:MainMenu", PANEL, "Panel")