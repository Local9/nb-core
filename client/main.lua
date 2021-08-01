CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(33)
    end
    TriggerServerEvent('NB:OnPlayerSessionStart')
    return 
end)

CreateThread(function()
    print("[NBCore] Client Loaded")
    --exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
    exports.spawnmanager:spawnPlayer({
            x = -802.311, y = 175.056, z = 72.8446,heading = 0.0,model = `a_m_y_hipster_01`,
            skipFade = false
        }, function()
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)

