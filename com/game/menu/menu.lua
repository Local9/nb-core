local Menu = {}
com.game.Menu = Menu
Menu.Opened = false 

OnMenuKeyInput = function(input)
	if Menu.Opened then 
		switch (input) (
			case ("MENU_SELECT","MENU_ENTER") (
				function()
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			case ("MENU_CANCEL") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			case ("MENU_LEFT","MENU_RIGHT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			case ("MENU_UP","MENU_DOWN") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			default (
				function()
					PlaySoundFrontend(-1, "On_Call_Player_Join", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true);
				end 
			)
		)
	end 
end 