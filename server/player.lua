



function CreatePlayer(playerId, license)
	local self = {}
	self.playerId = playerId
	self.source = playerId
	self.license = license
	self.variables = {}
	
	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	return self
end

RegisterNetEvent('NB:OnPlayerJoined', function()
	local source = source
	local xPlayer = NB.GetPlayerFromId(source)
	if not NB.Players[source] then
		local source = source
		local license = com.game.license.GetLicense(source)
		print(license)
		if license then 
			NB.Utils.Remote.mysql_execute('SELECT id FROM players WHERE license = @license', {
				['@license'] = license
			}, function(result)
				
				if not result[1] then
					--[=[
					NB.Utils.Remote.mysql_execute('INSERT INTO players (license,position) VALUES (@license,@position)', {
						['@license'] = license,
						['@position'] = json.encode(DEFAULT_SPAWN_POSITION)
					}, function(result)
						print("Created player into database")
						NB.Players[source] = CreatePlayer(source, license)
						
					end )
					--]=]
					NB.SendClientMessageToAll(-1,"一個新玩家加入了服務器，正在進行選角")
					NB.Players[source] = CreatePlayer(source, license)
				else 
					NB.SendClientMessageToAll(-1,"一個老玩家加入了服務器，正在進行選角")
					NB.Players[source] = CreatePlayer(source, license)
					return NB.Players[source]
				end
			end)
		else 
			DropPlayer(playerId, 'Your license could not be found,the cause of this error is not known.')
			return false 
		end 
	end
	return false 
end)


NB.GetExpensivePlayerData = function(source,tablename,dataname,resultcb)
	local license = com.game.license.GetLicense(source)
	NB.Utils.Remote.mysql_execute('SELECT '..dataname..' FROM '..tablename..' WHERE license = @license', {
		['@license'] = license
	}, function(result)
		resultcb(result)
	end)
end 

NB.SetExpensivePlayerData = function(source,tablename,dataname,datas,...)
	local license = com.game.license.GetLicense(source)
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
		NB.Utils.Remote.mysql_execute('UPDATE '..tablename..' SET '..dataname..' = @'..dataname..' WHERE license = @license', {
			['@license'] = license,
			['@'..dataname..''] = covertDatas(datas)
		})

end 
