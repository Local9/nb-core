function IsServer() return IsDuplicityVersion() end 
function IsClient() return not IsDuplicityVersion() end 
function IsShared() return true end
function Main (fn) return fn() end

NB = {
	_temp_ = {},
	Datas={},
	Players={},
	Utils={},
	Threads={}
}  


Main(function()
	print("NB-CORE INITIALISED")
end)

function OnPlayerConnect(playerid, name, setKickReason, deferrals)
	deferrals.defer()
	Wait(0)
	local license = NB.GetIdentifier(playerid)
	print(license)
	local isLicenseAlreadyInUse = false 
	deferrals.update(string.format("Hello %s. Validating Your Rockstar License", name))
	if NB.GetPlayerFromIdentifier(NB.GetIdentifier(playerid)) then 
		isLicenseAlreadyInUse = true 
	end 
	--Wait(2500)

    --deferrals.update(string.format("Hello %s. We are checking if you are banned.", name))
	
	Wait(2500)
	
    deferrals.update(string.format("Welcome %s to {Server Name}.", name))
	if not license then
        deferrals.done('No Valid Rockstar License Found')
    --elseif isBanned then
	    --deferrals.done(Reason)
    elseif isLicenseAlreadyInUse then
        deferrals.done('Duplicate Rockstar License in the Server Found')
    else
        deferrals.done()
        Wait(1000)
        TriggerEvent("connectqueue:playerConnect", name, setKickReason, deferrals)
    end
end 

function OnPlayerRegister(playerid)
	
end 

function OnPlayerLogin(playerid)
	
end 

function OnPlayerUpdate(playerid)
	
end 

function OnPlayerDisconnect(playerid)
	
end 