if IsClient() then
com.menu = {Client={},Server={},Shared={}}
com.menu.ESXMenuFramework = {}
com.menu.type = {}
local RegisterKeyboardCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'keyboard', key) end 
local RegisterMouseWheelCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'MOUSE_WHEEL', key) end 
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
RegisterMouseButtonCallback("MENU_MOUSE_LEFT","MOUSE_LEFT","MOUSE_LEFT",function()
	TriggerAcceptedStyleMenuInput("MENU_MOUSE_LEFT_CLICK")
end)
RegisterMouseWheelCallback("MENU_WHEEL_UP","IOM_WHEEL_UP","Wheel UP",function()
	TriggerAcceptedStyleMenuInput("MENU_WHEEL_UP")
end)
RegisterMouseWheelCallback("MENU_WHEEL_DOWN","IOM_WHEEL_DOWN","Wheel DOWN",function()
	TriggerAcceptedStyleMenuInput("MENU_WHEEL_DOWN")
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