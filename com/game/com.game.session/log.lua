if IsServer() then 
	NB.RegisterNetEvent("NB:log", function (strings,isprint,playerId_)
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
			if isprint then 
				print(strings)
			end 
			f:close()
		else 
			print(err)
		end 
	end)

end