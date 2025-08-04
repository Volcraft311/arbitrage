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


local allKeys = {
    [KEY_Q] = "Q", [KEY_W] = "W", [KEY_E] = "E", [KEY_R] = "R", [KEY_T] = "T", [KEY_Y] = "Y", [KEY_U] = "U", [KEY_I] = "I", [KEY_O] = "O", [KEY_P] = "P", [KEY_LBRACKET] = "[", [KEY_RBRACKET] = "]",
    [KEY_A] = "A", [KEY_S] = "S", [KEY_D] = "D", [KEY_F] = "F", [KEY_G] = "G", [KEY_H] = "H", [KEY_J] = "J", [KEY_K] = "K", [KEY_L] = "L", [KEY_SEMICOLON] = ";", [KEY_APOSTROPHE] = "'",
    [KEY_Z] = "Z", [KEY_X] = "X", [KEY_C] = "C", [KEY_V] = "V", [KEY_B] = "B", [KEY_N] = "N", [KEY_M] = "M", [KEY_COMMA] = ",", [KEY_PERIOD] = ".", [KEY_SLASH] = "/",

    [KEY_F1] = "F1", [KEY_F2] = "F2", [KEY_F3] = "F3", [KEY_F4] = "F4", [KEY_F5] = "F5", [KEY_F6] = "F6", [KEY_F7] = "F7", [KEY_F8] = "F8", [KEY_F9] = "F9", [KEY_F10] = "F10", [KEY_F11] = "F11", [KEY_F12] = "F12",
    [KEY_1] = "1", [KEY_2] = "2", [KEY_3] = "3", [KEY_4] = "4", [KEY_5] = "5", [KEY_6] = "6", [KEY_7] = "7", [KEY_8] = "8", [KEY_9] = "9", [KEY_0] = "0", [KEY_MINUS] = "-", [KEY_EQUAL] = "=",

    [KEY_BACKSLASH] = "\\", [KEY_TAB] = "TAB", [KEY_CAPSLOCK] = "CAPS", [KEY_LSHIFT] = "LSHIFT", [KEY_RSHIFT] = "RSHIFT", [KEY_LCONTROL] = "LCTRL", [KEY_RCONTROL] = "RCTRL",

    [MOUSE_LEFT] = "MOUSE LEFT", [MOUSE_RIGHT] = "MOUSE RIGHT", [MOUSE_MIDDLE] = "MOUSE MIDDLE", [MOUSE_4] = "MOUSE 4", [MOUSE_5] = "MOUSE 5",

    [KEY_LALT] = "LALT", [KEY_RALT] = "RALT"
}

SETTINGS.binds.MouseList = {
    [MOUSE_LEFT] = true,
    [MOUSE_RIGHT] = true,
    [MOUSE_MIDDLE] = true,
    [MOUSE_4] = true,
    [MOUSE_5] = true
}

for key, value in pairs(allKeys) do
    SETTINGS.binds.AddKey(key, value)
end


SETTINGS.binds.Add("open_interface", KEY_Q, {
    name = "#binds_open_interface_name",
    title = "#binds_open_interface_title",
    description = "#binds_open_interface_desc"
})

SETTINGS.binds.Add("open_context", KEY_C, {
    name = "#binds_open_context_name",
    title = "#binds_open_context_title",
    description = "#binds_open_context_desc"
})

SETTINGS.binds.Add("open_scoreboard", KEY_TAB, {
    name = "#binds_open_scoreboard_name",
    title = "#binds_open_scoreboard_title",
    description = "#binds_open_scoreboard_desc"
})

SETTINGS.binds.Add("open_mainmenu_ui", KEY_F1, {
    name = "#binds_open_mainmenu_ui_name",
    title = "#binds_open_mainmenu_ui_title",
    description = "#binds_open_mainmenu_ui_desc"
})

SETTINGS.binds.Add("open_monomenu_ui", KEY_F3, {
    name = "#binds_open_monomenu_ui_name",
    title = "#binds_open_monomenu_ui_title",
    description = "#binds_open_monomenu_ui_desc"
})

SETTINGS.binds.Add("open_material_ui", KEY_F4, {
    name = "#binds_open_material_ui_name",
    title = "#binds_open_material_ui_title",
    description = "#binds_open_material_ui_desc"
})

SETTINGS.binds.Add("voice_up", KEY_RBRACKET, {
    name = "#binds_voice_up_name",
    title = "#binds_voice_up_title",
    description = "#binds_voice_up_desc"
})

SETTINGS.binds.Add("voice_down", KEY_LBRACKET, {
    name = "#binds_voice_down_name",
    title = "#binds_voice_down_title",
    description = "#binds_voice_down_desc"
})

SETTINGS.binds.Add("sitting", KEY_N, {
    name = "#binds_sitting_name",
    title = "#binds_sitting_title",
    description = "#binds_sitting_desc"
})

SETTINGS.binds.Add("radialmenu", KEY_H, {
    name = "#binds_radialmenu_name",
    title = "#binds_radialmenu_title",
    description = "#binds_radialmenu_desc"
})

SETTINGS.binds.Add("spectating", KEY_B, {
    name = "#binds_spectating_name",
    title = "#binds_spectating_title",
    description = "#binds_spectating_desc",
    IsHidden = function(client)
        return client:IsAdmin()
    end
})

SETTINGS.binds.Add("prone", KEY_SLASH, {
    name = "#binds_prone_name",
    title = "#binds_prone_title",
    description = "#binds_prone_desc"
})

SETTINGS.binds.Add("closerlook", KEY_LALT, {
    name = "#binds_closerlook_name",
    title = "#binds_closerlook_title",
    description = "#binds_closerlook_desc"
})

SETTINGS.binds.Add("finger_anim", KEY_G, {
    name = "Указать пальцем",
    title = "Указать пальцем",
    description = "Войти в анимацию показания пальцем"
})