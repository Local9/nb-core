if IsShared() then 
	NB.Async = com.lua.utils.Async
	NB.Utils = com.lua.utils
	NB.Flow = com.lua.utils.Flow
	NB.Threads = com.lua.threads
	NB.Threads.CreateSpecialLoop = function(name,time,fn)
		local _fn = function(...)
			com.lua.utils.Random.MakeSeed()
			return fn(...)
		end 
		return NB.Threads.CreateLoop(name,time,_fn)
	end 
	NB.Cache.SetPropSlotValue  = function(...) return com.lua.utils.Table.SetTableSomething(NB["_CACHE_"],...) end
	NB.Cache.IsPropValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB["_CACHE_"],...) end 
	NB.Cache.GetPropSlotValue = function(...) return com.lua.utils.Table.GetTableSomthing(NB["_CACHE_"],...) end  
	NB.Cache.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NB["_CACHE_"],...) end
	NB.Cache.RemovePropSlot = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NB["_CACHE_"],...) end
	NB.Cache = setmetatable(NB.Cache,{__call = function(self,...) return NB.Cache.SetPropSlotValue(...) end })
	NB.GetCache = NB.Cache.GetPropSlotValue
	NB.LoadDataSheet = com.game.Shared.Load.LoadDataSheet
	NB.Random = com.lua.utils.Math.getRandomNumber
	NB.RandomFloat = com.lua.utils.Math.getRandomFloat
	NB.AsyncLimit = com.lua.utils.Async.CreateLimit --namespace,limited,fnwithWaitAndReturnInside
	NB.AsyncSeries = com.lua.utils.Async.CreateSeries --namespace,fnwithWaitAndReturnInside
	NB.RandomSeed = com.lua.utils.Random.MakeSeed
	NBRandomSeed = NB.RandomSeed
end 
if IsServer() then 
	NB.GetLicense = com.game.Server.License.Get
	NB.GetIdentifier = NB.GetLicense
end 
if IsClient() then 
	NB.Skin = com.game.Client.Skin
	NB.GetHashString = GetHashString
	NB.Stream = com.game.Shared.Load.Stream
	
	
end 