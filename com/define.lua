NB.Async = com.lua.utils.Async
NB.Utils = com.lua.utils
NB.Threads = com.lua.threads
NB.SetCacheSomething = function(...) return com.lua.utils.Table.SetTableSomething(NB["_CACHE_"],...) end
NB.IsCacheSomthingExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB["_CACHE_"],...) end 
NB.GetCacheSomthing = function(...) return com.lua.utils.Table.GetTableSomthing(NB["_CACHE_"],...) end  