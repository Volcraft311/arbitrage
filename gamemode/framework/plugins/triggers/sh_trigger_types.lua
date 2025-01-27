--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://asterion.games/chancery
        
        developer(s):
            Volcraft - https://steamcommunity.com/id/boobsgunner
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Trigger.ActionTypes = {}

local function _force(value)
    local a = !value and table.Count(Trigger.PlayerInside) > 0

    return a
end

function Trigger:AddActionType(data)
    data.args = {}
    data.args_desc = {}
    data.default = {}

    for k, v in pairs(data.arguments or {}) do
        data.args[k] = v.type
        data.args_desc[k] = v.tooltip
        data.default[k] = v.default
    end

    data.arguments = nil

    table.insert(self.ActionTypes, data)
end

Trigger:AddActionType({
    name = "Написать в консоль",
    icon = "icon16/application_osx_terminal.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Консольная Команда", type = "string", default = "say"},
        [2] = {tooltip = "Аргументы команды", type = "string", default = "/me test message"},
        [3] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
        [4] = {tooltip = "Неизбежный", type = "bool", default = true}
    },
    run = function(trigger, args, client)
        if SERVER then return end

        local command = args[1]
        local argument = args[2]
        local delay = args[3]
        local force = args[4]

        timer.Simple(delay or 0, function()
            if _force(force) then return end

            RunConsoleCommand(command, argument)
        end)
    end
})

Trigger:AddActionType({
    name = "Изменить цветокор",
    icon = "icon16/image.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Умножить цвет", type = "color", default = Color(0, 0, 0)},
        [2] = {tooltip = "Добавить цвет", type = "color", default = Color(0, 0, 0)},
        [3] = {tooltip = "Яркость", type = "number", default = 0},
        [4] = {tooltip = "Контрасность", type = "number", default = 1},
        [5] = {tooltip = "Насыщенность", type = "number", default = 1},
        [6] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
        [7] = {tooltip = "Скорость", type = "number", default = 1},
        [8] = {tooltip = "Неизбежный", type = "bool", default = true}
    },
    run = function(trigger, args, client)
        if SERVER then return end

        local color_mul = args[1]
        local color_add = args[2]
        local brightness = args[3]
        local contrast = args[4]
        local saturation = args[5]
        local delay = args[6]
        local duration = args[7]
        local force = args[8]

        timer.Simple(delay or 0, function()
            if _force(force) then return end

            timer.Remove("Trigger:ColorModify")

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
                ColorModify.AllTweens[k]:SetDuration(duration)
                ColorModify.AllTweens[k]:Start()
            end

            timer.Create("Trigger:ColorModify", 0, 0, function()
                for k, v in pairs(ColorModify.CurrentTColor) do
                    ColorModify.CurrentTColor[k] = ColorModify.AllTweens[k]:GetValue()
                end

                if ColorModify.AllTweens["color"]:TimeLeft() <= 0 then timer.Remove("Trigger:ColorModify") end
            end)
        end)
    end
})

Trigger:AddActionType({
    name = "Удалить цветокор",
    icon = "icon16/image_delete.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
        [2] = {tooltip = "Неизбежный", type = "bool", default = true}
    },
    run = function(trigger, args, client)
        if SERVER then return end

        local delay = args[1]
        local force = args[2]

        timer.Simple(delay or 0, function()
            if _force(force) then return end

            ColorModify.CurrentTColor = table.Copy(ColorModify.DefaultTColor)
            timer.Remove("Trigger:ColorModify")
        end)
    end
})

Trigger:AddActionType({
    name = "Изменить Гравитацию",
    icon = "icon16/controller.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Величина", type = "number", default = 1},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local gravity = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            client:SetGravity(gravity)
        end)
    end
})

Trigger:AddActionType({
    name = "Написать в чат",
    icon = "icon16/email_edit.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Сообщение", type = "string", default = "Текст"},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        if SERVER then return end

        local message = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            chat.AddText(message)
        end)
    end
})

Trigger:AddActionType({
    name = "Воспроизвести звук по URL",
    icon = "icon16/music.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "URL", type = "string", default = "https://audio.jukehost.co.uk/sI7Q85iVfHnQ9SksLELgKFEhTGzK8YNV"},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        if SERVER then return end

        local url = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            sound.PlayURL(url, "", function(station)
                if IsValid(station) then
                    station:SetPos(LocalPlayer():GetPos())
                    station:Play()
                    g_station = station
                else
                    LocalPlayer():ChatPrint("Invalid URL!")
                end
            end)
        end)
    end
})

Trigger:AddActionType({
    name = "Оттолкнуть",
    icon = "icon16/lightning_go.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "X", type = "number", default = 0},
        [2] = {tooltip = "Y", type = "number", default = 0},
        [3] = {tooltip = "Z", type = "number", default = 0},
        [4] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        local x = args[1]
        local y = args[2]
        local z = args[3]
        local delay = args[4]

        timer.Simple(delay or 0, function()
            if CLIENT then return end

            local firstTime = true
            timer.Create("Trigger:Push" .. tostring(trigger) .. tostring(client), 0, 0, function()
                if trigger:IsPlayerInside(client) or firstTime then
                    firstTime = false

                    local vel = Vector(x, y, z)
                    client:SetVelocity(vel)
                else
                    timer.Remove("Trigger:Push" .. tostring(trigger) .. tostring(client))
                end
            end)
        end)
    end
})

Trigger:AddActionType({
    name = "Опрокинуть",
    icon = "icon16/status_away.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Время", type = "number", default = 1},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local time = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            client:FallOver(time)
        end)
    end
})

Trigger:AddActionType({
    name = "Телепортировать",
    icon = "icon16/arrow_in.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Позиция", type = "vector", default = Vector(0, 0, 0)},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        if CLIENT then return end
        local pos = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            if client:IsRagdoll() or client:IsRagdolling() then
                local ent = client:GetRagdoll()
                local offset = pos - ent:GetPos()

                for i = 0, ent:GetPhysicsObjectCount() - 1 do
                    local phys = ent:GetPhysicsObjectNum(i)

                    phys:SetPos(phys:GetPos() + offset)
                    phys:SetVelocity(Vector(0, 0, 0))
                end
            else
                client:SetPos(pos)
                client:CheckStuck(0.3)
            end
        end)
    end
})

Trigger:AddActionType({
    name = "Изменить здоровье",
    icon = "icon16/heart.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Здоровье", type = "number", default = 100},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local health = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            client:SetHealth(health)
        end)
    end
})

Trigger:AddActionType({
    name = "Изменить броню",
    icon = "icon16/heart.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Броня", type = "number", default = 100},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0}
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local armor = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            client:SetArmor(armor)
        end)
    end
})

Trigger:AddActionType({
    name = "Убить",
    icon = "icon16/stop.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local delay = args[1]

        timer.Simple(delay or 0, function()
            client:Kill()
        end)
    end
})

Trigger:AddActionType({
    name = "Заморозить",
    icon = "icon16/shape_square_delete.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local delay = args[1]

        timer.Simple(delay or 0, function()
            client:Freeze(true)
        end)
    end
})

Trigger:AddActionType({
    name = "Разморозить",
    icon = "icon16/shape_square_add.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local delay = args[1]

        timer.Simple(delay or 0, function()
            client:Freeze(false)
        end)
    end
})

Trigger:AddActionType({
    name = "Поджечь",
    icon = "icon16/transmit.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Длина", type = "number", default = 5},
        [2] = {tooltip = "Радиус", type = "number", default = 0},
        [3] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local length = args[1]
        local radius = args[2]
        local delay = args[3]

        timer.Simple(delay or 0, function()
            client:Ignite(length, radius)
        end)
    end
})

Trigger:AddActionType({
    name = "Потушить",
    icon = "icon16/transmit_blue.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local delay = args[1]

        timer.Simple(delay or 0, function()
            client:Extinguish()
        end)
    end
})

Trigger:AddActionType({
    name = "Нанести урон",
    icon = "icon16/chart_line.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Количество", type = "number", default = 1},
        [2] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local amount = args[1]
        local delay = args[2]

        timer.Simple(delay or 0, function()
            client:TakeDamage(amount)
        end)
    end
})

Trigger:AddActionType({
    name = "Выключить триггер",
    icon = "icon16/cross.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local delay = args[1]

        timer.Simple(delay or 0, function()
            if !trigger:GetActive() then return end

            trigger:SetActive(false)
            trigger:Sync()
        end)
    end
})

Trigger:AddActionType({
    name = "Включить триггер",
    icon = "icon16/tick.png",
    hint = "ПОМОЩИ НЕ БУДЕТ, МОЛИСЬ",
    arguments = {
        [1] = {tooltip = "Задержка до выполнения", type = "number", default = 0},
    },
    run = function(trigger, args, client)
        if CLIENT then return end

        local delay = args[1]

        timer.Simple(delay or 0, function()
            if trigger:GetActive() then return end

            trigger:SetActive(true)
            trigger:Sync()
        end)
    end
})