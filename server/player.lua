NB["_LOCAL_"].thisPlayerId = -1

NB.GetPlayers = function(id)
	return not id and NB.Players or NB.Players[id]
end

NB.UpdatePlayerId = function(playerId)
	if tonumber(playerId) then 
		NB["_LOCAL_"].thisPlayerId = tonumber(playerId)
	end 
	local playerId = NB["_LOCAL_"].thisPlayerId
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

NB.SetPlayer = function(value)
	NB.Players[NB.PlayerId()] = value
end 

NB.ReleasePlayer = function()
	NB.Players[NB.PlayerId()] = nil 
end



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
	local playerdata,playerId = NB.PlayerData(source)
	if not playerdata then
		local license = com.game.Server.License.Get(playerId)
		if license then 
			if not DB_IsUserExist(license) then
				
				NB.SendClientMessageToAll(-1,"一個新玩家加入了服務器，正在進行選角")
				local citizenID = NB.UserSomethingSeriousGenerator('citizen_id','characters',function()return tostring(com.lua.utils.Text.Generator(7) .. com.lua.utils.Math.Generator(9)):upper()end)
				NB.SetPlayer(CreatePlayer(playerId, license, citizenID))
				if OnPlayerRegister then OnPlayerRegister(playerId, license, citizenID) end 
				return NB.GetPlayers(playerId)
			else 
				
				NB.SendClientMessageToAll(-1,"一個老玩家加入了服務器，正在進行選角")
				local citizenID = DB_GetCharactersByLicense(license,1)
				NB.SetPlayer(CreatePlayer(playerId, license, citizenID))
				if OnPlayerLogin then OnPlayerLogin(playerId, license, citizenID) end 
				return NB.GetPlayers(playerId)
			end
			
		else 
			DropPlayer(playerId, 'Your license could not be found,the cause of this error is not known.')
			return false 
		end 
	end
	return false 
end)


NB.UserSomethingSeriousGenerator = function(name,tablename,checkfn)
	local SomethingExist = false
	local Something = nil

	while not SomethingExist do
		Something = checkfn(name)
		if not Something then error("error on creating player something",2) end 
		local result = NB.Utils.Remote.mysql_execute_sync('SELECT COUNT(*) as count FROM '..tablename..' WHERE '..name..'=@'..name..'', {['@'..name..''] = Something})
		if result[1].count == 0 then
			SomethingExist = true
		end
	end
	return Something
end

NB.RegisterNetEvent('NB:SavePlayerPosition', function(coords,heading)
	if coords and heading then 
		local x, y, z = table.unpack(coords)
		local playerData = NB.PlayerData(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			NB.SetCitizenPackedDataCache(citizenID,'characters','position',{x=x+0.0,y=y+0.0,z=z+0.0,heading=heading+0.0})
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] position Saved")
		end 
	end 
end) 


NB.RegisterNetEvent("NB:SaveCharacterSkin",function(skindata)
	if skindata and type(skindata) == 'table' then 
		local playerData = NB.PlayerData(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			NB.SetCitizenPackedDataCache(citizenID,'characters','skin',skindata,true)
			NB.TriggerEvent("NB:log","[Citizen:"..citizenID.."] skin Saved",true)
		end 
	end 
	
end )

NB.RegisterServerCallback("NB:GetCharacterPackedData",function(playerId,cb,datatype,isCompress)
	local playerData = NB.PlayerData(playerId)
	local citizenID = playerData.citizenID 
	local ava = {"position","skin"}
	local found = false 
	for i=1,#ava do 
		if datatype == ava[i] then 
			found = true 
		end 
	end 
	if not found then return end 
	print(citizenID,'characters',datatype,isCompress)
	local skin = NB.GetCitizenPackedDataCache(citizenID,'characters',datatype,isCompress)
	if skin then 
		cb(skin)
		--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
	end 
end )

NB.RegisterServerCallback("NB:GetLastPosition",function(playerId,cb)
	local playerData = NB.PlayerData(playerId)
	local citizenID = playerData.citizenID 
	local pos = NB.GetCitizenPackedDataCache(citizenID,'characters','position')
	if pos then 
		cb(pos)
		--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
	end 
end )

