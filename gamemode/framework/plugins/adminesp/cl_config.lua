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

--[[
    Players
]]--
PLUGIN:AddPlayerESPCustomization("name_pl", {
    dist = 0,
    config = {
        name = "Имя персонажа",
        desc = "Включить показатель имени персонажа"
    },
    data = function(entity)
        return entity:Name()
    end
})

PLUGIN:AddPlayerESPCustomization("steamname_pl", {
    dist = 0,
    config = {
        name = "STEAM Имя персонажа",
        desc = "Включить показатель имени персонажа"
    },
    data = function(entity)
        return entity:SteamName()
    end
})

PLUGIN:AddPlayerESPCustomization("rank_pl", {
    dist = 1500,
    config = {
        name = "Ранг игрока",
        desc = "Включить показатель ранга игрока"
    },
    data = function(entity)
        return entity:GetUserGroup()
    end
})

PLUGIN:AddPlayerESPCustomization("hp_armor_pl", {
    dist = 1000,
    config = {
        name = "Состояние игрока",
        desc = "Включить показатель состояния игрока"
    },
    data = function(entity)
        return entity:Health() .. "/" .. entity:Armor()
    end
})

PLUGIN:AddPlayerESPCustomization("weapon_pl", {
    dist = 1000,
    config = {
        name = "Оружие игрока",
        desc = "Включить показатель информации о оружии игрока"
    },
    data = function(entity)
        local weapon = entity:GetActiveWeapon()
        if weapon and IsValid(weapon) then
            return weapon:GetPrintName() .. "[" .. weapon:GetClass() .. "] — " .. weapon:Clip1() .. "/" .. entity:GetAmmoCount(weapon:GetPrimaryAmmoType())
        end
    end
})

PLUGIN:AddPlayerESPCustomization("trace_pl", {
    dist = 1000,
    config = {
        name = "Прицел игрока",
        desc = "Показывать куда смотрит игрок"
    },
    data = function(entity)
        if entity:IsDormant() then return end

        local col = team.GetColor(entity:Team())

        local tr = {}
        tr.start = entity:EyePos()
        tr.endpos = (entity:GetAimVector() * 99999)
        tr.filter = {entity}

        local trace = util.TraceLine(tr).HitPos
        local trace2D = trace:ToScreen()
        local eyePos2D = entity:EyePos():ToScreen()

        if !trace2D.visible then return end

        surface.SetDrawColor(col)
        surface.DrawRect(trace:ToScreen().x - 2.5, trace:ToScreen().y - 2.5, 5, 5)

        if !eyePos2D.visible then return end

        surface.DrawLine(eyePos2D.x, eyePos2D.y, trace2D.x, trace2D.y)
    end,
    isfunc = true
})

PLUGIN:AddPlayerESPCustomization("observer_pl", {
    dist = 0,
    config = {
        name = "ОбСервер статус",
        desc = "Включить показатель состояния ОбСервера игрока"
    },
    data = function(entity)
        if entity:GetMoveType() == MOVETYPE_NOCLIP then
            return "[OBSERVER]"
        end
    end
})

PLUGIN:AddPlayerESPCustomization("fallover_pl", {
    dist = 0,
    config = {
        name = "Fallover статус",
        desc = "Включить показатель состояния Fallover-а игрока"
    },
    data = function(entity)
        local ragdoll = entity:IsRagdolling()

        if ragdoll then
            return "[FALLOVER]"
        end
    end
})

--[[
    Entity
]]--
PLUGIN:AddEntityESPCustomization("name_en", {
    dist = 3000,
    config = {
        name = "Название энтити",
        desc = "Включить показатель названия энтити"
    },
    data = function(entity)
        local class = entity:GetClass()
        if class == "arb_item" then
            local itemTable = entity.GetItemTable and entity:GetItemTable()
            if itemTable then
                return itemTable.GetName and itemTable:GetName()
            end
        end

        return "Неизвестно"
    end
})

PLUGIN:AddEntityESPCustomization("class_en", {
    dist = 1000,
    config = {
        name = "Класс энтити",
        desc = "Включить показатель класса энтити"
    },
    data = function(entity)
        return entity:GetClass()
    end
})

PLUGIN:AddEntityESPCustomization("hp_en", {
    dist = 1000,
    config = {
        name = "Состояние энтити",
        desc = "Включить показатель состояния энтити"
    },
    data = function(entity)
        return entity:Health() .. "/" .. entity:GetMaxHealth()
    end
})

PLUGIN:AddEntityESPCustomization("model_en", {
    dist = 200,
    config = {
        name = "Модель энтити",
        desc = "Включить показатель модели энтити"
    },
    data = function(entity)
        return entity:GetModel()
    end
})