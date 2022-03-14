local PLUGIN = PLUGIN

function PLUGIN:Think()
    -- логируем все нажатия на кнопки биндов
    for value in pairs(SETTINGS:GetStored().binds) do
        self.binds.IsPressedID(value, true)
        self.binds.IsClampedID(value, true)
    end

    -- print(PLUGIN.binds.GetClampedKey())
end

function PLUGIN:KeyPressID(client, id, bIsVisibleGUI)
    netstream.Start("SETTINGS:KeyPressID", client, id, bIsVisibleGUI)

    -- print(tostring(client) .. " нажал " .. id)
end

function PLUGIN:KeyReleaseID(client, id, bIsVisibleGUI)
    netstream.Start("SETTINGS:KeyReleaseID", client, id, bIsVisibleGUI)

    -- print(tostring(client) .. " отпустил " .. id)
end

-- function PLUGIN:KeyClampID(client, id)
    -- print(tostring(client) .. " зажал " .. id)
-- end