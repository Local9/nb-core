local lastDebug = 0 
local DebugTime = 1 
com.lua.utils.Random.MakeSeed = function(x)
	if x then return math.randomseed(x) end
	if IsClient() then 
		local seed = GetCloudTimeAsInt()+GetGameTimer()
		math.randomseed(math.floor(math.abs(seed)))
	end 
	if IsServer() then 
		local seed = os.time()+GetGameTimer()
		math.randomseed(math.floor(math.abs(seed)))
	end 
end 

