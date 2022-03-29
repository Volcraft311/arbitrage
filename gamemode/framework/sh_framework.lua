--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
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
    Arbitrage.AddAction("arb_note", "Прочитать", {
        icon = "icon16/book_open.png",
        data = function(client, entity)
            entity:ReadNote(client, 1)
        end
    })

    Arbitrage.AddAction("arb_note", "Изменить", {
        icon = "icon16/pencil.png",
        data = function(client, entity)
            entity:AutoAddEditor(client)

            entity:EditNote(client, 1)
        end
    })
end

do
    Arbitrage.evidence.AddEnt("arb_note", {
        name = "Блокнот",
        desc = "Самый обычный блокнот, скорее всего содержит в себе какие-то записи.",
        up = 0,
        right = 0,
        forward = 0
    })

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
    -- Автоматы
    Arbitrage.weapon.Add("tfcss_ak47_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_awp_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_famas_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_p90_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_g3sg1_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_galil_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_ump45_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_m249_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_m3_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_m4a1_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_mac10_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_mp5_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_scout_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_sg550_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_sg552_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_aug_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_tmp_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfcss_xm1014_alt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_sv10", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_m16_ch", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_m16_rt", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_fal", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_mp5", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_jae700", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_mac10", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_500a", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_870", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_rug1022", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_rug1022_25", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_sako", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_sako_is", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_sks", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_sks_nb", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_1892", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_superx3", "automatic_machines", true)
    Arbitrage.weapon.Add("tfa_nmrih_cz", "automatic_machines", true)

    Arbitrage.weapon.Add("weapon_ar2", "automatic_machines", true)
    Arbitrage.weapon.Add("weapon_crossbow", "automatic_machines", true)
    Arbitrage.weapon.Add("weapon_smg1", "automatic_machines", true)
    Arbitrage.weapon.Add("weapon_shotgun", "automatic_machines", true)
    Arbitrage.weapon.Add("weapon_rpg", "automatic_machines", true)

    Arbitrage.weapon.Add("428gl", "automatic_machines", true)
    Arbitrage.weapon.Add("428mas", "automatic_machines", true)
    Arbitrage.weapon.Add("428draco", "automatic_machines", true)
    Arbitrage.weapon.Add("428pkm", "automatic_machines", true)
    Arbitrage.weapon.Add("428tac", "automatic_machines", true)
    Arbitrage.weapon.Add("428saigad", "automatic_machines", true)
    Arbitrage.weapon.Add("428saiga", "automatic_machines", true)
    Arbitrage.weapon.Add("428scorp", "automatic_machines", true)
    Arbitrage.weapon.Add("428scorpst", "automatic_machines", true)
    Arbitrage.weapon.Add("428scorps", "automatic_machines", true)
    Arbitrage.weapon.Add("428sgr", "automatic_machines", true)
    Arbitrage.weapon.Add("428sauer", "automatic_machines", true)
    Arbitrage.weapon.Add("428sauers", "automatic_machines", true)
    Arbitrage.weapon.Add("428sauero", "automatic_machines", true)
    Arbitrage.weapon.Add("428winch", "automatic_machines", true)


    -- Пистолеты
    Arbitrage.weapon.Add("tfcss_deagle_alt", "pistol", true)
    Arbitrage.weapon.Add("tfcss_dualelites_alt", "pistol", true)
    Arbitrage.weapon.Add("tfcss_fiveseven_alt", "pistol", true)
    Arbitrage.weapon.Add("tfcss_glock_alt", "pistol", true)
    Arbitrage.weapon.Add("tfcss_usp_alt", "pistol", true)
    Arbitrage.weapon.Add("tfcss_p228_alt", "pistol", true)
    Arbitrage.weapon.Add("tfa_nmrih_m92fs", "pistol", true)
    Arbitrage.weapon.Add("tfa_nmrih_1911", "pistol", true)
    Arbitrage.weapon.Add("tfa_nmrih_g17", "pistol", true)
    Arbitrage.weapon.Add("tfa_nmrih_mkiii", "pistol", true)
    Arbitrage.weapon.Add("tfa_nmrih_sw686", "pistol", true)

    Arbitrage.weapon.Add("weapon_357", "pistol", true)
    Arbitrage.weapon.Add("weapon_pistol", "pistol", true)

    Arbitrage.weapon.Add("428samurai", "pistol", true)
    Arbitrage.weapon.Add("428_1911", "pistol", true)
    Arbitrage.weapon.Add("428mag", "pistol", true)
    Arbitrage.weapon.Add("428cz", "pistol", true)
    Arbitrage.weapon.Add("428_1911_2", "pistol", true)
    Arbitrage.weapon.Add("428cz2", "pistol", true)
    Arbitrage.weapon.Add("428dual", "pistol", true)
    Arbitrage.weapon.Add("428glo", "pistol", true)

    Arbitrage.weapon.Add("tfa_hellsing_casull", "pistol", true)


    -- Ближнее
    Arbitrage.weapon.Add("tfa_arcade_nmrih_bat", "big", true)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_sledge", "big", true)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_kknife", "small", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_machete", "big", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_bcd", "small", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_crowbar", "big", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_fireaxe", "big", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_lpipe", "big", true)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_cleaver", "small", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_hatchet", "big", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_wrench", "small", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_big", "blunt", false)
    Arbitrage.weapon.Add("tfa_arcade_nmrih_etool", "big", false)

    Arbitrage.weapon.Add("weapon_crowbar", "big", false)
    Arbitrage.weapon.Add("weapon_stunstick", "small", false)

    Arbitrage.weapon.Add("weapon_sky_akaviri_katana", "big", false)
    Arbitrage.weapon.Add("weapon_sky_bladeofsacrifice", "big", false)
    Arbitrage.weapon.Add("weapon_sky_bladeofwoe", "big", false)
    Arbitrage.weapon.Add("weapon_sky_axe_daedric", "big", false)
    Arbitrage.weapon.Add("weapon_sky_daedricbow", "big", false)
    Arbitrage.weapon.Add("weapon_sky_daedric_dagger", "big", false)
    Arbitrage.weapon.Add("weapon_sky_daedric_greatsword", "big", false)
    Arbitrage.weapon.Add("weapon_sky_mace_daedric", "big", false)
    Arbitrage.weapon.Add("weapon_sky_daedricsword", "big", false)
    Arbitrage.weapon.Add("weapon_sky_waraxe_daedric", "big", false)
    Arbitrage.weapon.Add("weapon_sky_warhammer_daedric", "big", false)
    Arbitrage.weapon.Add("weapon_sky_axe_draugr", "big", false)
    Arbitrage.weapon.Add("weapon_sky_draugr_greatsword", "big", false)
    Arbitrage.weapon.Add("weapon_sky_draugrsword", "big", false)
    Arbitrage.weapon.Add("weapon_sky_waraxe_draugr", "big", false)
    Arbitrage.weapon.Add("weapon_sky_axe_wuuthrad", "big", false)

    Arbitrage.weapon.Add("epee_daedric", "big", false)
    Arbitrage.weapon.Add("epee_argent", "big", false)
    Arbitrage.weapon.Add("epee_fer", "big", false)
    Arbitrage.weapon.Add("epee_verre", "big", false)
    Arbitrage.weapon.Add("epee_ebonite", "big", false)


    -- Луки
    Arbitrage.weapon.Add("weapon_sky_draugrbow", "bow", false)


    -- Разное
    Arbitrage.weapon.Add("bloom", "bloom", false)
    Arbitrage.weapon.Add("weapon_flashlight", "flashlight", false)
    Arbitrage.weapon.Add("weapon_extinguisher_infinite", "extinguisher", false)
    Arbitrage.weapon.Add("weapon_extinguisher", "extinguisher", false)
    Arbitrage.weapon.Add("weapon_grapplehook", "grapp", false)
    Arbitrage.weapon.Add("weapon_grapplehook_mk2", "grapp", false)
    Arbitrage.weapon.Add("weapon_thrusterpack", "thruster", false)
    Arbitrage.weapon.Add("weapon_roulette", "roulette", false)
    Arbitrage.weapon.Add("item_lighter", "lighter", false)


    -- Наручники
    Arbitrage.weapon.Add("weapon_cuff_standard", "cuffs", false)
    Arbitrage.weapon.Add("weapon_leash_elastic", "cuffs", false)
    Arbitrage.weapon.Add("weapon_cuff_elastic", "cuffs", false)
    Arbitrage.weapon.Add("weapon_cuff_plastic", "cuffs", false)
    Arbitrage.weapon.Add("weapon_cuff_police", "cuffs", false)
    Arbitrage.weapon.Add("weapon_leash_rope", "cuffs", false)
    Arbitrage.weapon.Add("weapon_cuff_rope", "cuffs", false)
    Arbitrage.weapon.Add("weapon_cuff_shackles", "cuffs", false)
    Arbitrage.weapon.Add("weapon_cuff_tactical", "cuffs", false)


    -- Магия
    Arbitrage.weapon.Add("wow_entangling_roots", "wow_entangling_roots", false)
    Arbitrage.weapon.Add("psi_smokeout", "psi_smokeout", false)
    Arbitrage.weapon.Add("wow_moonfire", "wow_moonfire", false)
    Arbitrage.weapon.Add("pk_armor", "pk_armor", false)
    Arbitrage.weapon.Add("psi_vaporizetrap", "psi_vaporizetrap", false)
    Arbitrage.weapon.Add("psi_picklock", "psi_picklock", false)
    Arbitrage.weapon.Add("psi_phantomsummon", "psi_phantomsummon", false)
    Arbitrage.weapon.Add("wow_taunt", "wow_taunt", false)
    Arbitrage.weapon.Add("wow_regrowth", "wow_regrowth", false)
    Arbitrage.weapon.Add("wow_charge", "wow_charge", false)
    Arbitrage.weapon.Add("psi_psijammercharge", "psi_psijammercharge", false)
    Arbitrage.weapon.Add("pk_shift", "pk_shift", false)
    Arbitrage.weapon.Add("psi_psychoshock", "psi_psychoshock", false)
    Arbitrage.weapon.Add("psi_staticburst", "psi_staticburst", false)
end

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
    local stamina = client.Stamina or 100

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

    playerMeta.SteamName = playerMeta.SteamName or playerMeta.Name
    function playerMeta:GetName()
        if !IsValid(self) then return "" end -- Tried to use a NULL entity! (WTF??)

        local faction = self:Team()
        local data = Arbitrage.teams.Get(faction)

        if faction and self:IsPlaying() and data then
            return data.name or self:SteamName()
        end

        return self:SteamName()
    end

    playerMeta.Nick = playerMeta.GetName
    playerMeta.Name = playerMeta.GetName

    function IsMonoKum(idx)
        if !idx then return false end

        local factionData = Arbitrage.teams.Get(idx)
        if !factionData then return false end

        return factionData.monokuma or false
    end

    function playerMeta:IsMonoKum()
        local faction = self:Team()

        return IsMonoKum(faction)
    end

    function playerMeta:IsSpectate()
        local faction = self:Team()

        return faction == TEAM_SPECTATE
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
player_manager.AddValidModel("Sayaka Maizono", "models/player/dewobedil/sayaka_maizono/default_p.mdl")
player_manager.AddValidHands("Sayaka Maizono", "models/player/dewobedil/sayaka_maizono/c_arms/default_p.mdl", 0, "00000000")
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
player_manager.AddValidModel("Kyoko Kirigiri", "models/player/dewobedil/kyouko_kirigiri/default_p.mdl")
player_manager.AddValidHands("Kyoko Kirigiri", "models/player/dewobedil/kyouko_kirigiri/c_arms/default_p.mdl", 0, "00000000")
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
