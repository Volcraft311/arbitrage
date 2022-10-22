netstream.Hook("Character:CreationRegisterKeys", function(key, uniqueID, info)
	Character.CreationRegisterKeys(key, uniqueID, info)
end)

netstream.Hook("Character:CreationEditKeys", function(key, uniqueID, info)
	Character.CreationEditKeys(key, uniqueID, info)
end)

netstream.Hook("Character:CreationRemoveKeys", function(key, uniqueID)
	Character.CreationRemoveKeys(key, uniqueID)
end)

netstream.Hook("Character:CreationSync", function(key, stored)
	for uniqueID, info in pairs(stored) do
		Character.CreationRegisterKeys(key, uniqueID, info)
	end
end)