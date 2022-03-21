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

Arbitrage.evidence = Arbitrage.library.Add("evidence")

local color = Color(255, 61, 96)
function Arbitrage.evidence.CreateText(data)
    if !data then return end

    local client = Arbitrage.Client()
    local pos = data.pos
    local name = data.name
    local desc = data.desc
    local class = data.class
    local dataEvidence = data.data

    local vec = client:GetPos()
    local ang = Angle(client:GetAngles()[1], client:GetAngles()[2], 0)

    local start1 = vec + ang:Right() * 15
    local start2 = vec - ang:Right() * 15
    local endpos1 = vec + ang:Forward() * 150 + ang:Right() * 15 + ang:Up() * 10
    local endpos2 = vec + ang:Forward() * 150 - ang:Right() * 15 + ang:Up() * 10

    local ignore_list = {}
    ignore_list[#ignore_list + 1] = client

    for k, v in pairs(ents.FindByClass("arb_evidence")) do ignore_list[#ignore_list + 1] = v end

    if class then
        for k, v in pairs(ents.FindByClass(class)) do
            ignore_list[#ignore_list + 1] = v
        end
    end

    if !Arbitrage.hud.VectorObstructed(EyePos(), pos, ignore_list) then
        local x = pos:ToScreen().x
        local y = pos:ToScreen().y

        local max_alpha = 150
        local curalpha = math.Clamp(math.sin(CurTime() * 2) * max_alpha, 0, max_alpha)

        local alpha = math.Clamp(client:GetPos():Distance(pos) / 3, 0, 150)

        local evData = 0
        if tonumber(dataEvidence) and Arbitrage.evidence.repository[dataEvidence] then
            evData = Arbitrage.evidence.repository[dataEvidence]
        elseif isentity(dataEvidence) and IsValid(dataEvidence) then
            evData = dataEvidence
        else
            Arbitrage.evidence.array[dataEvidence] = Arbitrage.evidence.array[dataEvidence] or {alpha = 0}
            evData = Arbitrage.evidence.array[dataEvidence]
        end

        local faction = Arbitrage.teams.Get(LocalPlayer():Team())

        evData.alpha = evData.alpha or 0

        local circle = Arbitrage.hud.GeneratePoly(x, y, math.Clamp((curalpha - alpha - evData.alpha) * (20 / 200) * (faction.evidenceVisibility or 1), 0, 200), math.Clamp(curalpha - alpha - evData.alpha, 0, 150))
        surface.SetDrawColor(ColorAlpha(color, math.Clamp(curalpha - alpha - evData.alpha, 0, 150)))
        draw.NoTexture()
        surface.DrawPoly(circle)

        if Arbitrage.hud.SeeVector({start1, start2, endpos2, endpos1}, pos, false) and client:GetPos():Distance(pos) < 150 then
            evData.alpha = Lerp(FrameTime(), evData.alpha, 255)
        else
            evData.alpha = Lerp(FrameTime() * 3, evData.alpha, 0)
        end

        local genericHeight = draw.GetFontHeight("arb.Font_FuturaPTDemi_8")
        local descHeight = draw.GetFontHeight("arb.Font_FuturaPTBook_6")

        draw.DrawText(name, "arb.Font_FuturaPTDemi_8", x, y - (genericHeight / 2), ColorAlpha(color, evData.alpha), TEXT_ALIGN_CENTER)

        local descriptionText = Arbitrage.WrapText(desc, 300, "arb.Font_FuturaPTBook_6")

        for i, _ in pairs(descriptionText) do
            local y2 = y + (descHeight * i) - (genericHeight / 2) + 5
            draw.DrawText(descriptionText[i], "arb.Font_FuturaPTBook_6", x, y2, ColorAlpha(Color(255, 255, 255), evData.alpha), TEXT_ALIGN_CENTER)
        end
    end
end

function Arbitrage.evidence.Draw()
    for k, v in pairs(Arbitrage.evidence.repository or {}) do
        local evidence = Arbitrage.evidence.Get(v.index)

        local data = k
        local pos = v.data
        local class = nil

        if LocalPlayer():GetPos():Distance(pos) >= 500 then continue end

        if isentity(pos) then
            pos = v.data:GetPos()
            class = v.data:GetClass()
            data = v.data
        end

        if isvector(pos) and evidence then
            Arbitrage.evidence.CreateText({
                pos = pos,
                name = evidence.name,
                desc = "",
                class = class,
                data = data
            })
        end
    end

    for k2, v2 in pairs(ents.FindInSphere(EyePos(), 500)) do
        local entity = Arbitrage.evidence.entities[v2:GetClass()]
        if !entity then continue end

        local up = entity.up or 0
        local right = entity.right or 0
        local forward = entity.forward or 0

        local newPos = v2:GetPos()
        newPos = newPos + (v2:GetUp() * up)
        newPos = newPos + (v2:GetRight() * right)
        newPos = newPos + (v2:GetForward() * forward)

        Arbitrage.evidence.CreateText({
            pos = newPos,
            name = entity.name,
            desc = entity.desc,
            class = v2:GetClass(),
            data = v2
        })
    end
end


--[[    ПЕРЕПИСАНО В ПЛАГИН `evidence`
netstream.Hook("arbAddEvidence", function(data)
    if !data then return end

    Arbitrage.evidence.repository = data
end)

netstream.Hook("arb.evidenceSend", function(data, replace)
    if !data then return end

    Arbitrage.evidence.data = replace and {} or (Arbitrage.evidence.data or {})

    for k, v in pairs(data) do
        Arbitrage.evidence.data[k] = v
    end
end)

netstream.Hook("arb.evidenceClearAll", function()
    Arbitrage.evidence.repository = {}
end)

netstream.Hook("arb.evidenceDataSend", function(data)
    Arbitrage.evidence.repository = data
end)
]]--