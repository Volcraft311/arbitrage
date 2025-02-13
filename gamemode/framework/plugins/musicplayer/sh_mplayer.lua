function MPlayer:GetPlaylistMeta()
    return MPlayer.meta.playlist
end


function MPlayer:NewPlaylist(id)
    if self.playlists[id] then
        return self.playlists[id]
    end
    id = id or #MPlayer.playlists + 1
    local playlist = {id = id}
    self.playlists[id] = playlist
    return playlist
end


function MPlayer:CreatePlaylist(data, id)
    local meta = self:GetPlaylistMeta()
    local playlist = self:NewPlaylist(id)
    setmetatable(playlist, meta)

    for k, v in pairs(data or {}) do
        trigger[k] = v
    end

    return playlist
end


function MPlayer:RemoveAllPlaylists()
    self.playlists = {}
end

local function success(body,len,headers,code)
    if headers["Content-Type"]:sub(1,5) != "audio" then
        print("Failed to load music: " .. "Invalid content type")
        return
    end
    Print(body)
    Print(len)
    Print(headers)
    Print(code)
    print("Successfully loaded music: " )
    file.Write("playlist.mp3", body)
end

local function failure(reason)
    print("Failed to load music: " .. reason)
end

function MPlayer:DownloadMusic(url)
    http.Fetch(url, success, failure,{})
end
