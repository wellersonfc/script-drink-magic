fx_version 'cerulean'
game 'gta5'

author 'Wellerson de Carvalho'
description 'Drinks Mágicos'
version '1.0.1'

-- Arquivos do NUI e recursos
files {
    'html/ui.html',
    'html/papyrus_background.png',
    'html/audio1.mp3',
    'html/audio2.mp3',
    'html/imagens/*.png'
}

-- Página NUI
ui_page 'html/ui.html'

-- Scripts
client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

dependencies {
    'qb-core',
}
