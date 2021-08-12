if IsClient() then
com.menu = {Client={},Server={},Shared={}}
com.menu.framework = {}
com.menu.default = {}


local RegisterKeyboardCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'keyboard', key) end 

RegisterKeyboardCallback("MENU_SELECT","SPACE","MENU SELECT",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_SELECT") end 
end )

RegisterKeyboardCallback("MENU_SHIFT","TAB","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_SHIFT") end
end )

RegisterKeyboardCallback("MENU_BACK","BACK","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_BACK") end
end )

RegisterKeyboardCallback("MENU_ESCAPE","ESCAPE","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_CANCEL") end
end )

RegisterKeyboardCallback("MENU_ENTER","RETURN","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_ENTER") end
end )

RegisterKeyboardCallback("MENU_UP","UP","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_UP") end
end )

RegisterKeyboardCallback("MENU_DOWN","DOWN","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_DOWN") end
end )

RegisterKeyboardCallback("MENU_LEFT","LEFT","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_LEFT") end
end )

RegisterKeyboardCallback("MENU_RIGHT","RIGHT","",function()
	if OnMenuKeyInput then OnMenuKeyInput("MENU_RIGHT") end
end )

com.menu.framework.RegisterType = ESX.UI.Menu.RegisterType
com.menu.framework.Open = ESX.UI.Menu.Open
com.menu.framework.Close = ESX.UI.Menu.Close
com.menu.framework.CloseAll = ESX.UI.Menu.CloseAll
com.menu.framework.GetOpened = ESX.UI.Menu.GetOpened
com.menu.framework.GetOpenedMenus = ESX.UI.Menu.GetOpenedMenus
com.menu.framework.IsOpen = ESX.UI.Menu.IsOpen

end 