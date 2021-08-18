if IsClient() then 

local SetSelection = function(handle,pos) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	NBMenu.SetProp("CurrentSelection",handle,pos) 
end 
local GetSelection = function(handle) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	return NBMenu.GetProp("CurrentSelection",handle) 
end 


--bridge
NBMenu.SetCurrentSlot = SetSelection
NBMenu.GetCurrentSlot = GetSelection

NBMenu.IsCurrentSlotSlider = function(handle)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local buttons = NBMenu.GetProp("Handles",handle,"menu","metadata","buttons")
	return buttons[NBMenu.GetCurrentSlot(handle)].type == 'slider'
end 

local SetItemSelection = function(handle,pos) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	if not NBMenu.IsCurrentSlotSlider(handle) then return print("This item is not a slider object") end 
	local item = NBMenu.GetProp("Handles",handle,"menu","metadata","buttons")[NBMenu.GetCurrentSlot(handle)]
	if pos > #item.options then 
		pos = 1
	end 
	if pos <= 0 then 
		pos = #item.options
	end 
	NBMenu.SetProp("Handles",handle,"menu","metadata","buttonpos",NBMenu.GetCurrentSlot(handle),pos)
	NBMenu.SetProp("CurrentItemSelection",handle,item,"pos",pos) 
	NBMenu.OnRenderUpdate(handle)
end 
local GetItemSelection = function(handle) 
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	if not NBMenu.IsCurrentSlotSlider(handle) then return print("This item is not a slider object") end  
	local item = NBMenu.GetProp("Handles",handle,"menu","metadata","buttons")[NBMenu.GetCurrentSlot(handle)]
	if NBMenu.GetProp("CurrentItemSelection",handle,item,"pos") == nil then 
		SetItemSelection(handle,1)
	end 
	return NBMenu.GetProp("CurrentItemSelection",handle,item,"pos") 
end 
NBMenu.SetCurrentItemSlot = SetItemSelection
NBMenu.GetCurrentItemSlot = GetItemSelection
NBMenu.GetItemSlotPos = function(handle,itemindex)
	return NBMenu.GetProp("Handles",handle,"menu","metadata","buttonpos",itemindex)
end 

NBMenu.ConvertCurrentItemForCallback = function(handle,cbtype) -- "Submit","Cancel","Change","Close"
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	local selecteditem = menu.metadata.buttons[NBMenu.GetCurrentSlot(handle)]
	local callback = menu.callback 
	local convertedData = {current={}}
	if NBMenu.IsCurrentSlotSlider(handle) then 
		convertedData.current = selecteditem.options[GetItemSelection(handle)]
		convertedData.current.value = GetItemSelection(handle) or 1
	else 
		convertedData.current = selecteditem
		if selecteditem.value == nil then convertedData.current.value = selecteditem.label end 
	end 
	convertedData.menuHandle = handle
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


NBMenu.SetMethods = function(handle,methods,returntype)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	switch(NBMenu.GetProp("CurrentMethod"))(
		case ("SET_MENU_HEADER")(function()
			menu.metadata.title = methods[1]
			menu.metadata.description = methods[2]
			menu.metadata.others = methods[3]
			NBMenu.OnRenderUpdate(handle)
		end),
		case ("SET_MENU_BUTTON")(function()
			menu.metadata.buttons = methods
			for i,v in pairs(menu.metadata.buttons) do 
				NBMenu.SetProp("Handles",handle,"menu","metadata","buttonpos",i,1)
			end 
			NBMenu.OnRenderUpdate(handle)
		end),
		case ("SET_MENU_CALLBACK")(function()
			menu.callback = {
				onSubmit = methods[1],
				onCancel = methods[2],
				onChange = methods[3],
				onClose = methods[4]
			}
			NBMenu.OnRenderUpdate(handle)
		end),
		default(function()
			error("Something wrong without BeginMenuMethod?",2)
		end)
	)
	NBMenu.ClearProp("CurrentMethod")
	SetSelection(handle,1)
	if returntype == 0 then return nil end 
	if returntype == 1 then return menu end 
	if returntype == 2 then return menu.metadata end 
	if returntype == 3 then return menu.callback end 
	return nil 
end 
NBMenu.EndMenuMethod = function(x) 
	local result
	if NBMenu.GetProp("CurrentMethod") then 
		result = NBMenu.SetMethods(NBMenu.GetProp("CurrentHandle"),NBMenu._TEMP_.METHODS,x or 0) ; NBMenu._TEMP_.METHODS={} 
	else 
		error("Something wrong without BeginMenuMethod?",2)
	end 
	return result
end 

NBMenu.RequestMenu = function(menutype,name)
	local r = NBMenu.NextIndex
	if not (NBMenu.IsPropExist("Menus",menutype,name)) then 
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu","menutype",menutype)
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu","name",name)
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu",'metadata',{})
		NBMenu.SetProp("Handles",NBMenu.NextIndex,"menu",'callback',{})
		NBMenu.SetProp("Menus",menutype,name,NBMenu.NextIndex)
		
		NBMenu.NextIndex = NBMenu.NextIndex + 1
	else 
		return NBMenu.GetProp("Menus",menutype,name)
	end 
	return r
end 

local start = BeginScaleformMovieMethodOnFrontend
local send = function (...)
    local tb = {...}
    for i=1,#tb do
        if type(tb[i]) == "number" then 
            if math.type(tb[i]) == "integer" then
                    ScaleformMovieMethodAddParamInt(tb[i])
            else
                    ScaleformMovieMethodAddParamFloat(tb[i])
            end
        elseif type(tb[i]) == "string" then ScaleformMovieMethodAddParamTextureNameString(tb[i])
        elseif type(tb[i]) == "boolean" then ScaleformMovieMethodAddParamBool(tb[i])
        end
    end 
	EndScaleformMovieMethod()
end
	
NBMenu.SetMenuAsNoLongerNeeded = function(handle)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	local menu = NBMenu.GetProp("Handles",handle,"menu")
	local name = menu.name 
	local menutype = menu.menutype
	
	NBMenu.ClearProp("Handles",handle,"menu","menutype")
	NBMenu.ClearProp("Handles",handle,"menu","name")
	NBMenu.ClearProp("Handles",handle,"menu","metadata","buttonpos")
	NBMenu.ClearProp("Handles",handle,"menu","metadata","buttons")
	NBMenu.ClearProp("Handles",handle,"menu",'metadata')
	NBMenu.ClearProp("Handles",handle,"menu",'callback')
	NBMenu.ClearProp("Handles",handle,"menu",'opened')
	NBMenu.ClearProp("Handles",handle,"menu")
	NBMenu.ClearProp("Handles",handle)
	NBMenu.ClearProp("Menus",menutype,name)
	NBMenu.ClearProp("AcceptedInput",menutype,name)
end 
 
NBMenu.BeginMenuMethod = function(handle,method)
	if not NBMenu.HasMenuLoaded(handle) then error("No such menu Loaded.",2) end 
	NBMenu.SetProp("CurrentMethod",method)
	NBMenu.SetProp("CurrentHandle",handle)
end

NBMenu.MenuMethodAddParams = function(str)
	if NBMenu.GetProp("CurrentMethod") then 
		table.insert(NBMenu._TEMP_.METHODS,str) 
	else 
		error("Something wrong without BeginMenuMethod?",2)
	end 
end

NBMenu.MenuMethodAddButton = function(label,params2,description,rtext)
	if NBMenu.GetProp("CurrentMethod") then 
		if type(params2) == 'table'then 
			local endparams2 = {}
			for i,v in pairs(params2) do 
				if not endparams2[i] then endparams2[i] = {} end 
				if params2[i][1]  then endparams2[i].label = params2[i][1]  end 
				if params2[i][2]  then endparams2[i].description = params2[i][2] end 
			end 
			table.insert(NBMenu._TEMP_.METHODS,{type="slider",label=label,options=endparams2}) 
		else 
			local value = params2
			table.insert(NBMenu._TEMP_.METHODS,{type="default",label=label,value=value,description=description,rtext=rtext}) 
		end 
	else 
		error("Something wrong without BeginMenuMethod?",2)
	end 
end
NBMenu.MenuMethodAddElements = function(elements)
	if NBMenu.GetProp("CurrentMethod") then 
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
			table.insert(NBMenu._TEMP_.METHODS,v) 
		end 
	else 
		error("Something wrong without BeginMenuMethod?",2)
	end 
end 
--shadows
NBMenu.EndMenuMethodReturn = function() return NBMenu.EndMenuMethod(1) end 
NBMenu.MenuMethodAddCallback = NBMenu.MenuMethodAddParams
NBMenu.MenuMethodAddParamsDatas = NBMenu.MenuMethodAddParams
NBMenu.MenuMethodAddOption = NBMenu.MenuMethodAddButton
NBMenu.EndMenuMethodReturnAny = NBMenu.EndMenuMethodReturn



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
NBMenu.CBS = {}
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
			table.insert(currentRendering.slots,{type = v.type or 'default',ltext = v.label or '',rtext = (v.type == 'slider' and menu.metadata.buttons[NBMenu.GetCurrentSlot(handle)].options[GetItemSelection(handle)].label or v.rtext) or '',description = v.description or ''})
			else 
			table.insert(currentRendering.slots,{type = v.type or 'default',ltext = v.label or '',rtext = (v.type == 'slider' and menu.metadata.buttons[i].options[NBMenu.GetItemSlotPos(handle,i)].label or v.rtext) or '',description = v.description or ''})
			end 
		end --type,ltext,rtext,description
		if NBMenu.CBS[handle] then 
			NBMenu.CBS[handle].callback(currentRendering,NBMenu.CBS[handle].isAgain)
			NBMenu.CBS[handle].isAgain = true 
		end 
	end 
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