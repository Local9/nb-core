local IsFrameworkScript = GetCurrentResourceName() == "nb-core"  
local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 
NB = (function()return exports['nb-core']:GetSharedObject()end)()

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