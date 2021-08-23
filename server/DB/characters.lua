NB.GetCitizenDataCache = function(citizenID,tablename,dataslot)
	return NB.Cache.Get("CITIZEN",citizenID,tablename,dataslot) or NB.GetCitizenDataSQL_Table(citizenID,tablename,dataslot)
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
NB.SetCitizenDataCache("NFGT9NI218846462","characters","test",'WHERE 1=1 --')
NB.GetCitizenPackedDataCache = function(citizenID,tablename,dataslot,isCompress)
	local pd = NB.Cache.Get("CITIZEN",citizenID,tablename,"packeddata",dataslot)
	local r = pd or NB.GetCitizenDataSQL_Table(citizenID,tablename,"packeddata")[dataslot] 
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

NB.GetCitizenDataSQL_Table= function(citizenID,tablename,dataslot)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT '..dataslot..' FROM '..tablename..' WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	local t = json.decodetable(result)
	NB.Cache.Set("CITIZEN",citizenID,tablename,dataslot,t)
	return t 
end 

NB.SetCitizenDataSQL_Table = function(citizenID,tablename,dataslot)
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

NB.SaveAllCacheCitizenDataIntoMysql = function(citizenID)
	if NB["_CACHE_"] and NB["_CACHE_"]["CITIZEN"] then 
		local CITIZENTABLE = NB["_CACHE_"]["CITIZEN"]
		local tasks = {}
		if citizenID then 
			for tablename,citizendata in pairs(CITIZENTABLE[citizenID]) do 
				local task = function(cb)
						NB.SetCitizenDataSQL_Table(citizenidstr,tablename,citizendata)
						--print(citizenidstr,tablename,dataslot,data)
					cb("Async")
				end
				table.insert(tasks, task)
			end 
		else 
			for citizenidstr,CITIZENSLOT in pairs(CITIZENTABLE) do 
				for tablename,citizendata in pairs(CITIZENSLOT) do 
					local task = function(cb)
							NB.SetCitizenDataSQL_Table(citizenidstr,tablename,citizendata)
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

CreateThread(function()
	Wait(10000)
	while true do 
		NB.SaveAllCacheCitizenDataIntoMysql()
		Wait(60000)
	end 
end )