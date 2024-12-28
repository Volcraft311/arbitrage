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
    name = "Кнопка открытия инвентаря",
    title = "Интерфейс",
    description = "Открывает интерфейса инвентаря"
})

SETTINGS.binds.Add("open_context", KEY_C, {
    name = "Кнопка открытия интерфейса с действиями",
    title = "Интерфейс с действиями",
    description = "Открывает контекстное меню вместе с информацией о персонаже"
})

SETTINGS.binds.Add("open_scoreboard", KEY_TAB, {
    name = "Кнопка открытия списка игроков",
    title = "Список игроков",
    description = "Открывает таблицу текущим списком игроков на сервере и информацией о них"
})

SETTINGS.binds.Add("open_mainmenu_ui", KEY_F1, {
    name = "Кнопка открытия главного меню",
    title = "Главное меню",
    description = "Открывает главное меню"
})

SETTINGS.binds.Add("open_monomenu_ui", KEY_F3, {
    name = "Кнопка открытия мономеню",
    title = "Мономеню",
    description = "Открывает мономеню, которое имеет в себе полный доступ к инструментарию ведущих и администраторов"
})

SETTINGS.binds.Add("open_material_ui", KEY_F4, {
    name = "Кнопка открытия меню материалов",
    title = "Список Материалов",
    description = "Открывает окно с материалами и уликами для текущей игры"
})

SETTINGS.binds.Add("voice_up", KEY_RBRACKET, {
    name = "Повысить дальность микрофона",
    title = "Громкость микрофона",
    description = "Повышает расстояние слышимости вашего голоса"
})

SETTINGS.binds.Add("voice_down", KEY_LBRACKET, {
    name = "Понизить дальность микрофона",
    title = "Громкость микрофона",
    description = "Понижает расстояние слышимости вашего голоса"
})

SETTINGS.binds.Add("sitting", KEY_N, {
    name = "Кнопка для сидения",
    title = "Сесть на пол",
    description = "Кнопка при помощи которой вы можете сесть на землю"
})

SETTINGS.binds.Add("radialmenu", KEY_H, {
    name = "Кнопка меню действий",
    title = "Меню действий",
    description = "Кнопка которая открываем интерфейс с разными взаимодействиями"
})

SETTINGS.binds.Add("spectating", KEY_B, {
    name = "Режим наблюдения",
    title = "Режим наблюдения",
    description = "Кнопка, которая отвечает за вход/выход из режима наблюдения",
    IsHidden = function(client)
        return client:IsAdmin()
    end
})

SETTINGS.binds.Add("prone", KEY_SLASH, {
    name = "Лечь на землю",
    title = "Лечь на землю",
    description = "Кнопка, которая отвечает за вход/выход из режима ползания"
})

SETTINGS.binds.Add("closerlook", KEY_LALT, {
    name = "Присмотреться",
    title = "Присмотреться",
    description = "Возможность приблизить изображение когда вы держите ключи или руки"
})