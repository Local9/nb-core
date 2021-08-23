NB["_PLAYER_"].thisPlayerId = -1

NB.GetPlayers = function(id)
	return not id and NB.Players or NB.Players[id]
end

NB.UpdatePlayerId = function(playerId)
	if tonumber(playerId) then 
		NB["_PLAYER_"].thisPlayerId = tonumber(playerId)
	end 
	local playerId = NB["_PLAYER_"].thisPlayerId
	return playerId,NB.GetPlayers(playerId)
end

NB.PlayerId = function(playerId)
	local playerid,playerdata = NB.UpdatePlayerId(playerId)
	return playerid,playerdata
end 

NB.PlayerData = function(playerId)
	local playerid, playerdata = NB.UpdatePlayerId(playerId)
	return playerdata,playerid
end 

NB.SetPlayer = function(playerhandle)
	NB.Players[NB.PlayerId()] = playerhandle
end 

NB.ReleasePlayer = function()
	NB.Players[NB.PlayerId()] = nil 
end

NB.GetPlayerLicense = com.game.Server.License.Get --playerid

NB.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(NB.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

function CreatePlayer(playerId, license,citizenID)
	local self = {}
	self.playerId = playerId
	self.PlayerId = playerId
	self.source = playerId
	self.license = license
	self.variables = {}
	self.citizenID = citizenID
	self.triggerEvent = function(eventName, ...)
		NB.TriggerClientEvent(eventName, self.source, ...)
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	return self
end

NB.RegisterNetEvent('NB:OnPlayerJoined', function() --called by com.game.session.spawn.lua/CreateThread
	local source = tonumber(source)
	local playerdata,playerId = NB.PlayerData(source)
	local license = NB.GetPlayerLicense(playerId)
	if OnPlayerJustJoin then OnPlayerJustJoin(playerId, license, playerdata) end 
end)


