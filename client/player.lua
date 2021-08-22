--應該由其他插件接管，還是說我做成默認？
local LastSkinDecode = nil 
local LastCoords = vector3(0.0,0.0,0.0) 
if DEFAULT_SPAWN_METHOD then  
NB.RegisterNetEvent("NB:ReadyToSpawn",function()
	print("Spawn is Ready")
	NB.TriggerEvent('NB:CancelDefaultSpawn')
	NB.TriggerServerCallback('NB:GetLastPosition',function (coords, heading)
		local coords,heading = coords,heading or  DEFAULT_SPAWN_POSITION
		NB.Skin.LoadDefaultModel( true,function()
			--NB.Skin.LoadCharacterSkin(json.decodetable('{"hair_1":11,"face":0,"lipstick_1":0,"lipstick_4":0,"beard_4":0,"age_2":0,"skin":0,"beard_2":0,"makeup_3":0,"eyebrows_2":0,"hair_color_1":0,"eyebrows_4":0,"lipstick_2":0,"eyebrows_3":0,"eyebrows_1":0,"hair_2":0,"sex":0,"hair_color_2":0,"makeup_1":0,"makeup_2":0,"age_1":0,"beard_1":0,"beard_3":0,"makeup_4":0,"lipstick_3":0}'))
		
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
			Wait(0)
		end
		table.insert(result,IsPedStopped(ped))
		table.insert(result,IsPedStill(ped))
		table.insert(result,GetPauseMenuState())
		
		return result
	end

	NB.Threads.CreateLoop('Save',1000,function()
		local ped = PlayerPedId()
		CreateThread(function()
			NB.Flow.CheckNativeChange("(name)checkpedtask",CheckPedTasks,ped,function(olddata,newdata)
				if OnPlayerUpdate then OnPlayerUpdate() end 
				print('checkpedtask save stuffs')
				NB.Flow.CheckNativeChangeVector("(name)checkcoords",GetEntityCoords,ped,1.0,function(oldcoords,newcoords)
					local heading = GetEntityHeading(ped)
					NB.TriggerServerEvent('NB:SavePlayerPosition',newcoords,heading)
				end)
				
				NB.Skin.GetCharacterSkin(function (skin)
					NB.Flow.CheckChange("(name)skinchanger:getSkin",skin,function(oldskin,newskin)
						NB.TriggerServerEvent("NB:SaveCharacterSkin",newskin)
					end )
				end)
			end)
		end)
		
	end)

	
end )
end 





