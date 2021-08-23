
DB.Citizen.IsExist = function (citizenID)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM citizens WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	local r = not not (result and result > 0)
	return r 
end 
DB.Citizen.GetLicense = function (citizenID)
	--'SELECT u.license FROM users u inner join citizens s on u.citizen_id = s.citizen_id WHERE u.citizen_id = @citizen_id'
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT license FROM citizens WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	return result and result or nil
end 
DB.Citizen.GetIDFromLicense = function (license,idx)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT citizen_id FROM citizens WHERE license = @license', {
		['@license'] = license
	})
	if idx then 
		return result and result[idx] and result[idx].citizen_id or nil
	else
		return result or nil 
	end 
end 
DB.Citizen.SqlToCache = function(citizenID,tablename,dataslot)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT '..dataslot..' FROM '..tablename..' WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
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
				return (cdata)
			end 
		end 
	end 
	if type(dataslot) == 'table' then 
		local querys = {}
		local datadefines = {
			['@citizen_id'] = citizenID
		}
		for dataslot_,data_ in pairs(dataslot) do 
			table.insert(querys,dataslot_..' = @'..dataslot_)
			datadefines['@'..dataslot_..''] = covertDatas(data_)
			--print(covertDatas(data_))
		end 
		querys = table.concat(querys,",")
		NB.Utils.Remote.mysql_execute('UPDATE '..tablename..' SET '..querys..' WHERE citizen_id = @citizen_id', datadefines)
	end 
end 
DB.Citizen.AllCachesToSql = function(citizenID)
	if NB["_CACHE_"] and NB["_CACHE_"]["CITIZEN"] then 
		local CITIZENTABLE = NB["_CACHE_"]["CITIZEN"]
		local tasks = {}
		if citizenID then 
			for tablename,citizendata in pairs(CITIZENTABLE[citizenID]) do 
				local task = function(cb)
						DB.Citizen.CacheToSql(citizenidstr,tablename,citizendata)
						--print(citizenidstr,tablename,dataslot,data)
					cb("Async")
				end
				table.insert(tasks, task)
			end 
		else 
			for citizenidstr,CITIZENSLOT in pairs(CITIZENTABLE) do 
				for tablename,citizendata in pairs(CITIZENSLOT) do 
					local task = function(cb)
							DB.Citizen.CacheToSql(citizenidstr,tablename,citizendata)
							--print(citizenidstr,tablename,dataslot,data)
						cb("Async")
					end
					table.insert(tasks, task)
				end 
			end 
		end 
		NB.Async.series(tasks,function(result) end)
	end 
end 
DB.Citizen.Create = function(playerid, license, citizenID,cb)
	NB.Utils.Remote.mysql_execute('INSERT INTO citizens (citizen_id,license,packeddata) VALUES (@citizen_id,@license,@packeddata)', {
		['@citizen_id'] = citizenID,
		['@license'] = license,
		['@packeddata'] = json.encode({position=DEFAULT_SPAWN_POSITION})
	}, function(result)
		print("Created a character into database")
		cb(result)
	end )
end 
CreateThread(function()
	Wait(10000)
	while true do 
		DB.Citizen.AllCachesToSql()
		Wait(60000)
	end 
end )


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
NB.SetCitizenDataCache("NFGT9NI218846462","citizens","test",'WHERE 1=1 --')
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
		local x, y, z = table.unpack(coords)
		local playerData = NB.PlayerData(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			NB.SetCitizenPackedDataCache(citizenID,'citizens','position',{x=com.lua.utils.Math.toFixed(x+0.0,2),y=com.lua.utils.Math.toFixed(y+0.0,2),z=com.lua.utils.Math.toFixed(z+0.0,2),heading=com.lua.utils.Math.toFixed(heading+0.0,2)})
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] position Saved")
		end 
	end 
end) 
NB.RegisterNetEvent("NB:Citizen:SaveSkin",function(skindata)
	if skindata and type(skindata) == 'table' then 
		local playerData = NB.PlayerData(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			NB.SetCitizenPackedDataCache(citizenID,'citizens','skin',skindata,true)
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] skin Saved",true)
		end 
	end 
end )
NB.RegisterServerCallback("NB:GetCharacterPackedData",function(playerId,cb,datatype,isCompress)
	local playerData = NB.PlayerData(playerId)
	local citizenID = playerData.citizenID 
	local ava = {"position","skin"}
	local found = false 
	for i=1,#ava do 
		if datatype == ava[i] then 
			found = true 
		end 
	end 
	if not found then return end 
	local skin = NB.GetCitizenPackedDataCache(citizenID,'citizens',datatype,isCompress)
	if skin then 
		cb(skin)
		--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
	end 
end )
