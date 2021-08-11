fx_version 'adamant'
game 'gta5'

files {
	'xls/table/*.csv'
}

lua54 'yes'

shared_scripts {
	"nbmanifest.lua",
	"nb-core.lua",
	"com/init.lua",
	'com/lua/*.lua',
	'com/lua/**/*.lua',
	'com/game/*.lua',
	'com/game/**/*.lua',
	'com/define.lua',
	"import.lua"
}

client_scripts {
	'client/functions.lua',
	'client/player.lua'
}

server_scripts{
	'server/functions.lua',
	'server/player.lua'
}

dependencies {
	'chat',
	'ghmattimysql',
	'connectqueue',
	'skinchanger'
}
