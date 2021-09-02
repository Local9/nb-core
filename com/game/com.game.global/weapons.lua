if IsClient() then 
	CreateThread(function()
		SetWeaponsNoAutoreload(GAME_WEAPON_AUTO_RELOAD)
	end)
end 