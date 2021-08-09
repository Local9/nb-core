NB._temp_.thisPlayerId = -1

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	local playerId = NB.PlayerId(source)
	if OnPlayerConnect then OnPlayerConnect(playerId, name, setKickReason, deferrals) end 
	
	TriggerEvent('NB:log','Player Connected',false,playerId)
end)

AddEventHandler('playerDropped', function (reason)
	local playerId = NB.PlayerId(source)
	if OnPlayerDisconnect then OnPlayerDisconnect(playerId) end 
	
	TriggerEvent('NB:log','Player Disconnected',false,playerId)
	NB.ReleasePlayer()
end)

NB.GetPlayers = function(id)
	return not id and NB.Players or NB.Players[id]
end

NB.UpdatePlayerId = function(playerId)
	if tonumber(playerId) then 
		NB._temp_.thisPlayerId = tonumber(playerId)
	end 
	local playerId = NB._temp_.thisPlayerId
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

NB.GetLicense = com.game.license.GetLicense

NB.GetIdentifier = NB.GetLicense


function CreatePlayer(playerId, license,citizenID)
	local self = {}
	self.playerId = playerId
	self.PlayerId = playerId
	self.source = playerId
	self.license = license
	self.variables = {}
	self.citizenID = citizenID
	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
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

function DB_IsUserExist(license)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM users WHERE license = @license', {
		['@license'] = license
	})
	local r = not not (result > 0)
	
	return r
end 

function DB_IsCharacterExist(citizenID)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT COUNT(*) as count FROM characters WHERE CitizenID = @CitizenID', {
		['@CitizenID'] = citizenID
	})
	local r = not not (result > 0)
	return r 
end 

function DB_GetCharacterLicense(citizenID)
	--'SELECT u.License FROM users u inner join characters s on u.CitizenID = s.CitizenID WHERE u.CitizenID = @CitizenID'
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT License FROM characters WHERE CitizenID = @CitizenID', {
		['@CitizenID'] = citizenID
	})
	return result and result or nil
end 

function DB_GetCharactersByLicense(license,idx)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT CitizenID FROM characters WHERE License = @License', {
		['@License'] = license
	})
	if idx then 
		return result and result[idx] and result[idx].CitizenID or nil
	else
		return result or nil 
	end 
end 

RegisterNetEvent('NB:OnPlayerJoined', function() --called by com.game.session.default.lua/CreateThread
	local playerdata,playerId = NB.PlayerData(source)
	if not playerdata then
		local license = com.game.license.GetLicense(playerId)
		if license then 
			if not DB_IsUserExist(license) then
				
				NB.SendClientMessageToAll(-1,"一個新玩家加入了服務器，正在進行選角")
				local citizenID = NB.UserSomethingSeriousGenerator('CitizenID','characters',function()return tostring(com.lua.utils.Text.Generator(7) .. com.lua.utils.Math.Generator(9)):upper()end)
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

NB.GetCheapCitizenData = function(CitizenID,tablename,dataname)
	return NB._temp_.CitizenDatas[CitizenID][tablename][dataname] or NB.GetExpensiveCitizenData(CitizenID,tablename,dataname)
end 

NB.GetExpensiveCitizenData = function(CitizenID,tablename,dataname)
	local result = NB.Utils.Remote.mysql_scalar_sync('SELECT '..dataname..' FROM '..tablename..' WHERE CitizenID = @CitizenID', {
		['@CitizenID'] = CitizenID
	})
	local t = json.decode(result)
	NB.SetTempSomething("CitizenDatas",CitizenID,tablename,dataname,t)
	return json.decode(result) 
end 

NB.SetExpensiveCitizenData = function(CitizenID,tablename,dataname,datas,...)
	local otherargs = {...}
	local datas = datas 
	if #otherargs > 0 then 
		datas = {datas[1],...}
	end 
	local covertDatas = function(datas)
		if datas then 
			if type(datas) == 'table' then 
				return json.encode(datas)
			else 
				return tostring(datas)
			end 
		end 
	end 
	NB.Utils.Remote.mysql_execute('UPDATE '..tablename..' SET '..dataname..' = @'..dataname..' WHERE CitizenID = @CitizenID', {
		['@CitizenID'] = CitizenID,
		['@'..dataname..''] = covertDatas(datas)
	})
end 

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

RegisterNetEvent('NB:SavePlayerPosition', function(coords,heading)
	if coords and heading then 
		local x, y, z = table.unpack(coords)
		local playerData = NB.PlayerData(tonumber(source))
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			NB.SetExpensiveCitizenData(citizenID,'characters','Position',{x=x,y=y,z=z,heading=heading})
			--TriggerEvent("NB:log","[Citizen:"..citizenID.."] Position Saved")
		end 
	end 
end) 


RegisterNetEvent("NB:SaveCharacterSkin",function(result)
	local playerData = NB.PlayerData(playerid)
	local citizenID = playerData.citizenID 
	if citizenID and result then 
		NB.SetExpensiveCitizenData(citizenID,'characters','Skin',result)
		TriggerEvent("NB:log","[Citizen:"..citizenID.."] Skin Saved",true)
	end 
end )



NB.RegisterServerCallback("NB:GetLastPosition",function(playerId,cb)
	local playerData = NB.PlayerData(playerId)
	local citizenID = playerData.citizenID 
	local pos = NB.GetExpensiveCitizenData(citizenID,'characters','Position')
	if pos then 
		cb(vector3(pos.x, pos.y, pos.z), pos.heading)
		--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
	end 
end )

--[=[
CreateThread(function()
	while true do Wait(1000)
		--NB.MakeSureTempSomethingExist("CitizenDatas2","xD","xD","xD")
		NB.SetTempSomething("CitizenDatas2","xD","xD","xD",{1,2,3})
		print(json.encode(NB.GetTempSomthing("CitizenDatas2","xD","xD","xD")))
	end 
end)
--]=]