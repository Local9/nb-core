

com.lua.utils.Table.SetTableSomething = function(obj,...)
	local args = {...}
	local thisparent = obj
	local lastv = nil 

	for i=1,#args-1 do 
		local v = tostring(args[i])
		if thisparent[v] == nil then 
			thisparent[v] = {} 
		end 
		if i ~= #args-1 then 
			thisparent = thisparent[v]
		else 
			local t = {}
			for i,v in pairs(args) do 
				t[i] = v 
			end 
			thisparent[v] = t[#t]
			return thisparent[v]
		end 
	end 
	return nil 
end 

com.lua.utils.Table.MakeSureTableSomethingExist = function(obj,...)
	local args = {...}
	local thisparent = obj
	local lastv = nil 
	
	for i=1,#args do 
		local v = tostring(args[i])
		if thisparent[v] == nil then 
			thisparent[v] = {} 
		end 
		if i ~= #args then 
			thisparent = thisparent[v]
		else 
			if thisparent[v] == nil then 
				thisparent[v] = nil
			else 
				return thisparent[v]
			end 
			return thisparent[v]
		end 
	end 
	return nil 
end 

com.lua.utils.Table.IsTableSomthingExist = function(obj,...)
	local args = {...}
	local thisparent = obj
	local lastv = nil 
	for i=1,#args do 
		local v = tostring(args[i])
		if thisparent[v] == nil then 
			return false 
		end 
		if i ~= #args then 
			thisparent = thisparent[v]
		else 
			if thisparent[v] == nil then 
				return false 
			else 
				return not (thisparent[v]==nil)
			end 
			return not (thisparent[v]==nil)
		end 
	end 
	return false 
end 

com.lua.utils.Table.GetTableSomthing = function(obj,...)
	if com.lua.utils.Table.IsTableSomthingExist(obj,...) then 
		local GetTableSomthing_ = function(...)
			local args = {...}
			local thisparent = obj
			local lastv = nil 
			
			for i=1,#args do 
				local v = tostring(args[i])
				if thisparent[v] == nil then 
					thisparent[v] = {} 
				end 
				if i ~= #args then 
					thisparent = thisparent[v]
				else 
					if thisparent[v] == nil then 
						thisparent[v] = nil
					else 
						return thisparent[v]
					end 
					return thisparent[v]
				end 
			end 
			return nil 
		end 
		local args = {...}
		local lastarg = args[#args]
		table.remove(args,#args)
		local args2 = args 
		local wtf = GetTableSomthing_(table.unpack(args2))[lastarg]
		return wtf
	else 
		return nil 
	end 
end 

