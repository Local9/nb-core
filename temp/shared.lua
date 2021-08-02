local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 
case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
default = {} --default must put after cases when use
switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,...)return a[{...}]end,__index=function(a,c)local d=false;if c and type(c)=="table"then for e=1,#c do local f=c[e]if f and b and f==b then d=true;break end end end;if d then return setmetatable({},{__call=function(a,g)default=setmetatable({},{__call=function(a,h)end})g()end})else return function()end end end})default=setmetatable({},{__call=function(a,b)if b and type(b)=="function"then b()end end})return a[b]end,__index=function(a,f)return setmetatable({},{__call=function(a,...)end})end})
Split = function (s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

if IsServer() then 
	TriggerSharedEvent = function(name,...)
		local args = {...}
		TriggerEvent(...)
		if source then 
			TriggerClientEvent(name,source,...)
		end 
	end 
	
	mysql_execute = function(...)
		return exports.ghmattimysql:execute(...)
	end 
	
	AddEventHandler('playerDropped', function (reason)
		TriggerEvent('NB:OnPlayerDisconnect',reason)
		TriggerEvent('NB:OnResourceExit',source)
	end)
	AddEventHandler('onResourceStart', function(resourceName)
		if (GetCurrentResourceName() == resourceName) then
			TriggerEvent('NB:OnResourceInit')
			return
		end
	end)
	AddEventHandler('onResourceStop', function(resourceName)
		if GetCurrentResourceName() == resourceName then
			TriggerEvent('NB:OnResourceExit')
			return
		end
	end)
	AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
		TriggerEvent('NB:OnPlayerConnect',name, setKickReason, deferrals)
	end )
end 

if IsClient() then 
	TriggerSharedEvent = function(name,...)
		local args = {...}
		TriggerEvent(name,...)
		TriggerServerEvent(name,...)
	end 
	
	CreateThread(function()
		SetThreadPriority(0)
		TriggerSharedEvent('NB:OnResourceInit')
		while not NetworkIsSessionStarted() do
			Wait(0)
		end
		TriggerSharedEvent('NB:OnPlayerSessionStart')
		return 
	end)
	CreateThread(function()
		while true do Citizen.Wait(1000)
			TriggerServerEvent('NB:SavePlayerPosition', GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
		end
	end)
	
	AddEventHandler('playerSpawned', function()
		TriggerSharedEvent('NB:OnSpawnPlayer')
	end)
	
	AddEventHandler('onResourceStop', function(resourceName)
		if GetCurrentResourceName() == resourceName then
			local threadId = GetIdOfThisThread()
			TerminateThisThread()
			N_0x4d953df78ebf8158()
			TriggerEvent('NB:OnResourceExit')
			return
		end
	end)
end 

--[=[
if IsShared() then 
	CreateThread(function()
		if Main then 
			Main()
		end 
	end)
	RegisterNetEvent('NB:OnPlayerSessionStart', function()
		if OnPlayerRequestSpawn then 
			if source then 
				OnPlayerRequestSpawn(source) 
			else 
				OnPlayerRequestSpawn() 
			end 
		end 
	end)

	RegisterNetEvent('NB:OnSpawnPlayer', function()
		if OnPlayerSpawn then 
			if source then 
				OnPlayerSpawn(source)
			else 
				OnPlayerSpawn()
			end 
		end 
	end)
	
	RegisterNetEvent('NB:OnResourceInit', function()
		if OnResourceInit then 
			if source then 
				OnResourceInit(source)
			else 
				OnResourceInit()
			end 
		end 	
	end)
	
	RegisterNetEvent('NB:OnResourceExit', function()
		if OnResourceExit then 
			if source then 
				OnResourceExit(source)
			else 
				OnResourceExit()
			end 
		end 
	end)
end 

if IsServer() then 
	RegisterNetEvent('NB:OnPlayerDisconnect', function(reason)
		if OnPlayerDisconnect then 
			OnPlayerDisconnect(reason)
		end 
	end)
	
	RegisterNetEvent('NB:OnPlayerConnect', function(name, setKickReason, deferrals)
		if OnPlayerConnect then 
			OnPlayerConnect(name, setKickReason, deferrals)
		end 
	end)
	AddEventHandler('chatMessage', function(source, name, message)
		if string.sub(message, 1, string.len("/")) ~= "/" then
			
		else 
			if OnPlayerCommandText then 
				if source then 
					local full = Split(message:sub(2)," ")
					local cmd = full[1] 
					table.remove(full,1)
					local args = full
					OnPlayerCommandText(source,cmd,args)
				end 
			end 
		end 
	end)
end 

if IsClient() then 
	RegisterNetEvent('chat:addMessage', function(msg)
		local message = msg.args[2]
		if string.sub(message, 1, string.len("/")) ~= "/" then
			
		else 
			if OnPlayerCommandText then 
				local full = Split(message:sub(2)," ")
				local cmd = full[1] 
				table.remove(full,1)
				local args = full
				OnPlayerCommandText(cmd,args)
			end 
		end 
	end)
end 

--]=]