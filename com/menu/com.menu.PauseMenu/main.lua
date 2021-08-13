if IsClient() then 
local NB_Pause_Menu = {focus={}}
com.menu.type['PauseMenu'] = NB_Pause_Menu
NB.MenuFramework.AcceptedInput["PauseMenu"] = {}
NB_Pause_Menu.ClearPropSlotValue = function(...) return com.lua.utils.Table.ClearTableSomething(NB_Pause_Menu,...) end
NB_Pause_Menu.SetPropSlotValue = function(...) return com.lua.utils.Table.SetTableSomething(NB_Pause_Menu,...) end
NB_Pause_Menu.IsPropSlotValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB_Pause_Menu,...) end 
NB_Pause_Menu.GetPropSlotValue = function(...) return com.lua.utils.Table.GetTableSomthing(NB_Pause_Menu,...) end  
NB_Pause_Menu.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NB_Pause_Menu,...) end
NB_Pause_Menu.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NB_Pause_Menu,...) end
local MenuType = 'PauseMenu'
local openMenu = function(namespace, name, data)
	NB_Pause_Menu.Open(namespace, name, data);
end
local closeMenu = function(namespace, name)
	NB_Pause_Menu.Close(namespace, name);
end
local lastpos = nil
function GetPos ()
	local a,b,c = GetPauseMenuSelectionData()
	if c ~= -1 then 
		return c+1 
	else 
		return nil
	end 
end 
NB.MenuFramework.RegisterType(MenuType, openMenu, closeMenu)
NB.MenuFramework.AcceptedInput["PauseMenu"].input = function(input)
	NB_Pause_Menu.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
		switch (input) (
			case ("MENU_SELECT","MENU_ENTER") (function()
					NB_Pause_Menu.submit(namespace, name, itemdata);
			end),
			case ("MENU_BACK") (function()
					NB_Pause_Menu.cancel(namespace, name);
			end),
			case ("MENU_CANCEL") (function()
					NB_Pause_Menu.cancel(namespace, name);
			end),
			case ("MENU_LEFT") (function()
					if itemdata and itemdata.type and itemdata.type == "slider" then 
						local length = itemdata.options and #itemdata.options or 0 
						itemdata.options.pos = itemdata.options.pos + 1
						local pos = itemdata.options.pos
						local nextpos = ((pos)%length)+1
						itemdata.value = itemdata.options[nextpos];
						itemdata.options.pos = nextpos
						NB_Pause_Menu.change(namespace, name, itemdata)
						NB_Pause_Menu.Update();
					end
			end),
			case ("MENU_RIGHT") (function()
					if itemdata and itemdata.type and itemdata.type == "slider" then 
						local length = itemdata.options and #itemdata.options or 0 
						local pos = itemdata.options.pos
						local nextpos = ((pos)%length)+1
						itemdata.value = itemdata.options[nextpos];
						itemdata.options.pos = nextpos
						NB_Pause_Menu.change(namespace, name, itemdata)
						NB_Pause_Menu.Update();
					end
			end),
			default (function()
			end)
		)
	end)
end 
NB_Pause_Menu.Open = function(namespace,name,data)
	if NB_Pause_Menu.IsPropSlotValueExist("opened",namespace,name) then 
		NB_Pause_Menu.Close(namespace, name);
	end 
	for i=1,#data.elements,1 do 
		if data.elements[i].type == nil then 
			data.elements[i].type = 'default';
		elseif data.elements[i].type == 'slider' then 
			if not data.elements[i].options then data.elements[i].options = {} end 
			if not data.elements[i].options.pos then data.elements[i].options.pos = 1 end 
			data.elements[i].value = data.elements[i].options[1]
		end 
	end 
	data._index     = #NB_Pause_Menu.focus;
	data._namespace = namespace;
	data._name      = name;
	for i=1,#data.elements,1 do 
		data.elements[i]._namespace = namespace;
		data.elements[i]._name      = name;
	end 
	NB_Pause_Menu.SetPropSlotValue("opened",namespace,name,data)
	NB_Pause_Menu.SetPropSlotValue("pos",namespace,name,1)
	for i=1,#data.elements,1 do 
		if data.elements[i].selected  then 
			NB_Pause_Menu.SetPropSlotValue("pos",namespace,name,i)
		else
			data.elements[i].selected = false
		end 
	end 
	NB_Pause_Menu.InsertPropSlot("focus",{namespace=namespace,name=name})
	NB_Pause_Menu.Update();
	local menudata = data 
	local Created = false 
	SetFrontendActive(false);
	Wait(10)
	StartPauseMenu(PauseMenu.versionid.FE_MENU_VERSION_MP_CHARACTER_CREATION)
	Wait(10)
	SetCurrentColumn(-1)
	if menudata.style and menudata.style == 0 then 
		SetDataSlotEmpty(0);
		SetColumnTitle(0,menudata.title,menudata.description or "","");
		for i=1,#menudata.elements do 
			local item = menudata.elements[i]
			local data_idx = i-1
			if i == #menudata.elements then 
				if item.type == 'footer' then 
				SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, " " , 2, 1, Created, -1, -1, 0 , 0);
				else 
				SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, item.type == 'slider' and item.value or "" , item.type == 'slider' and 0 or 1, 4, Created, -1, -1, 0 , 0);
				end 
			else 
				SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, item.type == 'slider' and item.value or "" , item.type == 'slider' and 0 or 1, 4, Created, -1, -1, 0 , 0);
			end 
		end 
		DisplayDataSlot(0);
		SetColumnFocus(0, 1, 1);
		SetColumnCanJump(0, 1);
		ShowColumn(0,true);
	end 
	NB.Threads.CreateLoopOnce("Menu",333,function(Break)
		if #NB_Pause_Menu.focus<=0  then Break() end 
		if N_0x2e22fefa0100275e() then 
			local pos = GetPos()
			if lastpos == nil or lastpos ~= pos then 
				if pos then 
					lastpos = pos
					NB_Pause_Menu.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos_,itemdata)
						if pos <= #menu.elements then 
							NB_Pause_Menu.SetPropSlotValue("pos",namespace,name,pos)
							for i=1,#menu.elements,1 do
								if(i == NB_Pause_Menu.pos[namespace][name]) then 
									menu.elements[i].selected = true
								else
									menu.elements[i].selected = false
								end 
							end 
							NB_Pause_Menu.change(namespace, name, menu.elements[pos])
							NB_Pause_Menu.Update();
						end 
					end)
				end 
			end 
		end  
	end)
end 
NB_Pause_Menu.Close = function(namespace, name)
	for  i=1,#NB_Pause_Menu.focus, 1 do 
		if NB_Pause_Menu.focus[i].namespace == namespace and  NB_Pause_Menu.focus[i].name == name then 
			table.remove(NB_Pause_Menu.focus,i)
			NB_Pause_Menu.ClearPropSlotValue('opened',namespace,name)
			break;
		end 
	end 
	NB_Pause_Menu.Update();
	SetFrontendActive(false);
end 
NB_Pause_Menu.GetCurrentFocus = function()
	return NB_Pause_Menu.focus[#NB_Pause_Menu.focus];
end 
NB_Pause_Menu.GetCurrentFocusData = function(cb)
	local currentFocus = NB_Pause_Menu.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menu    = NB_Pause_Menu.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_Pause_Menu.pos[currentFocus.namespace][currentFocus.name];
		local itemdata    = menu.elements[pos];
		if(#menu.elements > 0) then 
			cb(currentFocus.namespace,currentFocus.name,#menu.elements,menu,pos,itemdata)
		else 
			error("menu has no any datas",2)
		end 
	end 
end 
NB_Pause_Menu.Update = function() -- DRAW FUNCTIONS
	local currentFocus             = NB_Pause_Menu.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menuData    = NB_Pause_Menu.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_Pause_Menu.pos[currentFocus.namespace][currentFocus.name];
		if menuData.elements and (#menuData.elements > 0) then 
			for i,v in pairs (menuData.elements) do 
				if i == pos then 
					v.selected = true;
				end 
			end 
			local menudata = menuData
			local Created = true 
			local item = menudata.elements[pos]
			local data_idx = pos-1
			if menudata.style and menudata.style == 0 then 
				if pos == #menudata.elements then 
					if item.type == 'footer' then 
					SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, " " , 2, 1, Created, -1, -1, 0 , 0);
					else 
					SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, item.type == 'slider' and item.value or "" , item.type == 'slider' and 0 or 1, 4, Created, -1, -1, 0 , 0);
					end 
				else 
					SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, item.type == 'slider' and item.value or "" , item.type == 'slider' and 0 or 1, 4, Created, -1, -1, 0 , 0);
				end 
			end 
		end 
	end 
end 
NB_Pause_Menu.submit = function(namespace, name, data_)
	local data = {
		_namespace= namespace,
		_name     = name,
		current   = data_,
		elements  = NB_Pause_Menu.opened[namespace][name].elements
	}
	local menu = NB.MenuFramework.GetOpened(MenuType, data._namespace, data._name)
	if menu.submit ~= nil then
		menu.submit(data, menu)
	end
end 
NB_Pause_Menu.cancel = function(namespace, name)
	local data = {_namespace= namespace,_name= name}
	local menu = NB.MenuFramework.GetOpened(MenuType, data._namespace, data._name)
	if menu.cancel ~= nil then
		menu.cancel(data, menu)
	end
end 
NB_Pause_Menu.change = function(namespace, name, data_)
	local data = {_namespace= namespace,_name= name,current= data_,elements= NB_Pause_Menu.opened[namespace][name].elements}
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