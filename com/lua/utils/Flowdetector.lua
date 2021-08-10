local Flow = {}
com.lua.utils.Flow = Flow
Flow._temp_ = {old={},new={},oldDataSource={},newDataSource={}}

Flow.CheckNative = function(fn,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local _fn = fn 
	local tt = {_fn(table.unpack(args))}
	Flow._temp_.new[fn] = json.encode(tt)
	Flow._temp_.newDataSource[fn] = tt
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then 
		local t = Flow._temp_.oldDataSource[fn] and Flow._temp_.oldDataSource[fn] or nil 
		local t2 = Flow._temp_.newDataSource[fn]
		if t == nil  then 
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
			
			if cb then cb("OnInit",t2) end 
			if cb then cb("OnChange","null",t2) end 
		else 
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]

			if cb then cb("OnChange",table.unpack(t),table.unpack(t2)) end 
		end 
	else 
		local t = Flow._temp_.newDataSource[fn]
		if cb then cb("OnSame",table.unpack(t)) end 
	end 
end 

Flow.CheckNativeChange = function(fn,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local _fn = fn 
	local tt = type(_fn) == "function" and {_fn(table.unpack(args))} or _fn
	Flow._temp_.new[fn] = json.encode(tt)
	Flow._temp_.newDataSource[fn] = tt
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then 
		local t = Flow._temp_.oldDataSource[fn] and Flow._temp_.oldDataSource[fn] or nil 
		local t2 = Flow._temp_.newDataSource[fn]
		if t == nil  then 
			--print("init",t,"to",table.unpack(t2))
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
			if cb then cb("null",t2) end 
		else 
			--print("change",table.unpack(t),"to",table.unpack(t2))
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
			if cb then cb(table.unpack(t),table.unpack(t2)) end 
		end 
	end 
end 

Flow.CheckNativeChangeVector = function(fn,...)
	local args = {...} 
	local lastarg = args[#args]
	local range = type(lastarg) == "function" and args[#args-1] or nil
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	table.remove(args,#args)
	local _fn = fn 
	local tt = _fn(table.unpack(args))
	Flow._temp_.new[fn] = json.encode(tt)
	Flow._temp_.newDataSource[fn] = tt
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then
		local t = Flow._temp_.oldDataSource[fn] and Flow._temp_.oldDataSource[fn] or nil 
		local t2 = Flow._temp_.newDataSource[fn]
		if t == nil  then 
			--print("init",t,"to",table.unpack(t2))
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
			if cb then cb("null",t2) end 
		else 
			--print("change",table.unpack(t),"to",table.unpack(t2))
			if #(Flow._temp_.newDataSource[fn] - Flow._temp_.oldDataSource[fn]) > range then 
				Flow._temp_.old[fn] = Flow._temp_.new[fn]
				Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
				if cb then cb(t,t2) end 
			end 
		end 
	end 
	return 
end 

Flow.CheckNativeSame = function(fn,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local _fn = fn 
	local tt = {_fn(table.unpack(args))}
	Flow._temp_.new[fn] = json.encode(tt)
	Flow._temp_.newDataSource[fn] = tt
	if Flow._temp_.old[fn] == Flow._temp_.new[fn] then 
		local t = Flow._temp_.newDataSource[fn]
		if cb then cb(table.unpack(t)) end 
	end 
end 

Flow.Check = function(name,obj,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local name = name
	local tt = type(obj) == 'table' and {obj} or obj
	Flow._temp_.new[name] = type(tt) == 'table' and json.encode(tt) or tt
	Flow._temp_.newDataSource[name] = tt
	if Flow._temp_.old[name] ~= Flow._temp_.new[name] then 
		local t = Flow._temp_.oldDataSource[name] and Flow._temp_.oldDataSource[name] or nil 
		local t2 = Flow._temp_.newDataSource[name]
		if t == nil  then 
			Flow._temp_.old[name] = Flow._temp_.new[name]
			Flow._temp_.oldDataSource[name] = Flow._temp_.newDataSource[name]
			
			if cb then cb("OnInit",type(t2) == 'table' and table.unpack(t2) or t2) end 
			if cb then cb("OnChange","null",type(t2) == 'table' and table.unpack(t2) or t2) end 
		else 
			Flow._temp_.old[name] = Flow._temp_.new[name]
			Flow._temp_.oldDataSource[name] = Flow._temp_.newDataSource[name]

			if cb then cb("OnChange",type(t) == 'table' and table.unpack(t) or t,type(t2) == 'table' and table.unpack(t2) or t2) end 
		end 
	else 
		local t = Flow._temp_.newDataSource[name]
		if cb then cb("OnSame",type(t) == 'table' and table.unpack(t) or t) end 
	end 
end 

Flow.CheckChange = function(name,obj,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local name = name
	local tt = type(obj) == 'table' and {obj} or obj
	Flow._temp_.new[name] = type(tt) == 'table' and json.encode(tt) or tt
	Flow._temp_.newDataSource[name] = tt
	if Flow._temp_.old[name] ~= Flow._temp_.new[name] then 
		local t = Flow._temp_.oldDataSource[name] and Flow._temp_.oldDataSource[name] or nil 
		local t2 = Flow._temp_.newDataSource[name]
		if t == nil  then 
			Flow._temp_.old[name] = Flow._temp_.new[name]
			Flow._temp_.oldDataSource[name] = Flow._temp_.newDataSource[name]

			if cb then cb("null",type(t2) == 'table' and table.unpack(t2) or t2) end 
		else 
			Flow._temp_.old[name] = Flow._temp_.new[name]
			Flow._temp_.oldDataSource[name] = Flow._temp_.newDataSource[name]

			if cb then cb(type(t) == 'table' and table.unpack(t) or t,type(t2) == 'table' and table.unpack(t2) or t2) end 
		end 
	end 
end 

Flow.CheckSame = function(name,obj,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local name = name
	local tt = type(obj) == 'table' and {obj} or obj
	Flow._temp_.new[name] = type(tt) == 'table' and json.encode(tt) or tt
	Flow._temp_.newDataSource[name] = tt
	if Flow._temp_.old[name] == Flow._temp_.new[name] then 
		local t = Flow._temp_.newDataSource[name]
		if cb then cb(type(t) == 'table' and table.unpack(t) or t) end 
	end 
end 

Flow.DeleteCheckNative = function(fn,cb)
	if cb then cb(Flow._temp_.old[fn],Flow._temp_.new[fn]) end 
	Flow._temp_.new[fn] = nil 
    Flow._temp_.old[fn] = nil 
end



