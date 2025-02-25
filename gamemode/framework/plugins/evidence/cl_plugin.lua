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

-- Localize Global Calls
local RealTime = RealTime
local Arbitrage = Arbitrage
local EyeAngles = EyeAngles
local LerpVector = LerpVector
local Color = Color
local draw_SimpleText = draw.SimpleText
local draw_DrawText = draw.DrawText
local select = select
local math_max = math.max
local timer_Simple = timer.Simple
local ipairs = ipairs
local math_Clamp = math.Clamp
local math_abs = math.abs
local math_sin = math.sin
local EyePos = EyePos
local ColorAlpha = ColorAlpha
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local netstream = netstream
local IsValid = IsValid
local Material = Material
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local Lerp = Lerp
local FrameTime = FrameTime
local surface_SetDrawColor = surface.SetDrawColor
local chat_AddText = chat.AddText
local unpack = unpack

asterionlib.entscollector:AddTrack("evidence", {
    delay_apply = 3,
    onCanTrack = function(entity)
        local idx = entity:GetEvidence()
        if !idx then return false end

        local data = Evidence:GetEvidence(idx)
        if !data then return false end

        return true
    end,
    onCanApply = function(entity)
        return entity:GetPos():DistToSqr(EyePos()) <= 1000000
    end
})

local function get_ignore_list()
    local array = {LocalPlayer()}

    local data = asterionlib.entscollector:GetAll("evidence")
    for k, entity in ipairs(data) do
        array[#array + 1] = entity
    end

    return array
end

local function draw_admin_evidences(client)
    local data = asterionlib.entscollector:GetAll("evidence")
    if #data <= 0 then return end

    if !client:IsAdmin() then return end
    if !client:IsNocliping() then return end
    if client.GetSitting and client:GetSitting() then return end
    if !SETTINGS.options.Get("show_admin_esp") then return end

    for k, entity in ipairs(data) do
        if !IsValid(entity) then continue end

        local idx = entity:GetEvidence()
        if !idx then continue end

        local evidence = Evidence:GetEvidence(idx)
        if !evidence then continue end

        local pos = entity:GetPos()

        local data2D = pos:ToScreen()
        if !data2D.visible then continue end

        local x, y = data2D.x, data2D.y
        local name, description, color = evidence.name, evidence.description, evidence.color

        draw_DrawText("ID: " .. idx .. "\n" .. name .. "\n" .. description, "Default", x, y, color, TEXT_ALIGN_CENTER)
    end
end

local function get_allow(array, factionID)
    local bAllow = false
    local bUnique = false
    if array then
        local allow = array[factionID]

        if allow then
            bAllow = true
            bUnique = true
        end
    else
        bAllow = true
    end

    return bAllow, bUnique
end

local max_alpha = 150
local function get_curalpha()
    return math_Clamp(math_abs(math_sin(RealTime() * 3)) * max_alpha, 0, max_alpha)
end

local function get_alpha(distance)
    return math_Clamp(distance / 3, 0, max_alpha)
end

local function get_b(curalpha, alpha, evidenceVisibility)
    return math_Clamp((curalpha - alpha) * 0.2 * evidenceVisibility, 0, 255)
end

local function get_a(alphaA, distance, evidenceVisibility, sleep)
    local a = alphaA - (distance - (evidenceVisibility * 255)) * 0.7
    a = a - (255 - sleep * 2.55)
    a = math_Clamp(a, 0, 255)

    return a
end

local function get_info(client, pos, alphaA, evidenceVisibility, sleep)
    local clientPos = client:GetPos()
    local distance = clientPos:Distance(pos)

    local curalpha = get_curalpha()
    local alpha = get_alpha(distance)

    local b = get_b(curalpha, alpha, evidenceVisibility)
    local a = get_a(alphaA, distance, evidenceVisibility, sleep)

    return curalpha, alpha, b, a
end


local function draw_evidence_icon(x, y, b, a, evidence)
    local size = b * 0.9
    if size <= 0.05 then return end

    local d = Evidence.icons
    local mat = Material(d[evidence.image] and d[evidence.image] or d[1])

    surface_SetDrawColor(255, 255, 255, a)
    surface_SetMaterial(mat)
    surface_DrawTexturedRect(x - size, y - size, size * 2, size * 2)
end

local starIcon = Material("icon16/star.png")
local function draw_evidence_star(x, y, b, a, evidence)
    local size = b * 0.7 - (evidence.animSize or 0)
    if size <= 0.05 then return end

    surface_SetDrawColor(255, 255, 255, a)
    surface_SetMaterial(starIcon)
    surface_DrawTexturedRect(x - size, y - size, size * 2, size * 2)
end

local function draw_evidence_circle(x, y, b, a, evidence, curalpha, alpha, color)
    local size = b * 0.5 - (evidence.animSize or 0)
    if size <= 0.05 then return end

    local circle = Arbitrage.hud.GeneratePoly(x, y, size, math_Clamp(curalpha - alpha, 0, max_alpha))

    surface_SetDrawColor(color.r, color.g, color.b, a)
    draw_NoTexture()
    surface_DrawPoly(circle)
end

local function draw_player_evidences(client)
    local offPickEvidence = Arbitrage.OffPickingEvidence()
    if offPickEvidence then return end

    local data = asterionlib.entscollector:GetApply("evidence")
    if #data <= 0 then return end

    local ft = FrameTime()
    local eyePos = EyePos()
    local eyeAng = EyeAngles()
    local ignore_list = get_ignore_list()

    local factionID = client:Team()
    local faction = Character.team:GetByID(factionID)
    local evidenceVisibility = faction and faction:GetEvidenceVisibility() or 1
    local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100

    for k, entity in ipairs(data) do
        if !IsValid(entity) then continue end

        local idx = entity:GetEvidence()
        if !idx then continue end

        local evidence = Evidence:GetEvidence(idx)
        if !evidence then continue end

        local bAllow, bUnique = get_allow(evidence.factiondata, factionID)
        if !bAllow then continue end

        local name, description, color, alphaA = evidence.name, evidence.description, evidence.color, evidence.alpha

        local pos = entity:GetPos()
        local data2D = pos:ToScreen()
        if data2D.visible and !util.VectorObstructed(eyePos, pos, ignore_list) then
            local x, y = data2D.x, data2D.y

            local curalpha, alpha, b, a = get_info(client, pos, alphaA, evidenceVisibility, sleep)
            if evidence.animID and evidence.animID >= 5 then
                draw_evidence_icon(x, y, b, a, evidence)
            else
                if !evidence.animFinal then
                    if bUnique then
                        draw_evidence_star(x, y, b, a, evidence)
                    else
                        draw_evidence_circle(x, y, b, a, evidence, curalpha, alpha, color)
                    end
                end
            end
        end

        -- best animations!!!
        if !(evidence.animID and evidence.animID < 5) then continue end

        if evidence.animID > 0 and evidence.animID < 3 then
            evidence.animSize = Lerp(ft, evidence.animSize, 50)
        end

        if evidence.animID > 1 and evidence.animID < 4 then
            evidence.animPos = LerpVector(ft, evidence.animPos, eyePos + eyeAng:Forward() * 200 - eyeAng:Up() * 25)
        end

        local position = evidence.animPos or entity:GetPos()
        local position2D = position:ToScreen()

        if evidence.animID > 2 then
            evidence.animTextAlpha = Lerp(ft, evidence.animTextAlpha, evidence.animID > 3 and -255 or 255)

            if evidence.animTextAlpha > 0.1 then
                local colorText = Color(255, 255, 255, evidence.animTextAlpha)

                local _, height = draw_SimpleText(name, "arb.Font_FuturaPTBook_9", position2D.x, position2D.y + evidence.animSize, colorText, TEXT_ALIGN_CENTER)
                draw_DrawText(description, "arb.Font_FuturaPTBook_6", position2D.x, position2D.y + height + evidence.animSize, colorText, TEXT_ALIGN_CENTER)
            end

            if evidence.animID > 3 and evidence.animID < 5 then
                evidence.animPos = LerpVector(ft * 4, evidence.animPos, pos)
                evidence.animSize = Lerp(ft, evidence.animSize, -2)

                local b = select(3, get_info(client, pos, alphaA, evidenceVisibility, sleep))
                evidence.animSize = math_max(evidence.animSize, b * 0.7)
            end
        end

        if evidence.animSize then
            local d = Evidence.icons
            local mat = Material(d[evidence.image] and d[evidence.image] or d[1])

            surface_SetDrawColor(255, 255, 255, 255)
            surface_SetMaterial(mat)
            surface_DrawTexturedRect(position2D.x - evidence.animSize, position2D.y - evidence.animSize, evidence.animSize * 2, evidence.animSize * 2)
        end
    end
end

function Evidence:HUDPaint()
    local client = LocalPlayer()

    draw_admin_evidences(client)
    draw_player_evidences(client)
end

netstream.Hook("Evidence:RegisterAllEvidences", function(info)
    for idx, data in pairs(info) do
        Evidence.list[idx] = data
    end
end)

netstream.Hook("Evidence:Register", function(idx, data)
    Evidence.list[idx] = data
end)

netstream.Hook("Evidence:Clear", function()
    Evidence.list = {}
end)

netstream.Hook("Evidence:Draw", function(entity)
    local idx = entity:GetEvidence()
    if !idx then return end

    local evidence = Evidence:GetEvidence(idx)
    if !evidence then return end

    local d = Evidence.icons
    local mat = Material(d[evidence.image] and d[evidence.image] or d[1])

    chat_AddText(unpack({mat, evidence.name, ". ", evidence.description}))

    evidence.animID = 1
    evidence.animPos = entity:GetPos()
    evidence.animAlpha = 0
    evidence.animSize = 0
    evidence.animTextAlpha = 0

    timer_Simple(1, function()
        evidence.animID = 2
        evidence.animFinal = true
    end)

    timer_Simple(2.5, function()
        evidence.animID = 3
    end)

    timer_Simple(6, function()
        evidence.animID = 4
    end)

    timer_Simple(9, function()
        evidence.animID = 5

        evidence.animTextAlpha = nil
        evidence.animPos = nil
        evidence.animAlpha = nil
        evidence.animSize = nil
    end)
end)