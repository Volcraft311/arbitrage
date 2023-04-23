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

local mat = Material("gui/gradient")
local paddingX, paddingY = 20, 10
function Hints:HUDPaint()
    if !self.select then return end

    self.alpha = Lerp(FrameTime() * 2, self.alpha, self.alphaTo)

    if self.alpha < 0.1 then return end
    local w, h = draw.SimpleText(self.text, "arb.Font_FuturaPTBook_7", paddingX, paddingY, Color(255, 255, 255, self.alpha), TEXT_ALIGN_LEFT)

    surface.SetDrawColor(255, 255, 255, self.alpha)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(paddingX, paddingY + h, w, 1)
end