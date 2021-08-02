NB.RegisterServerCallback("NB:SpawnPlayer",function(source,cb)
    local source = source
    mysql_execute('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source)
    }, function(result)
        local pos = json.decode(result[1].position)
        cb(vector3(pos[1], pos[2], pos[3]), pos[4])
    end)
end )

