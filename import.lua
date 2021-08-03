local IsNBScript = GetCurrentResourceName() == "nb-core"  
local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 
local case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
local default = {} --default must put after cases when use
local switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,...)return a[{...}]end,__index=function(a,c)local d=false;if c and type(c)=="table"then for e=1,#c do local f=c[e]if f and b and f==b then d=true;break end end end;if d then return setmetatable({},{__call=function(a,g)default=setmetatable({},{__call=function(a,h)end})g()end})else return function()end end end})default=setmetatable({},{__call=function(a,b)if b and type(b)=="function"then b()end end})return a[b]end,__index=function(a,f)return setmetatable({},{__call=function(a,...)end})end})
local Split = function (s, delimiter) result = {};for match in (s..delimiter):gmatch("(.-)"..delimiter) do table.insert(result, match);end;return result;end
NB = (function()return exports['nb-core']:GetSharedObject()end)()
if IsShared() then 
	if Main then 
		Main()
	end 
	if OnPlayerRequestSpawn or IsNBScript then 
		RegisterNetEvent('NB:OnPlayerRequestSpawn', function()
			if source then 
				OnPlayerRequestSpawn(source)
			else 
				OnPlayerRequestSpawn()
			end 
		end)
	end
	if OnPlayerSpawn or IsNBScript then 
		RegisterNetEvent('NB:OnSpawnPlayer', function()
			if source then 
				OnPlayerSpawn(source)
			else 
				OnPlayerSpawn()
			end 
		end)
	end
	if OnPlayerText or IsNBScript then
		RegisterNetEvent('NB:OnPlayerText', function(message)
			if source then 
				OnPlayerText(source,message)
			else 
				OnPlayerText(message)
			end 
		end)
	end
	if OnPlayerCommandText or IsNBScript then
		RegisterNetEvent('NB:OnPlayerCommandText', function(cmd,args)
			if source then 
				OnPlayerCommandText(source,cmd,args)
			else 
				OnPlayerCommandText(cmd,args)
			end 
		end)
	end
end 
if IsServer() then 
	if OnPlayerDisconnect or IsNBScript then 
		RegisterNetEvent('NB:OnPlayerDisconnect', function(reason)
			OnPlayerDisconnect(reason)
		end)
	end
	if OnPlayerConnect or IsNBScript then 
		RegisterNetEvent('NB:OnPlayerConnect', function(name, setKickReason, deferrals)
			OnPlayerConnect(name, setKickReason, deferrals)
		end)
	end
end 
if IsShared() then 
	AddEventHandler('onResourceStop', function(resourceName)
		if GetCurrentResourceName() ~= resourceName then
			return 
		end
		if OnResourceExit then 
			OnResourceExit()
		end 	
	end)
	AddEventHandler('onResourceStart', function(resourceName)
		if GetCurrentResourceName() ~= resourceName then
			return 
		end
		if OnResourceInit then 
			OnResourceInit()
		end
	end)
end 