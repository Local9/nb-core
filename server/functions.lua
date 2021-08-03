NB.RegisterServerCallback = function(actionname,fn)
	----https://github.com/negbook/ServerCallback
	local resname = GetCurrentResourceName()
	local actionhashname = GetHashKey(actionname)
	local eventName,a = resname..":RequestCallback"..actionhashname
	a = RegisterNetEvent(eventName, function (ticketClient,...) --client send datas into ...
		local source_ = source 
		local ticketServer =  tostring(GetGameTimer())..tostring(GetHashKey(tostring(os.time()))) 
		local eventWithTicket,b = eventName .. ticketClient .. ticketServer
		if source_ then eventWithTicket = eventWithTicket .. tostring(source_)..tostring(GetHashKey(GetPlayerName(source_))) 
			b = RegisterNetEvent(eventWithTicket, function (ticketCl,...)
				local c = function(...)
					TriggerClientEvent(resname..":ResultCallback"..actionhashname..ticketCl,source_,...)
				end 
				if fn then fn(source_,c,...) end 
				if b then 
					RemoveEventHandler(b)
				end 
				if NB.RegisterServerCallback  then NB.RegisterServerCallback (actionname,fn) end 
			end) 
			TriggerEvent(eventWithTicket,ticketClient,...)
		end 
		if a then 
			RemoveEventHandler(a)
		end 
	end)
end 

NB.GetExpensivePlayerDataLongText = function(source,tablename,dataname,resultcb)
	mysql_execute('SELECT '..dataname..' FROM '..tablename..' WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source)
    }, function(result)
        resultcb(result)
    end)
end 

NB.SetExpensivePlayerDataLongText = function(source,tablename,dataname,...)
	local datas = {...}
	mysql_execute('UPDATE '..tablename..' SET '..dataname..' = @'..dataname..' WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source),
        ['@'..dataname..''] = '{ ' .. table.concat(datas,",").. '}'
    })
end 