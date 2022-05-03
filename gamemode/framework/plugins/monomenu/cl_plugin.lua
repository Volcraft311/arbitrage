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

function PLUGIN:VGUIMousePressed(panel, mousecode)
    if IsValid(panel) then
        if IsValid(Arbitrage.gui.monomenu) and panel == Arbitrage.gui.monomenu.monoList then return end
        if panel:GetName() == "DMenu" then return end

        return self:VGUIMousePressed(panel:GetParent(), mousecode)
    end

    if IsValid(Arbitrage.gui.monomenu) and IsValid(Arbitrage.gui.monomenu.monoList) then
        Arbitrage.gui.monomenu.monoList:AlphaTo(0, 0.1, 0, function()
            Arbitrage.gui.monomenu.monoList:Remove()
        end)
    end
end

function PLUGIN:ArbitrageContextMenu(data)
    if LocalPlayer():IsAdmin() then
        data:AddAction("Открыть Моно-Меню", function(client)
            netstream.Start("arb.OpenMonoMenu")
        end, Arbitrage.GetMaterial("danganronpa/hud/action/mono.png"))
    end
end

netstream.Hook("arb.OpenMonoMenu", function(data)
    local panel = IsValid(Arbitrage.gui.monomenu) and Arbitrage.gui.monomenu or vgui.Create("arb.MonoMenu")
    panel:SetData(data)
end)

netstream.Hook("arb.OpenMonoWhiteList", function(data)
    data = (istable(data) and table.Count(data) > 0) and data or { -- PLUGIN:GetData() - always returns some `table`, but not a `nil` value
        players = {},
        settings = false,
    }

    local panel = IsValid(Arbitrage.gui.whitelist) and Arbitrage.gui.whitelist or vgui.Create("arb.MonoMenuWhiteList")
    panel:SetData(data)
end)

netstream.Hook("arb.OpenSplashScreen", function(data)
    local panel = vgui.Create("arb.SplashScreen")
    panel:SetData(data)
end)

netstream.Hook("arb.OpenVotingScreen", function(data, votingList)
    local panel = vgui.Create("arb.VoteScreen")
    panel:SetData(data, votingList)
end)

netstream.Hook("arb.EndVoting", function(data)
    if !IsValid(Arbitrage.gui.votescreen) then return end

    Arbitrage.gui.votescreen:RemovingPanels()

    timer.Simple(1, function()
        Arbitrage.gui.votescreen:ShowWinning(data)
    end)
end)