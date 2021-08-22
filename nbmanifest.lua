NB = {
	encode = PreLibDeflate.encode ,
	decode = PreLibDeflate.decode ,
	encodeNumber = PreLibDeflate.encodeNumber ,
	decodeNumber = PreLibDeflate.decodeNumber ,
	encodeSql = PreLibDeflate.encodeToSQL  ,
	decodeSql = PreLibDeflate.decodeFromSQL ,
	_CACHE_ = {},
	_LOCAL_ = {},
	_IMPORTED_ = {},
	Cache={},
	Datas={},
	Players={},
	Utils={},
	Threads={}
} 

MAX_CHARACTER_SLOTS = 3
MAX_WANTED_LEVEL = 0
DEFAULT_SPAWN_METHOD = true
DEFAULT_SPAWN_POSITION = {x =-802.311, y = 175.056, z = 72.8446, heading = 0.0}
WEAPON_AUTO_RELOAD = false














isDebug = true 

function IsServer() return IsDuplicityVersion() end ;function IsClient() return not IsDuplicityVersion() end ;function IsShared() return true end ;function Main (fn) return fn() end ;
if isDebug == true then 

print_table = function(a)local b,c,d={},{},{}local e=1;local f="{\n"while true do local g=0;for h,i in pairs(a)do g=g+1 end;local j=1;for h,i in pairs(a)do if b[a]==nil or j>=b[a]then if string.find(f,"}",f:len())then f=f..",\n"elseif not string.find(f,"\n",f:len())then f=f.."\n"end;table.insert(d,f)f=""local k;if type(h)=="number"or type(h)=="boolean"then k="["..tostring(h).."]"else k="['"..tostring(h).."']"end;if type(i)=="number"or type(i)=="boolean"then f=f..string.rep('\t',e)..k.." = "..tostring(i)elseif type(i)=="table"then f=f..string.rep('\t',e)..k.." = {\n"table.insert(c,a)table.insert(c,i)b[a]=j+1;break else f=f..string.rep('\t',e)..k.." = '"..tostring(i).."'"end;if j==g then f=f.."\n"..string.rep('\t',e-1).."}"else f=f..","end else if j==g then f=f.."\n"..string.rep('\t',e-1).."}"end end;j=j+1 end;if g==0 then f=f.."\n"..string.rep('\t',e-1).."}"end;if#c>0 then a=c[#c]c[#c]=nil;e=b[a]==nil and e+1 or e-1 else break end end;table.insert(d,f)f=table.concat(d)print(f)end--https://www.codegrepper.com/code-examples/lua/lua+dump+table
thisResourceName= GetCurrentResourceName() -- nb-core
case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
default = {} --default must put after cases when use
switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,...)return a[{...}]end,__index=function(a,c)local d=false;if c and type(c)=="table"then for e=1,#c do local f=c[e]if f and b and f==b then d=true;break end end end;if d then return setmetatable({},{__call=function(a,g)default=setmetatable({},{__call=function(a,h)end})g()end})else return function()end end end})default=setmetatable({},{__call=function(a,b)if b and type(b)=="function"then b()end end})return a[b]end,__index=function(a,f)return setmetatable({},{__call=function(a,...)end})end})

deepcopy = function(a,b)b=b or{}local c=type(a)local d;if c=='table'then if b[a]then d=b[a]else d={}b[a]=d;for e,f in next,a,nil do d[deepcopy(e,b)]=deepcopy(f,b)end;setmetatable(d,deepcopy(getmetatable(a),b))end else d=a end;return d end --http://lua-users.org/wiki/CopyTable
json.decodetable = function(...) local a = json.decode(...) return a end ;
IsStringNullOrEmpty = function(str) return (str == nil or str == "") end 
StringCopy = function(fromlabel) if IsStringNullOrEmpty(fromlabel) then return "" else local a = GetLabelText(fromlabel) if a and a~= 'NULL' then return GetLabelText(fromlabel) else local b = GetStreetNameFromHashKey(fromlabel) return b end end end 
GetHashString = StringCopy
GetPauseMenuSelection = function() if N_0x2e22fefa0100275e() --[[IsSelectionUpdated]] then return GetPauseMenuSelectionData() end end
IF = function(x,a,b) return x and a or b end 
ratioX = function(x) x = (x * (1.777778 / GetAspectRatio(0)));return x; end

exports('GetSharedObject',function() return NB end)
local shadowmin = 1
local shadowmax = 3
local shadowchar = 66
local convertArgs = function(args)
	if args[1] and NB.encodeSql then 
		args[1] = "NB:"..NB.encodeSql(args[1]..string.char(shadowchar))
		--print(args[1])
	end 
	return args
end 


local TriggerEvent_ = TriggerEvent
NB.TriggerEvent = function(...)
	local args = {...}
	local temp = args[1]
	args = convertArgs(args)
	local shadows = deepcopy(args)
	for i,v in pairs(shadows) do 
		--[=[
		if type(v) == 'function' or type(v) == 'table' and v.__cfx_functionReference then 
			v = function() end 
			
		end 
		--]=]
		v = 0
	end 
	CreateThread(function()
		for i=1,math.random(shadowmin,shadowmax) do 
			CreateThread(function()
				shadows[1] = "NB:"..NB.encodeSql(temp..string.char(shadowchar+i));--print(shadows[1])
				TriggerEvent_(table.unpack(shadows))
				if math.random(1,500) > 250 then 
					Wait(math.random(1,500))
				end 
			end )
		end 
	end)
	return TriggerEvent_(table.unpack(args))
end 

local RegisterNetEvent_ = RegisterNetEvent
NB.RegisterNetEvent = function(...)
	local args = {...}
	args = convertArgs(args)
	return RegisterNetEvent_(table.unpack(args))
end 

local AddEventHandler_ = AddEventHandler
NB.AddEventHandler = function(...)
	local args = {...}
	args = convertArgs(args)
	return AddEventHandler_(table.unpack(args))
end 

if IsServer() then 
	local TriggerClientEvent_ = TriggerClientEvent
	NB.TriggerClientEvent = function(...)
		local args = {...}
		local temp = args[1]
		args = convertArgs(args)
		local shadows = deepcopy(args)
		for i,v in pairs(shadows) do 
			--[=[
			if type(v) == 'function' or type(v) == 'table' and v.__cfx_functionReference then 
				v = function() end 
				
			end 
			--]=]
			v = 0
		end 
		CreateThread(function()
			for i=1,math.random(shadowmin,shadowmax) do 
				CreateThread(function()
					shadows[1] = "NB:"..NB.encodeSql(temp..string.char(shadowchar+i));--print(shadows[1])
					TriggerClientEvent_(table.unpack(shadows))
					if math.random(1,500) > 250 then 
						Wait(math.random(1,500))
					end 
				end )
			end 
		end)
		return TriggerClientEvent_(table.unpack(args))
	end 
end 
if IsClient() then 
	local TriggerServerEvent_ = TriggerServerEvent
	NB.TriggerServerEvent = function(...)
		local args = {...}
		local temp = args[1]
		args = convertArgs(args)
		local shadows = deepcopy(args)
		for i,v in pairs(shadows) do 
			--[=[
			if type(v) == 'function' or type(v) == 'table' and v.__cfx_functionReference then 
				v = function() end 
				
			end 
			--]=]
			v = 0
		end 
		CreateThread(function()
			for i=1,math.random(shadowmin,shadowmax) do 
				CreateThread(function()
					shadows[1] = "NB:"..NB.encodeSql(temp..string.char(shadowchar+i));--print(shadows[1])
					TriggerServerEvent_(table.unpack(shadows))
					if math.random(1,500) > 250 then 
						Wait(math.random(1,500))
					end 
				end )
			end 
		end)
		return TriggerServerEvent_(table.unpack(args))
	end 
end 

if IsServer() then 
	NB.RegisterNetEvent("NB:server_print",function(...) 
		print(...) 
	end)
end 
if IsClient() then 
	print_server = function(...) 
		NB.TriggerServerEvent("NB:server_print",...) 
	end 
	print_table_server = function(a)local b,c,d={},{},{}local e=1;local f="{\n"while true do local g=0;for h,i in pairs(a)do g=g+1 end;local j=1;for h,i in pairs(a)do if b[a]==nil or j>=b[a]then if string.find(f,"}",f:len())then f=f..",\n"elseif not string.find(f,"\n",f:len())then f=f.."\n"end;table.insert(d,f)f=""local k;if type(h)=="number"or type(h)=="boolean"then k="["..tostring(h).."]"else k="['"..tostring(h).."']"end;if type(i)=="number"or type(i)=="boolean"then f=f..string.rep('\t',e)..k.." = "..tostring(i)elseif type(i)=="table"then f=f..string.rep('\t',e)..k.." = {\n"table.insert(c,a)table.insert(c,i)b[a]=j+1;break else f=f..string.rep('\t',e)..k.." = '"..tostring(i).."'"end;if j==g then f=f.."\n"..string.rep('\t',e-1).."}"else f=f..","end else if j==g then f=f.."\n"..string.rep('\t',e-1).."}"end end;j=j+1 end;if g==0 then f=f.."\n"..string.rep('\t',e-1).."}"end;if#c>0 then a=c[#c]c[#c]=nil;e=b[a]==nil and e+1 or e-1 else break end end;table.insert(d,f)f=table.concat(d)print_server(f)end--https://www.codegrepper.com/code-examples/lua/lua+dump+table
end
end 

