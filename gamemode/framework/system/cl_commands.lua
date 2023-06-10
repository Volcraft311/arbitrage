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

Arbitrage.commands = Arbitrage.library.Add("commands")
Arbitrage.commands.stored = {}

local function RegisterCommand(command, help, arguments, optionalArguments)
    Arbitrage.commands.stored[command] = {
        help = help,
        arguments = arguments,
        optionalArguments = optionalArguments
    }
end

RegisterCommand("me", "Говорить от третьего лица с окружающими.", {"text"})
RegisterCommand("mec", "Говорить от третьего лица с окружающими ВБЛИЗИ вас.", {"text"})
RegisterCommand("mel", "Говорить от третьего лица с окружающими большой площади вокруг вас", {"text"})

RegisterCommand("try", "Возможное действие случая.", {"text"})
RegisterCommand("tryc", "Возможное действие случая ближнего радиуса.", {"text"})
RegisterCommand("tryl", "Возможное действие случая большого радиуса.", {"text"})

RegisterCommand("it", "Описать местное действие или событие.", {"text"})
RegisterCommand("itc", "Описать местное действие или событие ближнего радиуса действия.", {"text"})
RegisterCommand("itl", "Описать местное действие или событие на большом расстоянии.", {"text"})

RegisterCommand("w", "Шептать персонажам рядом с вами.", {"text"})
RegisterCommand("y", "Крикнуть персонажам рядом с вами.", {"text"})
RegisterCommand("looc", "Написать в локальный НонРП чат.", {"text"})
RegisterCommand("ooc", "Написать в глобальный НонРП чат.", {"text"})
RegisterCommand("broadcast", "Написать уведомление в общий чат.", {"text"})
RegisterCommand("sg", "Получить изображение экрана игрока.", {"player"})
RegisterCommand("settime", "Установить время на сервере.", {"time"})
RegisterCommand("roll", "Крутить число от 0 до 100.", nil, {"number"})
RegisterCommand("freezeprops", "Заморозить все физические пропы.")
RegisterCommand("editor", "Зайти в режим редактирования.")
RegisterCommand("unstuck", "Телепортироваться на ближайшую позицию.")
RegisterCommand("exitaction", "Выйти из анимации.")
RegisterCommand("action", "Войти в определенную анимацию.", {"text"})
RegisterCommand("sitting", "Изменить анимацию при сидении.", {"number"})
RegisterCommand("mood", "Изменить настроение.", {"number"})
RegisterCommand("lookaround", "Осмотреться.")
RegisterCommand("settimespeed", "Изменить скорость времени.", {"number"})

netstream.Hook("arb.ChatNotify", function(data)
    if !data then return end

    Arbitrage.notify.NotifyChat(data)
end)