RegisterNetEvent('NB:SpawnPlayerDefault', function()
	exports.spawnmanager:setAutoSpawn(false)
	--exports.spawnmanager:forceRespawn()
	exports.spawnmanager:spawnPlayer({
			x = -802.311, y = 175.056, z = 72.8446,heading = 0.0,model = `mp_m_freemode_01`,
			skipFade = false
		}, function()
		SetPedDefaultComponentVariation(PlayerPedId())
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		FreezeEntityPosition(PlayerPedId(), false)
	end)
end)