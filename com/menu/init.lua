if IsClient() then
	com.menu = {
		_TEMP_ = {NBMenu={}}
	}
	com.menu.ESXMenu = ESX.UI.Menu
	com.menu._TEMP_.Clear = 		function(...) return com.lua.utils.Table.ClearTableSomething(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.Set = 			function(...) return com.lua.utils.Table.SetTableSomething(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.IsExist = 		function(...) return com.lua.utils.Table.IsTableSomthingExist(com.menu._TEMP_.NBMenu,...) end 
	com.menu._TEMP_.Get = 			function(...) return com.lua.utils.Table.GetTableSomthing(com.menu._TEMP_.NBMenu,...) end  
	com.menu._TEMP_.InsertTable = 	function(...) return com.lua.utils.Table.InsertTableSomethingTable(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.RemoveTable = 	function(...) return com.lua.utils.Table.RemoveTableSomethingTable(com.menu._TEMP_.NBMenu,...) end
end 