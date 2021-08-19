if IsClient() then 
	local MENUTYPE = 'pausemenu'
	local Clear 			= 	function(...) return com.menu._TEMP_.Clear(MENUTYPE,...) end 		
	local Set 			= 	function(...) return com.menu._TEMP_.Set(MENUTYPE,...) end 
	local IsExist 		= 	function(...) return com.menu._TEMP_.IsExist(MENUTYPE,...) end 		
	local Get 			= 	function(...) return com.menu._TEMP_.Get(MENUTYPE,...) end   			
	local TableInsert	= 	function(...) return com.menu._TEMP_.InsertTable(MENUTYPE,...) end   	
	local TableRemove	= 	function(...) return com.menu._TEMP_.RemoveTable(MENUTYPE,...) end  	
	local GetTableLastItem	= 	function(x) return (#Get(x) > 0 and Get(x)[#Get(x)]) or nil end
	local Keys = {
		"menus",
		"currentmenu"
	}

	local function GetPos() 
		local a,b,c = GetPauseMenuSelectionData() 
		
			return c ~= -1 and c+1 or 1 
		
	end 
	
	local menuOpen = function(currentMenu,isUpdate)

		if not isUpdate then 
			local namespace, name, data = currentMenu.namespace, currentMenu.name, currentMenu.data
			local _,lastindex,newmenu = TableInsert("menus",currentMenu)
			currentMenu.index = lastindex
			Set("currentmenu",newmenu)
			local menu = newmenu
			local pos = GetPos()
			if pos then 
				menu.select(pos)
			end 
			CreateThread(function() repeat Wait(33) menu.select(GetPos()) until false end)
			NB.RegisterKeyEvent('Menu'..namespace..name,function(input)
				switch(input)(
					case("MENU_LEFT")(function()
						menu.button.left()
						if com.menu.PauseMenu.UI.Render then 
							local simplymenu = com.menu.minify(Get("currentmenu"))
							com.menu.PauseMenu.UI.Render(simplymenu,true)
						end 
					end),
					case("MENU_RIGHT")(function()
						menu.button.right()
						if com.menu.PauseMenu.UI.Render then 
							local simplymenu = com.menu.minify(Get("currentmenu"))
							com.menu.PauseMenu.UI.Render(simplymenu,true)
						end 
					end),
					--[=[
					case("MENU_UP")(function()
						if GetPos()  then 
							menu.select(GetPos() )
						end 
					end),
					case("MENU_DOWN")(function()
						if GetPos()  then 
							menu.select(GetPos() )
						end 
						--menu.button.down()
					end),
					--]=]
					case("MENU_ENTER","MENU_SELECT")(function()
						menu.button.enter()
					end),
					case("MENU_BACK")(function()
						menu.button.back()
					end),
					case("MENU_ESCAPE")(function()
						menu.button.esc()
					end),
					default(function()
					end)
				)
				
				
			end )
			if com.menu.PauseMenu.UI.Render then 
				local simplymenu = com.menu.minify(Get("currentmenu"))
				com.menu.PauseMenu.UI.Render(simplymenu,isUpdate)
				--print_table_server(simplymenu)
			end 
			return lastindex
		end 
		if isUpdate then 
			if com.menu.PauseMenu.UI.Render then 
				local simplymenu = com.menu.minify(Get("currentmenu"))
				com.menu.PauseMenu.UI.Render(simplymenu,isUpdate)
			end 
			return currentMenu.index
		end 
	end 
	local menuClose = function()
		local nowmenu = Get("currentmenu")
		NB.UnRegisterKeyEvent("Menu"..nowmenu.namespace..nowmenu.name)
		local _,lastindex,lastmenu= TableRemove("menus")
		if lastmenu then 
			Set("currentmenu",lastmenu)
		end 
		if com.menu.PauseMenu.UI.RenderStop then 
			com.menu.PauseMenu.UI.RenderStop()
		end 
	end 
	local open = function(namespace, name, data) --button = data.elements
		local currentMenu = com.menu.ESXMenu.DeepOpen(MENUTYPE,namespace, name)  --獲得目前最新的純表格並關閉
		currentMenu.refresh = function() menuOpen(currentMenu,true) end
		local handle = menuOpen(currentMenu)
	end
	local close = function() --button = data.elements
		menuClose()
	end
	com.menu.ESXMenu.RegisterType(MENUTYPE, open, close)
end