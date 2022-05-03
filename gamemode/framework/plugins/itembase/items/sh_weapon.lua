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