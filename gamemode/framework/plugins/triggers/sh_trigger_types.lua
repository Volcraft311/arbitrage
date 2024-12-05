-- Trigger:CreateType("TakeDamage",{
--     name = "Получение урона",
--     settings = {
--         {
--             id = "DamageCount",
--             name = "Получение урона",
--             type = "slider"
--         },
--         {
--             id = "Delay",
--             name = "Задержка",
--             type = "slider"
--         }
--     },
--     onEnter = function(client)
--     end,

--     onCanInteract = function(client)
--         return client:Alive()
--     end,

--     onExit = function(client)
--     end
-- })


Trigger:CreateType({
    name = "Тест",
    OnEnter = function(client)
        if CLIENT then
            print("Hello World")
        end
    end
})

Trigger:CreateType({
    name = "Adolfus",
    OnEnter = function(client)
        if CLIENT then
            print("Acthung")
        end
    end
})