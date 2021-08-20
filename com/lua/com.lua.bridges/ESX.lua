ESX = {} -- https://github.com/esx-framework/esx-legacy
ESX.UI = {}
ESX.UI.Menu                   = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}
if IsShared() then 
    local Charset = {}
    for i = 48,  57 do table.insert(Charset, string.char(i)) end
    for i = 65,  90 do table.insert(Charset, string.char(i)) end
    for i = 97, 122 do table.insert(Charset, string.char(i)) end
    ESX.GetRandomString = function(length)
       if IsClient() then 
			local seed = GetCloudTimeAsInt()+GetGameTimer()
			if seed >= (2 ^ 32) then
				seed = seed - math.floor(seed / 2 ^ 32) * (2 ^ 32)
			end
			math.randomseed(math.floor(math.abs(seed)))
		end 
		if IsServer() then 
			local seed = os.time()+GetGameTimer()
			if seed >= (2 ^ 32) then
				seed = seed - math.floor(seed / 2 ^ 32) * (2 ^ 32)
			end
			math.randomseed(math.floor(math.abs(seed)))
		end 
        if length > 0 then
            return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
        else
            return ''
        end
    end
    ESX.GetRandomInt = function(length)
        if IsClient() then 
			local seed = GetCloudTimeAsInt()+GetGameTimer()
			if seed >= (2 ^ 32) then
				seed = seed - math.floor(seed / 2 ^ 32) * (2 ^ 32)
			end
			math.randomseed(math.floor(math.abs(seed)))
		end 
		if IsServer() then 
			local seed = os.time()+GetGameTimer()
			if seed >= (2 ^ 32) then
				seed = seed - math.floor(seed / 2 ^ 32) * (2 ^ 32)
			end
			math.randomseed(math.floor(math.abs(seed)))
		end 
        if length > 0 then
            return ESX.GetRandomInt(length - 1) .. tostring(math.random(1, 9))
        else
            return ''
        end
    end
end 
if IsServer() then 
    ESX.ServerCallbacks = {}
    RegisterServerEvent('ESX:triggerServerCallback')
    AddEventHandler('ESX:triggerServerCallback', function(name, requestId, ...)
        local playerId = NB and NB.PlayerId and NB.PlayerId(source) or tonumber(source)
        ESX.TriggerServerCallback(name, requestId, playerId, function(...)
            TriggerClientEvent('ESX:serverCallback', playerId, requestId, ...)
        end, ...)
    end)
    ESX.RegisterServerCallback = function(name, cb)
        ESX.ServerCallbacks[name] = cb
    end
    ESX.TriggerServerCallback = function(name, requestId, playerId, cb, ...)
        if ESX.ServerCallbacks[name] then
            ESX.ServerCallbacks[name](playerId, cb, ...)
        else
            print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!'):format(name))
        end
    end
else 
    ESX.ServerCallbacks           = {}
    ESX.CurrentRequestId          = 1
    ESX.TriggerServerCallback = function(name, cb, ...)
        ESX.ServerCallbacks[ESX.CurrentRequestId] = cb
        TriggerServerEvent('ESX:triggerServerCallback', name, ESX.CurrentRequestId, ...)
        if ESX.CurrentRequestId < 65534 then
            ESX.CurrentRequestId = ESX.CurrentRequestId + 1
        else
            ESX.CurrentRequestId = 1
        end
    end
    RegisterNetEvent('ESX:serverCallback')
    AddEventHandler('ESX:serverCallback', function(requestId, ...)
        if ESX.ServerCallbacks[requestId] then ESX.ServerCallbacks[requestId](...) end 
        ESX.ServerCallbacks[requestId] = nil
    end)
	--註冊一個Menu風格，以及它的開關 
    ESX.UI.Menu.RegisterType = function(type, open, close)
        ESX.UI.Menu.RegisteredTypes[type] = {
            open   = open,
            close  = close
        }
    end
	--開啟一個菜單，在一個Menu風格，這個菜單有namespace和name作為識別。
	--開啟同一個風格的同一個namespace和name，會刷新這個底層的目前的資料。
    ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
        local menu = {}
        menu.type      = type
        menu.namespace = namespace
        menu.name      = name
        menu.data      = data
        menu.submit    = submit
        menu.cancel    = cancel
        menu.change    = change
        menu.close = function()
            ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)
            for i=1, #ESX.UI.Menu.Opened, 1 do
                if ESX.UI.Menu.Opened[i] then
                    if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
                        ESX.UI.Menu.Opened[i] = nil
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
        menu.refresh = function()
            ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
        end
        menu.setElement = function(i, key, val)
            menu.data.elements[i][key] = val
        end
        menu.setElements = function(newElements)
            menu.data.elements = newElements
        end
        menu.setTitle = function(val)
            menu.data.title = val
        end
        menu.removeElement = function(query)
            for i=1, #menu.data.elements, 1 do
                for k,v in pairs(query) do
                    if menu.data.elements[i] then
                        if menu.data.elements[i][k] == v then
                            table.remove(menu.data.elements, i)
                            break
                        end
                    end
                end
            end
        end
        table.insert(ESX.UI.Menu.Opened, menu)
        ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)
        return menu
    end
    ESX.UI.Menu.Close = function(type, namespace, name) --基本不會用到 除非這麼有責任心
        for i=1, #ESX.UI.Menu.Opened, 1 do
            if ESX.UI.Menu.Opened[i] then
                if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
                    ESX.UI.Menu.Opened[i].close()
					
                    ESX.UI.Menu.Opened[i] = nil
                end
            end
        end

    end
    ESX.UI.Menu.CloseAll = function() --基本不會用到 會把default以及各種dialog的menu消除
        for i=1, #ESX.UI.Menu.Opened, 1 do
            if ESX.UI.Menu.Opened[i] then
                ESX.UI.Menu.Opened[i].close()
                ESX.UI.Menu.Opened[i] = nil
            end
        end
    end
    ESX.UI.Menu.GetOpened = function(type, namespace, name)  --得到某個風格menu的最新大Open資料 如果是default，因為Open會堆疊open，這將會是focus[#focus]
        for i=1, #ESX.UI.Menu.Opened, 1 do
            if ESX.UI.Menu.Opened[i] then
                if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
                    return ESX.UI.Menu.Opened[i]
                end
            end
        end
    end
    ESX.UI.Menu.GetOpenedMenus = function() --得到各個風格menu的最新大Open資料
        return ESX.UI.Menu.Opened
    end
    ESX.UI.Menu.IsOpen = function(type, namespace, name) --得到某個風格menu的大Open資料是否存在
        return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
    end
end 