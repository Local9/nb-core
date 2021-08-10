--應該由其他插件接管，還是說我做成默認？
local LastTasks = nil 
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
	NB.Threads.CreateLoop('Save',1000,function()
		local TaskEncode = json.encode(printCurrentPedTasks(PlayerPedId()))
		if LastTasks ~= TaskEncode then 
			LastTasks = TaskEncode
			if OnPlayerUpdate then OnPlayerUpdate() end 
			local coords,heading = GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())
			if #(LastCoords - coords) > 1.0 then 
				LastCoords = coords
				TriggerServerEvent('NB:SavePlayerPosition',coords,heading)
			end 
			TriggerEvent('skinchanger:getSkin', function(skin)
				local encodeSkin = json.encode(skin)
				if (LastSkinDecode~=encodeSkin) then 
					LastSkinDecode = encodeSkin
					TriggerServerEvent("NB:SaveCharacterSkin",skin)
				end 
			end)
		end 
	end)
	--[=[
	TriggerEvent('skinchanger:getData', function(components, maxVals)
		print('Components => ' .. json.encode(components))
		print('MaxVals => ' .. json.encode(maxVals))
	end)
	--]=]
	
end )
end 



function printCurrentPedTasks(ped,...)
    local checks = {}
    local ignoretable = {...}
	local result = {}
    for i=1,600 do
        checks[i] = true 
        if ignoretable then 
            for k,v in pairs(ignoretable) do 
                if v == i then 
                    checks[v] = false 
                end 
            end 
        end 
    end
    for task,v in pairs(checks) do 
        if GetIsTaskActive(ped, task) and v then 
            table.insert(result,task)
        end 
    end 
	return result
end

