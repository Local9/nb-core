NB.TriggerServerCallback = ESX.TriggerServerCallback 
NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	NB.Skin.LoadDefaultModel(true,function()
		NB.Utils.SpawnManager.Spawn(coords, heading)
	end )
end 


