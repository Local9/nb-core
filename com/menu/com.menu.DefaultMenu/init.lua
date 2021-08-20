if IsClient() then 
	local MENUTYPE = 'default'
	local Clear 			= 	function(...) return com.menu._TEMP_.Clear(MENUTYPE,...) end 		
	local Set 			= 	function(...) return com.menu._TEMP_.Set(MENUTYPE,...) end 
	local IsExist 		= 	function(...) return com.menu._TEMP_.IsExist(MENUTYPE,...) end 		
	local Get 			= 	function(...) return com.menu._TEMP_.Get(MENUTYPE,...) end   			
	local TableInsert	= 	function(...) return com.menu._TEMP_.InsertTable(MENUTYPE,...) end   	
	local TableRemove	= 	function(...) return com.menu._TEMP_.RemoveTable(MENUTYPE,...) end  	
	local GetTableLastItem	= 	function(x) return (#Get(x) > 0 and Get(x)[#Get(x)]) or nil end
	local Keys = {
		"menus",
	}
	local CurrentMenu = nil
	
	local menuOpen = function(newMenu,isUpdate)
		if not isUpdate then 
			local namespace, name, data = newMenu.namespace, newMenu.name, newMenu.data
			local _,lastindex,newmenu = TableInsert("menus",newMenu)
			CurrentMenu = newmenu --Get("menus")[#Get("menus")]
			CurrentMenu.index = lastindex
			CurrentMenu.updateRender = com.menu.DefaultMenu.UI.Render
			if CurrentMenu.updateRender then 
				local simplymenu = com.menu.minify(CurrentMenu)
				CurrentMenu.updateRender(simplymenu)
				--print_table_server(simplymenu)
			end 
		end 
		if not ThreadCreated then 
			CreateThread(function()
				--只會建立一次
				ThreadCreated = true
				com.menu.RegisterKeyEvent('Menu'..MENUTYPE,function(input)
					if CurrentMenu then 
						switch(input)(
							case("MENU_LEFT")(function()
								CurrentMenu.button.left()
								PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							end),
							case("MENU_RIGHT")(function()
								CurrentMenu.button.right()
								PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							end),
							
							case("MENU_UP")(function()
								CurrentMenu.button.up()
								PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
								
							end),
							case("MENU_DOWN")(function()
								CurrentMenu.button.down()
								PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
								
							end),
							case("MENU_MOUSE_LEFT_CLICK")(function()
							end),
							case("MENU_ENTER","MENU_SELECT")(function()
								CurrentMenu.button.enter() 
								PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
								
							end),
							case("MENU_BACK")(function()
								CurrentMenu.button.back()
								PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
								
							end),
							case("MENU_ESCAPE")(function()
								CurrentMenu.button.esc()
								PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							end),
							default(function()
							end)
						)
					end 
				end )
			end)
		end 
		return newMenu.index
	end 
	local menuClose = function()
		local nowmenu = CurrentMenu
		local _,lastindex,lastmenu= TableRemove("menus")
		if lastmenu then 
			CurrentMenu = lastmenu
			if CurrentMenu.updateRender then 
				local simplymenu = com.menu.minify(CurrentMenu)
				CurrentMenu.updateRender(simplymenu)
				--print_table_server(simplymenu)
			end 
		else 
			com.menu.UnRegisterKeyEvent("Menu"..MENUTYPE)

			ThreadCreated = nil
			
			if com.menu.DefaultMenu.UI.RenderStop then 
				com.menu.DefaultMenu.UI.RenderStop()
			end 
			
			CurrentMenu = nil
		end 
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end 
	local open = function(namespace, name, data) --button = data.elements
		local newMenu = com.menu.ESXMenu.DeepOpen(MENUTYPE,namespace, name)  --獲得目前最新的純表格並關閉
		newMenu.refresh = function() menuOpen(newMenu,true) end
		local handle = menuOpen(newMenu)
	end
	local close = function() --button = data.elements
		menuClose()
	end
	com.menu.ESXMenu.RegisterType(MENUTYPE, open, close)
end