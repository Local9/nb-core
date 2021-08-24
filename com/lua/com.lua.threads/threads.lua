local threads = {}
com.lua.threads = threads

--stable:
threads._created = function (timer) 
	return threads._tasks[timer] 
 end 
threads._handle = 1
threads._handles = {}
threads._alive = {}
threads._timers = {}
threads._programs = {}
threads._once = {}
threads._tasks = {}
local loopit = function(_func,_timer,_name)
    if threads._once[_name] then return end 
	if debuglog and not _timer then 
		print("threads(debug):[BAD Hobbits]Some loopit timer is nil on "..GetCurrentResourceName())
	end 
    local name = _name or tostring(_func)
    local timer = _timer>=0 and _timer or 0
    local isCreated = threads._created(timer) --threads._tasks[timer] Exist
	if isCreated then  
        if threads._programs[name] then 
            print('[Warning]Threads'..name..' is doubly and replaced')  
        end 
        threads._alive[name] = true 
        threads._programs[name] = _func
        threads._timers[name] = timer 
        table.insert(threads._tasks[timer],name ) -- 如果default此毫秒已存在 則添加到循環流程中
    else                                -- 否則新建一個default的毫秒表 以及新建一個循環線程
		if threads._programs[name] then 
            print('[Warning]Threads'..name..' is doubly and replaced')  
        end 
        threads._alive[name] = true 
        threads._programs[name] = _func
        threads._timers[name] = timer 
        threads._tasks[timer] = {}	
		local thistasks = threads._tasks[timer] 
        local vt = timer
		table.insert(threads._tasks[timer] , name)
		CreateThread(function() 
			local b;
			b = function () 
                if #thistasks == 0 then 
                    return 
                end 
				for i=1,#thistasks do 
                    local v = thistasks[i]
                    if threads._alive[v] and threads._programs[v] and threads._timers[v] == timer then 
                        local preBreaker = function(t,data) threads.Break(v) end
                        threads._programs[v](preBreaker,v,#thistasks)
                    else 
                        if thistasks and thistasks[i] then 
                            table.remove(thistasks ,i) 
                            if #thistasks == 0 then 
                                threads.KillLoop(name,timer)
                                return 
                            end 
                        end 
                    end 
				end 
				SetTimeout(vt,b)
            end 
			b()
			
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
    loopit(func,timer,name)
    if threads._handle >= 65530 then threads._handle = 1 end 
    threads._handle = threads._handle + 1
    threads._handles[threads._handle] = name
    return threads._handle
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
    if not threads._once[name] then 
        if debuglog then print('threads(debug):CreateLoopOnce:CreateThread:'..timer, name) end
        loopit(func,timer,name)
        threads._once[name] = true 
    end 
    if threads._handle >= 65530 then threads._handle = 1 end 
    threads._handle = threads._handle + 1
    threads._handles[threads._handle] = name
    return threads._handle
end
threads.IsActionOfLoopAlive = function(name)
    return threads._alive[name] and true or false
end 
threads.IsLoopAlive = function(name)
    return threads._programs[name] and true or false
end 
threads.KillLoop = function(name,timer)
    threads._alive[name] = nil 
    threads._programs[name] = nil
    threads._timers[name] = nil 
    threads._tasks[timer] = nil	
    threads._once[name]  = nil
    if debuglog then print('threads(debug):KillLoop:'..name,timer) end
end 
threads.KillActionOfLoop = function(name)
    for timer,_name in pairs (threads._tasks) do 
        if _name == name then 
            for i=1,#threads._tasks[timer] do 
                if threads._tasks[timer][i] == name then 
                    table.remove(threads._tasks[timer] ,i) 
                    if #threads._tasks[timer] == 0 then 
                        threads.KillLoop(name,timer)
                        return 
                    end 
                end 
            end 
        end 
    end 
    threads._alive[name] = nil 
    threads._once[name] = nil 
    threads._programs[name] = nil
    if debuglog then print('threads(debug):KillLoop:'..name) end
end 
threads.KillHandleOfLoop = function(handle)
    if threads._handles[handle] then 
        threads.KillActionOfLoop(threads._handles[handle])
    end 
end 
threads.Break = function(name)
    if threads.IsActionOfLoopAlive(name) then threads.KillActionOfLoop(name) end 
end 
threads.OnceThread = {}
threads.CreateThreadOnce = function(name,fn)
    if threads.OnceThread[name] then 
        return 
    end 
    threads.OnceThread[name] = true
    CreateThread(fn)
end 
threads.ClearThreadOnce = function(name)
    threads.OnceThread[name] = nil 
end 