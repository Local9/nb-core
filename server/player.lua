NB.GetPlayers = function()
	return NB.Players
end
NB.GetPlayerDataFromId = function(playerId)
	local playerdata = NB.Players[playerId]
	return playerdata
end 
NB.GetCitizenDataFromId = function(playerId)
	local playerdata = NB.GetPlayerDataFromId(playerId)
	local citizendata
	if playerdata and playerdata.citizenData then 
		citizendata = playerdata.citizenData
	else 
		error("citizen data not loaded",2)
	end 
	return citizendata
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
	local result = DB.User.CreateUser(license,NB.GetIP(playerId),NB.GetOtherLicenses(playerId))
	if result then 
		if OnPlayerRegister and playerId>0 then OnPlayerRegister(playerId, license) end 
	end 
	--下面是新建角色才會執行，目前先省略建立步驟
	local CreateChar = true 
	if CreateChar then 
		local citizenID = DB.User.DataSlotTemplateGenerator('citizen_id','citizens','xxyyyyyyyyyx')
		DB.Citizen.Create(citizenID,license,function(citizenData) --創建Citizen在這裡
			print("Created a character into database")
			PrePlayerData.init("citizenID",citizenID)
			PrePlayerData.init("citizenData",citizenData)
			if OnPlayerLogin then OnPlayerLogin(playerId,license) end 
		end )
	end 
end)
NB.AddEventHandler("NB:OnPlayerLogin",function(playerId, license)
	local PrePlayerData = CreatePlayerDatatable(playerId)
	local license = license
	PrePlayerData.init("license",license)
	local citizenID = DB.Citizen.GetIDFromLicense(license,1)
	local citizenData = DB.Citizen.GetData(citizenID)
	PrePlayerData.init("citizenID",citizenID)
	PrePlayerData.init("citizenData",citizenData)
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
	print('playerConnecting',source)
	local playerid = tonumber(source)
	NB.TriggerEvent('NB:log','Player Connected',false,playerid)
	if OnPlayerConnect then OnPlayerConnect(playerid, name, setKickReason, deferrals) end 
end)
AddEventHandler('playerDropped', function (reason)
	print('playerDropped',source)
	local playerid = tonumber(source)
	if playerid then 
		NB.TriggerEvent('NB:log','Player Disconnected',false,playerid)
		if OnPlayerDisconnect then OnPlayerDisconnect(playerid) end 
		if NB.ReleasePlayer then NB.ReleasePlayer(playerid) end
	end 
end)



RegisterServerCallback("NB:GetScript",function(playerId,cb,scriptname)
	if scriptname == "player.lua" then 
	local codes = [=[
		--應該由其他插件接管，還是說我做成默認？
		NB.SpawnPlayer = function(coords, heading)
			NB.Utils.SpawnManager.Spawn(coords, heading)
			local playerid,ped = PlayerId(),PlayerPedId()
			if OnPlayerSpawn then OnPlayerSpawn(playerid,ped) end 
			NB.TriggerEvent('NB:OnPlayerSpawn')
			NB.TriggerServerEvent('NB:OnPlayerSpawn',PedToNet(ped))
		end 

		NB_LOCAL.SpawnPlayerDefault = function()
			local player = PlayerId()
			SetPlayerControl(player, true, false)
			local coords,heading = DEFAULT_SPAWN_POSITION
			NB.Skin.LoadDefaultModel(true,function()
				NB.SpawnPlayer(coords, heading)
			end )
		end 

		NB.AddEventHandler("NB:CancelPlayerDefaultSpawn",function()
			com.game.Client.Session.CancelDefaultSpawn()
		end)

		RegisterNetEvent("chat:addMessage",function()
			local player,ped = PlayerId(),PlayerPedId()
			if OnPlayerChat then OnPlayerChat(player,ped ) end
			if OnPlayerUpdate then OnPlayerUpdate(player,ped ) end
		end)

		NB.RegisterNetEvent("NB:OnPlayerSpawn",function()
			
			local function CheckPedTasks(ped) 
				local tasks = {}
				for i=0,19 do 
					local bool = GetIsTaskActive(ped,i)
					if bool then 
						table.insert(tasks,function(cb) 
							cb( 1 )
						end )
					end 
				end 
				for i=150,168 do 
					local bool = GetIsTaskActive(ped,i)
					if bool then 
						table.insert(tasks,function(cb) 
							cb( 1 )
						end )
					end 
				end 
				local bool = IsEntityInAir(ped)
				if bool then 
					table.insert(tasks,function(cb) 
						cb( 1 )
					end )
				end 
				
				return tasks 
			end
			local loop;loop = function()
				local ped = PlayerPedId()
				NB.Async.parallelLimit(CheckPedTasks(ped), 10,function(result)
					local length = #result
					NB.Flow.CheckChange("(name)checkpedtask",length,function(olddata,newdata)
						if OnPlayerUpdate then OnPlayerUpdate(PlayerId(),ped) end
						NB.TriggerServerEvent("NB:OnPlayerUpdate",PedToNet(ped))
						
					end)
					SetTimeout((length+1)*500,loop)
				end)
			end 
			loop()
		end)



		if DEFAULT_SPAWN_METHOD then  
		NB.RegisterNetEvent("NB:PlayerReadyToSpawn",function()
			NB.TriggerEvent('NB:CancelPlayerDefaultSpawn')
			print("CancelPlayerDefaultSpawn with Default Spawn Method Example")
			
			TriggerServerCallback('NB:GetCharacterPackedData',function (pos)
				--print(json.encode(pos))
				local coords,heading 
				if pos then 
					coords,heading = vector3(pos.x, pos.y, pos.z), pos.heading 
				else 
					coords,heading = DEFAULT_SPAWN_POSITION
				end 
				--print(coords,heading )
				NB.Skin.LoadDefaultModel( true,function()
					NB.SpawnPlayer(coords, heading) -- using SpawnManager to spawn,trigger Event NB:OnPlayerSpawn
				end )
			end, "position", false)
			
			TriggerServerCallback('NB:GetCharacterPackedData',function (skin)
				--print("Get Skin:",json.encode(skin))
			end,'skin',true)
			
		end )
		end 

	]=]
	cb(NB.encode(codes))
	end
end)