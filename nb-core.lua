Main(function()
	print("NB-CORE INITIALISED")
	NB.LoadDataSheet("items",false)
	NB.LoadDataSheet("monster",false)
	if IsServer() then 
		NB.LoadBans()
	end 
end)
if IsServer() then 
	function OnPlayerConnect(playerId, name, setKickReason, deferrals)
		deferrals.defer()
		Wait(0)
		local license = NB.GetIdentifier(playerId)
		local isLicenseAlreadyInUse = false 
		local Banned = false 
		deferrals.update(string.format("Hello %s. Validating Your Rockstar License", name))
		if NB.GetPlayerFromIdentifier(NB.GetIdentifier(playerId)) then 
			isLicenseAlreadyInUse = true 
		end 
		Wait(2500)
		NB.ReloadBans()
		Wait(50)
		Banned = NB.IsIdentifierBanned(license)
		deferrals.update(string.format("Hello %s. We are checking if you are banned.", name))
		
		Wait(2500)
		deferrals.update(string.format("Welcome %s to {Server Name}.", name))
		if not license then
			deferrals.done('No Valid Rockstar License Found')
		elseif Banned then 
			deferrals.done("You've got BANNED from this server")
		elseif isLicenseAlreadyInUse then
			deferrals.done('Duplicate Rockstar License in the Server Found')
		else
			deferrals.done()
			Wait(1000)
			NB.TriggerEvent("connectqueue:playerConnect", name, setKickReason, deferrals)
		end
	end 
	function OnPlayerRegister(playerId, license, citizenID)
		DB.User.CreateUser(license, function(result)
			--下面是新建角色才會執行，目前先省略建立步驟
			DB.Citizen.Create(playerId, license, citizenID,function(result)
				print("Created a character into database")
				if OnPlayerLogin then OnPlayerLogin(playerId,citizenID) end 
			end )
		end )
	end 
	function OnPlayerLogin(playerid, license, citizenID)
		NB.TriggerClientEvent("NB:ReadyToSpawn",playerid) -- 出生，應該跟在上面的建立角色之後，目前先在這裡
		if OnPlayerSpawn then OnPlayerSpawn(playerid) end 
	end 
	function OnPlayerJustJoin(playerId, license, playerdata)
		if NB.IsPlayerBanned(playerId) then 
			DropPlayer(playerId,"You've got BANNED from this server")
			return 
		end 
		if not playerdata then
			if license then 
				if not DB.User.IsUserExist(license) then
					NB.SendClientMessageToAll(-1,"一個新玩家加入了服務器，正在進行選角")
					local citizenID = DB.User.DataSlotTemplateGenerator('citizen_id','citizens','xxyyyyyyyyyx')
					NB.SetPlayer(CreatePlayer(playerId, license, citizenID))
					if OnPlayerRegister then OnPlayerRegister(playerId, license, citizenID) end 
					return NB.GetPlayers(playerId)
				else 
					NB.SendClientMessageToAll(-1,"一個老玩家加入了服務器，正在進行選角")
					local citizenID = DB.Citizen.GetIDFromLicense(license,1)
					NB.SetPlayer(CreatePlayer(playerId, license, citizenID))
					if OnPlayerLogin then OnPlayerLogin(playerId, license, citizenID) end 
					return NB.GetPlayers(playerId)
				end
			else 
				DropPlayer(playerId, 'Your license could not be found,the cause of this error is not known.')
				return false 
			end 
		end
	end 
	function OnPlayerSpawn(playerid)
		NB.SendClientMessageToAll(-1,GetPlayerName(playerid).."出生了")
	end 
	function OnPlayerDisconnect(playerid)
		local playerData = NB.PlayerData(playerid)
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			DB.Citizen.AllCachesToSql(citizenID)
			NB.SendClientMessageToAll(-1,GetPlayerName(playerid).."離開了服務器")
		end 
	end 
end 
if IsClient() then 
	function OnPlayerUpdate()
	end 
end 