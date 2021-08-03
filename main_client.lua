function Main()

end

function OnResourceInit()

end

function OnResourceExit()

end

function OnPlayerRequestCharacter(charid) --selectChar
end

function OnPlayerRequestSpawn()
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
	
end

function OnPlayerDeath(killerid, reason)
end

function OnPlayerCommandText(cmdtext, args)
	
end

function OnPlayerText(text)
	
end
