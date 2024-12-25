-- Иконки https://heyter.github.io/js-famfamfam-search/

local function _force(value)
    local a = !value and next(Trigger.PlayerInside) != nil
    print(a)
    return a
end


Trigger.ActionTypes = {
    {
        name = "Написать в консоль",
        run = function(trigger, args, client)
            local delay = args[3]
            local force = args[4]
            timer.Simple(delay or 0,function()
                if CLIENT then
                    if _force(force) then return false end
                    RunConsoleCommand(args[1],args[2])
                end
            end)
        end,
        args = {"string","string","number","bool"},
        args_desc = {"Консольная Команда", "Аргументы команды", "Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ", -- Не используется, но в планах.
        default = {"say","/me test message",0,true},
        icon = "icon16/application_osx_terminal.png"
    },
    {
        name = "Изменить цветокор",
        run = function(trigger, args, client)
            local delay = args[6]
            local force = args[7]
            timer.Simple(delay or 0,function()
                if CLIENT then
                    if _force(force) then return false end
                    local color_add = args[1]
                    local color_mul = args[2]
                    local brightness = args[3]
                    local contrast = args[4]
                    local saturation  = args[5]
                    ColorModify.TriggerColor = {
                        brightness = brightness,
                        contrast = contrast,
                        enabled = true,
                        color = saturation,
                        mulr = color_mul.r,
                        mulg = color_mul.g,
                        mulb = color_mul.b,
                        addr = color_add.r,
                        addg = color_add.g,
                        addb = color_add.b,
                    }
                end
            end)
        end,
        args = {"color","color","number","number","number","number","bool"},
        args_desc = {"Умножить цвет","Добавить цвет","Яркость", "Контрасность","Насыщенность", "Задержка до выполнения", "Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {Color(0,0,0),Color(0,0,0),0,1,1,0,true},
        icon = "icon16/image.png"
    },
    {
        name = "Удалить цветокор",
        run = function(trigger, args, client)
            local delay = args[1]
            local force = args[2]
            timer.Simple(delay or 0,function()
                if CLIENT then
                    if _force(force) then return false end
                    ColorModify.TriggerColor = nil
                end
            end)
        end,
        args = {"number","bool"},
        args_desc = {"Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {0, true},
        icon = "icon16/image_delete.png"
    },
    {
        name = "Изменить Гравитацию",
        run = function(trigger, args, client)
            local delay = args[2]
            timer.Simple(delay or 0,function()
                if SERVER then
                    client:SetGravity(args[1])
                end
            end)
        end,
        args = {"number","number","bool"},
        args_desc = {"Величина", "Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {0,0,true},
        icon = "icon16/application_osx_terminal.png"
    },
}