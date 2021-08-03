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
	TriggerEvent('NB:SpawnPlayer')
end

function OnPlayerSpawn()
	print("OnPlayerSpawn")
end
 
function OnPlayerDeath(killerid, reason)
	
end
 
function OnPlayerCommandText(cmdtext, args)
	print('OnPlayerCommandText client', cmdtext, json.encode(args))
end

function OnPlayerText(text)
	print('OnPlayerText', text)
end

--[=[
CreateThread(function()
	while true do Citizen.Wait(1000)
		NB.TriggerServerCallback('servertime',function (source,str,value)
			print(source,str,value)
		end,vector3(1,2,3),123)
	end 
end)
--]=]