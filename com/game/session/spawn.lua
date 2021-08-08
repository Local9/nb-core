if IsClient() then 
	local DefaultSpawnCanceled = false 
	SetThreadPriority(0)
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(MAX_WANTED_LEVEL)
	CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(0)
		end
		DoScreenFadeOut(0)
		TriggerServerEvent('NB:OnPlayerJoined')
		com.lua.utils.SpawnManager.SpawnFreeze(PlayerId(),true)
		CreateThread(function()
			Wait(5000)
			if IsScreenFadedOut() and not IsScreenFadedIn() then
				DoScreenFadeIn(0)
				while not IsScreenFadedIn() do
					Citizen.Wait(0)
				end
				if not DefaultSpawnCanceled then 
					NB.SpawnPlayerDefault()
					print("Default Spawned Player due to no any spawn script handled.")
				else 
					
				end 
			end
		end)
		return 
	end)
	AddEventHandler("NB:CancelDefaultSpawn",function()
		DefaultSpawnCanceled = true
	end )
end 

