function IsServer() return IsDuplicityVersion() end ;function IsClient() return not IsDuplicityVersion() end ;function IsShared() return true end ;function Main (fn) return fn() end ;
json.decodetable = function(...) local a = json.decode(...) return a end ;
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



