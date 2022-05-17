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


local BASE = ItemBase.GetBase()

BASE.name = "База Блокнотов"
BASE.description = ""
BASE.category = "Библиотека"
BASE.data = {font = 1, editors = {}, pages = {{
    title = "Заголовок",
    text = "Ваш текст..."
}}}

local function HasAccess(arr, data)
    if !arr then return false end

    if IsValid(data) and data:IsPlayer() then
        data = data:SteamID()
    end

    return arr[data] and true or false
end

local function AddNewPage(item)
    local data = item.data

    item.data.pages[#data.pages + 1] = {
        title = "Заголовок",
        text = "Ваш текст..."
    }
end

local function AutoAddEditor(item, client)
    if table.Count(item.data.editors) <= 0 then
        item.data.editors[client:SteamID()] = true
    end
end

local function OpenNote(item, client, page, bEdit, bClose)
    local info = item.data.pages[page]
    if !info then return end

    local data = {
        editors = item.data.editors,
        title = info.title,
        text = info.text,
        page = page,
        pages = #item.data.pages,
        entity = item,
        edit = bEdit and true or false,
        font = item.data.font,
        itemID = item:GetID()
    }

    if bClose then
        asterionlib.netgui:Close(client, "ItemBase:OpenNote")
    end

    asterionlib.netgui:Get(client, "ItemBase:OpenNote", "IsValid", function(bState)
        if bState then
            asterionlib.netgui:Call(client, "ItemBase:OpenNote", "SetData", data, bEdit)
        else
            asterionlib.netgui:Create(client, "ItemBase:OpenNote", nil, "SetData", data, bEdit)
        end
    end)
end

local function ReadNote(item, client, page, bClose)
    OpenNote(item, client, page, false, bClose)
end

local function EditNote(item, client, page, bClose)
    if !HasAccess(item.data.editors, client) then return end

    OpenNote(item, client, page, true, bClose)
end

BASE:AddAction("Прочитать", {
    OnRun = function(item)
        local client = item.player

        ReadNote(item, client, 1)

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

BASE:AddAction("Изменить", {
    OnRun = function(item)
        local client = item.player

        AutoAddEditor(item, client)
        EditNote(item, client, 1)

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

if SERVER then
    local actionList = {
        ["CHANGE_PAGE"] = function(client, item, data)
            local page = data[1]
            local bEdit = data[2]

            if bEdit then
                if !HasAccess(item.data.editors, client) then return end

                EditNote(item, client, page)
            else
                ReadNote(item, client, page)
            end
        end,
        ["SAVE_PAGE"] = function(client, item, data)
            local page = data[1]
            local title = data[2]
            local text = data[3]

            if !item.data.pages[page] then return end
            if !HasAccess(item.data.editors, client) then return end
            if utf8.len(title) > NOTE_SIZE_TITLE then return end
            if utf8.len(text) > NOTE_SIZE_TEXT then return end

            item.data.pages[page].title = title
            item.data.pages[page].text = text

            netstream.Start(client, "arb.Notify", "Вы успешно сохранили страницу №" .. page .. "!", false)
        end,
        ["DELETE_PAGE"] = function(client, item, data)
            local page = data[1]

            if !HasAccess(item.data.editors, client) then return end

            local last_page = #item.data.pages
            if last_page <= 1 then return end

            item.data.pages[last_page] = nil

            if last_page == page then
                EditNote(item, client, page - 1, true)
            else
                EditNote(item, client, page)
            end

            netstream.Start(client, "arb.Notify", "Вы успешно удалили страницу №" .. last_page .. "!", false)
        end,
        ["CREATE_PAGE"] = function(client, item, data)
            local page = data[1]

            if !HasAccess(item.data.editors, client) then return end
            if #item.data.pages >= NOTE_MAX_PAGES then return end

            AddNewPage(item)
            EditNote(item, client, page)

            netstream.Start(client, "arb.Notify", "Вы успешно создали страницу №" .. #item.data.pages .. "!", false)
        end,
        ["READ_PAGE"] = function(client, item, data)
            local page = data[1]

            if !HasAccess(item.data.editors, client) then return end

            ReadNote(item, client, page, true)
        end,
        ["REMOVE_EDITOR"] = function(client, item, data)
            local editor = data[1]

            if !HasAccess(item.data.editors, client) then return end

            item.data.editors[editor] = nil
        end,
        ["ADD_EDITOR"] = function(client, item, data)
            local steamid = data[1]

            if !steamid then return end
            if !string.find(steamid, "STEAM_") then return end
            if !HasAccess(item.data.editors, client) then return end

            item.data.editors[steamid] = true
        end,
        ["CHANGE_FONT"] = function(client, item, data)
            local page = data[1]
            local font = data[2]

            if !HasAccess(item.data.editors, client) then return end
            if !NOTE_FONTS[font] then return end

            item.data.font = font

            EditNote(item, client, page, true)
        end,
        ["CHANGE_TAKE"] = function(client, item)
        	local bTake = !item:GetData("disableTake", false)
        	item:SetData("disableTake", bTake)

        	netstream.Start(client, "arb.Notify", "Вы " .. (bTake and "запретили" or "разрешили") .. " поднимать блокнот!", false)
        end
    }

    netstream.Hook("ItemBase:NoteAction", function(client, name, itemID, ...)
        local data = {...}

        local item = ItemBase.instances[itemID]
        if !item then return end

        local entity = item:GetEntity()
        if IsValid(entity) then
            if entity:GetClass() != "arb_item" then return end
            if entity:GetPos():DistToSqr(client:GetPos()) >= 25000 then return end
        else
            local inventory = item:GetInventory()
            if !inventory then return end
            if !inventory:IsReceiver(client) then return end
        end

        if actionList[name] then
            actionList[name](client, item, data)
        end
    end)
end


ItemBase:RegisterBase("base_note", BASE)


NOTE_MAX_EDITORS = 30
NOTE_MAX_PAGES = 15
NOTE_SIZE_TITLE = 32
NOTE_SIZE_TEXT = 5000

NOTE_FONTS = {
    [1] = {
        name = "Baskerville WGL4 BT",
        font = "arb.Font_BaskervilleWGL4BT_"
    },
    [2] = {
        name = "Open Sans",
        font = "arb.Font_OpenSansLight_"
    },
    [3] = {
        name = "Futura PT Book",
        font = "arb.Font_FuturaPTBook_"
    },
    [4] = {
        name = "Futura PT Demi",
        font = "arb.Font_FuturaPTDemi_"
    },
    [5] = {
        name = "Roboto",
        font = "arb.Font_Roboto_"
    }
}