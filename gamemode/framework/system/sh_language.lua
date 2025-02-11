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


Arbitrage.language = Arbitrage.library.Add("language")
Arbitrage.language.stored = Arbitrage.language.stored or {}
Arbitrage.language.default = "ru"
Arbitrage.language.convar = CreateClientConVar("arb_lang", Arbitrage.language.default, true, true)

function Arbitrage.language:Add(lang_id, information, data)
    self.stored[lang_id] = {
        information = information,
        data = data
    }
end

function Arbitrage.language:Get(lang_id)
    return self.stored[lang_id]
end

function Arbitrage.language:GetActive()
    local lang_id = self.convar:GetString()
    local lang = Arbitrage.language:Get(lang_id)
    if lang then
        return lang
    end

    return Arbitrage.language:Get(self.default)
end

function Arbitrage.language:Format(data, client)
    return data:gsub("#([%w_]+)", function(lang_id)
        lang_id = "#" .. lang_id

        local info = client and L(client, lang_id) or L(lang_id)
        return info or lang_id
    end)
end

function Arbitrage.language:OnUpdate(old, new)
    hook.Run("OnLanguageUpdate", old, new)

    Arbitrage.util.WriteMessage(Color(255, 132, 0), "{" .. Arbitrage.util.GetSide():upper() .. "} ", Color(255, 174, 0), "A change in language was noticed!")
end

local function format(data, ...)
    local args = {...}

    return data:gsub("%%s", function()
        if #args > 0 then
            return table.remove(args, 1)
        else
            return "%s"
        end
    end)
end

if SERVER then
    function L(client, id, ...)
        local convar = client:GetInfo("arb_lang") or Arbitrage.language.default
        local lang = Arbitrage.language:Get(convar) or Arbitrage.language:Get(Arbitrage.language.default)
        local info = lang.data[id]

        if isstring(info) then
            return format(info, ...)
        elseif isfunction(info) then
            info = info(...)

            return format(info, ...)
        elseif istable(info) then
            info = table.concat(info, " ")

            return format(info, ...)
        end

        return format(tostring(id), ...)
    end

    function F(client, data)
        return Arbitrage.language:Format(data, client)
    end
else
    function L(id, ...)
        local lang = Arbitrage.language:GetActive()
        local info = lang.data[id]

        if isstring(info) then
            return format(info, ...)
        elseif isfunction(info) then
            info = info(...)

            return format(info, ...)
        elseif istable(info) then
            info = table.concat(info, " ")

            return format(info, ...)
        end

        return format(tostring(id), ...)
    end

    function F(data)
        return Arbitrage.language:Format(data)
    end


    local oldConVar = Arbitrage.language.convar:GetString()
    timer.Create("Arbitrage.language:OnUpdate", 1, 0, function()
        local newConVar = Arbitrage.language.convar:GetString()
        if newConVar != oldConVar then
            Arbitrage.language:OnUpdate(oldConVar, newConVar)
        end

        oldConVar = newConVar
    end)
end