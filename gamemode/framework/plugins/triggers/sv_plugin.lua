-- PLUGIN.triggers = {}
-- SetNetVar("Trigger:triggers",{})


-- netstream.Hook("Trigger:New", function(_, vector)
--     netstream.Start(nil,"Trigger:Test","Adolfus")
--     local oldT = GetNetVar("Trigger:triggers",{})
--     if #oldT > 29 then -- ## ОГРАНИЧЕНИЕ НА КОЛИЧЕСТВО ТРИГГЕРОВ
--         print("Слишком много триггеров")
--         return false
--     end
--     SetNetVar("Trigger:triggers",{})
--     table.Add(oldT,{points = {vector,vector + Vector(5,5,5)}})
--     SetNetVar("Trigger:triggers",oldT)
-- end)

-- netstream.Hook("Trigger:ChangePos", function(_, id, point, pos)
--     local trigT = GetNetVar("Trigger:triggers",{})
--     if trigT == {} then return false end
--     trigT[id][point] = pos
--     SetNetVar("Trigger:triggers",trigT)
-- end)