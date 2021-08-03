function Main()
	print("My script loaded!")
end

function OnResourceInit(playerid)
	print('OnResourceInit',playerid)
end
 
function OnResourceExit(playerid)
	print('OnResourceExit',playerid)
end
 
function OnPlayerRequestCharacter(playerid, charid) --selectChar
end
 
function OnPlayerRequestSpawn(playerid)
	print("OnPlayerRequestSpawn",playerid)
	TriggerClientEvent('NB:SpawnPlayer',playerid)
end
 
function OnPlayerConnect(playerid)
	print("OnPlayerConnect",playerid)
end
 
function OnPlayerDisconnect(playerid, reason)
	print("OnPlayerDisconnect",playerid,reason or "no reason")
end
 
function OnPlayerSpawn(playerid)
	print("OnPlayerSpawn",playerid)
end
 
function OnPlayerDeath(playerid, killerid, reason)
end
 
function OnPlayerCommandText(playerid, cmdtext, args)
	print('OnPlayerCommandText', playerid, cmdtext, json.encode(args))
end

function OnPlayerText(playerid, text)
	print('OnPlayerText', playerid, text)
end