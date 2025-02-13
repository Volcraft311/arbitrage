
local PLAYLIST = {}
PLAYLIST.__index = PLAYLIST
PLAYLIST.id = 0
PLAYLIST.name = "Playlist"
PLAYLIST.image = ""
PLAYLIST.songs = {}


function PLAYLIST:__tostring()
    return "Playlist nmbr [" .. self.id .. "]"
end

function PLAYLIST:__eq(other)
    return self:GetID() == other:GetID()
end

function PLAYLIST:GetID()
    return self.id
end

function PLAYLIST:SetName(name)
    self.name = name
end

function PLAYLIST:GetName()
    return self.name
end

function PLAYLIST:SetImage(image)
    self.image = image
end

function PLAYLIST:GetImage()
    return self.image
end



MPlayer.meta.playlist = PLAYLIST