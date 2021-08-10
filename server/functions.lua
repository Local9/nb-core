NB.Async = com.lua.utils.Async
NB.Utils = com.lua.utils
NB.Flow = com.lua.utils.Flow
NB.Threads = com.lua.threads

NB.SetCacheSomething = function(...) return com.lua.utils.Table.SetTableSomething(NB["_CACHE_"],...) end
NB.IsCacheSomthingExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB["_CACHE_"],...) end 
NB.GetCacheSomthing = function(...) return com.lua.utils.Table.GetTableSomthing(NB["_CACHE_"],...) end  
NB.RegisterServerCallback = ESX.RegisterServerCallback 

NB.SendClientMessage = function(playerId, color, message)
	TriggerClientEvent('chat:addMessage',playerId, {
	  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
	  multiline = true,
	  args = {message}
	})
end 

NB.SendClientMessageToAll = function(color,message)
	TriggerClientEvent('chat:addMessage',-1, {
	  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
	  multiline = true,
	  args = { message}
	})
end 
