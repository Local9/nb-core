local CitizenSaveQueryid = {}
local CitizenLastQuery = {}
local LastQueryid = {}
local LastQuery = {}



DB.Citizen.GetData = function (citizenID,...)
	return NB.Cache.Get("CITIZEN",citizenID,...)
end 
DB.Citizen.GetCitizenPlayerId = function(citizenID)
	return NB.Cache.Get("CITIZEN",citizenID,"_TEMP_","playerId")
end 
DB.Citizen.SetData = function (citizenID,...)
	return NB.Cache.Set("CITIZEN",citizenID,...)
end 
DB.Citizen.IsExist = function (citizenID)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM citizens WHERE ?', {{
		['citizen_id'] = citizenID
	}})
	local r = not not (result and result > 0)
	return r 
end 
DB.Citizen.GetLicense = function (citizenID)
	--'SELECT u.license FROM users u inner join citizens s on u.citizen_id = s.citizen_id WHERE u.citizen_id = @citizen_id'
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT license FROM citizens WHERE ?', {{
		['citizen_id'] = citizenID
	}})
	return result and result or nil
end 
DB.Citizen.GetIDFromLicense = function (license,idx)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT citizen_id FROM citizens WHERE ?', {{
		 ['license'] = license
	}})
	if idx then 
		return result and result[idx] and result[idx].citizen_id or nil
	else
		return result or nil 
	end 
end 
DB.Citizen.SqlToCache = function(citizenID,tablename,dataslot)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT '..dataslot..' FROM '..tablename..' WHERE ?', {{
		['citizen_id'] = citizenID
	}})
	local t = json.decodetable(result)
	NB.Cache.Set("CITIZEN",citizenID,tablename,dataslot,t)
	return t 
end 
DB.Citizen.CacheToSql = function(citizenID,tablename,dataslot)
	--if not NB.IsPlayerConnected(DB.Citizen.GetCitizenPlayerId(citizenID)) then return error("player not connected",2) end
	if tablename == "_TEMP_" then return end 
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
		local datastore = {}
		local querys = {}
		for dataslot_,data_ in pairs(dataslot) do 
			table.insert(querys,--[[dataslot_..' = ]]'?')
			table.insert(datastore,{[dataslot_] = covertDatas(data_)})
		end 
		querys = table.concat(querys,",")
		local newquerystring = 'UPDATE '..tablename..' SET '..querys..' WHERE ?'
		if not CitizenSaveQueryid[citizenID] then 
			CitizenLastQuery[citizenID] = {}
			CitizenSaveQueryid[citizenID] = {}
		end 
		if not CitizenSaveQueryid[citizenID][tablename] or CitizenLastQuery[citizenID][tablename]~= newquerystring then 
			if LastQuery[tablename] == newquerystring then 
				CitizenLastQuery[citizenID][tablename] = LastQuery[tablename]
				CitizenSaveQueryid[citizenID][tablename] = LastQueryid[tablename]
			else
				LastQuery[tablename] = newquerystring
				LastQueryid[tablename] = com.lua.utils.Remote.mysql_storeSync(newquerystring)
				CitizenLastQuery[citizenID][tablename] = LastQuery[tablename]
				CitizenSaveQueryid[citizenID][tablename] = LastQueryid[tablename]
			end 
		end 
		table.insert(datastore,{['citizen_id'] = citizenID})
		NB.Utils.Remote.mysql_execute(CitizenSaveQueryid[citizenID][tablename], datastore)
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
					cb({citizenID = citizenID,result = "Async "..(tablename~="_TEMP_" and "Saving " or " Temping ") ..citizenID.." "..tablename.." "..json.encode(citizendata).." Okay"})
				end
				table.insert(tasks, task)
			end 
		else 
			for citizenidstr,CITIZENSLOT in pairs(CITIZENTABLE) do 
				for tablename,citizendata in pairs(CITIZENSLOT) do 
					local task = function(cb)
							DB.Citizen.CacheToSql(citizenidstr,tablename,citizendata)
							--print(citizenidstr,tablename,dataslot,data)
						cb({citizenID = citizenidstr,result = "Async "..(tablename~="_TEMP_" and "Saving " or " Temping ")..citizenidstr.." "..tablename.." "..json.encode(citizendata).." Okay"})
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

CreateThread(function()
	Wait(10000)
	NB.Threads.CreateLoop("saveAllCacheDB",10000,function()
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
RegisterServerCallback("NB:GetCharacterPackedData",function(playerId,cb,datatype,isCompress)
	local playerData = NB.GetPlayerDataFromId(playerId)
	local citizenID = playerData and playerData.citizenID 
	if citizenID then 
		local ava = ACCEPTED_PACKDATA
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
NB.GetCitizenStatusCache = function(citizenID,tablename,dataslot,isCompress)
	local pd = NB.Cache.Get("CITIZEN",citizenID,tablename,"statusdata",dataslot)
	local r = pd or DB.Citizen.SqlToCache(citizenID,tablename,"statusdata")[dataslot] 
	if isCompress then 
		if r then 
			local rt = NB.decodeSql(r)
			r = json.decodetable(rt)
		end 
	end 
	return r
end 
NB.SetCitizenStatusCache = function(citizenID,tablename,dataslot,datas,isCompress)
	local _data = NB.Cache.Get("CITIZEN",citizenID,tablename,"statusdata")
	if not _data then NB.Cache.Set("CITIZEN",citizenID,tablename,"statusdata",{}) 
		_data = {}
	end 
	if isCompress then 
		_data[dataslot] = NB.encodeSql(json.encode(datas))
	else 
		_data[dataslot] = datas
	end 
	NB.Cache.Set("CITIZEN",citizenID,tablename,"statusdata",_data)
end 
RegisterServerCallback("NB:GetCharacterStatusData",function(playerId,cb,datatype,isCompress)
	local playerData = NB.GetPlayerDataFromId(playerId)
	local citizenID = playerData and playerData.citizenID 
	if citizenID then 
		local ava = ACCEPTED_STATUSDATA
		local found = false 
		for i=1,#ava do 
			if datatype == ava[i] then 
				found = true 
			end 
		end 
		if not found then return end 
		local result = NB.GetCitizenStatusCache(citizenID,'citizens',datatype,isCompress)
		if result then 
			cb(result)
		end 
	end 
end )
NB.RegisterNetEvent('NB:Citizen:SavePosition', function(coords,heading)
	if coords and heading then 
		local playerData = NB.GetPlayerDataFromId(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if DB.Citizen.IsLoaded(citizenID) then 
			local x, y, z = table.unpack(coords)
			x, y, z, heading = x , y , z , heading
			x = com.lua.utils.Math.toFixed(x,2)
			y = com.lua.utils.Math.toFixed(y,2)
			z = com.lua.utils.Math.toFixed(z,2)
			heading = com.lua.utils.Math.toFixed(heading,2)
			--NB.SetCitizenDataCache(citizenID,'citizens','test',"test")
			NB.SetCitizenPackedDataCache(citizenID,'citizens','position',{x=x,y=y,z=z,heading=heading})
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] position Saved")
		end 
	end 
end) 
NB.RegisterNetEvent("NB:Citizen:SaveSkin",function(skindata)
	if skindata and type(skindata) == 'table' then 
		local playerData = NB.GetPlayerDataFromId(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if DB.Citizen.IsLoaded(citizenID) then 
			NB.SetCitizenPackedDataCache(citizenID,'citizens','skin',skindata,true)
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] skin Saved",true)
		end 
	end 
end )


RegisterServerCallback("NB:IsCharacterLoaded",function(playerId,cb)
	local playerData = NB.GetPlayerDataFromId(playerId)
	local citizenID = playerData and playerData.citizenID 
	cb(DB.Citizen.IsLoaded(citizenID))
end )

RegisterServerCallback("NB:GetCitizenDataDynamic",function(playerId,cb)
	local playerData = NB.GetPlayerDataFromId(playerId)
	local citizenID = playerData and playerData.citizenID 
	cb(DB.Citizen.GetData(citizenID))
end )


DB.Citizen.Init = function(playerId,citizenID,cb)
	if not NB.Cache.IsExist("CITIZEN",citizenID) then 
		NB.Cache.Set("CITIZEN",citizenID,{['_TEMP_']={playerId = playerId,citizenID = citizenID}})
	end 
	NB.TriggerEvent("NB:OnCitizenLoaded",playerId,citizenID,NB.Cache.Get("CITIZEN",citizenID))
	return result 
end 
DB.Citizen.IsLoaded = function(citizenID)
	return (NB.IsPlayerConnected(DB.Citizen.GetCitizenPlayerId(citizenID)) and NB.GetPlayerDataFromId(DB.Citizen.GetCitizenPlayerId(citizenID)).citizenID==citizenID) or false
end 
DB.Citizen.Create = function(playerId,citizenID,license,cb)
	local status = {}
	for i=1,#(ACCEPTED_STATUSDATA) do 
		status[ACCEPTED_STATUSDATA[i]] = DEFAULT_STATUSDATA[ACCEPTED_STATUSDATA[i]] or 0
	end 
	local packs ={}
	for i=1,#(ACCEPTED_PACKDATA) do 
		packs[ACCEPTED_PACKDATA[i]] = DEFAULT_PACKDATA[ACCEPTED_PACKDATA[i]] or 0
	end 
	
	local result = NB.Utils.Remote.mysql_execute_sync('INSERT INTO citizens (citizen_id,license,packeddata,statusdata,inventory) VALUES (?,?,?,?,?)', {
		citizenID,
		license,
		json.encode(packs),
		json.encode(status),
		"[]"
	})
	return result 
end 