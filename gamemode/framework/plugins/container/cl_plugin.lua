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


local draw_GetFontHeight = draw.GetFontHeight
local draw_SimpleText = draw.SimpleText
local ColorAlpha = ColorAlpha
local Color = Color
local util_TraceLine = util.TraceLine
local timer_Create = timer.Create
local IsValid = IsValid
local ipairs = ipairs
local ents_FindInSphere = ents.FindInSphere
local EyePos = EyePos
local Arbitrage = Arbitrage
local Lerp = Lerp
local FrameTime = FrameTime

local font = "arb.Font_FuturaPTBook_8"
local genericHeight = draw_GetFontHeight(font)
local function createTextContainer(entity, name)
    local position = entity:LocalToWorld(entity:OBBCenter())

    local data2D = position:ToScreen()
    if !data2D.visible then return end

    local x, y = data2D.x, data2D.y
    local alpha = entity.textalpha

    draw_SimpleText(name, font, x, y - (genericHeight / 2) - 10, ColorAlpha(Color(255, 61, 96), alpha), TEXT_ALIGN_CENTER)
end

local function getTrace(client)
    local traceline = {}
    traceline.start = client:GetShootPos()
    traceline.endpos = traceline.start + client:GetAimVector() * 120
    traceline.filter = client

    return util_TraceLine(traceline)
end

local entities = {}
local ent = nil
timer_Create("Container:Update", 1, 0, function()
    entities = {}
    ent = nil

    local client = LocalPlayer()
    if !IsValid(client) then return end
    if client:IsSpectate() then return end

    local tr = getTrace(client)

    for k, v in ipairs(ents_FindInSphere(EyePos(), 500)) do
        if v:GetClass() != "arb_container" then continue end

        local name = v:GetContainerName()
        local bNotVisible = Arbitrage.hud.VectorObstructed(EyePos(), v:GetPos(), {LocalPlayer(), v})
        if bNotVisible then continue end

        v.textalpha = v.textalpha or 0

        entities[#entities + 1] = {v, name}

        if tr.Entity == v then
            ent = v
        end
    end
end)

function Container:HUDPaint()
    for k, v in ipairs(entities) do
        local entity = v[1]
        local name = v[2]

        if !IsValid(entity) then continue end
        if ent != entity and entity.textalpha <= 0.1 then continue end

        entity.textalpha = Lerp(FrameTime() * 5, entity.textalpha, ent == entity and 256 or 0)

        createTextContainer(entity, name)
    end
end