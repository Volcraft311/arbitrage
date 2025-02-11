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

Arbitrage.notify = Arbitrage.library.Add("notify")

function Arbitrage.notify.Add(data, warning)
    if !data then return end

    local notify = Arbitrage.notifypanel:Add("arb.Notify") -- vgui.Create("arb.Notify")
    notify:Dock(TOP)
    notify:DockMargin(0, 10, 0, 0)
    notify:SetData(data)
    notify:SetWarning(warning)
end

function Arbitrage.notify.NotifyChat(data)
    if !data then return end

    if !istable(data) then
        data = {data}
    end

    for k, v in ipairs(data) do
        if isstring(v) then
            data[k] = F(v)
        end
    end

    chat.AddText(Color(255, 61, 96), "| ", color_white, unpack(data))
end

netstream.Hook("arb.Notify", function(data, warning)
    if !data then return end

    Arbitrage.notify.Add(data, warning)
end)

timer.Simple(0, function()
    if IsValid(Arbitrage.notifypanel) then
        Arbitrage.notifypanel:Remove()
    end

    Arbitrage.notifypanel = asterionlib.netgui:Create("arb.NotifyPanel")
end)