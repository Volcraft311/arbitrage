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

local PANEL = {}

local deathTime = 10
function PANEL:Init()
    if IsValid(Arbitrage.gui.death) then
        Arbitrage.gui.death:Remove()
    end

    Arbitrage.gui.death = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)

    self.labelTitle = ""
    self.labelText = ""

    self.characterTitle = 0
    self.characterText = 0

    self.spectateTime = os.time() + deathTime

    self.alpha = 0

    self.nextThink = RealTime() + 1
    self.textThink = self.nextThink
end

function PANEL:TickSound()
    asterionlib.EmitSound("common/talk.wav", 100, math.random(190, 200))
end

function PANEL:Think()
    local deathTitle = L("#deathscreen_title")
    local deathText = L("#deathscreen_text")

    local time = RealTime()
    if time >= self.nextThink then
        if self.characterTitle < deathTitle:utf8len() then
            self.characterTitle = self.characterTitle + 1
            self.labelTitle = string.utf8sub(deathTitle, 1, self.characterTitle)

            self:TickSound()
            self.textThink = time + 2
        else
            local formatDeathText = deathText:format(math.Clamp(self.spectateTime - os.time(), 0, deathTime))

            if self.characterText < formatDeathText:utf8len() and time >= self.textThink then
                self.characterText = self.characterText + 1
                self:TickSound()
            end

            self.labelText = string.utf8sub(formatDeathText, 1, self.characterText)
        end

        self.nextThink = time + 0.05
    end

    self.alpha = math.abs(math.sin(CurTime() * 2) * 255) * 0.01

    if (self.spectateTime - os.time()) <= 0 and !self.removemenu then
        self.removemenu = true

        self:AlphaTo(0, 1, 0, function()
            self:Remove()
        end)
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 44, 44, self.alpha)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(self.labelTitle, "arb.Font_FuturaPTDemi_20", ScrW() / 2, ScrH() * 0.4, color_white, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.labelText, "arb.Font_FuturaPTBook_12", ScrW() / 2, ScrH() * 0.45, color_white, TEXT_ALIGN_CENTER)
end

vgui.Register("arb.DeathMenu", PANEL, "EditablePanel")