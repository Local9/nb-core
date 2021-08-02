
NB.TriggerServerCallback = function(actionname,fn,...)
	----https://github.com/negbook/ServerCallback
	local resname = GetCurrentResourceName()
	local a 
	local actionhashname = GetHashKey(actionname)
	
	local ticketClient = tostring(GetGameTimer())..tostring(GetHashKey(tostring(GetCloudTimeAsInt()))) .. tostring(GetIdOfThisThread())
	a = RegisterNetEvent(resname..":ResultCallback"..actionhashname..ticketClient, function (...)
		fn(...)
		if a then  
			RemoveEventHandler(a)
		end 
	end)
	TriggerServerEvent(resname..":RequestCallback"..actionhashname,ticketClient,...)
end 