local PLUGIN = PLUGIN

function PLUGIN:InitPostEntity()
    SETTINGS.Load()

    hook.Run("OnSettingsLoad")
end