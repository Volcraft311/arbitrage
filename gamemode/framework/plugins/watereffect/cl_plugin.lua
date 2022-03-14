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

game.AddParticles("particles/zen_water_effects.pcf")

PrecacheParticleSystem("zen_player_drips")
PrecacheParticleSystem("zen_player_drips_3_sec")
PrecacheParticleSystem("zen_player_drips_2_sec")
PrecacheParticleSystem("zen_player_drips_full")

--function PLUGIN:Think()
    -- >> ТРЕБУЕТСЯ ПЕРЕРАБОТКА <<
    --[[
    for k, v in pairs(player.GetAll()) do
        local data = v:GetNetVar("watereffect")
        local pos = v:GetPos()

        if EyePos():Distance(pos) <= 200 and data and
            data >= CurTime() and IsValid(v) and v:Alive() and
            v:IsPlaying() and (not v.WaterEffect or CurTime() >= v.WaterEffect) then

            for i = 1, 10 do
                ParticleEffectAttach("zen_player_drips", 1, v, 0)
            end

            v.WaterEffect = CurTime() + 1
        end
    end
    ]]--
--end