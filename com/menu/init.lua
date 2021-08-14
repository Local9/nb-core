if IsClient() then
com.menu = {Client={},Server={},Shared={}}
com.menu.ESXMenuFramework = {}
com.menu.type = {}

local RegisterKeyboardCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'keyboard', key) end 
local RegisterMouseButtonCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'MOUSE_BUTTON', key) end 

com.menu.ESXMenuFramework = ESX.UI.Menu
NB.MenuFramework = com.menu.ESXMenuFramework

NB.MenuFramework.AcceptedInput = {}

local TriggerAcceptedStyleMenuInput = function(input)
	
	for i,v in pairs(NB.MenuFramework.AcceptedInput) do 
		if v.input then 
			v.input(input)  
		end 
	end 
end 
RegisterMouseButtonCallback("+MOUSE_LEFT","MOUSE_LEFT","Left Click",function()
	TriggerAcceptedStyleMenuInput("MENU_MOUSE_LEFT_PRESSED")
end)
RegisterMouseButtonCallback("-MOUSE_LEFT","MOUSE_LEFT","Left Click Release",function()
	TriggerAcceptedStyleMenuInput("MENU_MOUSE_LEFT_RELEASED")
end)
RegisterKeyboardCallback("MENU_SELECT","SPACE","MENU SELECT",function()
	TriggerAcceptedStyleMenuInput("MENU_SELECT")
end )

RegisterKeyboardCallback("MENU_SHIFT","TAB","",function()
	TriggerAcceptedStyleMenuInput("MENU_SHIFT")
end )

RegisterKeyboardCallback("MENU_BACK","BACK","",function()
	TriggerAcceptedStyleMenuInput("MENU_BACK")
end )

RegisterKeyboardCallback("MENU_ESCAPE","ESCAPE","",function()
	TriggerAcceptedStyleMenuInput("MENU_ESCAPE")
end )

RegisterKeyboardCallback("MENU_ENTER","RETURN","",function()
	TriggerAcceptedStyleMenuInput("MENU_ENTER")
end )

RegisterKeyboardCallback("MENU_UP","UP","",function()
	TriggerAcceptedStyleMenuInput("MENU_UP")
end )

RegisterKeyboardCallback("MENU_DOWN","DOWN","",function()
	TriggerAcceptedStyleMenuInput("MENU_DOWN")
end )

RegisterKeyboardCallback("MENU_LEFT","LEFT","",function()
	TriggerAcceptedStyleMenuInput("MENU_LEFT")
end )

RegisterKeyboardCallback("MENU_RIGHT","RIGHT","",function()
	TriggerAcceptedStyleMenuInput("MENU_RIGHT")
end )


end 