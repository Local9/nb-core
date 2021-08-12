if IsClient() then
com.menu = {Client={},Server={},Shared={}}
com.menu.ESXMenuFramework = {}
com.menu.default = {}
local RegisterKeyboardCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'keyboard', key) end 

com.menu.ESXMenuFramework = ESX.UI.Menu
NB.Menu = com.menu.ESXMenuFramework

local AcceptedStyle = {"default"}

local TriggerAcceptedStyleMenuInput = function(input)
	for i=1,#AcceptedStyle do 
		local type = AcceptedStyle[i]
		NB.Menu.RegisteredTypes[type].input(input)
	end 
end 

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