local PLUGIN = PLUGIN

netstream.Hook("SETTINGS:KeyPressID", function(client, id)
    hook.Run("KeyPressID", client, id)
end)

netstream.Hook("SETTINGS:KeyReleaseID", function(client, id)
    hook.Run("KeyReleaseID", client, id)
end)