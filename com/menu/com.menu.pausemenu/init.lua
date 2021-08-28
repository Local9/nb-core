if IsClient() then 
	local currentmenu_
	local function GetPos() 
		local a,b,c = GetPauseMenuSelectionData() 
		return c ~= -1 and c+1 or 1 
	end 
	local open = function(currentmenu, data) --button = data.elements
		--print(currentmenu.invoking,currentmenu.index,json.encode(data))
		--只會建立一次
		
		currentmenu_ = currentmenu
		NB.Threads.CreateLoopOnce("pausemenu",50,function(Break)
			if currentmenu_ then 
				if N_0x2e22fefa0100275e() then 
					local pos = GetPos()
					if pos then 
						currentmenu_.select(pos)
					end 
				end 
				
			end 
		end)
	end
	local close = function(currentmenu,islast) --button = data.elements
		--print("close")
		--print("stop render",currentmenu.invoking, currentmenu.index)
		if islast then 
			com.menu.PauseMenu.UI.RenderStop()
			NB.Threads.KillActionOfLoop("pausemenu"..currentmenu.index)
		end 
		
	end
	local updaterender = function(currentmenu , simplymenu, isupdate)
		--print('render simply menu',isupdate, invoking, index , json.encode(simplymenu))
		com.menu.PauseMenu.UI.Render(simplymenu,isupdate,isupdate and currentmenu.pos)
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
					--PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					
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
	--com.menu.RegisterType("pausemenu", open, close, render, true)
	com.menu.RegisterType("pausemenu", open, close, keylistener, updaterender, stoprender)
	
	
end 