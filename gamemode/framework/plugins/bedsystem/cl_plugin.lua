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

netstream.Hook("BedSystem:LayDownBed", function(entity, eyePos, eyeAng)
    if IsValid(BedSystem.panel) then
        BedSystem.panel:Remove()
    end

    local panel = vgui.Create("BedSystem:Menu")
    panel:SetBedData(entity, eyePos, eyeAng)

    BedSystem.panel = panel
end)

netstream.Hook("BedSystem:GetUpBed", function()
    if !IsValid(BedSystem.panel) then return end

    BedSystem.panel.bClose = true
    BedSystem.panel:SetBedData(nil)
    BedSystem.panel:AlphaTo(0, 5, 0, function()
        BedSystem.panel:Remove()
    end)
end)