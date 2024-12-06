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

Arbitrage.chat = Arbitrage.library.Add("chat")
Arbitrage.chat.Colors = {
    ["player"] = Color(240, 201, 73),
    ["other"] = Color(238, 220, 194),
    ["looc"] = Color(190, 62, 62),
    ["ooc"] = Color(236, 62, 62),
    ["anon"] = Color(0, 153, 255, 251),
    ["spectate"] = Color(153, 153, 153)
}

function Arbitrage.chat:GetIcon(client)
    local icon = client:GetIcon()

    if icon then
        return Material(icon)
    end
end

local function getDist()
    if Arbitrage.lawEnable then
        return 9999999
    end

    return ARBITRAGE_SAY_LENGTH
end

local function chatColor(name)
    return Arbitrage.chat.List[name].Color or color_white
end

local emojiList = {
    [":)"] = "улыбается", ["(:"] = "улыбается",
    [":("] = "грустит", ["):"] = "грустит",
    [":D"] = "радуется",
    ["D:"] = "грустит",
    [":P"] = "показывает язык", [":p"] = "показывает язык", [":Р"] = "показывает язык", [":р"] = "показывает язык",
    [":о"] = "удивлен(а)", [":o"] = "удивлен(а)", [":0"] = "удивлен(а)", [":O"] = "удивлен(а)", [":О"] = "удивлен(а)",
    [":/"] = "сомневается",
    [":'("] = "плачет",
    [":*"] = "целует",
    [":|"] = "без эмоций",
    [":$"] = "смущен(а)",
    [":s"] = "засмущался(ась)",
    [":X"] = "сжал(а) губы", [":x"] = "сжал(а) губы", [":Х"] = "сжал(а) губы", [":х"] = "сжал(а) губы",
    [":^)"] = "хитро улыбается",
    ["^_^"] = "радуется",
    ["-_-"] = "разочарован(а)",
    ["0_0"] = "в шоке", ["o_o"] = "в шоке", ["O_O"] = "в шоке", ["о_о"] = "в шоке", ["О_О"] = "в шоке",
    ["T_T"] = "плачет", ["Т_Т"] = "плачет", ["т_т"] = "плачет",
    [":\\"] = "недоумевает",
    ["x_x"] = "уставший(ая)", ["X_X"] = "уставший(ая)", ["Х_Х"] = "уставший(ая)", ["х_х"] = "уставший(ая)",
    ["^-^"] = "очень счастлив(а)",
    [":>"] = "радостный(ая)",
    [":<"] = "расстроенный(ая)",
    ["o_O"] = "удивлен(а)", ["о_O"] = "удивлен(а)", ["о_О"] = "удивлен(а)", ["o_О"] = "удивлен(а)", ["o_0"] = "удивлен(а)", ["o_0"] = "удивлен(а)", ["о_0"] = "удивлен(а)",
    ["O_o"] = "удивлен(а)", ["O_о"] = "удивлен(а)", ["О_о"] = "удивлен(а)", ["О_o"] = "удивлен(а)", ["0_o"] = "удивлен(а)", ["0_o"] = "удивлен(а)", ["0_о"] = "удивлен(а)",
    ["3:"] = "выражает недовольство", ["з:"] = "выражает недовольство", ["З:"] = "выражает недовольство",
    [":3"] = "выражает радость", [":з"] = "выражает радость", [":З"] = "выражает радость"
}

local letterList = {
    ["?"] = true,
    ["!"] = true,
    [";"] = true,
    ["~"] = true,
    ["|"] = true,
    ["*"] = true,
    [":"] = true,
    ["+"] = true,
    ["-"] = true,
    ["/"] = true,
    ["\\"] = true,
    ["#"] = true,
    ["="] = true,
    ["_"] = true
}
local function format(data, bIsCapitalize, bIsDot)
    if bIsCapitalize != nil then
        local firstLetter = string.utf8sub(data, 1, 1)
        local func = bIsCapitalize and string.utf8upper or string.utf8lower

        firstLetter = func(firstLetter)
        data = firstLetter .. string.utf8sub(data, 2, string.utf8len(data))
    end

    if bIsDot != nil then
        local len = string.utf8len(data)
        local lastLetter = string.utf8sub(data, len, len)

        if !letterList[lastLetter] then
            if bIsDot and lastLetter != "." then
                data = data .. "."
            elseif !bIsDot and lastLetter == "." then
                data = string.utf8sub(data, 1, string.utf8len(data) - 1)
            end
        end
    end

    return data
end

Arbitrage.chat.List = {
    ["me"] = {
        Color = Color(44, 176, 247),
        OnCreate = function(client, sender, data)
            return chatColor("me"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("me"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["mec"] = {
        Color = Color(44, 176, 247),
        OnCreate = function(client, sender, data)
            return chatColor("me"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("me"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["mel"] = {
        Color = Color(44, 176, 247),
        OnCreate = function(client, sender, data)
            return chatColor("me"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("me"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["meanon"] = {
        Color = Color(44, 176, 247),
        OnCreate = function(client, sender, data)
            return chatColor("meanon"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.anon, "Анонимно", Arbitrage.chat.Colors.other, " " .. format(data[1], false, false)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["try"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("try"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "Удачно" or "Неудачно") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["tryc"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("try"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "Удачно" or "Неудачно") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
                TypingDraw:SetTypingText(v, client, data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["tryl"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("try"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "Удачно" or "Неудачно") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["tryanon"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("tryanon"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.anon, "Анонимно", Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "Удачно" or "Неудачно") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["ic"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " говорит: ", "'" .. format(data[1], true, true) .. "'"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            local emojiText = string.Trim(data[1])
            local emojiAction = emojiList[emojiText]
            if emojiAction then
                Arbitrage.chat.SendCommand("me", client, emojiAction)
            else
                for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                    TypingDraw:SetTypingText(v, client, data[1], Arbitrage.chat.Colors.other)
                    Arbitrage.chat.SendClient(v, client, name, data)
                end
            end
        end
    },
    ["looc"] = {
        OnCreate = function(client, sender, data)
            local bSpectate = sender:IsSpectate()
            local c_player = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.player
            local c_other = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.other

            return Arbitrage.chat.Colors.looc, "[Локальный НонРП чат] ", c_player, sender:Name(), c_other, ": ", "" .. data[1] .. ""
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end,
        UseIcon = true
    },
    ["ooc"] = {
        OnCreate = function(client, sender, data)
            local bSpectate = sender:IsSpectate()
            local c_player = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.player
            local c_other = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.other

            return Arbitrage.chat.Colors.ooc, "[Глобальный НонРП чат] ", c_player, sender:SteamName(), c_other, ": ", "" .. data[1] .. ""
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.GetAll()) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end,
        UseIcon = true
    },
    ["broadcast"] = {
        Color = Color(216, 62, 62),
        OnCreate = function(client, sender, data)
            return chatColor("broadcast"), "[Уведомление] ", Arbitrage.chat.Colors.other, format(data[1], true, true)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.GetAll()) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["event"] = {
        Color = Color(216, 131, 62),
        OnCreate = function(client, sender, data)
            return chatColor("event"), format(data[1], true, true)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.GetAll()) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["eventlocal"] = {
        Color = Color(216, 193, 62),
        OnCreate = function(client, sender, data)
            return chatColor("eventlocal"), format(data[1], true, true)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["whispers"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " шепчет: ", "'" .. format(data[1], true, true) .. "'"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
                TypingDraw:SetTypingText(v, client, data[1], Arbitrage.chat.Colors.other)
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["yell"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " кричит: ", "'" .. format(data[1], true, true) .. "'"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], Arbitrage.chat.Colors.other)
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["it"] = {
        Color = color_white,
        OnCreate = function(client, sender, data)
            return chatColor("it"), "● ", Arbitrage.chat.Colors.other, "** ", format(data[1], true, nil), Arbitrage.chat.Colors.player, " (" .. sender:Name() .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("it"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["itc"] = {
        Color = color_white,
        OnCreate = function(client, sender, data)
            return chatColor("it"), "● ", Arbitrage.chat.Colors.other, "** ", format(data[1], true, nil), Arbitrage.chat.Colors.player, " (" .. sender:Name() .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("it"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["itl"] = {
        Color = color_white,
        OnCreate = function(client, sender, data)
            return chatColor("it"), "● ", Arbitrage.chat.Colors.other, "** ", format(data[1], true, nil), Arbitrage.chat.Colors.player, " (" .. sender:Name() .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("it"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["itanon"] = {
        Color = color_white,
        OnCreate = function(client, sender, data)
            return chatColor("itanon"), "● ", Arbitrage.chat.Colors.other, "** ", format(data[1], true, nil), Arbitrage.chat.Colors.anon, " (Анонимно)"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
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

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["pm"] = {
        Color = Color(42, 151, 51),
        OnCreate = function(client, sender, target, message)
            local bSpectate = sender:IsSpectate()
            local c_player = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.player
            local c_other = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.other

            print(message)

            return chatColor("pm"), "[Личное сообщение] ", c_player, sender:Name(), c_other, " > ", c_player, target:Name(), c_other, ": ", message
        end,
        OnSend = function(client, name, data)
            local target = data[1]
            local message = data[2]

            Arbitrage.chat.SendClient(target, client, "pm", target, message)
            Arbitrage.chat.SendClient(client, client, "pm", target, message)
        end,
        UseIcon = true
    },
    ["admin"] = {
        Color = Color(255, 0, 0),
        OnCreate = function(client, sender, data)
            local bSpectate = sender:IsSpectate()
            local c_player = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.player
            local c_other = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.other

            return chatColor("admin"), "[Чат администрации] ", c_player, sender:FullName(), c_other, ": ", "" .. data[1]
        end,
        OnSend = function(client, name, data)
            for k, v in ipairs(player.GetAll()) do
                if v:IsAdmin() then
                    Arbitrage.chat.SendClient(v, client, "admin", data)
                end
            end
        end,
        UseIcon = true
    },
    ["help"] = {
        Color = Color(250, 208, 208),
        OnCreate = function(client, sender, data)
            local bSpectate = sender:IsSpectate()
            local c_player = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.player
            local c_other = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.other

            return chatColor("help"), "[Помощь] ", c_player, sender:FullName(true), c_other, ": ", "" .. data[1]
        end,
        OnSend = function(client, name, data)
            for k, v in ipairs(player.GetAll()) do
                if v:IsAdmin() and client != v then
                    Arbitrage.chat.SendClient(v, client, "help", data)
                end
            end

            Arbitrage.chat.SendClient(client, client, "help", data)
        end
    },
}

function Arbitrage.chat.SendCommand(name, client, ...)
    local data = {...}

    Arbitrage.chat.List[name].OnSend(client, name, data)

    local tableData = Arbitrage.chat.UnPackMessage(Arbitrage.chat.List[name].OnCreate(nil, client, data))

    if tableData and istable(tableData) then
        local str = ""
        for k, v in ipairs(tableData) do
            if isstring(v) then
                str = str .. tostring(v)
            end
        end

        hook.Run("OnChatSay", client, name, str)
    end
end

function Arbitrage.chat.UnPackMessage(...)
    local data = {...}

    -- there must be something here?...
    return data
end

function Arbitrage.chat.SendClient(client, sender, name, ...)
    if !IsValid(client) then return end
    if !client:IsPlayer() then return end

    local tableData = Arbitrage.chat.UnPackMessage(Arbitrage.chat.List[name].OnCreate(client, sender, ...))

    if tableData and istable(tableData) then
        netstream.Start(client, "arb.chatCommandCreate", sender, name, tableData)
    end
end