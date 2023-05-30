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
    name = "Отображение кнопки действий",
    title = "Кнопки действий",
    description = "Отображает подсказки в нижнем левом углу экрана, на котором отображены кнопки, при нажатии на которые будут выполняться определенные действия.",
    image = "danganronpa/settings/interface_open_button.png"
})

SETTINGS.options.Add("show_gamemode_info", SETTINGS.type.bool, true, {
    name = "Отображение информацию о режиме",
    title = "Текст о режиме",
    description = "Маленький текстовый блок в верхнем правом углу экрана. Хранит в себе информацию о текущей версии режима.",
    image = "danganronpa/settings/show_gamemode_info.png"
})

-- SETTINGS.options.Add("show_profiler_info", SETTINGS.type.bool, false, {
--     name = "Отображение нагрузки сервера",
--     title = "Текст о нагрузке",
--     description = "Информационный блок, находящийся в нижнем левом углу, отвечающий за отображение нагрузки которую испытывает сервер на текущий момент.",
--     image = "danganronpa/settings/show_profiler_info.png"
-- })

SETTINGS.options.Add("show_crosshair", SETTINGS.type.bool, true, {
    name = "Отображение прицела",
    title = "Прицел по середине экрана",
    description = "Динамический прицел в виде круга. В зависимости от расстояния до точки на которую смотрит игрок, прицел будет менять свой размер.",
    image = "danganronpa/settings/show_crosshair.png"
})

SETTINGS.options.Add("interface_sound", SETTINGS.type.bool, true, {
    name = "Звуки в интерфейсе",
    title = "Включить проигрывание звуков в интерфейсе",
    description = "Звуки проигрываются при взаимодействии с интерфейсом. Не влияет на музыку, проигрываемую на заднем фоне.",
    image = "danganronpa/settings/interface_sound.png"
})

SETTINGS.options.Add("show_stamina", SETTINGS.type.bool, true, {
    name = "Отображение стамины",
    title = "Включить отображение стамины на интерфейсе",
    description = "Информирует о текущем количестве выносливости персонажа.",
    image = "danganronpa/settings/show_stamina.png"
})

SETTINGS.options.Add("show_beta_test", SETTINGS.type.bool, false, {
    name = "Скрывать информацию о раннем доступе",
    title = "Включить открытие панели о раннем доступе",
    description = "Данная панель будет присутствовать на этапах разработки, а также Закрытого Бета Тестирования (ЗБТ) и Открытого Бета Тестирования (ОБТ). После успешно проведённых тестов и выхода в релиз, панель будет удалена.",
    image = "danganronpa/settings/show_beta_test.png"
})

SETTINGS.options.Add("show_invisible", SETTINGS.type.bool, true, {
    name = "Отображение о невидимости",
    title = "Текст о том, что вы находите в невидимости",
    description = "Краткое напоминание в самом низу экрана при нахождении в noclip'е.",
    image = "danganronpa/settings/show_invisible.png",
    IsHidden = function(client)
        return client:IsAdmin()
    end
})

SETTINGS.options.Add("show_admin_notify", SETTINGS.type.bool, true, {
    name = "Отображение админских уведомлений",
    title = "Информация о действиях на сервере",
    description = "Один из элементов инструментария администрации и ведущих. Отображает всплывающие окна в верхнем правом углу экрана, информирующих о недавно совершенных действиях игроков и администрации.",
    image = "danganronpa/settings/show_admin_notify.png",
    IsHidden = function(client)
        return client:IsAdmin()
    end
})

SETTINGS.options.Add("show_admin_esp", SETTINGS.type.bool, true, {
    name = "Отображение админского ESP",
    title = "Информация о игроках",
    description = "Включает точечное отображение текущего местоположения игроков, а также: имя их персонажа, псевдоним игрока, ранг, характеристики, точку взгляда персонажа, текущий предмет в руках и расстояние до персонажа. Изначально отображает опознавательные данные, но по мере приближения к персонажу, количество информации увеличивается.",
    image = "danganronpa/settings/show_admin_esp.png",
    IsHidden = function(client)
        return client:IsAdmin()
    end
})

SETTINGS.options.Add("corpse_find_volume", SETTINGS.type.number, 50, {
    name = "Громкость при обнаружении трупа",
    title = "Громкость музыки при обнаружении трупа",
    description = "При нахождении трупа тремя персонажами, включается звуковой сигнал, подтверждающий убийство и начало расследования.",
    min = 0,
    max = 100
})

SETTINGS.options.Add("camera_smoothness", SETTINGS.type.number, 25, {
    name = "Регулятор инерции камеры",
    title = "Регулятор инерции камеры",
    description = "Отвечает за плавность и скорость вращения камеры от лица персонажа. При выставлении минимальных процентов, вращение камеры становится медленным и с дополнительным эффектом плавности, а при максимальном проценте — поворот камеры становится мгновенным и полностью теряет плавность",
    min = 3,
    max = 25
})

SETTINGS.options.Add("monopad_smoothness", SETTINGS.type.number, 3, {
    name = "Инерция курсора Монопада",
    title = "Регулятор инерции курсона Монопада",
    description = "Отвечает за плавность и скорость курсора вашего Монопада.",
    min = 1,
    max = 10
})

SETTINGS.options.Add("music_volume", SETTINGS.type.number, 20, {
    name = "Громкость музыки",
    title = "Громкость проигрываемой музыки",
    description = "Отвечает за громкость проигрываемой музыки на заднем фоне, во время игрового процесса.",
    min = 0,
    max = 100
})

SETTINGS.options.Add("show_typingdraw", SETTINGS.type.bool, true, {
    name = "Отображать текст над головой",
    title = "Отображение текста",
    description = "Включить отображение текста игрока над его головой при взаимодействии или написания в чат."
})

SETTINGS.options.Add("show_chaticon", SETTINGS.type.bool, true, {
    name = "Отображать иконки над головой",
    title = "Отображение иконки",
    description = "Включить отображение иконки игрока над его головой, которая указывает в какой чат печатает игрок."
})

SETTINGS.options.Add("show_hints", SETTINGS.type.bool, true, {
    name = "Отображать подсказки",
    title = "Отображение подсказок на экране",
    description = "Включить отображение подсказок в левом верхнем углу экрана."
})

SETTINGS.options.Add("chatbox_size", SETTINGS.type.number, 8, {
    name = "Размер текста чата",
    title = "Изменить размер букв в чате",
    description = "Отвечает за размер символов отображаемых в чате.",
    min = 3,
    max = 20
})

SETTINGS.options.Add("static_crosshair", SETTINGS.type.bool, false, {
    name = "Статический прицел",
    title = "Статический прицел",
    description = "Выключить динамический прицел и перейти в статическую версию."
})

SETTINGS.options.Add("alpha_localplayer", SETTINGS.type.bool, true, {
    name = "Изменять прозрачность игроку от 3-его лица",
    title = "Изменять прозрачность игроку от 3-его лица",
    description = "Включить изменение прозрачности локального игрока в зависимости от дальности камеры."
})