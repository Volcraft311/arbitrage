--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
EPaint = PLUGIN

EPaint.name = "Entity Paint"

EPaint.Width = 1443
EPaint.Height = 540
EPaint.Distance = 800
EPaint.allowModels = {
    ["models/asterion/academy/props/classroom/ast_classroom_board.mdl"] = true
}

function EPaint:AllowEntity(entity)
    return self.allowModels[entity:GetModel()]
end

function EPaint:CompressData(data)
    if not data or table.IsEmpty(data) then return "" end

    local buffer = {}
    for id, entry in pairs(data) do
        local color = entry[2] or {r = 255, g = 255, b = 255}
        local hexColor = string.format("%02x%02x%02x", color.r, color.g, color.b)

        local entryStr = string.format("%d~%d~%s~%d~%d~%d", id,
            entry[1] or 1, -- type
            hexColor, -- color
            entry[3] or 0, -- x
            entry[4] or 0, -- y
            entry[5] or 5 -- size
        )

        if entry[6] and entry[7] then
            entryStr = entryStr .. string.format("~%d~%d",
                entry[6], -- beforeX
                entry[7] -- beforeY
            )
        end

        buffer[#buffer + 1] = entryStr
    end

    local compressed = table.concat(buffer, ",")
    return util.Base64Encode(util.Compress(compressed))
end

function EPaint:DecompressData(compressedStr)
    if not compressedStr or compressedStr == "" then return {} end

    local raw = util.Decompress(util.Base64Decode(compressedStr))
    if not raw then return {} end

    local data = {}
    for part in raw:gmatch("([^,]+)") do
        local fields = {}
        for val in part:gmatch("([^~]+)") do
            fields[#fields + 1] = val
        end

        if #fields >= 6 then
            local id = tonumber(fields[1])
            local hexColor = fields[3]

            data[id] = {
                tonumber(fields[2]), -- type
                {
                    r = tonumber(hexColor:sub(1,2), 16),
                    g = tonumber(hexColor:sub(3,4), 16),
                    b = tonumber(hexColor:sub(5,6), 16)
                },
                tonumber(fields[4]), -- x
                tonumber(fields[5]), -- y
                tonumber(fields[6]) -- size
            }

            if #fields >= 8 then
                data[id][6] = tonumber(fields[7]) -- beforeX
                data[id][7] = tonumber(fields[8]) -- beforeY
            end
        end
    end

    return data
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_epaintlist.lua")
Arbitrage.base.Include("sv_plugin.lua")