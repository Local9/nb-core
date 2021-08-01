RegisterNetEvent('NB:OnPlayerSessionStart', function()
    print(1)
end)

CreateThread(function()
    print("[NBCore] Server Loaded")
end)