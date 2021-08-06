
if IsServer() then 
	com.lua.utils.Remote.mysql_execute = function(...)
		return exports.ghmattimysql:execute(...)
	end 
end 
