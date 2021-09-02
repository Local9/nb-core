NB.SpawnPlayer = function(coords, heading)
	NB.Utils.SpawnManager.Spawn(coords, heading)
	local playerid,ped = PlayerId(),PlayerPedId()
	if OnPlayerSpawn then OnPlayerSpawn(playerid,ped) end 
	NB.TriggerEvent('NB:OnPlayerSpawn')
	NB.TriggerServerEvent('NB:OnPlayerSpawn',PedToNet(ped))
end 

NB_LOCAL.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = REGISTER_DEFAULT_SPAWNPOSITION
	NB.Skin.LoadDefaultModel(true,function()
		NB.SpawnPlayer(coords, heading)
	end )
end 

NB.AddEventHandler("NB:CancelPlayerDefaultSpawn",function()
	com.game.Client.Session.CancelDefaultSpawn()
end)

RegisterNetEvent("chat:addMessage",function()
	local player,ped = PlayerId(),PlayerPedId()
	if OnPlayerChat then OnPlayerChat(player,ped ) end
	--if OnPlayerUpdate then OnPlayerUpdate(player,ped ) end
end)


