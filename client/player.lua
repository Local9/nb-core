--應該由其他插件接管，還是說我做成默認？

if DEFAULT_SPAWN_METHOD then 
RegisterNetEvent("NB:ReadyToSpawn",function()
	TriggerEvent('NB:CancelDefaultSpawn')
	NB.TriggerServerCallback('NB:GetLastPosition',function (coords, heading)
		local coords,heading = coords,heading or DEFAULT_SPAWN_POSITION
		TriggerEvent('skinchanger:loadDefaultModel', true,function()
			NB.Utils.SpawnManager.Spawn(coords, heading)
		end )
		
	end)
	NB.Threads.CreateLoop('SavePosition',1000,function()
		TriggerServerEvent('NB:SavePlayerPosition',GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent("NB:SaveCharacterSkin",skin)
		end)
	end)
	--[=[
	TriggerEvent('skinchanger:getData', function(components, maxVals)
		print('Components => ' .. json.encode(components))
		print('MaxVals => ' .. json.encode(maxVals))
	end)
	--]=]
	
end )
end 


