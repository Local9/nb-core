CreateThread(function()

end)



CreateThread(function()
    NB.TriggerServerCallback('servertime',function (...)
        print("Server Time",...)
    end)
	NB.TriggerServerCallback('servertime2',function (...)
        print("Server Time 2",...)
    end)

end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('NB:OnSpawnPlayer')
end)


	
RegisterNetEvent('NB:SpawnAtLastPosition')
AddEventHandler('NB:SpawnAtLastPosition', function(PosX, PosY, PosZ, Heading, Model)
	--[=[
    local defaulModel = GetHashKey('mp_m_freemode_01')
    RequestModel(defaulModel)
    while not HasModelLoaded(defaulModel) do
        Citizen.Wait(1)
    end
    SetPlayerModel(PlayerId(), defaulModel)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(defaulModel)

    SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 1, 0, 0, 1)
	--]=]
	exports.spawnmanager:spawnPlayer({
			x = PosX or -802.311, y = PosY or 175.056, z = PosZ or 72.8446,heading = Heading or 0.0,model = Model or `mp_m_freemode_01`,
			skipFade = false
		}, function()
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		FreezeEntityPosition(PlayerPedId(), false)
	end)
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        lastX, lastY, lastZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        TriggerServerEvent('NB:SavePlayerPosition', lastX, lastY, lastZ)
    end
end)