fx_version 'adamant'
game 'gta5'

files {

}



shared_scripts {
	"com/init.lua",
	'com/**/*.lua',
	'com/**/**/*.lua',
    "shared.lua",
	"import.lua"
}

client_scripts {
	'client/functions.lua',
	'client/events.lua',
	'client/session.lua'
}

server_scripts{
	'server/functions.lua',
	'server/callbacks.lua',
	'server/events.lua',
	'server/session.lua'
}



dependencies {
	'chat',
	'ghmattimysql',
	'connectqueue'
}