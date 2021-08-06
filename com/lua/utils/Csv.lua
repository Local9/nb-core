com.lua.utils.Csv.LoadDataSheet = function (name,returnkeys)
	local split = function (s, delimiter)
		result = {};
		for match in (s..delimiter):gmatch('(.-)'..delimiter) do
			table.insert(result, match);
		end
		return result;
	end
	local filecontent = split(string.gsub(LoadResourceFile(GetCurrentResourceName(),"/xls/table/"..name..".csv"),"\r",""),"\n") or {}
	local nowindex = 1
	local keys = {}
	local datasfull = {}
	for line_idx=1,#filecontent do
		local linetext = filecontent[line_idx]
		if linetext ~= "" then 
			local firstline = false 
			if nowindex == 1 then 
				firstline = true 
			end 
			local datatable = split(linetext,',')
			local dataslot = {} 
			if firstline then 
				for i=1,#datatable do 
					table.insert(keys,datatable[i])
				end 
			else 
				for i=1,#keys do 
					dataslot[keys[i]] = tostring(datatable[i])
					if not datasfull[dataslot[keys[1]]] then datasfull[dataslot[keys[1]]] = {} end 
				end 
			end 
			for key,value in pairs(dataslot) do 
				if key == keys[1] then 
				else 
					datasfull[dataslot[keys[1]]][key] = value
				end 
			end 
			nowindex = nowindex + 1
		end 
	end 
	return datasfull,returnkeys and keys or nil
end 

com.lua.utils.Csv.CreateDataSheet = function (name,data,keys)
	if IsServer() then 
		
			local file_exists = function (name)
				   local f=io.open(name,"r")
				   
				   if f~=nil then io.close(f) return true else return false end
			end
			if file_exists(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'.csv') then 
				error('Can not create due to file pre-'..name..'.csv already exist',2) 
			else 
				local filecontent,err = io.open(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'.csv','w+') --匯出
				if filecontent then 
					local split = function (s, delimiter)
						result = {};
						for match in (s..delimiter):gmatch('(.-)'..delimiter) do
							table.insert(result, match);
						end
						return result;
					end
					
					local firstline = table.concat(keys,",")
					local datatable = split(firstline,',')
					filecontent:write(firstline.."\n")
					for i,v in pairs(data) do --匯出的表
						local toconcat = {} 
						table.insert(toconcat,tostring(i))
						for k=2,#datatable,1 do 
							if datatable[k] then 
								local obj = v[datatable[k]]
								if type(obj) == 'table' then error(" table in table data is not supported",2)  end 
								local str = tostring(obj) 
								table.insert(toconcat,str)
							end 
						end 
						filecontent:write(table.concat(toconcat,",").."\n")
					end 
					filecontent:close()
				else 
					print(err)
				end 
				--[=[
				local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'2.csv','w+') --驗證
				if f then 
					local firstline = DATA_FIRSTLINE
					local datatable = split(firstline,',')
					f:write(firstline.."\n")
					for i,v in pairs(DATA) do --驗證表
						local toconcat = {} 
						table.insert(toconcat,tostring(i))
						for k=2,#datatable,1 do 
							if datatable[k] then 
								local obj = v[datatable[k]]
								local str = tostring(obj)
								table.insert(toconcat,str)
							end 
						end 
						f:write(table.concat(toconcat,",").."\n")
					end 
					f:close()
				else 
					print(err)
				end 
				--]=]
			end 
		
	else 
		error("Client is not supported",2)
	end 
end 


com.lua.utils.Csv.LoadDataSheetDecode = function (name,returnkeys)
	local split = function (s, delimiter)
		result = {};
		for match in (s..delimiter):gmatch('(.-)'..delimiter) do
			table.insert(result, match);
		end
		return result;
	end
	local filecontent = split(string.gsub(com.lua.utils.Encryption.SimpleDecrypt(LoadResourceFile(GetCurrentResourceName(),"/xls/table/"..name..".csv.code")),"\r",""),"\n") or {}
	local nowindex = 1
	local keys = {}
	local datasfull = {}
	for line_idx=1,#filecontent do
		local linetext = filecontent[line_idx]
		if linetext ~= "" then 
			local firstline = false 
			if nowindex == 1 then 
				firstline = true 
			end 
			local datatable = split(linetext,',')
			local dataslot = {} 
			if firstline then 
				for i=1,#datatable do 
					table.insert(keys,datatable[i])
				end 
			else 
				for i=1,#keys do 
					dataslot[keys[i]] = tostring(datatable[i])
					if not datasfull[dataslot[keys[1]]] then datasfull[dataslot[keys[1]]] = {} end 
				end 
			end 
			for key,value in pairs(dataslot) do 
				if key == keys[1] then 
				else 
					datasfull[dataslot[keys[1]]][key] = value
				end 
			end 
			nowindex = nowindex + 1
		end 
	end 
	return datasfull,returnkeys and keys or nil
end 

com.lua.utils.Csv.CreateDataSheetEncode = function (name,data,keys)
	if IsServer() then 
		local file_exists = function (name)
			local f=io.open(name,"r")
			
			if f~=nil then io.close(f) return true else return false end
		end
		if file_exists(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'.csv.code') then 
			error('Can not create due to file pre-'..name..'.csv already exist',2) 
		else 
			local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'.csv.code','w+') --匯出
			if f then 
				local split = function (s, delimiter)
					result = {};
					for match in (s..delimiter):gmatch('(.-)'..delimiter) do
						table.insert(result, match);
					end
					return result;
				end
				local firstline = table.concat(keys,',')
				local datatable = split(firstline,',')
				f:write(firstline.."\n")
				for i,v in pairs(data) do --匯出的表
					local toconcat = {} 
					table.insert(toconcat,tostring(i))
					for k=2,#datatable,1 do 
						if datatable[k] then 
							local obj = v[datatable[k]]
							if type(obj) == 'table' then error(" table in table data is not supported",2)  end 
							local str = tostring(obj) 
							table.insert(toconcat,str)
						end 
					end 
					f:write(table.concat(toconcat,",").."\n")
				end 
				f:close()
			else 
				print(err)
			end 
			local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'.csv.code','r')
			local content
			if f then 
				content = f:read "*a" -- *a or *all reads the whole file
				f:close()
			end 
			local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'.csv.code','w+')
			if f then 
				f:write(com.lua.utils.Encryption.SimpleEncrypt(content))
				f:close()
			end 
			
			
			--[=[
			local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/xls/table/pre-'..name..'2.csv','w+') --驗證
			if f then 
				local firstline = DATA_FIRSTLINE
				local datatable = split(firstline,',')
				f:write(firstline.."\n")
				for i,v in pairs(DATA) do --驗證表
					local toconcat = {} 
					table.insert(toconcat,tostring(i))
					for k=2,#datatable,1 do 
						if datatable[k] then 
							local obj = v[datatable[k]]
							local str = tostring(obj)
							table.insert(toconcat,str)
						end 
					end 
					f:write(table.concat(toconcat,",").."\n")
				end 
				f:close()
			else 
				print(err)
			end 
			--]=]
		end 
		
	else 
		error("Client is not supported",2)
	end 
end 
