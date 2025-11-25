local RSGCore = exports['rsg-core']:GetCoreObject()

-- Permission Check
local function HasAdminPermission(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local adminJobs = { 'admin', 'god' }
    for _, job in pairs(adminJobs) do
        if Player.PlayerData.job.name == job then
            return true
        end
    end
    
    return false
end

-------------------------------------------------------------------
-- Give Item to Player
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:server:giveItem', function(targetId, itemName, amount)
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
    
    -- Validate item exists
    if not RSGCore.Shared.Items[itemName] then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Invalid item: ' .. itemName,
            type = 'error'
        })
        return
    end
    
    -- Give item
    local success = Player.Functions.AddItem(itemName, amount)
    
    if success then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Give Item',
            description = 'Gave ' .. amount .. 'x ' .. RSGCore.Shared.Items[itemName].label .. ' to ' .. GetPlayerName(targetId),
            type = 'success'
        })
        
        TriggerClientEvent('ox_lib:notify', targetId, {
            title = 'Admin',
            description = 'You received ' .. amount .. 'x ' .. RSGCore.Shared.Items[itemName].label,
            type = 'inform'
        })
        
        -- Log action
        print('^3[QC-DevTools Admin]^0 ' .. GetPlayerName(src) .. ' gave ' .. amount .. 'x ' .. itemName .. ' to ' .. GetPlayerName(targetId))
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Failed to give item (inventory full?)',
            type = 'error'
        })
    end
end)

-------------------------------------------------------------------
-- Open Player Inventory
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:server:openInventory', function(targetId)
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
    
    -- Check if rsg-inventory is running
    if GetResourceState('rsg-inventory') == 'started' then
        -- Use rsg-inventory open other inventory
        TriggerClientEvent('rsg-inventory:client:openOtherInventory', src, targetId)
    else
        -- Fallback: Show inventory data as notification
        local inventory = Player.PlayerData.items or {}
        local itemList = {}
        
        for slot, item in pairs(inventory) do
            if item and item.name then
                table.insert(itemList, item.amount .. 'x ' .. (RSGCore.Shared.Items[item.name].label or item.name))
            end
        end
        
        if #itemList > 0 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = GetPlayerName(targetId) .. '\'s Inventory',
                description = table.concat(itemList, '\n'),
                type = 'inform',
                duration = 10000
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Inventory',
                description = 'Player inventory is empty!',
                type = 'inform'
            })
        end
    end
    
    -- Log action
    print('^3[QC-DevTools Admin]^0 ' .. GetPlayerName(src) .. ' viewed inventory of ' .. GetPlayerName(targetId))
end)

-------------------------------------------------------------------
-- Get Players with Coords (for blips)
-------------------------------------------------------------------
RSGCore.Functions.CreateCallback('qc-devtools:server:getPlayersWithCoords', function(source, cb)
    if not HasAdminPermission(source) then
        cb({})
        return
    end
    
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        local Player = RSGCore.Functions.GetPlayer(tonumber(playerId))
        if Player then
            local ped = GetPlayerPed(playerId)
            local coords = GetEntityCoords(ped)
            
            table.insert(players, {
                id = tonumber(playerId),
                name = GetPlayerName(playerId),
                citizenid = Player.PlayerData.citizenid,
                coords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z
                }
            })
        end
    end
    
    cb(players)
end)

print('^2[QC-DevTools]^0 Advanced admin server module loaded successfully!')
