function RagdollSystem:NetworkEntityCreated(entity)
    local class = entity:GetClass()
    if class != "prop_ragdoll" then return end

    timer.Simple(0.5, function() -- netvar sync time
        if !IsValid(entity) then return end

        local ownerSteamID = entity:GetNetVar("sIsRagdoll")
        if !ownerSteamID then return end

        local client = player.GetBySteamID(ownerSteamID)
        if !IsValid(client) then return end

        entity.TooltipMini = function(_, tooltip)
            local fallOverEntity = client:GetRagdoll()
            if entity != fallOverEntity then
                entity.TooltipMini = nil
                if IsValid(Arbitrage.tooltip) then
                    Arbitrage.tooltip:Remove()
                end

                return
            end

            tooltip.player = client
            tooltip:SetTitle(client:Name())
                if !client:GetNetVar("hideStatus") then
                    local color = Color(61, 210, 101)
                    local stText = "На вид в порядке"
                    local health = client:Health()

                    if health <= 40 then
                        color = Color(218, 52, 52)
                        stText = "Выглядит неважно"
                    elseif health <= 80 then
                        color = Color(218, 162, 52)
                        stText = "Слегка потрепанный"
                    end

                    tooltip:AddSubMenu(stText, function(this)
                        this.title:SetTextColor(color)
                    end)
                end
            tooltip:SetDescription(client:GetNetVar("description"))
        end
    end)
end

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