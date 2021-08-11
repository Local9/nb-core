function IsServer() return IsDuplicityVersion() end ;function IsClient() return not IsDuplicityVersion() end ;function IsShared() return true end ;function Main (fn) return fn() end ;
json.decodetable = function(...) local a = json.decode(...) return a end ;
IsStringNullOrEmpty = function(str) return (str == nil or str == "") end 
StringCopy = function(fromlabel) if IsStringNullOrEmpty(fromlabel) then return "" else local a = GetLabelText(fromlabel) if a and a~= 'NULL' then return GetLabelText(fromlabel) else local b = GetStreetNameFromHashKey(fromlabel) return b end end end 
GetPauseMenuSelection = function() if N_0x2e22fefa0100275e() then return GetPauseMenuSelectionData() end end

NB = {
	_CACHE_ = {},
	_LOCAL_ = {},
	Datas={},
	Players={},
	Utils={},
	Threads={}
}  
exports('GetSharedObject',function()return NB end)

MAX_CHARACTER_SLOTS = 3
MAX_WANTED_LEVEL = 0
DEFAULT_SPAWN_METHOD = true
DEFAULT_SPAWN_POSITION = {x =-802.311, y = 175.056, z = 72.8446, heading = 0.0}



