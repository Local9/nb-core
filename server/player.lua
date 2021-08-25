NB["_PLAYER_"].thisPlayerId = -1
NB.GetPlayers = function(id)
	return not id and NB.Players or NB.Players[id]
end
NB.UpdatePlayerId = function(playerId)
	if playerId and tonumber(playerId) then 
		NB["_PLAYER_"].thisPlayerId = tonumber(playerId)
	end 
	local playerid = NB["_PLAYER_"].thisPlayerId
	return playerid,NB.GetPlayers(playerid)
end
NB.PlayerId = function(playerId)
	local playerid,playerdata = NB.UpdatePlayerId(playerId)
	return playerid
end 
NB.GetPlayerDataFromId = function(playerId)
	local playerid, playerdata = NB.UpdatePlayerId(playerId)
	return playerdata
end 
NB.ReleasePlayer = function(playerId)
	NB.Players[playerId] = nil 
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
	NB.Players[playerId] = self
	return self
end
NB.RegisterNetEvent('NB:OnPlayerJoined', function() --called by com.game.session.spawn.lua/CreateThread
	local source = tonumber(source)
	local playerid = source
	local playerdata = NB.GetPlayerDataFromId(playerid)
	local license = NB.GetLicense(playerid)
	local isNew
	if not playerdata then
		if license then 
			if not DB.User.IsUserExist(license) then
				isNew = true
				NB.TriggerEvent('NB:OnPlayerRegister',playerid, license)				
			else 
				isNew = false 
				NB.TriggerEvent('NB:OnPlayerLogin',playerid, license)
			end
		else 
			DropPlayer(playerid, 'Your license could not be found,the cause of this error is not known.')
			return false 
		end 
	end
	if not (isNew ==  nil) then 
		if OnPlayerJustJoin then OnPlayerJustJoin(playerid, license, isNew) end 
	end 
end)
NB.AddEventHandler("NB:OnPlayerRegister",function(playerId, license)
	local license = license
	local PrePlayerData = CreatePlayerDatatable(playerId)
	PrePlayerData.init("license",license)
	local result = DB.User.CreateUser(license)
	if result then 
		if OnPlayerRegister and playerId>0 then OnPlayerRegister(playerId, license) end 
	end 
	--下面是新建角色才會執行，目前先省略建立步驟
	local CreateChar = true 
	if CreateChar then 
		local citizenID = DB.User.DataSlotTemplateGenerator('citizen_id','citizens','xxyyyyyyyyyx')
		DB.Citizen.Create(citizenID,license,function()
			print("Created a character into database")
			PrePlayerData.init("citizenID",citizenID)
			if OnPlayerLogin then OnPlayerLogin(playerId,license) end 
		end )
	end 
end)
NB.AddEventHandler("NB:OnPlayerLogin",function(playerId, license)
	local PrePlayerData = CreatePlayerDatatable(playerId)
	local license = license
	PrePlayerData.init("license",license)
	local citizenID = DB.Citizen.GetIDFromLicense(license,1)
	PrePlayerData.init("citizenID",citizenID)
	if OnPlayerLogin and playerId>0 then OnPlayerLogin(playerId, license) end 
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
		local playerid = NB.PlayerId(source)
		NB.TriggerEvent('NB:log','Player Connected',false,playerid)
		if OnPlayerConnect then OnPlayerConnect(playerid, name, setKickReason, deferrals) end 
	end 
end)
AddEventHandler('playerDropped', function (reason)
	local playerid = tonumber(source)
	if playerid then 
		NB.TriggerEvent('NB:log','Player Disconnected',false,playerid)
		if OnPlayerDisconnect then OnPlayerDisconnect(playerid) end 
		if NB.ReleasePlayer then NB.ReleasePlayer(playerid) end
	end 
end)