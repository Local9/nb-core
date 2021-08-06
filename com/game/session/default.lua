local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 
if IsClient() then 
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
				NB.SpawnPlayerDefault()
				print("Default Spawned Player due to no any spawn script handled.")
			end
		end)
		return 
	end)
end 

if IsServer() then 
	AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
		if NB.GetPlayerFromIdentifier(NB.GetIdentifier(source)) then 
			DropPlayer(source, 'Error: Someone who is having Same License in the Server')
		end 
	end)
	AddEventHandler('playerDropped', function (reason)
	  NB.ReleasePlayer(source)
	end)


end 