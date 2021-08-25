if IsShared() then 
	NB.Async = com.lua.utils.Async
	NB.Utils = com.lua.utils
	NB.Flow = com.lua.utils.Flow
	NB.Cache.Set  = function(...) return com.lua.utils.Table.SetTableSomething(NB["_CACHE_"],...) end
	NB.Cache.Clear  = function(...) return com.lua.utils.Table.ClearTableSomething(NB["_CACHE_"],...) end
	NB.Cache.IsExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB["_CACHE_"],...) end 
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
	NB.GetIP = com.game.Server.License.GetIP
	NB.GetOtherLicenses = com.game.Server.License.GetOthers
	NB.GetIdentifier = NB.GetLicense
	NB.LoadBans = com.game.Server.Load.LoadBanList
	NB.ReloadBans = NB.LoadBans
	NB.Ban = com.game.Server.Load.AddBan
	NB.IsIdentifiersBanned = function(identifiers) 
		local banlist = NB.ReloadBans() 
		for i,v in pairs(identifiers) do 
			if banlist[v] then 
				return true
			end 
		end 
		return false
	end
	NB.IsPlayerBanned = function(playerId) return NB.IsIdentifiersBanned(GetPlayerIdentifiers(playerId)) end 
	NB.BanPlayer = function (playerId) local license = NB.GetLicense(playerId) if license then  NB.Ban(license) end return end 
	NB.LoadWhitelist = com.game.Server.Load.LoadWhiteList
end 
if IsClient() then 
	NB.Skin = com.game.Client.Skin
	NB.GetHashString = GetHashString
	NB.Stream = com.game.Shared.Load.Stream
	
	
end 