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

        local character = Character.team:GetByID(client:Team())
        if character then
            if character:GetUniqueID() == "nagito" then
                rand = client.nagitoRandom
                client.nagitoRandom = !client.nagitoRandom
            elseif character:GetUniqueID() == "makoto" and !rand then
                if math.random(1, 5) == 5 then -- 20% на то, что повезет
                    rand = true
                end
            end
        end

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

        SetNetVar("arb.Time", value)
        Arbitrage.commands.Notify(client, "Вы успешно изменили время на: " .. time)
    end
})

Arbitrage.commands.Add("roll", {
    arguments = {},
    OnAction = function(client)
        if client:IsSpectate() then return end
        local rand = math.random(1, 100)

        local character = Character.team:GetByID(client:Team())
        if character then
            if character:GetUniqueID() == "nagito" then
                rand = client.nagitoRandom and 100 or 0
                client.nagitoRandom = !client.nagitoRandom
            elseif character:GetUniqueID() == "makoto" and rand < 50 then
                if math.random(1, 5) == 5 then -- 20% на то, что повезет
                    rand = 100
                end
            end
        end

        Arbitrage.chat.SendCommand("roll", client, "получил(а) шанс " .. rand .. " из 100.")
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

Arbitrage.commands.Add("exitaction", {
    arguments = {},
    OnAction = function(client)
        local bThirdPerson = select(3, client:GetAction())
        if !bThirdPerson then return Arbitrage.commands.Notify(client, "Вы не находитесь в анимации!") end

        client:ExitAction(true)
    end
})

Arbitrage.commands.Add("action", {
    arguments = {
        [1] = {
            name = "ID Анимации",
            type = "string",
            important = true
        }
    },
    OnAction = function(client, uniqueID)
        local bThirdPerson = select(3, client:GetAction())
        if bThirdPerson then return Arbitrage.commands.Notify(client, "Вы уже находитесь в анимации!") end

        local bOnGround = client:OnGround()
        if !bOnGround then return Arbitrage.commands.Notify(client, "Вы должны находиться на земле, чтобы активировать анимацию!") end

        local bLawEnable = Arbitrage.lawEnable
        if bLawEnable then return Arbitrage.commands.Notify(client, "Нельзя запустить анимацию во время суда") end

        client:StartAction(uniqueID)
    end
})

Arbitrage.commands.Add("sitting", {
    arguments = {
        [1] = {
            name = "ID Анимации",
            type = "string",
            important = true
        }
    },
    OnAction = function(client, id)
        local bSitting = client.GetSitting and client:GetSitting()
        if bSitting then return Arbitrage.commands.Notify(client, "Встаньте, чтобы изменить себе анимацию сидения!") end

        id = tonumber(id)

        if id then
            if id <= 0 then
                client:SetNetVar("sitting", nil)
            else
                if Emotes.SittingList[id] then
                    client:SetNetVar("sitting", id)
                end
            end
        end
    end
})

Arbitrage.commands.Add("mood", {
    arguments = {
        [1] = {
            name = "ID Анимации",
            type = "string",
            important = true
        }
    },
    OnAction = function(client, id)
        id = tonumber(id)

        if id then
            local name = "Стандартная"

            if id <= 0 then
                client:SetNetVar("mood", nil)
            else
                local data = Emotes.MoodList[id]
                if data then
                    client:SetNetVar("mood", id)

                    name = data.name
                end
            end

            Arbitrage.commands.Notify(client, "Вы успешно изменили себе настроение на: " .. name .. "(" .. id .. ")!")
        end
    end
})

Arbitrage.commands.Add("lookaround", {
    arguments = {},
    OnAction = function(client)
        local bThirdPerson = select(3, client:GetAction())
        if bThirdPerson then return Arbitrage.commands.Notify(client, "Вы находитесь в анимации!") end

        local bSitting = client.GetSitting and client:GetSitting()
        if bSitting then return Arbitrage.commands.Notify(client, "Встаньте чтобы осмотреть себя!") end

        client:SetNetVar("action", {
            -1,
            -1,
            true,
            client:GetAngles()
        })
    end
})

Arbitrage.commands.Add("settimespeed", {
    arguments = {
        [1] = {
            name = "Скорость времени",
            type = "string",
            important = true
        }
    },
    OnAction = function(client, speed)
        if !client:IsAdmin() then return end

        speed = tonumber(speed)
        Arbitrage.TickTime = speed

        Arbitrage.commands.Notify(client, "Вы изменили скорость времени на: " .. speed)
    end
})

function Arbitrage:PlayerShouldTaunt(client, act)
    if !client:Alive() then return false end
    if !client:IsPlaying() then return false end
    if client:GetNetVar("inbed") then return false end
    if client.GetSitting and client:GetSitting() then return false end

    return true
end

local emoteList = {
    "споткнулся",
    "сильно чихнул, отклонив голову вперёд",
    "заметил на полу монетку и, наклонившись, подбирает",
    "заметил развязанные шнурки и, наклонившись, завязывает",
    "заметил паука на полу и, испугавшись, отпрыгнул в сторону"
}
function Arbitrage:ScalePlayerDamage(client, hitgroup, dmginfo)
    if !IsValid(client) then return end

    local character = Character.team:GetByID(client:Team())
    if !character then return end

    local uniqueID = character:GetUniqueID()
    if uniqueID == "makoto" then
        if math.random(1, 5) == 5 then -- 20% на то, что повезет
            dmginfo:ScaleDamage(0)
            Arbitrage.chat.SendCommand("me", client, emoteList[math.random(1, #emoteList)])
        end
    end
end

function Arbitrage:KeyPress(client, key)
    client.spectateplayer = client.spectateplayer or 0
    if client:IsSpectate() and (key == IN_ATTACK or key == IN_ATTACK2) then
        local first_player = 0
        local last_player = 0
        local alive_players = {}

        for k, v in ipairs(player.GetAll()) do
            if Arbitrage.players[v:SteamID()] and v:Alive() and !v:IsHost() then
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

function Arbitrage:GetFallDamage(client, speed)
    return (speed - 580) * (100 / 444)
end

local function initPlayer(client)
    client:StripWeapons()
    client:StripAmmo()
    client:Freeze(false)
    client:GodDisable()
    client:SyncVars()

    Character.team:Join(client, TEAM_NOTCHARACTER, true)
    client:SendLua([[RunConsoleCommand("stopsound")]])
    client:SetNetVar("connectedTime", CurTime())

    hook.Run("PlayerInitial", client)

    local id = "Arbitrage:StatisticsThink_" .. client:EntIndex()
    timer.Create(id, 2, 0, function()
        if !IsValid(client) then return timer.Remove(id) end

        if !client:Alive() then return end
        if !client:IsPlaying() then return end

        if !Arbitrage.IsStartGame() then return end
        if Arbitrage.lawEnable then return end

        Arbitrage.statistics.PlayerPostThink(client)
    end)
end

function Arbitrage:PlayerInitialSpawn(client)
    local indx = client:EntIndex()

    local id = "initClient_" .. indx
    timer.Create(id, FrameTime(), 0, function()
        if IsValid(client) then
            timer.Remove(id)

            initPlayer(client)
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
    hook.Run("ChatAddText", client, data)

    if data:sub(1, 1) == "!" or data:sub(1, 1) == "~" or data:sub(1, 1) == "@" then
        local message = utf8.sub(data, 2, utf8.len(data))
        local extra = Arbitrage:ExtractArgs(message)

        if data:sub(1, 1) == "@" then
            table.insert(extra, 1, client:IsAdmin() and "a" or "help")
        end

        local command = "sg"

        if data:sub(1, 1) == "~" then
            command = "sgs"
        end

        netstream.Start(client, "arb.SendCommand", command, extra)
        return ""
    end

    if Arbitrage.commands then
        local command = data:sub(1, 2)

        if command == "//" or command == "[[" or command == "./" then
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




local function syncvars()
    Arbitrage.startgame = true
    SetNetVar("arb.StartGame", Arbitrage.startgame)
    for k, v in pairs(player.GetAll()) do
        v:SyncVars()
    end
end

local function changetheme()
    ScriptMusic:ChangeTheme("startgame", true)

    local uniqueID = "arb.StartGameThemeClear"
    timer.Remove(uniqueID)
    timer.Create(uniqueID, 120, 1, function()
        timer.Remove(uniqueID)

        ScriptMusic:ChangeTheme("none", true)
    end)
end

local function getclients()
    local data = {}

    for k, v in pairs(Arbitrage.players) do
        local client = v.client or NULL

        if IsValid(client) and client:Alive() and client:IsPlaying() then
            local storedInfo = Arbitrage.players[client:SteamID()]

            if storedInfo then
                data[#data + 1] = v
            end
        end
    end

    return data
end

local function showtailent()
    for k, v in ipairs(getclients()) do
        local client = v.client

        netstream.Start(client, "arb.TailentScreen")
    end
end

local function fixfaction()
    for k, v in ipairs(getclients()) do
        local client = v.client
        local storedInfo = Arbitrage.players[client:SteamID()]

        if !IsPlaying(storedInfo.faction) then
            local faction = client:Team()

            storedInfo.faction = faction
        end
    end
end

local function setstats()
    for k, v in ipairs(getclients()) do
        local client = v.client

        client:ExitAction()
        client:ExitVehicle()
        client:SetNWBool("SitGroundSitting", false)
        client:Freeze(true)

        client:SendLua([[RunConsoleCommand("stopsound")]])
        client:SendLua([[RunConsoleCommand("r_cleardecals")]])

        client:StripAmmo()
        client:StripWeapons()

        Arbitrage.player.SetupHealth(client)
        Arbitrage.player.SetupSpeed(client)
        Arbitrage.player.SetupWeapons(client)
        Arbitrage.player.SetupStatistics(client)
        Arbitrage.player.SetupViewOffset(client)

        client:SetLocalVar("stamina", 100)

        client:SetNoDraw(false)
        client:SetNotSolid(false)
        client:DrawWorldModel(true)
        client:DrawShadow(true)
        client:SetNoTarget(false)
        client:SetupHands()

        client:SetNoCollideWithTeammates(false)
    end
end

local function setinventory()
    for k, v in ipairs(getclients()) do
        local client = v.client
        local faction = client:Team()

        local inventory = client:GetInventory()
        if !inventory then continue end

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

        -- выдаем всем персонажам монопады
        if !Arbitrage.OffGiveMonopads() then
            local item = give("monopad")
            local monopad = MonoPad:New(item:GetID())
            monopad:SetOwner(client)

            item.stored = monopad

            local object = item.stored
            object:Sync()

            item:Equip(client, item, 1)
        end

        if !Arbitrage.OffGiveItems() then
            local factionData = Character.team:GetByID(faction)
            if !factionData then continue end

            for _, uniqueID in ipairs(factionData:GetItems() or {}) do
                give(uniqueID)
            end
        end
    end
end

local function teleport()
    for k, v in ipairs(getclients()) do
        local client = v.client

        if Arbitrage.spawnList then
            local place = client:LawPlace()
            local point, _ = Arbitrage.spawnList and Arbitrage.spawnList[place] or table.Random(Arbitrage.spawnList)

            if point then
                client:SetPos(point)
            end
        end

        client:Freeze(false)
        client:GodDisable()
        client:SetEyeAngles(Angle(0, 0, 0))
        client:CheckStuck(1, function()
            client:CheckStuck(0.2, function()
                client:CheckStuck(0.2)
            end)
        end)
    end
end

function Arbitrage:StartGame()
    netstream.Start(nil, "Character:Caching")
    SetNetVar("arb.Time", 28800)

    syncvars()
    changetheme()

    netstream.Start(nil, "arb.Blackout", 6.5)

    showtailent()
    fixfaction()
    setstats()
    setinventory()

    timer.Simple(5, function()
        teleport()
    end)
end

function Arbitrage:StopGame()
    Arbitrage.startgame = false
    SetNetVar("arb.StartGame", Arbitrage.startgame)

    Arbitrage.lawEnable = false
    SetNetVar("arb.StartLaw", Arbitrage.lawEnable)

    netstream.Start(nil, "arb.Blackout", 1.5)

    timer.Simple(2, function()
        netstream.Start(nil, "arb.ClearLaw")

        for k, v in pairs(player.GetAll()) do
            local vector, _ = Arbitrage.lobbyList and table.Random(Arbitrage.lobbyList) or Vector(0, 0, 0)
            v:SetPos(vector)
        end
    end)

    for k, v in ipairs(player.GetAll()) do
        v:Freeze(false)
        v:SetLocalVar("stamina", 100)
        v:SetHealth(999999999)
        Arbitrage.player.SetupStatistics(v)

        local inventory = v:GetInventory()

        if inventory then
            local items = inventory:GetItems()

            -- Анэквипаем все предметы
            for k2, v2 in pairs(items) do
                if v2:GetData("equip") then
                    v2:UnEquip(v, v2)
                end
            end

            for k2, v2 in ipairs(items) do
                v2:Remove()
            end
        end
    end
end

timer.Create("Arbitrage:RegenerationHealth", 60, 0, function()
    for k, v in ipairs(player.GetAll()) do
        if !v:IsPlaying() then continue end

        local health = v:Health()
        if health >= 100 or health <= 0 then continue end

        v:SetHealth(math.Clamp(health + 1, 0, 100))
    end
end)

timer.Create("Arbitrage:UpdateSpectate", 0.5, 0, function()
    for k, v in ipairs(player.GetAll()) do
        if !v:IsSpectate() then return end

        local spectate = v.spectateent

        if IsValid(spectate) then
            v:SetPos(spectate:GetPos())
        end

        v:SetNoDraw(true)
        v:SetNotSolid(true)
        v:DrawWorldModel(false)
        v:DrawShadow(false)
        v:GodEnable()
        v:SetNoTarget(true)
        v:StripWeapons()
        v:StripAmmo()
        v:Spectate(OBS_MODE_CHASE)
    end
end)

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

Arbitrage.TickTime = 17
timer.Create("arb.CurTime", 1, 0, function()
    local data = Arbitrage.ReturnTime()
    SetNetVar("arb.Time", data + Arbitrage.TickTime)
end)

local dayTheme = "freetime_day"
local nightTheme = "freetime_night"
timer.Create("arb.UpdateTheme", 10, 0, function()
    if !Arbitrage.IsStartGame() then return end

    local theme = ScriptMusic:GetTheme()
    if theme == "none" or theme == dayTheme or theme == nightTheme then
        local isDay = Arbitrage.IsDay()

        if isDay then
            if theme != dayTheme then
                ScriptMusic:ChangeTheme(dayTheme, true)
            end
        else
            if theme != nightTheme then
                ScriptMusic:ChangeTheme(nightTheme, true)
            end
        end
    end
end)

netstream.Hook("arb.HideState", function(client, state)
    local bHide = state and true or false

    client:SetNetVar("hideStatus", bHide)
    Arbitrage.commands.Notify(client, "Вы " .. (bHide and "скрыли" or "раскрыли") .. " свое состояние!")
end)

netstream.Hook("arb.HideName", function(client)
    local state = client:GetNetVar("hideName", false)
    local bHide = !state

    client:SetNetVar("hideName", bHide)
    Arbitrage.commands.Notify(client, "Вы " .. (bHide and "скрыли" or "раскрыли") .. " свое имя!")
end)

netstream.Hook("arb.EditDescription", function(client, data)
    data = tostring(data)
    if !data then return end

    if data == "" or data == " " or data == "  " then
        data = nil
    else
        if utf8.len(data) > 200 then
            data = data:utf8sub(1, 197) .. "..."
        end
    end

    client:SetNetVar("description", data)
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

netstream.Hook("arb.Sleeping", function(client)
    local character = Character.team:GetByID(client:Team())
    if !character then return end

    local uniqueID = character:GetUniqueID()
    if uniqueID == "chiaki" or uniqueID == "himiko" then
        local isSleeping = client:GetLocalVar("sleeping", false)

        client:SetLocalVar("sleeping", !isSleeping)
        client:ChatNotify(isSleeping and "Вы начали просыпаться!" or "Вы уснули!")

        local hookID = "arb.Sleeping_" .. client:SteamID()
        local function clear()
            hook.Remove("StartCommand", hookID)
            hook.Remove("PostPlayerDeath", hookID)

            if IsValid(client) then
                client:SetLocalVar("sleeping", false)
            end
        end

        local function create()
            local eyeAng = client:GetAngles()

            hook.Add("StartCommand", hookID, function(target, ucmd)
                if target != client then return end
                if !IsValid(client) then return clear() end

                ucmd:RemoveKey(IN_JUMP)
                ucmd:RemoveKey(IN_DUCK)
                ucmd:RemoveKey(IN_ATTACK)
                ucmd:RemoveKey(IN_USE)

                ucmd:RemoveKey(IN_LEFT)
                ucmd:RemoveKey(IN_RIGHT)

                ucmd:ClearMovement()

                ucmd:SetForwardMove(0)
                ucmd:SetUpMove(0)
                ucmd:SetSideMove(0)

                ucmd:SetMouseX(0)
                ucmd:SetMouseY(0)
                ucmd:SetMouseWheel(0)

                client:SetEyeAngles(eyeAng)
            end)

            hook.Add("PostPlayerDeath", hookID, function(target)
                if target != client then return end
                if !IsValid(client) then return clear() end

                clear()
            end)
        end

        if !isSleeping then
            create()
        else
            clear()
        end
    end
end)