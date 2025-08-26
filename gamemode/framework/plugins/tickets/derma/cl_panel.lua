--[[
        © AsterionStaff 2025.
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
    Ticket.panel = self

    self:SetTitle("")
    self:ShowCloseButton(false)

    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self:SetZPos(32000)

    local width = ScrH() * 0.37
    local heigth = ScrH() - 50

    self:SetPos(ScrW() - width - 50, 50)
    self:SetSize(width, heigth)

    self.panels = {}
    self.ticket = nil

    self:LoadTickets()

    Ticket:SetDraggblePanel()
end

function PANEL:LoadTicket(ticket, bNoSound)
    if IsValid(self.panels[ticket.id]) then
        self.panels[ticket.id]:Remove()
    end

    local panel = self:Add("Ticket:SubPanel")
    panel:Dock(TOP)
    panel:SetTicket(ticket)

    self.panels[ticket.id] = panel

    ticket.panel = panel

    if !bNoSound then
        asterionlib.EmitSound("garrysmod/save_load4.wav", 75, 100, 0.05)
    end

    return panel
end

function PANEL:LoadTickets()
    for _, ticket in pairs(Ticket.instances) do
        self:LoadTicket(ticket, true)
    end
end

function PANEL:Paint()
end

vgui.Register("Ticket:Panel", PANEL, "DFrame")

timer.Simple(1, function()
    if !IsValid(Ticket.panel) then
        Ticket.panel = vgui.Create("Ticket:Panel")
    end
end)