--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

timer.Simple(1, function()
    Arbitrage.commands.Add("goto", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            client.moderationOldPos = client:GetPos()

            client:SetPos(target:GetPos())
            client:UnStuck()
        end
    })

    Arbitrage.commands.Add("bring", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            target.moderationOldPos = target:GetPos()

            target:SetPos(client:GetPos())
            target:UnStuck()
        end
    })

    Arbitrage.commands.Add("tp", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            target.moderationOldPos = target:GetPos()

            target:SetPos(client:GetEyeTrace().HitPos)
            target:UnStuck()
        end
    })

    Arbitrage.commands.Add("pm", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
            [2] = {
                name = "Текст",
                type = "text",
                important = true
            },
        },
        OnAction = function(client, target, message)
            if client == target then return Arbitrage.commands.Notify(client, "Вы не можете отправить сообщение самому себе!") end

            Arbitrage.chat.SendCommand("pm", client, target, message)
        end,
        bNoLog = true
    })

    for _, command in ipairs({"a", "admin"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Текст",
                    type = "text",
                    important = true
                },
            },
            OnAction = function(client, message)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                Arbitrage.chat.SendCommand("admin", client, message)
            end
        })
    end

    for _, command in ipairs({"help", "report"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Текст",
                    type = "text",
                    important = true
                },
            },
            OnAction = function(client, message)
                if client:IsAdmin() then return Arbitrage.commands.Notify(client, "Вы являетесь администратором и не можете запросить помощь!") end

                Arbitrage.chat.SendCommand("help", client, message)
                netstream.Start(player.GetAdmins(), "Moderation:HelpTarget", client:SteamID())
            end
        })
    end

    Arbitrage.commands.Add("return", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end
            if !target.moderationOldPos then return Arbitrage.commands.Notify(client, "Отсутствует старая позиция!") end

            target:SetPos(target.moderationOldPos)
            target:UnStuck()
        end
    })

    for _, command in ipairs({"unanonymous", "unincognito", "returnrank", "rr"}) do
        Arbitrage.commands.Add(command, {
            arguments = {},
            OnAction = function(client)
                if client:GetStaticUserGroup() == "user" then return Arbitrage.commands.Notify(client, "У вас отсутствует статический ранг и вы не можете выдать себе права!") end
                if client:GetStaticUserGroup() == client:GetDynamicUserGroup() then return Arbitrage.commands.Notify(client, "Вам уже выданы данные права!") end

                client:Give("weapon_physgun")
                client:Give("gmod_tool")

                for k, v in ipairs(player.GetAdmins()) do
                    Arbitrage.commands.Notify(v, "Администратор " .. client:FullName() .. " вернул себе админские права!")
                end

                client:SetDynamicToStaticUserGroup()
                Arbitrage.commands.Notify(client, "Вы успешно вернули себе права. Чтобы их снять, используйте команду \"/tr\"!")
            end
        })
    end

    for _, command in ipairs({"anonymous", "incognito", "takerank", "tr"}) do
        Arbitrage.commands.Add(command, {
            arguments = {},
            OnAction = function(client)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end
                if client:GetStaticUserGroup() == "user" then return Arbitrage.commands.Notify(client, "У вас отсутствует статический ранг и вы не можете снять с себя права данной командой!") end

                client:StripWeapon("weapon_physgun")
                client:StripWeapon("gmod_tool")

                client:SetDynamicUserGroup("user")

                for k, v in ipairs(player.GetAdmins()) do
                    Arbitrage.commands.Notify(v, "Администратор " .. client:FullName() .. " забрал у себя админские права!")
                end

                Arbitrage.commands.Notify(client, "Вы успешно сняли с себя права. Чтобы их вернуть, используйте команду \"/rr\"!")
            end
        })
    end

    for _, command in ipairs({"hp", "health"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Игрок",
                    type = "player",
                    important = true
                },
                [2] = {
                    name = "Значение",
                    type = "number",
                    important = true
                },
            },
            OnAction = function(client, target, value)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                target:SetHealth(value)
            end
        })
    end

    for _, command in ipairs({"ar", "armor"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Игрок",
                    type = "player",
                    important = true
                },
                [2] = {
                    name = "Значение",
                    type = "number",
                    important = true
                },
            },
            OnAction = function(client, target, value)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                target:SetArmor(value)
            end
        })
    end

    Arbitrage.commands.Add("hunger", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
            [2] = {
                name = "Значение",
                type = "number",
                important = true
            },
        },
        OnAction = function(client, target, value)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            Arbitrage.statistics.Set(target, "Hunger", value)
        end
    })

    Arbitrage.commands.Add("thirst", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
            [2] = {
                name = "Значение",
                type = "number",
                important = true
            },
        },
        OnAction = function(client, target, value)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            Arbitrage.statistics.Set(target, "Thirst", value)
        end
    })

    Arbitrage.commands.Add("sleep", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
            [2] = {
                name = "Значение",
                type = "number",
                important = true
            },
        },
        OnAction = function(client, target, value)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            Arbitrage.statistics.Set(target, "Sleep", value)
        end
    })

    Arbitrage.commands.Add("cleardecals", {
        arguments = {},
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            BroadcastLua([[RunConsoleCommand("r_cleardecals")]])
        end
    })

    Arbitrage.commands.Add("slap", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            target:SetVelocity(Vector(math.random(-225, 225), math.random(-225, 225), 10))
        end
    })

    for _, command in ipairs({"kill", "slay"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Игрок",
                    type = "player",
                    important = true
                },
            },
            OnAction = function(client, target)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                target:Kill()
            end
        })
    end

    for _, command in ipairs({"ignite", "fire"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Игрок",
                    type = "player",
                    important = true
                },
                [2] = {
                    name = "Значение",
                    type = "number",
                    important = false
                },
            },
            OnAction = function(client, target, delay)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                delay = delay or 999999
                target:Ignite(delay)
            end
        })
    end

    for _, command in ipairs({"unignite", "unfire", "extinguish"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Игрок",
                    type = "player",
                    important = true
                },
            },
            OnAction = function(client, target)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                target:Extinguish()
            end
        })
    end

    Arbitrage.commands.Add("freezeprops", {
        arguments = {},
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            for k, v in ipairs(ents.FindByClass("prop_physics")) do
                local physicsObject = v:GetPhysicsObject()

                if IsValid(physicsObject) then
                    physicsObject:EnableMotion(false)
                end
            end
        end
    })

    for _, command in ipairs({"map", "changemap", "changelevel"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Карта",
                    type = "string",
                    important = true
                },
            },
            OnAction = function(client, map)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                map = map:lower()
                game.ConsoleCommand("changelevel " .. map .. "\n")
            end
        })
    end

    for _, command in ipairs({"getmaps", "maps"}) do
        Arbitrage.commands.Add(command, {
            arguments = {},
            OnAction = function(client)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                Arbitrage.commands.Notify(client, "Список всех доступных карт на сервере:")

                local maps = file.Find( "maps/*.bsp", "GAME" )
                for k, v in ipairs(maps) do
                    local name = string.gsub(v, "%.bsp$", ""):lower()

                    client:ChatPrint(name)
                end
            end
        })
    end

    Arbitrage.commands.Add("kick", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
            [2] = {
                name = "Причина",
                type = "text",
                important = false
            },
        },
        OnAction = function(client, target, reason)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            reason = reason or "Вы были кикнуты администратором сервера!"
            target:Kick(reason)
        end
    })

    Arbitrage.commands.Add("runconsolecommand", {
        arguments = {
            [1] = {
                name = "Причина",
                type = "text",
                important = true
            },
        },
        OnAction = function(client, command)
            if !client:IsSuperAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            command = string.Explode(" ", command)
            asterionlib.RunConsoleCommand(unpack(command))
        end
    })

    Arbitrage.commands.Add("reset", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            }
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            local id = target:Team()
            local character = Character.team:GetByID(id)

            local health, armor = ARBITRAGE_HEALTH, ARBITRAGE_ARMOR
            if character then
                health = character:GetHealth()
                armor = character:GetArmor()
            end

            target:SetHealth(health)
            target:SetArmor(armor)

            for k, v in pairs(Arbitrage.statistics.list) do
                Arbitrage.statistics.Set(target, v.data, 100)
            end
        end
    })

    Arbitrage.commands.Add("respawn", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            }
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            Character.team:Join(target, target:Team(), true)
        end
    })

    Arbitrage.commands.Add("model", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
            [2] = {
                name = "Модель",
                type = "string",
                important = true
            }
        },
        OnAction = function(client, target, model)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            target:SetModel(model)
        end
    })

    Arbitrage.commands.Add("guard", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            },
            [2] = {
                name = "Время",
                type = "string",
                important = true
            }
        },
        OnAction = function(client, target, delay)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            for k, v in ipairs(player.GetAdmins()) do
                Arbitrage.commands.Notify(v, "Администратор " .. client:FullName() .. " выдал админские права " .. target:FullName(true) .. " на " .. delay .. "!")
            end

            local time = asterionlib.IsoDurationToSeconds(delay)
            target:SetDynamicUserGroup("guard", time)

            Arbitrage.commands.Notify(target, "Вам были выданы админские права на " .. delay .. "!")
        end
    })

    Arbitrage.commands.Add("unguard", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            }
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end
            if !target:IsAdmin() then return Arbitrage.commands.Notify(client, "Данный пользователь не имеет прав администрирования!") end

            target:SetDynamicUserGroup("user")

            for k, v in ipairs(player.GetAdmins()) do
                Arbitrage.commands.Notify(v, "Администратор " .. client:FullName() .. " забрал админские права у " .. target:FullName(true) .. "!")
            end

            Arbitrage.commands.Notify(target, "С вас были сняты админские права!")
        end
    })

    Arbitrage.commands.Add("restartserver", {
        arguments = {
            [1] = {
                name = "Время",
                type = "number",
                important = false
            }
        },
        OnAction = function(client, delay)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end
            if bServerRestart then return Arbitrage.commands.Notify(client, "Сервер уже получил запрос на его перезапуск!") end

            delay = delay or 30

            local adminName = client:FullName(true)

            local function notifyAll(data)
                for k, v in ipairs(player.GetAll()) do
                    v:ChatNotify(data)
                end
            end

            timer.Simple(0.5, function()
                antifreeze.SetTimeout(1)
                hook.Remove("PlayerDisconnected", "asterionlib.antifreeze")
                hook.Remove("PlayerConnect", "asterionlib.antifreeze")

                hook.Add("CheckPassword", "RestartServer", function()
                    return false, "Сервер перезапускается"
                end)

                timer.Create("RestartServer", 1, delay, function()
                    notifyAll("Сервер будет перезапущен через " .. delay .. " секунд!")

                    delay = delay - 1

                    if delay <= 0 then
                        for k, v in ipairs(player.GetAll()) do
                            v:Kick("Администратор " .. adminName .. " перезапустил сервер!\nПереподключайтесь через 1-2 минуты после появления данного окна.")
                        end

                        timer.Simple(1, function()
                            hook.Call("ShutDown", GAMEMODE)
                        end)

                        timer.Simple(3, function()
                            antifreeze.RestartServer()
                        end)
                    end
                end)

                notifyAll("Администратор " .. adminName .. " запустил перезапуск сервера!")
            end)

            bServerRestart = true
            Arbitrage.commands.Notify(client, "Вы отправили серверу запрос на его перезапуск. Для отмены используйте команду /unrestartserver!")
        end
    })

    Arbitrage.commands.Add("unrestartserver", {
        arguments = {},
        OnAction = function(client, delay)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end
            if !bServerRestart then return Arbitrage.commands.Notify(client, "Сервер не получил запроса на перезапуск!") end

            local function notifyAll(data)
                for k, v in ipairs(player.GetAll()) do
                    v:ChatNotify(data)
                end
            end

            antifreeze.SetTimeout(90)
            hook.Remove("CheckPassword", "RestartServer")
            timer.Remove("RestartServer")

            hook.Add("PlayerDisconnected", "asterionlib.antifreeze", function()
                if #player.GetAll() <= 1 then
                    antifreeze.SetTimeout(3600)
                end
            end)

            hook.Add("PlayerConnect", "asterionlib.antifreeze", function()
                if #player.GetAll() >= 0 then
                    antifreeze.SetTimeout(90)
                end
            end)

            bServerRestart = false
            notifyAll("Администратор " .. client:FullName(true) .. " отменил перезапуск сервера!")
        end
    })

    Arbitrage.commands.Add("freeze", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            }
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            target:Freeze(true)
        end
    })

    Arbitrage.commands.Add("unfreeze", {
        arguments = {
            [1] = {
                name = "Игрок",
                type = "player",
                important = true
            }
        },
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            target:Freeze(false)
        end
    })

    Arbitrage.commands.Add("removesoundscape", {
        arguments = {},
        OnAction = function(client, target)
            if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

            for k, v in ipairs(ents.GetAll()) do
                if v:GetClass() == "env_soundscape" then
                    v:Remove()
                end
            end

            BroadcastLua([=[RunConsoleCommand("stopsound") RunConsoleCommand("stopsoundscape") RunConsoleCommand("snd_restart")]=])

            hook.Add("PlayerInitialSpawnForRealz", "Arbitrage:RemoveSoundScape", function(client)
                timer.Simple(1, function()
                    client:SendLua([=[RunConsoleCommand("stopsound") RunConsoleCommand("stopsoundscape") RunConsoleCommand("snd_restart")]=])
                end)
            end)
        end
    })

    for _, command in ipairs({"strip", "strips", "stripweapons", "stripsweapons"}) do
        Arbitrage.commands.Add(command, {
            arguments = {
                [1] = {
                    name = "Игрок",
                    type = "player",
                    important = true
                }
            },
            OnAction = function(client, target)
                if !client:IsAdmin() then return Arbitrage.commands.Notify(client, "Недостаточно прав для выполнения данной команды!") end

                target:StripWeapons()
                target:Give("academy_first")
                target:Give("academy_key")
                target:SelectWeapon("academy_key")
            end
        })
    end
end)
