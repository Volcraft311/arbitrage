--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
PLUGIN.actionMenu = PLUGIN.actionMenu or {}
PLUGIN.actionMenu.stored = {}
PLUGIN.actionMenu.font = "arb.Font_FuturaPTBook_9"

function PLUGIN.actionMenu:New(data)
    self.stored[data.entity] = data
end

function PLUGIN.actionMenu:DrawCursor()
    if table.Count(self.stored) <= 0 then return end

    local x, y = ScrW() / 2, ScrH() / 2

    surface.SetDrawColor(95, 28, 39, 255)
    surface.DrawRect(x - 3, y - 3, 6, 6)
    surface.SetDrawColor(15, 5, 6, 255)
    surface.DrawRect(x - 2, y - 2, 4, 4)
end

function PLUGIN.actionMenu:GetMaxWidth(id)
    if self.stored[id].maxWidth then
        return self.stored[id].maxWidth
    end

    local data = {}
    for k, text in ipairs(self.stored[id].options) do
        local width, _ = surface.GetTextSize(text)

        data[#data + 1] = width
    end

    if #data > 0 then
        local max = math.max(unpack(data))
        self.stored[id].maxWidth = max

        return max
    end

    return 0
end

function PLUGIN.actionMenu:IsSelected(x, y, w, h)
    w = x + w
    h = y + h

    local centerX, centerY = ScrW() / 2, ScrH() / 2

    if (centerX > x and centerX < w) and (centerY > y and centerY < h) then
        return true
    end

    return false
end

function PLUGIN.actionMenu:Paint()
    local client = LocalPlayer()

    surface.SetFont(self.font)
    local size = W(20)

    for k, v in pairs(self.stored) do
        local entity = v.entity

        if !IsValid(entity) then
            self.stored[k] = nil
            continue
        end

        local pos = entity:LocalToWorld(entity:OBBCenter())
        local data2D = pos:ToScreen()
        local x, y = data2D.x, data2D.y
        local distance = client:GetPos():Distance(pos)

        v.alpha = Lerp(FrameTime(), v.alpha, 256)
        local alpha = math.min(v.alpha + 345 - distance * 4, 255)

        if alpha <= -50 and v.alpha >= 200 then
            self.stored[k] = nil
        end

        local isSelect
        if data2D.visible and alpha > 0 then
            for k2, v2 in ipairs(v.options) do
                local _, height = surface.GetTextSize(v2)
                local tall = y + ((k2 - 1) * height)

                local maxWidth = self:GetMaxWidth(k)
                local _x, _y, _w, _h = x - maxWidth / 2 - size, tall, maxWidth + size * 2, height + 2

                local bSelected = self:IsSelected(_x, _y, _w, _h)
                local buttonAlpha = bSelected and alpha or alpha * 0.8
                local textAlpha = bSelected and alpha or alpha * 0.3

                surface.SetDrawColor(15, 5, 6, buttonAlpha * 0.9)
                surface.DrawRect(_x, _y, _w, _h)

                surface.SetDrawColor(95, 28, 39, buttonAlpha)
                surface.DrawOutlinedRect(_x, _y, _w, _h, 2)

                draw.SimpleText(v2, self.font, x, tall, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER)

                if bSelected then isSelect = v2 end
            end

            if isSelect and client:KeyDown(IN_USE) and (!PLUGIN.actionMenu.cd or CurTime() >= PLUGIN.actionMenu.cd) then
                netstream.Start("ItemBase:SendAction", entity:GetItemID(), isSelect)

                self.stored[k] = nil
                PLUGIN.actionMenu.cd = CurTime() + 0.5
            end
        end
    end

    self:DrawCursor()
end