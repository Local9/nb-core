print(4)
local Async = {}
com.lua.utils.Async = Async
function Async.parallel(tasks, cb)
	if #tasks == 0 then
		if cb then cb({}) end 
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
					if cb then cb(results) end 
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
		if cb then cb({}) end 
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
					if cb then cb(results) end 
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
	Async.parallelLimit(tasks, 1, cb)
end
function Async.waterfall(tasks, cb)
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
