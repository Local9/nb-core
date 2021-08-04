local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 

if IsServer() then 
	com.utils.Remote.mysql_execute = function(...)
		return exports.ghmattimysql:execute(...)
	end 
end 
