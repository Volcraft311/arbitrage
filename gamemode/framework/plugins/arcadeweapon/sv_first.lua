--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

local function dropEntity(client, entity)
    if IsValid(entity) and client:GetLocalVar("owner") != nil then
        client:SetLocalVar("owner", nil)
    end

    client.Drag = nil
end

function PLUGIN:PlayerPostThink(client)
    if client and client:oldAlive() then
        local weapon = client:GetActiveWeapon()
        if weapon and IsValid(weapon) and weapon:GetClass() == "academy_first" then
            if !client.Drag then return end

            local pos = client:GetShootPos()
            local aim = client:GetAimVector()
            local entity = client.Drag.Entity

            if (client:KeyDown(IN_ATTACK2) or client:KeyDown(IN_ATTACK)) and IsValid(entity) and entity:GetPos():Distance(client:GetPos()) <= 500 then
                local Phys = entity:GetPhysicsObject()
                if !IsValid(Phys) then return end
                if Phys:GetMass() >= 400 then return dropEntity(client, entity) end

                if IsValid(Phys) then
                    local Pos2 = pos + aim * 150 * client.Drag.Fraction
                    local OffPos = entity:LocalToWorld(client.Drag.OffPos)
                    local Dif = Pos2 -OffPos
                    local Nom = (Dif:GetNormal() * math.min(1, Dif:Length() / 100) * 500 -Phys:GetVelocity()) * Phys:GetMass()

                    Phys:ApplyForceOffset(Nom, OffPos)
                    Phys:AddAngleVelocity(-Phys:GetAngleVelocity() / 4)
                end
            else
                dropEntity(client, entity)
            end
        end
    end
end

function PLUGIN:ArcadeFistsSecondary(client)
    local pos = client:GetShootPos()
    local aim = client:GetAimVector()

    local trace = util.TraceLine{
        start = pos,
        endpos = pos + aim * 150,
        filter = player.GetAll(),
    }

    local entity = trace.Entity
    if client.Drag then
        entity = client.Drag.Entity
    else
        if !IsValid(entity) or entity:GetMoveType() != MOVETYPE_VPHYSICS or entity:IsVehicle() or IsValid(entity:GetParent()) then return end

        if !client.Drag then
            client.Drag = {
                OffPos = entity:WorldToLocal(trace.HitPos),
                Entity = entity,
                Fraction = trace.Fraction,
            }

            client:SetLocalVar("owner", {client.Drag.OffPos, entity})
        end
    end
end

function PLUGIN:EntityTakeDamage(target, dmginfo)
    local attacker = dmginfo:GetAttacker()

    if dmginfo:GetDamageType() == 1 then -- Удар от пропа
        return dmginfo:SetDamage(0)
    end

    if attacker and IsValid(attacker) and attacker:IsPlayer() then
        local weapon = attacker:GetActiveWeapon()
        if weapon and IsValid(weapon) then
        	local class = weapon:GetClass()
        	if class != "academy_first" then return end

            dmginfo:SetDamage(target:Health() <= 5 and 0 or 2)
        end
    end
end