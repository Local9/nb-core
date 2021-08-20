
local Async = {}
com.lua.utils.Async = Async
function Async.parallel(tasks, cb)
	if #tasks == 0 then
		if cb then cb({}) else error("Async cb",2)  end 
		return
	end
	local remaining = #tasks
	local results   = {}
	for i=1, #tasks, 1 do
		CreateThread(function()
			tasks[i](function(result)
				table.insert(results, result)
				remaining = remaining - 1;
				if remaining == 0 then
					if cb then cb(results) else error("Async cb",2) end 
					return
				end
				return
			end)
			return 
		end)
	end
end
function Async.parallelLimit(tasks, limit, cb)
	if #tasks == 0 then
		if cb then cb({}) else error("Async cb",2)  end 
		return
	end
	local remaining = #tasks
	local running   = 0
	local queue     = {}
	local results   = {}
	for i=1, #tasks, 1 do
		table.insert(queue, tasks[i])
	end
	local function processQueue()
		if #queue == 0 then
			return
		end
		while running < limit and #queue > 0 do
			local task = table.remove(queue, 1)
			running = running + 1
			task(function(result)
				table.insert(results, result)
				remaining = remaining - 1;
				running   = running - 1
				if remaining == 0 then
					if cb then 
						cb(results)
					else 
						error("Async cb",2) 
					end 
					return
				end
				return
			end)
		end
		CreateThread(processQueue)
		return 
	end
	processQueue()
end
function Async.series(tasks, cb)
	if not cb then  error("Async cb",2)  end 
	Async.parallelLimit(tasks, 1, cb)
end
function Async.waterfall(tasks, cb)
	if not cb then  error("Async cb",2)  end 
	local nextArg = {}
	for i, v in pairs(tasks) do
		local error = false
		v(function(err, ...)
			local arg = {...}
		    nextArg = arg;
		    if err then
				error = true
			end
		end, table.unpack(nextArg))
		if error then return cb("error") end
	end
	cb(nil, table.unpack(nextArg))
end

com.lua.utils.Async.Tasks = {}
com.lua.utils.Async.CanRun = false

com.lua.utils.Async.CreateLimit = function(namespace,limit,fn,CB)
	local task = function(cb) 
		CreateThread(function() 
			
			local result = fn()
			cb(result)
			CB(result)
		end) 
	end 
	table.insert(com.lua.utils.Async.Tasks, task)
	if IsClient() then 
		if not com.lua.utils.Async.Busy then 
			BeginTextCommandBusyspinnerOn("MP_SPINLOADING")
			EndTextCommandBusyspinnerOn(3)
			com.lua.utils.Async.Busy = true 
		end 
	end 
	if #com.lua.utils.Async.Tasks <= limit and com.lua.utils.Async.CanRun==false then 
		com.lua.utils.Async.CanRun = true 
		com.lua.threads.CreateLoopOnce("CreateAsyncCheck"..namespace,333,function(Break)
			if com.lua.utils.Async.CanRun then 
				if #com.lua.utils.Async.Tasks > 0 then 
					com.lua.utils.Async.CanRun = false
					com.lua.utils.Async.parallelLimit(com.lua.utils.Async.Tasks,limit,  function(results)
						--print(json.encode(results))
						com.lua.utils.Async.Tasks = {}
						com.lua.utils.Async.CanRun = true
						if IsClient() then 
							if BusyspinnerIsOn() then
								BeginTextCommandBusyspinnerOn("FM_COR_AUTOD")
								EndTextCommandBusyspinnerOn(4)
								
								CreateThread(function() Wait(50)
									--print('off spin')
									BusyspinnerOff()
									com.lua.utils.Async.Busy = false 
								end)
							end 
						end 
					end)
				else 
					Break()
					com.lua.utils.Async.Tasks = {}
					com.lua.utils.Async.CanRun = false
					 
				 
				end 
			end 
		end)
	end 
end 

com.lua.utils.Async.CreateSeries = function(namespace,fn,CB)
	local task = function(cb) 
		CreateThread(function() 
			local result = fn()
			cb(result)
			CB(result)
		end) 
	end 
	table.insert(com.lua.utils.Async.Tasks, task)
 
	if #com.lua.utils.Async.Tasks <= 1 and com.lua.utils.Async.CanRun==false then 
		com.lua.utils.Async.CanRun = true 
		com.lua.threads.CreateLoopOnce("CreateAsyncCheck"..namespace,333,function(Break)

			if com.lua.utils.Async.CanRun then 
				if #com.lua.utils.Async.Tasks > 0 then 
					com.lua.utils.Async.CanRun = false
					com.lua.utils.Async.parallelLimit(com.lua.utils.Async.Tasks,1,  function(results)
						--print(json.encode(results))
						com.lua.utils.Async.Tasks = {}
						com.lua.utils.Async.CanRun = true
						
					end)
				else 
					Break()
					com.lua.utils.Async.Tasks = {}
					com.lua.utils.Async.CanRun = false
					 
				 
				end 
			end 
		end)
	end 
end 


--[=[
local tasks = {}

for i = 1, 100, 1 do
	local task = function(cb)
		SetTimeout(1000, function()
			local result = math.random(1, 50000)

			cb(result)
		end)
	end

	table.insert(tasks, task)
end

Async.parallel(tasks, function(results)
	print(json.encode(results))
end)

Async.parallelLimit(tasks, 2, function(results)
	print(json.encode(results))
end)

Async.series(tasks, function(results)
	print(json.encode(results))
end)
--]=]
