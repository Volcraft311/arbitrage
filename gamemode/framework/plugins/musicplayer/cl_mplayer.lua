MPlayer.files = {
    base = "academy_musicplayer",
    music = "academy_musicplayer/music",
}
MPlayer.playlists = MPlayer.playlists or {}

file.CreateDir(MPlayer.files.base)
file.CreateDir(MPlayer.files.music)


function MPlayer:UpdateMusic()
    self.music = file.Find(MPlayer.files.music .. "/*.mp3", "DATA")
end

