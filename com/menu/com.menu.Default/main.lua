if IsClient() then 
local NB_Default_Menu = {focus={}}
com.menu.type['DefaultMenu'] = NB_Default_Menu
NB.MenuFramework.AcceptedInput['DefaultMenu'] = {}
NB_Default_Menu.ClearPropSlotValue = function(...) return com.lua.utils.Table.ClearTableSomething(NB_Default_Menu,...) end
NB_Default_Menu.SetPropSlotValue = function(...) return com.lua.utils.Table.SetTableSomething(NB_Default_Menu,...) end
NB_Default_Menu.IsPropSlotValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB_Default_Menu,...) end 
NB_Default_Menu.GetPropSlotValue = function(...) return com.lua.utils.Table.GetTableSomthing(NB_Default_Menu,...) end  
NB_Default_Menu.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NB_Default_Menu,...) end
NB_Default_Menu.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NB_Default_Menu,...) end
local MenuType = 'DefaultMenu'
local openMenu = function(namespace, name, data)
	NB_Default_Menu.Open(namespace, name, data);
end
local closeMenu = function(namespace, name)
	NB_Default_Menu.Close(namespace, name);
end
NB.MenuFramework.RegisterType(MenuType, openMenu, closeMenu)

NB.MenuFramework.AcceptedInput['DefaultMenu'].input = function(input)
	
	NB_Default_Menu.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
		switch (input) (
			case ("MENU_SELECT","MENU_ENTER") (
				function()
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_Default_Menu.submit(namespace, name, itemdata);
				end
			),
			case ("MENU_BACK") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_Default_Menu.cancel(namespace, name);
				end
			),
			case ("MENU_CANCEL") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_Default_Menu.cancel(namespace, name);
				end
			),
			case ("MENU_LEFT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					if itemdata and itemdata.type and itemdata.type == "slider" then 
						
						local length = itemdata.options and #itemdata.options or 0 
						itemdata.options.pos = itemdata.options.pos + 1
						local pos = itemdata.options.pos
						local nextpos = ((pos)%length)+1
						itemdata.value = itemdata.options[nextpos];
						itemdata.options.pos = nextpos
						
						NB_Default_Menu.change(namespace, name, itemdata)
						NB_Default_Menu.Update();
					end
				end
			),
			case ("MENU_RIGHT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					if itemdata and itemdata.type and itemdata.type == "slider" then 
						
						local length = itemdata.options and #itemdata.options or 0 
						local pos = itemdata.options.pos
						local nextpos = ((pos)%length)+1
						itemdata.value = itemdata.options[nextpos];
						itemdata.options.pos = nextpos
						NB_Default_Menu.change(namespace, name, itemdata)
						NB_Default_Menu.Update();
					end
				end
			),
			case ("MENU_UP") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					local pos = NB_Default_Menu.GetPropSlotValue("pos",namespace,name)
					local nextpos = ((pos)%elementslength)+1
					NB_Default_Menu.SetPropSlotValue("pos",namespace,name,nextpos)
					for i=1,#menu.elements,1 do
						if(i == NB_Default_Menu.pos[namespace][name]) then 
							menu.elements[i].selected = true
						else
							menu.elements[i].selected = false
						end 
					end 
					NB_Default_Menu.change(namespace, name, itemdata)
					NB_Default_Menu.Update();
				end
			),
			case ("MENU_DOWN") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					local pos = NB_Default_Menu.GetPropSlotValue("pos",namespace,name)
					local nextpos = ((pos)%elementslength)+1
					NB_Default_Menu.SetPropSlotValue("pos",namespace,name,nextpos)
					for i=1,#menu.elements,1 do
						if(i == NB_Default_Menu.pos[namespace][name]) then 
							menu.elements[i].selected = true
						else
							menu.elements[i].selected = false
						end 
					end 
					NB_Default_Menu.change(namespace, name, itemdata)
					NB_Default_Menu.Update();
				end
			),
			default (
				function()
					--error("Menu",2)
				end 
			)
		)
	end)
end 


NB_Default_Menu.Open = function(namespace,name,data)
	if NB_Default_Menu.IsPropSlotValueExist("opened",namespace,name) then 
		NB_Default_Menu.Close(namespace, name);
	end 
	for i=1,#data.elements,1 do 
		if data.elements[i].type == nil then 
			data.elements[i].type = 'default';
		elseif data.elements[i].type == 'slider' then 
			if not data.elements[i].options then data.elements[i].options = {} end 
			if not data.elements[i].options.pos then data.elements[i].options.pos = 1 end 
			if not data.elements[i].value then  data.elements[i].value = data.elements[i].options[1] end 
		end 
	end 
	data._index     = #NB_Default_Menu.focus;
	data._namespace = namespace;
	data._name      = name;
	for i=1,#data.elements,1 do 
		data.elements[i]._namespace = namespace;
		data.elements[i]._name      = name;
	end 
	NB_Default_Menu.SetPropSlotValue("opened",namespace,name,data)
	NB_Default_Menu.SetPropSlotValue("pos",namespace,name,1)
	for i=1,#data.elements,1 do 
		if data.elements[i].selected  then 
			NB_Default_Menu.SetPropSlotValue("pos",namespace,name,i)
		else
			data.elements[i].selected = false
		end 
	end 
	NB_Default_Menu.InsertPropSlot("focus",{namespace=namespace,name=name})
	NB_Default_Menu.Update();
end 
NB_Default_Menu.Close = function(namespace, name)
	for  i=1,#NB_Default_Menu.focus, 1 do 
		if NB_Default_Menu.focus[i].namespace == namespace and  NB_Default_Menu.focus[i].name == name then 
			table.remove(NB_Default_Menu.focus,i)
			NB_Default_Menu.ClearPropSlotValue('opened',namespace,name)
			break;
		end 
	end 
	NB_Default_Menu.Update();
end 
NB_Default_Menu.GetCurrentFocus = function()
	return NB_Default_Menu.focus[#NB_Default_Menu.focus];
end 
NB_Default_Menu.GetCurrentFocusData = function(cb)
	local currentFocus = NB_Default_Menu.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menu    = NB_Default_Menu.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_Default_Menu.pos[currentFocus.namespace][currentFocus.name];
		local itemdata    = menu.elements[pos];
		if(#menu.elements > 0) then 
			
			
			cb(currentFocus.namespace,currentFocus.name,#menu.elements,menu,pos,itemdata)
		else 
			error("menu has no any datas",2)
		end 
	end 
end 
NB_Default_Menu.Update = function() -- DRAW FUNCTIONS
	local currentFocus             = NB_Default_Menu.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menuData    = NB_Default_Menu.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_Default_Menu.pos[currentFocus.namespace][currentFocus.name];
		if menuData.elements and (#menuData.elements > 0) then 
			--print(menuData.title)
			--print(menuData.description)	
			for i,v in pairs (menuData.elements) do 
				if i == pos then 
					v.selected = true;
				end 
			end 
			TriggerEvent("NB:MenuUpdate",menuData,pos)
		end 
	end 
end 
NB_Default_Menu.submit = function(namespace, name, data)
	local data = {
		_namespace= namespace,
		_name     = name,
		current   = data,
		elements  = NB_Default_Menu.opened[namespace][name].elements
	}
	local menu = NB.MenuFramework.GetOpened(MenuType, data._namespace, data._name)
	if menu.submit ~= nil then
		menu.submit(data, menu)
	end
end 
NB_Default_Menu.cancel = function(namespace, name)
	local data = {_namespace= namespace,_name= name}
	local menu = NB.MenuFramework.GetOpened(MenuType, data._namespace, data._name)
	if menu.cancel ~= nil then
		menu.cancel(data, menu)
	end
end 
NB_Default_Menu.change = function(namespace, name, data)
	local data = {_namespace= namespace,_name= name,current= data,elements= NB_Default_Menu.opened[namespace][name].elements}
	local menu = NB.MenuFramework.GetOpened(MenuType, data._namespace, data._name)
	for i=1, #data.elements, 1 do
		menu.setElement(i, 'value', data.elements[i].value)
		if data.elements[i].selected then
			menu.setElement(i, 'selected', true)
		else
			menu.setElement(i, 'selected', false)
		end
	end
	if menu.change ~= nil then
		menu.change(data, menu)
	end
end 

end 