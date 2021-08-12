

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
			TriggerEvent("connectqueue:playerConnect", name, setKickReason, deferrals)
		end
	end 

	function OnPlayerRegister(playerid, license, citizenID)
		NB.Utils.Remote.mysql_execute('INSERT INTO users (license) VALUES (@license)', {
			['@license'] = license
		}, function(result)
			--下面是新建角色才會執行，目前先省略建立步驟
			
			NB.Utils.Remote.mysql_execute('INSERT INTO characters (citizen_id,license,position) VALUES (@citizen_id,@license,@position)', {
				['@citizen_id'] = citizenID,
				['@license'] = license,
				['@position'] = json.encode(DEFAULT_SPAWN_POSITION)
			}, function(result)
				print("Created a character into database")
				if OnPlayerLogin then OnPlayerLogin(playerid,citizenID) end 
			end )
		end )
		
	end 

	function OnPlayerLogin(playerid, license, citizenID)
		TriggerClientEvent("NB:ReadyToSpawn",playerid) -- 出生，應該跟在上面的建立角色之後，目前先在這裡
		if OnPlayerSpawn then OnPlayerSpawn(playerid) end 
	end 

	function OnPlayerSpawn(playerid)
		NB.SendClientMessageToAll(-1,GetPlayerName(playerid).."出生了")
	end 
	
	function OnPlayerDisconnect(playerid)
		local playerData = NB.PlayerData(playerid)
		local citizenID = playerData.citizenID 
		NB.SaveAllCacheCitizenDataIntoMysql(citizenID)
		NB.SendClientMessageToAll(-1,GetPlayerName(playerid).."離開了服務器")
	end 
	
end 

if IsClient() then 
	function OnPlayerUpdate()
		
	end 
	
end 