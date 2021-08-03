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

NB.GetExpensivePlayerData = function(source,tablename,dataname,resultcb)
	mysql_execute('SELECT '..dataname..' FROM '..tablename..' WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source)
    }, function(result)
        resultcb(result)
    end)
end 

NB.SetExpensivePlayerData = function(source,tablename,dataname,datas,...)
	local otherargs = {...}
	local datas = datas 
	if #otherargs > 0 then 
		datas = {datas[1],...}
	end 
	local covertDatas = function(datas)
		if datas then 
			local test_ = {}
			local datatype = 0
			if type(datas) == 'table' then 
				datatype = 1
				for i,v in pairs(datas) do 
					table.insert(test_,i)
				end 
				for i=1,#test_ do 
					if test_[i] == i then 
					else 
						datatype = 2
						break 
					end 
				end 
				
				--return '{' .. table.concat(t_,",").. '}'
			else 
				datatype = 0
				--return datas
			end 
			if datatype == 2 then 
				local t_ = {} 
				for i,v in pairs(datas) do 
					table.insert(t_,'"'..i..'"'..":"..v)
				end 
				return '{' .. table.concat(t_,",").. '}'
			elseif datatype == 1 then 
				local t_ = {} 
				for i=1,#datas do 
					table.insert(t_,datas[i])
				end 
				return '{' .. table.concat(t_,",").. '}'
			else 
				return datas
			end 
		end 
	end 
	mysql_execute('UPDATE '..tablename..' SET '..dataname..' = @'..dataname..' WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source),
        ['@'..dataname..''] = covertDatas(datas)
    })
end 