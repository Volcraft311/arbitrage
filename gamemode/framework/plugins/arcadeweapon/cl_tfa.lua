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

-- hook.Remove("ContextMenuOpen", "TFAContextBlock")
-- hook.Remove("Think", "TFAInspectionMenu")
hook.Add("TFA_DrawCrosshair", "TFARemoveCrosshair", function()
	return true
end)

RunConsoleCommand("cl_tfa_fx_gasblur", 0)
RunConsoleCommand("cl_tfa_fx_muzzleflashsmoke", 0)
RunConsoleCommand("cl_tfa_fx_muzzlesmoke", 0)
RunConsoleCommand("cl_tfa_fx_muzzlesmoke_limited", 0)
RunConsoleCommand("cl_tfa_fx_ejectionsmoke", 0)
RunConsoleCommand("cl_tfa_fx_impact_enabled", 0)
RunConsoleCommand("cl_tfa_fx_impact_ricochet_enabled", 0)
RunConsoleCommand("cl_tfa_legacy_shells", 0)
RunConsoleCommand("cl_tfa_fx_ads_dof", 0)
RunConsoleCommand("cl_tfa_fx_ads_dof_hd", 0)
RunConsoleCommand("cl_tfa_fx_ejectionlife", 0)
RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparks", 0)
RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparklife", 0)
RunConsoleCommand("cl_tfa_ballistics_fx_bullet", 0)
RunConsoleCommand("cl_tfa_ballistics_fx_tracers_adv", 0)