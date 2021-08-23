Main(function()
	print("NB-CORE INITIALISED")
	NB.LoadDataSheet("items",false)
	NB.LoadDataSheet("monster",false)
end)
if IsServer() then 
	function OnPlayerConnect(playerid, name, setKickReason, deferrals)
		deferrals.defer()
		Wait(0)
		local license = NB.GetIdentifier(playerid)
		local isLicenseAlreadyInUse = false 
		deferrals.update(string.format("Hello %s. Validating Your Rockstar License", name))
		if NB.GetPlayerFromIdentifier(NB.GetIdentifier(playerid)) then 
			isLicenseAlreadyInUse = true 
		end 
		--Wait(2500)
		--deferrals.update(string.format("Hello %s. We are checking if you are banned.", name))
		Wait(2500)
		deferrals.update(string.format("Welcome %s to {Server Name}.", name))
		if not license then
			deferrals.done('No Valid Rockstar License Found')
		--elseif isBanned then
			--deferrals.done(Reason)
		elseif isLicenseAlreadyInUse then
			deferrals.done('Duplicate Rockstar License in the Server Found')
		else
			deferrals.done()
			Wait(1000)
			NB.TriggerEvent("connectqueue:playerConnect", name, setKickReason, deferrals)
		end
	end 
	function OnPlayerRegister(playerid, license, citizenID)
		DB.User.CreateUser(license, function(result)
			--下面是新建角色才會執行，目前先省略建立步驟
			DB.Citizen.Create(playerid, license, citizenID,function(result)
				print("Created a character into database")
				if OnPlayerLogin then OnPlayerLogin(playerid,citizenID) end 
			end )
		end )
	end 
	function OnPlayerLogin(playerid, license, citizenID)
		NB.TriggerClientEvent("NB:ReadyToSpawn",playerid) -- 出生，應該跟在上面的建立角色之後，目前先在這裡
		if OnPlayerSpawn then OnPlayerSpawn(playerid) end 
	end 
	function OnPlayerJustJoin(playerId, license, playerdata)
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
		local citizenID = playerData.citizenID 
		DB.Citizen.AllCachesToSql(citizenID)
		NB.SendClientMessageToAll(-1,GetPlayerName(playerid).."離開了服務器")
	end 
end 
if IsClient() then 
	function OnPlayerUpdate()
	end 
end 