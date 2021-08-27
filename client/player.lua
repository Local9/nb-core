TriggerServerCallback('NB:GetScript',function (result)
	load(NB.decode(result))()
end,'player.lua')