NB.RegisterServerCallback = ESX.RegisterServerCallback 


NB.SendClientMessage = function(source, color, message)
	TriggerClientEvent('chat:addMessage',source, {
	  color = color == -1 and 255 or HexToRGB2(color),
	  multiline = true,
	  args = {message}
	})
end 

NB.SendClientMessageToAll = function(color,message)
	TriggerClientEvent('chat:addMessage',-1, {
	  color = color == -1 and 255 or HexToRGB2(color),
	  multiline = true,
	  args = { message}
	})
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