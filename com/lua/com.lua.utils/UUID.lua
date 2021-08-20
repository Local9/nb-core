uuid = {}
com.lua.utils.UUID = uuid

local random = math.random
uuid.Gen = function() --https://gist.github.com/jrus/3197011
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
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	local str,len = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%X', v)
    end)
    return str
end

uuid.GenByString = function(str) 
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	local hash = GetHashKey(str) --固定string 產生固定 hashkey
	local seed = hash
	if seed >= (2 ^ 32) then
		seed = seed - math.floor(seed / 2 ^ 32) * (2 ^ 32)
	end
	math.randomseed(math.floor(math.abs(seed))) --固定seed 產生固定UUID
	local str,len = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%X', v)
    end)
    return str
end

print(uuid.GenByString("A"))