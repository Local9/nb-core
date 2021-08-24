NB.TriggerServerCallback = ESX.TriggerServerCallback 
NB.SpawnPlayer = function(coords, heading)
	NB.Utils.SpawnManager.Spawn(coords, heading)
	local playerid,ped = PlayerId(),PlayerPedId()
	if OnPlayerSpawn then OnPlayerSpawn(playerid,ped) end 
	NB.TriggerEvent('NB:OnPlayerSpawn')
	NB.TriggerServerEvent('NB:OnPlayerSpawn',PedToNet(ped))
end 

NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	NB.Skin.LoadDefaultModel(true,function()
		NB.SpawnPlayer(coords, heading)
	end )
end 

