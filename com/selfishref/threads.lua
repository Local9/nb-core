local threads = {}
	NB.Threads = threads
	threads.Custom_Handle = 1
	threads.Custom_Handles = {}
	threads.Custom_Alive = {}
	threads.Custom_Timers = {}
	threads.Custom_VarTimer = {}
	threads.Custom_Functions = {}
	threads.Custom_Once = {}
	threads.Custom_ActionTables = {}
	function threads.Custom_IsActionTableCreated(timer) return threads.Custom_ActionTables[timer]  end 
	threads.loop_custom = function()error("Outdated",2) end 
	local LoopItCustom = function(_name,_timer,_func,_varname)
		if threads.Custom_Once[_name] then return end 
		if debuglog and not _timer then 
			print("[BAD Hobbits]Some LoopIt timer is nil on "..GetCurrentResourceName())
		end 
		local name = _name or tostring(_func)
		local timer = _timer>=0 and _timer or 0
		local IsThreadCreated = threads.Custom_IsActionTableCreated(timer) --threads.Custom_ActionTables[timer] Exist
		if IsThreadCreated then  
			if threads.Custom_Functions[name] then 
				print('[Warning]threads'..name..' is doubly and replaced')  
			end 
			threads.Custom_Alive[name] = true 
			threads.Custom_Functions[name] = _func
			threads.Custom_Timers[name] = timer 
			table.insert(threads.Custom_ActionTables[timer],name ) -- 如果default此毫秒已存在 則添加到循環流程中
		else                                -- 否則新建一個default的毫秒表 以及新建一個循環線程
			if threads.Custom_Functions[name] then 
				print('[Warning]threads'..name..' is doubly and replaced')  
			end 
			threads.Custom_Alive[name] = true 
			threads.Custom_Functions[name] = _func
			threads.Custom_Timers[name] = timer 
			threads.Custom_ActionTables[timer] = {}	
			local actiontable = threads.Custom_ActionTables[timer] 
			local vt = timer
			table.insert(threads.Custom_ActionTables[timer] , name)
			CreateThread(function() 
				local loop;loop = function()
					if #actiontable == 0 then 
						return 
					end 
					for i=1,#actiontable do 
						local function this()
						local v = actiontable[i]
							if threads.Custom_Alive[v] and threads.Custom_Functions[v] and threads.Custom_Timers[v] == timer then 
								local predelaySetter = {setter=setmetatable({},{__call = function(t,data) threads.SetLoopCustom(_varname,data) end}),getter=function(t,data) return threads.GetLoopCustom(_varname) end}
								local delaySetter = predelaySetter
								local preBreaker = function(t,data) threads.BreakCustom(v) end
								threads.Custom_Functions[v](_varname and delaySetter,preBreaker,v,#actiontable or preBreaker,v,#actiontable)
							else 
								if actiontable and actiontable[i] then 
									table.remove(actiontable ,i) 
									if #actiontable == 0 then 
										threads.KillLoopCustom(name,timer)
										return 
									end 
								end 
							end 
						end 
						this()
					end 
					if _varname and threads.Custom_VarTimer[_varname] then 
						vt = threads.Custom_VarTimer[_varname]
					end 
					SetTimeout(vt>0 and vt or 0,loop)
				end 
				loop()
				return 
			end)
		end 
	end
	--pass Varname into parameters[4] with using threads.SetLoopCustom(Varname,millisecond)/threads.GetLoopCustom(Varname) to set/get the Delay or just using functionhash with setter/getter instead.
	threads.CreateLoopCustom = function(...) --actionname,defaulttimer(and ID of timer.will stack actions into the sameID),func,varname(link a custom name to this timer)
		local tbl = {...}
		local length = #tbl
		local func,varname,name,defaulttimer
		if length == 4 then
			name = tbl[1]
			defaulttimer = tbl[2]
			func = tbl[3]
			varname = tbl[4]
		elseif length == 3 then 
			name = tbl[1]
			defaulttimer = tbl[2]
			func = tbl[3]
		elseif  length == 2 then 
			name = GetCurrentResourceName()
			defaulttimer = tbl[1]
			func = tbl[2]
		elseif  length == 1 then 
			name = GetCurrentResourceName()
			defaulttimer = 0
			func = tbl[1]
		end 
		if not varname then 
			--error("threads.CreateLoopCustom(actionname,defaulttimer,func,varname)") 
			local shash = tostring(debug.getinfo(2,'S').source)..'line'..tostring(debug.getinfo(2).currentline)
			varname = shash
		end 
		threads.Custom_VarTimer[varname] = defaulttimer
		if debuglog then 
			print("Linked VarName '"..varname .. "' to a Custom Timer")
			print('threads(debug):CreateLoopCustom:Varname:'..varname,"actionname: ".. name) 
		end
		LoopItCustom(name,defaulttimer,func,varname)
		if threads.Custom_Handle >= 65530 then threads.Custom_Handle = 1 end 
		threads.Custom_Handle = threads.Custom_Handle + 1
		threads.Custom_Handles[threads.Custom_Handle] = name
		return threads.Custom_Handle
	end
	threads.CreateLoopOnceCustom = function(...) 
		local tbl = {...}
		local length = #tbl
		local func,varname,name,defaulttimer
		if length == 4 then
			name = tbl[1]
			defaulttimer = tbl[2]
			func = tbl[3]
			varname = tbl[4]
		elseif length == 3 then 
			name = tbl[1]
			defaulttimer = tbl[2]
			func = tbl[3]
		elseif  length == 2 then 
			name = GetCurrentResourceName()
			defaulttimer = tbl[1]
			func = tbl[2]
		elseif  length == 1 then 
			name = GetCurrentResourceName()
			defaulttimer = 0
			func = tbl[1]
		end 
		if not threads.Custom_Once[name] then 
		if not varname then 
			--error("threads.CreateLoopCustom(actionname,defaulttimer,func,varname)") 
			local shash = tostring(debug.getinfo(2,'S').source)..'line'..tostring(debug.getinfo(2).currentline)
			varname = shash
		end 
		threads.Custom_VarTimer[varname] = defaulttimer
		if debuglog then 
			print("Linked VarName '"..varname .. "' to a Custom Timer")
			print('threads(debug):CreateLoopOnceCustom:Varname:'..varname,"actionname: ".. name) 
		end
			if debuglog then print('threads(debug):CreateLoopOnce:CreateThread:'..defaulttimer, name) end
			LoopItCustom(name,defaulttimer,func,varname)
			threads.Custom_Once[name] = true 
		end 
		if threads.Custom_Handle >= 65530 then threads.Custom_Handle = 1 end 
		threads.Custom_Handle = threads.Custom_Handle + 1
		threads.Custom_Handles[threads.Custom_Handle] = name
		return threads.Custom_Handle
	end
	threads.CreateLoopCustomOnce =  threads.CreateLoopOnceCustom
	threads.GetLoopCustom = function(varname)
		if not threads.Custom_VarTimer[varname] then error("VarTimer not found.Make sure set varname in the last of threads.CreateLoopCustom(actionname,defaulttimer,func,varname)",2) end 
		return threads.Custom_VarTimer[varname]
	end 
	threads.SetLoopCustom = function(varname,totimer)
		if not threads.Custom_VarTimer[varname] then error("VarTimer not found.Make sure set varname in the last of threads.CreateLoopCustom(actionname,defaulttimer,func,varname)",2) end 
		threads.Custom_VarTimer[varname] = totimer 
	end 
	threads.KillLoopCustom = function(name,timer)
		threads.Custom_Alive[name] = nil 
		threads.Custom_Functions[name] = nil
		threads.Custom_Timers[name] = nil 
		threads.Custom_ActionTables[timer] = nil	
		threads.Custom_Once[name]  = nil
		if debuglog then print('threads(debug):KillLoopCustom:'..name,timer) end
	end 
	threads.KillActionOfLoopCustom = function(name)
		for timer,_name in pairs (threads.Custom_ActionTables) do 
			if _name == name then 
				for i=1,#threads.Custom_ActionTables[timer] do 
					if threads.Custom_ActionTables[timer][i] == name then 
						table.remove(threads.Custom_ActionTables[timer] ,i) 
						if #threads.Custom_ActionTables[timer] == 0 then 
							threads.KillLoopCustom(name,timer)
							return 
						end 
					end 
				end 
			end 
		end 
		threads.Custom_Alive[name] = false 
		threads.Custom_Once[name] = false 
		threads.Custom_Functions[name] = nil
		if debuglog then print('threads(debug):KillActionOfLoopCustom:'..name) end
	end 
	threads.KillHandleOfLoopCustom = function(handle)
		if threads.Custom_Handle[handle] then 
			threads.KillActionOfLoopCustom(threads.Custom_Handle[handle])
		end 
	end 
	threads.IsActionOfLoopAliveCustom = function(name)
		return threads.Custom_Alive[name] and true or false 
	end 
	threads.IsLoopAliveCustom = function(name)
		return threads.Custom_Functions[name] and true or false 
	end 
	--debug 
	if debuglog then 
	local thisname = "threads"
	CreateThread(function()
		if IsDuplicityVersion() then 
			if GetCurrentResourceName() ~= thisname then 
				print('\x1B[32m[server-utils]\x1B[0m'..thisname..' is used on '..GetCurrentResourceName().." \n\x1B[32m[\x1B[33m"..thisname.."\x1B[32m]\x1B[33m"..GetResourcePath(GetCurrentResourceName())..'\x1B[0m')
			end 
			RegisterServerEvent(thisname..':log')
			AddEventHandler(thisname..':log', function(strings,sourcename)
				print(strings.." player:"..GetPlayerName(source).." \n\x1B[32m[\x1B[33m"..thisname.."\x1B[32m]\x1B[33m"..GetResourcePath(sourcename)..'\x1B[0m')
			end)
		else 
			if GetCurrentResourceName() ~= thisname then 
				TriggerServerEvent(thisname..':log','\x1B[32m[client-utils]\x1B[0m'..thisname..'" is used on '..GetCurrentResourceName(),GetCurrentResourceName())
			end 
		end 
	end)
	end 
	threads.OnceThread = {}
	threads.CreateThreadOnce = function(name,fn)
		if threads.OnceThread[name] then 
			return 
		end 
		threads.OnceThread[name] = true
		
			CreateThread(function()
				if fn and type(fn) == 'function' or fn.__cfx_functionReference then 
						fn()
				else 
					error("CreateThreadOnce",2)
				end 
			end)
		
	end 
	threads.ClearThreadOnce = function(name)
		threads.OnceThread[name] = nil 
	end 

	--stable:
	function threads.IsActionTableCreated(timer) return threads.ActionTables[timer]  end 
	threads.Handle = 1
	threads.Handles = {}
	threads.Alive = {}
	threads.Timers = {}
	threads.Functions = {}
	threads.Once = {}
	threads.ActionTables = {}
	local LoopIt = function(_name,_timer,_func)
		if threads.Once[_name] then return end 
		if debuglog and not _timer then 
			print("threads(debug):[BAD Hobbits]Some LoopIt timer is nil on "..GetCurrentResourceName())
		end 
		local name = _name or tostring(_func)
		local timer = _timer>=0 and _timer or 0
		local IsThreadCreated = threads.IsActionTableCreated(timer) --threads.ActionTables[timer] Exist
		if IsThreadCreated then  
			if threads.Functions[name] then 
				print('[Warning]threads'..name..' is doubly and replaced')  
			end 
			threads.Alive[name] = true 
			threads.Functions[name] = _func
			threads.Timers[name] = timer 
			table.insert(threads.ActionTables[timer],name ) -- 如果default此毫秒已存在 則添加到循環流程中
		else                                -- 否則新建一個default的毫秒表 以及新建一個循環線程
			if threads.Functions[name] then 
				print('[Warning]threads'..name..' is doubly and replaced')  
			end 
			threads.Alive[name] = true 
			threads.Functions[name] = _func
			threads.Timers[name] = timer 
			threads.ActionTables[timer] = {}	
			local actiontable = threads.ActionTables[timer] 
			local vt = timer
			table.insert(threads.ActionTables[timer] , name)
			CreateThread(function() 
				local loop;loop = function()
					if #actiontable == 0 then 
						return 
					end 
					for i=1,#actiontable do 
						local function this()
							local v = actiontable[i]
							if threads.Alive[v] and threads.Functions[v] and threads.Timers[v] == timer then 
								local preBreaker = function(t,data) threads.Break(v) end
								threads.Functions[v](preBreaker,v,#actiontable)
							else 
								if actiontable and actiontable[i] then 
									table.remove(actiontable ,i) 
									if #actiontable == 0 then 
										threads.KillLoop(name,timer)
										return 
									end 
								end 
							end 
						end 
						this()
					end 
					SetTimeout(vt,loop)
				end 
				loop()
				return 
			end)
		end 
	end
	threads.CreateLoop = function(...) 
		local tbl = {...}
		local length = #tbl
		local func,timer,name
		if length == 3 then 
			name = tbl[1]
			timer = tbl[2]
			func = tbl[3]
		elseif  length == 2 then 
			name = GetCurrentResourceName()
			timer = tbl[1]
			func = tbl[2]
		elseif  length == 1 then 
			name = GetCurrentResourceName()
			timer = 0
			func = tbl[1]
		end 
		if debuglog then print('threads(debug):CreateLoop:CreateThread:'..timer, name) end
		LoopIt(name,timer,func)
		if threads.Handle >= 65530 then threads.Handle = 1 end 
		threads.Handle = threads.Handle + 1
		threads.Handles[threads.Handle] = name
		return threads.Handle
	end
	threads.CreateLoopOnce = function(...) 
		local tbl = {...}
		local length = #tbl
		local func,timer,name
		if length == 3 then 
			name = tbl[1]
			timer = tbl[2]
			func = tbl[3]
		elseif  length == 2 then 
			name = GetCurrentResourceName()
			timer = tbl[1]
			func = tbl[2]
		elseif  length == 1 then 
			name = GetCurrentResourceName()
			timer = 0
			func = tbl[1]
		end 
		if not threads.Once[name] then 
			if debuglog then print('threads(debug):CreateLoopOnce:CreateThread:'..timer, name) end
			LoopIt(name,timer,func)
			threads.Once[name] = true 
		end 
		if threads.Handle >= 65530 then threads.Handle = 1 end 
		threads.Handle = threads.Handle + 1
		threads.Handles[threads.Handle] = name
		return threads.Handle
	end
	threads.IsActionOfLoopAlive = function(name)
		return threads.Alive[name] and true or false
	end 
	threads.IsLoopAlive = function(name)
		return threads.Functions[name] and true or false
	end 
	threads.KillLoop = function(name,timer)
		threads.Alive[name] = nil 
		threads.Functions[name] = nil
		threads.Timers[name] = nil 
		threads.ActionTables[timer] = nil	
		threads.Once[name]  = nil
		if debuglog then print('threads(debug):KillLoop:'..name,timer) end
	end 
	threads.KillActionOfLoop = function(name)
		for timer,_name in pairs (threads.ActionTables) do 
			if _name == name then 
				for i=1,#threads.ActionTables[timer] do 
					if threads.ActionTables[timer][i] == name then 
						table.remove(threads.ActionTables[timer] ,i) 
						if #threads.ActionTables[timer] == 0 then 
							threads.KillLoop(name,timer)
							return 
						end 
					end 
				end 
			end 
		end 
		threads.Alive[name] = nil 
		threads.Once[name] = nil 
		threads.Functions[name] = nil
		if debuglog then print('threads(debug):KillLoop:'..name) end
	end 
	threads.KillHandleOfLoop = function(handle)
		if threads.Handles[handle] then 
			threads.KillActionOfLoop(threads.Handles[handle])
		end 
	end 
	threads.Break = function(name)
		if threads.IsActionOfLoopAlive(name) then threads.KillActionOfLoop(name) end 
	end 
	threads.BreakCustom = function(name)
		if threads.IsActionOfLoopAliveCustom(name) then threads.KillActionOfLoopCustom(name) end 
	end 
	threads.AddPositions = function(actionname,datas,rangeorcb,_cb)
        exports.threads:AddPositions(actionname,datas,rangeorcb,_cb)
    end 
    threads.AddPosition = function(actionname,data,rangeorcb,_cb)
        exports.threads:AddPosition(actionname,data,rangeorcb,_cb)
    end 
	threads.IsArrivalExist = function(actionname)
        return exports.threads:IsArrivalExist(actionname)
    end 
	threads.ArrivalDelete = function(actionname)
        exports.threads:ArrivalDelete(actionname)
    end 