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
	local ticketClient = tostring(GetGameTimer())..tostring(GetHashKey(tostring(GetCloudTimeAsInt()))) .. tostring(GetIdOfThisThread())
	a = RegisterNetEvent(resname..":ResultCallback"..actionhashname..ticketClient, function (...)
		if fn then fn(...) end 
		if a then  
			RemoveEventHandler(a)
		end 
	end)
	TriggerServerEvent(resname..":RequestCallback"..actionhashname,ticketClient,table.unpack(args))
end 
