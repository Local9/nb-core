NB.RegisterServerCallback('NB:OnPlayerSessionStart', function(source,cb)
	TriggerClientEvent('NB:OnPlayerRequestSpawn',source)
	cb('ok')
end)

NB.RegisterServerCallback("NB:SpawnPlayer",function(source,cb)
	NB.GetExpensivePlayerData(source,'users','position',function(result)
		if result then 
			local pos = json.decode(result[1].position)
			cb(vector3(pos.x, pos.y, pos.z), pos.heading)
			--cb(vector3(pos[1], pos[2], pos[3]), pos[4])
		end 
	end)
end )

NB.RegisterServerCallback('NB:SavePlayerPosition', function(source,cb,coords,heading)
	local x, y, z = table.unpack(coords)
	NB.SetExpensivePlayerData(source,'users','position',{x=x,y=y,z=z,heading=heading})
end)
