CreateThread(function()
    while true do Citizen.Wait(1000)
		TriggerServerEvent('NB:SavePlayerPosition', GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('NB:OnSpawnPlayer')
end)



