com.lua.utils.Colour.HexToRGBA = function (hex,skipkeys)
	local r = hex >> 24
	local offset = hex - (r << 24)
	local g = offset >> 16
	local offset = offset - (g << 16)
	local b = offset >> 8
	local offset = offset - (b << 8)
	local a = offset
	return (not skipkeys and {r=r,g=g,b=b,a=a}) or {r,g,b,a};
end 
com.lua.utils.Colour.HexToRGB = function (hex,skipkeys)
	local r = hex >> 16
	local offset = hex - (r << 16)
	local g = offset >> 8
	local b = offset - (g << 8)
	return (not skipkeys and {r=r,g=g,b=b}) or {r,g,b};
	
end 

com.lua.utils.Colour.RGBToHex = function (r, g, b) 
	return ('%02X%02X%02X'):format(tonumber(r),tonumber(g),tonumber(b))
end
com.lua.utils.Colour.RGBAToHex = function (r, g, b, a) 
	return ('%02X%02X%02X%02X'):format(tonumber(r),tonumber(g),tonumber(b),tonumber(a))
end
