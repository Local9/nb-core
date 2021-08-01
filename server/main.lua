CreateThread(function()

end)



NB.RegisterServerCallback("servertime",function(...)
    return os.date("%Y %m %d %H %M %S")
end )