NB.TriggerServerCallback = ESX.TriggerServerCallback 

NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	TriggerEvent('skinchanger:loadDefaultModel', true,function()
		NB.Utils.SpawnManager.Spawn(coords, heading)
	end )
	
end 
