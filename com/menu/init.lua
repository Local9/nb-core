if IsClient() then
com.menu = {Client={},Server={},Shared={}}
com.menu.ESXMenuFramework = {}
com.menu.type = {}
local RegisterKeyboardCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'keyboard', key) end 
local RegisterMouseWheelCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'MOUSE_WHEEL', key) end 
local RegisterMouseButtonCallback = function(name,key,description,fn) RegisterCommand(name, function() fn() end, false) RegisterKeyMapping(name, IsStringNullOrEmpty(description) and name or description , 'MOUSE_BUTTON', key) end 
com.menu.ESXMenuFramework = ESX.UI.Menu
NB.MenuFramework = com.menu.ESXMenuFramework
NB.RegisteredKeyEvent = {}

NB.RegisterKeyEvent = function(name,cb)
	NB.RegisteredKeyEvent[name] = cb 
end 

local TriggerRegisterKeyEvent = function(input)
	for i,v in pairs(NB.RegisteredInput) do 
		if v then 
			v(input)  
		end 
	end 
end 

RegisterMouseButtonCallback("MENU_MOUSE_LEFT","MOUSE_LEFT","MOUSE_LEFT",function()
	TriggerRegisterKeyEvent("MENU_MOUSE_LEFT_CLICK")
end)
RegisterMouseWheelCallback("MENU_WHEEL_UP","IOM_WHEEL_UP","Wheel UP",function()
	TriggerRegisterKeyEvent("MENU_WHEEL_UP")
end)
RegisterMouseWheelCallback("MENU_WHEEL_DOWN","IOM_WHEEL_DOWN","Wheel DOWN",function()
	TriggerRegisterKeyEvent("MENU_WHEEL_DOWN")
end)
RegisterKeyboardCallback("MENU_SELECT","SPACE","MENU SELECT",function()
	TriggerRegisterKeyEvent("MENU_SELECT")
end )
RegisterKeyboardCallback("MENU_SHIFT","TAB","",function()
	TriggerRegisterKeyEvent("MENU_SHIFT")
end )
RegisterKeyboardCallback("MENU_BACK","BACK","",function()
	TriggerRegisterKeyEvent("MENU_BACK")
end )
RegisterKeyboardCallback("MENU_ESCAPE","ESCAPE","",function()
	TriggerRegisterKeyEvent("MENU_ESCAPE")
end )
RegisterKeyboardCallback("MENU_ENTER","RETURN","",function()
	TriggerRegisterKeyEvent("MENU_ENTER")
end )
RegisterKeyboardCallback("MENU_UP","UP","",function()
	TriggerRegisterKeyEvent("MENU_UP")
end )
RegisterKeyboardCallback("MENU_DOWN","DOWN","",function()
	TriggerRegisterKeyEvent("MENU_DOWN")
end )
RegisterKeyboardCallback("MENU_LEFT","LEFT","",function()
	TriggerRegisterKeyEvent("MENU_LEFT")
	
end )
RegisterKeyboardCallback("MENU_RIGHT","RIGHT","",function()
	TriggerRegisterKeyEvent("MENU_RIGHT")
end )
if GetCurrentResourceName() ~= "nb-menu" then --a must, otherwise function becomes table in main framework script
NBMenu = exports['nb-menu']:GetClientObject()
end 

RequestMenu = NBMenu.RequestMenu
BeginMenuMethod = NBMenu.BeginMenuMethod
MenuMethodAddParams = NBMenu.MenuMethodAddParams
MenuMethodAddParamsDatas = NBMenu.MenuMethodAddParamsDatas
MenuMethodAddButton = NBMenu.MenuMethodAddButton
MenuMethodAddOption = NBMenu.MenuMethodAddOption
MenuMethodAddCallback = NBMenu.MenuMethodAddCallback
EndMenuMethod = NBMenu.EndMenuMethod
EndMenuMethodReturn = NBMenu.EndMenuMethodReturn
MenuMethodAddElements = NBMenu.MenuMethodAddElements
SetMenuAsNoLongerNeeded = NBMenu.SetMenuAsNoLongerNeeded
HasMenuLoaded = NBMenu.HasMenuLoaded
OnMenuRenderUpdate = NBMenu.OnRenderUpdate

end 