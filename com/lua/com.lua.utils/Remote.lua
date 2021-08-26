
if IsServer() then 
	com.lua.utils.Remote.mysql_execute = function(...)
		--local args = {...}
		--NB.TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:execute(...)
	end 
	com.lua.utils.Remote.mysql_execute_sync = function(...)
		--local args = {...}
		--NB.TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:executeSync(...)
	end 
	
	com.lua.utils.Remote.mysql_scalar = function(...)
		--local args = {...}
		--NB.TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:scalar(...)
	end 
	com.lua.utils.Remote.mysql_scalar_sync = function(...)
		--local args = {...}
		--NB.TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:scalarSync(...)
	end 
	com.lua.utils.Remote.mysql_store = function(...)
		--local args = {...}
		--NB.TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:store(...)
	end 
	com.lua.utils.Remote.mysql_storeSync = function(...)
		--local args = {...}
		--NB.TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:storeSync(...)
	end 
end 
