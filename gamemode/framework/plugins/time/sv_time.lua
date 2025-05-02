Time.BaseTick = 7 -- Равноценный 17 в прошлой сборке
Time.Speed = Time.Speed or 1
Time.Paused = Time.Paused or false

local TIME_MINUTE = 1
local TIME_HOUR = 60
local _NextTick = _NextTick or SysTime()

hook.Add("Tick","arb.TimeUpdate",function()
    if (Time.Paused) then return end 
    if (SysTime() >= _NextTick) then

        Time:AddMinutes(1)
        _NextTick = SysTime() + (Time.BaseTick / Time.Speed)
    end
end)

function Time:ResetTimeUpdate()
    _NextTick = 0
end

function Time:Unpause()
    Time.Paused = false
    SetNetVar("arb.TimePaused", false)
end

function Time:Pause()
    Time.Paused = true
    SetNetVar("arb.TimePaused", true)
end

function Time:SetSpeed(speed)
    if (speed == 0) then
        error("TIME SPEED CANNOT BE EQUAL TO ZERO")
    end
    SetNetVar("arb.TimeSpeed", speed)
    self.Speed = speed
end

function Time:GetSpeed()
    return self.Speed
end

function Time:AddMinutes(minutes)
    self:SetUnformated(minutes * TIME_MINUTE + self:GetUnformated())
end

function Time:AddHours(hours)
    self:SetUnformated(hours * TIME_HOUR + self:GetUnformated())
end

function Time:AddUnformated(time)
    self:SetUnformated(time + self:GetUnformated())
end

function Time:SetUnformated(time)
    SetNetVar("arb.Time", time)
end

function Time:SetFormated(time)
    self:SetUnformated(self:ToUnformated(time))
end


netstream.Hook("Time:SetFormated", function(client, timedata)
    if (!client:IsAdmin()) then return end 
    Time:SetFormated(timedata)
end)

netstream.Hook("Time:SetUnfromated", function(client, timedata)
    if (!client:IsAdmin()) then return end 
    Time:SetUnfromated(timedata)
end)

netstream.Hook("Time:SetSpeed", function(client, value)
    if (!client:IsAdmin()) then return end
    Time:SetSpeed(value)
    Time:ResetTimeUpdate()
end)

netstream.Hook("Time:SetPause", function(client, value)
    if (!client:IsAdmin()) then return end
    if (value) then 
        Time:Pause()
    else
        Time:Unpause()
    end
end)