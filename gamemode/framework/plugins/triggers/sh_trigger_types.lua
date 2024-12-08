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
        if SERVER then
            client:FallOver(2)
            Arbitrage.commands.PlayerSay(client, "/me упала с обрыва")
            timer.Simple(1,function()
                timer.Create("TriggerTest:IsOnGround",0.2,400,function()
                    if client:IsOnGround() then
                        Arbitrage.commands.PlayerSay(client, "/me сломала свою ногу")
                        client:AddTemporaryStatusEffect("broken_leg",20)
                        timer.Remove("TriggerTest:IsOnGround")
                    end
                end)
            end)
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