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
	print("OnPlayerRequestSpawn1")
	--[=[
	exports.spawnmanager:setAutoSpawn(false)
	--exports.spawnmanager:forceRespawn()
	exports.spawnmanager:spawnPlayer({
			x = -802.311, y = 175.056, z = 72.8446,heading = 0.0,model = `mp_m_freemode_01`,
			skipFade = false
		}, function()
		SetPedDefaultComponentVariation(PlayerPedId())
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		FreezeEntityPosition(PlayerPedId(), false)
	end)
	--]=]
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
