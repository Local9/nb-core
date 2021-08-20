com.lua.utils.Random.MakeSeed = function(x)
	if x then return math.randomseed(x) end
	if IsClient() then 
		local seed = GetCloudTimeAsInt()+GetGameTimer()
		if seed >= (2 ^ 32) then
			seed = seed - math.floor(seed / 2 ^ 32) * (2 ^ 32)
		end
		math.randomseed(math.floor(math.abs(seed)))
	end 
	if IsServer() then 
		local seed = os.time()+GetGameTimer()
		if seed >= (2 ^ 32) then
			seed = seed - math.floor(seed / 2 ^ 32) * (2 ^ 32)
		end
		math.randomseed(math.floor(math.abs(seed)))
	end 
end 

