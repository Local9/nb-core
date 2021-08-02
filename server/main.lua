CreateThread(function()

end)

AddEventHandler('NB_NOT_NET:CreateOrLogin', function(source, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local identifier

    -- you can use [steam, license] --
    -- 你可以使用[steam, license] --

    for k, v in ipairs(identifiers) do 
        if string.match(v, 'steam:') then
            identifier = v
            break
        end
    end

    if not identifier then
    else
        exports.ghmattimysql:scalar('SELECT 1 FROM users WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            if not result then
                exports.ghmattimysql:execute('INSERT INTO users (identifier) VALUES (@identifier)', {
                    ['@identifier'] = identifier
                })
            end
        end)
    end
end)



NB.RegisterServerCallback("servertime",function(source,cb,value)
	print(value)
	CreateThread(function() Wait(3000)
    cb(os.date("%Y %m %d %H %M %S [1]"))
	end)
end )

NB.RegisterServerCallback("servertime2",function(source,cb)
    cb(os.date("%Y %m %d %H %M %S [2]"))
end )

NB.RegisterServerCallback("NB:SpawnPlayer",function(source,cb)
    local source = source
    exports.ghmattimysql:execute('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source)
    }, function(result)
        local pos = json.decode(result[1].position)
        cb(vector3(pos[1], pos[2], pos[3]), pos[4])
    end)
end )


RegisterServerEvent('NB:SavePlayerPosition')
AddEventHandler('NB:SavePlayerPosition', function(coords,heading)
    local source = source
	local x, y, z = table.unpack(coords)
    exports.ghmattimysql:execute('UPDATE users SET position = @position WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source),
        ['@position'] = '{ ' .. x  .. ', ' .. y .. ', ' .. z .. ', ' .. heading .. '}'
    })
end)