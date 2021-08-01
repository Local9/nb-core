RegisterNetEvent('NB:OnPlayerSessionStart', function()
    print("PlayerSessionStart",source)
end)

CreateThread(function()
    print("[NBCore] Server Loaded")
end)