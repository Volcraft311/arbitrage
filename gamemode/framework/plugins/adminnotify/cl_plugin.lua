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


surface.CreateFont("ixAdminNotifyFont", {
    font = "Arial",
    size = ScreenScale(5),
    weight = 400,
    extended = true,
    antialias = true,
    shadow = false,
})

function AdminNotify:CreateNotify(data)
    if !IsValid(AdminNotify.panel) then
        AdminNotify.panel = vgui.Create("ixAdminNotify")
    end

    if !SETTINGS.options.Get("show_admin_notify") then return end

    AdminNotify.panel:AddNewNotify(data)
end


concommand.Add("arb_adminnotify_reload", function(client)
    if !client:IsAdmin() then return end

    if IsValid(AdminNotify.panel) then
        AdminNotify.panel:Remove()
    end

    vgui.Create("ixAdminNotify")
end)


netstream.Hook("ixAdminNotify", function(notify, ...)
    if !AdminNotify.notifyList[notify] then return end

    local info = {AdminNotify.notifyList[notify](...)}

    if #info > 0 then
        AdminNotify:CreateNotify(info)

        for k, v in ipairs(info) do
            if isstring(v) then
                info[k] = F(v)
            end
        end

        MsgC(unpack(info))
        Msg("\n")
    end
end)


timer.Simple(1, function()
    if IsValid(AdminNotify.panel) then
        AdminNotify.panel:Remove()
    end

    vgui.Create("ixAdminNotify")
end)