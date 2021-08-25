if IsServer() then 
com.game.Server.License.Get = function(playerId)
	local identifiers = GetPlayerIdentifiers(playerId)
	local license

	-- you can use [steam, license] --
	-- 你可以使用[steam, license] --

	for k, v in ipairs(identifiers) do 
		if string.match(v, 'license:') then
			license = v
			break
		end
	end
	return license
end 
com.game.Server.License.GetIP = function(playerId)
	local identifiers = GetPlayerIdentifiers(playerId)
	local license

	-- you can use [steam, license] --
	-- 你可以使用[steam, license] --

	for k, v in ipairs(identifiers) do 
		if string.match(v, 'ip:') then
			license = string.sub(v, 4)
			print(license)
			break
		end
	end
	return license
end 
com.game.Server.License.GetOthers = function(playerId)
	local identifiers = GetPlayerIdentifiers(playerId)
	local licenses = {}
	for k, v in ipairs(identifiers) do 
		if not string.match(v, 'license:') then
			table.insert(licenses,v)
		end
	end
	return licenses
end 
end 