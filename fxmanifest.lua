fx_version 'adamant'
game 'gta5'

files {
	'xls/table/*.csv'
}

lua54 'yes'

shared_scripts {
	"nbmanifest.lua",
	"com/init.lua",
	'com/lua/*.lua',
	'com/lua/**/*.lua',
	'com/game/*.lua',
	'com/game/**/*.lua',
	'com/define.lua',
	"import.lua",
	"nb-core.lua"
}

client_scripts {
	'client/events.lua',
	'client/functions.lua',
	'client/player.lua'
}

server_scripts{
	'server/events.lua',
	'server/functions.lua',
	'server/player.lua'
}

dependencies {
	'chat',
	'ghmattimysql',
	'connectqueue',
	'skinchanger'
}
