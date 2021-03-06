
local PI_OVER_180 = 0.017453292519943295;

math.round = function(num)
  return num + (2^52 + 2^51) - (2^52 + 2^51)
end
com.lua.utils.Math.round = math.round

com.lua.utils.Math.getRandomNumber = function(min, max)
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
	local num = math.floor(math.random() * (max - min + 1)) + min;
	return num;
end 

com.lua.utils.Math.getRandomFloat = function(min, max)
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
	local num = math.random() * (max - min + 1) + min;
	return num;
end 

com.lua.utils.Math.toFixedRound = function(num, fractionDigits)
      return com.lua.utils.Math.toFixed(num,fractionDigits,true);
end 

com.lua.utils.Math.toFixed = function(num, fractionDigits, round)
	local fractionDigits = fractionDigits or 2
      local pcs = 1;
      for i=1,fractionDigits,1 do 
         pcs = pcs * 10;
      end 
      return (not round and math.floor(num * pcs) or math.floor(num * pcs+0.5)) / pcs;
end 


