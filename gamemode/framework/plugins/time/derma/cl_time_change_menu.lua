local PANEL = {}

function PANEL:Init()
    if (Arbitrage.time_change_menu) then
        Arbitrage.time_change_menu:Remove()
    end

    Arbitrage.time_change_menu = self
    local minutes = Time:GetMinutes()
    local hours = Time:GetHours()
    self:SetSize(300,200)
    self:Center()
    self:SetTitle("Time Change")
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.1)

    local time_panel = self:Add("DPanel")
    time_panel:Dock(TOP)
    time_panel:DockMargin(80,0,80,0)
    time_panel:SetTall(30)

    local hours_wang = time_panel:Add("DNumberWang")
    hours_wang:Dock(LEFT)
    hours_wang:SetValue(hours)
    function hours_wang:OnValueChanged(val)
        self.Value = math.Clamp(val, 0, 23)
    end

    function hours_wang:OnEnter(val)
        self:SetText(math.Clamp(val, 0, 23))
    end

    local minutes_wang = time_panel:Add("DNumberWang")
    minutes_wang:Dock(RIGHT)
    minutes_wang:SetValue(minutes)

    function minutes_wang:OnValueChanged(val)
        self.Value = math.Clamp(val, 0, 59)
    end

    function minutes_wang:OnEnter(val)
        self:SetText(math.Clamp(val, 0, 59))
    end

    local apply_button = self:Add("DButton")
    apply_button:Dock(TOP)
    apply_button:DockMargin(80,5,80,10)
    apply_button:SetText("Применить")
    
    local SpeedSlider = self:Add( "DNumSlider")
    SpeedSlider:Dock(TOP)
    SpeedSlider:SetText( "Time Speed" )
    SpeedSlider:SetMin( 1 )
    SpeedSlider:SetMax( 100 )
    SpeedSlider:SetDefaultValue(1)
    SpeedSlider:SetDecimals( 0 )
    SpeedSlider:SetValue(GetNetVar("arb.TimeSpeed", 1))
    function SpeedSlider:OnValueChanged(val)
        netstream.Start("Time:SetSpeed", val)
    end

    local PauseBox = self:Add("DCheckBoxLabel")
    PauseBox:Dock(TOP)
    PauseBox:SetText( "Time Paused" )
    PauseBox:SetValue(GetNetVar("arb.TimePaused", false))

    function PauseBox:OnChange(val)
        netstream.Start("Time:SetPause", val)
    end

    function apply_button:DoClick()
        netstream.Start("Time:SetFormated", {hours = hours_wang:GetValue(), minutes = minutes_wang:GetValue()})
    end
end

vgui.Register("arb.timeChangeMenu", PANEL, "DFrame")
