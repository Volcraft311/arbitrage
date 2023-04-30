local PLUGIN = PLUGIN

util.AddNetworkString("arb.ChatMessage")
util.AddNetworkString("arb.ChatIsTyping")

net.Receive("arb.ChatMessage", function(length, client)
    local text = net.ReadString()

    if ((client.ixNextChat or 0) < CurTime() and isstring(text) and text:find("%S")) then
        hook.Run("PlayerSay", client, text)

        client:SetNetVar("arb.chattype", nil)
        client.ixNextChat = CurTime() + 0.5
    end
end)

net.Receive("arb.ChatIsTyping", function(len, client)
    client:SetNWBool("IsTyping", net.ReadBool())
end)

netstream.Hook("arb.SetChatType", function(client, data)
    local oldVar = client:GetNetVar("arb.chattype")

    local value = PLUGIN.typesData[data]
    if oldVar == value then return end

    client:SetNetVar("arb.chattype", value)
end)