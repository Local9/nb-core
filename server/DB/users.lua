DB.User.IsUserExist = function (license)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM users WHERE license = ?', {
		license
	})
	local r = not not (result and result > 0)
	return r
end 

DB.User.CreateUser = function (license,ip,licenses)
	local result = NB.Utils.Remote.mysql_execute_sync('INSERT INTO users (license,ip,otherlicenses) VALUES (?,?,?)', {license,ip,NB.encodeSql(json.encode(licenses))})
	CreateThread(function()
	NB.TriggerEvent("NB:log",NB.encodeSql(json.encode(licenses))..","..json.encode(licenses))
	end)
	
	local r = result and result.affectedRows>0 and true or false
	return r
end 

DB.User.DataSlotTemplateGenerator = function(genwhat,tablename,template)
	local SomethingExist = false
	local Something = nil

	while not SomethingExist do
		Something = com.lua.utils.UUID.GenByTemplate(template)
		if not Something then error("error on creating player something",2) end 
		local result = NB.Utils.Remote.mysql_execute_sync('SELECT COUNT(*) as count FROM '..tablename..' WHERE '..genwhat..'=?', {Something})
		--print(json.encode(result))
		if result and result[1] and result[1].count == 0 then
			SomethingExist = true
		end
	end
	return Something
end

