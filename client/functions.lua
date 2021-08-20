NB.TriggerServerCallback = ESX.TriggerServerCallback 
NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local coords,heading = DEFAULT_SPAWN_POSITION
	NB.Skin.LoadDefaultModel(true,function()
		NB.Utils.SpawnManager.Spawn(coords, heading)
	end )
end 
NB.CreateLoad = function(typeLoading,name,cb)
	local spin = function() if not BusyspinnerIsOn() then BeginTextCommandBusyspinnerOn("MP_SPINLOADING") EndTextCommandBusyspinnerOn(3) end end
	PreloadBusyspinner()
	switch(typeLoading)(
		case("texture")(function()
			NB.AsyncLimit("typeLoading"..typeLoading..name,8,function()
				local _,attempt,handle = RequestStreamedTextureDict(name),0
				repeat Wait(33) spin(); handle,attempt = HasStreamedTextureDictLoaded(name),attempt+1 until handle or attempt > 50
				if not handle then print(name.." not found.Please report it.") end 
				return handle 
			end,function(handle)
				cb(handle)
			end )
		end),
		case("model")(function()
			NB.AsyncLimit("typeLoading"..typeLoading..name,8,function()
				local hash = type(name)=='number' and name or GetHashKey(name)
				local _,attempt,handle = RequestModel(hash),0
				repeat Wait(33) spin(); handle,attempt = HasModelLoaded(hash),attempt+1 until handle or attempt > 50
				if not handle then print("model "..hash.." not found.Please report it.") end 
				return handle 
			end,function(handle)
				cb(handle)
			end )
		end),
		case("scaleform")(function()
			NB.AsyncLimit("typeLoading"..typeLoading..name,8,function()
				local _,attempt,handle = RequestScaleformMovie(name),0
				repeat Wait(33) spin(); handle,attempt = HasScaleformMovieLoaded(_),attempt+1 until handle or attempt > 50
				if not handle then print(name.." not found.Please report it.") end 
				return handle 
			end,function(handle)
				cb(handle)
			end )
		end),
		default(function()
		end)
	)
end 

CreateThread(function()
	for i=1,21 do 
		NB.CreateLoad("model","dlc_sol",function(handle)
			print('model here',i,handle)
		end )
		NB.CreateLoad("texture","dlc_sol",function(handle)
			print('texture here',i,handle)
		end )
		NB.CreateLoad("scaleform","dlc_sol",function(handle)
			print('scaleform here',i,handle)
		end )
	end 
end)
