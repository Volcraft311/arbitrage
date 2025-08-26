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


local PLUGIN = PLUGIN

Ticket = PLUGIN
Ticket.name = "Tickets"
Ticket.instances = Ticket.instances or {}
Ticket.lastID = Ticket.lastID or 0
Ticket.types = Ticket.types or {}
Ticket.panel = Ticket.panel or nil

function Ticket:RegisterType(uniqueID, data)
    self.types[uniqueID] = data
end

Ticket:RegisterType("roleplay", {
    name = "Ролевой процесс"
})

function Ticket:New(id)
    if self.instances[id] then
        return self.instances[id]
    end

    local ticket = {id = id, messages = {}}
    setmetatable(ticket, Arbitrage.meta.ticket)

    self.instances[id] = ticket

    return ticket
end

function Ticket:Create(data)
    self.lastID = self.lastID + 1
    local id = self.lastID

    local ticket = self:New(id)
    ticket.type = "roleplay"
    ticket.time = os.time()

    ticket:SetOwner(data.owner)
    ticket.title = ("%s[%s]"):format(data.owner:Name(), data.owner:SteamName())

    ticket:AddMessage(data.owner, data.message, true)

    if SERVER then
        hook.Run("OnTicketCreate", data.owner, id, data.message)
    end

    return ticket
end

function Ticket:GetByID(id)
    return self.instances[id]
end

Arbitrage.base.Include("meta/sh_ticket.lua")

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")