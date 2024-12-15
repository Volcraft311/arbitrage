Trigger.actionList = {
    {
        name = "Написать в консоль",
        run = function(trigger, args)
            local delay = args[3]
            timer.Simple(delay or 0,function()
                if CLIENT then
                    RunConsoleCommand(args[1],args[2])
                end
            end)
        end,
        args = {"string","string","number"},
        args_desc = {"Консольная Команда", "Аргументы команды", "Задержка до выполнения"}
    }
}