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



NB.RegisterServerCallback("servertime",function(...)
    return os.date("%Y %m %d %H %M %S [1]")
end )

NB.RegisterServerCallback("servertime2",function(...)
    return os.date("%Y %m %d %H %M %S [2]")
end )


RegisterServerEvent('NB:SavePlayerPosition')
AddEventHandler('NB:SavePlayerPosition', function(PosX, PosY, PosZ)
    local source = source
    exports.ghmattimysql:execute('UPDATE users SET position = @position WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifier(source),
        ['@position'] = '{ ' .. PosX  .. ', ' .. PosY .. ', ' .. PosZ .. '}'
    })
end)