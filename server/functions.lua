NB.Utils = com.lua.utils
NB.Threads = com.lua.threads
NB.RegisterServerCallback = ESX.RegisterServerCallback 
NB.SetTempSomething = function(...) return com.lua.utils.Table.SetTableSomething(NB._temp_,...) end
NB.IsTempSomthingExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB._temp_,...) end 
NB.GetTempSomthing = function(...) return com.lua.utils.Table.GetTableSomthing(NB._temp_,...) end  


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
