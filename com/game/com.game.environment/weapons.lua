if IsClient() then 
	CreateThread(function()
		SetWeaponsNoAutoreload(WEAPON_AUTO_RELOAD)
	end)
end 