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


local PLUGIN = PLUGIN
PLUGIN.requestList = PLUGIN.requestList or {}
PLUGIN.logs = PLUGIN.logs or {}
PLUGIN.logsTypes = {
    add = "Пользователь %s добавил %s в список предложенных дополнений.",
    removeReq = "Администратор %s отправил запрос на удаление %s.",
    installReq = "Администратор %s отправил запрос на установку %s.",
    cancel = "Администратор %s удалил %s из списка предложенных дополнений",
    skip = "Пропускаем дополнение %s из-за привышения максимальных попыток поиска",
    startRemove = "[1/3] Дополнение %s начало удаляться.",
    startInstall = "[1/3] Дополнение %s начало устанавливаться.",
    search = "[2/3] Пробуем найти %s в списке активных дополнений сервера.... (%s/10)",
    remove = "[3/3] Дополнение %s успешно было удалено.",
    intall = "[3/3] Дополнение %s успешно было установлено.",
}

--[[
    METHODS
]]--
function PLUGIN:Install(id)
    asterionlib.workshop:Add(id)
end

function PLUGIN:AddLog(type, array)
    self.logs[#self.logs + 1] = {
        type,
        array
    }

    local panel = Arbitrage.gui.workshop
    if !IsValid(panel) then return end

    local logger = panel.logger
    if logger then
        local info = PLUGIN.logsTypes[type]
        local data = info:format(unpack(array))

        logger:AppendText(data .. "\n")
        logger:GotoTextEnd()
    end
end


--[[
    NETSTREAMS
]]--
netstream.Hook("Workshop:List", function(data)
    for k, v in ipairs(data) do
        PLUGIN:Install(v)
    end
end)

netstream.Hook("Workshop:Install", function(id)
    PLUGIN:Install(id)
end)

netstream.Hook("WORKSHOP:AddLog", function(type, array)
    PLUGIN:AddLog(type, array)
end)

netstream.Hook("WORKSHOP:SuccessfullyStatus", function(state)
    local panel = Arbitrage.gui.workshop
    if !IsValid(panel) then return end

    if state == 1 then
        panel.requestAPI = true
    elseif state == 2 then
        panel.downloaderAPI = true
    end
end)

netstream.Hook("WORKSHOP:RequestList", function(array)
    PLUGIN.requestList = {}

    for k, v in ipairs(array) do
        PLUGIN.requestList[tonumber(v[2])] = true
    end
end)