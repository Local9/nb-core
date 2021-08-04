fx_version 'adamant'
game 'gta5'

files {

}



shared_scripts {
	"factory/*.lua",
	'factory/**/*.lua',
    "shared.lua",
	"import.lua"
}

client_scripts {
	'client/functions.lua',
	'client/events.lua',
	'client/session.lua',
	"main_client.lua"
}

server_scripts{
	'server/functions.lua',
	'server/callbacks.lua',
	'server/events.lua',
	'server/session.lua',
	"main_server.lua"
}



dependencies {
	'chat',
	'ghmattimysql',
	'connectqueue'
}