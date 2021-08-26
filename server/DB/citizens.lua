DB.Citizen.GetData = function (citizenID)
	if not NB.Cache.IsExist("CITIZEN",citizenID) then 
		NB.Cache.Set("CITIZEN",citizenID,{})
	end 
	return NB.Cache.Get("CITIZEN",citizenID)
end 
DB.Citizen.IsExist = function (citizenID)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM citizens WHERE citizen_id = ?', {
		citizenID
	})
	local r = not not (result and result > 0)
	return r 
end 
DB.Citizen.GetLicense = function (citizenID)
	--'SELECT u.license FROM users u inner join citizens s on u.citizen_id = s.citizen_id WHERE u.citizen_id = @citizen_id'
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT license FROM citizens WHERE citizen_id = ?', {
		citizenID
	})
	return result and result or nil
end 
DB.Citizen.GetIDFromLicense = function (license,idx)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT citizen_id FROM citizens WHERE license = ?', {
		 license
	})
	if idx then 
		return result and result[idx] and result[idx].citizen_id or nil
	else
		return result or nil 
	end 
end 
DB.Citizen.SqlToCache = function(citizenID,tablename,dataslot)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT '..dataslot..' FROM '..tablename..' WHERE citizen_id = ?', {
		citizenID
	})
	local t = json.decodetable(result)
	NB.Cache.Set("CITIZEN",citizenID,tablename,dataslot,t)
	return t 
end 
DB.Citizen.CacheToSql = function(citizenID,tablename,dataslot)
	local covertDatas = function(cdata)
		if cdata then 
			if type(cdata) == 'table' then 
				return json.encode(cdata)
			else 
				return tostring(cdata)
			end 
		end 
	end 
	if type(dataslot) == 'table' then 
		local querys = {}
		local datadefines = {
			 citizenID
		}
		for dataslot_,data_ in pairs(dataslot) do 
			table.insert(querys,dataslot_..' = ?')
			table.insert(datadefines,covertDatas(data_))
		end 
		querys = table.concat(querys,",")
		NB.Utils.Remote.mysql_execute('UPDATE '..tablename..' SET '..querys..' WHERE citizen_id = ?', datadefines)
	end 
end 
DB.Citizen.AllCachesToSql = function(citizenID,isClear)
	if NB["_CACHE_"] and NB["_CACHE_"]["CITIZEN"] then 
		local CITIZENTABLE = NB["_CACHE_"]["CITIZEN"]
		local tasks = {}
		if citizenID then 
			for tablename,citizendata in pairs(CITIZENTABLE[citizenID]) do 
				local task = function(cb)
						DB.Citizen.CacheToSql(citizenID,tablename,citizendata)
						--print(citizenidstr,tablename,dataslot,data)
					cb({citizenID = citizenID,result = "Async Saving "..citizenID.." "..tablename.." "..json.encode(citizendata).." Okay"})
				end
				table.insert(tasks, task)
			end 
		else 
			for citizenidstr,CITIZENSLOT in pairs(CITIZENTABLE) do 
				for tablename,citizendata in pairs(CITIZENSLOT) do 
					local task = function(cb)
							DB.Citizen.CacheToSql(citizenidstr,tablename,citizendata)
							--print(citizenidstr,tablename,dataslot,data)
						cb({citizenID = citizenidstr,result = "Async Saving "..citizenidstr.." "..tablename.." "..json.encode(citizendata).." Okay"})
					end
					table.insert(tasks, task)
				end 
			end 
		end 
		NB.Async.series(tasks,function(results) 
			for i=1,#results do 
				if isClear then 
					print('Citizen '..results[i].citizenID..' Data is saved and cleared.\n:',results[i].result)
					NB.DeleteCitizenDataCache(results[i].citizenID)
				else 
					print('Citizen '..results[i].citizenID..' Data is saved.\n:',results[i].result)
				end 
			end 
			
			
		end)
	end 
end 
DB.Citizen.Create = function(citizenID,license,cb)
	NB.Utils.Remote.mysql_execute('INSERT INTO citizens (citizen_id,license,packeddata) VALUES (?,?,?)', {
		citizenID,
		license,
		json.encode({position=DEFAULT_SPAWN_POSITION})
	}, function(result)
		print("Created a character into database")
		--NB.Cache.Set("CITIZEN",citizenID,{})
		cb(DB.Citizen.GetData(citizenID))
	end )
end 
CreateThread(function()
	Wait(10000)
	NB.Threads.CreateLoop("saveAllCacheDB",60000,function()
		DB.Citizen.AllCachesToSql()
	end)
end )

NB.DeleteCitizenDataCache = function(...)
	return NB.Cache.Clear("CITIZEN",...)
end 

NB.GetCitizenDataCache = function(citizenID,tablename,dataslot)
	return NB.Cache.Get("CITIZEN",citizenID,tablename,dataslot) or DB.Citizen.SqlToCache(citizenID,tablename,dataslot)
end 
NB.SetCitizenDataCache = function(citizenID,tablename,dataslot,datas)
	--[=[
	if type(datas) == "string" then 
		datas = string.format("%q", datas)
	elseif type(datas) == 'table' then 
		for i,v in pairs(datas) do 
			if type(v) == "string" then 
				datas[i] = string.format("%q", v)
			end 
		end 
	end 
	--]=]
	NB.Cache.Set("CITIZEN",citizenID,tablename,dataslot,datas)
end 
--NB.SetCitizenDataCache("NFGT9NI218846462","citizens","test",'WHERE 1=1 --')
NB.GetCitizenPackedDataCache = function(citizenID,tablename,dataslot,isCompress)
	local pd = NB.Cache.Get("CITIZEN",citizenID,tablename,"packeddata",dataslot)
	local r = pd or DB.Citizen.SqlToCache(citizenID,tablename,"packeddata")[dataslot] 
	if isCompress then 
		if r then 
			local rt = NB.decodeSql(r)
			r = json.decodetable(rt)
		end 
	end 
	return r
end 
NB.SetCitizenPackedDataCache = function(citizenID,tablename,dataslot,datas,isCompress)
	local _data = NB.Cache.Get("CITIZEN",citizenID,tablename,"packeddata")
	if not _data then NB.Cache.Set("CITIZEN",citizenID,tablename,"packeddata",{}) 
		_data = {}
	end 
	if isCompress then 
		_data[dataslot] = NB.encodeSql(json.encode(datas))
	else 
		_data[dataslot] = datas
	end 
	NB.Cache.Set("CITIZEN",citizenID,tablename,"packeddata",_data)
	--NB.Cache.Set("CITIZEN",citizenID,tablename,"packeddata",dataslot,datas)
end 

NB.RegisterNetEvent('NB:Citizen:SavePosition', function(coords,heading)
	if coords and heading then 
		local playerData = NB.GetPlayerDataFromId(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			local x, y, z = table.unpack(coords)
			x, y, z, heading = x , y , z , heading
			x = com.lua.utils.Math.toFixed(x,2)
			y = com.lua.utils.Math.toFixed(y,2)
			z = com.lua.utils.Math.toFixed(z,2)
			heading = com.lua.utils.Math.toFixed(heading,2)
			NB.SetCitizenPackedDataCache(citizenID,'citizens','position',{x=x,y=y,z=z,heading=heading})
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] position Saved")
		end 
	end 
end) 
NB.RegisterNetEvent("NB:Citizen:SaveSkin",function(skindata)
	if skindata and type(skindata) == 'table' then 
		local playerData = NB.GetPlayerDataFromId(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			NB.SetCitizenPackedDataCache(citizenID,'citizens','skin',skindata,true)
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] skin Saved",true)
		end 
	end 
end )
NB.RegisterServerCallback("NB:GetCharacterPackedData",function(playerId,cb,datatype,isCompress)
	local playerData = NB.GetPlayerDataFromId(playerId)
	local citizenID = playerData and playerData.citizenID 
	if citizenID then 
		local ava = {"position","skin"}
		local found = false 
		for i=1,#ava do 
			if datatype == ava[i] then 
				found = true 
			end 
		end 
		if not found then return end 
		local result = NB.GetCitizenPackedDataCache(citizenID,'citizens',datatype,isCompress)
		if result then 
			cb(result)
			--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
		end 
	end 
end )

