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


Arbitrage.theme = Arbitrage.library.Add("theme")
Arbitrage.theme.cached = Arbitrage.theme.cached or {}

file.CreateDir("academy_theme_configs")

function Arbitrage.theme:ProcessMaterial(mat)
    if !mat then return end

    if isstring(mat) then
        mat = mat:Trim()

        if mat == "" then
            return
        end
    end

    if string.isURL(mat) then
        if self.cached[mat] == nil then
            self.cached[mat] = false

            asterionlib.downloader:Image(mat, function(fetchMaterial)
                self.cached[mat] = fetchMaterial
            end)
        end

        if self.cached[mat] then
            return self.cached[mat]
        end
    else
        return Material(mat)
    end
end

function Arbitrage.theme:Export(name, theme_id)
    local theme = self:Get(theme_id)
    if !theme then return end

    local data = {colors = {}, images = {}}

    for key, value in pairs(theme.colors) do
        data.colors[key] = {
            r = value.r or 255,
            g = value.g or 255,
            b = value.b or 255,
            a = theme.default.colors[key].a
        }
    end

    for key, value in pairs(theme.images) do
        data.images[key] = tostring(value) or ""
    end

    data = util.TableToJSON(data)
    file.Write("academy_theme_configs/" .. name .. ".txt", data)
end

function Arbitrage.theme:Import(name, theme_id)
    local theme = self:Get(theme_id)
    if !theme then return end

    local onEdit = theme.onEdit
    if !onEdit then return end

    local data = util.JSONToTable(file.Read("academy_theme_configs/" .. name .. ".txt", "DATA") or "") or {}
    data.colors = data.colors or {}
    data.images = data.images or {}

    for key, value in pairs(data.colors) do
        onEdit(theme, key, value)
    end

    for key, value in pairs(data.images) do
        onEdit(theme, key, value)
    end
end

function Arbitrage.theme:GetConfigs()
    local data = {}

    local files = file.Find("academy_theme_configs/*", "DATA")
    for _, name in ipairs(files or {}) do
        data[#data + 1] = name:gsub(".txt", "")
    end

    return data
end


netstream.Hook("Theme:EditParamTheme", function(theme_id, key, value)
    local theme = Arbitrage.theme:Get(theme_id)
    if !theme then return end

    if isstring(value) then
        theme.images[key] = value
    elseif istable(value) then
        local color = Color(value.r or 255, value.g or 255, value.b or 255, theme.default.colors[key].a)

        theme.colors[key] = color
    end
end)

netstream.Hook("Theme:LoadParamsTheme", function(theme_id, data)
    Arbitrage.theme:LoadThemeParameters(theme_id, data)
end)


-- Инициализируем кастомные параметры пользовательских тем
timer.Simple(1, function()
    for uniqueID, theme in pairs(Arbitrage.theme.stored) do
        local onInitialized = theme.onInitialized

        if onInitialized then
            onInitialized(theme)
        end
    end
end)