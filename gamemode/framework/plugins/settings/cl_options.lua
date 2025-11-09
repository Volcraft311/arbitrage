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


SETTINGS.options.Add("interface_open_button", SETTINGS.type.bool, true, {
    name = "#options_interface_open_button_name",
    title = "#options_interface_open_button_title",
    description = "#options_interface_open_button_desc",
    category = "#option_e_hints",
    image = "danganronpa/settings/interface_open_button.png",
    m_type = "bool"
})

SETTINGS.options.Add("show_gamemode_info", SETTINGS.type.bool, true, {
    name = "#options_show_gamemode_info_name",
    title = "#options_show_gamemode_info_title",
    description = "#options_show_gamemode_info_desc",
    category = "#option_e_hints",
    image = "danganronpa/settings/show_gamemode_info.png",
    m_type = "bool"
})

SETTINGS.options.Add("show_crosshair", SETTINGS.type.bool, true, {
    name = "#options_show_crosshair_name",
    title = "#options_show_crosshair_title",
    description = "#options_show_crosshair_desc",
    category = "#option_a_general",
    image = "danganronpa/settings/show_crosshair.png",
    m_type = "bool"
})

SETTINGS.options.Add("interface_sound", SETTINGS.type.bool, true, {
    name = "#options_interface_sound_name",
    title = "#options_interface_sound_title",
    description = "#options_interface_sound_desc",
    category = "#option_b_audio",
    image = "danganronpa/settings/interface_sound.png",
    m_type = "bool"
})

SETTINGS.options.Add("show_stamina", SETTINGS.type.bool, true, {
    name = "#options_show_stamina_name",
    title = "#options_show_stamina_title",
    description = "#options_show_stamina_desc",
    category = "#option_c_gameplay",
    image = "danganronpa/settings/show_stamina.png",
    m_type = "bool"
})

-- УДАЛИТЬ НИЖЕ
SETTINGS.options.Add("show_beta_test", SETTINGS.type.bool, false, {
    name = "#options_show_beta_test_name",
    title = "#options_show_beta_test_title",
    description = "#options_show_beta_test_desc",
    image = "danganronpa/settings/show_beta_test.png",
    m_type = "bool"
})

SETTINGS.options.Add("show_invisible", SETTINGS.type.bool, true, {
    name = "#options_show_invisible_name",
    title = "#options_show_invisible_title",
    description = "#options_show_invisible_desc",
    category = "#option_h_admin",
    image = "danganronpa/settings/show_invisible.png",
    IsHidden = function(client)
        return client:IsAdmin()
    end,
    m_type = "bool"
})

SETTINGS.options.Add("show_admin_notify", SETTINGS.type.bool, true, {
    name = "#options_show_admin_notify_name",
    title = "#options_show_admin_notify_title",
    description = "#options_show_admin_notify_desc",
    category = "#option_h_admin",
    image = "danganronpa/settings/show_admin_notify.png",
    IsHidden = function(client)
        return client:IsAdmin()
    end,
    m_type = "bool"
})

SETTINGS.options.Add("show_admin_esp", SETTINGS.type.bool, true, {
    name = "#options_show_admin_esp_name",
    title = "#options_show_admin_esp_title",
    description = "#options_show_admin_esp_desc",
    category = "#option_h_admin",
    image = "danganronpa/settings/show_admin_esp.png",
    IsHidden = function(client)
        return client:IsAdmin()
    end,
    m_type = "bool"
})

SETTINGS.options.Add("corpse_find_volume", SETTINGS.type.number, 50, {
    name = "#options_corpse_find_volume_name",
    title = "#options_corpse_find_volume_title",
    category = "#option_b_audio",
    description = "#options_corpse_find_volume_desc",
    min = 0,
    max = 100,
    m_type = "number"
})

SETTINGS.options.Add("viewbob_strength", SETTINGS.type.number, 50, {
    name = "#options_viewbob_strength_name",
    title = "#options_viewbob_strength_title",
    description = "#options_viewbob_strength",
    category = "#option_a_general",
    min = 0,
    max = 100,
    m_type = "number"
})

SETTINGS.options.Add("camera_smoothness", SETTINGS.type.number, 25, {
    name = "#options_camera_smoothness_name",
    title = "#options_camera_smoothness_title",
    description = "#options_camera_smoothness_desc",
    category = "#option_a_general",
    min = 3,
    max = 25,
    m_type = "number"
})

SETTINGS.options.Add("monopad_smoothness", SETTINGS.type.number, 3, {
    name = "#options_monopad_smoothness_name",
    title = "#options_monopad_smoothness_title",
    description = "#options_monopad_smoothness_desc",
    category = "#option_a_general",
    min = 1,
    max = 10,
    m_type = "number"
})

SETTINGS.options.Add("music_volume", SETTINGS.type.number, 20, {
    name = "#options_music_volume_name",
    title = "#options_music_volume_title",
    description = "#options_music_volume_desc",
    category = "#option_b_audio",
    min = 0,
    max = 100,
    m_type = "number"
})

SETTINGS.options.Add("show_typingdraw", SETTINGS.type.bool, true, {
    name = "#options_show_typingdraw_name",
    title = "#options_show_typingdraw_title",
    description = "#options_show_typingdraw_desc",
    category = "#option_c_gameplay",
    m_type = "bool"
})

SETTINGS.options.Add("show_chaticon", SETTINGS.type.bool, true, {
    name = "#options_show_chaticon_name",
    title = "#options_show_chaticon_title",
    description = "#options_show_chaticon_desc",
    category = "#option_c_gameplay",
    m_type = "bool"
})

SETTINGS.options.Add("show_hints", SETTINGS.type.bool, true, {
    name = "#options_show_hints_name",
    title = "#options_show_hints_title",
    description = "#options_show_hints_desc",
    category = "#option_e_hints",
    m_type = "bool"
})

SETTINGS.options.Add("chatbox_size", SETTINGS.type.number, 8, {
    name = "#options_chatbox_size_name",
    title = "#options_chatbox_size_title",
    description = "#options_chatbox_size_desc",
    category = "#option_f_chat",
    min = 3,
    max = 20,
    m_type = "number"
})

SETTINGS.options.Add("static_crosshair", SETTINGS.type.bool, false, {
    name = "#options_static_crosshair_name",
    title = "#options_static_crosshair_title",
    description = "#options_static_crosshair_desc",
    category = "#option_a_general",
    m_type = "bool"
})

SETTINGS.options.Add("alpha_localplayer", SETTINGS.type.bool, true, {
    name = "#options_alpha_localplayer_name",
    title = "#options_alpha_localplayer_title",
    description = "#options_alpha_localplayer_desc",
    category = "#option_d_graphics",
    m_type = "bool"
})