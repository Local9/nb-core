NB.TriggerServerCallback = ESX.TriggerServerCallback 
NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	NB.Skin.LoadDefaultModel(true,function()
		NB.Utils.SpawnManager.Spawn(coords, heading)
		if OnPlayerSpawn then OnPlayerSpawn(playerid) end 
		NB.TriggerEvent('NB:OnPlayerSpawn')
		NB.TriggerServerEvent('NB:OnPlayerSpawn')
	end )
end 

