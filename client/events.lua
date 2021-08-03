RegisterNetEvent('NB:SpawnPlayer', function()
	NB.TriggerServerCallback('NB:SpawnPlayer',function (coords, Heading, model)
		exports.spawnmanager:setAutoSpawn(false)
		--exports.spawnmanager:forceRespawn()
		local x,y,z 
		if coords then 
			x,y,z = coords.x,coords.y,coords.z
		end 
		exports.spawnmanager:spawnPlayer({
				x = x or -802.311, y = y or 175.056, z = z or 72.8446,heading = Heading or 0.0,model = Model or `mp_m_freemode_01`,
				skipFade = false
			}, function()
			SetPedDefaultComponentVariation(PlayerPedId())
			ShutdownLoadingScreen()
			ShutdownLoadingScreenNui()
			FreezeEntityPosition(PlayerPedId(), false)
		end)
	end)
end)

