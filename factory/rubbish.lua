local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 
case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
default = {} --default must put after cases when use
switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,...)return a[{...}]end,__index=function(a,c)local d=false;if c and type(c)=="table"then for e=1,#c do local f=c[e]if f and b and f==b then d=true;break end end end;if d then return setmetatable({},{__call=function(a,g)default=setmetatable({},{__call=function(a,h)end})g()end})else return function()end end end})default=setmetatable({},{__call=function(a,b)if b and type(b)=="function"then b()end end})return a[b]end,__index=function(a,f)return setmetatable({},{__call=function(a,...)end})end})
Split = function (s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
HexToRGB = function (hex)
    local r = hex >> 16
    local offset = hex - (r << 16)
    local g = offset >> 8
    local b = offset - (g << 8)
    return {r=r,g=g,b=b};
end 
HexToRGB2 = function (hex)
    local r = hex >> 16
    local offset = hex - (r << 16)
    local g = offset >> 8
    local b = offset - (g << 8)
    return {r,g,b};
end 

if IsServer() then 
	mysql_execute = function(...)
		return exports.ghmattimysql:execute(...)
	end 
end 
local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end
if IsClient() then 
	SetThreadPriority(0)
	CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(0)
		end
		TriggerServerEvent('NB:OnPlayerSessionStart')
		DoScreenFadeOut(0)
		freezePlayer(PlayerId(), true)
		return 
	end)
end 

if IsServer() then 
	AddEventHandler('playerDropped', function (reason)
		TriggerEvent('NB:OnPlayerDisconnect',reason)
	end)
	AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
		TriggerEvent('NB:OnPlayerConnect',name, setKickReason, deferrals)
	end )
end 

if IsClient() then 
	local TriggerSharedEvent = function(name,...)
		local args = {...}
		TriggerEvent(name,...)
		TriggerServerEvent(name,...)
	end 
	AddEventHandler('playerSpawned', function()
		TriggerSharedEvent('NB:OnSpawnPlayer')
	end)
	RegisterNetEvent('chat:addMessage', function(msg)
		if msg.args[2] then 
			local message = msg.args[2]
			if string.sub(message, 1, string.len("/")) ~= "/" then
				TriggerSharedEvent('NB:OnPlayerText',message)
			else 
				local full = Split(message:sub(2)," ")
				local cmd = full[1] 
				table.remove(full,1)
				local args = full
				TriggerSharedEvent('NB:OnPlayerCommandText',cmd,args)
			end 
		end 
	end)
end 