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

Moderation:RegisterRank("founder", {
    name = "Владелец",
    description = "founder description todo...",
    color = Color(255, 62, 62),
    icon = "asterion/academy/ui/icons/rank_founder.png",
    permission_superadmin = true
})

Moderation:RegisterRank("curator", {
    name = "Куратор",
    description = "curator description todo...",
    color = Color(255, 102, 0),
    icon = "asterion/academy/ui/icons/rank_curator.png",
    permission_superadmin = true
})

Moderation:RegisterRank("gamemaster", {
    name = "Игровой мастер",
    description = "gamemaster description todo...",
    color = Color(204, 0, 255),
    icon = "asterion/academy/ui/icons/rank_gamemaster.png",
    permision_admin = true
})

Moderation:RegisterRank("guard", {
    name = "Администратор",
    description = "guard description todo...",
    color = Color(0, 255, 98),
    icon = "asterion/academy/ui/icons/rank_guard.png",
    permision_admin = true
})

Moderation:RegisterRank("developer", {
    name = "Разработчик",
    description = "developer description todo...",
    color = Color(0, 102, 255),
    icon = "asterion/academy/ui/icons/rank_developer.png",
    permision_admin = true
})

Moderation:RegisterRank("user", {
    name = "Пользователь",
    description = "user description todo...",
    color = Color(255, 255, 255),
    icon = nil
})