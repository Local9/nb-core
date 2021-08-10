local Threads = {}
com.lua.threads = Threads

Threads.debuglog = false
Threads.busyspin = true


Threads.Custom_Handle = 1
Threads.Custom_Handles = {}
Threads.Custom_Alive = {}
Threads.Custom_Timers = {}
Threads.Custom_VarTimer = {}
Threads.Custom_Functions = {}
Threads.Custom_Once = {}
Threads.Custom_ActionTables = {}
function Threads.Custom_IsActionTableCreated(timer) return Threads.Custom_ActionTables[timer]  end 
Threads.loop_custom = function()error("Outdated",2) end 
Threads.loop2_custom = function(_name,_timer,_func,_varname)
    if Threads.Custom_Once[_name] then return end 
	if Threads.debuglog and not _timer then 
		print("[BAD Hobbits]Some Threads.loop2 timer is nil on "..GetCurrentResourceName())
	end 
    local name = _name or tostring(_func)
    local timer = _timer>=0 and _timer or 0
    local IsThreadCreated = Threads.Custom_IsActionTableCreated(timer) --Threads.Custom_ActionTables[timer] Exist
	if IsThreadCreated then  
        if Threads.Custom_Functions[name] then 
            print('[Warning]Threads'..name..' is doubly and replaced')  
        end 
        Threads.Custom_Alive[name] = true 
        Threads.Custom_Functions[name] = _func
        Threads.Custom_Timers[name] = timer 
        table.insert(Threads.Custom_ActionTables[timer],name ) -- 如果default此毫秒已存在 則添加到循環流程中
    else                                -- 否則新建一個default的毫秒表 以及新建一個循環線程
		if Threads.Custom_Functions[name] then 
            print('[Warning]Threads'..name..' is doubly and replaced')  
        end 
       
        Threads.Custom_Alive[name] = true 
        Threads.Custom_Functions[name] = _func
        Threads.Custom_Timers[name] = timer 
        Threads.Custom_ActionTables[timer] = {}	
		local actiontable = Threads.Custom_ActionTables[timer] 
        local vt = timer
		table.insert(Threads.Custom_ActionTables[timer] , name)
		CreateThread(function() 
			while true do
                
                if #actiontable == 0 then 
                    return 
                end 
				for i=1,#actiontable do 
                    local function this()
                    local v = actiontable[i]
                        if Threads.Custom_Alive[v] and Threads.Custom_Functions[v] and Threads.Custom_Timers[v] == timer then 
                            local predelaySetter = {setter=setmetatable({},{__call = function(t,data) Threads.SetLoopCustom(_varname,data) end}),getter=function(t,data) return Threads.GetLoopCustom(_varname) end}
                            local delaySetter = predelaySetter
                            local preBreaker = function(t,data) Threads.BreakCustom(v) end
                            Threads.Custom_Functions[v](_varname and delaySetter,preBreaker,v,#actiontable or preBreaker,v,#actiontable)
                        else 
                            if actiontable and actiontable[i] then 
                                table.remove(actiontable ,i) 
                                if #actiontable == 0 then 
                                    Threads.KillLoopCustom(name,timer)
                                    return 
                                end 
                            end 
                        end 
                    end 
                    this()
                    
				end 
                if _varname and Threads.Custom_VarTimer[_varname] then 
                    vt = Threads.Custom_VarTimer[_varname]
                end 
                Wait(vt>0 and vt or 0)
            end 
            return 
		end)
	end 
end
--pass Varname into parameters[4] with using Threads.SetLoopCustom(Varname,millisecond)/Threads.GetLoopCustom(Varname) to set/get the Delay or just using functionhash with setter/getter instead.
Threads.CreateLoopCustom = function(...) --actionname,defaulttimer(and ID of timer.will stack actions into the sameID),func,varname(link a custom name to this timer)
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
        --error("Threads.CreateLoopCustom(actionname,defaulttimer,func,varname)") 
        local shash = tostring(debug.getinfo(2,'S').source)..'line'..tostring(debug.getinfo(2).currentline)
        varname = shash
    end 
    Threads.Custom_VarTimer[varname] = defaulttimer
    if Threads.debuglog then 
        print("Linked VarName '"..varname .. "' to a Custom Timer")
        print('threads(debug):CreateLoopCustom:Varname:'..varname,"actionname: ".. name) 
    end
    Threads.loop2_custom(name,defaulttimer,func,varname)
    if Threads.Custom_Handle >= 65530 then Threads.Custom_Handle = 1 end 
    Threads.Custom_Handle = Threads.Custom_Handle + 1
    Threads.Custom_Handles[Threads.Custom_Handle] = name
    return Threads.Custom_Handle
end
Threads.CreateLoopOnceCustom = function(...) 
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
    if not Threads.Custom_Once[name] then 
    if not varname then 
        --error("Threads.CreateLoopCustom(actionname,defaulttimer,func,varname)") 
        local shash = tostring(debug.getinfo(2,'S').source)..'line'..tostring(debug.getinfo(2).currentline)
        varname = shash
    end 
    Threads.Custom_VarTimer[varname] = defaulttimer
    if Threads.debuglog then 
        print("Linked VarName '"..varname .. "' to a Custom Timer")
        print('threads(debug):CreateLoopOnceCustom:Varname:'..varname,"actionname: ".. name) 
    end
        if Threads.debuglog then print('threads(debug):CreateLoopOnce:CreateThread:'..defaulttimer, name) end
        Threads.loop2_custom(name,defaulttimer,func,varname)
        Threads.Custom_Once[name] = true 
    end 
    if Threads.Custom_Handle >= 65530 then Threads.Custom_Handle = 1 end 
    Threads.Custom_Handle = Threads.Custom_Handle + 1
    Threads.Custom_Handles[Threads.Custom_Handle] = name
    return Threads.Custom_Handle
end
Threads.CreateLoopCustomOnce =  Threads.CreateLoopOnceCustom
Threads.GetLoopCustom = function(varname)
    if not Threads.Custom_VarTimer[varname] then error("VarTimer not found.Make sure set varname in the last of Threads.CreateLoopCustom(actionname,defaulttimer,func,varname)",2) end 
    return Threads.Custom_VarTimer[varname]
end 
Threads.SetLoopCustom = function(varname,totimer)
    if not Threads.Custom_VarTimer[varname] then error("VarTimer not found.Make sure set varname in the last of Threads.CreateLoopCustom(actionname,defaulttimer,func,varname)",2) end 
    Threads.Custom_VarTimer[varname] = totimer 
end 
Threads.KillLoopCustom = function(name,timer)
    Threads.Custom_Alive[name] = nil 
    Threads.Custom_Functions[name] = nil
    Threads.Custom_Timers[name] = nil 
    Threads.Custom_ActionTables[timer] = nil	
    Threads.Custom_Once[name]  = nil
    if Threads.debuglog then print('threads(debug):KillLoopCustom:'..name,timer) end
end 
Threads.KillActionOfLoopCustom = function(name)
    for timer,_name in pairs (Threads.Custom_ActionTables) do 
        if _name == name then 
            for i=1,#Threads.Custom_ActionTables[timer] do 
                if Threads.Custom_ActionTables[timer][i] == name then 
                    table.remove(Threads.Custom_ActionTables[timer] ,i) 
                    if #Threads.Custom_ActionTables[timer] == 0 then 
                        Threads.KillLoopCustom(name,timer)
                        return 
                    end 
                end 
            end 
        end 
    end 
    Threads.Custom_Alive[name] = false 
    Threads.Custom_Once[name] = false 
    Threads.Custom_Functions[name] = nil
    if Threads.debuglog then print('threads(debug):KillActionOfLoopCustom:'..name) end
end 
Threads.KillHandleOfLoopCustom = function(handle)
    if Threads.Custom_Handle[handle] then 
        Threads.KillActionOfLoopCustom(Threads.Custom_Handle[handle])
    end 
end 
Threads.IsActionOfLoopAliveCustom = function(name)
    return Threads.Custom_Alive[name] and true or false 
end 
Threads.IsLoopAliveCustom = function(name)
    return Threads.Custom_Functions[name] and true or false 
end 


--debug 
if Threads.debuglog then 
local thisname = "threads"
CreateThread(function()
	if IsDuplicityVersion() then 
		if GetCurrentResourceName() ~= thisname then 
			print('\x1B[32m[server-utils]\x1B[0m'..thisname..' is used on '..GetCurrentResourceName().." \n\x1B[32m[\x1B[33m"..thisname.."\x1B[32m]\x1B[33m"..GetResourcePath(GetCurrentResourceName())..'\x1B[0m')
		end 
		RegisterServerEvent(thisname..':log')
		AddEventHandler(thisname..':log', function(strings,sourcename)
			print(strings.." player:"..GetPlayerName(NB.PlayerId(source)).." \n\x1B[32m[\x1B[33m"..thisname.."\x1B[32m]\x1B[33m"..GetResourcePath(sourcename)..'\x1B[0m')
		end)
	else 
		if GetCurrentResourceName() ~= thisname then 
			TriggerServerEvent(thisname..':log','\x1B[32m[client-utils]\x1B[0m'..thisname..'" is used on '..GetCurrentResourceName(),GetCurrentResourceName())
		end 
	end 
end)
end 


Threads.OnceThread = {}
Threads.CreateThreadOnce = function(fn)
    if Threads.OnceThread[tostring(fn)] then 
        return 
    end 
    Threads.OnceThread[tostring(fn)] = true
    CreateThread(fn)
end 
Threads.ClearThreadOnce = function(name)
    Threads.OnceThread[name] = nil 
end 
Threads.CreateLoad = function(thing,loadfunc,checkfunc,cb)
    if Threads.debuglog then print('threads(debug):CreateLoad:'..thing) end
    local handle = loadfunc(thing)
    local SinceTime = GetGameTimer()
    local failed = false
    local nowcb = nil     
    while true do 
        if not(checkfunc(thing)) and GetGameTimer() > SinceTime + 1000 then 
            if Threads.busyspin then 
            AddTextEntry("TEXT_LOAD", "Loading...(by threads)")
            BeginTextCommandBusyspinnerOn("TEXT_LOAD")
            EndTextCommandBusyspinnerOn(4)
            end 
        end 
        if not(checkfunc(thing)) and GetGameTimer() > SinceTime + 5000 then 
            failed = true 
        end 
        if HasScaleformMovieLoaded ~= checkfunc then 
            if checkfunc(thing) then 
                nowcb = thing 
            end 
        else 
            local handle = loadfunc(thing)
            if checkfunc(handle) then 
                nowcb = handle 
            end 
        end 
        if failed then 
            break 
        elseif nowcb then  
            break
        end 
        Wait(33)
    end 
    if Threads.busyspin then 
        BusyspinnerOff()
    end 
    if failed then
        if Threads.debuglog then print('threads(debug):CreateLoad:'..thing.."Loading Failed") end
    elseif nowcb then  
        cb(nowcb)
    end 
end
--stable:
function Threads.IsActionTableCreated(timer) return Threads.ActionTables[timer]  end 
Threads.Handle = 1
Threads.Handles = {}
Threads.Alive = {}
Threads.Timers = {}
Threads.Functions = {}
Threads.Once = {}
Threads.ActionTables = {}

Threads.loop = function()error("Outdated",2) end 
Threads.loop2 = function(_name,_timer,_func)
    if Threads.Once[_name] then return end 
	if Threads.debuglog and not _timer then 
		print("threads(debug):[BAD Hobbits]Some Threads.loop2 timer is nil on "..GetCurrentResourceName())
	end 
    local name = _name or tostring(_func)
    local timer = _timer>=0 and _timer or 0
    local IsThreadCreated = Threads.IsActionTableCreated(timer) --Threads.ActionTables[timer] Exist
	if IsThreadCreated then  
        if Threads.Functions[name] then 
            print('[Warning]Threads'..name..' is doubly and replaced')  
        end 
        Threads.Alive[name] = true 
        Threads.Functions[name] = _func
        Threads.Timers[name] = timer 
        table.insert(Threads.ActionTables[timer],name ) -- 如果default此毫秒已存在 則添加到循環流程中
    else                                -- 否則新建一個default的毫秒表 以及新建一個循環線程
		if Threads.Functions[name] then 
            print('[Warning]Threads'..name..' is doubly and replaced')  
        end 
        Threads.Alive[name] = true 
        Threads.Functions[name] = _func
        Threads.Timers[name] = timer 
        Threads.ActionTables[timer] = {}	
		local actiontable = Threads.ActionTables[timer] 
        local vt = timer
		table.insert(Threads.ActionTables[timer] , name)
		CreateThread(function() 
			while true do
                
                
                if #actiontable == 0 then 
                    return 
                end 
                
				for i=1,#actiontable do 
                    local function this()
                        local v = actiontable[i]
                        if Threads.Alive[v] and Threads.Functions[v] and Threads.Timers[v] == timer then 
                            local preBreaker = function(t,data) Threads.Break(v) end
                           
                            Threads.Functions[v](preBreaker,v,#actiontable)
                        else 
                            
                            if actiontable and actiontable[i] then 
                                table.remove(actiontable ,i) 
                                if #actiontable == 0 then 
                                    Threads.KillLoop(name,timer)
                                    return 
                                end 
                            end 
                        end 
                    end 
                    this()
                    
				end 
                Wait(vt)
            end 
            return 
		end)
	end 
end
Threads.CreateLoop = function(...) 
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
    if Threads.debuglog then print('threads(debug):CreateLoop:CreateThread:'..timer, name) end
    Threads.loop2(name,timer,func)
    if Threads.Handle >= 65530 then Threads.Handle = 1 end 
    Threads.Handle = Threads.Handle + 1
    Threads.Handles[Threads.Handle] = name
    return Threads.Handle
end
Threads.CreateLoopOnce = function(...) 
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
    if not Threads.Once[name] then 
        if Threads.debuglog then print('threads(debug):CreateLoopOnce:CreateThread:'..timer, name) end
        Threads.loop2(name,timer,func)
        Threads.Once[name] = true 
    end 
    if Threads.Handle >= 65530 then Threads.Handle = 1 end 
    Threads.Handle = Threads.Handle + 1
    Threads.Handles[Threads.Handle] = name
    return Threads.Handle
end

Threads.IsActionOfLoopAlive = function(name)
    return Threads.Alive[name] and true or false
end 
Threads.IsLoopAlive = function(name)
    return Threads.Functions[name] and true or false
end 
Threads.KillLoop = function(name,timer)
    Threads.Alive[name] = nil 
    Threads.Functions[name] = nil
    Threads.Timers[name] = nil 
    Threads.ActionTables[timer] = nil	
    Threads.Once[name]  = nil

    if Threads.debuglog then print('threads(debug):KillLoop:'..name,timer) end
end 
Threads.KillActionOfLoop = function(name)
    for timer,_name in pairs (Threads.ActionTables) do 
        if _name == name then 
            for i=1,#Threads.ActionTables[timer] do 
                if Threads.ActionTables[timer][i] == name then 
                    table.remove(Threads.ActionTables[timer] ,i) 
                    if #Threads.ActionTables[timer] == 0 then 
                        Threads.KillLoop(name,timer)
                        return 
                    end 
                end 
            end 
        end 
    end 
    Threads.Alive[name] = nil 
    Threads.Once[name] = nil 
    Threads.Functions[name] = nil
    
    if Threads.debuglog then print('threads(debug):KillLoop:'..name) end
end 
Threads.KillHandleOfLoop = function(handle)
    if Threads.Handles[handle] then 
        Threads.KillActionOfLoop(Threads.Handles[handle])
    end 
end 
Threads.Break = function(name)
    if Threads.IsActionOfLoopAlive(name) then Threads.KillActionOfLoop(name) end 
end 
Threads.BreakCustom = function(name)
    if Threads.IsActionOfLoopAliveCustom(name) then Threads.KillActionOfLoopCustom(name) end 
end 
