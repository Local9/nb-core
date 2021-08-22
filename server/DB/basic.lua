function DB_IsUserExist(license)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM users WHERE license = @license', {
		['@license'] = license
	})
	local r = not not (result and result > 0)
	return r
end 

function DB_IsCharacterExist(citizenID)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM characters WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	local r = not not (result and result > 0)
	return r 
end 

function DB_GetCharacterLicense(citizenID)
	--'SELECT u.license FROM users u inner join characters s on u.citizen_id = s.citizen_id WHERE u.citizen_id = @citizen_id'
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT license FROM characters WHERE citizen_id = @citizen_id', {
		['@citizen_id'] = citizenID
	})
	return result and result or nil
end 

function DB_GetCharactersByLicense(license,idx)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT citizen_id FROM characters WHERE license = @license', {
		['@license'] = license
	})
	if idx then 
		return result and result[idx] and result[idx].citizen_id or nil
	else
		return result or nil 
	end 
end 
