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
	}
	local CurrentMenu = nil
	local function GetPos() 
		local a,b,c = GetPauseMenuSelectionData() 
		return c ~= -1 and c+1 or 1 
	end 
	local menuOpen = function(newMenu,isUpdate)
		if not isUpdate then 
			local namespace, name, data = newMenu.namespace, newMenu.name, newMenu.data
			local _,lastindex,newmenu = TableInsert("menus",newMenu)
			CurrentMenu = newmenu --Get("menus")[#Get("menus")]
			CurrentMenu.index = lastindex
			CurrentMenu.updateRender = com.menu.PauseMenu.UI.Render
			if CurrentMenu.updateRender then 
				local simplymenu = com.menu.minify(CurrentMenu)
				CurrentMenu.updateRender(simplymenu)
				--print_table_server(simplymenu)
			end 
		end 
		NB.Threads.CreateThreadOnce(MENUTYPE,function()
			--只會建立一次
			NB.Threads.CreateLoop("Menu"..MENUTYPE,50,function(Break)
				if CurrentMenu then 
					if N_0x2e22fefa0100275e() then 
						local pos = GetPos()
						if pos then 
							CurrentMenu.select(pos)
						end 
					end 
				end 
			end)
			com.menu.RegisterKeyEvent('Menu'..MENUTYPE,function(input)
				if CurrentMenu then 
					switch(input)(
						case("MENU_LEFT")(function()
							CurrentMenu.button.left()
						end),
						case("MENU_RIGHT")(function()
							CurrentMenu.button.right()
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
						case("MENU_MOUSE_LEFT_CLICK")(function()--[=[
							local c = PauseMenu.GetValueFromMouse(0.375)
							if c then 
								if c == 1 then 
									local currentmenu = CurrentMenu
									if currentmenu then 
										currentmenu.button.right()
									end 
								elseif c == -1 then 
									local currentmenu = CurrentMenu
									if currentmenu then 
										currentmenu.button.left()
									end 
								end 
							end --]=]
						end),
						case("MENU_ENTER","MENU_SELECT")(function()
							CurrentMenu.button.enter() 
						end),
						case("MENU_BACK")(function()
							CurrentMenu.button.back()
						end),
						case("MENU_ESCAPE")(function()
							CurrentMenu.button.esc()
						end),
						default(function()
						end)
					)
				end 
			end )
		end)
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
			NB.Threads.KillActionOfLoop("Menu"..MENUTYPE)
			NB.Threads.ClearThreadOnce(MENUTYPE)
			if com.menu.PauseMenu.UI.RenderStop then 
				com.menu.PauseMenu.UI.RenderStop()
			end 
			CurrentMenu = nil
		end 
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