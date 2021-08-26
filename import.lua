local function IsServer() return IsDuplicityVersion() end ;
local function IsClient() return not IsDuplicityVersion() end ;
local function IsShared() return true end ;

--IMPORT--
if GetCurrentResourceName() ~= "nb-core" then --a must, otherwise function becomes table in main framework script
NB = exports['nb-core']:GetSharedObject()
end 

--Shared Global Functions--
if IsShared() then 
	RollRandomSeed = NB.RandomSeed  
end 
if IsServer() then 
	RegisterServerCallback = NB.RegisterServerCallback 
	SendClientMessage = function(playerId, color, message)
		TriggerClientEvent('chat:addMessage',playerId, {
		  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
		  multiline = true,
		  args = {message}
		})
	end 

	SendClientMessageToAll = function(color,message)
		TriggerClientEvent('chat:addMessage',-1, {
		  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
		  multiline = true,
		  args = { message}
		})
	end 
end 
if IsClient() then 
	TriggerServerCallback = NB.TriggerServerCallback 
end 
