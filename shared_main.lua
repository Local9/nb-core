NB = {}

local function GetObject()
	return NB
end

AddEventHandler('NB:GetObject', function(cb)
	cb(GetObject())
end)

local IsServer = function() return IsDuplicityVersion() end 
local IsClient = function() return not IsDuplicityVersion() end 
if IsServer() then 
    RegisterNetEvent('NB:OnPlayerSessionStart', function()
        print("PlayerSessionStart",source)
    end)

    CreateThread(function()
        print("[NBCore] Server Loaded")
    end)
end 
if IsClient() then 
    CreateThread(function()
        local SpawnPlayer = function()
            exports.spawnmanager:spawnPlayer({
                    x = -802.311, y = 175.056, z = 72.8446,heading = 0.0,model = `a_m_y_hipster_01`,
                    skipFade = false
                }, function()
                ShutdownLoadingScreen()
                ShutdownLoadingScreenNui()
                FreezeEntityPosition(PlayerPedId(), false)
            end)
        end
        while not NetworkIsSessionStarted() do
            Wait(0)
        end
        SpawnPlayer()
        TriggerServerEvent('NB:OnPlayerSessionStart')
        TriggerEvent('NB:OnPlayerSessionStart')
        --print("NB:OnPlayerSessionStart")
        return 
    end)
end 

if IsServer() then 
    local RegisterServerCallback
    RegisterServerCallback = function(name,fn)
        local resname = GetCurrentResourceName()
        local hash = GetHashKey(name)
        local eventName,a = resname..":"..hash..":".."RequestCallback"
        RegisterNetEvent(eventName)
        a = AddEventHandler(eventName, function (ticketClient,...)
            local source_ = source 
            local ticketServer =  tostring(GetGameTimer())..tostring(math.random(0,65535))
            local eventWithTicket,b = eventName .. ticketClient .. ticketServer
            if source_ then eventWithTicket = eventWithTicket .. tostring(source_)..tostring(GetHashKey(GetPlayerName(source_))) 
                RegisterNetEvent(eventWithTicket)
                b = AddEventHandler(eventWithTicket, function (ticketCl,...)
                    TriggerClientEvent(resname..":"..hash..":".."ResultCallback"..ticketCl,source_,fn(...),...)
                    RemoveEventHandler(b)
                    CreateThread(function()
                        if RegisterServerCallback then RegisterServerCallback(name,fn) end 
                    end)
                end) 
                TriggerEvent(eventWithTicket,ticketClient,...)
            end 
            RemoveEventHandler(a)
        end)
    end 
    NB.RegisterServerCallback = RegisterServerCallback --https://github.com/negbook/ServerCallback
end 
if IsClient() then 
    local TriggerServerCallback
    TriggerServerCallback = function(name,fn,...)
        local resname = GetCurrentResourceName()
        local a 
        local hash = GetHashKey(name)
        local ticketClient = tostring(GetGameTimer())..tostring(NetworkGetRandomIntRanged(0,65535))
        RegisterNetEvent(resname..":"..hash..":".."ResultCallback"..ticketClient)
        a = AddEventHandler(resname..":"..hash..":".."ResultCallback"..ticketClient, function (...)
            fn(...)
            RemoveEventHandler(a)
        end)
        TriggerServerEvent(resname..":"..hash..":".."RequestCallback",ticketClient,...)
    end 
    NB.TriggerServerCallback = TriggerServerCallback --https://github.com/negbook/ServerCallback
end 