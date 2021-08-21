NB.AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	if NB.PlayerId then 
		local playerId = NB.PlayerId(source)
		NB.TriggerEvent('NB:log','Player Connected',false,playerId)
		
		
		if OnPlayerConnect then OnPlayerConnect(playerId, name, setKickReason, deferrals) end 
	end 
end)

NB.AddEventHandler('playerDropped', function (reason)
	local playerId = tonumber(source)
	if playerId then 
		NB.TriggerEvent('NB:log','Player Disconnected',false,playerId)
		
		
		if OnPlayerDisconnect then OnPlayerDisconnect(playerId) end 
		if NB.ReleasePlayer then NB.ReleasePlayer() end
	end 
end)