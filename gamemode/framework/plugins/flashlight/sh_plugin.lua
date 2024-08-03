--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
Flashlight = PLUGIN

Flashlight.name = "Flashlight"

do -- удаляем луа файлы аддонов на фонарик (моделька почему то всегда внутри себя имеет еще lua файлики который закачиваются в одиночке из-за resource.AddWorkshop)
    if TPF_Update or OpenTPFSaveFileDialog or GetConVar("cl_flashlight_texture") then
        TPF_Update = nil
        TPF_UpdateLight = nil
        TPF_CanUpdate = nil
        TPF_SwitchFlashlightHook = nil
        TPF_SwitchFlashlight = nil
        TPF_RemoveProjectedTexture = nil
        TPF_SetupProjectedTexture = nil
        TPF_ShouldUseTPF = nil

        hook.Remove("PlayerSwitchFlashlight", "TPF_SwitchFlashlightHook")
        hook.Remove("PlayerInitialSpawn", "TPF_InitServerDefaults")
        hook.Remove("PlayerPostThink", "TPF_Update")
        hook.Remove("CalcView", "TPF_CalcView")
        hook.Remove("PopulateToolMenu", "TPF_AddMenuItem")
        hook.Remove( "PlayerLoadout", "FlashlighLoadout")
        hook.Remove( "StartCommand", "SWEP FlashlightBind")

        local meta = FindMetaTable("Player")

        meta.oldAllowFlashlight = meta.oldAllowFlashlight or meta.TPF_AllowFlashlight or meta.AllowFlashlight
        meta.AllowFlashlight = meta.oldAllowFlashlight

        meta.oldFlashlight = meta.oldFlashlight or meta.TPF_Flashlight or meta.Flashlight
        meta.Flashlight = meta.oldFlashlight

        meta.oldFlashlightIsOn = meta.oldFlashlightIsOn or meta.TPF_FlashlightIsOn or meta.FlashlightIsOn
        meta.FlashlightIsOn = meta.oldFlashlightIsOn
    end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")