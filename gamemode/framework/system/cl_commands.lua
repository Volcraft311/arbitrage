--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
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
RegisterCommand("try", "Возможное действие случая.", {"text"})
RegisterCommand("w", "Шептать персонажам рядом с вами.", {"text"})
RegisterCommand("y", "Крикнуть персонажам рядом с вами.", {"text"})
RegisterCommand("it", "Описать местное действие или событие.", {"text"})
RegisterCommand("looc", "Написать в локальный НонРП чат.", {"text"})
RegisterCommand("ooc", "Написать в глобальный НонРП чат.", {"text"})
RegisterCommand("broadcast", "Написать уведомление в общий чат.", {"text"})
RegisterCommand("sg", "Получить изображение экрана игрока.", {"player"})
RegisterCommand("settime", "Установить время на сервере.", {"time"})
RegisterCommand("roll", "Крутить число от 0 до 100.")
RegisterCommand("freezeprops", "Заморозить все физические пропы.")
RegisterCommand("editor", "Зайти в режим редактирования.")
RegisterCommand("unstuck", "Телепортироваться на ближайшую позицию.")
RegisterCommand("exitaction", "Выйти из анимации.")
RegisterCommand("action", "Войти в определенную анимацию.", {"text"})
RegisterCommand("sitting", "Изменить анимацию при сидении.", {"number"})
RegisterCommand("mood", "Изменить настроение.", {"number"})
RegisterCommand("lookaround", "Осмотреться.")

netstream.Hook("arb.ChatNotify", function(data)
    if !data then return end

    Arbitrage.notify.NotifyChat(data)
end)