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
	local ticketClient = NB._temp_.Currentticket
	NB._temp_.Currentticket = NB._temp_.Currentticket + 1
	if NB._temp_.Currentticket > 65534 then 
		NB._temp_.Currentticket = 1
	end 
	a = RegisterNetEvent(resname..":ResultCallback"..tostring(ticketClient), function (...)
		if fn then fn(...) end 
		if a then  
			RemoveEventHandler(a)
		end 
	end)
	
	TriggerServerEvent(resname..":RequestCallback"..actionhashname,ticketClient,table.unpack(args))
	
end 
