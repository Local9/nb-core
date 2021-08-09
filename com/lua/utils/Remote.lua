
if IsServer() then 
	com.lua.utils.Remote.mysql_execute = function(...)
		--local args = {...}
		--TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:execute(...)
	end 
	com.lua.utils.Remote.mysql_execute_sync = function(...)
		--local args = {...}
		--TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:executeSync(...)
	end 
	
	com.lua.utils.Remote.mysql_scalar = function(...)
		--local args = {...}
		--TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:scalar(...)
	end 
	com.lua.utils.Remote.mysql_scalar_sync = function(...)
		--local args = {...}
		--TriggerEvent('NB:log',json.encode(args))
		return exports.ghmattimysql:scalarSync(...)
	end 
	
end 
