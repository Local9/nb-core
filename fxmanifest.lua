fx_version 'adamant'
game 'gta5'

files {
	'xls/table/monster.csv'
}

lua54 'yes'

shared_scripts {
	'config.lua',
	"init.lua",
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
	'client/events.lua',
	'client/session.lua'
}

server_scripts{
	'server/functions.lua',
	'server/callbacks.lua',
	'server/events.lua',
	'server/player.lua',
	'server/session.lua'
}



dependencies {
	'chat',
	'ghmattimysql',
	'connectqueue'
}