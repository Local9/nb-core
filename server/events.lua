RegisterNetEvent('NB:SavePlayerPosition', function(coords,heading)
    local source = source
	local x, y, z = table.unpack(coords)
    mysql_execute('UPDATE users SET position = @position WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source),
        ['@position'] = '{ ' .. x  .. ', ' .. y .. ', ' .. z .. ', ' .. heading .. '}'
    })
end)

