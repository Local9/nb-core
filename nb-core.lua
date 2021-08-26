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
		local isLicenseBanned = false 
		local isIPBanned = false 
		local IsWhite = false 
		local DoesIpInBanList = function(banslist,ip)
		    local function banned(f,s)
				local ipsplit=function(b,c)local b=string.gsub(b,"%.",",")if not c then c=","end;result={}for d in(b..c):gmatch("(.-)"..c)do table.insert(result,d)end;return result end
				local ss = ipsplit (s)
				local ff = ipsplit(f)
				local found = false
				for i=1,#ss do 
				   if (ss[i] == ff[i] or ss[i] == "*") == false then 
					  return nil
				   end 
				   
				end 
				return true
			end 
			local found = false
			for i,v in pairs(banslist) do 
				
				if banned(ip,i) then 
					return true 
				end 
				
			end 
			return found 
		end 
		
		deferrals.update(string.format("Hello %s. Validating Your Rockstar License", name))
		if NB.GetPlayerFromIdentifier(NB.GetIdentifier(playerId)) then 
			isLicenseAlreadyInUse = true 
		end 
		Wait(2500) local banslist = NB.ReloadBans()
		Wait(50) isLicenseBanned = NB.IsIdentifiersBanned(GetPlayerIdentifiers(playerId))
		isIPBanned = DoesIpInBanList(banslist,com.game.Server.License.GetIP(playerId)) == true
		deferrals.update(string.format("Hello %s. We are checking if you are banned.", name))
		
		local whitelistlength,whitelist = NB.LoadWhitelist()
		if whitelistlength > 0 then
			Wait(2500) 
			deferrals.update(string.format("Hello %s. We are checking if you are in allowlist.", name))
			if whitelist and whitelist[license] then IsWhite = true end 
		else 
			IsWhite = true
		end 
		Wait(2500)
		deferrals.update(string.format("Welcome %s to {Server Name}.", name))
		if not license then
			deferrals.done('No Valid Rockstar License Found')
		elseif isLicenseBanned or isIPBanned then 
			deferrals.done("You've got BANNED from this server")
		elseif not IsWhite then 
			deferrals.done("You are not in the allowlist from this server.")
		elseif isLicenseAlreadyInUse then
			deferrals.done('Duplicate Rockstar License in the Server Found')
		else
			deferrals.done()
			Wait(1000)
			NB.TriggerEvent("connectqueue:playerConnect", name, setKickReason, deferrals)
		end
	end 
	function OnPlayerRegister(playerId, license)
		
	end 
	function OnPlayerLogin(playerId, license)
		NB.TriggerClientEvent("NB:PlayerReadyToSpawn",playerId) -- 出生，應該跟在上面的建立角色之後，目前先在這裡
	end 
	function OnPlayerJustJoin(playerId, license, isNew)
		if NB.IsPlayerBanned(playerId) then 
			DropPlayer(playerId,"You've got BANNED from this server")
			return 
		end 
		if isNew then 
			NB.SendClientMessageToAll(-1,"一個新玩家加入了服務器，正在進行選角")
		else 
			NB.SendClientMessageToAll(-1,"一個老玩家加入了服務器，正在進行選角")
		end 
		
	end 
	function OnPlayerSpawn(playerId)
		NB.SendClientMessageToAll(-1,GetPlayerName(playerId).."出生了")
	end 
	function OnPlayerDisconnect(playerId)
		local playerData = NB.GetPlayerDataFromId(playerId)
		local citizenID = playerData and playerData.citizenID 
		if citizenID then 
			DB.Citizen.AllCachesToSql(citizenID,true)
			NB.SendClientMessageToAll(-1,GetPlayerName(playerId).."離開了服務器")
		end 
	end 
	function OnPlayerUpdate(playerId,PedNetid)
		
	end 
end 
if IsClient() then 
	local LastSkin = nil 
	function OnPlayerSpawn(player,ped)
		
	end
	function OnPlayerUpdate(player,ped)
		NB.Flow.CheckNativeChangeVector("(name)checkcoords",GetEntityCoords,ped,1.0,function(oldcoords,newcoords)
			local heading = GetEntityHeading(ped)
			NB.TriggerServerEvent('NB:Citizen:SavePosition',newcoords,heading)
		end)
		NB.Skin.CitizenGetSkin(function (skin)
			NB.Flow.CheckChange("(name)skinchanger:getSkin",LastSkin,function(oldskin,newskin)
				NB.TriggerServerEvent("NB:Citizen:SaveSkin",newskin)
			end )
			LastSkin = skin
		end)
	end 
end 