NB = {}
local function GetObject()
	return NB
end
AddEventHandler('NB:GetObject', function(cb)
	cb(GetObject())
end)
local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
if IsServer() then 
	RegisterNetEvent('NB:OnPlayerSessionStart', function()
		TriggerEvent("NB_NOT_NET:CreateOrLogin",source)
	end)
	CreateThread(function()
		print("[NBCore] Server Loaded")
	end)
end 
if IsClient() then 
	CreateThread(function()
		local SpawnPlayer = function()
			--[[
			exports.spawnmanager:spawnPlayer({
					x = -802.311, y = 175.056, z = 72.8446,heading = 0.0,model = `a_m_y_hipster_01`,
					skipFade = false
				}, function()
				ShutdownLoadingScreen()
				ShutdownLoadingScreenNui()
				FreezeEntityPosition(PlayerPedId(), false)
			end)
			--]]
			NB.TriggerServerCallback('NB:SpawnPlayer',function (coords, Heading, model)
				exports.spawnmanager:setAutoSpawn(false)
				--exports.spawnmanager:forceRespawn()
				local x,y,z 
				if coords then 
					x,y,z = coords.x,coords.y,coords.z
				end 
				exports.spawnmanager:spawnPlayer({
						x = x or -802.311, y = y or 175.056, z = z or 72.8446,heading = Heading or 0.0,model = Model or `mp_m_freemode_01`,
						skipFade = false
					}, function()
					SetPedDefaultComponentVariation(PlayerPedId())
					ShutdownLoadingScreen()
					ShutdownLoadingScreenNui()
					FreezeEntityPosition(PlayerPedId(), false)
				end)
				
			end)
		end
		while not NetworkIsSessionStarted() do
			Wait(0)
		end
		SpawnPlayer()
		TriggerServerEvent('NB:OnPlayerSessionStart')
		TriggerEvent('NB:OnPlayerSessionStart')
		--print("NB:OnPlayerSessionStart")
		return 
	end)
end 
if IsServer() then 
	----https://github.com/negbook/ServerCallback
	NB.RegisterServerCallback = function(actionname,fn) -- NB.RegisterServerCallback('abc',function(cb) cb(1) end)
		
		local resname = GetCurrentResourceName()
		local actionhashname = GetHashKey(actionname)
		local eventName,a = resname..":RequestCallback"..actionhashname
		
		a = RegisterNetEvent(eventName, function (ticketClient,...) --client send datas into ...
			local source_ = source 
			local ticketServer =  tostring(GetGameTimer())..tostring(os.time())
			local eventWithTicket,b = eventName .. ticketClient .. ticketServer
			if source_ then eventWithTicket = eventWithTicket .. tostring(source_)..tostring(GetHashKey(GetPlayerName(source_))) 
				b = RegisterNetEvent(eventWithTicket, function (ticketCl,...)
					local c = function(...)
						TriggerClientEvent(resname..":ResultCallback"..actionhashname..ticketCl,source_,...)
					end 
					fn(source_,c,...)
					if b then 
						RemoveEventHandler(b)
					end 
					if NB.RegisterServerCallback  then NB.RegisterServerCallback (actionname,fn) end 
				end) 
				TriggerEvent(eventWithTicket,ticketClient,...)
			end 
			if a then 
				RemoveEventHandler(a)
			end 
		end)
	end 
end 
if IsClient() then 
	----https://github.com/negbook/ServerCallback
	NB.TriggerServerCallback = function(actionname,fn,...)
		local resname = GetCurrentResourceName()
		local a 
		local actionhashname = GetHashKey(actionname)
		
		local ticketClient = tostring(GetGameTimer())..tostring(GetCloudTimeAsInt())
		a = RegisterNetEvent(resname..":ResultCallback"..actionhashname..ticketClient, function (...)
			fn(...)
			if a then  
				RemoveEventHandler(a)
			end 
		end)
		TriggerServerEvent(resname..":RequestCallback"..actionhashname,ticketClient,...)
	end 
end 