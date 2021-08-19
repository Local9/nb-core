if IsClient() then
	com.menu = {
		_TEMP_ = {NBMenu={}}
	}
	com.menu.ESXMenu = ESX.UI.Menu
	com.menu.ESXMenu.DeepOpen = function(type, namespace, name) --基本不會用到 除非這麼有責任心
		local menu = deepcopy(com.menu.ESXMenu.GetOpened(type,namespace, name))
		com.menu.ESXMenu.ThrowAway(MENUTYPE,namespace, name) --關閉大Open
        return menu
    end
	com.menu.ESXMenu.ThrowAway = function(type, namespace, name) --基本不會用到 除非這麼有責任心
        for i=1, #ESX.UI.Menu.Opened, 1 do
            if ESX.UI.Menu.Opened[i] then
                if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
                    ESX.UI.Menu.Opened[i] = nil
                end
            end
        end
    end
	com.menu._TEMP_.Clear = 		function(...) return com.lua.utils.Table.ClearTableSomething(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.Set = 			function(...) return com.lua.utils.Table.SetTableSomething(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.IsExist = 		function(...) return com.lua.utils.Table.IsTableSomthingExist(com.menu._TEMP_.NBMenu,...) end 
	com.menu._TEMP_.Get = 			function(...) return com.lua.utils.Table.GetTableSomthing(com.menu._TEMP_.NBMenu,...) end  
	com.menu._TEMP_.InsertTable = 	function(...) return com.lua.utils.Table.InsertTableSomethingTable(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.RemoveTable = 	function(...) return com.lua.utils.Table.RemoveTableSomethingTable(com.menu._TEMP_.NBMenu,...) end
end 