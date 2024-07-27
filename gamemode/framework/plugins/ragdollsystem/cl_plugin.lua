netstream.Hook("RagdollSystem:FallOver", function(idx, time)
    if IsValid(RagdollSystem.panel) then
        RagdollSystem.panel:Remove()
    end

    local panel = vgui.Create("RagdollSystem:FallOverMenu")
    panel:SetEntityIdx(tonumber(idx))
    panel:SetStandUpTime(tonumber(time))

    RagdollSystem.panel = panel
end)

netstream.Hook("RagdollSystem:ClosePanel", function()
    if !IsValid(RagdollSystem.panel) then return end

    RagdollSystem.panel.bClose = true
end)