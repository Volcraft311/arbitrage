-- Иконки https://heyter.github.io/js-famfamfam-search/

local function _force(value)
    local a = !value and next(Trigger.PlayerInside) != nil
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
            local force = args[8]
            timer.Simple(delay or 0,function()
                if CLIENT then
                    if _force(force) then return false end
                    timer.Remove("Trigger:ColorModify")
                    local color_add = args[2]
                    local color_mul = args[1]
                    local brightness = args[3]
                    local contrast = args[4]
                    local saturation  = args[5]
                    ColorModify.TargetTColor = {
                        brightness = brightness,
                        contrast = contrast,
                        color = saturation,
                        mulr = color_mul.r,
                        mulg = color_mul.g,
                        mulb = color_mul.b,
                        addr = color_add.r * 0.1,
                        addg = color_add.g * 0.1,
                        addb = color_add.b * 0.1,
                    }
                    for k, v in pairs(ColorModify.CurrentTColor) do
                        ColorModify.AllTweens[k]:SetTo(ColorModify.TargetTColor[k])
                        ColorModify.AllTweens[k]:SetFrom(v)
                        ColorModify.AllTweens[k]:SetDuration(args[7])
                        ColorModify.AllTweens[k]:Start()
                    end
                    timer.Create("Trigger:ColorModify",0,0,function()
                        for k, v in pairs(ColorModify.CurrentTColor) do
                            ColorModify.CurrentTColor[k] = ColorModify.AllTweens[k]:GetValue()
                        end
                        if ColorModify.AllTweens["color"]:TimeLeft() <= 0 then
                            timer.Remove("Trigger:ColorModify")
                        end
                    end)
                end
            end)
        end,
        args = {"color","color","number","number","number","number","number","bool"},
        args_desc = {"Умножить цвет","Добавить цвет","Яркость", "Контрасность","Насыщенность", "Задержка до выполнения","Скорость", "Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {Color(0,0,0),Color(0,0,0),0,1,1,0,1,true},
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
                    timer.Remove("Trigger:ColorModify")
                    ColorModify.CurrentTColor = table.Copy(ColorModify.DefaultTColor)
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
        icon = "icon16/controller.png"
    },
    {
        name = "Написать в чат",
        run = function(trigger, args, client)
            local delay = args[2]
            timer.Simple(delay or 0,function()
                if CLIENT then
                    ChatBox.panel:AddMessage(args[1])
                end
            end)
        end,
        args = {"string","number","bool"},
        args_desc = {"Сообщение", "Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {0,0,true},
        icon = "icon16/email_edit.png"
    },
    {
        name = "Воспроизвести звук по URL",
        run = function(trigger, args, client)
            local delay = args[2]
            timer.Simple(delay or 0,function()
                if CLIENT then
                    local g_station = nil
                    sound.PlayURL ( args[1], "", function( station )
                        if ( IsValid( station ) ) then

                            station:SetPos( LocalPlayer():GetPos() )

                            station:Play()

                            g_station = station

                        else

                            LocalPlayer():ChatPrint( "Invalid URL!" )

                        end
                    end )
                end
            end)
        end,
        args = {"string","number","bool"},
        args_desc = {"URL", "Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {"https://audio.jukehost.co.uk/sI7Q85iVfHnQ9SksLELgKFEhTGzK8YNV",0,true},
        icon = "icon16/music.png",
    },
    {
        name = "Оттолкнуть",
        run = function(trigger, args, client)
            local delay = args[4]
            timer.Simple(delay or 0,function()
                if SERVER then
                    local firstTime = true
                    timer.Create("Trigger:Push" .. tostring(client),0,0,function()
                        if trigger:IsPlayerInside(client) or firstTime then
                            firstTime = false
                            local vel = Vector(args[1],args[2],args[3])
                            local dummy = client
                            dummy:SetVelocity(vel)
                        else
                            timer.Remove("Trigger:Push" .. tostring(trigger))
                        end
                    end)
                end
            end)
        end,
        args = {"number","number","number","number","bool"},
        args_desc = {"X","Y","Z", "Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {0,0,0,0,true},
        icon = "icon16/lightning_go.png"
    },
    {
        name = "Опрокинуть",
        run = function(trigger, args, client)
            local delay = args[2]
            timer.Simple(delay or 0,function()
                if SERVER then
                    client:FallOver(args[1])
                end
            end)
        end,
        args = {"number","number","bool"},
        args_desc = {"Время", "Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {1,0,true},
        icon = "icon16/music.png",
    },
    {
        name = "Телепортировать",
        run = function(trigger, args, client)
            local delay = args[2]
            timer.Simple(delay or 0,function()
                if SERVER then
                    local force = args[3]
                    if _force(force) then return false end
                    local pos = args[1]
                    Print(pos)
                    client:SetPos(pos)
                    client:CheckStuck(0.3)
                end
            end)
        end,
        args = {"vector","number","bool"},
        args_desc = {"Позиция", "Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {Vector(0,0,0),0,true},
        icon = "icon16/arrow_in.png"
    },
    {
        name = "Изменить здоровье",
        run = function(trigger, args, client)
            local delay = args[3]
            timer.Simple(delay or 0,function()
                if SERVER then
                    local force = args[4]
                    if _force(force) then return false end
                    client:SetHealth(args[1])
                end
            end)
        end,
        args = {"number","number","bool"},
        args_desc = {"Здоровье","Задержка до выполнения","Неизбежный"},
        hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
        default = {100,0,0,true},
        icon = "icon16/heart.png"
    },
    {
        name = "Изменить броню",
        run = function(trigger, args, client)
            local delay = args[2]
            timer.Simple(delay or 0,function()
                if SERVER then
                    local force = args[3]
                    if _force(force) then return false end
                    client:SetArmor(args[1])
                end
            end)
        end,
        args = {"number","number","bool"},
        args_desc = {"Броня","Задержка до выполнения","Неизбежный"},
        default = {100,0,true},
        icon = "icon16/heart.png"
    }
}