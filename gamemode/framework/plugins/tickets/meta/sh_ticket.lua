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


local TICKET = {}
TICKET.__index = TICKET

TICKET.title = ""
TICKET.id = 0
TICKET.owner = nil
TICKET.panel = nil
TICKET.time = nil
TICKET.messages = {}
TICKET.type = "roleplay"

function TICKET:__tostring()
    return "ticket[" .. self.id .. "]"
end

function TICKET:__eq(other)
    return self:GetID() == other:GetID()
end

function TICKET:GetID()
    return self.id
end

---@return Player|nil
function TICKET:GetOwner()
    if IsValid(self._owner) then
        return self._owner
    end

    local client = player.GetBySteamID(self.owner)
    if client and IsValid(client) then
        self._owner = client

        return client
    end
end

function TICKET:GetData()
    local data = {
        title = self.title,
        type = self.type,
        messages = self.messages,
        owner = self.owner,
        time = self.time
    }

    return data
end

function TICKET:GetRecivers()
    local recivers = player.GetAdmins()

    local owner = self:GetOwner()
    if IsValid(owner) then
        recivers[#recivers + 1] = owner
    end

    return recivers
end

function TICKET:IsReciver(client)
    local recivers = self:GetRecivers()

    for _, v in ipairs(recivers) do
        if v == client then
            return true
        end
    end

    return false
end

function TICKET:SetOwner(client)
    self.owner = client:SteamID()
    self._owner = client
end

function TICKET:Remove()
    if SERVER then
        netstream.Start(nil, "Ticket:Remove", self.id)
    else
        local panel = self:GetPanel()
        if IsValid(panel) then
            panel:Remove()
        end
    end

    Ticket.instances[self.id] = nil
end

if SERVER then
    function TICKET:Sync()
        local recivers = self:GetRecivers()

        local data = self:GetData()
        netstream.Start(recivers, "Ticket:Sync", self.id, data)
    end

    function TICKET:AddMessage(client, message, bNoSync)
        local data = {
            owner = client:SteamID(),
            title = client:Name(),
            time = os.date("%H:%M"),
            message = message
        }

        self.messages[#self.messages + 1] = data

        if #self.messages > 50 then
            table.remove(self.messages, 1)
        end

        if !bNoSync then
            local recivers = self:GetRecivers()
            netstream.Start(recivers, "Ticket:AddMessage", self.id, data)
        end
    end
else
    function TICKET:GetPanel()
        return self.panel
    end

    function TICKET:SendMessage(message)
        netstream.Start("Ticket:SendMessage", self.id, message)
    end

    function TICKET:CloseRequest()
        netstream.Start("Ticket:CloseRequest", self.id)
    end
end


Arbitrage.meta.ticket = TICKET