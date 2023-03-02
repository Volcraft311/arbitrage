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

PLUGIN.sound = nil

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

function PLUGIN:IsValidGlobalSound()
    local s = self.sound

    if s and type(s) == "IGModAudioChannel" and s:IsValid() then
        return true
    end

    return false
end

function PLUGIN:VolumeDown(channel, callback)
    local uniqueID = util.CRC(channel:GetFileName())

    local function cb()
        timer.Remove("ScriptMusic:Volume_" .. uniqueID)

        if callback then
            callback()
        end
    end

    timer.Create("ScriptMusic:Volume_" .. uniqueID, FrameTime(), 0, function()
        if self:IsValidGlobalSound() then
            local volume = self.sound:GetVolume()
            volume = math.Approach(volume, 0, FrameTime() * 0.3)

            self.sound:SetVolume(volume)

            if volume <= 0 and callback then
                cb()
            end
        else
            cb()
        end
    end)
end

function PLUGIN:VolumeUp(channel, max_volume, callback)
    max_volume = max_volume or 100
    self.max_volume = max_volume

    local uniqueID = util.CRC(channel:GetFileName())

    local function cb()
        timer.Remove("ScriptMusic:Volume_" .. uniqueID)

        if callback then
            callback()
        end
    end

    timer.Create("ScriptMusic:Volume_" .. uniqueID, FrameTime(), 0, function()
        if self:IsValidGlobalSound() then
            local volume = self.sound:GetVolume()
            volume = math.Approach(volume, max_volume / 100, FrameTime() * 0.3)

            self.sound:SetVolume(volume)

            if volume >= max_volume / 100 then
                cb()
            end
        else
            cb()
        end
    end)
end

function PLUGIN:StopGlobalSound(callback)
    if self:IsValidGlobalSound() then
        self:VolumeDown(self.sound, function()
            if self.sound then
                self.sound:Stop()
                self.sound = nil

                if callback then
                    timer.Simple(1, function()
                        callback()
                    end)
                end
            else
                if callback then
                    callback()
                end
            end
        end)
    else
        self.sound = nil

        if callback then
            timer.Simple(1, function()
                callback()
            end)
        end
    end
end

function PLUGIN:IsStoping()
    if !self:IsValidGlobalSound() then return true end

    local state = self.sound:GetState()
    return state == GMOD_CHANNEL_STOPPED or state == GMOD_CHANNEL_PAUSED
end

function PLUGIN:UpdateSoundVolume()
    if !self:IsValidGlobalSound() then return end
    if self:IsStoping() then return end

    local uniqueID = util.CRC(self.sound:GetFileName())
    local max_volume = (self.max_volume or 100) / 100
    local volume = self.sound:GetVolume()
    local option_volume = SETTINGS.options.Get("music_volume") / 100

    if !timer.Exists("ScriptMusic:Volume_" .. uniqueID) then
        local new_volume = max_volume * option_volume

        if volume != new_volume then
            self.sound:SetVolume(new_volume)
        end
    end
end

function PLUGIN:ChangeMusic()
    if !Arbitrage.IsStartGame() then return end

    local theme = self:GetTheme()
    if theme == "none" then return end

    if (!self.uChangeMusic or CurTime() >= self.uChangeMusic) then
        if self:IsStoping() then
            netstream.Start("ScriptMusic:PlayEventGL", theme)

            if self:IsValidGlobalSound() then
                self.sound:Stop()
                self.sound = nil
            end

            self.uChangeMusic = CurTime() + 10
        end
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

local isLoading = false
netstream.Hook("ScriptMusic:GlobalTrack", function(path, volume, max_volume)
    if isLoading then return end

    volume = volume and volume / 100 or 0

    isLoading = true
    PLUGIN:StopGlobalSound(function()
        PLUGIN.sound = nil

        PLUGIN:InitializeTrack(path, function(channel)
            if PLUGIN.sound then
                PLUGIN.sound:Stop()
                PLUGIN.sound = nil
            end

            PLUGIN.sound = channel
            channel:SetVolume(0)
            channel:Play()

            MsgC(Color(0, 255, 0), "Сейчас играет: ", channel:GetFileName(), "\n")

            isLoading = false
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