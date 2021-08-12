if IsClient() then 
local Menu = {_PROPS_={focus={}}}
local NB_MENU = Menu["_PROPS_"]
com.menu.Default = Menu

NB_MENU.ClearPropSlotValue = function(...) return com.lua.utils.Table.ClearTableSomething(Menu["_PROPS_"],...) end
NB_MENU.SetPropSlotValue = function(...) return com.lua.utils.Table.SetTableSomething(Menu["_PROPS_"],...) end
NB_MENU.IsPropSlotValueExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(Menu["_PROPS_"],...) end 
NB_MENU.GetPropSlotValue = function(...) return com.lua.utils.Table.GetTableSomthing(Menu["_PROPS_"],...) end  
NB_MENU.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(Menu["_PROPS_"],...) end
NB_MENU.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(Menu["_PROPS_"],...) end
local MenuType = 'default'
local openMenu = function(namespace, name, data)
	NB_MENU.Open(namespace, name, data);
end
local closeMenu = function(namespace, name)
	NB_MENU.Close(namespace, name);
end

com.menu.framework.RegisterType(MenuType, openMenu, closeMenu)

NB_MENU.Open = function(namespace,name,data)
	
	if NB_MENU.IsPropSlotValueExist("opened",namespace,name) then 
		NB_MENU.Close(namespace, name);
	end 
	for i=1,#data.elements,1 do 
		if data.elements[i].type == nil then 
			data.elements[i].type = 'default';
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
	NB_MENU.InsertPropSlot("focus",{namespace=namespace,name=name})
	NB_MENU.Update();
end 



NB_MENU.Close = function(namespace, name)
	for  i=1,#NB_MENU.focus, 1 do 
		if NB_MENU.focus[i].namespace == namespace and  NB_MENU.focus[i].name == name then 
			table.remove(NB_MENU.focus,i)
			NB_MENU.ClearPropSlotValue('opened',namespace,name)
			break;
		end 
	end 
	NB_MENU.Update();
end 

NB_MENU.GetCurrentFocus = function()
	return NB_MENU.focus[#NB_MENU.focus];
end 

NB_MENU.GetCurrentFocusData = function(cb)
	local focused = NB_MENU.GetCurrentFocus();
	if focused and #(focused) then
		local menu    = NB_MENU.opened[focused.namespace][focused.name];
		local pos     = NB_MENU.pos[focused.namespace][focused.name];
		local itemdata    = menu.elements[pos];
		if(#menu.elements > 0) then 
			cb(focused.namespace,focused.name,#menu.elements,menu,pos,itemdata)
		end 
	end 
end 



NB_MENU.Update = function() -- DRAW FUNCTIONS
	local currentFocus             = NB_MENU.GetCurrentFocus();
	if currentFocus and #(currentFocus) then
		local menuData    = NB_MENU.opened[currentFocus.namespace][currentFocus.name];
		local pos     = NB_MENU.pos[currentFocus.namespace][currentFocus.name];
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

NB_MENU.submit = function(namespace, name, data)
	TriggerEvent('menu_submit',{
		_namespace= namespace,
		_name     = name,
		current   = data,
		elements  = NB_MENU.opened[namespace][name].elements
	},function(cb) end)
end 

NB_MENU.cancel = function(namespace, name)

	TriggerEvent('menu_cancel',{_namespace= namespace,
		_name     = name},function(cb) end)
end 

NB_MENU.change = function(namespace, name, data)
	TriggerEvent('menu_change',{
		_namespace= namespace,
		_name     = name,
		current   = data,
		elements  = NB_MENU.opened[namespace][name].elements
	},function(cb) end)
end 

OnMenuKeyInput = function(input)
	if NB_MENU.opened then 
		switch (input) (
			case ("MENU_SELECT","MENU_ENTER") (
				function()
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
						NB_MENU.submit(namespace, name, itemdata);
					end)
				end
			),
			case ("MENU_BACK") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
						NB_MENU.cancel(namespace, name);
					end)
				end
			),
			case ("MENU_CANCEL") (
				function()
					PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
						NB_MENU.cancel(namespace, name);
					end)
				end
			),
			case ("MENU_LEFT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
						if itemdata and itemdata.type and itemdata.type == 'slider' then 
							if  itemdata.options ~=nil then 
								if not itemdata.options.pos then itemdata.options.pos = {} end 
								local length = #itemdata.options
								local nextoptionpos = itemdata.options.pos - 1 == 0 and itemdata.options.pos - 2 or itemdata.options.pos - 1
								itemdata.value = itemdata.options[nextoptionpos/#itemdata.options];
								NB_MENU.change(focused.namespace, focused.name, itemdata)
							end 
							NB_MENU.Update();
						end 
					end)
				end
			),
			case ("MENU_RIGHT") (
				function()
					PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
						if itemdata and itemdata.type and itemdata.type == 'slider' then 
							if  itemdata.options ~=nil then 
								if not itemdata.options.pos then itemdata.options.pos = {} end 
								local length = #itemdata.options
								local nextoptionpos = itemdata.options.pos + 1 == 0 and itemdata.options.pos + 2 or itemdata.options.pos + 1
								itemdata.value = itemdata.options[nextoptionpos/#itemdata.options];
								NB_MENU.change(focused.namespace, focused.name, itemdata)
							end 
							NB_MENU.Update();
						end 
					end)
				end
			),
			case ("MENU_UP") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
						local pos = NB_MENU.GetPropSlotValue("pos",namespace,name)
						local nextpos = pos-1 == 0 and pos-2 or pos-1
						NB_MENU.SetPropSlotValue("pos",namespace,name,nextpos%elementslength)
						for i=1,#menu.elements,1 do
							if(i == NB_MENU.pos[namespace][name]) then 
								menu.elements[i].selected = true
							else
								menu.elements[i].selected = false
							end 
						end 
						NB_MENU.change(namespace, name, itemdata)
						NB_MENU.Update();
					end)
				end
			),
			case ("MENU_DOWN") (
				function()
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
					NB_MENU.GetCurrentFocusData(function(namespace,name,elementslength,menu,pos,itemdata)
						local pos = NB_MENU.GetPropSlotValue("pos",namespace,name)
						local nextpos = pos+1 == 0 and pos+2 or pos+1
						NB_MENU.SetPropSlotValue("pos",namespace,name,nextpos%elementslength)
						for i=1,#menu.elements,1 do
							if(i == NB_MENU.pos[namespace][name]) then 
								menu.elements[i].selected = true
							else
								menu.elements[i].selected = false
							end 
						end 
						NB_MENU.change(namespace, name, itemdata)
						NB_MENU.Update();
					end)
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


Citizen.CreateThread(function()
	

	RegisterNetEvent('menu_submit')
	AddEventHandler('menu_submit', function(data, cb)
		--TriggerEvent('localmessage','menu_submit')
		local menu = com.menu.framework.GetOpened(MenuType, data._namespace, data._name)
		
		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end)
	
	RegisterNetEvent('menu_cancel')
	AddEventHandler('menu_cancel', function(data, cb)
		--TriggerEvent('localmessage','menu_cancel')
		local menu = com.menu.framework.GetOpened(MenuType, data._namespace, data._name)
		
		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)


	RegisterNetEvent('menu_change')
	AddEventHandler('menu_change', function(data, cb)
		--TriggerEvent('localmessage','menu_change')
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

		cb('OK')
	end)

end)

end 