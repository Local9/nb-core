--IMPORT--
if GetCurrentResourceName() ~= "nb-core" then --a must, otherwise function becomes table in main framework script
NB = exports['nb-core']:GetSharedObject()
load(LoadResourceFile("nb-core", 'com/selfishref/threads.lua'))()
end 
