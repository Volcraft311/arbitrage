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


local meta = FindMetaTable("Player")
function meta:SetDynamicUserGroup(rank, delay)
    if !Moderation.instances[rank] then return "Данной привилегии не существует!" end

    if rank == "user" then rank = nil end

    local time = os.time()
    local steamID = self:SteamID()
    local steamID64 = self:SteamID64()
    timer.Remove("Moderation:RankTaker_" .. steamID)

    if rank then
        delay = delay or 300

        self:SetNetVar("moderation_dynamicusergroup", rank)

        local data = {
            _id = steamID64,
            name = self:SteamName(),
            rank = tostring(rank),
            delay = time + tonumber(delay)
        }

        local collection = asterionlib.mongodb:GetCollection("academy_dynamicrank")
        if collection then
            local dataExist = collection:Find({_id = steamID64})

            if dataExist and dataExist[1] then
                collection:Update({_id = steamID64}, {["$set"] = data})
            else
                collection:Insert(data)
            end
        end

        timer.Create("Moderation:RankTaker_" .. steamID, delay, 1, function()
            if !IsValid(self) then return end

            self:SetDynamicUserGroup("user")
        end)

        return "Вы успешно выдали пользователю " .. self:FullName() .. " привилегию " .. rank .. " на " .. delay .. " секунд!"
    else
        if self:GetDynamicUserGroup() == "user" then return "Пользователь " .. self:FullName() .. " уже не имеет привилегию!" end

        self:SetNetVar("moderation_dynamicusergroup", "user")

        local collection = asterionlib.mongodb:GetCollection("academy_dynamicrank")
        if collection then
            collection:Remove({_id = steamID64})
        end

        return "Вы сняли привилегии с пользователя " .. self:FullName() .. "!"
    end
end

function meta:SetStaticUserGroup(rank)
    self:SetNetVar("moderation_staticusergroup", rank)
end

function meta:SetDynamicToStaticUserGroup()
    timer.Remove("Moderation:RankTaker_" .. self:SteamID())

    self:SetNetVar("moderation_dynamicusergroup", self:GetStaticUserGroup())
end

function Moderation:PlayerInitialSpawnForRealz(client)
    local time = os.time()
    local steamID64 = client:SteamID64()

    -- Dynamic UserGroup
    do
        local collection = asterionlib.mongodb:GetCollection("academy_dynamicrank")
        if collection then
            local dataExist = collection:Find({_id = steamID64})

            if dataExist and dataExist[1] then
                local rank = dataExist[1].rank
                local delay = dataExist[1].delay

                if time <= delay then
                    client:SetDynamicUserGroup(rank, delay - time)
                end
            end
        end
    end

    -- Static UserGroup
    do
        local collection = asterionlib.mongodb:GetCollection("academy_staticrank")
        if collection then
            local dataExist = collection:Find({_id = steamID64})

            if dataExist and dataExist[1] then
                client:SetStaticUserGroup(dataExist[1].rank)
            end
        end
    end

    -- User Info
    do
        local collection = asterionlib.mongodb:GetCollection("academy_usersinfo")
        if collection then
            local dataExist = collection:Find({_id = steamID64})

            if dataExist and dataExist[1] then
                client:SetNetVar("user_info", dataExist[1])
            end
        end
    end
end

hook("OnCheckPassword", function(steamID64)
    local collection = asterionlib.mongodb:GetCollection("academy_staticrank")
    if collection then
        local dataExist = collection:Find({_id = steamID64})

        if dataExist and dataExist[1] then
            return true
        end
    end
end)

function Moderation:AddLog(uniqueID, data)
    self.logs[uniqueID] = data
    self.logs[uniqueID].id = uniqueID
end

function Moderation:HighlightPrimary(original)
    return "`" .. tostring(original) .. "`"
end

function Moderation:HighlightSecondary(original)
    return "**" .. tostring(original) .. "**"
end

function Moderation:HighlightPlayer(client, fullname)
    return ("[%s](<%s>)"):format(fullname and client:FullName() or client:Name(), "https://steamcommunity.com/profiles/" .. client:SteamID64())
end

function Moderation:SendLog(client, uniqueID, ...)
    local log = self.logs[uniqueID]
    if !log then return end

    local info = log.format(client, ...)

    -- admins log
    do
        netstream.Start(player.GetAdmins(), "Moderation:Log", uniqueID, info)
    end

    -- discord embed
    do
        local embed = asterionlib.webhook:Embed()
        embed.title = nil
        embed.author = nil
        embed.description = F("ru", info)
        embed.color = log.color

        embed.footer.text = ("%s • Тип лога: %s[%s] • %s"):format(F("ru", client:FullName(true)), log.name, log.id, os.date("%H:%M:%S - %d/%m/%Y", os.time()))
        embed.footer.icon_url = client:AvatarURL()

        asterionlib.webhook:Arbitrage(nil, embed)
    end
end

timer.Simple(0, function()
    local method = "Arbitrage"

    asterionlib.webhook.webList[#asterionlib.webhook.webList + 1] = method
    asterionlib.webhook.stored[method] = asterionlib.webhook.stored[method] or {}
    asterionlib.webhook[method] = function(self, message, body)
        asterionlib.logging:Add(method:lower(), message)

        table.insert(self.stored[method], self:Def(message, body))
    end
end)