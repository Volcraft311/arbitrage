--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

local function dropEntity(client, entity)
    if IsValid(entity) and client:GetNetVar("owner") != nil then
        client:SetNetVar("owner", nil, client)
    end

    if client.Drag then
        --client:SetWalkSpeed(arcade.standart_walkspeed)
        --client:SetRunSpeed(arcade.standart_runspeed)
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

                if Phys:GetMass() >= 400 then
                    dropEntity(client, entity)
                    return
                end

                if entity:GetClass() == "prop_ragdoll" and entity:GetNetVar("sleeprag") then
                    dropEntity(client, entity)
                    return
                end

                if IsValid(Phys) then
                    local Pos2 = pos + aim * 150 * client.Drag.Fraction
                    local OffPos = entity:LocalToWorld( client.Drag.OffPos )
                    local Dif = Pos2 -OffPos
                    local Nom = (Dif:GetNormal() * math.min(1, Dif:Length() / 100) * 500 -Phys:GetVelocity()) * Phys:GetMass()

                    Phys:ApplyForceOffset( Nom, OffPos )
                    Phys:AddAngleVelocity( -Phys:GetAngleVelocity() / 4 )

                    --client:SetWalkSpeed(arcade.standart_walkspeed * 0.8)
                    --client:SetRunSpeed(arcade.standart_walkspeed * 0.8)
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
        if not IsValid( entity ) or entity:GetMoveType() != MOVETYPE_VPHYSICS or
            entity:IsVehicle() or entity:GetNWBool( "NoDrag", false ) or
            entity.BlockDrag or
            IsValid( entity:GetParent() ) then
            return
        end

        if not client.Drag then
            client.Drag = {
                OffPos = entity:WorldToLocal(trace.HitPos),
                Entity = entity,
                Fraction = trace.Fraction,
            }

            client:SetNetVar("owner", {client.Drag.OffPos, entity}, client)
        end
    end
end

function PLUGIN:PlaceDecal(client, ent, data)
    if (!IsValid(ent) and !ent:IsWorld()) then return end

    local bone
    if ( data.bone and data.bone < ent:GetPhysicsObjectCount() ) then
        bone = ent:GetPhysicsObjectNum( data.bone )
    end

    if (!IsValid(bone)) then
        bone = ent:GetPhysicsObject()
    end

    if (!IsValid(bone)) then
        bone = ent
    end

    util.Decal(data.decal, bone:LocalToWorld( data.Pos1 ), bone:LocalToWorld(data.Pos2), client)

    local i = ent.DecalCount or 0
    i = i + 1
    duplicator.StoreEntityModifier( ent, "decal" .. i, data )
    ent.DecalCount = i
end

function PLUGIN:EntityTakeDamage(target, dmginfo)
    local attacker = dmginfo:GetAttacker()

    if dmginfo:GetDamageType() == 32 then -- Падение
        local trace = util.TraceLine({
            start = target:GetPos(),
            endpos = target:GetPos() - target:GetAngles():Up() * 99999999,
            filter = player.GetAll()
        })
    end

    if dmginfo:GetDamageType() == 1 then -- Удар от пропа
        dmginfo:SetDamage(0)
        return
    end

    if attacker and IsValid(attacker) and attacker:IsPlayer() then
        local weapon = attacker:GetActiveWeapon()
        if weapon and IsValid(weapon) then
        	local class = weapon:GetClass()
        	if class != "academy_first" then return end

            dmginfo:SetDamage(target:Health() <= 20 and 0 or 2)
        end
    end
end