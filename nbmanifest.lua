NB = {
	_CACHE_ = {},
	_LOCAL_ = {},
	Cache={},
	Datas={},
	Players={},
	Utils={},
	Threads={}
} 
function IsServer() return IsDuplicityVersion() end ;function IsClient() return not IsDuplicityVersion() end ;function IsShared() return true end ;function Main (fn) return fn() end ;
case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
default = {} --default must put after cases when use
switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,...)return a[{...}]end,__index=function(a,c)local d=false;if c and type(c)=="table"then for e=1,#c do local f=c[e]if f and b and f==b then d=true;break end end end;if d then return setmetatable({},{__call=function(a,g)default=setmetatable({},{__call=function(a,h)end})g()end})else return function()end end end})default=setmetatable({},{__call=function(a,b)if b and type(b)=="function"then b()end end})return a[b]end,__index=function(a,f)return setmetatable({},{__call=function(a,...)end})end})
json.decodetable = function(...) local a = json.decode(...) return a end ;
IsStringNullOrEmpty = function(str) return (str == nil or str == "") end 
StringCopy = function(fromlabel) if IsStringNullOrEmpty(fromlabel) then return "" else local a = GetLabelText(fromlabel) if a and a~= 'NULL' then return GetLabelText(fromlabel) else local b = GetStreetNameFromHashKey(fromlabel) return b end end end 
GetHashString = StringCopy
GetPauseMenuSelection = function() if N_0x2e22fefa0100275e() --[[IsSelectionUpdated]] then return GetPauseMenuSelectionData() end end
IF = function(x,a,b) return x and a or b end 
ratioX = function(x) x = (x * (1.777778 / GetAspectRatio(0)));return x; end
export = exports; import = function(x,slot) NB[slot] = exports[x]:GetSharedObject();return NB[slot] end 
export('GetSharedObject',function()return NB end)





import('nb-menu','Menu')





MAX_CHARACTER_SLOTS = 3
MAX_WANTED_LEVEL = 0
DEFAULT_SPAWN_METHOD = true
DEFAULT_SPAWN_POSITION = {x =-802.311, y = 175.056, z = 72.8446, heading = 0.0}