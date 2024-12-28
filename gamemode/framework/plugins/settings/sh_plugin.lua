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

local PLUGIN = PLUGIN
SETTINGS = PLUGIN

-- Localize Global Calls
local pairs = pairs
local input_IsKeyDown = CLIENT and input.IsKeyDown
local input_IsMouseDown = CLIENT and input.IsMouseDown
local vgui_CursorVisible = CLIENT and vgui.CursorVisible
local hook_Run = hook.Run
local ipairs = ipairs

PLUGIN.name = "Settings"

PLUGIN.keys = {}
PLUGIN.options = PLUGIN.options or {}
PLUGIN.binds = PLUGIN.binds or {}
PLUGIN.stored = PLUGIN.stored or {options = {}, binds = {}}
PLUGIN.colddown = PLUGIN.colddown or {}
PLUGIN.pressed = PLUGIN.pressed or {}

-- OPTIONS
function PLUGIN.options.Add(id, type, default, data)
    data = data or {}

    local oldValue = PLUGIN.stored.options[id] and PLUGIN.stored.options[id].value
    local bReplace = false

    if oldValue != default then
        bReplace = true
    end

    PLUGIN.stored.options[id] = {
        id = id,
        type = type,
        default = default,
        value = bReplace and oldValue or default,
        name = data.name or "Неизвестно",
        title = data.title or "Не указано",
        description = data.description or "Не указано",
        image = data.image or nil,
        min = data.min or 0,
        max = data.max or 100,
        IsHidden = data.IsHidden or nil,
        OnChanged = data.OnChanged or nil
    }
end

function PLUGIN.options.Set(id, value)
    if !PLUGIN.stored.options[id] then return end

    PLUGIN.stored.options[id].value = value

    local func = PLUGIN.stored.options[id].OnChanged
    if func then
        func()
    end

    PLUGIN.Save()
end

function PLUGIN.options.Get(id)
    local data = PLUGIN.stored.options[id]

    return data and data.value
end

function PLUGIN.options.SetDefault(id)
    if !PLUGIN.stored.options[id] then return end

    PLUGIN.stored.options[id].value = PLUGIN.stored.options[id].default

    PLUGIN.Save()
end

function PLUGIN.options.GetDefault(id)
    if !PLUGIN.stored.options[id] then return end

    return PLUGIN.stored.options[id].default
end

function PLUGIN.options.IsDefault(id)
    return PLUGIN.stored.options[id] and (PLUGIN.stored.options[id].default == PLUGIN.stored.options[id].value)
end


-- BINDS
function PLUGIN.binds.Add(id, default, data)
    data = data or {}

    PLUGIN.stored.binds[id] = {
        id = id,
        default = default,
        value = default,
        name = data.name or "Неизвестно",
        title = data.title or "Не указано",
        description = data.description or "Не указано",
        image = data.image or nil,
        IsHidden = data.IsHidden or nil,
        OnChanged = data.OnChanged or nil
    }
end

function PLUGIN.binds.Set(id, value)
    if !PLUGIN.stored.binds[id] then return end

    PLUGIN.stored.binds[id].value = value

    local func = PLUGIN.stored.binds[id].OnChanged
    if func then
        func()
    end

    PLUGIN.Save()
end

function PLUGIN.binds.Get(id)
    local data = PLUGIN.stored.binds[id]

    return data and data.value
end

function PLUGIN.binds.SetDefault(id)
    if !PLUGIN.stored.binds[id] then return end

    PLUGIN.stored.binds[id].value = PLUGIN.stored.binds[id].default

    PLUGIN.Save()
end

function PLUGIN.binds.GetDefault(id)
    if !PLUGIN.stored.binds[id] then return end

    return PLUGIN.stored.binds[id].default
end

function PLUGIN.binds.IsDefault(id)
    return PLUGIN.stored.binds[id] and (PLUGIN.stored.binds[id].default == PLUGIN.stored.binds[id].value)
end


function PLUGIN.binds.AddKey(key, value)
    PLUGIN.keys[key] = value
end

function PLUGIN.binds.GetClampedKey()
    for key, value in pairs(PLUGIN.keys) do
        local info = SETTINGS.binds.MouseList[key] and input_IsMouseDown(key) or input_IsKeyDown(key)

        if info == true then
            return key, value
        end
    end
end

PLUGIN.binds.clampedID = {}
function PLUGIN.binds.IsClampedID(id)
    return PLUGIN.binds.clampedID[id] or false
end

local function IsVisibleGUI()
    return vgui_CursorVisible()
end

function PLUGIN.binds.IsPressedID(id, bCallHooks)
    local data = SETTINGS.binds.Get(id)

    if data then
        local info = SETTINGS.binds.MouseList[data] and input_IsMouseDown(data) or input_IsKeyDown(data)
        local client = LocalPlayer()
        local bVisibleGUI = IsVisibleGUI()

        if info then
            if bCallHooks then
                hook_Run("KeyClampID", client, id, bVisibleGUI)
            end

            PLUGIN.binds.clampedID[id] = true
        else
            PLUGIN.binds.clampedID[id] = nil
        end

        if PLUGIN.pressed[id] then
            if info == false then
                PLUGIN.pressed[id] = false

                if bCallHooks then
                    hook_Run("KeyReleaseID", client, id, bVisibleGUI)
                end
            end

            return false
        else
            if info == true then
                PLUGIN.pressed[id] = true

                if bCallHooks then
                    hook_Run("KeyPressID", client, id, bVisibleGUI)
                end

                return true
            end
        end
    end

    return false
end


-- OTHER
function PLUGIN.Save()
    local data = PLUGIN.GetData and PLUGIN:GetData({}, true, true) or {}
    data.options = data.options or {}
    data.binds = data.binds or {}

    for k, v in ipairs({"options", "binds"}) do
        for k2, v2 in pairs(PLUGIN.stored[v]) do
            data[v][k2] = v2.value
        end
    end

    PLUGIN:SetData(data, true, true)
end

function PLUGIN.GetStored()
    return PLUGIN.stored
end

function PLUGIN.Load()
    local data = PLUGIN.GetData and PLUGIN:GetData({}, true, true) or {}
    data.options = data.options or {}
    data.binds = data.binds or {}

    for k, v in ipairs({"options", "binds"}) do
        for id, value in pairs(data[v]) do
            if !PLUGIN.stored[v][id] then continue end

            PLUGIN.stored[v][id].value = value
        end
    end
end


Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_binds.lua")
Arbitrage.base.Include("cl_options.lua")
Arbitrage.base.Include("sv_plugin.lua")

Arbitrage.base.Include("cl_hooks.lua")
Arbitrage.base.Include("sh_hooks.lua")
Arbitrage.base.Include("sv_hooks.lua")