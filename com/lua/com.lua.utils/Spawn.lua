
com.lua.utils.SpawnManager.SpawnFreeze = function(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end


com.lua.utils.SpawnManager.Spawn = function(coords, heading, model,cb)
	-- spawnmanager
	local x,y,z 
	if coords then 
		x,y,z = coords.x,coords.y,coords.z
	else 
		x,y,z = -802.311, 175.056, 72.8446
	end 
	local model = model

	-- freeze the local player
    com.lua.utils.SpawnManager.SpawnFreeze(PlayerId(), true)
	if model then 
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
	end 
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
	if GetResourceState("spawnmanager") ~= "started" then 
		TriggerEvent('playerSpawned')
	end 
	--local model = GetEntityModel(ped)
	if model and model == `mp_m_freemode_01` or model == `mp_f_freemode_01` then 
		SetPedDefaultComponentVariation(ped)
	end 
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	FreezeEntityPosition(ped, false)
	if cb then cb() end 
end 