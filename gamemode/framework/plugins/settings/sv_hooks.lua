local PLUGIN = PLUGIN

netstream.Hook("SETTINGS:KeyPressID", function(client, id, bIsVisibleGUI)
    hook.Run("KeyPressID", client, id, bIsVisibleGUI)
end)

netstream.Hook("SETTINGS:KeyReleaseID", function(client, id, bIsVisibleGUI)
    hook.Run("KeyReleaseID", client, id, bIsVisibleGUI)
end)