if IsClient() then

com.menu = {Client={},Server={},Shared={}}
com.menu.ESXMenuFramework = {}
com.menu.type = {}
NBMenu = {}
com.menu.ESXMenuFramework = NBMenu
NBMenu.ClearProp = function(...) return com.lua.utils.Table.ClearTableSomething(NBMenu,...) end
NBMenu.SetProp = function(...) return com.lua.utils.Table.SetTableSomething(NBMenu,...) end
NBMenu.IsPropExist = function(...) return com.lua.utils.Table.IsTableSomthingExist(NBMenu,...) end 
NBMenu.GetProp = function(...) return com.lua.utils.Table.GetTableSomthing(NBMenu,...) end  
NBMenu.InsertPropSlot = function(...) return com.lua.utils.Table.InsertTableSomethingTable(NBMenu,...) end
NBMenu.RemovePropSlotIndex = function(...) return com.lua.utils.Table.RemoveTableSomethingTable(NBMenu,...) end
NBMenu.NextIndex = 1
NBMenu._TEMP_ = {METHODS={}}
NBMenu.CBS = {}
NBMenu.RegisteredInput = {}
NBMenu.SetCurrentSlot = function(handle,pos) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	NBMenu.SetProp("CurrentSelection",handle,pos) 
	local buttons = NBMenu.GetProp("Handles",handle,"menu","metadata","buttons")
	for i,v in pairs(buttons) do 
		if i~=pos then 
			v.selected = false 
		else 
			v.selected = true 
		end 
	end 
end 

NBMenu.GetCurrentSlot = function(handle) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	return NBMenu.GetProp("CurrentSelection",handle) 
end 

NBMenu.SetItemProp = function(handle,itemindex,propname,propvalue)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	NBMenu.SetProp("Handles",handle,"menu","metadata","buttons",itemindex,propname,propvalue)
end 

NBMenu.GetItemProp = function(handle,itemindex,propname,propvalue)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	NBMenu.GetProp("Handles",handle,"menu","metadata","buttons",itemindex,propname)
end 

NBMenu.IsCurrentSlotSlider = function(handle)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local buttons = NBMenu.GetProp("Handles",handle,"menu","metadata","buttons")
	return NBMenu.GetCurrentSlot(handle) and buttons[NBMenu.GetCurrentSlot(handle)].type == 'slider'
end 

NBMenu.SetCurrentItemSlot = function(handle,pos) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	if not NBMenu.IsCurrentSlotSlider(handle) then return print("This item is not a slider object") end 
	local item = NBMenu.GetProp("Handles",handle,"menu","metadata","buttons")[NBMenu.GetCurrentSlot(handle)]
	if pos > #item.options then 
		pos = 1
	end 
	if pos <= 0 then 
		pos = #item.options
	end 
	--NBMenu.SetProp("Handles",handle,"menu","metadata","buttonpos",NBMenu.GetCurrentSlot(handle),pos)
	NBMenu.SetProp("ItemSubjectSelection",handle,NBMenu.GetCurrentSlot(handle),"pos",pos) 
	NBMenu.OnRenderUpdate(handle)
end 

NBMenu.GetCurrentItemSlot = function(handle) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	if not NBMenu.IsCurrentSlotSlider(handle) then return print("This item is not a slider object") end  
	local item = NBMenu.GetProp("Handles",handle,"menu","metadata","buttons")[NBMenu.GetCurrentSlot(handle)]
	if NBMenu.GetProp("ItemSubjectSelection",handle,NBMenu.GetCurrentSlot(handle),"pos") == nil then 
		NBMenu.SetCurrentItemSlot(handle,1)
	end 
	return NBMenu.GetProp("ItemSubjectSelection",handle,NBMenu.GetCurrentSlot(handle),"pos") 
end 

NBMenu.GetItemSlotPos = function(handle,itemindex)
	return NBMenu.GetProp("ItemSubjectSelection",handle,itemindex,"pos") --NBMenu.GetProp("Handles",handle,"menu","metadata","buttonpos",itemindex)
end 

NBMenu.TriggerMenuCallback = function(handle,cbtype) -- "Submit","Cancel","Change","Close"
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	local selecteditem = menu.metadata.buttons[NBMenu.GetCurrentSlot(handle)]
	local callback = menu.callback 
	local convertedData = deepcopy(menu.metadata.buttons) --editing convertedData will be effected the menu.metadata.buttons if not deepcopy
	if not convertedData.current then convertedData.current = {} end 
	if NBMenu.IsCurrentSlotSlider(handle) then 
		convertedData.current = selecteditem.options[NBMenu.GetCurrentItemSlot(handle)]
		convertedData.current.value = NBMenu.GetCurrentItemSlot(handle) or 1
	else 
		convertedData.current = selecteditem
		if selecteditem.value == nil then convertedData.current.value = selecteditem.label end 
	end 
	convertedData.menuHandle = handle
	convertedData.index = NBMenu.GetCurrentSlot(handle)
	switch(cbtype)(
		case("Submit")(function()
			cb = callback.onSubmit
		end),
		case("Cancel")(function()
			cb = callback.onCancel
		end),
		case("Change")(function()
			cb = callback.onChange
		end),
		case("Close")(function()
			cb = callback.onClose
		end),
		default(function()
			cb = callback.onSubmit
		end)
	)
	if cb then cb(convertedData) end 
end 

NBMenu.SetMenuCallbacks = function(handle,callbacks)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	menu.callback = {
		onSubmit = callbacks[1],
		onCancel = callbacks[2],
		onChange = callbacks[3],
		onClose = callbacks[4]
	}
end 
NBMenu.UpdateMenuCallbacks = NBMenu.SetMenuCallbacks
NBMenu.SetMenuHeader = function(handle,title,description)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	menu.metadata.title = title
	menu.metadata.description = description
	NBMenu.OnRenderUpdate(handle)
end 
NBMenu.UpdateMenuHeader = NBMenu.SetMenuHeader
NBMenu.SetMenuButtons = function(handle,buttons)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	menu.metadata.buttons = buttons
	for i,v in pairs(menu.metadata.buttons) do 
		--NBMenu.SetProp("Handles",handle,"menu","metadata","buttonpos",i,1)
		NBMenu.SetProp("ItemSubjectSelection",handle,i,"pos",1)
		v.selected = false 
	end 
	NBMenu.OnRenderUpdate(handle)
end 
NBMenu.UpdateMenuButtons = NBMenu.SetMenuButtons
NBMenu.RequestMenu = function(title,description,menutype,name)
	local r = NBMenu.NextIndex
	if not (NBMenu.IsPropExist("Menus",menutype,name)) then 
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu","menutype",menutype)
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu","name",name)
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu",'metadata',{title=title,description=description})
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu",'callback',{})
		NBMenu.SetProp("Menus",menutype,name,NBMenu.NextIndex)
		
		NBMenu.NextIndex = NBMenu.NextIndex + 1
	else 
		return NBMenu.GetProp("Menus",menutype,name)
	end 
	return r
end 
	
NBMenu.SetMenuAsNoLongerNeeded = function(handle)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	local name = menu.name 
	local menutype = menu.menutype
	
	NBMenu.ClearProp("Handles",handle,"menu","menutype")
	NBMenu.ClearProp("Handles",handle,"menu","name")
	--NBMenu.ClearProp("Handles",handle,"menu","metadata","buttonpos")
	NBMenu.ClearProp("Handles",handle,"menu","metadata","buttons")
	NBMenu.ClearProp("Handles",handle,"menu",'metadata')
	NBMenu.ClearProp("Handles",handle,"menu",'callback')
	NBMenu.ClearProp("Handles",handle,"menu",'opened')
	NBMenu.ClearProp("Handles",handle,"menu")
	NBMenu.ClearProp("Handles",handle)
	NBMenu.ClearProp("Menus",menutype,name)
	NBMenu.ClearProp("AcceptedInput",menutype,name)
end 


NBMenu.AddButton = function(label,params2,description,rtext)
	if type(params2) == 'table'then 
		local endparams2 = {}
		for i,v in pairs(params2) do 
			if not endparams2[i] then endparams2[i] = {} end 
			if params2[i][1]  then endparams2[i].label = params2[i][1]  end 
			if params2[i][2]  then endparams2[i].description = params2[i][2] end 
		end 
		return {type="slider",label=label,options=endparams2}
	else 
		local value = params2
		return {type="default",label=label,value=value,description=description,rtext=rtext}
	end 
end
NBMenu.AddSlider = NBMenu.AddButton
NBMenu.AddElements = function(elements)
	local tbl = {}
	for i,v in pairs(elements) do
		if v.type == nil then 
			v.type = 'default'
		end 
		if v.options then 
			if v.options[1] then 
				for k,c in pairs(v.options) do 
					v.options[k] = {label = v.options[k]}
				end 
			end 
		end 
		table.insert(tbl,v)
	end
	
	return table.unpack(tbl)
end 
--shadows



NBMenu.HasMenuLoaded = function(handle) 
	local handle = handle
	if not handle then return false end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	if menu == nil then return false end 
	local name = menu.name 
	if name == nil then return false end 
	local menutype = menu.menutype 
	if menutype == nil then return false end 
	
	--print(NBMenu.IsPropExist("Menus",menutype,name),NBMenu.GetProp("Menus",menutype,name),NBMenu.GetProp("Menus",menutype,name),handle , NBMenu.NextIndex)
	if NBMenu.IsPropExist("Menus",menutype,name) and handle == NBMenu.GetProp("Menus",menutype,name) then 
		return true 
	else 
		return false 
	end 
end 

NBMenu.OnRenderUpdate = function(handle,cb)
	if cb then 
	if not NBMenu.CBS[handle] then NBMenu.CBS[handle] = {isAgain=false,callback=cb} end 
	end 
	local handle = handle
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	local name = menu.name 
	local menutype = menu.menutype 
	local currentRendering = {
		title = menu.metadata.title,
		description = menu.metadata.description,
		slots = {}
	}
	if menu and menu.metadata and menu.metadata.buttons then 
		for i,v in pairs(menu.metadata.buttons) do 
			
			if  NBMenu.IsCurrentSlotSlider(handle) and NBMenu.GetCurrentSlot(handle) == i then 
			table.insert(currentRendering.slots,{raw=v,type = v.type or 'default',ltext = v.label or '',rtext = (v.type == 'slider' and menu.metadata.buttons[NBMenu.GetCurrentSlot(handle)].options[NBMenu.GetCurrentItemSlot(handle)].label or v.rtext) or '',description = v.description or ''})
			else 
			table.insert(currentRendering.slots,{raw=v,type = v.type or 'default',ltext = v.label or '',rtext = (v.type == 'slider' and menu.metadata.buttons[i].options[NBMenu.GetItemSlotPos(handle,i)].label or v.rtext) or '',description = v.description or ''})
			end 
		end --type,ltext,rtext,description
		if NBMenu.CBS[handle] then 
			NBMenu.CBS[handle].callback(currentRendering,NBMenu.CBS[handle].isAgain)
			NBMenu.CBS[handle].isAgain = true 
		end 
	end 
end 
NBMenu.RegisterRenderUpdate = NBMenu.OnRenderUpdate

end 