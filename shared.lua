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

exports('GetSharedObject', function()
	return NB
end)





