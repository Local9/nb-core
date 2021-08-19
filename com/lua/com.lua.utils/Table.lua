com.lua.utils.Table.GetLastSlot = function(obj,...)
	local args = {...}
	local nowreach = obj
	local pos_end = #args
	local value = args[#args]
	for i=1,pos_end do 
		local v = args[i]
		if nowreach[v] == nil then 
			nowreach[v] = {} 
		end 
		if i == pos_end then 
			return nowreach,v
		else 
			nowreach = nowreach[v]
		end 
	end 
	return nil 
end 

com.lua.utils.Table.SetTableSomething = function(obj,...)
	local args = {...}
	local value = args[#args]
	table.remove(args,#args)
	local tbl,idx = com.lua.utils.Table.GetLastSlot(obj,table.unpack(args))
	tbl[idx] = value
end 

com.lua.utils.Table.ClearTableSomething = function(obj,...)
	if com.lua.utils.Table.IsTableSomthingExist(obj,...) then 
		local tbl,idx = com.lua.utils.Table.GetLastSlot(obj,...)
		tbl[idx] = nil
	end 
end 

com.lua.utils.Table.MakeSureTableSomethingExist = function(obj,...)
	local args = {...}
	local nowreach = obj
	local pos_end = #args
	for i=1,pos_end do 
		local v = args[i]
		if nowreach[v] == nil then 
			nowreach[v] = {} 
		end 
		if i ~= pos_end then 
			nowreach = nowreach[v]
		else 
			if nowreach[v] == nil then 
				nowreach[v] = nil
			else 
				return nowreach[v]
			end 
			return nowreach[v]
		end 
	end 
	return nil 
end 

com.lua.utils.Table.IsTableSomthingExist = function(obj,...)
	local args = {...}
	local nowreach = obj
	local pos_end = #args 
	for i=1,pos_end do 
		local v = args[i]
		if i == pos_end then 
			return not (nowreach[v]==nil)
		else 
			if nowreach[v] == nil then 
				return false 
			end 
			nowreach = nowreach[v]
		end 
	end 
	return false 
end 

com.lua.utils.Table.GetTableSomthing = function(obj,...)
	if com.lua.utils.Table.IsTableSomthingExist(obj,...) then 
		local tbl,idx = com.lua.utils.Table.GetLastSlot(obj,...)
		return tbl[idx]
	end  
	return nil  
end 

com.lua.utils.Table.InsertTableSomethingTable = function(obj,...)
	local args = {...}
	local value = args[#args]
	table.remove(args,#args)
	local tbl,idx = com.lua.utils.Table.GetLastSlot(obj,table.unpack(args))
	table.insert(tbl[idx],value)
	local rtbl = tbl and tbl[idx]
	local rlength = rtbl and #rtbl
	if rlength == 0 then return nil, nil end 
	return rtbl,rlength
end 

com.lua.utils.Table.RemoveTableSomethingTable = function(obj,...)
	local args = {...}
	local index = args[#args]
	local tbl,idx
	if type(index) == 'number' or (#args>1 and index==nil) then 
		table.remove(args,#args)
		tbl,idx = com.lua.utils.Table.GetLastSlot(obj,table.unpack(args))
		table.remove(tbl[idx],index)
	else 
		tbl,idx = com.lua.utils.Table.GetLastSlot(obj,table.unpack(args))
		table.remove(tbl[idx])
	end 
	local rtbl = tbl and tbl[idx]
	local rlength = rtbl and #rtbl
	if rlength == 0 then return nil, nil end 
	return rtbl,rlength
end 

