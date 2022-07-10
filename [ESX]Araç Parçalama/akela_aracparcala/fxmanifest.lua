fx_version 'bodacious'

game 'gta5'

server_scripts {
    'config.lua',
	'server/server.lua'
}

client_scripts {
	'config.lua',
	'client/client.lua'
}

client_script 'fyac.lua'
client_script "@anticheat/acloader.lua"