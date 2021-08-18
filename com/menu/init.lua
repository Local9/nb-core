if IsClient() then

com.menu = {Client={},Server={},Shared={}}
com.menu.ESXMenuFramework = deepcopy(ESX.UI.Menu)
com.menu.type = {}
NBMenu = {focus={}}
NBMenu.CBS = {}
local MenuType = 'PauseMenu'
local openMenu = function(namespace, name, menu, isUpdate)
	menu.namespace = namespace
	menu.name = name
	NBMenu.open(namespace, name, menu, isUpdate);
	NB.RegisterKeyEvent('Menu'..namespace..name,function(input)
		local function GetPos() local a,b,c = GetPauseMenuSelectionData() return c ~= -1 and c+1 or 1 end 
			switch(input)(
				case("MENU_LEFT")(function()
						NBMenu.SetCurrentSlot(namespace, name,GetPos())
						if NBMenu.IsCurrentSlotSlider(namespace, name) then
							NBMenu.SetCurrentItemSlot(namespace, name,NBMenu.GetCurrentItemSlot(namespace, name)-1)
							
							
						end 
						NBMenu.OnRenderUpdate(namespace,name)
				end),
				case("MENU_RIGHT")(function()
						NBMenu.SetCurrentSlot(namespace, name,GetPos())
						if NBMenu.IsCurrentSlotSlider(namespace, name) then
							NBMenu.SetCurrentItemSlot(namespace, name,NBMenu.GetCurrentItemSlot(namespace, name)+1)
							
						end 
						NBMenu.OnRenderUpdate(namespace,name)
				end),
				case("MENU_UP")(function()
						NBMenu.SetCurrentSlot(namespace, name,GetPos())
						if NBMenu.IsCurrentSlotSlider(namespace, name) then
						
						end 
						NBMenu.OnRenderUpdate(namespace,name)
				end),
				case("MENU_DOWN")(function()
						NBMenu.SetCurrentSlot(namespace, name,GetPos())
						if NBMenu.IsCurrentSlotSlider(namespace, name) then

						end 
						NBMenu.OnRenderUpdate(namespace,name)
				end),
				case("MENU_ENTER","MENU_SELECT")(function()
						NBMenu.SetCurrentSlot(namespace, name,GetPos())
						NBMenu.OnRenderUpdate(namespace,name)
						
				end),
				case("MENU_BACK")(function()
						NBMenu.SetCurrentSlot(namespace, name,GetPos())
						NBMenu.OnRenderUpdate(namespace,name)
						
				end),
				case("MENU_ESCAPE")(function()
						NBMenu.SetCurrentSlot(namespace, name,GetPos())
						NBMenu.OnRenderUpdate(namespace,name)
				end),
				default(function()
					
				end)
			)
	end )
	NBMenu.RegisterRenderUpdate(namespace, name,function(menuRenderDatas,isUpdate)
		local render = menuRenderDatas
		if render then 
			--[=[
			print(render.title)
			print(render.description)
			for i=1,#render.elements do 
				print(render.elements[i].type)
				print(render.elements[i].ltext)
				print(render.elements[i].rtext)
				print(render.elements[i].description)
			end 
			--]=]
			local columnid = 1
			if not isUpdate then 
				PauseMenu.SetDataSlotEmpty(columnid);
				PauseMenu.SetColumnTitle(columnid,render.title,render.description or "","");
			end 
			local elements = render.elements
			local data_idx = 0
			
			for i=1,#elements do 
				local item = elements[i]
				if i == #elements then 
					if item.type == 'footer' then 
						PauseMenu.SetOrUpdateNormalDataSlot(columnid, data_idx, PauseMenu.menuid.CREATION_HERITAGE, data_idx, item.ltext, " " , 2, 1, isUpdate);
					else 
						PauseMenu.SetOrUpdateNormalDataSlot(columnid, data_idx, PauseMenu.menuid.CREATION_HERITAGE, data_idx, item.ltext, item.rtext , item.type == 'slider' and 0 or 1, 4, isUpdate); 
					end 
				else 
					PauseMenu.SetOrUpdateNormalDataSlot(columnid, data_idx, PauseMenu.menuid.CREATION_HERITAGE, data_idx, item.ltext, item.rtext , item.type == 'slider' and 0 or 1, 4, isUpdate);
				end 
				data_idx = data_idx + 1
			end 
			if not isUpdate then 
				PauseMenu.DisplayDataSlot(columnid);
				PauseMenu.SetColumnFocus(columnid, 1, 1);
				PauseMenu.SetColumnCanJump(columnid, 1);
				PauseMenu.SetCurrentColumn(columnid)
				if #elements>7 then 
					if columnid == 1 or columnid == 6 then 
						PauseMenu.InitColumnScroll(columnid, 1, 1, 1, 0, 0)
					end 
				end 
			end 
			
		end 
	end)
	NBMenu.OnRenderUpdate(namespace,name)
end
local closeMenu = function(namespace, name)
	NBMenu.close(namespace, name);
end

com.menu.ESXMenuFramework.RegisterType(MenuType, openMenu, closeMenu)


NBMenu.ClearProp = function(...) return com.lua.utils.Table.ClearTableSomething(NBMenu,...) end
NBMenu.SetProp = function(...) return com.lua.utils.Table.SetTableSomething(NBMenu,...) end
NBMenu.IsPropExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NBMenu,...) end 
NBMenu.GetProp = function(...) return com.lua.utils.Table.GetTableSomthing(NBMenu,...) end  
NBMenu.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NBMenu,...) end
NBMenu.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NBMenu,...) end

NBMenu.SetCurrentSlot = function(namespace,name,pos) 
	NBMenu.SetProp("CurrentSelection",namespace,name,pos) 
	local menu = com.menu.ESXMenuFramework.GetOpened(MenuType, namespace, name)

	local buttons = menu.data.elements
	for i,v in pairs(buttons) do 
		if i~=pos then 
			v.selected = false 
		else 
			v.selected = true 
		end 
	end 
end 
NBMenu.GetCurrentSlot = function(namespace,name) 
	return NBMenu.GetProp("CurrentSelection",namespace,name) 
end 
NBMenu.IsCurrentSlotSlider = function(namespace,name)
	local menu = com.menu.ESXMenuFramework.GetOpened(MenuType, namespace, name)
	local buttons = menu.data.elements
	return NBMenu.GetCurrentSlot(namespace,name) and buttons[NBMenu.GetCurrentSlot(namespace,name)].type == 'slider'
end 

NBMenu.SetCurrentItemSlot = function(namespace,name,pos) 
	local menu = com.menu.ESXMenuFramework.GetOpened(MenuType, namespace, name)
	local buttons = menu.data.elements
	local item = buttons[NBMenu.GetCurrentSlot(namespace,name)]
	if pos > #item.options then 
		pos = 1
	end 
	if pos <= 0 then 
		pos = #item.options
	end 
	NBMenu.SetProp("ItemSubjectSelection",namespace,name,NBMenu.GetCurrentSlot(namespace,name),"pos",pos) 
	NBMenu.OnRenderUpdate(namespace,name)
end 

NBMenu.GetCurrentItemSlot = function(namespace,name) 
	local menu = com.menu.ESXMenuFramework.GetOpened(MenuType, namespace, name)
	local buttons = menu.data.elements
	local item = buttons[NBMenu.GetCurrentSlot(namespace,name)]
	if NBMenu.GetProp("ItemSubjectSelection",namespace,name,NBMenu.GetCurrentSlot(namespace,name),"pos") == nil then 
		NBMenu.SetCurrentItemSlot(namespace,name,1)
	end 
	return NBMenu.GetProp("ItemSubjectSelection",namespace,name,NBMenu.GetCurrentSlot(namespace,name),"pos") 
end 
NBMenu.SetItemSlotPos = function(namespace,name,itemindex,pos)
	return NBMenu.SetProp("ItemSubjectSelection",namespace,name,itemindex,"pos",pos) 
end 
NBMenu.GetItemSlotPos = function(namespace,name,itemindex)
	return NBMenu.GetProp("ItemSubjectSelection",namespace,name,itemindex,"pos") 
end 

NBMenu.OnRenderUpdate = function(namespace,name,cb)
	if cb then 
		if not NBMenu.CBS[namespace..name] then NBMenu.CBS[namespace..name] = {isAgain=false,callback=cb} end 
	end 
	local menu = com.menu.ESXMenuFramework.GetOpened(MenuType, namespace, name)
	local name = menu.name 
	local namespace = menu.namespace 
	local currentRendering = {
		title = menu.data.title,
		description = menu.data.description or '',
		elements = {}
	}
	if menu and menu.data and menu.data.elements then 
		for i,v in pairs(menu.data.elements) do 
			
			if  NBMenu.IsCurrentSlotSlider(namespace,name) and NBMenu.GetCurrentSlot(namespace,name) == i then 
			table.insert(currentRendering.elements,{raw=v,type = v.type or 'default',ltext = v.label or '',rtext = (v.type == 'slider' and menu.data.elements[NBMenu.GetCurrentSlot(namespace,name)].options[NBMenu.GetCurrentItemSlot(namespace,name)].label or v.rtext) or '',description = v.description or ''})
			else 
			table.insert(currentRendering.elements,{raw=v,type = v.type or 'default',ltext = v.label or '',rtext = (v.type == 'slider' and (menu.data.elements[i].options[NBMenu.GetItemSlotPos(namespace,name,i)] and menu.data.elements[i].options[NBMenu.GetItemSlotPos(namespace,name,i)].label) or v.rtext) or '',description = v.description or ''})
			end 
		end --type,ltext,rtext,description
		if NBMenu.CBS[namespace..name] then 
			NBMenu.CBS[namespace..name].callback(currentRendering,NBMenu.CBS[namespace..name].isAgain)
			NBMenu.CBS[namespace..name].isAgain = true 
		end 
	end 
	
end 
NBMenu.RegisterRenderUpdate = NBMenu.OnRenderUpdate

NBMenu.UnRegisterRenderUpdate = function(namespace,name)
	if NBMenu.CBS[namespace..name] then NBMenu.CBS[namespace..name] = nil end 
end 

com.menu.type['PauseMenu'] = NBMenu


		
NBMenu.open = function(namespace,name,data, isUpdate)
	if NBMenu.IsPropExist("opened",namespace,name) then 
		NBMenu.close(namespace, name);
	end 


	for i=1,#data.elements,1 do 
		if data.elements[i].type == nil then 
			data.elements[i].type = 'default';
		elseif data.elements[i].type == 'slider' then 
			if not data.elements[i].options then data.elements[i].options = {} end 
			--if not data.elements[i].options.pos then data.elements[i].options.pos = 1 end 
			NBMenu.SetItemSlotPos(namespace,name,i,1)
			data.elements[i].value = data.elements[i].options[1]
		end 
	end 
	NBMenu.InsertPropSlot("focus",{namespace=namespace,name=name})
	data._index     = #NBMenu.focus;
	data._namespace = namespace;
	data._name      = name;
	data._style	    = data.style or "default"
	for i=1,#data.elements,1 do 
		data.elements[i]._namespace = namespace;
		data.elements[i]._name      = name;
	end 

	if not isUpdate then 
		NBMenu.SetProp("opened",namespace,name,data)
		for i=1,#data.elements,1 do 
			if data.elements[i].selected  then 
				NBMenu.SetProp("CurrentSelection",namespace,name,i)
			else
				data.elements[i].selected = false
			end 
		end 
	else 
		if #data.elements > 0 then 
			for i=1,#data.elements,1 do 
				data.elements[i].selected = false
			end 
			NBMenu.SetCurrentSlot(namespace,name,1)
			data.elements[1].selected = false
		end 
	end 
	
	
	
	
	
end 
NBMenu.close = function(namespace, name)
	print('lclose')
	for  i=1,#NBMenu.focus, 1 do 
		if NBMenu.focus[i].namespace == namespace and  NBMenu.focus[i].name == name then 
			table.remove(NBMenu.focus,i)
			
			if #NBMenu.GetProp("focus") > 0 then 
				NBMenu.SetProp("opened",namespace,name,NBMenu.GetProp("focus")[#NBMenu.GetProp("focus")])
			else 
				NBMenu.ClearProp("opened",namespace,name)
				com.menu.ESXMenuFramework.Close(namespace,name)
			end 
			break;
		end 
	end 
	
end 




end 