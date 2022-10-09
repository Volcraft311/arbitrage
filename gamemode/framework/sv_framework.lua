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

Arbitrage.commands.Add("discord", {
    arguments = {},
    OnAction = function(client)
        netstream.Start(client, "arb.OpenURL", "https://google.com")
    end
})

-- Arbitrage.commands.Add("drop", {
--     arguments = {},
--     OnAction = function(client)
--         local message = Arbitrage.weapon.Drop(client)

--         if message then
--             Arbitrage.commands.Notify(client, message)
--         end
--     end
-- })

Arbitrage.commands.Add("me", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        if client:IsSpectate() then return end

        Arbitrage.chat.SendCommand("me", client, text)
    end
})

Arbitrage.commands.Add("try", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        if client:IsSpectate() then return end
        local rand = math.random(0, 100) >= 50 and true or false

        Arbitrage.chat.SendCommand("try", client, text, rand)
    end
})

Arbitrage.commands.Add("w", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        if client:IsSpectate() then return end

        Arbitrage.chat.SendCommand("whispers", client, text)
    end
})

Arbitrage.commands.Add("y", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        if client:IsSpectate() then return end

        Arbitrage.chat.SendCommand("yell", client, text)
    end
})

Arbitrage.commands.Add("it", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        if client:IsSpectate() then return end

        Arbitrage.chat.SendCommand("it", client, text)
    end
})

Arbitrage.commands.Add("looc", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        Arbitrage.chat.SendCommand("looc", client, text)
    end
})

Arbitrage.commands.Add("ooc", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        if Arbitrage.OffOOC() then
            return Arbitrage.commands.Notify(client, "Глобальный чат отключен!")
        end

        Arbitrage.chat.SendCommand("ooc", client, text)
    end
})

Arbitrage.commands.Add("broadcast", {
    arguments = {
        [1] = {
            name = "Текст",
            type = "text",
            important = true
        },
    },
    OnAction = function(client, text)
        if !client:IsAdmin() then return end

        Arbitrage.chat.SendCommand("broadcast", client, text)
    end
})

Arbitrage.commands.Add("sg", {
    arguments = {
        [1] = {
            name = "Игрок",
            type = "string",
            important = true
        }
    },
    OnAction = function(client, target)
        if !client:IsAdmin() then return end

        target = player.GetByIdentifier(target)
        if !IsValid(target) then return end

        local client_name = client:SteamName()
        local client_steamid = client:SteamID()

        Arbitrage.commands.Notify(client, "Обрабатываем...")

        local b = ("Ответ администратору **%s**(%s)"):format(client_name, client_steamid)

        asterionlib.sg:Capture(b, target, function(url)
            Arbitrage.commands.Notify(client, "Скриншот экрана: " .. url)

            client:SendLua([[
                local frame = vgui.Create("DFrame")
                frame:SetSize(ScrW(), ScrH())
                frame:SetTitle("]] .. url .. [[")
                frame:MakePopup()
                local html = vgui.Create("DHTML", frame)
                html:Dock(FILL)
                html:OpenURL("]] .. url .. [[")
            ]])
        end)
    end
})

Arbitrage.commands.Add("settime", {
    arguments = {
        [1] = {
            name = "Время",
            type = "string",
            important = true
        }
    },
    OnAction = function(client, time)
        if !client:IsAdmin() then return end

        local value = asterionlib.IsoDurationToSeconds(time)

        Arbitrage.CurTime = value
        Arbitrage.commands.Notify(client, "Вы успешно изменили время на: " .. time)
    end
})

Arbitrage.commands.Add("roll", {
    arguments = {},
    OnAction = function(client)
        if client:IsSpectate() then return end

        Arbitrage.chat.SendCommand("roll", client, "получил(а) шанс " .. math.random(1, 100) .. " из 100.")
    end
})

Arbitrage.commands.Add("freezeprops", {
    arguments = {},
    OnAction = function(client)
        if !client:IsAdmin() then return end

        local count = 0

        for k, v in pairs(ents.FindByClass("prop_physics")) do
            local physicsObject = v:GetPhysicsObject()

            if physicsObject and physicsObject:IsMotionEnabled() then
                physicsObject:EnableMotion(false)

                count = count + 1
            end
        end

        Arbitrage.commands.Notify(client, "Вы успешно заморозили " .. count .. " пропов!")
    end
})

Arbitrage.commands.Add("editor", {
    arguments = {},
    OnAction = function(client)
        if !client:IsAdmin() then return end

        local bEditor = client:IsEditing()

        client:SetEditing(!bEditor)
    end
})

Arbitrage.commands.Add("unstuck", {
    arguments = {},
    OnAction = function(client)
        if client:IsSpectate() then return end

        if client:IsStuck() then
            client:UnStuck()

            Arbitrage.commands.Notify(client, "Сервер телепортировал вас на ближайшую позицию!")
        else
            Arbitrage.commands.Notify(client, "Вы не застряли!")
        end
    end
})

function Arbitrage:PlayerShouldTaunt(client, act)
    if !client:Alive() then return false end
    if !client:IsPlaying() then return false end
    if client:GetNetVar("inbed") then return false end
    if client.GetSitting and client:GetSitting() then return false end

    return true
end

function Arbitrage:KeyPress(client, key)
    if client:oldAlive() and client:IsPlaying() and key == IN_JUMP and !client:IsNocliping() then
        local stamina = client:GetLocalVar("stm", 100)

        client:SetLocalVar("stm", math.Clamp(stamina - (12.5 / 2), 0, 100))
        client.StaminaCD = CurTime() + 3
    end

    client.spectateplayer = client.spectateplayer or 0
    if client:IsSpectate() and (key == IN_ATTACK or key == IN_ATTACK2) then
        local first_player = 0
        local last_player = 0
        local alive_players = {}

        for k, v in SortedPairs(player.GetAll()) do
            if v:oldAlive() and !v:IsSpectate() and !v:IsHost() and v:Team() != TEAM_ADMIN then -- v:Team() == TEAM_PLAYERS
                alive_players[#alive_players + 1] = v
            end
        end

        first_player = 1
        last_player = #alive_players

        if key == IN_ATTACK then
            if client.spectateplayer == last_player then
                client.spectateplayer = first_player
                client:SpectateEntity(alive_players[first_player])
                client.spectateent = alive_players[first_player]

                client:SetNetVar("spectate", alive_players[first_player])
                goto skip
            end

            client.spectateplayer = client.spectateplayer + 1
            client:SpectateEntity(alive_players[client.spectateplayer])
            client.spectateent = alive_players[client.spectateplayer]

            client:SetNetVar("spectate", alive_players[client.spectateplayer])
        elseif key == IN_ATTACK2 then
            if client.spectateplayer == first_player then
                client.spectateplayer = last_player
                client:SpectateEntity(alive_players[last_player])
                client.spectateent = alive_players[last_player]

                client:SetNetVar("spectate", alive_players[last_player])
                goto skip
            end

            client.spectateplayer = client.spectateplayer - 1
            client:SpectateEntity(alive_players[client.spectateplayer])
            client.spectateent = alive_players[client.spectateplayer]

            client:SetNetVar("spectate", alive_players[client.spectateplayer])
        end

        ::skip::


        if client.spectateplayer > #alive_players then
            client.spectateplayer = 0
        end

        if client.spectateplayer < 0 then
            client.spectateplayer = 0
        end
    end
end

timer.Create("Arbitrage:StatisticsThink", 1, 0, function()
    for k, v in ipairs(player.GetAll()) do
        Arbitrage.statistics.PlayerPostThink(v)
    end
end)

timer.Create("Arbitrage:StaminaThink", 0.3, 0, function()
    for k, v in ipairs(player.GetAll()) do
        if !v:oldAlive() then continue end
        if !v:IsPlaying() then continue end

        local stamina = v:GetLocalVar("stm", 100)
        local frametime = FrameTime()
        local factionData = Character.team:GetByID(v:Team())
        local staminaSpending = factionData and factionData:GetRunConsumption() or 1
        local length = v:GetVelocity():LengthSqr()

        if (v:KeyDown(IN_SPEED) and !v:IsNocliping()) and length >= 10000 then
            v:SetLocalVar("stm", math.Clamp(stamina - (frametime * 60 * staminaSpending), 0, 100))
            v.StaminaCD = CurTime() + 1.5
        else
            local amount = Arbitrage.statistics.Get(v, "Thirst")
            local staminaColdDown = v.StaminaCD

            if (!staminaColdDown or CurTime() >= staminaColdDown) and amount >= 10 then
                v:SetLocalVar("stm", math.Clamp(stamina + (frametime * 220), 0, 100))
            end
        end

        if stamina >= 100 then continue end
        timer.Simple(0.2, function() -- Обработка после прыжка (если обрабатывать по тику, то после прыжка сила будет сразу же падать вниз из-за чего у нас прыжок сразу же уходит на несколько поинтов вниз)
            if !IsValid(v) then return end

            local jumppower = math.Clamp(stamina * 4, 50, ARBITRAGE_JUMP_POWER)
            v:SetJumpPower(jumppower)
        end)
    end
end)

function Arbitrage:PlayerDeath(client, inflictor, attacker)
    asterionlib.netgui:Create(client, "arb.DeathMenu")

    if client:InGame() then -- чтобы можно было вернуть в игру
        client:SetNetVar("arb.oldData", {
            client:Team(),
            client:GetPos()
        })
    end

    timer.Simple(1, function()
        if !IsValid(client) then return end

        Character.team:Join(client, TEAM_NOTCHARACTER, true)
    end)
end

function Arbitrage:PlayerInitialSpawn(client)
    timer.Create("initClient_" .. client:EntIndex(), FrameTime(), 0, function()
        if IsValid(client) then
            timer.Remove("initClient_" .. client:EntIndex())

            client:StripWeapons()
            client:StripAmmo()
            client:Freeze(false)
            client:GodDisable()
            client:SyncVars()

            Character.team:Join(client, TEAM_NOTCHARACTER, true)
            client:SendLua([[RunConsoleCommand("stopsound")]])

            client:SetNetVar("connectedTime", CurTime())

            hook.Run("PlayerInitial", client)
        end
    end)
end

function Arbitrage:ExtractArgs(text)
    local skip = 0
    local arguments = {}
    local curString = ""

    for i = 1, text:utf8len() do
        if (i <= skip) then continue end

        local c = text:utf8sub(i, i)

        if (c == "\"") then
            local match = text:utf8sub(i):match("%b\"\"")

            if (match) then
                curString = ""
                skip = i + match:utf8len()
                arguments[#arguments + 1] = match:utf8sub(2, -2)
            else
                curString = curString .. c
            end
        elseif (c == " " and curString != "") then
            arguments[#arguments + 1] = curString
            curString = ""
        else
            if (c == " " and curString == "") then
                continue
            end

            curString = curString .. c
        end
    end

    if (curString != "") then
        arguments[#arguments + 1] = curString
    end

    return arguments
end

function Arbitrage:PlayerSay(client, data)
    if data:sub(1, 1) == "!" or data:sub(1, 1) == "~" or data:sub(1, 1) == "@" then
        local message = utf8.sub(data, 2, utf8.len(data))
        local extra = Arbitrage:ExtractArgs(message)

        if data:sub(1, 1) == "@" then
            table.insert(extra, 1, "help")
        end

        local command = "sg"

        if data:sub(1, 1) == "~" then
            command = "sgs"
        end

        netstream.Start(client, "arb.SendCommand", command, extra)
        return ""
    end

    if Arbitrage.commands then
        if data:sub(1, 2) == "//" or data:sub(1, 2) == "[[" or data:sub(1, 2) == "./" then
            local command = data:sub(1, 2)
            local message = utf8.sub(data, 3, utf8.len(data))
            local extra = Arbitrage:ExtractArgs(message)

            local rep = command == "//" and "ooc" or "looc"

            Arbitrage.commands.RunCommand(client, rep, extra)
            return ""
        end

        return Arbitrage.commands.PlayerSay(client, data)
    end

    -- eh...
end

function Arbitrage:StartGame()
    ScriptMusic:ChangeTheme("startgame", true)

    timer.Remove("arb.StartGameThemeClear")
    timer.Create("arb.StartGameThemeClear", 120, 1, function()
        timer.Remove("arb.StartGameThemeClear")

        ScriptMusic:ChangeTheme("none", true)
    end)

    Arbitrage.startgame = true
    SetNetVar("arb.StartGame", Arbitrage.startgame)
    for k, v in pairs(player.GetAll()) do
        v:SyncVars()
    end

    netstream.Start(nil, "arb.Intro", 8)

    for k, v in pairs(Arbitrage.players) do
        local client = v.client
        local storedInfo = Arbitrage.players[client:SteamID()]

        if IsValid(client) and client:Alive() and client:IsPlaying() and storedInfo then
            local faction = client:Team()

            if !IsPlaying(storedInfo.faction) then
                storedInfo.faction = faction
            end

            client:Freeze(true)

            client:SendLua([[RunConsoleCommand("stopsound")]])
            client:SendLua([[RunConsoleCommand("r_cleardecals")]])

            local inventory = client:GetInventory()
            if inventory then
                -- Анэквипаем все предметы
                local items = inventory:GetItems()

                for k2, v2 in pairs(items) do
                    if v2:GetData("equip") then
                        v2:UnEquip(client, v2)
                    end
                end

                local function give(uniqueID)
                    local item = ItemBase.CreateItem(uniqueID)

                    if item then
                        item:Transfer(inventory:GetID())

                        return item
                    end
                end

                -- выдаем всем персонажам ключи от своих дверей
                give("keys"):SetData("faction", faction)

                if !Arbitrage.OffGiveItems() then
                    local factionData = Character.team:GetByID(faction)
                    if factionData then
                        for _, uniqueID in ipairs(factionData:GetItems() or {}) do
                            give(uniqueID)
                        end
                    end
                end
            end

            client:StripAmmo()
            client:StripWeapons()

            Arbitrage.player.SetupHealth(client)
            Arbitrage.player.SetupSpeed(client)
            Arbitrage.player.SetupWeapons(client)
            Arbitrage.player.SetupStatistics(client)
            Arbitrage.player.SetupViewOffset(client)

            client:SetNoDraw(false)
            client:SetNotSolid(false)
            client:DrawWorldModel(true)
            client:DrawShadow(true)
            client:SetNoTarget(false)
            client:SetupHands()

            client:SetNoCollideWithTeammates(false)

            timer.Simple(5, function()
                if !IsValid(client) then return end

                if Arbitrage.spawnList then
                    local vector, _ = table.Random(Arbitrage.spawnList)
                    client:SetPos(vector)
                end

                client:Freeze(false)
                client:GodDisable()
                client:SetEyeAngles(Angle(0, 0, 0))
                client:CheckStuck(1)
            end)
        end
    end
end

function Arbitrage:StopGame()
    Arbitrage.startgame = false
    SetNetVar("arb.StartGame", Arbitrage.startgame)

    Arbitrage.lawEnable = false
    SetNetVar("arb.StartLaw", Arbitrage.lawEnable)

    for k, v in pairs(player.GetAll()) do
        v:Freeze(false)
    end

    netstream.Start(nil, "arb.Intro", 3)
    timer.Simple(2, function()
        netstream.Start(nil, "arb.ClearLaw")

        for k, v in pairs(player.GetAll()) do
            local vector, _ = Arbitrage.lobbyList and table.Random(Arbitrage.lobbyList) or Vector(0, 0, 0)
            v:SetPos(vector)
        end
    end)
end

function Arbitrage:PlayerOneSecond(client)
    if !client:IsSpectate() then return end
    local spectate = client.spectateent

    if IsValid(spectate) then
        client:SetPos(spectate:GetPos())
    end

    client:SetNoDraw(true)
    client:SetNotSolid(true)
    client:DrawWorldModel(false)
    client:DrawShadow(false)
    client:GodEnable()
    client:SetNoTarget(true)
    client:StripWeapons()
    client:StripAmmo()
    client:Spectate(OBS_MODE_CHASE)
end

function Arbitrage:PlayerCanPickupWeapon(client, entity)
    if client:IsSpectate() then return false end

    if CurTime() - entity:GetCreationTime() < 0.5 then
        return true
    end

    if client:KeyDown(IN_USE) and client:GetEyeTraceNoCursor().Entity == entity then
        return true
    end

    return false
end

function Arbitrage.GM:PlayerSpawn(client, transiton)
    client:SetNoDraw(false)
    client:SetNotSolid(false)
    client:SetMoveType(MOVETYPE_WALK)

    player_manager.SetPlayerClass(client, "player_arbitrage")

    client:UnSpectate()
    client:SetupHands()

    player_manager.OnPlayerSpawn(client, transiton)
    player_manager.RunClass(client, "Spawn")

    local faction = Character.team:GetByID(client:Team())
    if faction then
        timer.Simple(0, function()
            Character.team:Join(client, client:Team())
        end)
    end

    hook.Call("PlayerSetModel", GAMEMODE, client)
end

function Arbitrage:PlayerSpray(client)
    return true
end

function CCGiveSWEP(client, command, arguments)
    if !IsValid(client) then return end
    if arguments[1] == nil then return end

    local swep = list.Get("Weapon")[arguments[1]]
    if swep == nil then return end

    if ((!swep.Spawnable and !client:IsAdmin()) or (swep.AdminOnly and !client:IsAdmin())) then
    	return
    end

    if (!gamemode.Call("PlayerGiveSWEP", client, arguments[1], swep)) then return end

    if (!client:HasWeapon(swep.ClassName)) then
    	client:Give(swep.ClassName)
    end

    client:SelectWeapon(swep.ClassName)
end
concommand.Add( "gm_giveswep", CCGiveSWEP)

concommand.Add("arb_join_notcharacter", function(client, command, arguments)
    if client:Team() != TEAM_NOTCHARACTER then
        Character.team:Join(client, TEAM_NOTCHARACTER, true)
    end
end)

concommand.Add("arb_returnnormalflashlight", function(client, command, arguments)
    if !client:IsAdmin() then return end

    hook.Remove("PlayerSwitchFlashlight", "TPF_SwitchFlashlightHook")
    hook.Remove("PlayerInitialSpawn", "TPF_InitServerDefaults")
    hook.Remove("PlayerPostThink", "TPF_Update")

    hook.Add("PlayerSwitchFlashlight", "arb.AllowFlashlight", function()
        return true
    end)

    for k, v in ipairs(player.GetAll()) do
        v:AllowFlashlight(true)
        v:Flashlight(false)

        if TPF_RemoveProjectedTexture then
    		TPF_RemoveProjectedTexture(v)
    	end
    end
end)

timer.Create("arb.CurTime", 1, 0, function()
    Arbitrage.CurTime = Arbitrage.CurTime or 0
    Arbitrage.CurTime = Arbitrage.CurTime + 17

    netstream.Start(nil, "arb.ReturnCurTime", Arbitrage.CurTime)
end)

timer.Create("arb.UpdateTheme", 10, 0, function()
    local theme = ScriptMusic:GetTheme()
    if theme != "none" and theme != "freetime_day" and theme != "freetime_night" then return end

    local isDay = Arbitrage.IsDay()

    if isDay and theme != "freetime_day" then
        ScriptMusic:ChangeTheme("freetime_day", true)
    elseif !isDay and theme != "freetime_night" then
        ScriptMusic:ChangeTheme("freetime_night", true)
    end
end)

netstream.Hook("arb.HideState", function(client, state)
    local bHide = state and true or false

    client:SetNetVar("hideStatus", bHide)
    Arbitrage.commands.Notify(client, "Вы " .. (bHide and "скрыли" or "раскрыли") .. " свое состояние!")
end)

netstream.Hook("arb.SelectCharacter", function(client, data)
    if !data then return end
    if GetNetVar("arb.StartGame") and data != TEAM_SPECTATE then return end

    local faction = Character.team:GetByID(data)
    if faction and istable(faction) and client:Team() != data then
        if faction.admin and !client:IsAdmin() then return end

        local count = 0
        for k, v in ipairs(player.GetAll()) do
            local vFaction = v:Team()

            if vFaction == data then
                count = count + 1
            end
        end

        Character.team:Join(client, data, true)

        for k, v in pairs(Arbitrage.statistics.list) do
            Arbitrage.statistics.Set(client, v.data, 100)
        end
    end
end)

local function ChangeTokoType(client, idx)
    timer.Create(idx, math.random(600, 3600), 1, function()
        if !IsValid(client) then return timer.Remove(idx) end
        if !client:IsToko() then return timer.Remove(idx) end

        local isGenocide = client:IsTokoGenocide()
        local model = isGenocide and Arbitrage.TokoModel or Arbitrage.TokoGenocideModel
        local text = isGenocide and "Токо Фукава" or "Геноцид Сё"

        Arbitrage.commands.Notify(client, "Вы сменили личность на \"" .. text .. "\".")
        Arbitrage.commands.RunCommand(client, "me", {"сменила личность на \"" .. text .. "\"."})
        client:SetModel(model)

        ChangeTokoType(client, idx)
    end)
end

netstream.Hook("arb.TokoSneezing", function(client)
    if !client:IsToko() then return end

    local idx = "TokoTimer_" .. client:EntIndex()
    if timer.Exists(idx) then
        timer.Remove(idx)

        return Arbitrage.commands.Notify(client, "Вы выключили автоматическую смену личности.")
    end

    ChangeTokoType(client, idx)

    Arbitrage.commands.Notify(client, "Вы включили автоматическую смену личности.")
end)