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

Hints.stored = Hints.stored or {}
Hints.keysDraw = {}
Hints.text = ""
Hints.char = 0
Hints.alpha, Hints.alphaTo = 0, 0
Hints.select = 0
Hints.nextThink = RealTime()

function Hints:Add(data)
    self.stored[#self.stored + 1] = data
end

function Hints:Select(id)
    if !SETTINGS.options.Get("show_hints") then return end

    local data = self.stored[id]
    if !data then return end

    self.text = ""
    self.char = 0
    self.alpha = 0
    self.alphaTo = 125
    self.select = id

    asterionlib.EmitSound("garrysmod/ui_return.wav")

    timer.Simple(data:utf8len() * 0.1 + 8, function()
        self.alphaTo = 0

        timer.Simple(2, function()
            self.select = nil
        end)
    end)
end

function Hints:OnSettingsLoad()
    self:Add("Вы всегда можете настроить игру под себя в настройках главного меню.")
    self:Add("Для большего погружения, не забывайте использовать RP-команды (/me, /try, /it).")
    self:Add("При наличии ошибок с моделями или текстурами, проверьте статус скачанных аддонов во вкладке 'Контент' игровых настроек.")

    self:Add("Открыть главное меню можно нажатием клавиши '" .. input.GetKeyName(SETTINGS.binds.Get("open_mainmenu_ui")) .. "'")
    self:Add("При помощи клавиш '" .. input.GetKeyName(SETTINGS.binds.Get("voice_up")) .. "' и '" .. input.GetKeyName(SETTINGS.binds.Get("voice_down")) .. "', вы можете регулировать дальность слышимости вашего микрофона.")
end

timer.Create("Hints:Random", 150, 0, function()
    local id = math.random(1, #Hints.stored)

    local data = Hints.stored[id]
    if !data then return end

    Hints:Select(id)
end)

local blockReload = {
    tfa_nmrih_asaw = true,
    tfa_nmrih_chainsaw = true
}
timer.Create("Hints:Update", 0.1, 0, function()
    local client = LocalPlayer()
    if !IsValid(client) then return end

    if Arbitrage.lawEnable then return end
    if !SETTINGS.options.Get("interface_open_button") then return end
    if client.GetSitting and client:GetSitting() then return end

    local trace = client:GetEyeTrace()
    local sit_key = SETTINGS.binds.Get("sitting")
    if trace.HitPos:DistToSqr(EyePos()) < 5000 or input.IsKeyDown(sit_key) then
        if !client.IsProne or !client:IsProne() then
            Hints:AddKeyDraw("Сесть", sit_key)
        end
    end

    local t_entity = trace.Entity
    if IsValid(t_entity) and t_entity:GetPos():DistToSqr(EyePos()) < 10000 then
        if t_entity:GetClass() == "arb_item" or t_entity:GetClass() == "arb_fridge" then
            Hints:AddKeyDraw("Использовать", "+use")
        elseif t_entity:GetClass() == "arb_container" or t_entity:GetClass() == "arb_wardrobe" then
            Hints:AddKeyDraw("Открыть", "+use")
        elseif t_entity:IsPlayer() then
            Hints:AddKeyDraw("Действия", "+use")
        else
            local model = t_entity:GetModel() or ""

            if BedSystem.allowBed[model:lower()] then
                Hints:AddKeyDraw("Лечь спать", "+use")
            end
        end
    end

    -- поменять в будущем с tfa на arc9
    local weapon = client:GetActiveWeapon()
    if IsValid(weapon) then
        local base = weapon.Base or ""
        local class = weapon:GetClass()

        if string.Left(base, 4) == "tfa_" then
            if base == "tfa_nmrimelee_base" then
                if !blockReload[class] then
                    local id = "tfa_safety_" .. class
                    local status = client:GetNetVar(id, false)

                    Hints:AddKeyDraw(status and "Поднять оружие" or "Опустить оружие", "+reload")
                end
            else
                Hints:AddKeyDraw("Проверить магазин", "+reload")
            end

            Hints:AddKeyDraw("Ударить", "+zoom")
        end
    end
end)

function Hints:Think()
    if !Hints.select then return end

    local time = RealTime()
    if time >= self.nextThink then
        local data = self.stored[self.select]
        if !data then return end

        if self.char < data:utf8len() then
            self.char = self.char + 1
            self.text = string.utf8sub(data, 1, self.char)
        end

        self.nextThink = time + 0.03
    end
end

local count = 0
function Hints:AddKeyDraw(text, key)
    local uniqueID = istable(key) and table.concat(key, "_") or key

    if !self.keysDraw[uniqueID] then
        count = count + 1

        self.keysDraw[uniqueID] = {
            text = text,
            key = key,
            id = count,
            alpha = 1
        }
    else
        self.keysDraw[uniqueID].text = text
        self.keysDraw[uniqueID].key = key
    end

    self.keysDraw[uniqueID].time = RealTime() + 0.5
end

local keysUseMat = {
    [MOUSE_RIGHT] = "danganronpa/ui/right_mouse.png",
    [MOUSE_LEFT] = "danganronpa/ui/left_mouse.png",
    ["+jump"] = "danganronpa/ui/space.png",
}

local padding = 0
local paddingX, paddingY = 25, 25
local function drawKey(info)
    local x, y = ScrW() - paddingX, ScrH() - paddingY - padding
    local w, h = draw.SimpleText(info.text, "arb.Font_FuturaPTBook_9", x, y, Color(255, 242, 245, info.alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

    x, y = x - w - h * 1.2, y - h

    local keys = istable(info.key) and info.key or {info.key}
    for k, v in ipairs(keys) do
        surface.SetDrawColor(255, 242, 245, (info.alpha / 255) * 12)
        surface.DrawOutlinedRect(x, y, h, h, 2)

        surface.SetDrawColor(1, 0, 0, (info.alpha / 255) * 153)
        surface.DrawRect(x, y, h, h)

        if keysUseMat[v] then
            local mat = Material(keysUseMat[v])

            local size = h * 0.8
            surface.SetDrawColor(255, 242, 245, info.alpha)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(x + (h - size) / 2, y + (h - size) / 2, size, size)
        else
            local button = v

            if isstring(button) then
                button = (input.LookupBinding(button) or ""):upper()
            else
                button = input.GetKeyName(button):upper()
            end

            if button != "" then
                button = button:gsub("MOUSE", "M")
                button = button:gsub("SPACE", "")

                draw.SimpleText(button, "arb.Font_FuturaPTDemi_8", x + h / 2 - 1, y + h / 2 - 1, Color(255, 242, 245, info.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText(info.button, "arb.Font_FuturaPTDemi_4", x + h / 2 - 1, y + h / 2 - 1, Color(255, 242, 245, info.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        x = x - h * 1.2
    end

    padding = padding + h * 1.2
end

local mat = Material("gui/gradient")
function Hints:HUDPaint()
    if self.select then
        self.alpha = Lerp(FrameTime() * 2, self.alpha, self.alphaTo)

        if self.alpha >= 0.1 then
            local w, h = draw.SimpleText(self.text, "arb.Font_FuturaPTBook_7", paddingX, paddingY, Color(255, 255, 255, self.alpha), TEXT_ALIGN_LEFT)

            surface.SetDrawColor(255, 255, 255, self.alpha)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(paddingX, paddingY + h, w, 1)
        end
    end

    if !SETTINGS.options.Get("interface_open_button") then return end

    local ft = FrameTime() * 10
    local time = RealTime()
    padding = 0
    for k, v in SortedPairsByMemberValue(self.keysDraw, "id") do
        drawKey(v)

        v.alpha = Lerp(ft, v.alpha, time < v.time and 255 or -2)

        if v.alpha <= 0 then
            self.keysDraw[k] = nil
        end
    end
end