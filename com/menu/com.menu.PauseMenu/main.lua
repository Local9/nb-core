if IsClient() then 
local NB_MENU_PAUSE_MENU = {focus={}}
com.menu.type['PauseMenu'] = NB_MENU_PAUSE_MENU
NB.Menu.AcceptedInput["PauseMenu"] = {}
NB_MENU_PAUSE_MENU.ClearPropSlotValue = function(...) return com.lua.utils.Table.ClearTableSomething(NB_MENU_PAUSE_MENU,...) end
NB_MENU_PAUSE_MENU.SetPropSlotValue = function(...) return com.lua.utils.Table.SetTableSomething(NB_MENU_PAUSE_MENU,...) end
NB_MENU_PAUSE_MENU.IsPropSlotValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NB_MENU_PAUSE_MENU,...) end 
NB_MENU_PAUSE_MENU.GetPropSlotValue = function(...) return com.lua.utils.Table.GetTableSomthing(NB_MENU_PAUSE_MENU,...) end  
NB_MENU_PAUSE_MENU.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NB_MENU_PAUSE_MENU,...) end
NB_MENU_PAUSE_MENU.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NB_MENU_PAUSE_MENU,...) end
local MenuType = 'PauseMenu'
local openMenu = function(namespace, name, data)
	NB_MENU_PAUSE_MENU.Open(namespace, name, data);
end
local closeMenu = function(namespace, name)
	NB_MENU_PAUSE_MENU.Close(namespace, name);
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


NB.Menu.RegisterType(MenuType, openMenu, closeMenu)
NB.Menu.AcceptedInput["PauseMenu"].input = function(input)
	
	NB_MENU_PAUSE_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
		switch (input) (
			case ("MENU_SELECT","MENU_ENTER") (
				function()
					--PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_PAUSE_MENU_SOUNDSET", true);
					NB_MENU_PAUSE_MENU.submit(namespace, name, itemdata);
				end
			),
			case ("MENU_BACK") (
				function()
					--PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_PAUSE_MENU_SOUNDSET", true);
					NB_MENU_PAUSE_MENU.cancel(namespace, name);
				end
			),
			case ("MENU_CANCEL") (
				function()
					--PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_PAUSE_MENU_SOUNDSET", true);
					NB_MENU_PAUSE_MENU.cancel(namespace, name);
				end
			),
			case ("MENU_LEFT") (
				function()
					--PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_PAUSE_MENU_SOUNDSET", true);
					if itemdata and itemdata.type and itemdata.type == "slider" then 
						
						local length = itemdata.options and #itemdata.options or 0 
						itemdata.options.pos = itemdata.options.pos + 1
						local pos = itemdata.options.pos
						local nextpos = ((pos)%length)+1
						itemdata.value = itemdata.options[nextpos];
						itemdata.options.pos = nextpos
						
						NB_MENU_PAUSE_MENU.change(namespace, name, itemdata)
						NB_MENU_PAUSE_MENU.Update();
					end
				end
			),
			case ("MENU_RIGHT") (
				function()
					--PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_PAUSE_MENU_SOUNDSET", true);
					if itemdata and itemdata.type and itemdata.type == "slider" then 
						
						local length = itemdata.options and #itemdata.options or 0 
						local pos = itemdata.options.pos
						local nextpos = ((pos)%length)+1
						itemdata.value = itemdata.options[nextpos];
						itemdata.options.pos = nextpos
						NB_MENU_PAUSE_MENU.change(namespace, name, itemdata)
						NB_MENU_PAUSE_MENU.Update();
					end
				end
			),
			--[=[
			case ("MENU_UP") (
				function()
					--PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_PAUSE_MENU_SOUNDSET", true);
					local pos = NB_MENU_PAUSE_MENU.GetPropSlotValue("pos",namespace,name)
					local nextpos = ((pos)%elementslength)+1
					NB_MENU_PAUSE_MENU.SetPropSlotValue("pos",namespace,name,nextpos)
					for i=1,#menu.elements,1 do
						if(i == NB_MENU_PAUSE_MENU.pos[namespace][name]) then 
							menu.elements[i].selected = true
						else
							menu.elements[i].selected = false
						end 
					end 
					NB_MENU_PAUSE_MENU.change(namespace, name, itemdata)
					NB_MENU_PAUSE_MENU.Update();
				end
			),
			case ("MENU_DOWN") (
				function()
					--PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_PAUSE_MENU_SOUNDSET", true);
					local pos = NB_MENU_PAUSE_MENU.GetPropSlotValue("pos",namespace,name)
					local nextpos = ((pos)%elementslength)+1
					NB_MENU_PAUSE_MENU.SetPropSlotValue("pos",namespace,name,nextpos)
					for i=1,#menu.elements,1 do
						if(i == NB_MENU_PAUSE_MENU.pos[namespace][name]) then 
							menu.elements[i].selected = true
						else
							menu.elements[i].selected = false
						end 
					end 
					NB_MENU_PAUSE_MENU.change(namespace, name, itemdata)
					NB_MENU_PAUSE_MENU.Update();
				end
			),--]=]
			default (
				function()
					--error("Menu",2)
				end 
			)
		)
	end)
end 


NB_MENU_PAUSE_MENU.Open = function(namespace,name,data)
	
	if NB_MENU_PAUSE_MENU.IsPropSlotValueExist("opened",namespace,name) then 
		NB_MENU_PAUSE_MENU.Close(namespace, name);
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
	data._index     = #NB_MENU_PAUSE_MENU.focus;
	data._namespace = namespace;
	data._name      = name;
	for i=1,#data.elements,1 do 
		data.elements[i]._namespace = namespace;
		data.elements[i]._name      = name;
	end 
	NB_MENU_PAUSE_MENU.SetPropSlotValue("opened",namespace,name,data)
	NB_MENU_PAUSE_MENU.SetPropSlotValue("pos",namespace,name,1)
	for i=1,#data.elements,1 do 
		if data.elements[i].selected  then 
			NB_MENU_PAUSE_MENU.SetPropSlotValue("pos",namespace,name,i)
		else
			data.elements[i].selected = false
		end 
	end 
	NB_MENU_PAUSE_MENU.InsertPropSlot("focus",{namespace=namespace,name=name})
	NB_MENU_PAUSE_MENU.Update();
	
	TriggerEvent("NB:MenuOpen",data)
	NB.Threads.CreateLoopOnce("Menu",333,function(Break)
		if #NB_MENU_PAUSE_MENU.focus<=0  then Break() end 
		if N_0x2e22fefa0100275e() then 
			local pos = GetPos()
			if lastpos == nil or lastpos ~= pos then 
				if pos then 
					lastpos = pos
					NB_MENU_PAUSE_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos_,itemdata)
						if pos <= #menu.elements then 
							NB_MENU_PAUSE_MENU.SetPropSlotValue("pos",namespace,name,pos)
							
							for i=1,#menu.elements,1 do
								if(i == NB_MENU_PAUSE_MENU.pos[namespace][name]) then 
									menu.elements[i].selected = true
								else
									menu.elements[i].selected = false
								end 
							end 
							NB_MENU_PAUSE_MENU.change(namespace, name, menu.elements[pos])
							NB_MENU_PAUSE_MENU.Update();
						
						end 
					end)
				end 
			end 
		end  
	end)
end 
NB_MENU_PAUSE_MENU.Close = function(namespace, name)
	for  i=1,#NB_MENU_PAUSE_MENU.focus, 1 do 
		if NB_MENU_PAUSE_MENU.focus[i].namespace == namespace and  NB_MENU_PAUSE_MENU.focus[i].name == name then 
			table.remove(NB_MENU_PAUSE_MENU.focus,i)
			NB_MENU_PAUSE_MENU.ClearPropSlotValue('opened',namespace,name)
			break;
		end 
	end 
	NB_MENU_PAUSE_MENU.Update();
	SetFrontendActive(false);
end 
NB_MENU_PAUSE_MENU.GetCurrentFocus = function()
	return NB_MENU_PAUSE_MENU.focus[#NB_MENU_PAUSE_MENU.focus];
end 
NB_MENU_PAUSE_MENU.GetCurrentFocusData = function(cb)
	local currentFocus = NB_MENU_PAUSE_MENU.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menu    = NB_MENU_PAUSE_MENU.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_MENU_PAUSE_MENU.pos[currentFocus.namespace][currentFocus.name];
		local itemdata    = menu.elements[pos];
		if(#menu.elements > 0) then 
			
			
			cb(currentFocus.namespace,currentFocus.name,#menu.elements,menu,pos,itemdata)
		else 
			error("menu has no any datas",2)
		end 
	end 
end 
NB_MENU_PAUSE_MENU.Update = function() -- DRAW FUNCTIONS
	local currentFocus             = NB_MENU_PAUSE_MENU.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menuData    = NB_MENU_PAUSE_MENU.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_MENU_PAUSE_MENU.pos[currentFocus.namespace][currentFocus.name];
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
NB_MENU_PAUSE_MENU.submit = function(namespace, name, data_)
	local data = {
		_namespace= namespace,
		_name     = name,
		current   = data_,
		elements  = NB_MENU_PAUSE_MENU.opened[namespace][name].elements
	}
	local menu = NB.Menu.GetOpened(MenuType, data._namespace, data._name)
	if menu.submit ~= nil then
		menu.submit(data, menu)
	end
end 
NB_MENU_PAUSE_MENU.cancel = function(namespace, name)
	local data = {_namespace= namespace,_name= name}
	local menu = NB.Menu.GetOpened(MenuType, data._namespace, data._name)
	if menu.cancel ~= nil then
		menu.cancel(data, menu)
	end
end 
NB_MENU_PAUSE_MENU.change = function(namespace, name, data_)
	local data = {_namespace= namespace,_name= name,current= data_,elements= NB_MENU_PAUSE_MENU.opened[namespace][name].elements}
	local menu = NB.Menu.GetOpened(MenuType, data._namespace, data._name)
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