function Main()
	
end

function OnResourceInit()

end
 
function OnResourceExit()

end
 
function OnPlayerRequestCharacter(playerid, charid) --selectChar
end
 
function OnPlayerRequestSpawn(playerid)

end
 
function OnPlayerConnect(playerid)
	NB.SendClientMessageToAll(0x00FF00,GetPlayerName(playerid).."進入了服務器")
end
 
function OnPlayerDisconnect(playerid, reason)

end
 
function OnPlayerSpawn(playerid)
	NB.SendClientMessageToAll(0xFFFFFF,GetPlayerName(playerid).."重生了")
	NB.TriggerClientCallback('CallNative',playerid,function(result)
		print(result)
	end ,"GetEntityCoords(PlayerPedId())")
end
 
function OnPlayerDeath(playerid, killerid, reason)
end
 
function OnPlayerCommandText(playerid, cmdtext, args)

end

function OnPlayerText(playerid, text)

end