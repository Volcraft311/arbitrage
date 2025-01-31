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
AdminESP = PLUGIN

AdminESP.name = "AdminESP"

AdminESP.playerinfo = {}
AdminESP.entityinfo = {}

AdminESP.entslist = {
    ["prop_ragdoll"] = {Color(157, 111, 210), function(entity)
        if entity:GetNetVar("sIsRagdoll") then
            return false
        end
    end},
    ["arb_player"] = {Color(111, 175, 210)},
    ["arb_wardrobe"] = {Color(111, 175, 210)},
    ["arb_fridge"] = {Color(111, 175, 210)},
    ["arb_dead"] = {Color(111, 175, 210)},
    ["arb_item"] = {Color(213, 150, 56)},
    ["arb_container"] = {Color(240, 73, 61)},
}

function AdminESP:AddPlayerESPCustomization(index, data)
    if !index then return end
    if !data then return end

    data.index = index
    self.playerinfo[#self.playerinfo + 1] = data
end

function AdminESP:AddEntityESPCustomization(index, data)
    if !index then return end
    if !data then return end

    data.index = index
    self.entityinfo[#self.entityinfo + 1] = data
end

function AdminESP:DistanceFits(vec1, vec2, dist)
    if dist == 0 then return true end

    return vec1:Distance(vec2) <= dist
end

local function addStructure(entity, info)
    local dist = info.dist
    local data = info.data

    if isfunction(data) and !info.isfunc then
        data = data(entity)
    end

    return {data, dist}
end

local PLAYER = FindMetaTable("Player")
function PLAYER:ESPInfo()
    local data = {}

    for k, v in ipairs(AdminESP.playerinfo) do
        data[#data + 1] = addStructure(self, v)
    end

    return data
end

function PLAYER:IsSpectating()
    return self:GetLocalVar("spectating", false)
end

local ENTITY = FindMetaTable("Entity")
function ENTITY:ESPInfo()
    local data = {}

    for k, v in ipairs(AdminESP.entityinfo) do
        data[#data + 1] = addStructure(self, v)
    end

    return data
end

Arbitrage.base.Include("cl_config.lua")
Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_spectate.lua")
Arbitrage.base.Include("sv_plugin.lua")
Arbitrage.base.Include("sv_spectate.lua")