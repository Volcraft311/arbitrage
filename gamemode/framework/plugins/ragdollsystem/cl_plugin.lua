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
                local stText = "#tooltip_status_healty"
                local health = client:Health()

                if health <= 40 then
                    color = Color(218, 52, 52)
                    stText = "#tooltip_status_badshape"
                elseif health <= 80 then
                    color = Color(218, 162, 52)
                    stText = "#tooltip_status_injured"
                end

                tooltip:AddSubMenu(stText, function(this)
                    this.title:SetTextColor(color)
                end)

                for _, v in ipairs(client:GetTemporaryStatusEffects()) do
                    local uniqueID = v.uniqueID
                    local status = Medical.t_status_effects[uniqueID]
                    if !status then continue end

                    local status_tooltip = status.tooltip
                    if !status_tooltip then continue end

                    tooltip:AddSubMenu(L(status_tooltip.format), function(this)
                        this.title:SetTextColor(status_tooltip.color)
                    end)
                end
            end

            local description = client:GetNetVar("description")
            if description then
                tooltip:SetDescription(description)
            end

            local forced_description = client:GetNetVar("forced_description")
            if forced_description then
                local wrapData = asterionlib.WrapText(forced_description, tooltip:GetWide(), "arb.Font_FuturaPTBook_7")
                for k, v in ipairs(wrapData or {}) do
                    tooltip:AddSubMenu(v, function(this)
                        this.title:SetTextColor(Color(245, 206, 206))
                    end)
                end
            end
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