if IsClient() then 
	local MENUTYPE = 'default'
	local Clear 			= 	function(...) return com.menu._TEMP_.Clear(MENUTYPE,...) end 		
	local Set 			= 	function(...) return com.menu._TEMP_.Set(MENUTYPE,...) end 
	local IsExist 		= 	function(...) return com.menu._TEMP_.IsExist(MENUTYPE,...) end 		
	local Get 			= 	function(...) return com.menu._TEMP_.Get(MENUTYPE,...) end   			
	local TableInsert	= 	function(...) return com.menu._TEMP_.InsertTable(MENUTYPE,...) end   	
	local TableRemove	= 	function(...) return com.menu._TEMP_.RemoveTable(MENUTYPE,...) end  	
	local GetTableLastItem	= 	function(x) return (#Get(x) > 0 and Get(x)[#Get(x)]) or nil end
	
	menuOpen = function(currentMenu)
		local namespace, name, data = currentMenu.namespace, currentMenu.name, currentMenu.data
		local lastmenu,lastindex = TableInsert("menus",currentMenu)
		lastmenu.index = lastindex
		Set("focus",lastmenu)
		print(lastindex,namespace, name, json.encode(data))

	end 
	
	menuClose = function(namespace, name)
		print(namespace, name);
		
		local lastmenu= TableRemove("menus")
		if not lastmenu then 
			com.menu.ESXMenu.Close(MENUTYPE,namespace, name) --關閉大Open
		else 
			Set("focus",lastmenu)
		end 
	end 
	
	
	
	
	local Open = function(namespace, name, data) --button = data.elements
		local currentMenu = deepcopy(com.menu.ESXMenu.GetOpened(MENUTYPE,namespace, name))  --獲得目前最新的純表格
		menuOpen(currentMenu)
	end

	com.menu.ESXMenu.RegisterType(MENUTYPE, Open)
end