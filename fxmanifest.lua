fx_version 'adamant'

game 'gta5'

files {

}
shared_scripts {
	"temp/shared.lua",
    "main_shared.lua"
}
client_scripts {
'@threads/threads.lua',
'client/functions.lua',
'client/events.lua',
'client/session.lua',
'main_client.lua'
}
server_scripts{
	'server/functions.lua',
	'server/callbacks.lua',
	'server/events.lua',
	'server/session.lua',
	'main_server.lua'
}

dependencies {
    'spawnmanager',
	'ghmattimysql',
	'connectqueue'
}