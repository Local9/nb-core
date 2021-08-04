local IsFrameworkScript = GetCurrentResourceName() == "nb-core"  
local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 
NB = (function()return exports['nb-core']:GetSharedObject()end)()

