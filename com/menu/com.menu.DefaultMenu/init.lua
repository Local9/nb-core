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
		"focus"
	}
	

	menuOpen = function(currentMenu)
		local namespace, name, data = currentMenu.namespace, currentMenu.name, currentMenu.data
		local _,lastindex,lastmenu = TableInsert("menus",currentMenu)
		lastmenu.index = lastindex
		Set("focus",lastmenu)
		
		
	end 
	
	menuClose = function(namespace, name)
		print(namespace, name);
		
		local _,lastindex,lastmenu= TableRemove("menus")
		if lastmenu then 
			Set("focus",lastmenu)
		end 
	end 
	
	
	
	
	local Open = function(namespace, name, data) --button = data.elements
		local currentMenu = com.menu.ESXMenu.DeepOpen(MENUTYPE,namespace, name)  --獲得目前最新的純表格的DeepCopy並關閉
		menuOpen(currentMenu)
	end

	com.menu.ESXMenu.RegisterType(MENUTYPE, Open)
end