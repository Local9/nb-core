CreateThread(function()

end)



CreateThread(function()
    NB.TriggerServerCallback('servertime',function (str)
        print("Server Time",str)
    end,234)
	NB.TriggerServerCallback('servertime2',function (str)
        print("Server Time 2",str)
    end)
	

end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('NB:OnSpawnPlayer')
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        TriggerServerEvent('NB:SavePlayerPosition', GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
    end
end)