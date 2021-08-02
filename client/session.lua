CreateThread(function()
	SetThreadPriority(0)
	while not NetworkIsSessionStarted() do
		Wait(0)
	end
	TriggerServerEvent('NB:OnPlayerSessionStart')
	TriggerEvent('NB:OnPlayerSessionStart')
	return 
end)


AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		local threadId = GetIdOfThisThread()
		TerminateThisThread()
		N_0x4d953df78ebf8158()
		return
	end
end)