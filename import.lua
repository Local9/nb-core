NB =  (function()return exports['nb-core']:GetSharedObject()end)()
local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
local IsShared = function() return true end 
local case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
local default = {} --default must put after cases when use
local switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,...)return a[{...}]end,__index=function(a,c)local d=false;if c and type(c)=="table"then for e=1,#c do local f=c[e]if f and b and f==b then d=true;break end end end;if d then return setmetatable({},{__call=function(a,g)default=setmetatable({},{__call=function(a,h)end})g()end})else return function()end end end})default=setmetatable({},{__call=function(a,b)if b and type(b)=="function"then b()end end})return a[b]end,__index=function(a,f)return setmetatable({},{__call=function(a,...)end})end})
local Split = function (s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

if IsShared() then 
	CreateThread(function()
		if Main then 
			Main()
		end 
	end)
	RegisterNetEvent('NB:OnPlayerSessionStart', function()
		if OnPlayerRequestSpawn then 
			if source then 
				OnPlayerRequestSpawn(source) 
			else 
				OnPlayerRequestSpawn() 
			end 
		end 
	end)

	RegisterNetEvent('NB:OnSpawnPlayer', function()
		if OnPlayerSpawn then 
			if source then 
				OnPlayerSpawn(source)
			else 
				OnPlayerSpawn()
			end 
		end 
	end)
	
	RegisterNetEvent('NB:OnResourceInit', function()
		if OnResourceInit then 
			if source then 
				OnResourceInit(source)
			else 
				OnResourceInit()
			end 
		end 	
	end)
	
	RegisterNetEvent('NB:OnResourceExit', function()
		if OnResourceExit then 
			if source then 
				OnResourceExit(source)
			else 
				OnResourceExit()
			end 
		end 
	end)
end 

if IsServer() then 
	RegisterNetEvent('NB:OnPlayerDisconnect', function(reason)
		if OnPlayerDisconnect then 
			OnPlayerDisconnect(reason)
		end 
	end)
	
	RegisterNetEvent('NB:OnPlayerConnect', function(name, setKickReason, deferrals)
		if OnPlayerConnect then 
			OnPlayerConnect(name, setKickReason, deferrals)
		end 
	end)
	AddEventHandler('chatMessage', function(source, name, message)
		if string.sub(message, 1, string.len("/")) ~= "/" then
			if OnPlayerChat then
				OnPlayerChat(source,message)
			end
		else 
			if OnPlayerCommandText then 
				if source then 
					local full = Split(message:sub(2)," ")
					local cmd = full[1] 
					table.remove(full,1)
					local args = full
					OnPlayerCommandText(source,cmd,args)
				end 
			end 
		end 
	end)
end 

if IsClient() then 
	RegisterNetEvent('chat:addMessage', function(msg)
		local message = msg.args[2]
		if string.sub(message, 1, string.len("/")) ~= "/" then
			if OnPlayerChat then
				OnPlayerChat(message)
			end
		else 
			if OnPlayerCommandText then 
				local full = Split(message:sub(2)," ")
				local cmd = full[1] 
				table.remove(full,1)
				local args = full
				OnPlayerCommandText(cmd,args)
			end 
		end 
	end)
end 
