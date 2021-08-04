NB.TriggerServerCallback = ESX.TriggerServerCallback 
NB.com = com 
NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords = vector3(-802.311, 175.056, 72.8446)
	local heading = 0.0 
	local model = `mp_m_freemode_01`
	NB.com.lua.utils.SpawnManager.Spawn(coords, heading, model)
end 

NB.SpawnPlayer = function(coords, heading, model)
	local coords = coords or vector3(-802.311, 175.056, 72.8446)
	local heading = 0.0 
	local model = model or `mp_m_freemode_01`
	NB.com.lua.utils.SpawnManager.Spawn(coords, heading, model)
end 

