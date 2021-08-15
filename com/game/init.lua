com.game = {Client={},Server={},Shared={}}
if IsShared() then 
	com.game.Shared.Load = {}
end 
if IsServer() then 
	com.game.Server.License = {}
end 
if IsClient() then 
	com.game.Client.Session = {}
	com.game.Client.Skin = {}
	com.game.Client.PauseMenu = {}
	com.game.Client.Notifications = {}
end 