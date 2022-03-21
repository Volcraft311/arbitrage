local PLUGIN = PLUGIN

function PLUGIN:PostDrawOpaqueRenderables()
    local client = LocalPlayer()

    local data = self:GetToolData(client)
    if !data then return end

    local trace = LocalPlayer():GetEyeTrace()
    local angle = trace.HitNormal:Angle()

    render.DrawLine(trace.HitPos, trace.HitPos + 8 * angle:Forward(), Color(255, 0, 0), true)
    render.DrawLine(trace.HitPos, trace.HitPos + 8 * -angle:Right(), Color(0, 255, 0), true)
    render.DrawLine(trace.HitPos, trace.HitPos + 8 * angle:Up(), Color(0, 0, 255), true)
end

function PLUGIN:HUDPaint()
    local client = LocalPlayer()

    for k, v in ipairs(ents.FindInSphere(client:GetPos(), 800)) do
        local idx = v:GetEvidence()

        if idx then
            local data = self:GetEvidence(idx)
            if !data then continue end

            local pos = v:GetPos()
            local name, description, color, alphaA = data.name, data.description, data.color, data.alpha

            local x, y = pos:ToScreen().x, pos:ToScreen().y

            local max_alpha = 150
            local curalpha = math.Clamp(math.abs(math.sin(CurTime() * 3)) * max_alpha, 0, max_alpha)
            local alpha = math.Clamp(client:GetPos():Distance(pos) / 3, 0, 150)

            local faction = Arbitrage.teams.Get(client:Team())

            local ignore_list = {}
            ignore_list[#ignore_list + 1] = client
            ignore_list[#ignore_list + 1] = v

            for k2, v2 in pairs(ents.FindByClass("arb_evidence")) do ignore_list[#ignore_list + 1] = v2 end

            v.evData = v.evData or 0

            if !Arbitrage.hud.VectorObstructed(EyePos(), pos, ignore_list) then
                local circle = Arbitrage.hud.GeneratePoly(x, y, math.Clamp((curalpha - alpha - v.evData) * (20 / 200) * (faction.evidenceVisibility or 1), 0, 200), math.Clamp(curalpha - alpha - v.evData, 0, 150))

                surface.SetDrawColor(ColorAlpha(color, math.Clamp(curalpha - alpha - v.evData - (255 * 0.5 - alphaA), 0, 150)))
                draw.NoTexture()
                surface.DrawPoly(circle)
            end

            if Arbitrage:IsDeveloping() or client:IsNocliping() then
                if !client:IsAdmin() then return end
                if client.GetSitting and client:GetSitting() then return end
                if !SETTINGS.options.Get("show_admin_esp") then return end

                draw.SimpleText("ID: " .. idx .. "\n" .. name .. "\n" .. description, "Default", x, y, color, TEXT_ALIGN_CENTER)
            end
        end
    end
end

netstream.Hook("evidence.Register", function(idx, data)
    PLUGIN.list[idx] = data
end)

netstream.Hook("evidence.Clear", function()
    PLUGIN.list = {}
end)