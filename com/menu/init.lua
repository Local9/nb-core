if IsClient() then
	com.menu                   = {}
	com.menu.Indexs			   = {}
	com.menu.Menus			   = {}
	com.menu.RegisteredTypes   = {}
	com.menu.RegisteredKeyEvent = {}

	com.menu.Minify = function(menu)
		local menu = setmetatable({},{__index=menu})
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
			end 
			if v.description then 
				result.slots[i].description = v.description
			end 
			if buttons[i].type == 'slider' then 
				local options = v.options 
				for k,c in pairs(options) do 
					if c.selected then 
						result.slots[i].righttext = c.label 
						result.slots[i].selection = true
						if c.description and not result.slots[i].description then 
							result.slots[i].description = c.description
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
	--開啟一個菜單，在一個Menu風格，這個菜單有invoking和name作為識別。
	--開啟同一個風格的同一個invoking和name，會刷新這個底層的目前的資料。
    com.menu.Open = function(type, data, submit, cancel, change, close)
        local menu = {}
		local invoking = GetInvokingResource()
        menu.invoking = invoking
		com.menu.Indexs[invoking] = ( com.menu.Indexs[invoking] or 0 ) + 1
		if not com.menu.Menus[invoking] then com.menu.Menus[invoking] = {} end 
		table.insert(com.menu.Menus[invoking],menu)
		if not com.menu.RegisteredKeyEvent[invoking] and com.menu.RegisteredTypes[type].keylistener then 
			com.menu.RegisterKeyEvent(invoking,function(input)
				if #com.menu.Menus[invoking] > 0 then 
					com.menu.RegisteredTypes[type].keylistener(com.menu.Menus[invoking][#com.menu.Menus[invoking]],input)
				end 
			end)
		end 
		local index = com.menu.Indexs[invoking]
		menu.type      = type
        menu.data      = data
        menu.submit    = submit
        menu.cancel    = cancel
        menu.change    = change
		menu.update    = function()
			local index_ = #com.menu.Menus[invoking]
			local invoking_ = invoking
			if #com.menu.Menus[invoking_] > 0 then 
				if com.menu.RegisteredTypes[type].updaterender then 
					local simplymenu = com.menu.Minify(com.menu.Menus[invoking_][index_])
					com.menu.RegisteredTypes[type].updaterender(invoking_, index_, simplymenu, true) --update
					print_table_server(simplymenu)
				end 
			end 
		end 
        menu.close = function()
            com.menu.RegisteredTypes[type].close(invoking,index)
            if close then --callback of menus
                close(invoking, index)
            end

			if #com.menu.Menus[invoking] > 0 then
				table.remove(com.menu.Menus[invoking])
				com.menu.Indexs[invoking] = com.menu.Indexs[invoking] - 1
				if #com.menu.Menus[invoking] > 0 then 
					menu.update()
				end 
			else 
				if com.menu.RegisteredTypes[type].updaterender then 
					com.menu.RegisteredTypes[type].updaterender = nil
				end 
				com.menu.Menus[invoking] = nil
				com.menu.Indexs[invoking] = 0
			end 
        end
		menu.data.elements = com.menu.convertButtons(menu.data.elements,namespace,name)
		menu.data.elementpos = {}
		for i,v in pairs(menu.data.elements) do
			if v.type == 'slider' then 
				menu.data.elementpos[i] = 1
			end 
		end 
		menu.pos = 1
		menu.update()
		menu.select = function(posVertical,posHorizontal)
			if posVertical <= 0 then 
				posVertical = (posVertical-1)%#menu.data.elements+1
			elseif posVertical > #menu.data.elements then 
				posVertical = posVertical%#menu.data.elements
			end 
			local current = menu.getcurrentselection()
			local current2 , changeX
			local changeY = posVertical ~= current
			menu.pos = posVertical
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
							current2 = menu.getcurrentoptionselection()
							changeX = current2 ~= posHorizontal
							menu.data.elementpos[menu.getcurrentselection()] = posHorizontal
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
				menu.update()
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

		if com.menu.RegisteredTypes[type] then 
	
			if com.menu.RegisteredTypes[type].open then 
				com.menu.RegisteredTypes[type].open(invoking, index, data)
			else 
				print("Registered Menu Not Any open")
			end 
			if com.menu.RegisteredTypes[type].updaterender then 
				local simplymenu = com.menu.Minify(menu)
				com.menu.RegisteredTypes[type].updaterender(invoking, index, simplymenu, false) --first open
				print_table_server(simplymenu)
			end 
		else 
			print("Not Registered Any Menu about "..type)
		end 
		
        return menu
    end
    
	local TriggerRegisterKeyEvent = function(input)
		if com.menu.RegisteredKeyEvent then 
			for i,v in pairs(com.menu.RegisteredKeyEvent) do 
				if v then 
					v(input)  
				end 
			end 
		end 
	end 
	NB.RegisterKeyEvent('Menu',function(input)
		TriggerRegisterKeyEvent(input)
	end )
	
	--註冊一個Menu風格，以及它的開關 
    com.menu.RegisterType = function(type, open, close, keylistener, updaterender , stoprender)
        com.menu.RegisteredTypes[type] = {
            open   = open,
            close  = close,
			keylistener = keylistener,
			updaterender = updaterender,
			stoprender = stoprender
        }
    end
	com.menu.RegisterKeyEvent = function(invoking,cb)
		com.menu.RegisteredKeyEvent[invoking] = cb 
	end 
	com.menu.UnRegisterKeyEvent = function(invoking)
		if com.menu.RegisteredKeyEvent[invoking] then com.menu.RegisteredKeyEvent[invoking] = nil end 
	end 
end 