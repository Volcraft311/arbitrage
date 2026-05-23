--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
Crafting = PLUGIN

Crafting.name = "Crafting"

function Crafting:AddEntity(className, data)
    local ENT = {}
    ENT.Type = "anim"
    ENT.Base = "base_anim"
    ENT.Author = "Selenter"
    ENT.PrintName = data.name
    ENT.Category = "Asterion Academy"
    ENT.Spawnable = true

    if SERVER then
        ENT.Initialize = function(this)
            this:SetModel(data.model)
            this:SetSolid(SOLID_VPHYSICS)
            this:PhysicsInit(SOLID_VPHYSICS)
            this:SetUseType(SIMPLE_USE)

            local physObj = this:GetPhysicsObject()
            if IsValid(physObj) then
                physObj:EnableMotion(false)
                physObj:Wake()
            end
        end

        ENT.Use = function(this, client, caller)
            Crafting:RecipeProcessing(client, this)
        end
    else
        ENT.Draw = function(this)
            this:DrawModel()
        end

        ENT.Tooltip = function(this, tooltip)
            tooltip:SetTitle(data.name)
            tooltip:SetDescription(data.description)
            tooltip:SetIcon("asterion/academy/ui/tooltip/wardrobe.png")

            local countItems = {}
            local items = this:GetItems()
            for _, item in ipairs(items) do
                local name = item:GetName()

                countItems[name] = (countItems[name] or 0) + 1
            end

            tooltip:AddSubMenu("Находящиеся предметы:", function(panel)
                panel.Paint = function(_, w, h)
                    local size = h * 0.15

                    surface.SetDrawColor(66, 125, 213)
                    surface.DrawRect(0, size, w, h - size * 2)
                end
            end)

            for name, count in pairs(countItems) do
                tooltip:AddSubMenu(name .. " - " .. count .. "x")
            end
        end
    end

    ENT.CalculateOBB = function(this)
        local min = this:OBBMins()
        local max = this:OBBMaxs()

        local padding = max.z - min.z

        local newMin = Vector(
            -math.max(math.abs(min.x), math.abs(min.y)),
            -math.max(math.abs(min.x), math.abs(min.y)),
            min.z + padding
        )

        local newMax = Vector(
            math.max(math.abs(max.x), math.abs(max.y)),
            math.max(math.abs(max.x), math.abs(max.y)),
            max.z + padding
        )

        return newMin, newMax
    end

    ENT.GetItems = function(this)
        local pos = this:GetPos()
        local min, max = this:CalculateOBB()

        local items = {}
        local entities = ents.FindInBox(pos + min, pos + max)
        for _, entity in ipairs(entities) do
            local class = entity:GetClass()
            if class != "arb_item" then continue end

            local item = entity:GetItem()
            if !item then continue end

            items[#items + 1] = item
        end

        return items
    end

    scripted_ents.Register(ENT, className)
end

Crafting:AddEntity("arb_craft_workbench", {
    name = "Верстак",
    description = "test asdajkd kajs jkasdjk",
    model = "models/props_wasteland/controlroom_desk001b.mdl"
})


Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")