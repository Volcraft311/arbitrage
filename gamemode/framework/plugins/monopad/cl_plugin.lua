MonoPad.miniMapList = {
    ["drp_hopespeak"] = {
        x = -495,
        y = -255,
        stored = {
            [1] = {"Этаж №1", "aboba5.png"},
            [2] = {"Этаж №2", "aboba4.png"},
            [3] = {"Этаж №3", "aboba10.png"},
            [4] = {"Этаж №4", "aboba10.png"},
            [5] = {"Этаж №5", "aboba10.png"},
            [6] = {"Зал суда", "aboba10.png"},
            [7] = {"Коллектор", "aboba10.png"}
        }
    }
}

function MonoPad:CreateFont(id, name, size, info)
    local data = {
        font = name,
        extended = true,
        size = size,
        weight = 500,
        antialias = true,
    }

    for k, v in pairs(info or {}) do
        data[k] = v
    end

    surface.CreateFont("MonoPad:" .. id, data)
end

function MonoPad:GetFont(id)
    return "MonoPad:" .. id
end

-- cl_mainmenu.lua
MonoPad:CreateFont("task", "Futura PT Book", 20)
MonoPad:CreateFont("welcome", "Futura PT Demi", 30)
MonoPad:CreateFont("category_title", "Futura PT Demi", 25)
MonoPad:CreateFont("category_desc", "Futura PT Book", 19)
MonoPad:CreateFont("category_notify", "Futura PT Book", 20)
MonoPad:CreateFont("category_notify_blur", "Futura PT Book", 20, {blursize = 3})
MonoPad:CreateFont("tooltip_text", "Futura PT Book", 18)
MonoPad:CreateFont("tooltip_text_blur", "Futura PT Book", 18, {blursize = 3})

-- cl_minimap.lua
MonoPad:CreateFont("minimap_button", "Futura PT Demi", 22)

MonoPad:CreateFont("minimap_button2", "Futura PT Book", 22)
MonoPad:CreateFont("minimap_button2_blur", "Futura PT Book", 22, {blursize = 5})

-- cl_notes.lua
MonoPad:CreateFont("notes_title", "Futura PT Book", 22)
MonoPad:CreateFont("notes_title2", "Futura PT Book", 32)
MonoPad:CreateFont("notes_description", "Futura PT Book", 18)

-- cl_rules.lua
MonoPad:CreateFont("rules_id", "Futura PT Book", 22)
MonoPad:CreateFont("rules_id_draw", "Futura PT Book", 21)
MonoPad:CreateFont("rules_title", "Futura PT Demi", 30)
MonoPad:CreateFont("rules_description", "Futura PT Book", 20)
MonoPad:CreateFont("rules_description_blur", "Futura PT Book", 20, {blursize = 3})
MonoPad:CreateFont("rules_notify", "Futura PT Book", 20)
MonoPad:CreateFont("rules_notify_blur", "Futura PT Book", 20, {blursize = 3})

-- cl_messenger.lua
MonoPad:CreateFont("messenger_title", "Futura PT Book", 22)
MonoPad:CreateFont("messenger_title_blur", "Futura PT Book", 22, {blursize = 5})

MonoPad:CreateFont("messenger_author", "Futura PT Demi", 22)
MonoPad:CreateFont("messenger_text", "Futura PT Book", 19)
MonoPad:CreateFont("messenger_text_blur", "Futura PT Book", 19, {blursize = 3})

-- cl_gamelog.lua
MonoPad:CreateFont("gamelog_title", "Futura PT Demi", 26)
MonoPad:CreateFont("gamelog_text", "Futura PT Book", 20)
MonoPad:CreateFont("gamelog_text_blur", "Futura PT Book", 20, {blursize = 3})

-- cl_special.lua
MonoPad:CreateFont("special_title", "Futura PT Demi", 27)
MonoPad:CreateFont("special_description", "Futura PT Book", 20)
MonoPad:CreateFont("special_description_blur", "Futura PT Book", 20, {blursize = 3})

function MonoPad:CreateTablet(entity)
    self:DisableTablet()
    local panel = vgui.Create("MonoPad:Menu")

    if entity then
        panel:SetPaintedManually(true)
    end

    local monopad = panel:FindMonoPad()
    if monopad then
        panel:SetObject(monopad)
    end

    return panel
end

function MonoPad:EnableTablet(entity, bEnable, panel)
    panel = panel or MonoPad:GetUI() --entity.panel
    if !IsValid(panel) then return end

    if bEnable then
        panel:Menu()
    else
        panel:Intro()
    end
end

function MonoPad:DisableTablet()
    local ui = MonoPad:GetUI()
    if IsValid(ui) then
        ui:Remove()
    end

    Arbitrage.gui.tabletUI = nil
end

function MonoPad:GetUI()
    return Arbitrage.gui.tabletUI
end

function MonoPad:StartRegisterMeta(panel)
    local oldAdd = panel.Add

    function panel.Add(a, object)
        local b = oldAdd(a, object)

        function b:InitPanel()
            function b:IsHovered()
                local d = MonoPad:GetUI()
                if !IsValid(d) then return end

                local cursorX, cursorY = d:GetChildPosition(d.cursor)

                local panelX, panelY = d:GetChildPosition(b)
                local panelW, panelH = b:GetWide(), b:GetTall()

                if (cursorX >= panelX and cursorX <= panelX + panelW) and (cursorY >= panelY and cursorY <= panelY + panelH) then
                    return true
                end

                return false
            end
        end

        local oldPerformLayout = b.PerformLayout
        function b.PerformLayout(c, w, h)
            if !c.m_upd then
                c:InitPanel()

                c.m_upd = true
            end

            return oldPerformLayout and oldPerformLayout(c, w, h)
        end

        LocalPlayer().metaPanels[#LocalPlayer().metaPanels + 1] = b
        return b
    end
end

function MonoPad:DrawTextBlur(text, font, x, y, color, xAlign, cb)
    local alpha = color.a or 255
    if alpha <= 0.01 then return end

    local font_normal = font
    local font_blur = font .. "_blur"

    cb = cb or Color(254, 110, 21)
    local color_blur = ColorAlpha(cb, math.min(alpha, cb.a))

    for i = 1, 2 do
        draw.SimpleText(text, font_blur, x, y, color_blur, xAlign)
    end

    draw.SimpleText(text, font_normal, x, y, color, xAlign)
end

local tabletMat = Material("danganronpa/monopad/notify.png")
local tabletSize = H(100)
local tabletAlpha = 0
MonoPad.tabletTime = RealTime()
function MonoPad:HUDPaint()
    tabletAlpha = math.Approach(tabletAlpha, RealTime() > self.tabletTime and 0 or 255, FrameTime() * 150)

    local alpha = math.abs(math.sin(RealTime() * 2)) * tabletAlpha
    if alpha < 0.1 then return end

    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(tabletMat)
    surface.DrawTexturedRect(25, ScrH() - tabletSize, tabletSize, tabletSize)
end

netstream.Hook("MonoPad:CreateTablet", function(entity)
    MonoPad:CreateTablet(entity)
end)

netstream.Hook("MonoPad:EnableTablet", function(entity, bEnable)
    MonoPad:EnableTablet(entity, bEnable)
end)

netstream.Hook("MonoPad:DisableTablet", function(entity)
    MonoPad:DisableTablet(entity)
end)

netstream.Hook("MonoPad:SyncObject", function(id, faction, evidences, messagesNotify, caseStored)
    local item = ItemBase.instances[id]
    if !item then return end

    if !item.stored then
        local meta = table.Copy(FindMetaTable("Monopad"))
        local monopad = setmetatable({id = id}, meta)

        item.stored = monopad
    end

    local object = item.stored
    object.id = id
    object.team = faction
    object.evidences = evidences
    object.messagesNotify = messagesNotify
    object.caseStored = caseStored

    hook.Run("SyncMonoPad", object)
    MonoPad.instances[id] = object
end)

netstream.Hook("MonoPad:EditRulesNotify", function(id)
    local monopad = MonoPad:FindMonoPad(LocalPlayer())
    if !monopad then return end

    if id == nil then
        monopad.stored.rulesNotify = {}
    else
        monopad.stored.rulesNotify[id] = true
    end
end)

netstream.Hook("MonoPad:Notify", function()
    local monopad = MonoPad:FindMonoPad(LocalPlayer())
    if !monopad then return end

    MonoPad.tabletTime = RealTime() + 8
end)

netstream.Hook("MonoPad:EditGameLogNotify", function()
    local monopad = MonoPad:FindMonoPad(LocalPlayer())
    if !monopad then return end

    MonoPad.tabletTime = RealTime() + 8
    monopad.stored.gamelogNotify = true
end)

netstream.Hook("MonoPad:EditSpecialNotify", function()
    local monopad = MonoPad:FindMonoPad(LocalPlayer())
    if !monopad then return end

    MonoPad.tabletTime = RealTime() + 8
    monopad.stored.specialNotify = true
end)