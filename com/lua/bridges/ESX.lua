ESX = {} -- https://github.com/esx-framework/esx-legacy
if IsShared() then 
	local Charset = {}
	
	for i = 48,  57 do table.insert(Charset, string.char(i)) end
	for i = 65,  90 do table.insert(Charset, string.char(i)) end
	for i = 97, 122 do table.insert(Charset, string.char(i)) end

	ESX.GetRandomString = function(length)
		math.randomseed(GetGameTimer())

		if length > 0 then
			return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
		else
			return ''
		end
	end
	ESX.GetRandomInt = function(length)
		math.randomseed(GetGameTimer())

		if length > 0 then
			return ESX.GetRandomInt(length - 1) .. tostring(math.random(1, 9))
		else
			return ''
		end
	end
end 

if IsServer() then 
	ESX.ServerCallbacks = {}
	RegisterServerEvent('ESX:triggerServerCallback')
	AddEventHandler('ESX:triggerServerCallback', function(name, requestId, ...)
		local playerId = source
		ESX.TriggerServerCallback(name, requestId, playerId, function(...)
			TriggerClientEvent('ESX:serverCallback', playerId, requestId, ...)
		end, ...)
	end)


	ESX.RegisterServerCallback = function(name, cb)
		ESX.ServerCallbacks[name] = cb
	end

	ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
		if ESX.ServerCallbacks[name] then
			ESX.ServerCallbacks[name](source, cb, ...)
		else
			print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!'):format(name))
		end
	end
else 
	ESX.ServerCallbacks           = {}
	ESX.CurrentRequestId          = 1

	ESX.TriggerServerCallback = function(name, cb, ...)
		ESX.ServerCallbacks[ESX.CurrentRequestId] = cb

		TriggerServerEvent('ESX:triggerServerCallback', name, ESX.CurrentRequestId, ...)

		if ESX.CurrentRequestId < 65534 then
			ESX.CurrentRequestId = ESX.CurrentRequestId + 1
		else
			ESX.CurrentRequestId = 1
		end
	end

	RegisterNetEvent('ESX:serverCallback')
	AddEventHandler('ESX:serverCallback', function(requestId, ...)
		if ESX.ServerCallbacks[requestId] then ESX.ServerCallbacks[requestId](...) end 
		ESX.ServerCallbacks[requestId] = nil
	end)
end 



