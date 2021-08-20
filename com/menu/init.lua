if IsClient() then
	com.menu = {
		_TEMP_ = {NBMenu={}}
	}
	com.menu.Default = {UI={}}
	com.menu.PauseMenu = {UI={}}
	com.menu.ESXMenu = ESX.UI.Menu
	com.menu.minify = function(menu)
		local menu = deepcopy(menu)
		local items = menu.data.elements
		local result = {
			title = menu.data.title,
			description = menu.data.description,
			slots = {}
		}
		local buttons = menu.data.elements
		for i,v in pairs(buttons) do 
			if not result.slots[i] then result.slots[i] = {} end 
			result.slots[i].lefttext = v.label
			result.slots[i].righttext = v.righttext
			result.slots[i].selection = false
			if v.selected then 
				result.slots[i].selected = true 
				if v.description then 
					result.slots[i].description = v.description
				end 
			end 
			if buttons[i].type == 'slider' then 
				local options = v.options 
				for k,c in pairs(options) do 
					if c.selected then 
						result.slots[i].righttext = c.label 
						result.slots[i].selection = true
						if c.description then 
							if not result.slots[i].description then 
							result.slots[i].description = c.description
							end
						end 
						break
					end 
				end 
			end 
		end 
		return result
	end 
	com.menu.convertButtons = function(buttons, namespace, name)
		for i,v in pairs(buttons) do 
			v._namespace = namespace 
			v._name = name 
			
			--if not v.description then v.description = '' end 
			--if not v.righttext then v.righttext = '' end 
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
						--if not c.description then c.description = '' end 
						if not c.value then c.value = c.label end 
						c.selected = false
						c.index = k
						c.parentindex = i
					end 
				else 
					local tbl = options 
					for k=1,#options do 
						options[k] = {label=tbl[k],--[[description='',--]]value=tbl[k],selected = false,index=k,parentindex=i}
					end 
				end 
				options[1].selected = true
			end 
			v.selected = false
			v.index = i 
		end 
		buttons[1].selected = true
		return buttons
	end 
	com.menu.ESXMenu.ThrowAway = function(type, namespace, name) --Close基本不會用到 除非這麼有責任心 Close還會call close 如果想丟掉Open就不用Close了
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
		menu.data.elements = com.menu.convertButtons(menu.data.elements,namespace,name)
		menu.data.elementpos = {}
		for i,v in pairs(menu.data.elements) do
			if v.type == 'slider' then 
				menu.data.elementpos[i] = 1
			end 
		end 
		menu.pos = 1
		menu.select = function(posVertical,posHorizontal)
			if posVertical <= 0 then 
				posVertical = (posVertical-1)%#menu.data.elements+1
			elseif posVertical > #menu.data.elements then 
				posVertical = posVertical%#menu.data.elements
			end 
			menu.pos = posVertical
			local current = menu.getcurrentselection()
			local current2 , changeX
			local changeY = posVertical ~= current
			if posHorizontal then 
				for i,v in pairs(menu.data.elements) do 
					if i == posVertical then 
						v.selected = true 
						if posHorizontal and v.type == 'slider' then 
							if posHorizontal <= 0 then 
								posHorizontal = (posHorizontal-1)%#v.options+1
							elseif posHorizontal > #v.options then 
								posHorizontal = posHorizontal%#v.options
							end 
							menu.data.elementpos[menu.getcurrentselection()] = posHorizontal
							current2 = menu.getcurrentoptionselection()
							changeX = current2 ~= posHorizontal
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
			end 
			if (current and changeY) or (current2 and changeX) then 
				menu.change(menu.data,menu)
			end 
		end 
		
		menu.getcurrentselection = function()
			return menu.pos
		end 
		menu.getcurrentoptionselection = function()
			return menu.data.elementpos[menu.getcurrentselection()]
		end 
		menu.switch = function(posHorizontal)
			menu.select(menu.getcurrentselection(),posHorizontal)
		end 
		menu.button = {
			up = function()
				menu.select(menu.getcurrentselection()-1)
			end,
			down = function()
				menu.select(menu.getcurrentselection()+1)
			end,
			left = function()
				if menu.getcurrentoptionselection() then 
					menu.select(menu.getcurrentselection(),menu.getcurrentoptionselection()-1)
				end 
			end,
			right = function()
				if menu.getcurrentoptionselection() then 
					menu.select(menu.getcurrentselection(),menu.getcurrentoptionselection()+1)
				end 
			end,
			enter = function()
				local data = {
					_namespace = menu.data.namespace ,
					_name = menu.data.name,
					current = {}
				}
				local current = menu.data.elements[menu.getcurrentselection()]
				
				if menu.data.elements[menu.getcurrentselection()].type=="slider" then 
					data.current.value = current.options[menu.getcurrentoptionselection()].value
				else 
					data.current.value = current.value
				end 
				menu.submit(data,menu)
			end,
			back = function()
				local data = {
					_namespace = menu.data.namespace ,
					_name = menu.data.name,
					current = {}
				}
				local current = menu.data.elements[menu.getcurrentselection()]
				if menu.data.elements[menu.getcurrentselection()].type=="slider" then 
					data.current.value = current.options[menu.getcurrentoptionselection()].value
				else 
					data.current.value = current.value
				end 
				menu.cancel(data,menu)
			end,
			esc = function()
				menu.close()
			end 
		}
		menu.refresh = nil --交給中間框架吧
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