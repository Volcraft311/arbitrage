netstream.Hook("Photos:Request", function(client, isFlash)
	if client:GetActiveWeaponClass() != "academy_camera" then return end

	if (!client.cdPhoto or CurTime() >= client.cdPhoto) then
		local inventory = client:GetInventory()
		if !inventory then return end

		client:EmitSound(Sound("NPC_CScanner.TakePhoto"))
		client:SetAnimation(PLAYER_ATTACK1)

		if isFlash then
			local vPos = client:GetShootPos()
			local vForward = client:GetAimVector()

			local trace = {}
			trace.start = vPos
			trace.endpos = vPos + vForward * 256
			trace.filter = client

			local tr = util.TraceLine(trace)

			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			util.Effect("camera_flash", effectdata, true)
		end

		asterionlib.sg:Request(client, function(image)
			local item = ItemBase.CreateItem("camera_image")
			if !item then return end

			item.image = image
			local notify = item:Transfer(inventory:GetID())
			if notify then
				item:Spawn(client:GetPos() + Vector(0, 0, 20))
			end
		end)

		client.cdPhoto = CurTime() + 10
	else
		client:ChatNotify(L(client, "#notify_wait_camera", math.floor(client.cdPhoto - CurTime())))
	end
end)