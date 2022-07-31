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

Arbitrage.HookRun("Initialize")
Arbitrage.actionlist = {}

function Arbitrage.AddAction(entity, name, data)
    Arbitrage.actionlist = Arbitrage.actionlist or {}
    Arbitrage.actionlist[entity] = Arbitrage.actionlist[entity] or {}

    Arbitrage.actionlist[entity][name] = data
end

do
    Arbitrage.evidence.AddEnt("arb_fridge", {
        name = "Холодильник",
        desc = "Обычный холодильник, внутри находится огромное количество еды.",
        up = 55,
        right = 0,
        forward = 0
    })

    Arbitrage.evidence.AddEnt("arb_wardrobe", {
        name = "Гардероб",
        desc = "Шкаф с одеждой, можно попробовать сменить свою одежду.",
        up = 0,
        right = 0,
        forward = 0
    })

    Arbitrage.evidence.AddEnt("arb_player", {
        name = "Спящий персонаж",
        desc = "Данный персонаж вышел с сервера.",
        up = 10,
        right = 5,
        forward = 0
    })
end

do
    Arbitrage.evidence.AddMaterial("test")
end

do
    Arbitrage.statistics.Add("hunger", {
        data = "Hunger",
        time = function(client)
            local faction = Arbitrage.teams.Get(client:Team())
            return faction and (faction.hungerSpeed and faction.hungerSpeed) or 25
        end,
        action = function(client, info)
            local amount = Arbitrage.statistics.Get(client, info.data)
            if !amount then return end

            if Arbitrage.OnDeadLowStatictic() and amount <= 10 then
                client:TakeDamage(1)

                if client:Health() <= 1 then
                    client:Kill()
                end
            else
                if amount <= 10 and client:Health() > 10 then
                    client:TakeDamage(1)
                end
            end
        end,
    })

    Arbitrage.statistics.Add("thirst", {
        data = "Thirst",
        time = function(client)
            local faction = Arbitrage.teams.Get(client:Team())
            return faction and (faction.thirstSpeed and faction.thirstSpeed) or 25
        end,
        action = function(client, info)
            local amount = Arbitrage.statistics.Get(client, info.data)
            if !amount then return end

            if Arbitrage.OnDeadLowStatictic() and amount <= 10 then
                client:TakeDamage(1)

                if client:Health() <= 1 then
                    client:Kill()
                end
            else
                if amount <= 10 and client:Health() > 10 then
                    client:TakeDamage(1)
                end
            end
        end,
    })

    Arbitrage.statistics.Add("sleep", {
        data = "Sleep",
        time = function(client)
            local faction = Arbitrage.teams.Get(client:Team())
            return faction and (faction.sleepSpeed and faction.sleepSpeed) or 33
        end
    })
end

do
    local workshop = asterionlib.workshop

    hook.Add("asterionlib.workshop:Initialize", "asterionlib.workshop", function()
        -- MAIN
        workshop:Add("2715755590") -- Danganronpa - Main Content
        workshop:Add("2786490267") -- Danganronpa - Main Content #2
        workshop:Add("2717853308") -- Danganronpa - Models Content #1
        workshop:Add("2723789180") -- Danganronpa - Models Content #3
        workshop:Add("2780751458") -- Danganronpa - Models Content #2

        -- OTHER
        workshop:Add("246756300") -- Stream Radio
        -- (DELETED) workshop:Add("415143062") -- TFA Base [ Reduxed ]
        workshop:Add("2840031720") -- TFA Base
        workshop:Add("2463165156") -- [OPTIMIZED] vFire - Dynamic Fire
        workshop:Add("108024198") -- Food and Household items
        workshop:Add("131759821") -- VJ Base
        workshop:Add("1920810365") -- Facial Emote Mod
        workshop:Add("1784911999") -- LED screens
        workshop:Add("1161268544") -- Pink Blood

        -- WEAPONS
        -- (DELETED) workshop:Add("582366370") -- [TFA] No More Room in Hell Melee SWEPs
        -- (DELETED) workshop:Add("582493650") -- [TFA] No More Room in Hell Firearm SWEPs
        workshop:Add("2842765511") -- nmrih reupload
        workshop:Add("244540803") -- Customizable Flashlight
        workshop:Add("921195220") -- TFA CS:S Weapons
        workshop:Add("1414153810") -- [TTT] Night vision
        workshop:Add("1292873521") -- Amnesia Lantern Rework
        workshop:Add("244540803") -- Customizable Flashlight
        workshop:Add("104607228") -- Fire Extinguisher

        -- MAPS
        workshop:Add("1892549430") -- drp_hopespeak (WIP) Danganronpa map
        workshop:Add("1892565701") -- drp_hopespeak - Content

        -- MODELS
        workshop:Add("1246554779") -- Roleplay Props Extended
        workshop:Add("958532452") -- Interior Props Pack.
        workshop:Add("263266938") -- Developer Style Props!
        workshop:Add("1990021079") -- Some school props
        workshop:Add("213181442") -- Mobile Computing Pack
        workshop:Add("104477476") -- Misc Props Pack
        workshop:Add("2546157752") -- Stockplus - More Construct Props
    end)
end

function Arbitrage:GetStored()
    local data = {
        -- Позиции начальной камеры
        camPos = {
            drp_hopespeak = {Vector(-557.674011, -2769.518799, -690.412659), Angle(36.070911, 36.665367, 0.000000)},
        },
        -- Где должна находится камера в конце
        camPosEnd = {
            drp_hopespeak = Vector(-201.094284, -2496.078613, -887.968750)
        },
        -- Где должен сидеть Монокума
        monokumPlace = {
            drp_hopespeak = {Vector(-528.077271, -2354.913086, -822.366394), Angle(-1.174964, -27.304247, 0.093104)}
        },
        -- Камера которая смотрит на МоноКуму
        monokumCam = {
            drp_hopespeak = Vector(-393.274109, -2414.661377, -842.831726)
        },
        -- Список мест
        placesList = {
            drp_hopespeak = {
                [1] = {Vector(-198.881119, -2401.409668, -887.968750), Angle(-1.486018, -90.389771, 0.000000)},
                [2] = {Vector(-238.035492, -2404.347412, -887.968750), Angle(-0.034027, -68.741699, 0.000000)},
                [3] = {Vector(-277.119537, -2427.784424, -887.968750), Angle(-0.902689, -44.751057, -0.039650)},
                [4] = {Vector(-299.753387, -2465.804443, -887.968750), Angle(-1.282923, -21.863527, -0.045863)},
                [5] = {Vector(-302.587067, -2503.919434, -887.968750), Angle(-0.980000, -0.037211, -0.069704)},
                [6] = {Vector(-299.616333, -2542.128662, -887.968750), Angle(-1.189690, 21.964031, -0.086604)},
                [7] = {Vector(-278.177643, -2579.131348, -887.968750), Angle(-0.513964, 45.297821, 0.025415)},
                [8] = {Vector(-238.179596, -2603.757568, -887.968750), Angle(-0.535176, 68.749794, -0.047656)},
                [9] = {Vector(-200.064972, -2606.583984, -887.968750), Angle(-0.623258, 90.194252, 0.000393)},
                [10] = {Vector(-161.853333, -2603.610840, -887.968750), Angle(-0.782074, 111.488228, 0.098710)},
                [11] = {Vector(-122.848984, -2580.183594, -887.968750), Angle(-0.238875, 134.212341, 0.015548)},
                [12] = {Vector(-100.236328, -2542.160889, -887.968750), Angle(1.261051, 157.526886, 0.095551)},
                [13] = {Vector(-97.406654, -2504.047119, -887.968750), Angle(-0.472908, 179.155533, 0.011351)},
                [14] = {Vector(-100.362938, -2465.932617, -887.968750), Angle(-0.172372, -158.530289, -0.097806)},
                [15] = {Vector(-123.768608, -2426.896484, -887.968750), Angle(-0.933975, -135.699966, 0.012694)},
                [16] = {Vector(-161.782700, -2404.253418, -887.968750), Angle(0.147995, -112.951431, -0.043005)}
            }
        },
        spawnList = {
            drp_hopespeak = {
                Vector(-1121, -3375, -48), Vector(-1194, -3375, -48), Vector(-1276, -3374, -48), Vector(-1377, -3374, -48),
                Vector(-1478, -3374, -48), Vector(-1603, -3374, -48), Vector(-1715, -3374, -48), Vector(-1700, -3263, -48),
                Vector(-1549, -3263, -48), Vector(-1458, -3263, -48), Vector(-1355, -3263, -48), Vector(-1221, -3263, -48),
                Vector(-1108, -3263, -48), Vector(-1106, -3156, -48), Vector(-1212, -3155, -48), Vector(-1321, -3155, -48),
                Vector(-1447, -3155, -48), Vector(-1542, -3154, -48), Vector(-1632, -3154, -48), Vector(-1714, -3154, -48),
                Vector(-1714, -3076, -48), Vector(-1612, -3075, -48), Vector(-1513, -3075, -48), Vector(-1418, -3076, -48),
                Vector(-1301, -3076, -48), Vector(-1238, -3076, -48), Vector(-1144, -3076, -48), Vector(-1083, -3077, -48)
            }
        },
        lobbyList = {
            drp_hopespeak = {
                Vector(-4134, 2138, 77), Vector(-4592, 2513, 77),
                Vector(-4140, 3155, 77), Vector(-4890, 2401, 77),
                Vector(-4327, 2732, 77), Vector(-4919, 3159, 77),
                Vector(-4833, 2225, 77), Vector(-4414, 2636, 77)
            }
        }
    }

    return data
end

function Arbitrage:GetInfo()
    local data = {}

    -- копируем информацию из основной базы позиций
    for k, v in pairs(Arbitrage:GetStored()) do
        data[k] = v[game.GetMap()]
    end

    -- заменяем информацию из эдитора
    for k, v in pairs(Editor:GetStored()) do
        data[k] = v
    end

    return data
end

function Arbitrage:ReplaceVariables()
    local data = Arbitrage:GetInfo()

    -- записываем всю инфу в переменные, ибо с ними проще работать
    for k, v in pairs(data) do
        Arbitrage[k] = v
    end

    -- устанавливаем монокуме 0 место
    if Arbitrage.placesList and data.monokumPlace then
        Arbitrage.placesList[0] = data.monokumPlace
    end
end
Arbitrage:ReplaceVariables()

function Arbitrage.ReturnTime()
    return Arbitrage.CurTime or 0 -- * 17
end

-- 08:00 - 22:00 - дневная
-- 8:00 — 104400
-- 22:00 — 154800
function Arbitrage.IsDay()
    local arb_time = Arbitrage.ReturnTime()

    local hours = math.floor(math.fmod(arb_time, 86400) / 3600)
    local minutes = math.floor(math.fmod(arb_time, 3600) / 60)
    local seconds = math.floor(math.fmod(arb_time, 60))

    local h = string.format("%2d", hours)
    local m = string.format("%2d", minutes)
    local s = string.format("%2d", seconds)

    local time = os.time({day = 2, month = 1, wday = 1, yday = 1, year = 1970,
        hour = h,
        min = m,
        sec = s,
    })

    if time >= 104400 and time <= 154800 then
        return true
    end

    return false
end

-- 22:00 - 08:00 - ночная
function Arbitrage.IsNight()
    return !Arbitrage.IsDay()
end

function Arbitrage.IsStartGame()
    return GetNetVar("arb.StartGame", false)
end

function Arbitrage.OffOOC()
    return GetNetVar("arb.OffOOC", false)
end

function Arbitrage.OffFallStatictic()
    return GetNetVar("arb.OffFallStatictic", false)
end

function Arbitrage.OnDeadLowStatictic()
    return GetNetVar("arb.OnDeadLowStatictic", false)
end

function Arbitrage.OffCorpseEffect()
    return GetNetVar("arb.OffCorpseEffect", false)
end

function Arbitrage.ReturnEntity(client)
    local data = {}
    data.start = client:GetShootPos()
    data.endpos = data.start + client:GetAimVector() * 84
    data.filter = {client}

    local trace = util.TraceLine(data)
    local entity = trace.Entity

    if IsValid(entity) then
        return entity
    end
end

function Arbitrage:StartCommand(client, ucmd)
    local stamina = client:GetNetVar("stm", 100)

    if client:IsPlaying() and !client:IsNocliping() then
        local jump = ucmd:KeyDown(IN_JUMP)
        local speed = ucmd:KeyDown(IN_SPEED)

        if (jump or speed) and stamina <= 10 then
            ucmd:RemoveKey(IN_JUMP)
            ucmd:RemoveKey(IN_SPEED)
        end
    end
end

function Arbitrage.StringMatches(a, b)
    if !a then return end
    if !b then return end

    local a2, b2 = a:lower(), b:lower()

    local chars = {
        [1] = a,  [2] = b,
        [3] = a2, [4] = b2
    }

    for k, v in pairs(chars) do
        local c = utf8.len(v)
        local d = utf8.sub(v, c, c)

        if d == " " then
            chars[k] = utf8.sub(v, 1, c - 1)
        end
    end

    if chars[1] == chars[2] then return true end
    if chars[3] == chars[4] then return true end

    if chars[1]:find(chars[2]) then return true end
    if chars[3]:find(chars[4]) then return true end

    return false
end

Arbitrage.isoTable = {
    {
        syntax = "Год",
        allias = {["y"] = true, ["year"] = true, ["years"] = true},
        func = function(currect, data)
            return currect + tonumber(data) * ((86400 * 30) * 12)
        end
    },
    {
        syntax = "Месяц",
        allias = {["mon"] = true, ["month"] = true, ["months"] = true},
        func = function(currect, data)
            return currect + tonumber(data) * (86400 * 30)
        end
    },
    {
        syntax = "День",
        allias = {["d"] = true, ["day"] = true, ["days"] = true},
        func = function(currect, data)
            return currect + tonumber(data) * 86400
        end
    },
    {
        syntax = "Час",
        allias = {["h"] = true, ["hour"] = true, ["hours"] = true},
        func = function(currect, data)
            return currect + tonumber(data) * 3600
        end
    },
    {
        syntax = "Минута",
        allias = {["m"] = true, ["min"] = true, ["minut"] = true, ["minute"] = true, ["minutes"] = true, ["mi"] = true},
        func = function(currect, data)
            return currect + tonumber(data) * 60
        end
    },
    {
        syntax = "Секунда",
        allias = {["s"] = true, ["sec"] = true, ["second"] = true, ["seconds"] = true, ["se"] = true},
        func = function(currect, data)
            return currect + tonumber(data)
        end
    }
}

function Arbitrage.IsoDurationToSeconds(iso)
    if !iso then return end
    if tonumber(iso) then return iso end

    local duration = 0
    local oldiso = iso

    for i = 1, 9 do
        iso = iso:gsub(i, "0")
    end

    local explode = string.Explode("0", iso)
    for k, v in pairs(explode) do
        if v == "" or v == " " then
            explode[k] = nil
        end
    end

    local a = {}
    for i = 1, string.len(oldiso) do
        a[#a + 1] = string.sub(oldiso, i, i)
    end

    local numberTable = {}
    local str = ""
    for k, v in SortedPairs(a) do
        if tonumber(v) then
            str = str .. v
        elseif !tonumber(v) and str ~= "" then
            numberTable[#numberTable + 1] = str
            str = ""
        end
    end

    if #numberTable <= 0 then return end

    local tableData = {}
    local num = 1
    for k, v in SortedPairs(explode) do
        local _a, _b = string.find(oldiso, v)
        local sizeNum = string.len(numberTable[num])
        local sizeStr = string.len(string.sub(oldiso, _a, _b))

        local c1 = string.sub(oldiso, _a - sizeNum, _b - sizeStr)
        local c2 = string.sub(oldiso, _a, _b)

        tableData[#tableData + 1] = {
            c1,
            c2
        }

        num = num + 1
    end

    for k, v in SortedPairs(tableData) do
        local _num = v[1]
        local _str = v[2]

        local find = false
        for k2, v2 in pairs(Arbitrage.isoTable) do
            if v2.allias[_str] then
                find = k2
            end
        end

        if !find then return nil end

        local data = Arbitrage.isoTable[find].func(duration, _num)
        duration = data
    end

    return duration
end

function Arbitrage.FindPlayer(identifier, patterns)
    if (string.find(identifier, "STEAM_(%d+):(%d+):(%d+)")) then
        return player.GetBySteamID(identifier)
    end

    if (!patterns) then
        identifier = string.PatternSafe(identifier)
    end

    for _, v in ipairs(player.GetAll()) do
        if (Arbitrage.StringMatches(v:Name(), identifier)) then
            return v
        end
    end
end

do
    local playerMeta = FindMetaTable("Player")

    function playerMeta:FakeName()
        local name = self:GetNetVar("fakename")
        return (name ~= "" and name ~= " ") and name or nil
    end

    playerMeta.GetFakeName = playerMeta.FakeName

    playerMeta.SteamName = playerMeta.SteamName or playerMeta.Name
    function playerMeta:GetName()
        if !IsValid(self) then return "" end -- Tried to use a NULL entity! (WTF??)

        local fakeName = self:FakeName()
        if fakeName then
            return fakeName
        end

        if self:IsTokoGenocide() then
        	return "Геноцид Сё"
        end

        local faction = self:Team()
        local data = Arbitrage.teams.Get(faction)

        if faction and self:IsPlaying() and data then
            return data.name or self:SteamName()
        end

        return self:SteamName()
    end

    playerMeta.Nick = playerMeta.GetName
    playerMeta.Name = playerMeta.GetName

    function IsHost(steamid)
        local data = GetNetVar("hostList", {})

        return data[steamid]
    end

    function playerMeta:IsHost()
        return IsHost(self:SteamID())
    end

    function playerMeta:IsSpectate()
        local faction = self:Team()

        return faction == TEAM_SPECTATE
    end

    Arbitrage.TokoGenocideModel = "models/player/dewobedil/danganronpa/toko_fukawa/genocide_p.mdl"
    function playerMeta:IsTokoGenocide()
    	local model = self:GetModel()

    	return model == Arbitrage.TokoGenocideModel
    end

    Arbitrage.TokoModel = "models/player/dewobedil/danganronpa/toko_fukawa/default_p.mdl"
    function playerMeta:IsToko()
    	local model = self:GetModel()

    	return model == Arbitrage.TokoModel or self:IsTokoGenocide()
    end

    function playerMeta:IsPlaying()
        local faction = self:Team()

        return faction != 1001 and faction != TEAM_NOTCHARACTER and faction != TEAM_SPECTATE and faction != TEAM_ADMIN
    end

    function playerMeta:IsNotCharacter()
        local faction = self:Team()

        return faction == 1001 or faction == TEAM_NOTCHARACTER
    end

    function playerMeta:IsNocliping()
        return self:GetMoveType() == 8
    end

    function playerMeta:LawPlace()
        return self:GetNetVar("arbEmojiShow")
    end

    function playerMeta:MonoLawPlace()
        return self:GetNetVar("arbEmojiShow") == 0
    end

    function playerMeta:NoLawPlace()
        return self:GetNetVar("arbEmojiShow") == -1
    end

    function playerMeta:IsUseTool()
        local weapon = self:GetActiveWeapon()

        if IsValid(weapon) then
            local class = weapon:GetClass()
            if !class then return false end

            return class == "gmod_tool" or class == "weapon_physgun"
        end

        return false
    end


    playerMeta.oldAlive = playerMeta.oldAlive or playerMeta.Alive
    function playerMeta:Alive()
        local faction = self:Team()

        if self:IsSpectate() then return false end
        if faction == TEAM_ADMIN then return false end
        if faction == TEAM_NOTCHARACTER then return false end

        if self:IsPlaying() then
            return self:GetNetVar("arbAlive", true)
        end

        return self:oldAlive()
    end


    playerMeta.oldHasGodMode = playerMeta.oldHasGodMode or playerMeta.HasGodMode
    function playerMeta:HasGodMode()
        return Arbitrage.util.IsServerSide() and self:oldHasGodMode() or self:GetNetVar("HasGodMode", false)
    end

    if Arbitrage.util.IsServerSide() then
        playerMeta.oldGodEnable = playerMeta.oldGodEnable or playerMeta.GodEnable
        playerMeta.oldGodDisable = playerMeta.oldGodDisable or playerMeta.GodDisable

        function playerMeta:GodEnable()
            self:SetNetVar("HasGodMode", true)

            return self:oldGodEnable()
        end

        function playerMeta:GodDisable()
            self:SetNetVar("HasGodMode", false)

            return self:oldGodDisable()
        end

        function playerMeta:InGame()
            local steamid = self:SteamID()

            return Arbitrage.players[steamid] and true or false
        end

        function playerMeta:SetFakeName(name)
            self:SetNetVar("fakename", name)
        end
    end
end

do
    local entityMeta = FindMetaTable("Entity")

    function entityMeta:IsDoor()
        local class = self:GetClass()

        if class == "prop_door_rotating" or class == "func_door_rotating" or class == "func_door" then
            return true
        end

        return false
    end
end

-- original
player_manager.AddValidModel("group02male01", "models/humans/group02/male_01.mdl")
player_manager.AddValidHands("group02male01", "models/weapons/c_arms_citizen.mdl", 1, "0000000")
player_manager.AddValidModel("group02male03", "models/humans/group02/male_03.mdl")
player_manager.AddValidHands("group02male03", "models/weapons/c_arms_citizen.mdl", 1, "0000000")
player_manager.AddValidModel("group01female07", "models/player/group01/female_07.mdl")
player_manager.AddValidHands("group01female07", "models/weapons/c_arms_citizen.mdl", 1, "0000000")
player_manager.AddValidModel("group02female03", "models/player/group01/female_03.mdl")
player_manager.AddValidHands("group02female03", "models/weapons/c_arms_citizen.mdl", 1, "0000000")

-- v1
player_manager.AddValidModel("Danganronpa Sayaka (Yoru)", "models/Sayaka_Yoru/Danganronpa/rstar/Sayaka_Yoru/Sayaka_Yoru.mdl");
player_manager.AddValidHands("Danganronpa Sayaka (Yoru)", "models/Sayaka_Yoru/Danganronpa/rstar/Sayaka_Yoru/arms/Sayaka_Yoru_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Sakura Ogami", "models/player/yourtoast4/danganronpa/sakura_ogami.mdl")
player_manager.AddValidHands("Sakura Ogami", "models/player/yourtoast4/danganronpa/c_arms/sakura_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Toko Fukawa", "models/player/dewobedil/danganronpa/toko_fukawa/default_p.mdl")
player_manager.AddValidHands("Toko Fukawa", "models/player/dewobedil/danganronpa/toko_fukawa/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Toko Fukawa (Genocide)", "models/player/dewobedil/danganronpa/toko_fukawa/genocide_p.mdl")
player_manager.AddValidHands("Toko Fukawa (Genocide)", "models/player/dewobedil/danganronpa/toko_fukawa/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Celestia Ludenberg", "models/player/dewobedil/celestia_ludenberg/default_p.mdl")
player_manager.AddValidHands("Celestia Ludenberg", "models/player/dewobedil/celestia_ludenberg/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Chihiro", "models/player/dewobedil/danganronpa/chihiro/default_p.mdl")
player_manager.AddValidHands("Chihiro", "models/player/dewobedil/danganronpa/chihiro/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Mukuro Ikusaba", "models/pacagma/danganronpa/mukuro_ikusaba/mukuro_ikusaba_player.mdl")
player_manager.AddValidHands("Mukuro Ikusaba", "models/pacagma/danganronpa/mukuro_ikusaba/mukuro_ikusaba_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Hifumi Yamada", "models/player/yourtoast4/danganronpa/hifumi_yamada.mdl")
player_manager.AddValidHands("Hifumi Yamada", "models/player/yourtoast4/danganronpa/c_arms/hifumi_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Junko Enoshima (Default)", "models/player/dewobedil/danganronpa/junko_enoshima/default_p.mdl")
player_manager.AddValidHands("Junko Enoshima (Default)", "models/player/dewobedil/danganronpa/junko_enoshima/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Kiyotaka Ishimaru", "models/player/dewobedil/danganronpa/kiyotaka_ishimaru/default_p.mdl")
player_manager.AddValidHands("Kiyotaka Ishimaru", "models/player/dewobedil/danganronpa/kiyotaka_ishimaru/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Danganronpa Kyoko Kirigiri (Yoru)", "models/Kyoko_Kirigiri_Yoru/Danganronpa/rstar/Kyoko_Kirigiri_Yoru/Kyoko_Kirigiri_Yoru.mdl");
player_manager.AddValidHands("Danganronpa Kyoko Kirigiri (Yoru)", "models/Kyoko_Kirigiri_Yoru/Danganronpa/rstar/Kyoko_Kirigiri_Yoru/arms/Kyoko_Kirigiri_Yoru_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Leon Kuwata", "models/player/yourtoast4/danganronpa/leon_kuwata.mdl")
player_manager.AddValidHands("Leon Kuwata", "models/player/yourtoast4/danganronpa/c_arms/leon_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Makoto Naegi", "models/player/yourtoast4/danganronpa/makoto_naegi.mdl")
player_manager.AddValidHands("Makoto Naegi", "models/player/yourtoast4/danganronpa/c_arms/makoto_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Mondo Owada", "models/player/dewobedil/danganronpa/mondo_owada/default_p.mdl")
player_manager.AddValidHands("Mondo Owada", "models/player/dewobedil/danganronpa/mondo_owada/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Mondo Owada (White)", "models/player/dewobedil/danganronpa/mondo_owada/white_p.mdl")
player_manager.AddValidHands("Mondo Owada (White)", "models/player/dewobedil/danganronpa/mondo_owada/c_arms/white_p.mdl", 0, "00000000")
player_manager.AddValidModel("Aoi Asahina","models/custom/aoi_asahina.mdl")
player_manager.AddValidHands("Aoi Asahina", "models/custom/aoi_asahina_viewarms.mdl", 0, "00000000")
player_manager.AddValidModel("Byakuya Togami","models/custom/byakuya_togami.mdl")
player_manager.AddValidHands("Byakuya Togami", "models/custom/byakuya_togami_viewarms.mdl", 0, "00000000")

-- v2
player_manager.AddValidModel("Fuyuhiko Kuzuryu", "models/player/dewobedil/danganronpa/fuyuhiko/default_p.mdl")
player_manager.AddValidHands("Fuyuhiko Kuzuryu", "models/player/dewobedil/danganronpa/fuyuhiko/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Chiaki Nanami", "models/player/dewobedil/chiaki_nanami/default_p.mdl")
player_manager.AddValidHands("Chiaki Nanami", "models/player/dewobedil/chiaki_nanami/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Gundam Tanaka", "models/player/dewobedil/gundam_tanaka/default_p.mdl")
player_manager.AddValidHands("Gundam Tanaka", "models/player/dewobedil/gundam_tanaka/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Hajime Hinata", "models/player/dewobedil/danganronpa/hajime_hinata/default_p.mdl")
player_manager.AddValidHands("Hajime Hinata", "models/player/dewobedil/danganronpa/hajime_hinata/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Ibuki Mioda", "models/player/dewobedil/danganronpa/ibuki_mioda/default_p.mdl")
player_manager.AddValidHands("Ibuki Mioda", "models/player/dewobedil/danganronpa/ibuki_mioda/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Kazuichi Soda", "models/player/danganronpa/kazuichi_soda.mdl")
player_manager.AddValidHands("Kazuichi Soda", "models/player/danganronpa/c_arms/kazuichi_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Mahiru Koizumi", "models/player/dewobedil/danganronpa/mahiru_koizumi/default_p.mdl")
player_manager.AddValidHands("Mahiru Koizumi", "models/player/dewobedil/danganronpa/mahiru_koizumi/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Mikan Tsumiki", "models/player/dewobedil/mikan_tsumiki/default_p.mdl")
player_manager.AddValidHands("Mikan Tsumiki", "models/player/dewobedil/mikan_tsumiki/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Monomi", "models/player/dewobedil/monomi/default_p.mdl")
player_manager.AddValidHands("Monomi", "models/player/dewobedil/monomi/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Nagito Komaeda", "models/player/dewobedil/nagito_komaeda/default_p.mdl")
player_manager.AddValidHands("Nagito Komaeda", "models/player/dewobedil/nagito_komaeda/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Peko Pekoyama", "models/player/dewobedil/peko_pekoyama/default_p.mdl")
player_manager.AddValidHands("Peko Pekoyama", "models/player/dewobedil/peko_pekoyama/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Hiyoko Saionji (Danganronpa)", "models/player/dewobedil/danganronpa/hiyoko_saionji/default_p.mdl")
player_manager.AddValidHands("Hiyoko Saionji (Danganronpa)", "models/player/dewobedil/danganronpa/hiyoko_saionji/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Sonia Nevermind", "models/player/dewobedil/danganronpa/sonia_nevermind/default_p.mdl")
player_manager.AddValidHands("Sonia Nevermind", "models/player/dewobedil/danganronpa/sonia_nevermind/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Teruteru Hanamura", "models/player/yourtoast4/danganronpa/teruteru_hanamura.mdl")
player_manager.AddValidHands("Teruteru Hanamura", "models/player/yourtoast4/danganronpa/c_arms/teruteru_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Akane Owari", "models/player/yourtoast4/danganronpa/akane_owari.mdl")
player_manager.AddValidHands("Akane Owari", "models/player/yourtoast4/danganronpa/c_arms/akane_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Byakuya Togami (DR2)", "models/player/dewobedil/danganronpa2/byakuya_togami/default_p.mdl")
player_manager.AddValidHands("Byakuya Togami (DR2)", "models/player/dewobedil/danganronpa2/byakuya_togami/c_arms/default_p.mdl", 0, "00000000")

-- v3
player_manager.AddValidModel("Himiko Yumeno", "models/player/dewobedil/danganronpa/himiko_yumeno/default_p.mdl")
player_manager.AddValidHands("Himiko Yumeno", "models/player/dewobedil/danganronpa/himiko_yumeno/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Kaede Akamatsu", "models/player/dewobedil/danganronpa/kaede_akamatsu/default_p.mdl")
player_manager.AddValidHands("Kaede Akamatsu", "models/player/dewobedil/danganronpa/kaede_akamatsu/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Kaito Momota", "models/player/dewobedil/danganronpa/kaito_momota/default_p.mdl")
player_manager.AddValidHands("Kaito Momota", "models/player/dewobedil/danganronpa/kaito_momota/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("K1B0", "models/player_kiibo.mdl")
player_manager.AddValidHands("K1B0", "models/kiibo_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Kirumi Tojo", "models/player/dewobedil/danganronpa/kirumi_tojo/default_p.mdl")
player_manager.AddValidHands("Kirumi Tojo", "models/player/dewobedil/danganronpa/kirumi_tojo/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Korekiyo Shinguji", "models/player/dewobedil/danganronpa/korekiyo_shinguji/default_p.mdl")
player_manager.AddValidHands("Korekiyo Shinguji", "models/player/dewobedil/danganronpa/korekiyo_shinguji/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Maki Harukawa", "models/player/dewobedil/danganronpa/maki_harukawa/default_p.mdl")
player_manager.AddValidHands("Maki Harukawa", "models/player/dewobedil/danganronpa/maki_harukawa/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Miu Iruma", "models/player/dewobedil/danganronpa/miu_iruma/default_p.mdl")
player_manager.AddValidHands("Miu Iruma", "models/player/dewobedil/danganronpa/miu_iruma/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Monokuma","models/player/yourtoast4/danganronpa/monokuma.mdl")
player_manager.AddValidHands("Monokuma", "models/player/yourtoast4/danganronpa/c_arms/monokuma_arms.mdl", 0, "00000000")
player_manager.AddValidModel("Kokichi Oma School Uniform","models/player_kokichioumaschool.mdl")
player_manager.AddValidHands("Kokichi Oma School Uniform", "models/arms_kokichiouma_school.mdl", 0, "00000000")
player_manager.AddValidModel("Kokichi Oma School Uniform - No eyetrack","models/player_kokichioumaschool_notrack.mdl")
player_manager.AddValidHands("Kokichi Oma School Uniform - No eyetrack", "models/arms_kokichiouma.mdl", 0, "00000000")
player_manager.AddValidModel("Kokichi Oma Ulimate Uniform","models/player_kokichioumaultimate.mdl")
player_manager.AddValidHands("Kokichi Oma Ulimate Uniform", "models/arms_kokichiouma.mdl", 0, "00000000")
player_manager.AddValidModel("Kokichi Oma Ulimate Uniform - No eyetrack","models/player_kokichioumaultimate_notrack.mdl")
player_manager.AddValidHands("Kokichi Oma Ulimate Uniform - No eyetrack", "models/arms_kokichiouma.mdl", 0, "00000000")
player_manager.AddValidModel("Kokichi Oma Beta Uniform","models/player_kokichioumabeta.mdl")
player_manager.AddValidHands("Kokichi Oma Beta Uniform", "models/arms_kokichiouma_beta.mdl", 0, "00000000")
player_manager.AddValidModel("Kokichi Oma Beta Uniform - No eyetrack","models/player_kokichioumabeta_notrack.mdl")
player_manager.AddValidHands("Kokichi Oma Beta Uniform - No eyetrack", "models/arms_kokichiouma.mdl", 0, "00000000")
player_manager.AddValidModel("Rantaro Amami", "models/player/dewobedil/danganronpa/rantaro_amami/default_p.mdl")
player_manager.AddValidHands("Rantaro Amami", "models/player/dewobedil/danganronpa/rantaro_amami/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Ryoma Hoshi", "models/player/dewobedil/danganronpa/ryoma_hoshi/default_p.mdl")
player_manager.AddValidHands("Ryoma Hoshi", "models/player/dewobedil/danganronpa/ryoma_hoshi/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Shuichi Saihara", "models/player/dewobedil/danganronpa/shuichi_saihara/default_p.mdl")
player_manager.AddValidHands("Shuichi Saihara", "models/player/dewobedil/danganronpa/shuichi_saihara/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Tenko Chabashira", "models/player/dewobedil/danganronpa/tenko_chabashira/default_p.mdl")
player_manager.AddValidHands("Tenko Chabashira", "models/player/dewobedil/danganronpa/tenko_chabashira/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Tsumugi Shirogane", "models/player/dewobedil/danganronpa/tsumugi_shirogane/default_p.mdl")
player_manager.AddValidHands("Tsumugi Shirogane", "models/player/dewobedil/danganronpa/tsumugi_shirogane/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Angie Yonaga", "models/player/dewobedil/danganronpa/angie_yonaga/default_p.mdl")
player_manager.AddValidHands("Angie Yonaga", "models/player/dewobedil/danganronpa/angie_yonaga/c_arms/default_p.mdl", 0, "00000000")
player_manager.AddValidModel("Gonta Gokuhara", "models/player/dewobedil/danganronpa/gonta_gokuhara/default_p.mdl")
player_manager.AddValidHands("Gonta Gokuhara", "models/player/dewobedil/danganronpa/gonta_gokuhara/c_arms/default_p.mdl", 0, "00000000")

-- отключаем звук при инициализации игрока
sound.Add( {
    name = "Player.DrownStart",
    channel = CHAN_STATIC,
    volume = 0,
    level = 0,
    pitch = 0,
    sound = ""
})
