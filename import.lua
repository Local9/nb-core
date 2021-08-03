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
		if source then 
			TriggerEvent('NB:OnPlayerRequestSpawn',source)
			TriggerClientEvent('NB:OnPlayerRequestSpawn',source)
		end 
	end)
	if OnPlayerRequestCharacter or IsNBScript then 
		RegisterNetEvent('NB:OnPlayerRequestCharacter', function(charid)
			if source then 
				OnPlayerRequestCharacter(source,charid)
			else 
				OnPlayerRequestCharacter(charid)
			end 
		end)
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
		local ticketClient = math.abs(GetGameTimer()*GetHashKey(tostring(GetCloudTimeAsInt()))*GetIdOfThisThread())
		a = RegisterNetEvent(resname..":ResultCallback"..tostring(math.abs(actionhashname/ticketClient+1)), function (...)
			if fn then fn(...) end 
			if a then  
				RemoveEventHandler(a)
			end 
		end)
		TriggerServerEvent(resname..":RequestCallback"..actionhashname,ticketClient,table.unpack(args))
	end 

end 
