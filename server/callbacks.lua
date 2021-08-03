NB.RegisterServerCallback("NB:SpawnPlayer",function(source,cb)
    local source = source
    mysql_execute('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source)
    }, function(result)
        local pos = json.decode(result[1].position)
        cb(vector3(pos[1], pos[2], pos[3]), pos[4])
    end)
end )

NB.RegisterServerCallback('NB_UNSHARED:SavePlayerPosition', function(source,cb,coords,heading)
    local source = source
	local x, y, z = table.unpack(coords)
    mysql_execute('UPDATE users SET position = @position WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source),
        ['@position'] = '{ ' .. x  .. ', ' .. y .. ', ' .. z .. ', ' .. heading .. '}'
    })
end)



--[=[
NB.RegisterServerCallback("servertime",function(source,cb,value,heading)
    cb(os.date("%Y %m %d %H %M %S"),value,heading)
end )
--]=]