if IsServer() then 
	RegisterServerEvent("NB:log")
	AddEventHandler("NB:log", function (strings,playerId_)
		local playerId = NB and NB.PlayerId and NB.PlayerId(source) or tonumber(source)
		if playerId or playerId_ then 
			if NB and NB.GetLicense then 
				strings = "[".. os.date("%Y/%m/%d %H:%M:%S") .. "]".."[Client][".. NB.GetLicense(playerId) .."]"..strings 
			else 
				strings = "[".. os.date("%Y/%m/%d %H:%M:%S") .. "]".."[Client]"..strings 
			end 
		else 
			strings = "[".. os.date("%Y/%m/%d %H:%M:%S") .. "]".."[Server]"..strings 
		end
		local f,err = io.open('nbcore_log.txt','a+') 
		if f then 
			f:write(strings.."\n")
			f:close()
		else 
			print(err)
		end 
	end)

end