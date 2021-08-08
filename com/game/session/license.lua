com.game.license.GetLicense = function(playerId)
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

