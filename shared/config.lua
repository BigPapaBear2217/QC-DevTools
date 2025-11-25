Config = {}

-- Main DevTools Configuration
Config.Commands = {
    mainMenu = 'devtools',
    adminMenu = 'admin',  -- New unified admin menu
    pedDecals = 'dev_decals' -- Alternative direct access
}

-- Admin Menu Configuration
Config.AdminMenu = {
    enabled = true,
    showInMainMenu = true, -- Show admin option in main devtools menu
    requireRSGCore = true -- Requires RSG Core framework
}

-- Admin Permissions (matches rsg-adminmenu system)
-- Uses BOTH RSGCore.Functions.HasPermission() AND IsPlayerAceAllowed()
-- Add in server.cfg: add_ace group.admin command allow
-- OR set in RSGCore permissions database

-- DevTools Categories Configuration
Config.Categories = {
    {
        id = 'adminmenu',
        label = '🛡️ Admin Menu',
        description = 'Complete admin & moderation system',
        icon = '👑',
        enabled = true,
        adminOnly = true -- Only show if player has admin permission
    },
    {
        id = 'peddecals',
        label = 'Ped Decals',
        description = 'Apply and test ped decals (damage, scars, etc.)',
        icon = '🎭',
        enabled = true
    },
    {
        id = 'animpostfx',
        label = 'Animation Post FX',
        description = 'Test and apply animation post FX effects',
        icon = '🎬',
        enabled = true
    },
    {
        id = 'timecycles',
        label = 'Timecycle Modifiers',
        description = 'Apply and test timecycle visual effects',
        icon = '🌅',
        enabled = true
    },
    {
        id = 'explosions',
        label = 'Explosion Testing',
        description = 'Test explosions with player protection',
        icon = '💥',
        enabled = true
    },
    {
        id = 'audio',
        label = 'Audio Testing',
        description = 'Test sounds, speech, music, and effects',
        icon = '🔊',
        enabled = true
    },
    {
        id = 'ipls',
        label = 'Interior Placements',
        description = 'Enable/disable interior placements (IPLs)',
        icon = '🏗️',
        enabled = true
    },
    {
        id = 'ptfx',
        label = 'PTFX Effects',
        description = 'Test and apply particle effects',
        icon = '✨',
        enabled = true
    },
    {
        id = 'entityinfo',
        label = 'Entity Information',
        description = 'Inspect and capture entity data for development',
        icon = '🎯',
        enabled = true
    }
}

-- Permission system (standalone - no framework dependencies)
Config.Permissions = {
    adminOnly = false, -- Set to true to restrict to specific players only
    allowedPlayers = {} -- Add player identifiers: server IDs, steam IDs, license IDs, etc.
    -- Examples:
    -- allowedPlayers = { "1", "2", "steam:110000103fd1bb1", "license:a1b2c3d4e5f6g7h8" }
}

-- Admin Horse Configurations
Config.AdminHorses = {
    {
        name = 'Arabian White',
        hash = `a_c_horse_arabian_white`,
    },
    {
        name = 'Missouri Foxtrotter',
        hash = `a_c_horse_missourifoxtrotter_sablechampagne`,
    },
    {
        name = 'Nokota White Roan',
        hash = `a_c_horse_nokota_whiteroan`,
    },
    {
        name = 'Turkoman Gold',
        hash = `a_c_horse_turkoman_gold`,
    },
    {
        name = 'Thoroughbred',
        hash = `a_c_horse_thoroughbred_reversedappleblack`,
    }
}