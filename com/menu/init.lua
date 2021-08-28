if IsClient() then
	com.menu                   = {}
	com.menu.Indexs			   = {}
	com.menu.RegisteredTypes   = {}
	com.menu.Opened            = {}
	
	com.menu.RegisteredKeyEvent = {}
	com.menu.RegisterKeyEvent = function(invoking,cb)
		com.menu.RegisteredKeyEvent[invoking] = cb 
	end 
	com.menu.UnRegisterKeyEvent = function(invoking)
		if com.menu.RegisteredKeyEvent[invoking] then com.menu.RegisteredKeyEvent[invoking] = nil end 
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
    com.menu.RegisterType = function(type, open, close)
		print(type)
        com.menu.RegisteredTypes[type] = {
            open   = open,
            close  = close
        }
		
    end
	--開啟一個菜單，在一個Menu風格，這個菜單有invoking和name作為識別。
	--開啟同一個風格的同一個invoking和name，會刷新這個底層的目前的資料。
    com.menu.Open = function(type, data, submit, cancel, change, close)
		local invoking = GetInvokingResource()
		if not com.menu.RegisteredKeyEvent[invoking] then 
			com.menu.RegisterKeyEvent(invoking,function(input)
				print(input)
			end)
		end 
        local menu = {}
		local invoking = GetInvokingResource()
        menu.invoking = invoking
		com.menu.Indexs[invoking] = ( com.menu.Indexs[invoking] or 0 ) + 1
		local index = com.menu.Indexs[invoking]
		menu.type      = type
        menu.data      = data
        menu.submit    = submit
        menu.cancel    = cancel
        menu.change    = change
        menu.close = function()
            com.menu.RegisteredTypes[type].close(index)
            for i=1, #com.menu.Opened, 1 do
                if com.menu.Opened[i] then
                    if com.menu.Opened[i].type == type and com.menu.Opened[i].invoking == invoking and com.menu.Opened[i].index == index then
                        com.menu.Opened[i] = nil
                    end
                end
            end
            if close then
                close()
            end
        end
        menu.update = function(query, newData)
            for i=1, #menu.data.elements, 1 do
                local match = true
                for k,v in pairs(query) do
                    if menu.data.elements[i][k] ~= v then
                        match = false
                    end
                end
                if match then
                    for k,v in pairs(newData) do
                        menu.data.elements[i][k] = v
                    end
                end
            end
        end
        table.insert(com.menu.Opened, menu)
		if com.menu.RegisteredTypes[type] then 
			if com.menu.RegisteredTypes[type].open then 
				com.menu.RegisteredTypes[type].open(invoking, index, data)
			else 
				print("Registered Menu Not Any open")
			end 
		else 
			print("Not Registered Any Menu about "..type)
		end 
		
        return menu
    end
    com.menu.Close = function(type) --基本不會用到 除非這麼有責任心
		local invoking = GetInvokingResource()
		com.menu.UnRegisterKeyEvent(invoking)
        for i=1, #com.menu.Opened, 1 do
            if com.menu.Opened[i] then
                if com.menu.Opened[i].type == type and com.menu.Opened[i].invoking == invoking and com.menu.Opened[i].index == index then
                    com.menu.Opened[i].close()
					
                    com.menu.Opened[i] = nil
                end
            end
        end

    end
    com.menu.CloseAll = function() --基本不會用到 會把default以及各種dialog的menu消除
        for i=1, #com.menu.Opened, 1 do
            if com.menu.Opened[i] then
                com.menu.Opened[i].close()
                com.menu.Opened[i] = nil
            end
        end
    end
    com.menu.GetOpened = function(type, index)  --得到某個風格menu的最新大Open資料 如果是default，因為Open會堆疊open，這將會是focus[#focus]
        local invoking = GetInvokingResource()
		for i=1, #com.menu.Opened, 1 do
            if com.menu.Opened[i] then
                if com.menu.Opened[i].type == type and com.menu.Opened[i].invoking == invoking and com.menu.Opened[i].index == index then
                    return com.menu.Opened[i]
                end
            end
        end
    end
    com.menu.GetOpenedMenus = function() --得到各個風格menu的最新大Open資料
        return com.menu.Opened
    end
    com.menu.IsOpen = function(type, index) --得到某個風格menu的大Open資料是否存在
		local invoking = GetInvokingResource()
        return com.menu.GetOpened(type, invoking, index) ~= nil
    end
	
end 