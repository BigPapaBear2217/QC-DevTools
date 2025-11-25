local RSGCore = exports['rsg-core']:GetCoreObject()

-- Store players list for event handlers
local playersList = {}

-- Player Management Menu
RegisterNetEvent('qc-devtools:client:admin_players_menu', function()
    RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
        if not players or #players == 0 then
            lib.notify({ title = 'Admin', description = 'No players online!', type = 'error' })
            return
        end
        
        playersList = players -- Store for later use
        
        local options = {}
        for _, player in pairs(players) do
            table.insert(options, {
                id = 'player_' .. player.id,
                title = player.name,
                description = 'ID: ' .. player.id .. ' | Manage this player',
                icon = '👤'
            })
        end
        
        local menuData = {
            id = 'admin_players_menu',
            title = '👥 Player Management',
            subtitle = 'Online Players: ' .. #players,
            back = 'qc_admin_main',
            options = options
        }
        ShowDevToolsMenu(menuData)
    end)
end)

-- Handle players menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_players_menu' then
        -- Extract player ID from option ID (format: player_123)
        local playerId = tonumber(optionId:match('player_(%d+)'))
        if playerId then
            -- Find player in stored list
            for _, player in pairs(playersList) do
                if player.id == playerId then
                    TriggerEvent('qc-devtools:client:admin_player_options', player)
                    break
                end
            end
        end
    end
end)

-- Store selected player for event handlers
local selectedPlayer = nil

-- Individual Player Options
RegisterNetEvent('qc-devtools:client:admin_player_options', function(player)
    selectedPlayer = player -- Store for later use
    
    local menuData = {
        id = 'admin_player_options',
        title = '👤 ' .. player.name,
        subtitle = 'Player ID: ' .. player.id,
        back = 'admin_players_menu',
        options = {
            {
                id = 'player_info',
                title = 'ℹ️ View Info',
                description = 'View detailed player information',
                icon = '📋'
            },
            {
                id = 'teleport_to',
                title = '➡️ Teleport To Player',
                description = 'Teleport to this player',
                icon = '🎯'
            },
            {
                id = 'bring',
                title = '⬅️ Bring Player',
                description = 'Bring player to you',
                icon = '🎯'
            },
            {
                id = 'spectate',
                title = '👁️ Spectate',
                description = 'Spectate this player',
                icon = '📹'
            },
            {
                id = 'freeze',
                title = '❄️ Freeze Player',
                description = 'Freeze/Unfreeze player',
                icon = '🧊'
            },
            {
                id = 'revive',
                title = '❤️ Revive Player',
                description = 'Revive this player',
                icon = '💊'
            },
            {
                id = 'money',
                title = '💰 Money Options',
                description = 'Give or remove money',
                icon = '💵'
            },
            {
                id = 'kick',
                title = '⚠️ Kick Player',
                description = 'Kick player from server',
                icon = '🚪'
            },
            {
                id = 'ban',
                title = '🔨 Ban Player',
                description = 'Ban player from server',
                icon = '🔨'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle player options menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_player_options' and selectedPlayer then
        if optionId == 'player_info' then
            TriggerServerEvent('qc-devtools:server:getPlayerInfo', selectedPlayer.id)
        elseif optionId == 'teleport_to' then
            TriggerServerEvent('qc-devtools:server:teleportToPlayer', selectedPlayer.id)
        elseif optionId == 'bring' then
            TriggerServerEvent('qc-devtools:server:bringPlayer', selectedPlayer.id)
        elseif optionId == 'spectate' then
            TriggerEvent('qc-devtools:client:spectatePlayer', selectedPlayer.id)
        elseif optionId == 'freeze' then
            TriggerServerEvent('qc-devtools:server:freezePlayer', selectedPlayer.id)
        elseif optionId == 'revive' then
            TriggerServerEvent('qc-devtools:server:revivePlayer', selectedPlayer.id)
        elseif optionId == 'money' then
            TriggerEvent('qc-devtools:client:admin_money_menu', selectedPlayer)
        elseif optionId == 'kick' then
            TriggerEvent('qc-devtools:client:kickPlayer', selectedPlayer)
        elseif optionId == 'ban' then
            TriggerEvent('qc-devtools:client:banPlayer', selectedPlayer)
        end
    end
end)

-- Money Management Menu
RegisterNetEvent('qc-devtools:client:admin_money_menu', function(player)
    local input = lib.inputDialog('💰 Money Management - ' .. player.name, {
        {
            type = 'select',
            label = 'Action',
            options = {
                { value = 'add', label = 'Add Money' },
                { value = 'remove', label = 'Remove Money' }
            },
            required = true
        },
        {
            type = 'select',
            label = 'Money Type',
            options = {
                { value = 'cash', label = 'Cash' },
                { value = 'bank', label = 'Bank' },
                { value = 'bloodmoney', label = 'Blood Money' }
            },
            required = true
        },
        {
            type = 'number',
            label = 'Amount',
            required = true,
            min = 1
        }
    })
    
    if not input then return end
    
    TriggerServerEvent('qc-devtools:server:manageMoney', player.id, input[1], input[2], input[3])
end)

-- Kick Player
RegisterNetEvent('qc-devtools:client:kickPlayer', function(player)
    local input = lib.inputDialog('⚠️ Kick Player - ' .. player.name, {
        {
            type = 'input',
            label = 'Reason',
            required = true,
            placeholder = 'Enter kick reason...'
        }
    })
    
    if not input then return end
    
    TriggerServerEvent('qc-devtools:server:kickPlayer', player.id, input[1])
end)

-- Ban Player
RegisterNetEvent('qc-devtools:client:banPlayer', function(player)
    local input = lib.inputDialog('🔨 Ban Player - ' .. player.name, {
        {
            type = 'input',
            label = 'Reason',
            required = true,
            placeholder = 'Enter ban reason...'
        },
        {
            type = 'number',
            label = 'Duration (hours, 0 = permanent)',
            required = true,
            min = 0,
            default = 0
        }
    })
    
    if not input then return end
    
    TriggerServerEvent('qc-devtools:server:banPlayer', player.id, input[1], input[2])
end)

-- Spectate Player
local isSpectating = false
local spectateTarget = nil

RegisterNetEvent('qc-devtools:client:spectatePlayer', function(playerId)
    if isSpectating then
        -- Stop spectating
        isSpectating = false
        local playerPed = PlayerPedId()
        NetworkSetInSpectatorMode(false, spectateTarget)
        spectateTarget = nil
        lib.notify({ title = 'Spectate', description = 'Spectate mode disabled', type = 'inform' })
    else
        -- Start spectating
        local targetPlayer = GetPlayerFromServerId(playerId)
        if targetPlayer == -1 then
            lib.notify({ title = 'Error', description = 'Player not found!', type = 'error' })
            return
        end
        
        local targetPed = GetPlayerPed(targetPlayer)
        spectateTarget = targetPed
        isSpectating = true
        
        NetworkSetInSpectatorMode(true, targetPed)
        lib.notify({ title = 'Spectate', description = 'Now spectating player. Use the command again to stop.', type = 'success' })
    end
end)

-- Direct revive fallback (if no medic script installed)
RegisterNetEvent('qc-devtools:client:directRevive', function()
    local ped = cache.ped
    local pos = GetEntityCoords(ped)
    
    DoScreenFadeOut(500)
    Wait(1000)
    
    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(ped), true, false)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 0, 100.0) -- Health core
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 1, 100.0) -- Stamina core
    
    Wait(1500)
    DoScreenFadeIn(1800)
    
    TriggerServerEvent("RSGCore:Server:SetMetaData", "isdead", false)
    LocalPlayer.state:set('isDead', false, true)
end)

-- Display Player Info
RegisterNetEvent('qc-devtools:client:displayPlayerInfo', function(data)
    local menuData = {
        id = 'player_info_display',
        title = '📋 Player Information',
        subtitle = data.name,
        back = 'admin_player_options',
        options = {
            {
                id = 'name',
                title = 'Name',
                description = data.firstname .. ' ' .. data.lastname,
                icon = '👤'
            },
            {
                id = 'citizenid',
                title = 'Citizen ID',
                description = data.citizenid,
                icon = '🆔'
            },
            {
                id = 'serverid',
                title = 'Server ID',
                description = tostring(data.serverid),
                icon = '🖥️'
            },
            {
                id = 'job',
                title = 'Job',
                description = data.job .. ' (Grade: ' .. data.grade .. ')',
                icon = '💼'
            },
            {
                id = 'cash',
                title = 'Cash',
                description = '$' .. tostring(data.cash),
                icon = '💵'
            },
            {
                id = 'bank',
                title = 'Bank',
                description = '$' .. tostring(data.bank),
                icon = '🏦'
            },
            {
                id = 'bloodmoney',
                title = 'Blood Money',
                description = '$' .. tostring(data.bloodmoney),
                icon = '🩸'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)
