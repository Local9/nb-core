if IsClient() then 
local Menu = {_PROPS_={focus={}}}
local NB_MENU_DEFAULT = Menu["_PROPS_"]
com.menu.Default = Menu
NB_MENU_DEFAULT.ClearPropSlotValue = function(...) return com.lua.utils.Table.ClearTableSomething(Menu["_PROPS_"],...) end
NB_MENU_DEFAULT.SetPropSlotValue = function(...) return com.lua.utils.Table.SetTableSomething(Menu["_PROPS_"],...) end
NB_MENU_DEFAULT.IsPropSlotValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(Menu["_PROPS_"],...) end 
NB_MENU_DEFAULT.GetPropSlotValue = function(...) return com.lua.utils.Table.GetTableSomthing(Menu["_PROPS_"],...) end  
NB_MENU_DEFAULT.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(Menu["_PROPS_"],...) end
NB_MENU_DEFAULT.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(Menu["_PROPS_"],...) end
local MenuType = 'default'
local openMenu = function(namespace, name, data)
	NB_MENU_DEFAULT.Open(namespace, name, data);
end
local closeMenu = function(namespace, name)
	NB_MENU_DEFAULT.Close(namespace, name);
end
com.menu.framework.RegisterType(MenuType, openMenu, closeMenu)
NB_MENU_DEFAULT.Open = function(namespace,name,data)
	if NB_MENU_DEFAULT.IsPropSlotValueExist("opened",namespace,name) then 
		NB_MENU_DEFAULT.Close(namespace, name);
	end 
	for i=1,#data.elements,1 do 
		if data.elements[i].type == nil then 
			data.elements[i].type = 'default';
		end 
	end 
	data._index     = #NB_MENU_DEFAULT.focus;
	data._namespace = namespace;
	data._name      = name;
	for i=1,#data.elements,1 do 
		data.elements[i]._namespace = namespace;
		data.elements[i]._name      = name;
	end 
	NB_MENU_DEFAULT.SetPropSlotValue("opened",namespace,name,data)
	NB_MENU_DEFAULT.SetPropSlotValue("pos",namespace,name,1)
	for i=1,#data.elements,1 do 
		if data.elements[i].selected  then 
			NB_MENU_DEFAULT.SetPropSlotValue("pos",namespace,name,i)
		else
			data.elements[i].selected = false
		end 
	end 
	NB_MENU_DEFAULT.InsertPropSlot("focus",{namespace=namespace,name=name})
	NB_MENU_DEFAULT.Update();
end 
NB_MENU_DEFAULT.Close = function(namespace, name)
	for  i=1,#NB_MENU_DEFAULT.focus, 1 do 
		if NB_MENU_DEFAULT.focus[i].namespace == namespace and  NB_MENU_DEFAULT.focus[i].name == name then 
			table.remove(NB_MENU_DEFAULT.focus,i)
			NB_MENU_DEFAULT.ClearPropSlotValue('opened',namespace,name)
			break;
		end 
	end 
	NB_MENU_DEFAULT.Update();
end 
NB_MENU_DEFAULT.GetCurrentFocus = function()
	return NB_MENU_DEFAULT.focus[#NB_MENU_DEFAULT.focus];
end 
NB_MENU_DEFAULT.GetCurrentFocusData = function(cb)
	local currentFocus = NB_MENU_DEFAULT.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menu    = NB_MENU_DEFAULT.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_MENU_DEFAULT.pos[currentFocus.namespace][currentFocus.name];
		local itemdata    = menu.elements[pos];
		if(#menu.elements > 0) then 
			cb(currentFocus.namespace,currentFocus.name,#menu.elements,menu,pos,itemdata)
		else 
			error("menu has no any datas",2)
		end 
	end 
end 
NB_MENU_DEFAULT.Update = function() -- DRAW FUNCTIONS
	local currentFocus             = NB_MENU_DEFAULT.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menuData    = NB_MENU_DEFAULT.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_MENU_DEFAULT.pos[currentFocus.namespace][currentFocus.name];
		if menuData.elements and (#menuData.elements > 0) then 
			--print(menuData.title)
			--print(menuData.description)	
			for i,v in pairs (menuData.elements) do 
				if i == pos then 
					v.selected = true;
				end 
			end 
		end 
	end 
end 
NB_MENU_DEFAULT.submit = function(namespace, name, data)
	local data = {
		_namespace= namespace,
		_name     = name,
		current   = data,
		elements  = NB_MENU_DEFAULT.opened[namespace][name].elements
	}
	local menu = com.menu.framework.GetOpened(MenuType, data._namespace, data._name)
	if menu.submit ~= nil then
		menu.submit(data, menu)
	end
end 
NB_MENU_DEFAULT.cancel = function(namespace, name)
	local data = {_namespace= namespace,_name= name}
	local menu = com.menu.framework.GetOpened(MenuType, data._namespace, data._name)
	if menu.cancel ~= nil then
		menu.cancel(data, menu)
	end
end 
NB_MENU_DEFAULT.change = function(namespace, name, data)
	local data = {_namespace= namespace,_name= name,current= data,elements= NB_MENU_DEFAULT.opened[namespace][name].elements}
	local menu = com.menu.framework.GetOpened(MenuType, data._namespace, data._name)
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
OnMenuKeyInput = function(input)
	NB_MENU_DEFAULT.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
		switch (input) (
			case ("MENU_SELECT","MENU_ENTER") (
				function()
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU_DEFAULT.submit(namespace, name, itemdata);
				end
			),
			case ("MENU_BACK") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU_DEFAULT.cancel(namespace, name);
				end
			),
			case ("MENU_CANCEL") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU_DEFAULT.cancel(namespace, name);
				end
			),
			case ("MENU_LEFT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					if itemdata and itemdata.type and itemdata.type == 'slider' then 
						if  itemdata.options ~=nil then 
							if not itemdata.options.pos then itemdata.options.pos = {} end 
							local length = #itemdata.options
							local nextoptionpos = itemdata.options.pos - 1 == 0 and itemdata.options.pos - 2 or itemdata.options.pos - 1
							itemdata.value = itemdata.options[nextoptionpos/#itemdata.options];
							NB_MENU_DEFAULT.change(focused.namespace, focused.name, itemdata)
						end 
						NB_MENU_DEFAULT.Update();
					end 
				end
			),
			case ("MENU_RIGHT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					if itemdata and itemdata.type and itemdata.type == 'slider' then 
						if  itemdata.options ~=nil then 
							if not itemdata.options.pos then itemdata.options.pos = {} end 
							local length = #itemdata.options
							local nextoptionpos = itemdata.options.pos + 1 == 0 and itemdata.options.pos + 2 or itemdata.options.pos + 1
							itemdata.value = itemdata.options[nextoptionpos/#itemdata.options];
							NB_MENU_DEFAULT.change(focused.namespace, focused.name, itemdata)
						end 
						NB_MENU_DEFAULT.Update();
					end 
				end
			),
			case ("MENU_UP") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					local pos = NB_MENU_DEFAULT.GetPropSlotValue("pos",namespace,name)
					local nextpos = pos-1 == 0 and pos-2 or pos-1
					NB_MENU_DEFAULT.SetPropSlotValue("pos",namespace,name,nextpos%elementslength)
					for i=1,#menu.elements,1 do
						if(i == NB_MENU_DEFAULT.pos[namespace][name]) then 
							menu.elements[i].selected = true
						else
							menu.elements[i].selected = false
						end 
					end 
					NB_MENU_DEFAULT.change(namespace, name, itemdata)
					NB_MENU_DEFAULT.Update();
				end
			),
			case ("MENU_DOWN") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					local pos = NB_MENU_DEFAULT.GetPropSlotValue("pos",namespace,name)
					local nextpos = pos+1 == 0 and pos+2 or pos+1
					NB_MENU_DEFAULT.SetPropSlotValue("pos",namespace,name,nextpos%elementslength)
					for i=1,#menu.elements,1 do
						if(i == NB_MENU_DEFAULT.pos[namespace][name]) then 
							menu.elements[i].selected = true
						else
							menu.elements[i].selected = false
						end 
					end 
					NB_MENU_DEFAULT.change(namespace, name, itemdata)
					NB_MENU_DEFAULT.Update();
				end
			),
			default (
				function()
					error("Menu",2)
				end 
			)
		)
	end)
end 
end 