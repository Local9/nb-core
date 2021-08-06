NB.Utils = com.lua.utils
NB.Threads = com.lua.threads

NB.GetPlayers = function()
	return NB.Players
end

NB.GetPlayerFromId = function(source)
	return NB.Players[tonumber(source)]
end

NB.ReleasePlayer = function(source)
	NB.Players[source] = nil 
end


NB.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(NB.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

NB.GetIdentifier = function(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			local identifier = string.gsub(v, 'license:', '')
			return identifier
		end
	end
end

NB.GetIdentifier = NB.GetLicense

NB.RegisterServerCallback = ESX.RegisterServerCallback 

NB.SendClientMessage = function(source, color, message)
	TriggerClientEvent('chat:addMessage',source, {
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
