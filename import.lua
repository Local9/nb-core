if GetCurrentResourceName() ~= "nb-core" then --a must, otherwise function becomes table in main framework script
NB = (function()return exports['nb-core']:GetSharedObject()end)()
end 