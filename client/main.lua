CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(33)
    end
    TriggerServerEvent('NB:OnPlayerSessionStart')
    return 
end)