NB.GetCitizenDataFromId = function(playerId)
	local playerdata = NB.GetPlayerDataFromId(playerId)
	local citizendata
	if playerdata and playerdata.citizenData then 
		citizendata = playerdata.citizenData
	else 
		error("citizen data not loaded",2)
	end 
	return citizendata
end 
NB.AddEventHandler("NB:CreateCitizen",function(playerId, license,cb)
	local license = license
	local citizenID = DB.User.DataSlotTemplateGenerator('citizen_id','citizens','xxyyyyyyyyyx')
	local create = DB.Citizen.Create(playerId,citizenID,license)
	if create then 
		print("Created a character into database")
		DB.Citizen.Init(playerId,citizenID)
		cb(citizenID)
	else 
		error("creating citizen failed",2)
	end 
end)
NB.AddEventHandler("NB:LoadCitizen",function(playerId, license,cb)
	local license = license
	local citizenID = DB.Citizen.GetIDFromLicense(license,1)
	DB.Citizen.Init(playerId,citizenID)
	cb(citizenID)
end)
NB.RegisterNetEvent("NB:OnCitizenLoaded",function(playerId,citizenID) 
	NB.TriggerClientEvent("NB:CitizenLoaded",playerId,citizenID)
	if OnCitizenLoaded then OnCitizenLoaded(playerId,citizenID) end 
end)