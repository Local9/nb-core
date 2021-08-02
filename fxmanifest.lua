fx_version 'adamant'

game 'gta5'

files {

}
shared_scripts {
	"temp/shared.lua",
    "shared_main.lua"
}
client_scripts {
'@threads/threads.lua',
'client/functions.lua',
'client/events.lua',
'client/session.lua',
'client.lua'
}
server_scripts{
	'server/functions.lua',
	'server/callbacks.lua',
	'server/events.lua',
	'server/session.lua',
	'server.lua'
}

dependencies {
    'spawnmanager',
	'ghmattimysql',
	'connectqueue'
}