local PLUGIN = PLUGIN

netstream.Hook("DescriptiveText:SetDescription", function(client, data)
    client.DescriptiveTextDescription = data or "Ваш текст"
end)