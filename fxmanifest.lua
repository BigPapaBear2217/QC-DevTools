fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

name 'QC-DevTools'
description 'Development Tools for RedM Server - Decals, Testing, Admin Menu and More'
version '1.2.0'
author 'Quantum Projects'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

dependencies {
    'rsg-core',
    'ox_lib',
    'oxmysql'
}

client_scripts {
    'client/nui.lua',
    'client/main.lua',
    'client/peddecals/decals_data.lua',
    'client/peddecals/main.lua',
    'client/animpostfx/effects_data.lua',
    'client/animpostfx/main.lua',
    'client/timecycles/timecycles_data.lua',
    'client/timecycles/main.lua',
    'client/explosions/explosions_data.lua',
    'client/explosions/main.lua',
    'client/audio/dataview.lua',
    'client/audio/createstream.lua',
    'client/audio/musicevents.lua',
    'client/audio/frontendsoundsets.lua',
    'client/audio/audiobanks.lua',
    'client/audio/audioflags.lua',
    'client/audio/main.lua',
    'client/ipls/ipls_data.lua',
    'client/ipls/main.lua',
    'client/ptfx/effects_data.lua',
    'client/ptfx/main.lua',
    'client/entityinfo/main.lua',
    -- Admin Menu Integration
    'client/admin/main.lua',
    'client/admin/players.lua',
    'client/admin/server.lua',
    'client/admin/troll.lua',
    'client/admin/advanced.lua',
    'client/admin/reports.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/admin.lua',
    'server/admin_troll.lua',
    'server/admin_advanced.lua',
    'server/admin_reports.lua'
}

files {
    'html/dist/index.html',
    'html/dist/**/*'
}

ui_page 'html/dist/index.html'

lua54 'yes'