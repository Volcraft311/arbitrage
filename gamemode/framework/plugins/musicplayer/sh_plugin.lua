--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://asterion.games/chancery
        
        developer(s):
            Volcraft - https://steamcommunity.com/id/boobsgunner
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
MPlayer = PLUGIN

MPlayer.name = "Music Player"

MPlayer.meta = MPlayer.meta or {}
MPlayer.playlists = MPlayer.playlists or {}
MPlayer.music = MPlayer.music or {}

--[[
    Для сервера MPlayer.music = {
        file = "name.mp3" -- Название файла
        download_link = "https://audio.jukehost.co.uk/sI7Q85iVfHnQ9SksLELgKFEhTGzK8YNV" -- Прямая ссылка на скачивание
        duration = 120 -- Длительность трека(в секундах)
    }
    
    Для клиента MPlayer.music = {
        file = "name.mp3" -- Название файла
        duration = 120 -- Длительность трека
]]


Arbitrage.base.Include("meta/sh_meta_playlist.lua")
Arbitrage.base.Include("sh_mplayer.lua")
Arbitrage.base.Include("sv_mplayer.lua")
Arbitrage.base.Include("cl_mplayer.lua")