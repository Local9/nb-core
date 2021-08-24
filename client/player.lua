--應該由其他插件接管，還是說我做成默認？
local LastSkinDecode = nil 
local LastCoords = vector3(0.0,0.0,0.0) 
local LastSkin = nil 
if DEFAULT_SPAWN_METHOD then  
NB.RegisterNetEvent("NB:ReadyToSpawn",function()
	print("Spawn is Ready")
	NB.TriggerEvent('NB:CancelDefaultSpawn')
	NB.TriggerServerCallback('NB:GetCharacterPackedData',function (pos)
		local coords,heading 
		if pos then 
			coords,heading = vector3(pos.x, pos.y, pos.z), pos.heading 
		else 
			coords,heading = DEFAULT_SPAWN_POSITION
		end 
		NB.Skin.LoadDefaultModel( true,function()
			NB.Utils.SpawnManager.Spawn(coords, heading)
		end )
	end, "position", false)
	NB.TriggerServerCallback('NB:GetCharacterPackedData',function (skin)
		print("Get Skin:",json.encode(skin))
		LastSkin = skin
	end,'skin',true)
	
	local function CheckPedTasks(ped) 
		local tasks = {}
		for i=1,14 do 
			table.insert(tasks,function(cb) 
				local bool = GetIsTaskActive(ped,i)
				if bool then 
					cb( 1 )
				else 
					cb(nil)
				end 
			end )
		end 
		for i=146,169 do 
			table.insert(tasks,function(cb) 
				local bool = GetIsTaskActive(ped,i)
				if bool then 
					cb( 1 )
				else 
					cb(nil)
				end 
			end )
		end 
		return tasks 
	end
	local loop;loop = function()
		local ped = PlayerPedId()
		NB.Async.parallelLimit(CheckPedTasks(ped), 7,function(result)
			local length = #result
			NB.Flow.CheckChange("(name)checkpedtask",length,function(olddata,newdata)
				--print(json.encode(newdata))
				if OnPlayerUpdate then OnPlayerUpdate() end 
				NB.Flow.CheckNativeChangeVector("(name)checkcoords",GetEntityCoords,ped,1.0,function(oldcoords,newcoords)
					local heading = GetEntityHeading(ped)
					NB.TriggerServerEvent('NB:Citizen:SavePosition',newcoords,heading)
				end)
				NB.Skin.CitizenGetSkin(function (skin)
					NB.Flow.CheckChange("(name)skinchanger:getSkin",LastSkin,function(oldskin,newskin)
						NB.TriggerServerEvent("NB:Citizen:SaveSkin",newskin)
					end )
					LastSkin = skin
				end)
				
			end)
			SetTimeout((length+1)*1500,loop)
		end)
	end 
	loop()

end )
end 