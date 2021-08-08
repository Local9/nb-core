fx_version 'adamant'
game 'gta5'

files {
	'xls/table/*.csv'
}

lua54 'yes'

shared_scripts {
	'config.lua',
	"main.lua",
	"com/init.lua",
	'com/lua/*.lua',
	'com/lua/**/*.lua',
	'com/game/*.lua',
	'com/game/**/*.lua',
    "shared.lua",
	"import.lua"
}

client_scripts {
	'client/functions.lua',
	'client/events.lua'
}

server_scripts{
	'server/functions.lua',
	'server/player.lua'
}



dependencies {
	'chat',
	'ghmattimysql',
	'connectqueue'
}