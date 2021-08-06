function IsServer() return IsDuplicityVersion() end 
function IsClient() return not IsDuplicityVersion() end 
function IsShared() return true end
function Main (fn) return fn() end

NB = {
	Datas={},
	Players={},
	Utils={},
	Threads={}
}  


Main(function()
	print("NB-CORE INITIALISED")
end)

function OnPlayerConnect(playerid)
	
end 

function OnPlayerRegister(playerid)
	
end 

function OnPlayerLogin(playerid)
	
end 

function OnPlayerUpdate(playerid)
	
end 

function OnPlayerDisconnect(playerid)
	
end 