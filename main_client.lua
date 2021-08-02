function Main()
	print("My script loaded!")
end

function OnResourceInit()
	print('OnResourceInit')
end
 
function OnResourceExit()
	print('OnResourceExit')
end
 
function OnPlayerRequestCharacter(charid) --selectChar
	
end
 
function OnPlayerRequestSpawn()
	print("OnPlayerRequestSpawn")
end
 
function OnPlayerSpawn()
	print("OnPlayerSpawn")
end
 
function OnPlayerDeath(killerid, reason)
	
end
 
function OnPlayerCommandText(cmdtext, args)
	print('OnPlayerCommandText client', cmdtext, json.encode(args))
end

function OnPlayerChat(text)
	print('OnPlayerChat', text)
end