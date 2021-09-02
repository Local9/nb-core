NB.SpawnPlayer = function(coords, heading)
	NB.Utils.SpawnManager.Spawn(coords, heading)
	local playerid,ped = PlayerId(),PlayerPedId()
	if OnPlayerSpawn then OnPlayerSpawn(playerid,ped) end 
	NB.TriggerEvent('NB:OnPlayerSpawn')
	NB.TriggerServerEvent('NB:OnPlayerSpawn',PedToNet(ped))
end 

NB_LOCAL.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	NB.Skin.LoadDefaultModel(true,function()
		NB.SpawnPlayer(coords, heading)
	end )
end 

NB.AddEventHandler("NB:CancelPlayerDefaultSpawn",function()
	com.game.Client.Session.CancelDefaultSpawn()
end)

RegisterNetEvent("chat:addMessage",function()
	local player,ped = PlayerId(),PlayerPedId()
	if OnPlayerChat then OnPlayerChat(player,ped ) end
	--if OnPlayerUpdate then OnPlayerUpdate(player,ped ) end
end)

NB.RegisterNetEvent("NB:OnPlayerSpawn",function()
	
	local function CheckPedTasks(ped) 
		local tasks = {}
		for i=0,19 do 
			local bool = GetIsTaskActive(ped,i)
			if bool then 
				table.insert(tasks,function(cb) 
					cb( 1 )
				end )
			end 
		end 
		for i=150,168 do 
			local bool = GetIsTaskActive(ped,i)
			if bool then 
				table.insert(tasks,function(cb) 
					cb( 1 )
				end )
			end 
		end 
		local bool = IsEntityInAir(ped)
		if bool then 
			table.insert(tasks,function(cb) 
				cb( 1 )
			end )
		end 
		
		return tasks 
	end
	local loop;loop = function()
		local ped = PlayerPedId()
		NB.Async.parallelLimit(CheckPedTasks(ped), 10,function(result)
			local length = #result
			NB.Flow.CheckChange("(name)checkpedtask",length,function(olddata,newdata)
				TriggerServerCallback('NB:IsCharacterLoaded',function (bool)
					if bool then 
						if OnPlayerUpdate then OnPlayerUpdate(PlayerId(),ped) end
						NB.TriggerServerEvent("NB:OnPlayerUpdate",PedToNet(ped))
					end 
				end)
				
			end)
			SetTimeout((length+1)*500,loop)
		end)
	end 
	loop()
end)



	


NB.RegisterNetEvent("NB:CitizenLoaded",function(citizenID)

	TriggerServerCallback('NB:GetCharacterPackedData',function (pos)
		--print(json.encode(pos))
		local coords,heading 
		if pos then 
			coords,heading = vector3(pos.x, pos.y, pos.z), pos.heading 
		else 
			coords,heading = DEFAULT_SPAWN_POSITION
		end 
		--print(coords,heading )
		NB.Skin.LoadDefaultModel( true,function()
			NB.TriggerEvent('NB:CancelPlayerDefaultSpawn')
			NB.SpawnPlayer(coords, heading) -- using SpawnManager to spawn,trigger Event NB:OnPlayerSpawn
		end )
	end, "position", false)
	
	TriggerServerCallback('NB:GetCharacterPackedData',function (skin)
		--print("Get Skin:",json.encode(skin))
	end,'skin',true)
	
end )
