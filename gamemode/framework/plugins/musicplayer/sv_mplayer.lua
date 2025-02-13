Trigger.ServerPlaylist = Trigger.ServerPlaylist or {}


function MPlayer:CompareClientMusic(cmusic, playlist)
    local missing_music = {}
    for i, song in ipairs(playlist or Trigger.ServerPlaylist) do
        if !table.HasValue(cmusic, song) then
            table.insert(missing_music, song)
        end
    end
    return missing_music
end

function MPlayer:GetMissingMusic(cmusic)
    local missing_music = self:CompareClientMusic(cmusic, Trigger.ServerPlaylist)
end


netstream.Hook("MPlayer:CompareClientMusic", function(client, cmusic)
    local missing_music = MPlayer:CompareClientMusic(cmusic, playlist)
    netstream.Start(client, "MPlayer:MissingMusic", missing_music)
end)