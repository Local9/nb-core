
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

