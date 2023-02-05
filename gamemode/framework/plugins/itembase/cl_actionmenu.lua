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
        local width, _ = surface.GetTextSize(text[1])

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

local cornerRadius = 5
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
            local maxWidth, maxHeight = self:GetMaxWidth(k), 0
            local fontHeight = 0

            for k2, v2 in ipairs(v.options) do
                local _, height = surface.GetTextSize(v2[1])

                maxHeight = maxHeight + height
                fontHeight = height
            end

            local _x = x - maxWidth / 2 - size
            local _w = maxWidth + size * 2 + fontHeight + W(20)

            draw.RoundedBox(cornerRadius, _x, y, _w, maxHeight, Color(212, 59, 85, alpha))
            draw.RoundedBox(cornerRadius, _x + 2, y + 2, _w - 4, maxHeight - 4, Color(41, 22, 25, alpha))

            local isFindSelect = false
            for k2, v2 in ipairs(v.options) do
                local _, height = surface.GetTextSize(v2[1])
                local tall = y + ((k2 - 1) * height)

                local _y, _h = tall, height + 2
                local bSelected = false
                if !isFindSelect and self:IsSelected(_x, _y, _w, _h) then
                    bSelected = true
                    isFindSelect = true
                end

                local alphanew = alpha * 0.5
                if bSelected then
                    surface.SetDrawColor(27, 10, 13, 200)
                    surface.DrawRect(_x + 2, _y + 2, _w - 4, _h - 4)

                    alphanew = alphanew * 2
                end

                alphanew = math.Clamp(alphanew, 0, 255)

                if v2[2] then
                    local a = fontHeight * 0.67

                    surface.SetDrawColor(255, 255, 255, alpha)
                    surface.SetMaterial(Material(v2[2]))
                    surface.DrawTexturedRect(_x + (fontHeight / 2 - a / 2), _y + (fontHeight / 2 - a / 2), a, a)
                end

                draw.SimpleText(v2[1], self.font, _x + fontHeight + W(10), tall, Color(240, 240, 240, alphanew), TEXT_ALIGN_LEFT)

                if bSelected then isSelect = v2[1] end
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