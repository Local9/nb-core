if IsClient() then
	com.menu = {
		_TEMP_ = {NBMenu={}}
	}
	com.menu.ESXMenu = ESX.UI.Menu
	local convertButtons = function(buttons, namespace, name)
		for i,v in pairs(buttons) do 
			v._namespace = namespace 
			v._name = name 
			if not v.description then v.description = '' end 
			if not v.righttext then v.righttext = '' end 
			if not v.label then error("elements = {{label='apple'},{label='banana'}}",2) end 
			if not v.value then v.value = v.label end 
			if v.setter then v.getter = {};v.getter.value = 0 end
			if not v.type then v.type = 'default' end 
			if v.type == 'slider' then 
				local options = v.options 
				local haskey = not (type(options[1]) == 'string')
				if haskey then 
					for k,c in pairs(options) do 
						if not c.label then error("options = {{label='apple'},{label='banana'}} or {'apple','banana','orange'}",2) end 
						if not c.description then c.description = '' end 
						if not c.value then c.value = c.label end 
						c.selected = false
					end 
				else 
					local tbl = options 
					for i=1,#options do 
						options[i] = {label=tbl[i],description='',value=tbl[i],selected = false}
					end 
				end 
				options[1].selected = true
			end 
			v.selected = false
		end 
		buttons[1].selected = true
		return buttons
	end 
	com.menu.ESXMenu.ThrowAway = function(type, namespace, name) --基本不會用到 除非這麼有責任心
        for i=1, #com.menu.ESXMenu.Opened, 1 do
            if com.menu.ESXMenu.Opened[i] then
                if com.menu.ESXMenu.Opened[i].type == type and com.menu.ESXMenu.Opened[i].namespace == namespace and com.menu.ESXMenu.Opened[i].name == name then
                    com.menu.ESXMenu.Opened[i] = nil
                end
            end
        end
    end
	com.menu.ESXMenu.DeepOpen = function(type, namespace, name)
		local menu = com.menu.ESXMenu.GetOpened(type,namespace, name)
		menu.data.elements = convertButtons(menu.data.elements,namespace,name)
		menu.select = function(posVertical,posHorizontal)
			if posVertical <= 0 then 
				posVertical = (posVertical-1)%#menu.data.elements+1
			elseif posVertical > #menu.data.elements then 
				posVertical = posVertical%#menu.data.elements
			end 
			for i,v in pairs(menu.data.elements) do 
				if i == posVertical then 
					v.selected = true 
					if posHorizontal and v.type == 'slider' then 
						if posHorizontal <= 0 then 
							posHorizontal = (posHorizontal-1)%#v.options+1
						elseif posHorizontal > #v.options then 
							posHorizontal = posHorizontal%#v.options
						end 
						for k,c in pairs(v.options) do 
							if k == posHorizontal then 
								c.selected = true
							else 
								c.selected = false
							end 
						end 
					end 
				else 
					v.selected = false
				end 
				
			end 
			return {switch = function(y)
				if y then 
					menu.select(posVertical,y)
				end 
			end}
		end 
		menu.getcurrentselection = function()
			local currentselection 
			for i,v in pairs(menu.data.elements) do 
				if v.selected then 
					currentselection = i
					break
				end 
			end 
			return currentselection
		end 
		menu.getcurrentoptionselection = function()
			local currentselection 
			for i,v in pairs(menu.data.elements) do 
				if v.selected and v.type == 'slider' then 
					for k,c in pairs(v.options) do 
						if c.selected then 
							currentselection = k
							break
						end 
					end 
				end 
			end 
			return currentselection
		end 
		menu.switch = function(posHorizontal)
			menu.select(menu.getcurrentselection()).switch(posHorizontal)
		end 
		menu.button = {
			up = function()
				menu.select(menu.getcurrentselection()-1).switch(1)
			end,
			down = function()
				menu.select(menu.getcurrentselection()+1).switch(1)
			end,
			left = function()
				menu.select(menu.getcurrentselection()).switch(menu.getcurrentoptionselection()-1)
			end,
			right = function()
				menu.select(menu.getcurrentselection()).switch(menu.getcurrentoptionselection()+1)
			end
		}
		com.menu.ESXMenu.ThrowAway(type,namespace, name) --關閉大Open,menu依然有結構，不用deepcopy
        return menu
    end
	com.menu._TEMP_.Clear = 		function(...) return com.lua.utils.Table.ClearTableSomething(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.Set = 			function(...) return com.lua.utils.Table.SetTableSomething(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.IsExist = 		function(...) return com.lua.utils.Table.IsTableSomthingExist(com.menu._TEMP_.NBMenu,...) end 
	com.menu._TEMP_.Get = 			function(...) return com.lua.utils.Table.GetTableSomthing(com.menu._TEMP_.NBMenu,...) end  
	com.menu._TEMP_.InsertTable = 	function(...) return com.lua.utils.Table.InsertTableSomethingTable(com.menu._TEMP_.NBMenu,...) end
	com.menu._TEMP_.RemoveTable = 	function(...) return com.lua.utils.Table.RemoveTableSomethingTable(com.menu._TEMP_.NBMenu,...) end
end 