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
	
	CreateThread(function()
		if Main then 
			Main()
		end 
	end)
	RegisterNetEvent('NB:OnPlayerSessionStart', function()
		if source and IsServer() then 
			TriggerEvent('NB:OnPlayerRequestSpawn',source)
			TriggerClientEvent('NB:OnPlayerRequestSpawn',source)
		end 
	end)
	local OnPlayerRequestCharacter_event = 
	RegisterNetEvent('NB:OnPlayerRequestCharacter', function(charid)
		if OnPlayerRequestCharacter or IsNBScript then 
			if source and IsServer() then 
				OnPlayerRequestCharacter(source,charid)
			else 
				OnPlayerRequestCharacter(charid)
			end 
			print("OnPlayerRequestCharacter",GetCurrentResourceName(),IsServer())
		else 
			RemoveEventHandler(OnPlayerRequestCharacter_event)
		end
	end)
	
	
	local OnPlayerRequestSpawn_event =	
	RegisterNetEvent('NB:OnPlayerRequestSpawn', function()
		if OnPlayerRequestSpawn or IsNBScript then 
		if source and IsServer() then 
			OnPlayerRequestSpawn(source)
		else 
			OnPlayerRequestSpawn()
		end 
		print("OnPlayerRequestSpawn",GetCurrentResourceName(),IsServer())
		else 
			RemoveEventHandler(OnPlayerRequestSpawn_event)
		end
	end)
	
	
	local OnPlayerSpawn_event =	RegisterNetEvent('NB:OnSpawnPlayer', function()
		if OnPlayerSpawn or IsNBScript then 
			if source and IsServer() then 
				OnPlayerSpawn(source)
			else 
				OnPlayerSpawn()
			end 
			print("OnPlayerSpawn",GetCurrentResourceName(),IsServer())
		else 
			RemoveEventHandler(OnPlayerSpawn_event)
		end
	end)
	
	
	local OnPlayerText_event =	RegisterNetEvent('NB:OnPlayerText', function(message)
			if OnPlayerText or IsNBScript then
				if source and IsServer() then 
					OnPlayerText(source,message)
				else 
					OnPlayerText(message)
				end 
				print("OnPlayerText",GetCurrentResourceName(),IsServer())
			else 
				RemoveEventHandler(OnPlayerText_event)
			end
		end)
	
	
	local OnPlayerCommandText_event =	RegisterNetEvent('NB:OnPlayerCommandText', function(cmd,args)
			if OnPlayerCommandText or IsNBScript then
				if source and IsServer() then 
					OnPlayerCommandText(source,cmd,args)
				else 
					OnPlayerCommandText(cmd,args)
				end 
				print("OnPlayerCommandText",GetCurrentResourceName(),IsServer())
			else 
				RemoveEventHandler(OnPlayerCommandText_event)
			end
		end)
	
end 
if IsServer() then 
	
	local OnPlayerDisconnect_event =	RegisterNetEvent('NB:OnPlayerDisconnect', function(reason)
		if OnPlayerDisconnect or IsNBScript then 
			OnPlayerDisconnect(reason)
			print("OnPlayerDisconnect",GetCurrentResourceName(),IsServer())
		else 
			RemoveEventHandler(OnPlayerDisconnect_event)
		end
	end)
	
	
	local OnPlayerConnect_event =	RegisterNetEvent('NB:OnPlayerConnect', function(name, setKickReason, deferrals)
		if OnPlayerConnect or IsNBScript then 
			OnPlayerConnect(name, setKickReason, deferrals)
			print("OnPlayerConnect",GetCurrentResourceName(),IsServer())
		else 
			RemoveEventHandler(OnPlayerConnect_event)
		end
	end)
	
end 
if IsShared() then 
	AddEventHandler('onResourceStop', function(resourceName)
		if GetCurrentResourceName() ~= resourceName then
			return 
		end
		if OnResourceExit then 
			OnResourceExit()
			print("OnResourceExit",GetCurrentResourceName(),IsServer())
		end 	
	end)
	AddEventHandler('onResourceStart', function(resourceName)
		if GetCurrentResourceName() ~= resourceName then
			return 
		end
		if OnResourceInit then 
			OnResourceInit()
			print("OnResourceInit",GetCurrentResourceName(),IsServer())
		end
	end)
end 



if IsServer() then 
	NB.RegisterServerCallback = function(actionname,fn)
		----https://github.com/negbook/ServerCallback
		local resname = GetCurrentResourceName()
		local actionhashname = GetHashKey(actionname)
		local eventName,a = resname..":RequestCallback"..actionhashname
		a = RegisterNetEvent(eventName, function (ticketClient,...) --client send datas into ...
			local source_ = source 
			local ticketServer =  math.abs(GetGameTimer()*GetHashKey(tostring(os.time()))) 
			local eventWithTicket,b = math.abs(GetHashKey(eventName)*ticketClient/(ticketServer+1))
			local sender = function(...) 
				TriggerEvent(eventWithTicket,ticketClient,...) 
			end 
			if source_ then eventWithTicket = tostring(source_)..tostring(eventWithTicket*GetHashKey(GetPlayerName(source_))) 
				
				b = RegisterNetEvent(eventWithTicket, function (ticketCl,...)
					local c = function(...)
						TriggerClientEvent(resname..":ResultCallback"..tostring(math.abs(actionhashname/ticketCl+1)),source_,...)
					end 
					if fn then fn(source_,c,...) end 
					if b then 
						RemoveEventHandler(b)
					end 
					if NB.RegisterServerCallback  then NB.RegisterServerCallback (actionname,fn) end 
				end) 
				sender(...)
			end 
			if a then 
				RemoveEventHandler(a)
			end 
		end)
	end 
end 
if IsClient() then 
	
	NB.TriggerServerCallback = function(actionname,...)
		----https://github.com/negbook/ServerCallback
		local resname = GetCurrentResourceName()
		local a 
		local actionhashname = GetHashKey(actionname)
		local args = {...}
		local fn = args[1] 
		if fn and type(fn) == 'function' then 
			table.remove(args,1)
		end 
		local ticketClient = math.abs(GetGameTimer()*GetHashKey(tostring(GetCloudTimeAsInt())))
		a = RegisterNetEvent(resname..":ResultCallback"..tostring(math.abs(actionhashname/ticketClient+1)), function (...)
			if fn then fn(...) end 
			if a then  
				RemoveEventHandler(a)
			end 
		end)
		TriggerServerEvent(resname..":RequestCallback"..actionhashname,ticketClient,table.unpack(args))
	end 
end 



















if IsClient() then 
	NB.RegisterClientCallback = function(actionname,fn)
		----https://github.com/negbook/ClientCallback
		local resname = GetCurrentResourceName()
		local actionhashname = GetHashKey(actionname)
		local eventName,a = resname..":RequestCallback"..actionhashname
		a = RegisterNetEvent(eventName, function (ticketServer,...) --Client send datas into ...
			local source_ = PlayerId() 
			local ticketClient =  math.abs(GetGameTimer()*GetHashKey(tostring(GetCloudTimeAsInt()))*GetIdOfThisThread()) 
			local eventWithTicket,b = math.abs(GetHashKey(eventName)*ticketServer/(ticketClient+1))
			local sender = function(...) 
				TriggerEvent(eventWithTicket,ticketServer,...) 
			end 
			if source_ then eventWithTicket = tostring(source_)..tostring(eventWithTicket*GetHashKey(GetPlayerName(source_))) 
				
				b = RegisterNetEvent(eventWithTicket, function (ticketCl,...)
					local c = function(...)
						TriggerServerEvent(resname..":ResultCallback"..tostring(math.abs(actionhashname/ticketCl+1)),...)
					end 
					if fn then fn(c,...) end 
					if b then 
						RemoveEventHandler(b)
					end 
					if NB.RegisterClientCallback  then NB.RegisterClientCallback (actionname,fn) end 
				end) 
				sender(...)
			end 
			if a then 
				RemoveEventHandler(a)
			end 
		end)
	end 
end 

if IsServer() then 
	
	NB.TriggerClientCallback = function(actionname,player,...)
		----https://github.com/negbook/ClientCallback
		local resname = GetCurrentResourceName()
		local a 
		local actionhashname = GetHashKey(actionname)
		local args = {...}
		local fn = args[1] 
		if fn and type(fn) == 'function' then 
			table.remove(args,1)
		end 
		local ticketServer = math.abs(GetGameTimer()*GetHashKey(tostring(os.time())))
		a = RegisterNetEvent(resname..":ResultCallback"..tostring(math.abs(actionhashname/ticketServer+1)), function (...)
			if fn then fn(...) ; player = source end 
			if a then  
				RemoveEventHandler(a)
			end 
		end)
		TriggerClientEvent(resname..":RequestCallback"..actionhashname,player,ticketServer,table.unpack(args))
	end 
end 