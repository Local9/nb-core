com.game.Shared.Load.LoadDataSheet = function(dataname,iskeys)
	local keys 
	NB.Datas[dataname],keys = com.lua.utils.Csv.LoadDataSheet(dataname,iskeys)
	--[=[
	for i,v in pairs(NB.Datas[dataname]) do 
		for k,c in pairs(v) do 
			print(k,c)
		end 
	end 
	--]=]
	return NB.Datas[dataname],keys
end 

com.game.Shared.Load.Stream = function(typeLoading,name,cb)
	local spin = function() if not BusyspinnerIsOn() and not BusyspinnerIsDisplaying() then BeginTextCommandBusyspinnerOn("MP_SPINLOADING") EndTextCommandBusyspinnerOn(3) end end
	PreloadBusyspinner()
	switch(typeLoading)(
		case("texture")(function()
			com.lua.utils.Async.CreateLimit("typeLoading"..typeLoading..name,8,function()
				local _,attempt,handle = RequestStreamedTextureDict(name),0
				repeat Wait(33) spin(); handle,attempt = HasStreamedTextureDictLoaded(name),attempt+1 until handle or attempt > 50
				if not handle then print(name.." not found.Please report it.") end 
				return handle 
			end,function(handle)
				cb(handle)
			end )
		end),
		case("model")(function()
			com.lua.utils.Async.CreateLimit("typeLoading"..typeLoading..name,8,function()
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
			com.lua.utils.Async.CreateLimit("typeLoading"..typeLoading..name,8,function()
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