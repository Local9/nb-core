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
	NB.Cache.Set  = function(...) return com.lua.utils.Table.SetTableSomething(NB["_CACHE_"],...) end
	NB.Cache.Clear  = function(...) return com.lua.utils.Table.ClearTableSomething(NB["_CACHE_"],...) end
	NB.Cache.IsPropValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB["_CACHE_"],...) end 
	NB.Cache.Get = function(...) return com.lua.utils.Table.GetTableSomthing(NB["_CACHE_"],...) end  
	NB.Cache.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NB["_CACHE_"],...) end
	NB.Cache.RemovePropSlot = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NB["_CACHE_"],...) end
	NB.Cache = setmetatable(NB.Cache,{__call = function(self,...) return NB.Cache.Set(...) end })
	NB.GetCache = NB.Cache.Get
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
	NB.LoadBans = com.game.Server.Load.LoadBanList
	NB.ReloadBans = NB.LoadBans
	NB.Ban = com.game.Server.Load.AddBan
	NB.IsIdentifierBanned = function(identifier) local banlist = NB.ReloadBans() return banlist[identifier] end
	NB.IsPlayerBanned = function(playerid) return NB.IsIdentifierBanned(NB.GetLicense(playerid)) end 
	NB.BanPlayer = function (playerid) local license = NB.GetLicense(playerid) if license then  NB.Ban(license) end return end 
	NB.LoadWhitelist = com.game.Server.Load.LoadWhiteList
end 
if IsClient() then 
	NB.Skin = com.game.Client.Skin
	NB.GetHashString = GetHashString
	NB.Stream = com.game.Shared.Load.Stream
	
	
end 