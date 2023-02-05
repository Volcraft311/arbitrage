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

local sliderMat = Material("danganronpa/ui/slider.png")
local resetMat = Material("danganronpa/ui/info_8.png")

PLUGIN.type = {
    number = function(data, panel, panelinfo)
        local frame = PLUGIN.GeneratePanel(data, panel, panelinfo)

        local sliderPanel = frame:Add("DNumSlider")
        sliderPanel:Dock(RIGHT)
        sliderPanel:SetWide(W(180))
        sliderPanel:SetMin(data.min)
        sliderPanel:SetMax(data.max)

        local children = sliderPanel:GetChildren()
        local dtextentry = children[1]
        local dslider = children[2]
        local dlabel = children[3]

        dtextentry:SetWide(0)
        dlabel:SetWide(0)

        dslider.Paint = function(_, w, h)
            surface.SetDrawColor(46, 12, 17)
            surface.DrawRect(0, h / 2 - 1, w, 2)
        end

        dslider:GetChildren()[1]:SetTall(dslider:GetChildren()[1]:GetTall() * 1.3)
        dslider:GetChildren()[1]:SetWide(dslider:GetChildren()[1]:GetWide() * 1.3)
        dslider:GetChildren()[1].Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(sliderMat)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        sliderPanel.PerformLayout = function(_, w, h) end

        local labelPanel = frame:Add("DLabel")
        labelPanel:SetContentAlignment(6)
        labelPanel:SetFont("arb.Font_FuturaPTBook_8")
        labelPanel:Dock(RIGHT)
        labelPanel:DockMargin(0, 0, W(20), 0)

        sliderPanel.OnValueChanged = function(_, value)
            value = math.floor(value)

            labelPanel:SetText(value)

            SETTINGS.options.Set(data.id, value)
        end

        labelPanel:SetText(data.value)
        sliderPanel:SetValue(data.value)

        frame.OnReset = function(_, value)
            labelPanel:SetText(value)
            sliderPanel:SetValue(value)
        end
    end,
    bool = function(data, panel, panelinfo)
        local frame = PLUGIN.GeneratePanel(data, panel, panelinfo)

        local buttonNo = frame:Add("DButton")
        buttonNo:SetText("")
        buttonNo:Dock(RIGHT)
        buttonNo:SetWide(W(66))
        buttonNo:DockMargin(W(10), 0, 0, 0)
        buttonNo.alpha = 0.1
        buttonNo.Paint = function(_, w, h)
            local status = SETTINGS.options.Get(data.id) == false

            _.alpha = Lerp(FrameTime() * 10, _.alpha, status and 1 or 0.1)

            surface.SetDrawColor(15, 6, 6, 204 * _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(99, 17, 32, 255 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            draw.DrawText("НЕТ", "arb.Font_FuturaPTBook_8", w / 2, H(3), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
        end
        buttonNo.DoClick = function()
            local status = SETTINGS.options.Get(data.id) == false
            if status then return end

            SETTINGS.options.Set(data.id, false)
        end

        local buttonYes = frame:Add("DButton")
        buttonYes:SetText("")
        buttonYes:Dock(RIGHT)
        buttonYes:SetWide(W(66))
        buttonYes.alpha = 0.1
        buttonYes.Paint = function(_, w, h)
            local status = SETTINGS.options.Get(data.id) == true

            _.alpha = Lerp(FrameTime() * 10, _.alpha, status and 1 or 0.1)

            surface.SetDrawColor(15, 6, 6, 204 * _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(99, 17, 32, 255 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            draw.DrawText("ДА", "arb.Font_FuturaPTBook_8", w / 2, H(3), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
        end
        buttonYes.DoClick = function()
            local status = SETTINGS.options.Get(data.id) == true
            if status then return end

            SETTINGS.options.Set(data.id, true)
        end
    end,
    ["string"] = 3,
    bind = function(data, panel, panelinfo)
        panel.panelsKeys = panel.panelsKeys or {}

        local frame = PLUGIN.GeneratePanel(data, panel, panelinfo, true)

        local buttonKey = frame:Add("DButton")
        buttonKey:SetText("")
        buttonKey:Dock(RIGHT)
        buttonKey:SetWide(W(80))
        buttonKey.alpha = 1
        buttonKey.isEdit = false
        buttonKey.Paint = function(_, w, h)
            local key = input.GetKeyName(data.value) or "NULL"

            surface.SetDrawColor(15, 6, 6, 204 * _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(99, 17, 32, 255 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            if _.isEdit then
                key = "...."
            end

            draw.DrawText(string.upper(key), "arb.Font_FuturaPTBook_8", w / 2, H(3), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
        end
        buttonKey.DoClick = function()
            for k, v in pairs(panel.panelsKeys) do
                if !IsValid(v) then continue end

                v.isEdit = false
            end

            PLUGIN.ClearTimers()
            buttonKey.isEdit = true

            timer.Create("SETTINGS:ChangeKey", FrameTime(), 0, function()
                local key = SETTINGS.binds.GetClampedKey()

                if key then
                    PLUGIN.ClearTimers()
                    buttonKey.isEdit = false

                    SETTINGS.binds.Set(data.id, key)
                end
            end)

            timer.Create("SETTINGS:ChangeKeyDelay", 50, 1, function()
                PLUGIN.ClearTimers()
                buttonKey.isEdit = false
            end)
        end

        panel.panelsKeys[#panel.panelsKeys + 1] = buttonKey
    end
}

function PLUGIN.ClearTimers()
    timer.Remove("SETTINGS:ChangeKey")
    timer.Remove("SETTINGS:ChangeKeyDelay")
end

function PLUGIN.GeneratePanel(data, panel, panelinfo, isBind)
    local frame = panel:Add("DButton")
    frame:SetText("")
    frame:SetTall(H(30))
    frame:Dock(TOP)
    frame:DockMargin(0, 0, 0, H(18))
    frame.color = Color(255, 234, 238)
    frame.alpha = 50
    frame.Paint = function(_, w, h)
        local ishover = _:IsHovered()
        local isselect = panel.select == frame
        local frametime = FrameTime() * 10

        _.color.r = Lerp(frametime, _.color.r, isselect and 255 or 255)
        _.color.g = Lerp(frametime, _.color.g, isselect and 61 or 234)
        _.color.b = Lerp(frametime, _.color.b, isselect and 96 or 238)
        _.color.a = Lerp(frametime, _.color.a, (ishover or isselect) and 255 or 50)

        draw.DrawText(data.name, "arb.Font_FuturaPTBook_9", h + 5, 0, Color(_.color.r, _.color.g, _.color.b, _.color.a), TEXT_ALIGN_LEFT)
    end
    frame.DoClick = function()
        if panel.select == frame then return end

        for k, v in ipairs(panelinfo.panels) do
            if !IsValid(v) then continue end

            v:Remove()
        end

        panel.select = frame

        panelinfo:SetAlpha(0)
        panelinfo:AlphaTo(255, 0.2)

        local text = data.description
        local font = "arb.Font_FuturaPTBook_8"
        local textData = asterionlib.WrapText(text, panelinfo:GetWide(), font)

        surface.SetFont(font)
        local _, height = surface.GetTextSize(text)

        local labelTitle = panelinfo:Add("DLabel")
        labelTitle:SetText(data.title)
        labelTitle:SetFont("arb.Font_FuturaPTBook_11")
        labelTitle:SetTextColor(Color(255, 41, 80))
        labelTitle:Dock(TOP)
        labelTitle:DockMargin(0, 0, 0, H(6))
        labelTitle:SizeToContents()

        local labelDesc = panelinfo:Add("DPanel")
        labelDesc:Dock(TOP)
        labelDesc:SetTall(height * #textData)
        labelDesc.Paint = function(_, w, h)
            for k, v in ipairs(textData) do
                draw.DrawText(v, font, 0, height * k - height, Color(255, 234, 238), TEXT_ALIGN_LEFT)
            end
        end

        if data.image then
            local mat = Material(data.image)

            local w = mat:Width()
            local h = mat:Height()

            local imagePanel = panelinfo:Add("Panel")
            imagePanel:Dock(TOP)
            imagePanel:DockMargin(0, H(40), 0, 0)
            imagePanel.ischange = false
            imagePanel.Paint = function(_, _w, _h)
                local a = _w / w
                local a2 = w * a
                local b2 = h * a

                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(0, 0, a2, b2)

                if imagePanel:GetTall() != b2 and !_.ischange then
                    imagePanel:SetTall(b2)
                    _.ischange = true
                end
            end

            panelinfo.panels[#panelinfo.panels + 1] = imagePanel
        end

        panelinfo.panels[#panelinfo.panels + 1] = labelTitle
        panelinfo.panels[#panelinfo.panels + 1] = labelDesc
    end

    local buttonReset = frame:Add("DButton")
    buttonReset:SetAlpha(0)
    buttonReset:SetText("")
    buttonReset:SetWide(frame:GetTall())
    buttonReset:Dock(LEFT)
    buttonReset.color = Color(255, 234, 238)
    buttonReset.Paint = function(_, w, h)
        local ishover = _:IsHovered()
        local frametime = FrameTime() * 10

        _.color.r = Lerp(frametime, _.color.r, ishover and 255 or 255)
        _.color.g = Lerp(frametime, _.color.g, ishover and 61 or 234)
        _.color.b = Lerp(frametime, _.color.b, ishover and 96 or 238)

        surface.SetDrawColor(_.color.r, _.color.g, _.color.b)
        surface.SetMaterial(resetMat)
        surface.DrawTexturedRect(0, 0, h, h)

        if !SETTINGS.binds.IsDefault(data.id) and !SETTINGS.options.IsDefault(data.id) then
            _:SetAlpha(255)
        else
            _:SetAlpha(0)
        end
    end
    buttonReset.DoClick = function()
        if isBind then
            SETTINGS.binds.SetDefault(data.id)
        else
            SETTINGS.options.SetDefault(data.id)
        end

        if frame.OnReset then
            if isBind then
                frame:OnReset(SETTINGS.binds.GetDefault(data.id))
            else
                frame:OnReset(SETTINGS.options.GetDefault(data.id))
            end
        end
    end

    local line = panel:Add("DPanel")
    line:SetTall(H(2))
    line:Dock(TOP)
    line:DockMargin(0, 0, 0, H(16))
    line.Paint = function(_, w, h)
        surface.SetDrawColor(255, 234, 238, 10)
        surface.DrawRect(0, h - 2, w, 2)
    end

    return frame
end

timer.Simple(1, function()
    SETTINGS.Load()
end)