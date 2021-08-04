
com.lua.utils.Colour.HexToRGB = function (hex)
    local r = hex >> 16
    local offset = hex - (r << 16)
    local g = offset >> 8
    local b = offset - (g << 8)
    return {r=r,g=g,b=b};
end 
com.lua.utils.Colour.HexToRGB2 = function (hex)
    local r = hex >> 16
    local offset = hex - (r << 16)
    local g = offset >> 8
    local b = offset - (g << 8)
    return {r,g,b};
end 
