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

function Ticket:SyncAll(client)
    local tickets = {}

    for _, ticket in pairs(Ticket.instances) do
        if ticket:IsReciver(client) then
            local data = ticket:GetData()

            tickets[ticket.id] = data
        end
    end

    if table.Count(tickets) <= 0 then return end

    netstream.Heavy(client, "Ticket:SyncAll", tickets)
end


hook("PlayerInitialSpawnForRealz", function(client)
    Ticket:SyncAll(client) -- FIX : Heavy при заходе!!
end)


netstream.Hook("Ticket:SendMessage", function(client, id, message)
    local ticket = Ticket:GetByID(id)
    if !ticket then return end

    if !ticket:IsReciver(client) then return end

    message = message:Trim()
    if message == "" then return end

    hook.Run("OnTicketSendMessage", client, ticket, message)

    ticket:AddMessage(client, message)
end)

netstream.Hook("Ticket:CloseRequest", function(client, id)
    local ticket = Ticket:GetByID(id)
    if !ticket then return end

    if !ticket:IsReciver(client) then return end

    hook.Run("OnTicketClose", client, ticket)

    ticket:Remove()
end)