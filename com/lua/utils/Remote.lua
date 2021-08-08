
if IsServer() then 
	com.lua.utils.Remote.mysql_execute = function(...)
		return exports.ghmattimysql:execute(...)
	end 
	com.lua.utils.Remote.mysql_execute_sync = function(...)
		return exports['ghmattimysql']:executeSync(...)
	end 
	
end 
