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
    [":)"] = "#emoji_smiling", ["(:"] = "#emoji_smiling",
    [":("] = "#emoji_sad", ["):"] = "#emoji_sad",
    [":D"] = "#emoji_rejoices",
    ["D:"] = "#emoji_sad",
    [":P"] = "#emoji_shows_tongue", [":p"] = "#emoji_shows_tongue", [":Р"] = "#emoji_shows_tongue", [":р"] = "#emoji_shows_tongue",
    [":о"] = "#emoji_surprised", [":o"] = "#emoji_surprised", [":0"] = "#emoji_surprised", [":O"] = "#emoji_surprised", [":О"] = "#emoji_surprised",
    [":/"] = "#emoji_doubts",
    [":'("] = "#emoji_crying",
    [":*"] = "#emoji_kisses",
    [":|"] = "#emoji_without_emotion",
    [":$"] = "#emoji_confused",
    [":s"] = "#emoji_embarrassed",
    [":X"] = "#emoji_pursed_his_lips", [":x"] = "#emoji_pursed_his_lips", [":Х"] = "#emoji_pursed_his_lips", [":х"] = "#emoji_pursed_his_lips",
    [":^)"] = "#emoji_smiles_slyly",
    ["^_^"] = "#emoji_rejoices",
    ["-_-"] = "#emoji_disappointed",
    ["0_0"] = "#emoji_shocked", ["o_o"] = "#emoji_shocked", ["O_O"] = "#emoji_shocked", ["о_о"] = "#emoji_shocked", ["О_О"] = "#emoji_shocked",
    ["T_T"] = "#emoji_crying", ["Т_Т"] = "#emoji_crying", ["т_т"] = "#emoji_crying",
    [":\\"] = "#emoji_is_perplexed",
    ["x_x"] = "#emoji_tired", ["X_X"] = "#emoji_tired", ["Х_Х"] = "#emoji_tired", ["х_х"] = "#emoji_tired",
    ["^-^"] = "#emoji_very_happy",
    [":>"] = "#emoji_glad",
    [":<"] = "#emoji_upset",
    ["o_O"] = "#emoji_surprised", ["о_O"] = "#emoji_surprised", ["о_О"] = "#emoji_surprised", ["o_О"] = "#emoji_surprised", ["o_0"] = "#emoji_surprised", ["o_0"] = "#emoji_surprised", ["о_0"] = "#emoji_surprised",
    ["O_o"] = "#emoji_surprised", ["O_о"] = "#emoji_surprised", ["О_о"] = "#emoji_surprised", ["О_o"] = "#emoji_surprised", ["0_o"] = "#emoji_surprised", ["0_o"] = "#emoji_surprised", ["0_о"] = "#emoji_surprised",
    ["3:"] = "#emoji_expresses_dissatisfaction", ["з:"] = "#emoji_expresses_dissatisfaction", ["З:"] = "#emoji_expresses_dissatisfaction",
    [":3"] = "#emoji_expresses_joy", [":з"] = "#emoji_expresses_joy", [":З"] = "#emoji_expresses_joy"
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

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
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

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
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

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("me"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["meanon"] = {
        Color = Color(44, 176, 247),
        OnCreate = function(client, sender, data)
            return chatColor("meanon"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.anon, "#chat_anonymously", Arbitrage.chat.Colors.other, " " .. format(data[1], false, false)
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["try"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("try"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "#try_successfully" or "#try_unsuccessful") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
                TypingDraw:SetTypingText(v, client, data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["tryc"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("try"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "#try_successfully" or "#try_unsuccessful") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
                TypingDraw:SetTypingText(v, client, data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["tryl"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("try"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "#try_successfully" or "#try_unsuccessful") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], data[2] and Color(59, 238, 133) or Color(225, 73, 73))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["tryanon"] = {
        Color = Color(44, 247, 85),
        OnCreate = function(client, sender, data)
            return chatColor("tryanon"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.anon, "#chat_anonymously", Arbitrage.chat.Colors.other, " " .. format(data[1], false, false), data[2] and Color(59, 238, 133) or Color(225, 73, 73), " (" .. (data[2] and "#try_successfully" or "#try_unsuccessful") .. ")"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["ic"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " #chat_say: ", "'" .. format(data[1], true, true) .. "'"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            local emojiText = string.Trim(data[1])
            local emojiAction = emojiList[emojiText]
            if emojiAction then
                Arbitrage.chat.SendCommand("me", client, emojiAction)
            else
                for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
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

            return Arbitrage.chat.Colors.looc, "#chat_lnrp_type ", c_player, sender:Name(), c_other, ": ", "" .. data[1] .. ""
        end,
        OnSend = function(client, name, data)
            if !data then return end
            if client:GetNetVar("arb.MuteNonRPChat") then return client:ChatNotify("#chat_nrp_chat_block") end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
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

            return Arbitrage.chat.Colors.ooc, "#chat_gnrp_type ", c_player, sender:SteamName(), c_other, ": ", "" .. data[1] .. ""
        end,
        OnSend = function(client, name, data)
            if !data then return end
            if client:GetNetVar("arb.MuteNonRPChat") then return client:ChatNotify("#chat_nrp_chat_block") end

            for k, v in ipairs(player.GetAll()) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end,
        UseIcon = true
    },
    ["broadcast"] = {
        Color = Color(216, 62, 62),
        OnCreate = function(client, sender, data)
            return chatColor("broadcast"), "#chat_notification_type ", Arbitrage.chat.Colors.other, format(data[1], true, true)
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

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["whispers"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " #chat_whispers: ", "'" .. format(data[1], true, true) .. "'"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
                TypingDraw:SetTypingText(v, client, data[1], Arbitrage.chat.Colors.other)
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["yell"] = {
        OnCreate = function(client, sender, data)
            return Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " #chat_yell: ", "'" .. format(data[1], true, true) .. "'"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
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

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
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

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.3)) do
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

            for k, v in ipairs(player.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 2)) do
                TypingDraw:SetTypingText(v, client, data[1], chatColor("it"))
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["itanon"] = {
        Color = color_white,
        OnCreate = function(client, sender, data)
            return chatColor("itanon"), "● ", Arbitrage.chat.Colors.other, "** ", format(data[1], true, nil), Arbitrage.chat.Colors.anon, " (#chat_anonymously)"
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["roll"] = {
        Color = Color(209, 69, 69),
        OnCreate = function(client, sender, data)
            return chatColor("roll"), "● ", Arbitrage.chat.Colors.other, "** ", Arbitrage.chat.Colors.player, sender:Name(), Arbitrage.chat.Colors.other, " " .. "#chat_roll_send " .. data[1] .. " #chat_roll_send_prefix " .. data[2] .. "."
        end,
        OnSend = function(client, name, data)
            if !data then return end

            for k, v in ipairs(player.FindInSphere(client:GetPos(), getDist())) do
                Arbitrage.chat.SendClient(v, client, name, data)
            end
        end
    },
    ["pm"] = {
        Color = Color(42, 151, 51),
        OnCreate = function(client, sender, data)
            local target = data[1]
            local message = data[2]

            local bSpectate = sender:IsSpectate()
            local c_player = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.player
            local c_other = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.other

            return chatColor("pm"), "#chat_pm_type ", c_player, sender:Name(), c_other, " > ", c_player, target:Name(), c_other, ": ", message
        end,
        OnSend = function(client, name, data)
            local target = data[1]

            Arbitrage.chat.SendClient(target, client, "pm", data)
            Arbitrage.chat.SendClient(client, client, "pm", data)
        end,
        UseIcon = true
    },
    ["admin"] = {
        Color = Color(255, 0, 0),
        OnCreate = function(client, sender, data)
            local bSpectate = sender:IsSpectate()
            local c_player = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.player
            local c_other = bSpectate and Arbitrage.chat.Colors.spectate or Arbitrage.chat.Colors.other

            return chatColor("admin"), "#chat_admin_type ", c_player, sender:FullName(), c_other, ": ", "" .. data[1]
        end,
        OnSend = function(client, name, data)
            for k, v in ipairs(player.GetAdmins()) do
                Arbitrage.chat.SendClient(v, client, "admin", data)
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

            return chatColor("help"), "#chat_help_type ", c_player, sender:FullName(true), c_other, ": ", "" .. data[1]
        end,
        OnSend = function(client, name, data)
            for k, v in ipairs(player.GetAdmins()) do
                if client != v then
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

function Arbitrage.chat.SendClient(client, sender, name, data)
    if !IsValid(client) then return end
    if !client:IsPlayer() then return end

    local tableData = Arbitrage.chat.UnPackMessage(Arbitrage.chat.List[name].OnCreate(client, sender, data))

    if tableData and istable(tableData) then
        netstream.Start(client, "arb.chatCommandCreate", sender, name, tableData)
    end
end