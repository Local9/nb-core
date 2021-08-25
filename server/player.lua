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

NB.ReleasePlayer = function(playerid)
	NB.Players[playerid] = nil 
end

NB.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(NB.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

function CreatePlayerDatatable(playerId)
	local self = {}
	self.playerId = playerId
	self.PlayerId = playerId
	self.source = playerId
	self.variables = {}
	self.triggerEvent = function(eventName, ...)
		NB.TriggerClientEvent(eventName, self.source, ...)
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.init = function(k, v)
		self[k] = v
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
	local license = NB.GetLicense(playerId)
	local isNew
	if not playerdata then
		if license then 
			if not DB.User.IsUserExist(license) then
				isNew = true
				NB.TriggerEvent('NB:OnPlayerRegister',playerId, license)				
			else 
				isNew = false 
				NB.TriggerEvent('NB:OnPlayerLogin',playerId, license)
			end
		else 
			DropPlayer(playerId, 'Your license could not be found,the cause of this error is not known.')
			return false 
		end 
	end
	if not (isNew ==  nil) then 
		if OnPlayerJustJoin then OnPlayerJustJoin(playerId, license, isNew) end 
	end 
end)
NB.AddEventHandler("NB:OnPlayerRegister",function(playerId, license)
	local license = license
	
	local PrePlayerData = CreatePlayerDatatable(playerId)
	PrePlayerData.init("license",license)
	local result = DB.User.CreateUser(license)
	if result then 
		if OnPlayerRegister and playerid>0 then OnPlayerRegister(playerId, license, citizenID) end 
	end 
	
	--下面是新建角色才會執行，目前先省略建立步驟
	local CreateChar = true 
	if CreateChar then 
		local citizenID = DB.User.DataSlotTemplateGenerator('citizen_id','citizens','xxyyyyyyyyyx')
		DB.Citizen.Create(playerId, license, citizenID,function()
			print("Created a character into database")
			PrePlayerData.init("citizenID",citizenID)
			if OnPlayerLogin then OnPlayerLogin(playerId,license,citizenID) end 
		end )
	end 
	
	
end)
NB.AddEventHandler("NB:OnPlayerLogin",function(playerId, license)
	local PrePlayerData = CreatePlayerDatatable(playerId)
	local license = license
	local citizenID = DB.Citizen.GetIDFromLicense(license,1)
	PrePlayerData.init("license",license)
	PrePlayerData.init("citizenID",citizenID)
	if OnPlayerLogin and playerid>0 then OnPlayerLogin(playerId, license, citizenID) end 
end)
NB.RegisterNetEvent("NB:OnPlayerSpawn",function(PedNetid)
	local playerid = tonumber(source)
	if OnPlayerSpawn and playerid>0 then OnPlayerSpawn(playerid,PedNetid) end 
end)
NB.RegisterNetEvent("NB:OnPlayerUpdate",function(PedNetid)
	local playerid = tonumber(source)
	if OnPlayerUpdate then OnPlayerUpdate(playerid,PedNetid) end 
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	if NB.PlayerId then 
		local playerId = NB.PlayerId(source)
		NB.TriggerEvent('NB:log','Player Connected',false,playerId)
		if OnPlayerConnect then OnPlayerConnect(playerId, name, setKickReason, deferrals) end 
	end 
end)

AddEventHandler('playerDropped', function (reason)
	local playerId = tonumber(source)
	if playerId then 
		NB.TriggerEvent('NB:log','Player Disconnected',false,playerId)
		if OnPlayerDisconnect then OnPlayerDisconnect(playerId) end 
		if NB.ReleasePlayer then NB.ReleasePlayer(playerId) end
	end 
end)
