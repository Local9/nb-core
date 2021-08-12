if IsClient() then 
local Menu = {_PROPS_={}}
local NB_MENU = Menu["_PROPS_"]
com.game.Menu = Menu

NB_MENU.SetPropSlotValue = function(...) return com.lua.utils.Table.SetTableSomething(Menu["_PROPS_"],...) end
NB_MENU.IsPropSlotValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(Menu["_PROPS_"],...) end 
NB_MENU.GetPropSlotValue = function(...) return com.lua.utils.Table.GetTableSomthing(Menu["_PROPS_"],...) end  
NB_MENU.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(Menu["_PROPS_"],...) end
NB_MENU.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(Menu["_PROPS_"],...) end

Menu.Reset = function()
	NB_MENU.opened = false 
end 

Menu.Init = function()
	Menu.Reset()
end 

Menu.Open = function(namespace,name,data)
	if NB_MENU.IsPropSlotValueExist("opened",namespace,name) then 
		Menu.Close(namespace, name);
	end 
	for i=1,#data.elements,1 do 
		if data.elements[i].type == nil then 
			data.elements[i].type = 'scaleform';
		end 
	end 
	data._index     = #NB_MENU.focus;
	data._namespace = namespace;
	data._name      = name;

	for i=1,#data.elements,1 do 
		data.elements[i]._namespace = namespace;
		data.elements[i]._name      = name;
	end 

	NB_MENU.SetPropSlotValue("opened",namespace,name,data)
	NB_MENU.SetPropSlotValue("pos",namespace,name,1)
	for i=1,#data.elements,1 do 
		if data.elements[i].selected  then 
			NB_MENU.SetPropSlotValue("pos",namespace,name,i)
		else
			data.elements[i].selected = false
		end 
	end 

	table.insert(NB_MENU.focus,{namespace=namespace,name=name});
end 

Menu.Close = function()
	NB_MENU.opened = false 
end 

Menu.CloseCurrent = function()
	NB_MENU.opened = false 
end 

OnMenuKeyInput = function(input)
	if NB_MENU.opened then 
		switch (input) (
			case ("MENU_SELECT","MENU_ENTER") (
				function()
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			case ("MENU_BACK") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			case ("MENU_CANCEL") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					Menu.CloseCurrent()
				end
			),
			case ("MENU_LEFT","MENU_RIGHT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			case ("MENU_UP","MENU_DOWN") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
				end
			),
			default (
				function()
					error("Menu",2)
				end 
			)
		)
	end 
end 

Menu.Init()
end 