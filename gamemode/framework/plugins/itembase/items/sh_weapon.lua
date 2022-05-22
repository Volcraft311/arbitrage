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


do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Test"
    ITEM.description = "Test"
    ITEM.model = "models/weapons/w_pistol.mdl"

    ItemBase:RegisterItem("test_weapon", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Огнетушитель"
    ITEM.description = "Самая полезная вещь при пожаре."
    ITEM.model = "models/weapons/w_fire_extinguisher.mdl"
    ITEM.class = "weapon_extinguisher"

    ItemBase:RegisterItem("extinguisher", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Фонарь"
    ITEM.description = "Лучший помощник, дабы ориентироваться в темноте."
    ITEM.model = "models/weapons/w_flashlight_zm.mdl"
    ITEM.class = "weapon_flashlight"

    ItemBase:RegisterItem("flashlight", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Smith & Wesson 686"
    ITEM.description = "С этим оружием вы почувствуете себя явным жителем дикого запада."
    ITEM.model = "models/weapons/tfa_nmrih/w_fa_sw686.mdl"
    ITEM.class = "tfa_nmrih_sw686"

    ItemBase:RegisterItem("sw686", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Ruger MK III"
    ITEM.description = "Спортивно=охотничий американский пистолет."
    ITEM.model = "models/weapons/tfa_nmrih/w_fa_mkiii.mdl"
    ITEM.class = "tfa_nmrih_mkiii"

    ItemBase:RegisterItem("mkiii", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Remmington M870"
    ITEM.description = "Охотничии дробовик. Популярен в фильмах про зомби."
    ITEM.model = "models/weapons/tfa_nmrih/w_fa_870.mdl"
    ITEM.class = "tfa_nmrih_870"

    ItemBase:RegisterItem("m870", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Colt 1911"
    ITEM.description = "\"У кого есть кольт, тот решает всё!\""
    ITEM.model = "models/weapons/tfa_nmrih/w_fa_1911.mdl"
    ITEM.class = "tfa_nmrih_1911"

    ItemBase:RegisterItem("1911", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "MAC 10"
    ITEM.description = "Известен также как \"Брэддок\"."
    ITEM.model = "models/weapons/tfa_nmrih/w_fa_mac10.mdl"
    ITEM.class = "tfa_nmrih_mac10"

    ItemBase:RegisterItem("mac10", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Бейсбольная бита"
    ITEM.description = "Вот теперь вы можете сыграть в бейсбол, наверное."
    ITEM.model = "models/weapons/tfa_nmrih/w_me_bat_metal.mdl"
    ITEM.class = "tfa_nmrih_bat"

    ItemBase:RegisterItem("bat", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Кухонный Нож"
    ITEM.description = "Обычно предназначается для готовки."
    ITEM.model = "models/weapons/tfa_nmrih/w_me_kitknife.mdl"
    ITEM.class = "tfa_nmrih_kknife"

    ItemBase:RegisterItem("knife", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Топор"
    ITEM.description = "Оружие дровосека?"
    ITEM.model = "models/weapons/tfa_nmrih/w_me_hatchet.mdl"
    ITEM.class = "tfa_nmrih_hatchet"

    ItemBase:RegisterItem("hatchet", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Пожарный Топор"
    ITEM.description = "Считается оружием психопатов. Действительно, кто в здравом уме будет тушить огонь топором?"
    ITEM.model = "models/weapons/tfa_nmrih/w_me_axe_fire.mdl"
    ITEM.class = "tfa_nmrih_fireaxe"

    ItemBase:RegisterItem("fireaxe", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Огнетушитель (бесконечный)"
    ITEM.description = "Самая полезная вещь при пожаре."
    ITEM.model = "models/weapons/w_fire_extinguisher.mdl"
    ITEM.class = "weapon_extinguisher_infinite"

    ItemBase:RegisterItem("extinguisher_infinite", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Масляная лампа"
    ITEM.description = "Старенькая масляная лампа."
    ITEM.model = "models/weapons/w_lantern.mdl"
    ITEM.class = "buu_lantern_oil"

    ItemBase:RegisterItem("lantern_oil", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Масляная лампа (Бесконечная)"
    ITEM.description = "Старенькая масляная лампа."
    ITEM.model = "models/weapons/w_lantern.mdl"
    ITEM.class = "buu_lantern"

    ItemBase:RegisterItem("lantern", ITEM)

end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Очки ночного зрения."
    ITEM.description = "Очень популярны из-за фильмов про шпионов."
    ITEM.model = "models/weapons/cbinocularsbp/w_nvbinoculars.mdl"
    ITEM.class = "nightvision"

    ItemBase:RegisterItem("nightvision", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Бензопила"
    ITEM.description = "Устройте свою резню!"
    ITEM.model = "models/weapons/tfa_nmrih/w_me_chainsaw.mdl"
    ITEM.class = "tfa_nmrih_chainsaw"

    ItemBase:RegisterItem("chainsaw", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Арбалет"
    ITEM.description = "Арбалёт с раскаллёными метталическими болтами."
    ITEM.model = "models/weapons/w_crossbow.mdl"
    ITEM.class = "weapon_crossbow"

    ItemBase:RegisterItem("crossbow", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Desert Eagle"
    ITEM.description = "Крупнокалиберный израильский пистолет."
    ITEM.model = "models/weapons/3_pist_deagle.mdl"
    ITEM.class = "tfcss_deagle_alt"
    ITEM.icon = "danganronpa/inventory/items/wep_deserteagle.png"

    ItemBase:RegisterItem("deagle", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "HK USP"
    ITEM.description = "Лёгкокалиберный немецкий пистолет"
    ITEM.model = "models/weapons/3_pist_usp.mdl"
    ITEM.class = "tfcss_usp_alt"

    ItemBase:RegisterItem("usp", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Кувалда"
    ITEM.description = "Мощное оружие для вышибания мозгов"
    ITEM.model = "models/weapons/tfa_nmrih/w_me_sledge.mdl"
    ITEM.class = "tfa_nmrih_sledge"

    ItemBase:RegisterItem("sledge", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Фубар"
    ITEM.description = "Мультизадачный инструмент. Очень мультизадачный."
    ITEM.model = "models/weapons/tfa_nmrih/w_me_fubar.mdl"
    ITEM.class = "tfa_nmrih_fubar"

    ItemBase:RegisterItem("fubar", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Мачете"
    ITEM.description = "Прекрасен для рубки кокосов. И не только"
    ITEM.model = "models/weapons/tfa_nmrih/w_me_machete.mdl"
    ITEM.class = "tfa_nmrih_machete"

    ItemBase:RegisterItem("machete", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Dual Elites"
    ITEM.description = "Теперь вы похожи на профессионального киллера."
    ITEM.model = "models/weapons/w_pist_elite_dropped.mdl"
    ITEM.class = "tfcss_dualelites_alt"

    ItemBase:RegisterItem("dualelites", ITEM)
end



