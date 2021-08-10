NB.Async = com.lua.utils.Async
NB.Utils = com.lua.utils
NB.Flow = com.lua.utils.Flow
NB.Threads = com.lua.threads

NB.SetCacheSomething = function(...) return com.lua.utils.Table.SetTableSomething(NB["_CACHE_"],...) end
NB.IsCacheSomthingExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB["_CACHE_"],...) end 
NB.GetCacheSomthing = function(...) return com.lua.utils.Table.GetTableSomthing(NB["_CACHE_"],...) end  
NB.TriggerServerCallback = ESX.TriggerServerCallback 

NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	TriggerEvent('skinchanger:loadDefaultModel', true,function()
		NB.Utils.SpawnManager.Spawn(coords, heading)
	end )
	
end 
