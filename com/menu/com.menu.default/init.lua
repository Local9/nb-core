if IsClient() then 
	local currentmenu_
	local open = function(currentmenu, data) --button = data.elements
		--print(invoking,index,json.encode(data))
		currentmenu_ = currentmenu
	end
	local close = function(currentmenu,islast) --button = data.elements
		--print("close")
		--print("stop render",currentmenu.invoking, currentmenu.index)
		if islast then 
			
		end 
		
	end
	local updaterender = function(currentmenu , simplymenu, isupdate)
		--print('render simply menu',isupdate, invoking, index , json.encode(simplymenu))
	
	end 

	local keylistener = function(currentmenu,input)
		
		if currentmenu and currentmenu.button then 
			switch(input)(
				case("MENU_LEFT")(function()
					currentmenu.button.left()
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end),
				case("MENU_RIGHT")(function()
					currentmenu.button.right()
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end),
				
				case("MENU_UP")(function()
					currentmenu.button.up()
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					
				end),
				case("MENU_DOWN")(function()
					currentmenu.button.down()
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					
				end),
				case("MENU_MOUSE_LEFT_CLICK")(function()
				end),
				case("MENU_ENTER","MENU_SELECT")(function()
					currentmenu.button.enter() 
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					
				end),
				case("MENU_BACK")(function()
					currentmenu.button.back()
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					
				end),
				case("MENU_ESCAPE")(function()
					currentmenu.button.esc()
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end),
				default(function()
				end)
			)
		end 
	end 
	--com.menu.RegisterType("default", open, close, render, true)
	com.menu.RegisterType("default", open, close, keylistener, updaterender, stoprender)
	
	
end 