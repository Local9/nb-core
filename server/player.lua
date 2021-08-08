NB._temp_.thisPlayerId = -1

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	local playerId = NB.PlayerId(source)
	if OnPlayerConnect then OnPlayerConnect(playerId, name, setKickReason, deferrals) end 
	
	TriggerEvent('NB:log','Player Connected',playerId)
end)

AddEventHandler('playerDropped', function (reason)
	local playerId = NB.PlayerId(source)
	if OnPlayerDisconnect then OnPlayerDisconnect(playerId) end 
	
	TriggerEvent('NB:log','Player Disconnected',playerId)
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
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT id FROM users WHERE license = @license', {
		['@license'] = license
	})
	return license and (result and not not result[1] or false)
end 

function DB_GetCharacterLicense(citizenID)
	--'SELECT u.License FROM users u inner join characters s on u.CitizenID = s.CitizenID WHERE u.CitizenID = @CitizenID'
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT License FROM characters WHERE CitizenID = @CitizenID', {
		['@CitizenID'] = citizenID
	})
	return result and result[1].License or nil
end 

function DB_GetCharactersByLicense(license,idx)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT CitizenID FROM characters WHERE License = @License', {
		['@License'] = license
	})
	if idx then 
		return result and result[idx].CitizenID or nil
	else
		return result or nil 
	end 
end 

function DB_IsCharacterExist(citizenID)
	local result = NB.Utils.Remote.mysql_execute_sync('SELECT CitizenID FROM characters WHERE CitizenID = @CitizenID', {
		['@CitizenID'] = citizenID
	})
	return license and (not not result[1])
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


NB.GetExpensiveCitizenData = function(CitizenID,tablename,dataname,resultcb)
	NB.Utils.Remote.mysql_execute('SELECT '..dataname..' FROM '..tablename..' WHERE CitizenID = @CitizenID', {
		['@CitizenID'] = CitizenID
	}, function(result)
		resultcb(result)
	end)
end 

NB.SetExpensiveCitizenData = function(CitizenID,tablename,dataname,datas,...)
		local otherargs = {...}
		local datas = datas 
		if #otherargs > 0 then 
			datas = {datas[1],...}
		end 
		local covertDatas = function(datas)
			if datas then 
				local test_ = {}
				local datatype = 0
				if type(datas) == 'table' then 
					datatype = 1
					for i,v in pairs(datas) do 
						table.insert(test_,i)
					end 
					for i=1,#test_ do 
						if test_[i] == i then 
						else 
							datatype = 2
							break 
						end 
					end 
					
					--return '{' .. table.concat(t_,",").. '}'
				else 
					datatype = 0
					--return datas
				end 
				if datatype == 2 then 
					local t_ = {} 
					for i,v in pairs(datas) do 
						table.insert(t_,'"'..i..'"'..":"..v)
					end 
					return '{' .. table.concat(t_,",").. '}'
				elseif datatype == 1 then 
					local t_ = {} 
					for i=1,#datas do 
						table.insert(t_,datas[i])
					end 
					return '{' .. table.concat(t_,",").. '}'
				else 
					return datas
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
		end 
	end 
end) 


RegisterNetEvent("NB:SaveCharacterSkin",function(result)
	local playerData = NB.PlayerData(playerid)
	local citizenID = playerData.citizenID 
	if citizenID and result then 
		NB.SetExpensiveCitizenData(citizenID,'characters','Skin',result)
	end 
end )



NB.RegisterServerCallback("NB:GetLastPosition",function(playerId,cb)
	local playerData = NB.PlayerData(playerId)
	local citizenID = playerData.citizenID 
	NB.GetExpensiveCitizenData(citizenID,'characters','Position',function(result)
		if result then 
			local pos = json.decode(result[1].Position)
			cb(vector3(pos.x, pos.y, pos.z), pos.heading)
			--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
		end 
	end)
end )
