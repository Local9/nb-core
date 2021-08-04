local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsServer() end 
local IsShared = function() return true end 

ESX = {} -- https://github.com/esx-framework/esx-legacy


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
	ESX.CurrentRequestId          = 0

	ESX.TriggerServerCallback = function(name, cb, ...)
		ESX.ServerCallbacks[ESX.CurrentRequestId] = cb

		TriggerServerEvent('ESX:triggerServerCallback', name, ESX.CurrentRequestId, ...)

		if ESX.CurrentRequestId < 65535 then
			ESX.CurrentRequestId = ESX.CurrentRequestId + 1
		else
			ESX.CurrentRequestId = 0
		end
	end

	RegisterNetEvent('ESX:serverCallback')
	AddEventHandler('ESX:serverCallback', function(requestId, ...)
		ESX.ServerCallbacks[requestId](...)
		ESX.ServerCallbacks[requestId] = nil
	end)
end 



