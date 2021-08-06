NB.Utils = com.lua.utils
NB.Threads = com.lua.threads
NB.TriggerServerCallback = ESX.TriggerServerCallback 

NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	local model = `mp_m_freemode_01`
	NB.Utils.SpawnManager.Spawn(coords, heading, model)
end 

NB.SpawnPlayer = function(coords, heading, model)
	local coords,heading = coords,heading or DEFAULT_SPAWN_POSITION
	local model = model or `mp_m_freemode_01`
	NB.Utils.SpawnManager.Spawn(coords, heading, model)
end 

RegisterNetEvent('NB:SpawnPlayer', function()
	NB.TriggerServerCallback('NB:SpawnPlayer',function (coords, heading, model)
		NB.SpawnPlayer(coords, heading, model)
	end)
end)


CreateThread(function() Wait(500)
	TriggerEvent('NB:SpawnPlayer')
	TriggerEvent('NB:CancelDefaultSpawn')
	NB.Threads.CreateLoop('spawn',1000,function()
		TriggerServerEvent('NB:SavePlayerPosition',GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
	end)
end)
