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

Arbitrage.HookRun("Initialize")

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
    Arbitrage.statistics.Add("hunger", {
        data = "Hunger",
        time = function(client)
            local faction = Character.team:GetByID(client:Team())
            return faction and tonumber(faction:GetHunger()) or 25
        end,
        OnRun = function(client, info)
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
        OnCanRun = function(client, info)
            return !Arbitrage.OffFallHunger()
        end
    })

    Arbitrage.statistics.Add("thirst", {
        data = "Thirst",
        time = function(client)
            local faction = Character.team:GetByID(client:Team())
            return faction and tonumber(faction:GetThirst()) or 25
        end,
        OnRun = function(client, info)
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
        OnCanRun = function(client, info)
            return !Arbitrage.OffFallThirst()
        end,
    })

    Arbitrage.statistics.Add("sleep", {
        data = "Sleep",
        time = function(client)
            local faction = Character.team:GetByID(client:Team())
            return faction and tonumber(faction:GetFatique()) or 33
        end,
        OnCanRun = function(client, info)
            return !Arbitrage.OffFallSleep()
        end
    })
end

do
    local workshop = asterionlib.workshop

    hook.Add("asterionlib.workshop:Initialize", "asterionlib.workshop", function()
        -- MAIN
        workshop:Add("2902905430") -- Asterion Hope's Peak [Pre-Release]
        workshop:Add("2715755590") -- Danganronpa - Main Content
        workshop:Add("2786490267") -- Danganronpa - Main Content #2
        workshop:Add("2717853308") -- Danganronpa - Models Content #1
        workshop:Add("2780751458") -- Danganronpa - Models Content #2
        workshop:Add("2723789180") -- Danganronpa - Models Content #3
        workshop:Add("2849953494") -- Danganronpa - Models Content #4
        workshop:Add("2791583716") -- Asterion Academy - Additional Content
        workshop:Add("2860471023") -- Asterion Academy — Prop Content #1
        workshop:Add("2903072502") -- Asterion Academy - RadialMenu Assets (beta)

        -- OTHER
        workshop:Add("246756300") -- Stream Radio
        workshop:Add("2840031720") -- TFA Base
        workshop:Add("108024198") -- Food and Household items
        workshop:Add("1920810365") -- Facial Emote Mod
        workshop:Add("1784911999") -- LED screens
        workshop:Add("1161268544") -- Pink Blood
        workshop:Add("160250458") -- Wiremod
        workshop:Add("2840295308") -- Primitive

        -- WEAPONS
        workshop:Add("2842765511") -- nmrih reupload
        workshop:Add("244540803") -- Customizable Flashlight
        workshop:Add("921195220") -- TFA CS:S Weapons
        workshop:Add("1414153810") -- [TTT] Night vision
        workshop:Add("244540803") -- Customizable Flashlight
        workshop:Add("104607228") -- Fire Extinguisher

        -- MAPS
        workshop:Add("1892549430") -- drp_hopespeak (WIP) Danganronpa map
        workshop:Add("1892565701") -- drp_hopespeak - Content

        -- MODELS
        workshop:Add("1246554779") -- Roleplay Props Extended
        workshop:Add("958532452") -- Interior Props Pack
        workshop:Add("263266938") -- Developer Style Props!
        workshop:Add("1990021079") -- Some school props
        workshop:Add("213181442") -- Mobile Computing Pack
        workshop:Add("104477476") -- Misc Props Pack
        workshop:Add("2546157752") -- Stockplus - More Construct Props
        workshop:Add("1805856532") -- [DR] Nidai Nekomaru
        workshop:Add("2892089039") -- UNION Content Pack#1 [props]
        workshop:Add("2892095571") -- UNION Content Pack#6 [furniture]

        workshop:Add("2911771211") -- Players NPC Animations
    end)
end

function Arbitrage:GetStored()
    local data = {
        -- Позиции начальной камеры
        camPos = {
            asterion_hopespeak_prerelease = {Vector(4204.9350585938, -6540.875, -1521.4392089844), Angle(31.179883956909, -157.67475891113, 0)},
        },
        -- Где должна находится камера в конце
        camPosEnd = {
            asterion_hopespeak_prerelease = Vector(3536.844971, -6822.535645, -1939.968750)
        },
        -- Список мест
        placesList = {
            -- asterion_hopespeak_prerelease = {
            --     [0] = {Vector(-528.077271, -2354.913086, -822.366394), Angle(-1.174964, -27.304247, 0.093104)}, -- Монокума
            --     [1] = {Vector(-198.881119, -2401.409668, -887.968750), Angle(-1.486018, -90.389771, 0.000000)},
            --     [2] = {Vector(-238.035492, -2404.347412, -887.968750), Angle(-0.034027, -68.741699, 0.000000)},
            --     [3] = {Vector(-277.119537, -2427.784424, -887.968750), Angle(-0.902689, -44.751057, -0.039650)},
            --     [4] = {Vector(-299.753387, -2465.804443, -887.968750), Angle(-1.282923, -21.863527, -0.045863)},
            --     [5] = {Vector(-302.587067, -2503.919434, -887.968750), Angle(-0.980000, -0.037211, -0.069704)},
            --     [6] = {Vector(-299.616333, -2542.128662, -887.968750), Angle(-1.189690, 21.964031, -0.086604)},
            --     [7] = {Vector(-278.177643, -2579.131348, -887.968750), Angle(-0.513964, 45.297821, 0.025415)},
            --     [8] = {Vector(-238.179596, -2603.757568, -887.968750), Angle(-0.535176, 68.749794, -0.047656)},
            --     [9] = {Vector(-200.064972, -2606.583984, -887.968750), Angle(-0.623258, 90.194252, 0.000393)},
            --     [10] = {Vector(-161.853333, -2603.610840, -887.968750), Angle(-0.782074, 111.488228, 0.098710)},
            --     [11] = {Vector(-122.848984, -2580.183594, -887.968750), Angle(-0.238875, 134.212341, 0.015548)},
            --     [12] = {Vector(-100.236328, -2542.160889, -887.968750), Angle(1.261051, 157.526886, 0.095551)},
            --     [13] = {Vector(-97.406654, -2504.047119, -887.968750), Angle(-0.472908, 179.155533, 0.011351)},
            --     [14] = {Vector(-100.362938, -2465.932617, -887.968750), Angle(-0.172372, -158.530289, -0.097806)},
            --     [15] = {Vector(-123.768608, -2426.896484, -887.968750), Angle(-0.933975, -135.699966, 0.012694)},
            --     [16] = {Vector(-161.782700, -2404.253418, -887.968750), Angle(0.147995, -112.951431, -0.043005)}
            -- }
        },
        camPosPlaces = {
            -- asterion_hopespeak_prerelease = {
            --     [0] = Vector(-393.274109, -2414.661377, -842.831726) -- Монокума
            -- }
        },
        spawnList = {
            asterion_hopespeak_prerelease = {
                [1] = Vector(6010.171875, -8536.5771484375, 388.03125),
                [2] = Vector(6011.6752929688, -8416.462890625, 388.03125),
                [3] = Vector(6012.9731445313, -8312.6611328125, 388.03125),
                [4] = Vector(6014.16796875, -8217.07421875, 388.03125),
                [5] = Vector(6015.2114257813, -8133.634765625, 388.03125),
                [6] = Vector(6016.3701171875, -8040.8842773438, 388.03125),
                [7] = Vector(6017.4345703125, -7955.82421875, 388.03125),
                [8] = Vector(5883.3583984375, -7954.1459960938, 388.03125),
                [9] = Vector(5882.3012695313, -8038.7568359375, 388.03125),
                [10] = Vector(5881.1064453125, -8134.34375, 388.03125),
                [11] = Vector(5880.078125, -8216.56640625, 388.03125),
                [12] = Vector(5878.8784179688, -8312.5078125, 388.03125),
                [13] = Vector(5877.5913085938, -8415.427734375, 388.03125),
                [14] = Vector(5876.1064453125, -8534.3876953125, 388.03125),
                [15] = Vector(5774.4453125, -8533.0869140625, 388.03125),
                [16] = Vector(5775.927734375, -8414.291015625, 388.03125),
                [17] = Vector(5777.232421875, -8310.28125, 388.03125),
                [18] = Vector(5778.4194335938, -8215.1337890625, 388.03125),
                [19] = Vector(5779.4521484375, -8132.4150390625, 388.03125),
                [20] = Vector(5780.6469726563, -8036.828125, 388.03125),
                [21] = Vector(5781.7006835938, -7952.5288085938, 388.03125)
            }
        },
        lobbyList = {
            asterion_hopespeak_prerelease = {
                [1] = Vector(8264.177734375, -6640.451171875, 474.03125),
                [2] = Vector(8374.3427734375, -6639.8315429688, 474.03125),
                [3] = Vector(8503.35546875, -6639.1059570313, 474.03125),
                [4] = Vector(8627.0673828125, -6638.41015625, 474.03125),
                [5] = Vector(8742.6708984375, -6637.759765625, 474.03125),
                [6] = Vector(8856.1630859375, -6637.1215820313, 474.03125),
                [7] = Vector(8990.0654296875, -6636.3681640625, 474.03125),
                [8] = Vector(9014.1298828125, -6547.8759765625, 474.03125),
                [9] = Vector(9013.5830078125, -6450.9174804688, 474.03125),
                [10] = Vector(9013.0986328125, -6365.0483398438, 474.03125),
                [11] = Vector(9147.1298828125, -6313.4252929688, 474.03125),
                [12] = Vector(9149.146484375, -6429.9467773438, 474.03125),
                [13] = Vector(9149.6513671875, -6519.4604492188, 474.03125),
                [14] = Vector(9298.1181640625, -6470.0537109375, 474.03125),
                [15] = Vector(9378.3125, -6414.6142578125, 474.03125),
                [16] = Vector(9428.025390625, -6303.857421875, 474.03125),
                [17] = Vector(9427.328125, -6180.0971679688, 474.03125),
                [18] = Vector(9437.40234375, -6061.6411132813, 474.03125),
                [19] = Vector(8253.87109375, -6544.6420898438, 474.03125),
                [20] = Vector(8253.37890625, -6391.9565429688, 474.03125),
                [21] = Vector(8252.96484375, -6263.5678710938, 474.03125),
                [22] = Vector(8091.4858398438, -6264.0883789063, 474.03125),
                [23] = Vector(8091.0166015625, -6405.6987304688, 474.03125),
                [24] = Vector(8091.3916015625, -6521.9389648438, 474.03125),
                [25] = Vector(8371.7783203125, -6505.9443359375, 474.03125),
                [26] = Vector(8372.419921875, -6392.5854492188, 474.03125),
                [27] = Vector(8373.1240234375, -6268.13671875, 474.03125),
                [28] = Vector(8893.7998046875, -6479.109375, 474.03125),
                [29] = Vector(8823.5673828125, -6478.85546875, 474.03125),
                [30] = Vector(8690.4775390625, -6478.3759765625, 474.03125),
                [31] = Vector(8584.1015625, -6477.9916992188, 474.03125),
                [32] = Vector(8474.3818359375, -6477.5961914063, 474.03125),
                [33] = Vector(8136.9047851563, -6700.9892578125, 474.03125),
                [34] = Vector(9109.8251953125, -6629.4140625, 474.03125),
                [35] = Vector(9292.74609375, -6274.0571289063, 474.03125),
                [36] = Vector(9221.2041015625, -6393.2392578125, 474.03125),
                [37] = Vector(8947.78515625, -6215.126953125, 474.03125),
                [38] = Vector(9118.421875, -6197.1899414063, 474.03125),
                [39] = Vector(9341.208984375, -6138.6123046875, 474.03125)
            }
        }
    }

    return data
end

function Arbitrage:GetInfo()
    local data = {}

    -- копируем информацию из основной базы позиций
    local arbStored = table.Copy(Arbitrage:GetStored())
    for k, v in pairs(arbStored) do
        local info = v[game.GetMap()]

        data[k] = info
    end

    -- заменяем информацию из эдитора
    local editorStored = SERVER and table.Copy(Editor:GetStored()) or asterionlib.data:Get("editor_pos", {}, true)
    for k, v in pairs(editorStored) do
        local info = editorStored[k]

        data[k] = info
    end

    return data
end

function Arbitrage:ClearVariables(data)
    local variables = {"camPos", "camPosEnd", "placesList", "camPosPlaces", "spawnList", "lobbyList"}

    for k, v in ipairs(variables) do
        if data[v] == nil then
            Arbitrage[v] = nil
        end
    end
end

function Arbitrage:SaveVariables(data)
    for k, v in pairs(data) do
        Arbitrage[k] = v
    end
end

function Arbitrage:ReplaceVariables()
    local data = asterionlib.DeepCopy(Arbitrage:GetInfo())

    -- чистим переменные которые равны nil
    self:ClearVariables(data)

    -- записываем всю инфу в переменные, ибо с ними проще работать
    self:SaveVariables(data)
end
Arbitrage:ReplaceVariables()

function Arbitrage.FormatTime(time)
    local hours = math.floor(math.fmod(time, 86400) / 3600)
    local minutes = math.floor(math.fmod(time, 3600) / 60)

    local _h = string.format("%d", hours)
    local _m = string.format("%d", minutes)

    if tonumber(_h) < 10 then _h = "0" .. _h end
    if tonumber(_m) < 10 then _m = "0" .. _m end

    return Format("%s:%s", _h, _m)
end

function Arbitrage.GetTime()
    local thisTime = Arbitrage.ReturnTime()

    return Arbitrage.FormatTime(thisTime)
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

function Arbitrage.ReturnTime()
    return GetNetVar("arb.Time", 0)
end

-- 22:00 - 08:00 - ночная
function Arbitrage.IsNight()
    return !Arbitrage.IsDay()
end

function Arbitrage.IsStartGame()
    return GetNetVar("arb.StartGame", false)
end

function Arbitrage.IsStartLaw()
    return GetNetVar("arb.StartLaw", false)
end

function Arbitrage.OffOOC()
    return GetNetVar("arb.OffOOC", false)
end

function Arbitrage.OffFallHunger()
    return GetNetVar("arb.OffFallHunger", false)
end

function Arbitrage.OffFallThirst()
    return GetNetVar("arb.OffFallThirst", false)
end

function Arbitrage.OffFallSleep()
    return GetNetVar("arb.OffFallSleep", false)
end

function Arbitrage.OnDeadLowStatictic()
    return GetNetVar("arb.OnDeadLowStatictic", false)
end

function Arbitrage.OffCorpseEffect()
    return GetNetVar("arb.OffCorpseEffect", false)
end

function Arbitrage.OffSpawnPersistent()
    return GetNetVar("arb.OffSpawnPersistent", false)
end

function Arbitrage.OffShowClassTrial()
    return GetNetVar("arb.OffShowClassTrial", false)
end

function Arbitrage.OffGiveWeapons()
    return GetNetVar("arb.OffGiveWeapons", false)
end

function Arbitrage.OffGiveItems()
    return GetNetVar("arb.OffGiveItems", false)
end

function Arbitrage.OffSoundMassFindCorpse()
    return GetNetVar("arb.OffSoundMassFindCorpse", false)
end

function Arbitrage.OffSoundNightAndDay()
    return GetNetVar("arb.OffSoundNightAndDay", false)
end

function Arbitrage.OffRebuttalShowdown()
    return GetNetVar("arb.OffRebuttalShowdown", false)
end

function Arbitrage.OffGiveMonopads()
    return GetNetVar("arb.OffGiveMonopads", false)
end

function Arbitrage.OffShowFactions()
    return GetNetVar("arb.OffShowFactions", false)
end

function Arbitrage.KillerDetectsCorpses()
    return GetNetVar("arb.KillerDetectsCorpses", false)
end

function Arbitrage.GetChapter()
    return GetNetVar("arb.Chapter", "Эпизод отсутствует")
end

function Arbitrage.OffMonopadGlobalChat()
    return GetNetVar("arb.OffMonopadGlobalChat", false)
end

function Arbitrage.OffPickingEvidence()
    return GetNetVar("arb.OffPickingEvidence", false)
end

function Arbitrage.OnThirdPerson()
    return GetNetVar("arb.OnThirdPerson", false)
end

Arbitrage.DefaultRules = {
    {"https://i.imgur.com/WqrdPdz.png", "Перспективы прибывания", "Ученики должны жить в Абсолютной Академии остаток всего своего предпологаемого будущего."},
    {"https://i.imgur.com/5BEGz5S.png", "Требования для классного суда", "Когда происходит убийство, все выжившие ученики должны участвовать в классном суде."},
    {"https://i.imgur.com/jGNR57p.png", "Голосование на классном суде", "Если запятнанного обнаружат во время классного суда, только он будет казнен. Если запятнанный не будет обнаружен, все остальные ученики будут казнены."},
    {"https://i.imgur.com/N3y5t4N.png", "Полное прохождение Академии", "Если запятнанный переживет классный суд, он выпустится и вернётся во внешний мир."},
    {"https://i.imgur.com/5E0liqc.png", "Продолжение убийственной игры", "Убийственная игра и классный суды будут продолжаться, пока не останется только два выживших ученика."},
    {"https://i.imgur.com/8Ar23ne.png", "Время тихого часа", "\"Ночное Время\" длится с 10 вечера до 8 утра."},
    {"https://i.imgur.com/i6deVka.png", "Хорошие манеры поведения", "Насилие в отношении Монокумы - директора Абсолютной Академии, строго запрещено."},
    {"https://i.imgur.com/U4P1cUg.png", "Непричастность Директора", "Сам Монокума никогда не совершит убийство."},
    {"https://i.imgur.com/t89V6Gg.png", "Бережное отношение с имуществом Академии", "Ваши Монопады - очень важные предметы. Пожалуйста, берегите их."},
    {"https://i.imgur.com/Eg5uJSu.png", "Начало расследования", "\"Объявление о Нахождении Тела\" заиграет, когда три или более ученика найдут тело"},
    {"https://i.imgur.com/hpqh3Cp.png", "Правила передвижения по Академии", "Вы можете исследовать школу с минимальными ограничениями."},
    {"https://i.imgur.com/cMA8o7c.png", "Наказание за нарушение правил", "Ученики, которые нарушат эти правила, будут незамедлительно уничтожены."},
    {"https://i.imgur.com/DB3K2Nt.png", "Правило первой жертвы", "Если разными людьми одновременно будут совершены несколько убийств, запятнанным считаться будет тот, чью жертву нашли первой."},
    {"https://i.imgur.com/KQ300mf.png", "Принципы изменения устава Академии", "В дальнейшем, по прихоти директора, могут быть добавлены новые правила."}
}

function Arbitrage.GetAcademyRules()
    return GetNetVar("arb.Rules", table.Copy(Arbitrage.DefaultRules))
end

function Arbitrage.GetGameLogs()
    return GetNetVar("arb.GameLogs", {})
end

function Arbitrage.GetShowEvidences()
    return GetNetVar("arb.ShowEvidences", {})
end

local themes = {
    investigation = "Расследование",
    law = "Суд",
    voting = "Голосование",
    execution = "Казнь",
    splashscreen = "Заставка [Глава]",
    startgame = "Начало игры",
    endgame = "Конец игры"
}
function Arbitrage.GetTheme()
    local sound_theme = ScriptMusic:GetTheme()

    local info = themes[sound_theme]
    if info then
        return info
    end

    return "Свободное время"
end

do
    local playerMeta = FindMetaTable("Player")

    function playerMeta:FakeName()
        local name = self:GetNetVar("fakename")
        return (name != "" and name != " ") and name or nil
    end

    playerMeta.GetFakeName = playerMeta.FakeName

    function playerMeta:GetName()
        if !IsValid(self) then return "" end -- Tried to use a NULL entity! (WTF??)

        if CLIENT and self != LocalPlayer() and self:GetNetVar("hideName") then
            return "Неизвестно"
        end

        local fakeName = self:FakeName()
        if fakeName then
            return fakeName
        end

        if self:IsTokoGenocide() then
        	return "Геноцид Сё"
        end

        local faction = self:Team()
        local data = Character.team:GetByID(faction)

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

    function IsPlaying(faction)
        return faction != 1001 and faction != TEAM_NOTCHARACTER and faction != TEAM_SPECTATE and faction != TEAM_ADMIN
    end

    function playerMeta:IsPlaying()
        return IsPlaying(self:Team())
    end

    function playerMeta:IsNotCharacter()
        local faction = self:Team()

        return faction == 1001 or faction == TEAM_NOTCHARACTER
    end

    function playerMeta:IsNocliping()
        return self:GetMoveType() == 8
    end

    function playerMeta:LawPlace()
        return self:GetNetVar("arbLaw", -1)
    end

    playerMeta.oldAlive = playerMeta.oldAlive or playerMeta.Alive
    function playerMeta:Alive()
        local faction = self:Team()

        if IsPlaying(faction) then
            return self:GetNetVar("arbAlive", true)
        end

        return false
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

-- UDG
player_manager.AddValidModel( "Komaru Naegi (UDG)", "models/player/someguy/komaru_p.mdl" )
player_manager.AddValidHands( "Komaru Naegi (UDG)", "models/player/someguy/komaru_arms.mdl", 0, "00000000")

-- отключаем звук при инициализации игрока
sound.Add({
    name = "Player.DrownStart",
    channel = CHAN_STATIC,
    volume = 0,
    level = 0,
    pitch = 0,
    sound = ""
})

sound.Add({
    name = "SprayCan.Paint",
    channel = CHAN_STATIC,
    volume = 0,
    level = 0,
    pitch = 0,
    sound = ""
})