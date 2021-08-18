if IsClient() then
print(1)
com.menu = {Client={},Server={},Shared={}}
com.menu.ESXMenuFramework = {}
com.menu.type = {}
NBMenu = {}
NBMenu.ClearProp = function(...) return com.lua.utils.Table.ClearTableSomething(NBMenu,...) end
NBMenu.SetProp = function(...) return com.lua.utils.Table.SetTableSomething(NBMenu,...) end
NBMenu.IsPropExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NBMenu,...) end 
NBMenu.GetProp = function(...) return com.lua.utils.Table.GetTableSomthing(NBMenu,...) end  
NBMenu.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NBMenu,...) end
NBMenu.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NBMenu,...) end
NBMenu.NextIndex = 1
NBMenu._TEMP_ = {METHODS={}}
NBMenu.RegisteredInput = {}
NBMenu.Methods = {}

com.menu.ESXMenuFramework = NBMenu --ESX.UI.Menu

end 