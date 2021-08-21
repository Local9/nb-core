
NB.RegisterServerCallback = ESX.RegisterServerCallback 

NB.SendClientMessage = function(playerId, color, message)
	NB.TriggerClientEvent('chat:addMessage',playerId, {
	  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
	  multiline = true,
	  args = {message}
	})
end 

NB.SendClientMessageToAll = function(color,message)
	NB.TriggerClientEvent('chat:addMessage',-1, {
	  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
	  multiline = true,
	  args = { message}
	})
end 
