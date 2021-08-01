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

