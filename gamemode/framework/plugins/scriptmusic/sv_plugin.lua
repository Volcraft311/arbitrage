--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

function PLUGIN:NormalizeData()
    local data = asterionlib.data:Get("newmusic", {}, true)
    data[1] = data[1] or -1
    data[2] = data[2] or {}

    return data
end

function PLUGIN:OpenMenu(client)
    if !IsValid(client) then return end

    local data = self:NormalizeData()

    -- не передаем что внутри плейлиста находится
    for k, v in pairs(data[2]) do
        v[2] = nil
    end

    netstream.Start(client, "ScriptMusic:OpenMenu", data)
end

function PLUGIN:OpenMenuSub(client, playlist)
    if !IsValid(client) then return end

    local data = self:NormalizeData()

    local category = data[2][playlist]
    if !category then return end

    netstream.Start(client, "ScriptMusic:OpenMenuSub", playlist, category)
end

function PLUGIN:GetTracks(event)
    local data = self:NormalizeData()

    local current = self:GetCurrentPlaylist()

    local playlist = data[2][current]
    if !playlist then return end

    local tracks = playlist[2][event]
    if !tracks then return end

    return tracks
end

function PLUGIN:GetTrack(event)
    local tracks = self:GetTracks(event)
    if !tracks then return end

    local rand, _ = table.Random(tracks)

    return rand
end

function PLUGIN:GetCurrentPlaylist()
    local data = self:NormalizeData()

    return data[1]
end

function PLUGIN:PlayGlobalEvent(event, volume, max_volume)
    local track = self:GetTrack(event)
    if !track then return end

    volume = volume or 0
    max_volume = max_volume or self:GetEvents()[event].volume

    netstream.Start(nil, "ScriptMusic:GlobalTrack", track, volume, max_volume)
end

function PLUGIN:PlayLocalEvent(client, event, volume, max_volume)
    local track = self:GetTrack(event)
    if !track then return end

    volume = volume or 0
    max_volume = max_volume or self:GetEvents()[event].volume

    netstream.Start(client, "ScriptMusic:LocalTrack", track, volume, max_volume)
end

function PLUGIN:PlayClientGlobalEvent(client, event, volume, max_volume)
    local track = self:GetTrack(event)
    if !track then return end

    volume = volume or 0
    max_volume = max_volume or self:GetEvents()[event].volume

    netstream.Start(client, "ScriptMusic:GlobalTrack", track, volume, max_volume)
end

function PLUGIN:ChangeTheme(theme, bStopOldTheme)
    SetNetVar("arb.theme", theme)

    if bStopOldTheme then
        netstream.Start(nil, "ScriptMusic:StopTheme")
    end

    -- PrintMessage(HUD_PRINTTALK, "Тема поменялась на: " .. tostring(theme))
end



netstream.Hook("ScriptMusic:SavePlayList", function(client, id_playlist, data_playlist)
    if !client:IsAdmin() then return end

    local data = PLUGIN:NormalizeData()
    data[2][id_playlist] = data_playlist

    asterionlib.data:Set("newmusic", data)
    PLUGIN:OpenMenu(client)
end)

netstream.Hook("ScriptMusic:ChangeCurrentPlayList", function(client, id_playlist)
    if !client:IsAdmin() then return end

    local data = PLUGIN:NormalizeData()
    data[1] = id_playlist

    asterionlib.data:Set("newmusic", data)
    PLUGIN:OpenMenu(client)
end)

netstream.Hook("ScriptMusic:RemovePlayList", function(client, id_playlist)
    if !client:IsAdmin() then return end

    local data = PLUGIN:NormalizeData()

    table.remove(data[2], id_playlist)

    asterionlib.data:Set("newmusic", data)
    PLUGIN:OpenMenu(client)
end)

netstream.Hook("ScriptMusic:StartEvent", function(client, event)
    if !client:IsAdmin() then return end

    PLUGIN:PlayGlobalEvent(event)
end)

netstream.Hook("ScriptMusic:OpenMenu", function(client)
    if !client:IsAdmin() then return end

    PLUGIN:OpenMenu(client)
end)

netstream.Hook("ScriptMusic:OpenMenuSub", function(client, id_playlist)
    if !client:IsAdmin() then return end

    PLUGIN:OpenMenuSub(client, id_playlist)
end)

netstream.Hook("ScriptMusic:PlayEvent", function(client, event, volume, max_volume)
    PLUGIN:PlayLocalEvent(client, event, volume, max_volume)
end)

netstream.Hook("ScriptMusic:PlayEventG", function(client, event, volume, max_volume)
    if !client:IsAdmin() then return end

    PLUGIN:PlayGlobalEvent(event, volume, max_volume)
end)

netstream.Hook("ScriptMusic:PlayEventGL", function(client, event, volume, max_volume)
    PLUGIN:PlayClientGlobalEvent(client, event, volume, max_volume)
end)

netstream.Hook("ScriptMusic:PlayMusic", function(client, track, volume, max_volume)
    volume = volume or 0
    max_volume = max_volume or 100

    netstream.Start(client, "ScriptMusic:LocalTrack", track, volume, max_volume)
end)

netstream.Hook("ScriptMusic:ChangeTheme", function(client, theme, bStopOldTheme)
    if !client:IsAdmin() then return end

    PLUGIN:ChangeTheme(theme, bStopOldTheme)
end)

netstream.Hook("ScriptMusic:ChangeMusic", function(client, track, volume, max_volume)
    if !client:IsAdmin() then return end

    volume = volume or 0
    max_volume = max_volume or 100

    netstream.Start(nil, "ScriptMusic:GlobalTrack", track, volume, max_volume)
end)