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
Arbitrage.language.creationTabs = Arbitrage.language.creationTabs or {}
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
    local lang = self:Get(lang_id)

    return lang or self:Get(self.default)
end

function Arbitrage.language:Format(data, client)
    local text = data:gsub("#([%w_]+)", function(lang_id)
        lang_id = "#" .. lang_id

        local info = client and L(client, lang_id) or L(lang_id)
        return info or lang_id
    end)

    return text
end

function Arbitrage.language:FindWord(name)
    name = name:utf8lower()

    for _, lang in pairs(self.stored) do
        for idx, word in pairs(lang.data) do
            if isstring(word) then
                word = word:utf8lower()
            elseif isfunction(word) then
                word = word():utf8lower()
            elseif istable(word) then
                word = table.concat(word, " "):utf8lower()
            end

            if word == name then
                return idx
            end
        end
    end
end

function Arbitrage.language:AddCreationTab(name)
    self.creationTabs[#self.creationTabs + 1] = name
end

function Arbitrage.language:ReloadCreationTab(activeLang)
    local data = {}

    for _, name in ipairs(self.creationTabs) do
        local info = {name}

        for lang_id, lang in pairs(self.stored) do
            local word = lang.data[name]

            if word then
                info[lang_id] = word
            end
        end

        data[name] = info
    end

    local tabs = spawnmenu.GetCreationTabs()
    for name, info in pairs(data) do
        for lang_id, word in pairs(info) do
            local tab = tabs[word]

            if tab then
                local newName = data[name][activeLang] or name
                local copy = table.Copy(tab)

                tabs[word] = nil
                tabs[newName] = copy
            end
        end
    end
end

function Arbitrage.language:OnUpdate(old, new)
    -- Авто перенос больших букв на маленькие
    RunConsoleCommand("arb_lang", new:lower())

    hook.Run("OnLanguageUpdate", old, new)

    self:ReloadCreationTab(new)
    RunConsoleCommand("spawnmenu_reload")

    Arbitrage.util.WriteMessage(Color(255, 132, 0), "{" .. Arbitrage.util.GetSide():upper() .. "} ", Color(255, 174, 0), "A change in language was noticed!")
end

local function format(data, ...)
    local args = {...}

    local text = data:gsub("%%s", function()
        if #args > 0 then
            return table.remove(args, 1)
        else
            return "%s"
        end
    end)

    return text
end

if SERVER then
    function L(client, id, ...)
        local convar = isstring(client) and client or (client:GetInfo("arb_lang") or Arbitrage.language.default)
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


    local oldConVar = Arbitrage.language.convar:GetString():lower()
    timer.Create("Arbitrage.language:OnUpdate", 1, 0, function()
        local newConVar = Arbitrage.language.convar:GetString():lower()
        if newConVar != oldConVar then
            if !Arbitrage.language.stored[newConVar] then
                RunConsoleCommand("arb_lang", Arbitrage.language.default)

                return Arbitrage.util.WriteMessage(Color(255, 132, 0), "{" .. Arbitrage.util.GetSide():upper() .. "} ", Color(255, 0, 0), "[ERROR] ", Color(235, 93, 93), "The specified language was not found. Resetting to default state!")
            end

            Arbitrage.language:OnUpdate(oldConVar, newConVar)
        end

        oldConVar = newConVar
    end)
end