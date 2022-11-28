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

Arbitrage.chat = Arbitrage.library.Add("chat")
Arbitrage.chat.Colors = {
    ["player"] = Color(240, 201, 73),
    ["other"] = Color(238, 220, 194),
    ["looc"] = Color(190, 62, 62),
    ["ooc"] = Color(236, 62, 62)
}

function Arbitrage.chat:GetIcon(client)
    local mat = Material

    if IsValid(client) then
        if client.SteamID and client:SteamID() == "STEAM_0:1:127526733" then
            return mat("icon16/application_osx_terminal.png")
        elseif client:GetUserGroup() == "founder" then
            return mat("icon16/key.png")
        elseif client:GetUserGroup() == "superadmin" then
            return mat("icon16/award_star_gold_1.png")
        elseif client:GetUserGroup() == "gamemaster" then
            return mat("icon16/cog.png")
        elseif client:GetUserGroup() == "tester" then
            return mat("icon16/lock.png")
        elseif client:IsSuperAdmin() then
            return mat("icon16/award_star_gold_1.png")
        elseif client:IsAdmin() then
            return mat("icon16/medal_gold_2.png")
        end
    end

    return mat("icon16/user.png")
end

local function getDist()
    if Arbitrage.lawEnable then
        return 9999999
    end

    return ARBITRAGE_SAY_LENGTH
end

local function chatColor(name)
    if !name then return end

    return Arbitrage.chat.List[name].Color or color_white
end

Arbitrage.chat.List = {
    ["me"] = {
        Color = Color(44, 176, 247),
        OnCreate = function(client, sender, data)
            return chatColor("me"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. data[1]
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("me"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["try"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("try"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "Удачно" or "Неудачно") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["ic"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " говорит: ", "\"" .. data[1] .. "\""
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], Arbitrage.chat.Colors.other)
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["looc"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.looc, "[Локальный НонРП чат] ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, ": ", "" .. data[1] .. ""
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end,
        UseIcon = true
    },
    ["ooc"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.ooc, "[Глобальный НонРП чат] ", Arbitrage.chat.Colors.player, sender:SteamName(), Arbitrage.chat.Colors.other, ": ", "" .. data[1] .. ""
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(player.GetAll()) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end,
        UseIcon = true
    },
    ["broadcast"] = {
        Color = Color(216, 62, 62),
        OnCreate = function(client, sender, data)
            return chatColor("broadcast"), "[Уведомление] ", Arbitrage.chat.Colors.other, data[1]
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(player.GetAll()) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["whispers"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " шепчет: ", "\"" .. data[1] .. "\""
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
                TypingDraw:SetTypingText(v, client, data[1], Arbitrage.chat.Colors.other)
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["yell"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " кричит: ", "\"" .. data[1] .. "\""
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], Arbitrage.chat.Colors.other)
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["it"] = {
        Color = color_white,
        OnCreate = function(client, sender, data)
            return chatColor("it"), "● ", Arbitrage.chat.Colors.other, "** ", data[1], Arbitrage.chat.Colors.player, " (" .. sender:Name() .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("it"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["roll"] = {
        Color = Color(209, 69, 69),
        OnCreate = function(client, sender, data)
            return chatColor("roll"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. data[1]
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in pairs(ents.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    }
}

function Arbitrage.chat.SendCommand(name, client, ...)
    local data = {...}

    Arbitrage.chat.List[name].OnSend(client, name, data)

    local tableData = Arbitrage.chat.UnPackMessage(Arbitrage.chat.List[name].OnCreate(nil, client, data))

    if serverguard and tableData and istable(tableData) then
        local str = ""
        for k, v in ipairs(tableData) do
            if isstring(v) then
                str = str .. tostring(v)
            end
        end

        serverguard.Log(("<%s> (%s) -> %s"):format(client:SteamID(), name, str))
    end
end

function Arbitrage.chat.UnPackMessage(...)
    local data = {...}

    -- there must be something here?...
    return data
end

function Arbitrage.chat.SendClient(client, sender, name, data)
    if !IsValid(client) then return end
    if !client:IsPlayer() then return end

    local tableData = Arbitrage.chat.UnPackMessage(Arbitrage.chat.List[name].OnCreate(client, sender, data))

    if tableData and istable(tableData) then
        netstream.Start(client, "arb.chatCommandCreate", sender, name, tableData)
    end
end