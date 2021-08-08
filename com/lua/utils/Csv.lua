com.lua.utils.Csv.LoadDataSheet = function (name,returnkeys)
	
	local split = function (s, delimiter)
		result = {};
		for match in (s..delimiter):gmatch('(.-)'..delimiter) do
			table.insert(result, match);
		end
		return result;
	end
	local function extractVector(s)
		local a =  '[(].-[)]'
		local r = {}
		for m in string.gmatch(s,a) do
			table.insert(r,m)
		end
		local rt = string.gsub(table.concat(r),"[)]","")
		rt = string.gsub(rt,"[(]","")
		local vt = split(rt,",")
		if #vt == 4 then 
			return vector4(tonumber(vt[1]),tonumber(vt[2]),tonumber(vt[3]),tonumber(vt[4]))
		elseif #vt == 3 then 
			return vector3(tonumber(vt[1]),tonumber(vt[2]),tonumber(vt[3]))
		elseif #vt == 2 then 
			return vector2(tonumber(vt[1]),tonumber(vt[2]))
		end 
		return error("extractVector error",2)
	end
	local function fromCSV(s)
	  s = s .. ','        -- ending comma
	  local t = {}        -- table to collect fields
	  local fieldstart = 1
	  repeat
		-- next field is quoted? (start with `"'?)
		if string.find(s, '^"', fieldstart) then
		  local a, c
		  local i  = fieldstart
		  repeat
			-- find closing quote
			a, i, c = string.find(s, '"("?)', i+1)
		  until c ~= '"'    -- quote not followed by quote?
		  if not i then error('unmatched "') end
		  local f = string.sub(s, fieldstart+1, i-1)
		  table.insert(t, (string.gsub(f, '""', '"')))
		  fieldstart = string.find(s, ',', i) + 1
		else                -- unquoted; find next comma
		  local nexti = string.find(s, ',', fieldstart)
		  table.insert(t, string.sub(s, fieldstart, nexti-1))
		  fieldstart = nexti + 1
		end
	  until fieldstart > string.len(s)
	  return t
	end
	local isNumber = function(x)
		local a = tonumber(x)
		local b 
		if not a then 
			return false 
		else 
			b = tonumber(tostring(tonumber(x)))
			return a == b 
		end 
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
			local datatable = fromCSV(linetext)
			local dataslot = {} 
			if firstline then 
				for i=1,#datatable do 
					table.insert(keys,datatable[i])
				end 
			else 
				for i=1,#keys do 
					if string.find(datatable[i],"{") then 
						datatable[i] = json.decode(datatable[i])
					elseif string.find(datatable[i],"vector") then 
						datatable[i] = extractVector(datatable[i])
					elseif datatable[i] == "nil" or datatable[i] == "null" then 
						datatable[i] = nil
					elseif datatable[i] == "TRUE" then 
						datatable[i] = true 
					elseif datatable[i] == "FALSE" then 
						datatable[i] = false 
					elseif isNumber(datatable[i]) then 
						datatable[i] = tonumber(datatable[i])
					else 					
						datatable[i] = tostring(datatable[i])
					end 
					dataslot[keys[i]] = datatable[i]
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
					local function fromCSV(s)
					  s = s .. ','        -- ending comma
					  local t = {}        -- table to collect fields
					  local fieldstart = 1
					  repeat
						-- next field is quoted? (start with `"'?)
						if string.find(s, '^"', fieldstart) then
						  local a, c
						  local i  = fieldstart
						  repeat
							-- find closing quote
							a, i, c = string.find(s, '"("?)', i+1)
						  until c ~= '"'    -- quote not followed by quote?
						  if not i then error('unmatched "') end
						  local f = string.sub(s, fieldstart+1, i-1)
						  table.insert(t, (string.gsub(f, '""', '"')))
						  fieldstart = string.find(s, ',', i) + 1
						else                -- unquoted; find next comma
						  local nexti = string.find(s, ',', fieldstart)
						  table.insert(t, string.sub(s, fieldstart, nexti-1))
						  fieldstart = nexti + 1
						end
					  until fieldstart > string.len(s)
					  return t
					end
					if keys[1] ~= "#TableSlot" then table.insert(keys,1,"#TableSlot") end 
					local firstline = table.concat(keys,",")
					local datatable = fromCSV(firstline)
					filecontent:write(firstline.."\n")
					for i,v in pairs(data) do --匯出的表
						local toconcat = {} 
						table.insert(toconcat,tostring(i))
						for k=2,#datatable,1 do 
							if datatable[k] then 
								local obj = v[datatable[k]]
								if obj and type(obj) == 'table' then obj = string.gsub(json.encode(obj),'"','""') end 
								if string.find(tostring(obj),",") then 
									obj = '"'..tostring(obj) ..'"'
								end 
								local str = tostring(obj)  
								if str == "nil" then str = "null" end 
								table.insert(toconcat,str)
							end 
						end 
						filecontent:write(table.concat(toconcat,",").."\n")
					end 
					filecontent:close()
				else 
					print(err)
				end 
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
	local function extractVector(s)
		local a =  '[(].-[)]'
		local r = {}
		for m in string.gmatch(s,a) do
			table.insert(r,m)
		end
		local rt = string.gsub(table.concat(r),"[)]","")
		rt = string.gsub(rt,"[(]","")
		local vt = split(rt,",")
		if #vt == 4 then 
			return vector4(tonumber(vt[1]),tonumber(vt[2]),tonumber(vt[3]),tonumber(vt[4]))
		elseif #vt == 3 then 
			return vector3(tonumber(vt[1]),tonumber(vt[2]),tonumber(vt[3]))
		elseif #vt == 2 then 
			return vector2(tonumber(vt[1]),tonumber(vt[2]))
		end 
		return error("extractVector error",2)
	end
	local function fromCSV(s)
	  s = s .. ','        -- ending comma
	  local t = {}        -- table to collect fields
	  local fieldstart = 1
	  repeat
		-- next field is quoted? (start with `"'?)
		if string.find(s, '^"', fieldstart) then
		  local a, c
		  local i  = fieldstart
		  repeat
			-- find closing quote
			a, i, c = string.find(s, '"("?)', i+1)
		  until c ~= '"'    -- quote not followed by quote?
		  if not i then error('unmatched "') end
		  local f = string.sub(s, fieldstart+1, i-1)
		  table.insert(t, (string.gsub(f, '""', '"')))
		  fieldstart = string.find(s, ',', i) + 1
		else                -- unquoted; find next comma
		  local nexti = string.find(s, ',', fieldstart)
		  table.insert(t, string.sub(s, fieldstart, nexti-1))
		  fieldstart = nexti + 1
		end
	  until fieldstart > string.len(s)
	  return t
	end
	local isNumber = function(x)
		local a = tonumber(x)
		local b 
		if not a then 
			return false 
		else 
			b = tonumber(tostring(tonumber(x)))
			return a == b 
		end 
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
			local datatable = fromCSV(linetext,',')
			local dataslot = {} 
			if firstline then 
				for i=1,#datatable do 
					table.insert(keys,datatable[i])
				end 
			else 
				for i=1,#keys do 
					if string.find(datatable[i],"{") then 
						datatable[i] = json.decode(datatable[i])
					elseif string.find(datatable[i],"vector") then 
						datatable[i] = extractVector(datatable[i])
					elseif datatable[i] == "nil" or datatable[i] == "null" then 
						datatable[i] = nil
					elseif datatable[i] == "TRUE" then 
						datatable[i] = true 
					elseif datatable[i] == "FALSE" then 
						datatable[i] = false 
					elseif isNumber(datatable[i]) then 
						datatable[i] = tonumber(datatable[i])
					else 					
						datatable[i] = tostring(datatable[i])
					end 
					dataslot[keys[i]] = datatable[i]
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
				local function fromCSV(s)
				  s = s .. ','        -- ending comma
				  local t = {}        -- table to collect fields
				  local fieldstart = 1
				  repeat
					-- next field is quoted? (start with `"'?)
					if string.find(s, '^"', fieldstart) then
					  local a, c
					  local i  = fieldstart
					  repeat
						-- find closing quote
						a, i, c = string.find(s, '"("?)', i+1)
					  until c ~= '"'    -- quote not followed by quote?
					  if not i then error('unmatched "') end
					  local f = string.sub(s, fieldstart+1, i-1)
					  table.insert(t, (string.gsub(f, '""', '"')))
					  fieldstart = string.find(s, ',', i) + 1
					else                -- unquoted; find next comma
					  local nexti = string.find(s, ',', fieldstart)
					  table.insert(t, string.sub(s, fieldstart, nexti-1))
					  fieldstart = nexti + 1
					end
				  until fieldstart > string.len(s)
				  return t
				end
				if keys[1] ~= "#TableSlot" then table.insert(keys,1,"#TableSlot") end 
				local firstline = table.concat(keys,',')
				local datatable = fromCSV(firstline,',')
				f:write(firstline.."\n")
				for i,v in pairs(data) do --匯出的表
					local toconcat = {} 
					table.insert(toconcat,tostring(i))
					for k=2,#datatable,1 do 
						if datatable[k] then 
							local obj = v[datatable[k]]
							if obj and type(obj) == 'table' then obj = string.gsub(json.encode(obj),'"','""') end 
							if string.find(tostring(obj),",") then 
								obj = '"'..tostring(obj) ..'"'
							end 
							local str = tostring(obj) 
							if str == "nil" then str = "null" end 
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
		end 
		
	else 
		error("Client is not supported",2)
	end 
end 
