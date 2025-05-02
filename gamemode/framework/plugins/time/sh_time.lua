local MINUTES_PER_HOUR = 60
local MINUTES_PER_DAY = MINUTES_PER_HOUR * 24

function Time:ToUnformated(time)
    return time.hours * MINUTES_PER_HOUR + time.minutes
end

function Time:GetUnformated()
    return GetNetVar("arb.Time", 0)
end

function Time:GetFormated()
    return self:ToFormated(self:GetUnformated())
end

function Time:GetMinutes(time)
    time = time or Time:GetUnformated()
    return math.floor(math.fmod(time, MINUTES_PER_HOUR))
end

function Time:GetHours(time)
    time = time or Time:GetUnformated()
    return math.floor(math.fmod(time, MINUTES_PER_DAY) / MINUTES_PER_HOUR)
end

Time.dayTime = Time.dayTime or Time:ToUnformated({hours = 8, minutes = 0})
Time.nightTime = Time.nightTime or Time:ToUnformated({hours = 22, minutes = 0})

function Time:IsDay()
    local time = self:GetUnformated()

    return (time > self.dayTime and time < self.nightTime)
end

function Time:IsNight()
    return !self:IsDay()
end

function Time:ToFormated(time)
    local hours = self:GetHours(time)
    local minutes = self:GetMinutes(time)

    local _h = ("%d"):format(hours)
    local _m = ("%d"):format(minutes)

    if tonumber(_h) < 10 then _h = "0" .. _h end
    if tonumber(_m) < 10 then _m = "0" .. _m end

    return Format("%s:%s", _h, _m)
end