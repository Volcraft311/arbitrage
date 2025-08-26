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


function Ticket:SetDraggblePanel()
    if IsValid(Ticket.panel) then
        local count = table.Count(Ticket.instances)

        Ticket.panel:SetDraggable(count > 0 and true or false)
    end
end

function Ticket:SyncTicket(id, data)
    local ticket = Ticket:New(id)
    ticket.title = data.title
    ticket.type = data.type
    ticket.messages = data.messages
    ticket.time = data.time

    local client = player.GetBySteamID(data.owner)
    if IsValid(client) and client:IsPlayer() then
        ticket:SetOwner(client)
    end

    local panel = Ticket.panel
    if IsValid(panel) then
        panel:LoadTicket(ticket)
    end
end


netstream.Hook("Ticket:AddMessage", function(id, data)
    local ticket = Ticket:GetByID(id)
    if !ticket then return end

    local sender = player.GetBySteamID(data.owner)
    if IsValid(sender) and sender:IsPlayer() and ticket.owner != data.owner then
        data.title = sender:SteamName()
    end

    ticket.messages[#ticket.messages + 1] = data

    if #ticket.messages > 50 then
        table.remove(ticket.messages, 1)
    end

    local panel = ticket:GetPanel()
    if IsValid(panel) then
        panel:AddMessage(data)
    end

    asterionlib.EmitSound("garrysmod/ui_hover.wav", 75, 100, 1)
end)

netstream.Hook("Ticket:Remove", function(id)
    local ticket = Ticket:GetByID(id)
    if !ticket then return end

    ticket:Remove()

    Ticket:SetDraggblePanel()
end)

netstream.Hook("Ticket:Sync", function(id, data)
    Ticket:SyncTicket(id, data)

    Ticket:SetDraggblePanel()
end)

netstream.Hook("Ticket:SyncAll", function(tickets)
    for id, data in pairs(tickets) do
        Ticket:SyncTicket(id, data)
    end

    Ticket:SetDraggblePanel()
end)


concommand.Add("arb_tickets_reload", function()
    if IsValid(Ticket.panel) then
        Ticket.panel:Remove()
    end

    Ticket.panel = vgui.Create("Ticket:Panel")
end)