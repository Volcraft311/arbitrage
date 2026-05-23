
--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLAYER = FindMetaTable("Player")

function PLAYER:Recognize(target)
    local data = self:GetNetVar("recognizeData", {})

    local steamid = target
    if IsValid(target) and target:IsPlayer() then
        steamid = target:SteamID()
    end

    data[steamid] = true

    self:SetNetVar("recognizeData", data)
end

local sphereOptions = {
    talk = ARBITRAGE_SAY_LENGTH,
    whispers = ARBITRAGE_SAY_LENGTH * 0.3,
    yell = ARBITRAGE_SAY_LENGTH * 2
}
function PLAYER:RecognizeSphere(option)
    local radius = sphereOptions[option]
    if !radius then return end

    local steamid = self:SteamID()

    local players = player.FindInSphere(self:GetPos(), radius)
    for _, target in ipairs(players) do
        if target == self then continue end

        local data = target:GetNetVar("recognizeData", {})

        data[steamid] = true

        target:SetNetVar("recognizeData", data)
    end
end

function PLAYER:UnRecognize(target)
    local data = self:GetNetVar("recognizeData", {})

    local steamid = target
    if IsValid(target) and target:IsPlayer() then
        steamid = target:SteamID()
    end

    data[steamid] = nil

    self:SetNetVar("recognizeData", data)
end

function PLAYER:SetRecognizeName(name)
    name = name:Trim()

    if name == "" then
        name = nil
    end

    self:SetNetVar("recognizeName", name)
end