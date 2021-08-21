NB["_LOCAL_"].thisPlayerId = -1

NB.GetPlayers = function(id)
	return not id and NB.Players or NB.Players[id]
end

NB.UpdatePlayerId = function(playerId)
	if tonumber(playerId) then 
		NB["_LOCAL_"].thisPlayerId = tonumber(playerId)
	end 
	local playerId = NB["_LOCAL_"].thisPlayerId
	return playerId,NB.GetPlayers(playerId)
end

NB.PlayerId = function(playerId)
	local playerid,playerdata = NB.UpdatePlayerId(playerId)
	return playerid,playerdata
end 

NB.PlayerData = function(playerId)
	local playerid, playerdata = NB.UpdatePlayerId(playerId)
	return playerdata,playerid
end 

NB.SetPlayer = function(value)
	NB.Players[NB.PlayerId()] = value
end 

NB.ReleasePlayer = function()
	NB.Players[NB.PlayerId()] = nil 
end



NB.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(NB.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

function CreatePlayer(playerId, license,citizenID)
	local self = {}
	self.playerId = playerId
	self.PlayerId = playerId
	self.source = playerId
	self.license = license
	self.variables = {}
	self.citizenID = citizenID
	self.triggerEvent = function(eventName, ...)
		NB.TriggerClientEvent(eventName, self.source, ...)
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

function DB_IsUserExist(license)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM users WHERE license = @license', {
		['@license'] = license
	})
	local r = not not (result and result > 0)
	return r
end 

function DB_IsCharacterExist(citizenID)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM characters WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	local r = not not (result and result > 0)
	return r 
end 

function DB_GetCharacterLicense(citizenID)
	--'SELECT u.license FROM users u inner join characters s on u.citizen_id = s.citizen_id WHERE u.citizen_id = @citizen_id'
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT license FROM characters WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	return result and result or nil
end 

function DB_GetCharactersByLicense(license,idx)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT citizen_id FROM characters WHERE license = @license', {
		['@license'] = license
	})
	if idx then 
		return result and result[idx] and result[idx].citizen_id or nil
	else
		return result or nil 
	end 
end 



NB.RegisterNetEvent('NB:OnPlayerJoined', function() --called by com.game.session.spawn.lua/CreateThread
	local playerdata,playerId = NB.PlayerData(source)
	if not playerdata then
		local license = com.game.Server.License.Get(playerId)
		if license then 
			if not DB_IsUserExist(license) then
				
				NB.SendClientMessageToAll(-1,"一個新玩家加入了服務器，正在進行選角")
				local citizenID = NB.UserSomethingSeriousGenerator('citizen_id','characters',function()return tostring(com.lua.utils.Text.Generator(7) .. com.lua.utils.Math.Generator(9)):upper()end)
				NB.SetPlayer(CreatePlayer(playerId, license, citizenID))
				if OnPlayerRegister then OnPlayerRegister(playerId, license, citizenID) end 
				return NB.GetPlayers(playerId)
			else 
				
				NB.SendClientMessageToAll(-1,"一個老玩家加入了服務器，正在進行選角")
				local citizenID = DB_GetCharactersByLicense(license,1)
				NB.SetPlayer(CreatePlayer(playerId, license, citizenID))
				if OnPlayerLogin then OnPlayerLogin(playerId, license, citizenID) end 
				return NB.GetPlayers(playerId)
			end
			
		else 
			DropPlayer(playerId, 'Your license could not be found,the cause of this error is not known.')
			return false 
		end 
	end
	return false 
end)

NB.GetCheapCitizenData = function(citizenID,tablename,dataname)
	return NB.Cache.GetPropSlotValue("CITIZEN",citizenID,tablename,dataname) or NB.GetExpensiveCitizenData(citizenID,tablename,dataname)
end 

NB.GetExpensiveCitizenData = function(citizenID,tablename,dataname)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT '..dataname..' FROM '..tablename..' WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	local t = json.decodetable(result)
	NB.Cache.SetPropSlotValue("CITIZEN",citizenID,tablename,dataname,t)
	return t 
end 

NB.SaveAllCacheCitizenDataIntoMysql = function(citizenID)
	if NB["_CACHE_"] and NB["_CACHE_"].CITIZEN then 
		local tasks = {}
		local forcedcitizenID = not (citizenID == nil)
		for citizenidstr,tablenames in pairs(NB["_CACHE_"].CITIZEN) do 
			if (forcedcitizenID and citizenidstr == citizenID) or (not forcedcitizenID) then 
				for tablename,datanames in pairs(tablenames) do 
					--for dataname,data in pairs(datanames) do 
						if not NB.Cache.IsPropValueExist("CITIZEN",citizenidstr,tablename,"DontSaveToDatabase") then --dont save the table slots 
							local task = function(cb)
									NB.SetExpensiveCitizenData(citizenidstr,tablename,datanames)
									--print(citizenidstr,tablename,dataname,data)
								cb("Async")
							end
							table.insert(tasks, task)
						end 
					--end 
				end 
			end 
		end 
		NB.Async.series(tasks,function(result) end)
	end 
end 

CreateThread(function()
	Wait(10000)
	while true do 
		NB.SaveAllCacheCitizenDataIntoMysql()
		Wait(600000)
	end 
end )





NB.SetCheapCitizenData = function(citizenID,tablename,dataname,datas,dontSaveSql)
	if dontSaveSql then 
		NB.Cache.SetPropSlotValue("CITIZEN",citizenID,tablename,"DontSaveToDatabase",true)
	end 
	NB.Cache.SetPropSlotValue("CITIZEN",citizenID,tablename,dataname,datas)
end 

NB.SetExpensiveCitizenData = function(citizenID,tablename,dataname,datas,...)
	
	local covertDatas = function(cdata)
		if cdata then 
			if type(cdata) == 'table' then 
				return json.encode(cdata)
			else 
				return tostring(cdata)
			end 
		end 
	end 
	if type(dataname) == 'table' then 
		local querys = {}
		local datadefines = {
			['@citizen_id'] = citizenID
		}
		for dataname_,data_ in pairs(dataname) do 
			table.insert(querys,dataname_..' = @'..dataname_)
			datadefines['@'..dataname_..''] = covertDatas(data_)
		end 
		querys = table.concat(querys,",")
		
		NB.Utils.Remote.mysql_execute('UPDATE '..tablename..' SET '..querys..' WHERE citizen_id = @citizen_id', datadefines)
	else 
		local otherargs = {...}
		local datas = datas 
		if #otherargs > 0 then 
			datas = {datas[1],...}
		end 
		NB.Utils.Remote.mysql_execute('UPDATE '..tablename..' SET '..dataname..' = @'..dataname..' WHERE citizen_id = @citizen_id', {
			['@citizen_id'] = citizenID,
			['@'..dataname..''] = covertDatas(datas)
		})
	end 
	
end 

NB.UserSomethingSeriousGenerator = function(name,tablename,checkfn)
	local SomethingExist = false
	local Something = nil

	while not SomethingExist do
		Something = checkfn(name)
		if not Something then error("error on creating player something",2) end 
		local result = NB.Utils.Remote.mysql_execute_sync('SELECT COUNT(*) as count FROM '..tablename..' WHERE '..name..'=@'..name..'', {['@'..name..''] = Something})
		if result[1].count == 0 then
			SomethingExist = true
		end
	end
	return Something
end

NB.RegisterNetEvent('NB:SavePlayerPosition', function(coords,heading)
	if coords and heading then 
		local x, y, z = table.unpack(coords)
		local playerData = NB.PlayerData(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			NB.SetCheapCitizenData(citizenID,'characters','position',{x=x,y=y,z=z,heading=heading})
			--NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] position Saved")
		end 
	end 
end) 


NB.RegisterNetEvent("NB:SaveCharacterSkin",function(result)
	local playerData = NB.PlayerData(playerid)
	local citizenID = playerData.citizenID 
	if citizenID and result then 
		NB.SetCheapCitizenData(citizenID,'characters','Skin',result)
		NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] Skin Saved",true)
	end 
end )



NB.RegisterServerCallback("NB:GetLastPosition",function(playerId,cb)
	local playerData = NB.PlayerData(playerId)
	local citizenID = playerData.citizenID 
	local pos = NB.GetCheapCitizenData(citizenID,'characters','position')
	if pos then 
		cb(vector3(pos.x, pos.y, pos.z), pos.heading)
		--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
	end 
end )

