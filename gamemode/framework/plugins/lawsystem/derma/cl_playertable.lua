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

local PANEL = {}

local mat = Material("danganronpa/law/table/base.png")
local active = Material("danganronpa/law/table/active.png")
local disable = Material("danganronpa/law/table/disable.png")

function PANEL:Init()
    self:SetPos(ScrW() - W(582) - 30, 30)
    self:SetSize(W(582), H(100))
    self:SetZPos(20001)

    Arbitrage.gui.playertable = self

    self.selectClient = ""
    self.labelText = ""
    self.characterText = 0
    self.standartText = ""

    self.nextThink = RealTime()
    self.textThink = self.nextThink

    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.players = {}

    local tablePl = self:Add("DIconLayout")
    tablePl:SetPos(self:GetWide() - W(260), H(58))
    tablePl:SetSize(W(210), self:GetTall())
    tablePl:SetSpaceX(6)
    tablePl:SetSpaceY(2)

    for k, v in pairs(player.GetAll()) do
        if v:LawPlace() < 0 then continue end

        local panel = tablePl:Add("Panel")
        panel:SetSize(15, 15)
        panel.steamid = v:SteamID()
        panel.alpha = 0

        panel.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 5, _.alpha, self.selectClient == _.steamid and 255 or 0)

            local size = 25
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(disable)
            surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

            if _.alpha < 0.1 then return end

            size = (math.abs(math.sin(RealTime() * 4)) * 13) + 10

            surface.SetDrawColor(255, 255, 255, _.alpha)
            surface.SetMaterial(active)
            surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
        end

        self.players[v:SteamID()] = panel
    end
end

function PANEL:SetText(data)
    self.characterText = 0
    self.standartText = data
end

function PANEL:SetPlayer(data)
    if !IsValid(data) then return end

    local steamid = data:SteamID()
    if steamid == self.selectClient then return end

    local name = data:Name()

    self:SetText(name)
    self.selectClient = steamid
end

function PANEL:Think()
    local time = RealTime()
    if time >= self.nextThink then
        if self.characterText < self.standartText:utf8len() then
            self.characterText = self.characterText + 1
            self.labelText = string.utf8sub(self.standartText, 1, self.characterText)
        end

        self.nextThink = time + 0.05
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.DrawText(self.labelText, "arb.LawTableFont", w - W(30), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
end

vgui.Register("arb.LawPlayerTable", PANEL, "EditablePanel")