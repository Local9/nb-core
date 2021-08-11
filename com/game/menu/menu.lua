OnMenuKeyInput = function(input)
	switch (input) (
        case ("MENU_SELECT") (
			function()
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
			end
		),
		case ("MENU_CANCEL") (
			function()
				PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
			end
		),
		case ("MENU_UP","MENU_DOWN","MENU_LEFT","MENU_RIGHT") (
			function()
				PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
			end
		),
        default (
			function()
				
			end 
		)
    )
end 