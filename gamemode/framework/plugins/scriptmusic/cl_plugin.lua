--[[
        © Asterion Project 2022.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

RunConsoleCommand("stopsound") -- refresh

function PLUGIN:InitializeTrack(path, callback)
    local url = path:match("http[s]?://.+")
    local play = url and sound.PlayURL or sound.PlayFile
    path = url and url or "sound/" .. path

    play(path, "noplay", function(channel, error, message)
        if !IsValid(channel) then return end

        if callback then
            callback(channel)
        end
    end)
end

function PLUGIN:GetGlobalSound()
    return self.sound
end

function PLUGIN:IsValidGlobalSound()
    local s = self:GetGlobalSound()

    if s and type(s) == "IGModAudioChannel" and s:IsValid() then
        return true
    end

    return false
end

function PLUGIN:VolumeDown(channel, callback)
    local gSound = channel
    local uniqueID = util.CRC(channel:GetFileName())

    timer.Create("ScriptMusic:Volume_" .. uniqueID, FrameTime(), 0, function()
        if !self:IsValidGlobalSound() then
            timer.Remove("ScriptMusic:Volume_" .. uniqueID)

            if callback then
                callback()
            end

            return
        end

        local volume = gSound:GetVolume()
        volume = math.Approach(volume, 0, FrameTime() * 0.3)

        gSound:SetVolume(volume)

        if volume <= 0 and callback then
            timer.Remove("ScriptMusic:Volume_" .. uniqueID)

            if callback then
                callback()
            end
        end
    end)
end

function PLUGIN:VolumeUp(channel, max_volume, callback)
    max_volume = max_volume or 100
    self.max_volume = max_volume

    local gSound = channel
    local uniqueID = util.CRC(channel:GetFileName())

    timer.Create("ScriptMusic:Volume_" .. uniqueID, FrameTime(), 0, function()
        if !self:IsValidGlobalSound() then
            timer.Remove("ScriptMusic:Volume_" .. uniqueID)

            if callback then
                callback()
            end

            return
        end

        local volume = gSound:GetVolume()
        volume = math.Approach(volume, max_volume / 100, FrameTime() * 0.3)

        gSound:SetVolume(volume)

        if volume >= max_volume / 100 then
            timer.Remove("ScriptMusic:Volume_" .. uniqueID)

            if callback then
                callback()
            end
        end
    end)
end

function PLUGIN:StopGlobalSound(callback)
    if self:IsValidGlobalSound() then
        local channel = self:GetGlobalSound()
        local uniqueID = util.CRC(channel:GetFileName())

        if uniqueID then
            timer.Remove("ScriptMusic:Volume_" .. uniqueID)
        end

        self:VolumeDown(self:GetGlobalSound(), function()
            channel:Stop()

            if self:IsValidGlobalSound() then
                local gSound = self:GetGlobalSound()
                gSound:Stop()
            end

            PLUGIN.sound = nil

            if callback then
                timer.Simple(1, function()
                    callback()
                end)
            end
        end)
    else
        if self:IsValidGlobalSound() then
            local gSound = self:GetGlobalSound()
            gSound:Stop()
        end

        PLUGIN.sound = nil

        if callback then
            timer.Simple(1, function()
                callback()
            end)
        end
    end
end

function PLUGIN:IsStoping()
    if !self:IsValidGlobalSound() then return true end

    local gSound = self:GetGlobalSound()
    local state = gSound:GetState()

    return state != GMOD_CHANNEL_PLAYING and state != GMOD_CHANNEL_STALLED
end

function PLUGIN:UpdateSoundVolume()
    if !self:IsValidGlobalSound() then return end
    if self:IsStoping() then return end

    local gSound = self:GetGlobalSound()

    local uniqueID = util.CRC(gSound:GetFileName())
    local max_volume = (self.max_volume or 100) / 100
    local volume = gSound:GetVolume()
    local option_volume = SETTINGS.options.Get("music_volume") / 100

    if !timer.Exists("ScriptMusic:Volume_" .. uniqueID) then
        local new_volume = max_volume * option_volume

        if volume != new_volume then
            gSound:SetVolume(new_volume)
        end
    end
end

function PLUGIN:ChangeMusic()
    if !Arbitrage.IsStartGame() then return end
    if !self:IsStoping() then return end

    local theme = self:GetTheme()
    if theme == "none" then return end

    if (!self.uChangeMusic or CurTime() >= self.uChangeMusic) then
        netstream.Start("ScriptMusic:PlayEventGL", theme)

        if self:IsValidGlobalSound() then
            local gSound = self:GetGlobalSound()
            gSound:Stop()
        end

        PLUGIN.sound = nil

        self.uChangeMusic = CurTime() + 15
    end
end

function PLUGIN:Think()
    if (!self.UpdateVolumeSound or CurTime() >= self.UpdateVolumeSound) then
        self:UpdateSoundVolume()
        self:ChangeMusic()

        self.UpdateVolumeSound = CurTime() + 0.3
    end
end

function PLUGIN:PlayEvent(event, volume, max_volume)
    netstream.Start("ScriptMusic:PlayEvent", event, volume, max_volume)
end

function PLUGIN:PlayMusic(track, volume, max_volume)
    netstream.Start("ScriptMusic:PlayMusic", track, volume, max_volume)
end



netstream.Hook("ScriptMusic:OpenMenu", function(data)
    local panel = IsValid(PLUGIN.panel) and PLUGIN.panel or vgui.Create("ScriptMusic:Menu")
    panel:SetData(data)
end)

netstream.Hook("ScriptMusic:OpenMenuSub", function(id, data)
    local panel = vgui.Create("ScriptMusic:MenuSub")
    panel:SetData(id, data)
end)

netstream.Hook("ScriptMusic:GlobalTrack", function(data, volume, max_volume)
    volume = volume and volume / 100 or 0

    PLUGIN:InitializeTrack(data, function(channel)
        PLUGIN:StopGlobalSound(function()
            PLUGIN.sound = channel

            channel:SetVolume(0)
            channel:Play()

            --PLUGIN:VolumeUp(channel, max_volume)
        end)
    end)
end)

netstream.Hook("ScriptMusic:LocalTrack", function(data, volume, max_volume)
    volume = volume and volume / 100 or 0

    PLUGIN:InitializeTrack(data, function(channel)
        channel:SetVolume(volume)
        channel:Play()

        PLUGIN:VolumeUp(channel, max_volume)
    end)
end)

netstream.Hook("ScriptMusic:StopTheme", function()
    PLUGIN:StopGlobalSound()
end)