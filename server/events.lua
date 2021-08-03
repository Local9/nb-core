RegisterNetEvent('NB:OnPlayerSessionStart', function()
	if not WasEventCanceled () then 
		if source then 
			TriggerClientEvent('NB:SpawnPlayerDefault',source)
		end 
	end 
end)