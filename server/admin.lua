local RSGCore = exports['rsg-core']:GetCoreObject()

-- Permission Check (matches rsg-adminmenu system)
local function HasAdminPermission(source)
    print('[QC-DevTools] Permission check for', GetPlayerName(source))
    
    -- Check RSGCore permission system
    if RSGCore.Functions.HasPermission(source, 'admin') then
        print('[QC-DevTools] Permission GRANTED - RSGCore permission')
        return true
    end
    
    -- Check ACE permissions (server.cfg)
    if IsPlayerAceAllowed(source, 'command') then
        print('[QC-DevTools] Permission GRANTED - ACE permission')
        return true
    end
    
    print('[QC-DevTools] Permission DENIED - No admin or ACE permission')
    return false
end

-- Get Online Players
RSGCore.Functions.CreateCallback('qc-devtools:server:getPlayers', function(source, cb)
    if not HasAdminPermission(source) then
        cb({})
        return
    end
    
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        local Player = RSGCore.Functions.GetPlayer(tonumber(playerId))
        if Player then
            table.insert(players, {
                id = tonumber(playerId),
                name = GetPlayerName(playerId),
                citizenid = Player.PlayerData.citizenid
            })
        end
    end
    
    cb(players)
end)

-- Get Player Info
RegisterNetEvent('qc-devtools:server:getPlayerInfo', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'No permission!',
            type = 'error'
        })
        return
    end
    
    local Player = RSGCore.Functions.GetPlayer(targetId)
    if not Player then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Player not found!',
            type = 'error'
        })
        return
    end
    
    local data = {
        name = GetPlayerName(targetId),
        firstname = Player.PlayerData.charinfo.firstname,
        lastname = Player.PlayerData.charinfo.lastname,
        citizenid = Player.PlayerData.citizenid,
        serverid = targetId,
        job = Player.PlayerData.job.label,
        grade = Player.PlayerData.job.grade.level,
        cash = Player.PlayerData.money.cash or 0,
        bank = Player.PlayerData.money.bank or 0,
        bloodmoney = Player.PlayerData.money.bloodmoney or 0
    }
    
    TriggerClientEvent('qc-devtools:client:displayPlayerInfo', src, data)
end)

-- Teleport To Player
RegisterNetEvent('qc-devtools:server:teleportToPlayer', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local targetPed = GetPlayerPed(targetId)
    if targetPed == 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Player not found!',
            type = 'error'
        })
        return
    end
    
    local targetCoords = GetEntityCoords(targetPed)
    SetEntityCoords(GetPlayerPed(src), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Teleport',
        description = 'Teleported to player!',
        type = 'success'
    })
end)

-- Bring Player
RegisterNetEvent('qc-devtools:server:bringPlayer', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local adminPed = GetPlayerPed(src)
    local adminCoords = GetEntityCoords(adminPed)
    
    SetEntityCoords(GetPlayerPed(targetId), adminCoords.x, adminCoords.y, adminCoords.z, false, false, false, false)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Bring Player',
        description = 'Player brought to you!',
        type = 'success'
    })
    
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Admin',
        description = 'You have been teleported by an admin!',
        type = 'inform'
    })
end)

-- Freeze Player
local frozenPlayers = {}

RegisterNetEvent('qc-devtools:server:freezePlayer', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    frozenPlayers[targetId] = not frozenPlayers[targetId]
    
    TriggerClientEvent('qc-devtools:client:freezePlayer', targetId, frozenPlayers[targetId])
    
    local status = frozenPlayers[targetId] and 'frozen' or 'unfrozen'
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Freeze Player',
        description = 'Player ' .. status .. '!',
        type = 'success'
    })
end)

-- Revive Player
RegisterNetEvent('qc-devtools:server:revivePlayer', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    -- Support both rsg-medic and qc-medic
    if GetResourceState('rsg-medic') == 'started' then
        TriggerClientEvent('rsg-medic:client:adminRevive', targetId)
    elseif GetResourceState('QC-AdvancedMedic') == 'started' then
        TriggerClientEvent('QC-AdvancedMedic:Client:AdminRevive', targetId)
    else
        -- Fallback to direct revive if no medic script
        TriggerClientEvent('qc-devtools:client:directRevive', targetId)
    end
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Revive',
        description = 'Player revived!',
        type = 'success'
    })
    
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Admin',
        description = 'You have been revived by an admin!',
        type = 'success'
    })
end)

-- Money Management
RegisterNetEvent('qc-devtools:server:manageMoney', function(targetId, action, moneyType, amount)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local Player = RSGCore.Functions.GetPlayer(targetId)
    if not Player then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Player not found!',
            type = 'error'
        })
        return
    end
    
    if action == 'add' then
        Player.Functions.AddMoney(moneyType, amount, 'Admin gave money')
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Money',
            description = 'Added $' .. amount .. ' ' .. moneyType,
            type = 'success'
        })
    elseif action == 'remove' then
        Player.Functions.RemoveMoney(moneyType, amount, 'Admin removed money')
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Money',
            description = 'Removed $' .. amount .. ' ' .. moneyType,
            type = 'success'
        })
    end
    
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Admin',
        description = 'Your money was modified by an admin!',
        type = 'inform'
    })
end)

-- Kick Player
RegisterNetEvent('qc-devtools:server:kickPlayer', function(targetId, reason)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local adminName = GetPlayerName(src)
    
    DropPlayer(targetId, '⚠️ Kicked by Admin\n👤 Admin: ' .. adminName .. '\n📝 Reason: ' .. reason)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Kick',
        description = 'Player kicked successfully!',
        type = 'success'
    })
    
    -- Log to discord/console
    print('^3[QC-DevTools Admin]^0 ' .. adminName .. ' kicked player ' .. targetId .. ' | Reason: ' .. reason)
end)

-- Ban Player
RegisterNetEvent('qc-devtools:server:banPlayer', function(targetId, reason, duration)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local Player = RSGCore.Functions.GetPlayer(targetId)
    if not Player then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Player not found!',
            type = 'error'
        })
        return
    end
    
    local adminName = GetPlayerName(src)
    local banTime = duration > 0 and (os.time() + (duration * 3600)) or 9999999999
    
    -- Ban using RSGCore ban system
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(targetId),
        Player.PlayerData.license,
        Player.PlayerData.discord or '',
        Player.PlayerData.ip,
        reason,
        banTime,
        adminName
    })
    
    DropPlayer(targetId, '🔨 Banned from Server\n👤 Banned by: ' .. adminName .. '\n📝 Reason: ' .. reason .. '\n⏰ Duration: ' .. (duration > 0 and duration .. ' hours' or 'Permanent'))
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Ban',
        description = 'Player banned successfully!',
        type = 'success'
    })
    
    -- Log
    print('^1[QC-DevTools Admin]^0 ' .. adminName .. ' banned player ' .. targetId .. ' | Reason: ' .. reason .. ' | Duration: ' .. (duration > 0 and duration .. 'h' or 'Permanent'))
end)

-- Weather Control
RegisterNetEvent('qc-devtools:server:setWeather', function(weather)
    local src = source
    
    -- Trim whitespace from weather string
    if type(weather) == 'string' then
        weather = weather:match("^%s*(.-)%s*$")
    end
    
    if not HasAdminPermission(src) then 
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'No permission!',
            type = 'error'
        })
        return 
    end
    
    local adminName = GetPlayerName(src)
    
    -- Priority 1: Use weathersync (RSG Framework official weather system)
    if GetResourceState('weathersync') == 'started' then
        -- Convert weather to lowercase for weathersync
        local weatherLower = weather:lower()
        
        -- Use weathersync export (supports transition time, freeze, permanentSnow)
        exports['weathersync']:setWeather(weatherLower, 10.0, false, false)
        
        TriggerClientEvent('ox_lib:notify', -1, {
            title = 'Weather Changed',
            description = 'Weather set to ' .. weather .. ' by ' .. adminName,
            type = 'inform'
        })
        
        print('^3[QC-DevTools]^0 ' .. adminName .. ' changed weather to: ' .. weather .. ' (via weathersync)')
    else
        -- Fallback: Direct client-side weather change
        TriggerClientEvent('qc-devtools:client:setWeather', -1, weather)
        
        TriggerClientEvent('ox_lib:notify', -1, {
            title = 'Weather Changed',
            description = 'Weather set to ' .. weather .. ' by ' .. adminName,
            type = 'inform'
        })
        
        print('^3[QC-DevTools]^0 ' .. adminName .. ' changed weather to: ' .. weather .. ' (direct)')
    end
end)

-- Time Control
RegisterNetEvent('qc-devtools:server:setTime', function(hour, minute)
    local src = source
    
    if not HasAdminPermission(src) then 
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'No permission!',
            type = 'error'
        })
        return 
    end
    
    local adminName = GetPlayerName(src)
    
    -- Priority 1: Use weathersync (RSG Framework official time system)
    if GetResourceState('weathersync') == 'started' then
        -- weathersync setTime(day, hour, minute, second, transition, freeze)
        -- We'll use current day (0), set hour/minute, 0 seconds, 0 transition, false freeze
        exports['weathersync']:setTime(0, hour, minute, 0, 0, false)
        
        TriggerClientEvent('ox_lib:notify', -1, {
            title = 'Time Changed',
            description = 'Time set to ' .. string.format('%02d:%02d', hour, minute) .. ' by ' .. adminName,
            type = 'inform'
        })
        
        print('^3[QC-DevTools]^0 ' .. adminName .. ' changed time to: ' .. string.format('%02d:%02d', hour, minute) .. ' (via weathersync)')
    else
        -- Fallback: Direct client-side time change
        TriggerClientEvent('qc-devtools:client:setTime', -1, hour, minute)
        
        TriggerClientEvent('ox_lib:notify', -1, {
            title = 'Time Changed',
            description = 'Time set to ' .. string.format('%02d:%02d', hour, minute) .. ' by ' .. adminName,
            type = 'inform'
        })
        
        print('^3[QC-DevTools]^0 ' .. adminName .. ' changed time to: ' .. string.format('%02d:%02d', hour, minute) .. ' (direct)')
    end
end)

-- Server Announcement
RegisterNetEvent('qc-devtools:server:announce', function(message)
    local src = source
    
    print('[QC-DevTools Server] Announcement requested by', GetPlayerName(src))
    print('[QC-DevTools Server] Message:', message)
    
    if not HasAdminPermission(src) then 
        print('[QC-DevTools Server] Permission denied')
        return 
    end
    
    print('[QC-DevTools Server] Sending announcement to all players')
    
    TriggerClientEvent('ox_lib:notify', -1, {
        title = '📢 Server Announcement',
        description = message,
        type = 'inform',
        duration = 10000
    })
    
    print('[QC-DevTools Server] Announcement sent!')
end)

print('^2[QC-DevTools]^0 Admin server module loaded successfully!')
