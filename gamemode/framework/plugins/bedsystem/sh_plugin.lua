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
BedSystem = PLUGIN

BedSystem.name = "BedSystem"
BedSystem.animation = "d1_town05_Wounded_Idle_1"
BedSystem.allowBed = {
    ["models/props_downtown/bed_motel01.mdl"] = {
        pos = Vector(0, 0, 30),
        ang = Angle(0, 90, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * -25 + Vector(0, 0, 41) --Vector(vec[1] + ang:Right()[1] * 5, vec[2], vec[3] + 40)
            end,
            ang = Angle(10, 180, 3)
        }
    },
    ["models/env/furniture/bed_andrea/bed_andrea_1st.mdl"] = {
        pos = Vector(-50, 0, 30),
        ang = Angle(0, -90, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * -25 + Vector(0, 0, 41)
            end,
            ang = Angle(10, 180, 3)
        }
    },
    ["models/env/furniture/bed_secondclass/beddouble_group.mdl"] = {
        pos = Vector(0, 0, 30),
        ang = Angle(0, -90, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * 25 + ang:Forward() * -20 + Vector(0, 0, 41)
            end,
            ang = Angle(10, 180, 3)
        }
    },
    ["models/props_interiors/bed_motel.mdl"] = {
        pos = Vector(0, 0, 30),
        ang = Angle(0, 90, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * -25 + Vector(0, 0, 41)
            end,
            ang = Angle(10, 180, 3)
        }
    },
    ["models/props_vtmb/fancybed.mdl"] = {
        pos = Vector(10, 0, 30),
        ang = Angle(0, 180, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * 1 + ang:Forward() * -20 + Vector(0, 0, 41)
            end,
            ang = Angle(10, 180, 3)
        }
    },
    ["models/props_vtmb/heartbed.mdl"] = {
        pos = Vector(10, 0, 35),
        ang = Angle(0, 270, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * 20 + ang:Forward() * 1 + Vector(0, 0, 46)
            end,
            ang = Angle(10, 180, 3)
        }
    },
    ["models/props_c17/furniturebed001a.mdl"] = {
        pos = Vector(-5, 0, -5),
        ang = Angle(0, 180, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * 1 + ang:Forward() * -15
            end,
            ang = Angle(10, 180, 3)
        }
    },
    ["models/haxxer/normandy/comfybed.mdl"] = {
        pos = Vector(-5, 0, 30),
        ang = Angle(0, 180, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * 1 + ang:Forward() * -15 + ang:Up() * 32
            end,
            ang = Angle(10, 180, 3)
        }
    },
}

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_bedlist.lua")
Arbitrage.base.Include("sv_plugin.lua")