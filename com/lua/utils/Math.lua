
local PI_OVER_180 = 0.017453292519943295;

math.round = function(num)
  return num + (2^52 + 2^51) - (2^52 + 2^51)
end

com.lua.utils.Math.Generator = ESX.GetRandomInt

com.lua.utils.Math.getRandomNumber = function(min, max)
      local num = math.floor(math.random() * (max - min + 1)) + min;
      return num;
end 

com.lua.utils.Math.toFixedRound = function(num, fractionDigits)
      return com.lua.utils.Math.toFixed(num,fractionDigits,true);
end 

com.lua.utils.Math.toFixed = function(num, fractionDigits, round)
      local pcs = 1;
      for i=1,fractionDigits,1 do 
         pcs = pcs * 10;
      end 
      return (not round and math.floor(num * pcs) or math.floor(num * pcs+0.5)) / pcs;
end 


