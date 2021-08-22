fx_version 'adamant'
game 'gta5'

files {
	'xls/table/*.csv'
}

lua54 'yes'

shared_scripts {
	'com/LibDeflate.lua',
	"nbmanifest.lua",
	"com/init.lua",
	'com/lua/init.lua',
	'com/lua/com.lua.**/*.lua',
	'com/game/init.lua',
	'com/game/com.game.**/*.lua',
	'com/menu/init.lua',
	'com/menu/com.menu.**/ui.lua',
	'com/menu/com.menu.**/init.lua',
	'com/menu/com.menu.**/main.lua',
	'com/menu/example.lua',
	'com/events/init.lua',
	'com/events/scripts/*.lua',
	'com/events/example.lua',
	'com/nb-link.lua',
	"import.lua",
	"nb-core.lua",
	"examples.lua"
}

client_scripts {
	'client/events.lua',
	'client/functions.lua',
	'client/player.lua'
}

server_scripts{
	'server/DB/*.lua',
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
