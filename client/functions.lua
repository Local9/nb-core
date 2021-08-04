NB.TriggerServerCallback = ESX.TriggerServerCallback 

NB.SpawnPlayerDefault = function()
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	local x,y,z = -802.311, 175.056, 72.8446
	local model = `mp_m_freemode_01`
	RequestModel(model)

    -- load the model for this spawn
    while not HasModelLoaded(model) do
        RequestModel(model)

        Wait(0)
    end

    -- change the player model
    SetPlayerModel(PlayerId(), model)

    -- release the player model
    SetModelAsNoLongerNeeded(model)
	-- preload collisions for the spawnpoint
    RequestCollisionAtCoord(x, y, z)

    -- spawn the player
    local ped = PlayerPedId()

    -- V requires setting coords as well
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false, true)

    NetworkResurrectLocalPlayer(x, y, z, heading, true, true, false)

    -- gamelogic-style cleanup stuff
    ClearPedTasksImmediately(ped)
    --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
    RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
    ClearPlayerWantedLevel(PlayerId())

    -- why is this even a flag?
    --SetCharWillFlyThroughWindscreen(ped, false)

    -- set primary camera heading
    --SetGameCamHeading(heading)
    --CamRestoreJumpcut(GetGameCam())

    -- load the scene; streaming expects us to do it
    --ForceLoadingScreen(true)
    --loadScene(x, y, z)
    --ForceLoadingScreen(false)

    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    ShutdownLoadingScreen()

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)

        while not IsScreenFadedIn() do
            Citizen.Wait(0)
        end
    end

    -- and unfreeze the player
    local ped = PlayerPedId()
	if not IsEntityVisible(ped) then
        SetEntityVisible(ped, true)
    end

    if not IsPedInAnyVehicle(ped) then
        SetEntityCollision(ped, true)
    end

    FreezeEntityPosition(ped, false)
    --SetCharNeverTargetted(ped, false)
    SetPlayerInvincible(player, false)
    TriggerEvent('playerSpawned')

	SetPedDefaultComponentVariation(ped)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	FreezeEntityPosition(ped, false)
end 

NB.SpawnPlayer = function(coords, heading, model)
	local player = PlayerId()
	SetPlayerControl(player, true, false)
	-- spawnmanager
	local x,y,z 
	if coords then 
		x,y,z = coords.x,coords.y,coords.z
	else 
		x,y,z = -802.311, 175.056, 72.8446
	end 
	local model = model or `mp_m_freemode_01`
	RequestModel(model)

    -- load the model for this spawn
    while not HasModelLoaded(model) do
        RequestModel(model)

        Wait(0)
    end

    -- change the player model
    SetPlayerModel(PlayerId(), model)

    -- release the player model
    SetModelAsNoLongerNeeded(model)
	-- preload collisions for the spawnpoint
    RequestCollisionAtCoord(x, y, z)

    -- spawn the player
    local ped = PlayerPedId()

    -- V requires setting coords as well
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false, true)

    NetworkResurrectLocalPlayer(x, y, z, heading, true, true, false)

    -- gamelogic-style cleanup stuff
    ClearPedTasksImmediately(ped)
    --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
    RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
    ClearPlayerWantedLevel(PlayerId())

    -- why is this even a flag?
    --SetCharWillFlyThroughWindscreen(ped, false)

    -- set primary camera heading
    --SetGameCamHeading(heading)
    --CamRestoreJumpcut(GetGameCam())

    -- load the scene; streaming expects us to do it
    --ForceLoadingScreen(true)
    --loadScene(x, y, z)
    --ForceLoadingScreen(false)

    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    ShutdownLoadingScreen()

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)

        while not IsScreenFadedIn() do
            Citizen.Wait(0)
        end
    end

    -- and unfreeze the player
    local ped = PlayerPedId()
	if not IsEntityVisible(ped) then
        SetEntityVisible(ped, true)
    end

    if not IsPedInAnyVehicle(ped) then
        SetEntityCollision(ped, true)
    end

    FreezeEntityPosition(ped, false)
    --SetCharNeverTargetted(ped, false)
    SetPlayerInvincible(player, false)
    TriggerEvent('playerSpawned')

	SetPedDefaultComponentVariation(ped)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	FreezeEntityPosition(ped, false)
end 