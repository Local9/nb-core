NB.Async = com.lua.utils.Async
NB.Utils = com.lua.utils
NB.Flow = com.lua.utils.Flow
NB.Threads = com.lua.threads
if IsClient() then 
NB.Skin = com.game.Skin
end 
NB.SetCacheSomething = function(...) return com.lua.utils.Table.SetTableSomething(NB["_CACHE_"],...) end
NB.IsCacheSomthingExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB["_CACHE_"],...) end 
NB.GetCacheSomthing = function(...) return com.lua.utils.Table.GetTableSomthing(NB["_CACHE_"],...) end  