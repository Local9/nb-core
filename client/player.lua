--應該由其他插件接管，還是說我做成默認？
local LastSkinDecode = nil 
local LastCoords = vector3(0.0,0.0,0.0) 
if DEFAULT_SPAWN_METHOD then  
RegisterNetEvent("NB:ReadyToSpawn",function()
	print("NB:ReadyToSpawn")
	TriggerEvent('NB:CancelDefaultSpawn')
	NB.TriggerServerCallback('NB:GetLastPosition',function (coords, heading)
		local coords,heading = coords,heading or  DEFAULT_SPAWN_POSITION
		TriggerEvent('skinchanger:loadDefaultModel', true,function()
			NB.Utils.SpawnManager.Spawn(coords, heading)
		end )
		
	end)
	
	local function CheckPedTasks(ped)
		local result = {}
		for i=1,100 do
			if GetIsTaskActive(ped, i) then 
				table.insert(result,i)
			end 
			if GetPedConfigFlag(ped,i,false) == 1 then 
				table.insert(result,i)
			end 
			if GetPedConfigFlag(ped,i,true) == 1 then 
				table.insert(result,i)
			end 
		end
		table.insert(result,IsPedStopped(ped))
		table.insert(result,IsPedStill(ped))
		table.insert(result,GetPauseMenuState())
		return result
	end

	NB.Threads.CreateLoop('Save',1000,function()
		local ped = PlayerPedId()
		NB.Flow.CheckNativeChange(CheckPedTasks,ped,function(olddata,newdata)
			
			if OnPlayerUpdate then print('OnPlayerUpdate') OnPlayerUpdate() end 
			NB.Flow.CheckNativeChangeVector(GetEntityCoords,ped,1.0,function(oldcoords,newcoords)
				local heading = GetEntityHeading(ped)
				TriggerServerEvent('NB:SavePlayerPosition',newcoords,heading)
			end)

			TriggerEvent('skinchanger:getSkin', function(skin)
				NB.Flow.CheckChange("(name)skinchanger:getSkin",skin,function(oldskin,newskin)
					TriggerServerEvent("NB:SaveCharacterSkin",newskin)
				end )
			end)
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





