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

netstream.Hook("arb.Intro", function(data)
    local alpha = 0

    hook.Add("RenderScreenspaceEffects", "arb.Intro", function()
        alpha = Lerp(FrameTime() * 4, alpha, 257)

        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
    end)

    timer.Simple(data or 5, function()
        hook.Add("RenderScreenspaceEffects", "arb.Intro", function()
            alpha = Lerp(FrameTime(), alpha, -3)

            surface.SetDrawColor(0, 0, 0, alpha)
            surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
        end)

        timer.Simple(data + 5, function()
            hook.Remove("RenderScreenspaceEffects", "arb.Intro")
        end)
    end)
end)