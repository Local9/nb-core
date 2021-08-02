RegisterNetEvent('NB:OnPlayerSessionStart', function()
	TriggerEvent("NB_NOT_NET:CreateOrLogin",source)
end)

AddEventHandler('NB_NOT_NET:CreateOrLogin', function(source)
	--to do Something
	TriggerClientEvent('NB:SpawnPlayer',source)
end)