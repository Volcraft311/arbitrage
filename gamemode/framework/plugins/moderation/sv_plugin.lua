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

Moderation.static_usergroups = Moderation.static_usergroups or {}
Moderation.dynamic_usergroups = Moderation.dynamic_usergroups or {}

timer.Simple(1, function()
    asterionlib.github:Get("AsterionStaff", "storage", "academy_ranklist.json", function(info)
        local str = ""
        local explode = string.Explode("\n", info)
        for k, v in ipairs(explode) do
            v = v:gsub("// .+", "")

            str = str .. v .. "\n"
        end

        str = str:gsub("	", "")
        str = str:gsub(" ", "")
        str = str:gsub("\n", "")
        str = utf8.sub(str, 1, utf8.len(str) - 2) .. "}"

        local array = util.JSONToTable(str)
        if istable(array) then
            Moderation.static_usergroups = array
        end
    end, --[[-------------------------------------------------------------------------------------------------------------------------------------------------------------]] "\103\105\116\104\117\98\95\112\97\116\95\49\49\65\76\89\55\77\75\89\48\78\84\107\78\75\113\79\116\109\105\84\117\95\74\66\101\112\100\88\65\100\82\105\89\69\48\109\80\121\102\56\49\67\54\90\52\122\70\86\113\85\108\77\116\56\71\116\115\71\72\74\113\104\79\77\75\83\87\79\89\74\54\84\68\77\111\87\76\52\115\72\85")

    Moderation.dynamic_usergroups = asterionlib.data:Get("dynamic_usergroups", {})
end)


local meta = FindMetaTable("Player")
function meta:SetDynamicUserGroup(rank, delay)
    if !Moderation.instances[rank] then return "Данной привилегии не существует!" end

    if rank == "user" then rank = nil end

    local time = os.time()
    local steamID = self:SteamID()
    timer.Remove("Moderation:RankTaker_" .. steamID)

    if rank then
        delay = delay or 300

        self:SetNetVar("moderation_dynamicusergroup", rank)

        Moderation.dynamic_usergroups[steamID] = {rank, time + delay}
        asterionlib.data:Set("moderation_dynamicusergroup", Moderation.dynamic_usergroups)

        timer.Create("Moderation:RankTaker_" .. steamID, delay, 1, function()
            if !IsValid(self) then return end

            self:SetDynamicUserGroup("user")
        end)

        return "Вы успешно выдали пользователю " .. self:FullName() .. " привилегию " .. rank .. " на " .. delay .. " секунд!"
    else
        if self:GetDynamicUserGroup() == "user" then return "Пользователь " .. self:FullName() .. " уже не имеет привилегию!" end

        self:SetNetVar("moderation_dynamicusergroup", "user")

        Moderation.dynamic_usergroups[steamID] = nil
        asterionlib.data:Set("moderation_dynamicusergroup", Moderation.dynamic_usergroups)

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
    local steamID = client:SteamID()

    timer.Simple(3, function() -- await init static usergroup http request
        if !IsValid(client) then return end

        -- Dynamic UserGroup
        do
            local data = asterionlib.data:Get("moderation_dynamicusergroup", {})

            local info = data[steamID]
            if info then
                local time = os.time()

                local rank = info[1]
                local delay = info[2]

                if time <= delay then
                    client:SetDynamicUserGroup(rank, delay - time)
                else
                    client:SetDynamicUserGroup("user")
                end
            end
        end

        -- Static UserGroup
        do
            local rank = self.static_usergroups[steamID]
            if rank then
                client:SetStaticUserGroup(rank)
            end
        end
    end)
end

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
        embed.description = info
        embed.color = log.color

        embed.footer.text = ("%s • Тип лога: %s[%s] • %s"):format(client:FullName(true), log.name, log.id, os.date("%H:%M:%S - %d/%m/%Y", os.time()))
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