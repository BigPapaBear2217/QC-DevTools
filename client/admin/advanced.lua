local RSGCore = exports['rsg-core']:GetCoreObject()

-- Advanced Admin Features
-- Give Item, Player Blips, Inventory View, Player IDs, Reports

-------------------------------------------------------------------
-- Player Blips System
-------------------------------------------------------------------
local playerBlipsEnabled = false
local playerBlips = {}
local blipUpdateThread = nil

RegisterNetEvent('qc-devtools:client:togglePlayerBlips', function()
    playerBlipsEnabled = not playerBlipsEnabled
    
    if playerBlipsEnabled then
        lib.notify({ 
            title = 'Player Blips', 
            description = 'Player blips enabled! All players now visible on map.', 
            type = 'success' 
        })
        
        if not blipUpdateThread then
            blipUpdateThread = CreateThread(function()
                while playerBlipsEnabled do
                    Wait(1000)
                    RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
                        local myId = PlayerId()
                        
                        for _, player in pairs(players) do
                            if player.id ~= GetPlayerServerId(myId) then
                                if not playerBlips[player.id] then
                                    -- Create new blip
                                    local blip = BlipAddForCoords(1664425300, player.coords.x, player.coords.y, player.coords.z)
                                    SetBlipSprite(blip, GetHashKey('blip_ambient_companion'))
                                    SetBlipScale(blip, 0.6)
                                    local steamName = GetPlayerName(GetPlayerFromServerId(player.id))
                                    SetBlipName(blip, 'ID: ' .. player.id .. ' ' .. steamName)
                                    playerBlips[player.id] = blip
                                else
                                    -- Update existing blip position
                                    SetBlipCoords(playerBlips[player.id], player.coords.x, player.coords.y, player.coords.z)
                                end
                            end
                        end
                        
                        -- Remove blips for disconnected players
                        for blipId, blip in pairs(playerBlips) do
                            local found = false
                            for _, player in pairs(players) do
                                if player.id == blipId then
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                RemoveBlip(blip)
                                playerBlips[blipId] = nil
                            end
                        end
                    end)
                end
                blipUpdateThread = nil
            end)
        end
    else
        lib.notify({ 
            title = 'Player Blips', 
            description = 'Player blips disabled!', 
            type = 'inform' 
        })
        
        -- Remove all blips
        for _, blip in pairs(playerBlips) do
            RemoveBlip(blip)
        end
        playerBlips = {}
    end
end)

-------------------------------------------------------------------
-- Toggle Player IDs (Above Heads)
-------------------------------------------------------------------
local playerIDsEnabled = false

RegisterNetEvent('qc-devtools:client:togglePlayerIDs', function()
    -- Try txAdmin command first
    if GetResourceState('monitor') == 'started' then
        ExecuteCommand('txAdmin:menu:togglePlayerIDs')
    else
        -- Fallback: Custom implementation
        playerIDsEnabled = not playerIDsEnabled
        
        if playerIDsEnabled then
            lib.notify({ 
                title = 'Player IDs', 
                description = 'Player IDs enabled! (Custom implementation)', 
                type = 'success' 
            })
            
            CreateThread(function()
                while playerIDsEnabled do
                    Wait(0)
                    local players = GetActivePlayers()
                    for _, playerId in ipairs(players) do
                        local ped = GetPlayerPed(playerId)
                        local serverId = GetPlayerServerId(playerId)
                        local coords = GetEntityCoords(ped)
                        local _, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + 1.0)
                        
                        if x and y then
                            SetTextScale(0.35, 0.35)
                            SetTextFont(4)
                            SetTextProportional(true)
                            SetTextColour(255, 255, 255, 215)
                            SetTextOutline()
                            SetTextEntry("STRING")
                            AddTextComponentString("ID: " .. serverId)
                            DrawText(x, y)
                        end
                    end
                end
            end)
        else
            lib.notify({ 
                title = 'Player IDs', 
                description = 'Player IDs disabled!', 
                type = 'inform' 
            })
        end
    end
end)

-------------------------------------------------------------------
-- Give Item Feature
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:client:giveItem', function(targetId, targetName)
    -- Step 1: Search for item
    local searchInput = lib.inputDialog('🎁 Give Item to ' .. targetName, {
        {
            type = 'input',
            label = 'Search Item',
            description = 'Enter item name or part of it',
            placeholder = 'e.g. revolver, bandage, consumable_coffee',
            required = true
        }
    })
    
    if not searchInput then return end
    
    local keyword = searchInput[1]:lower()
    
    -- Step 2: Filter items from RSGCore.Shared.Items
    local items = RSGCore.Shared.Items
    local options = {}
    
    for itemName, itemData in pairs(items) do
        local label = itemData.label or itemName
        if label:lower():find(keyword, 1, true) or itemName:lower():find(keyword, 1, true) then
            options[#options + 1] = {
                value = itemName,
                label = label .. ' (' .. itemName .. ')'
            }
        end
    end
    
    if #options == 0 then
        lib.notify({ 
            title = 'Give Item', 
            description = 'No items found matching "' .. keyword .. '"', 
            type = 'error' 
        })
        return
    end
    
    -- Sort alphabetically
    table.sort(options, function(a, b) return a.label < b.label end)
    
    -- Step 3: Select item and amount
    local result = lib.inputDialog('Select Item and Amount', {
        {
            type = 'select',
            label = 'Item',
            description = 'Select the item to give',
            options = options,
            required = true,
            searchable = true
        },
        {
            type = 'number',
            label = 'Amount',
            description = 'How many to give',
            required = true,
            min = 1,
            max = 999,
            default = 1
        }
    })
    
    if not result then return end
    
    -- Step 4: Give item via server
    TriggerServerEvent('qc-devtools:server:giveItem', targetId, result[1], result[2])
end)

-------------------------------------------------------------------
-- View Player Inventory
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:client:viewInventory', function(targetId, targetName)
    TriggerServerEvent('qc-devtools:server:openInventory', targetId)
end)

-------------------------------------------------------------------
-- Advanced Options Menu
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:client:advancedOptions', function()
    local menuData = {
        id = 'admin_advanced_menu',
        title = '🔧 Advanced Admin Tools',
        subtitle = 'Extra admin features',
        back = 'qc_admin_main',
        options = {
            {
                id = 'player_blips',
                title = playerBlipsEnabled and '✅ Player Blips (ON)' or '❌ Player Blips (OFF)',
                description = 'Show all players on map with real-time updates',
                icon = '🗺️'
            },
            {
                id = 'player_ids',
                title = '🆔 Toggle Player IDs',
                description = 'Show player IDs above their heads',
                icon = '👁️'
            },
            {
                id = 'give_item',
                title = '🎁 Give Item',
                description = 'Search and give items to players (or yourself)',
                icon = '📦'
            },
            {
                id = 'give_item_self',
                title = '🎁 Give Item to Self',
                description = 'Quickly give items to yourself',
                icon = '💼'
            },
            {
                id = 'view_inventory',
                title = '📦 View Inventory',
                description = 'View any player\'s inventory',
                icon = '👀'
            },
            {
                id = 'view_inventory_self',
                title = '📦 View My Inventory',
                description = 'Check your own inventory',
                icon = '🎒'
            },
            {
                id = 'reports',
                title = '📋 Reports System',
                description = 'View and manage player reports',
                icon = '📝'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle advanced menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_advanced_menu' then
        if optionId == 'player_blips' then
            TriggerEvent('qc-devtools:client:togglePlayerBlips')
            -- Refresh menu to show updated state
            Wait(100)
            TriggerEvent('qc-devtools:client:advancedOptions')
        elseif optionId == 'player_ids' then
            TriggerEvent('qc-devtools:client:togglePlayerIDs')
        elseif optionId == 'give_item' then
            -- Open player selection for give item
            TriggerEvent('qc-devtools:client:selectPlayerForGiveItem')
        elseif optionId == 'give_item_self' then
            -- Give item to self directly
            TriggerEvent('qc-devtools:client:giveItem', GetPlayerServerId(PlayerId()), GetPlayerName(PlayerId()))
        elseif optionId == 'view_inventory' then
            -- Open player selection for inventory view
            TriggerEvent('qc-devtools:client:selectPlayerForInventory')
        elseif optionId == 'view_inventory_self' then
            -- View own inventory
            TriggerEvent('qc-devtools:client:viewInventory', GetPlayerServerId(PlayerId()), 'Yourself')
        elseif optionId == 'reports' then
            TriggerEvent('qc-devtools:client:openReports')
        end
    end
end)

-------------------------------------------------------------------
-- Player Selection for Give Item
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:client:selectPlayerForGiveItem', function()
    RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
        if not players or #players == 0 then
            lib.notify({ title = 'Give Item', description = 'No players online!', type = 'error' })
            return
        end
        
        local options = {}
        for _, player in pairs(players) do
            table.insert(options, {
                id = 'giveitem_player_' .. player.id,
                title = player.name,
                description = 'ID: ' .. player.id .. ' | Give item to this player',
                icon = '🎁'
            })
        end
        
        local menuData = {
            id = 'giveitem_players_menu',
            title = '🎁 Select Player',
            subtitle = 'Choose player to give item',
            back = 'admin_advanced_menu',
            options = options
        }
        ShowDevToolsMenu(menuData)
    end)
end)

-- Handle give item player selection
local giveItemPlayers = {}
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'giveitem_players_menu' then
        local playerId = tonumber(optionId:match('giveitem_player_(%d+)'))
        if playerId then
            -- Get player data
            RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
                for _, player in pairs(players) do
                    if player.id == playerId then
                        TriggerEvent('qc-devtools:client:giveItem', player.id, player.name)
                        break
                    end
                end
            end)
        end
    end
end)

-------------------------------------------------------------------
-- Player Selection for Inventory View
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:client:selectPlayerForInventory', function()
    RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
        if not players or #players == 0 then
            lib.notify({ title = 'View Inventory', description = 'No players online!', type = 'error' })
            return
        end
        
        local options = {}
        for _, player in pairs(players) do
            table.insert(options, {
                id = 'viewinv_player_' .. player.id,
                title = player.name,
                description = 'ID: ' .. player.id .. ' | View this player\'s inventory',
                icon = '📦'
            })
        end
        
        local menuData = {
            id = 'viewinv_players_menu',
            title = '📦 Select Player',
            subtitle = 'Choose player to view inventory',
            back = 'admin_advanced_menu',
            options = options
        }
        ShowDevToolsMenu(menuData)
    end)
end)

-- Handle inventory view player selection
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'viewinv_players_menu' then
        local playerId = tonumber(optionId:match('viewinv_player_(%d+)'))
        if playerId then
            RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
                for _, player in pairs(players) do
                    if player.id == playerId then
                        TriggerEvent('qc-devtools:client:viewInventory', player.id, player.name)
                        break
                    end
                end
            end)
        end
    end
end)

print('^2[QC-DevTools]^0 Advanced admin features loaded successfully!')
