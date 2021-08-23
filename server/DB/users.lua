DB.User.IsUserExist = function (license)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM users WHERE license = @license', {
		['@license'] = license
	})
	local r = not not (result and result > 0)
	return r
end 

DB.User.CreateUser = function (license,cb)
	NB.Utils.Remote.mysql_execute('INSERT INTO users (license) VALUES (@license)', {
			['@license'] = license
		}, function(result)
			--下面是新建角色才會執行，目前先省略建立步驟
			cb(result)
	end )
end 

DB.User.DataSlotTemplateGenerator = function(genwhat,tablename,template)
	local SomethingExist = false
	local Something = nil

	while not SomethingExist do
		Something = com.lua.utils.UUID.GenByTemplate(template)
		if not Something then error("error on creating player something",2) end 
		local result = NB.Utils.Remote.mysql_execute_sync('SELECT COUNT(*) as count FROM '..tablename..' WHERE '..genwhat..'=@'..genwhat..'', {['@'..genwhat..''] = Something})
		if result[1].count == 0 then
			SomethingExist = true
		end
	end
	return Something
end

