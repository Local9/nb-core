if IsClient() then 
	local DefaultSpawnCanceled = false 
	SetThreadPriority(0)
	CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(0)
		end
		DoScreenFadeOut(0)
		TriggerServerEvent('NB:OnPlayerJoined')
		local player = PlayerId()
		SetPlayerControl(player, false, false)
		if IsEntityVisible(ped) then
			SetEntityVisible(ped, false)
		end
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		--SetCharNeverTargetted(ped, true)
		SetPlayerInvincible(player, true)
		--RemovePtfxFromPed(ped)
		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
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
		print('CancelDefaultSpawn')
	end )
end 

