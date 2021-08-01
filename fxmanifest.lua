fx_version 'adamant'
resource_type 'gametype' { name = 'NBCore' }
game 'gta5'

files {

}
shared_scripts {
    "shared_main.lua"
}
client_scripts {
'@threads/threads.lua',
'client/*.lua'
}
server_scripts{
	'server/*.lua'
}

dependencies {
    'spawnmanager',
	'ghmattimysql',
    'threads'
}