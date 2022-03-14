--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

game.AddParticles( "particles/zen_water_effects.pcf" ) 

PrecacheParticleSystem( "zen_player_drips" )
PrecacheParticleSystem( "zen_player_drips_full" )
PrecacheParticleSystem( "zen_player_drips_3_sec" )
PrecacheParticleSystem( "zen_player_drips_2_sec" )

resource.AddFile( "particles/zen_water_effects.pcf" )

-- function PLUGIN:WaterEffect(client)
--     if client:WaterLevel() > 1 then
--         client.InfoTable = client.InfoTable or {}
--         client.InfoTable["water"] = {"Следы воды", Color(0, 132, 255)}
--         client:SetNetVar("watereffect", CurTime() + 60)
--         client:SetNetVar("infotable", client.InfoTable)
--     end

--     client.InfoTable = client.InfoTable or {}
--     if client.InfoTable["water"] and CurTime() >= client:GetNetVar("watereffect", 0) then
--         client.InfoTable["water"] = nil

--         client:SetNetVar("infotable", client.InfoTable)
--     end
-- end

-- function PLUGIN:PlayerOneSecond(client)
--     if !IsValid(client) then return end

--     self:WaterEffect(client)
-- end