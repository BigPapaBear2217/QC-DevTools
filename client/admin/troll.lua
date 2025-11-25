-- Store troll players list
local trollPlayersList = {}

-- Troll Players Menu
RegisterNetEvent('qc-devtools:client:admin_troll_menu', function()
    local RSGCore = exports['rsg-core']:GetCoreObject()
    
    RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
        if not players or #players == 0 then
            lib.notify({ title = 'Admin', description = 'No players online!', type = 'error' })
            return
        end
        
        trollPlayersList = players -- Store for later use
        
        local options = {}
        for _, player in pairs(players) do
            table.insert(options, {
                id = 'troll_player_' .. player.id,
                title = player.name,
                description = 'ID: ' .. player.id .. ' | Troll this player',
                icon = '😈'
            })
        end
        
        local menuData = {
            id = 'admin_troll_menu',
            title = '😈 Troll Players',
            subtitle = 'Fun troll options',
            back = 'qc_admin_main',
            options = options
        }
        ShowDevToolsMenu(menuData)
    end)
end)

-- Handle troll players menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_troll_menu' then
        -- Extract player ID from option ID (format: troll_player_123)
        local playerId = tonumber(optionId:match('troll_player_(%d+)'))
        if playerId then
            -- Find player in stored list
            for _, player in pairs(trollPlayersList) do
                if player.id == playerId then
                    TriggerEvent('qc-devtools:client:admin_troll_options', player)
                    break
                end
            end
        end
    end
end)

-- Store selected troll target for event handlers
local trollTarget = nil

-- Troll Options for Specific Player
RegisterNetEvent('qc-devtools:client:admin_troll_options', function(player)
    trollTarget = player -- Store for later use
    
    local menuData = {
        id = 'admin_troll_options',
        title = '😈 Troll: ' .. player.name,
        subtitle = 'Select troll action',
        back = 'admin_troll_menu',
        options = {
            {
                id = 'wild_attack',
                title = '🐻 Wild Animal Attack',
                description = 'Send a wild animal to attack player',
                icon = '🐺'
            },
            {
                id = 'set_fire',
                title = '🔥 Set on Fire',
                description = 'Set player on fire',
                icon = '🔥'
            },
            {
                id = 'ragdoll',
                title = '🤸 Ragdoll',
                description = 'Make player ragdoll',
                icon = '💫'
            },
            {
                id = 'drunk',
                title = '🍺 Make Drunk',
                description = 'Apply drunk screen effect',
                icon = '🍻'
            },
            {
                id = 'explode',
                title = '💥 Explode',
                description = 'Create explosion at player',
                icon = '💣'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle troll options menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_troll_options' and trollTarget then
        if optionId == 'wild_attack' then
            TriggerServerEvent('qc-devtools:server:wildAttack', trollTarget.id)
        elseif optionId == 'set_fire' then
            TriggerServerEvent('qc-devtools:server:setFire', trollTarget.id)
        elseif optionId == 'ragdoll' then
            TriggerServerEvent('qc-devtools:server:ragdoll', trollTarget.id)
        elseif optionId == 'drunk' then
            TriggerServerEvent('qc-devtools:server:makeDrunk', trollTarget.id)
        elseif optionId == 'explode' then
            TriggerServerEvent('qc-devtools:server:explodePlayer', trollTarget.id)
        end
    end
end)

-- Wild Animal Attack (Client)
RegisterNetEvent('qc-devtools:client:wildAttack', function()
    local attackAnimals = {
        joaat("a_c_wolf_small"),
        joaat("a_c_bearblack_01"),
        joaat("a_c_dogrufus_01")
    }
    
    local animalHash = attackAnimals[math.random(#attackAnimals)]
    local playerPed = cache.ped
    local coordsBehindPlayer = GetOffsetFromEntityInWorldCoords(playerPed, 100, -15.0, 0)
    local playerHeading = GetEntityHeading(playerPed)
    local belowGround, groundZ = GetGroundZAndNormalFor_3dCoord(coordsBehindPlayer.x, coordsBehindPlayer.y, coordsBehindPlayer.z)
    
    RequestModel(animalHash)
    while not HasModelLoaded(animalHash) do
        Wait(15)
    end
    
    local animalPed = CreatePed(animalHash, coordsBehindPlayer.x, coordsBehindPlayer.y, groundZ, playerHeading, true, false)
    EquipMetaPedOutfitPreset(animalPed, 1, 0)
    
    local animalGroupHash = joaat("Animal")
    local playerGroupHash = joaat("PLAYER")
    
    SetPedFleeAttributes(animalPed, 0, 0)
    SetPedRelationshipGroupHash(animalPed, animalGroupHash)
    TaskSetBlockingOfNonTemporaryEvents(animalPed, true)
    TaskCombatHatedTargetsAroundPed(animalPed, 30.0, 0)
    ClearPedTasks(animalPed)
    TaskPutPedDirectlyIntoMelee(animalPed, playerPed, 0.0, -1.0, 0.0, 0)
    SetRelationshipBetweenGroups(5, animalGroupHash, playerGroupHash)
    SetRelationshipBetweenGroups(5, playerGroupHash, animalGroupHash)
    SetModelAsNoLongerNeeded(animalHash)
    
    lib.notify({
        title = 'Admin Troll',
        description = '🐻 A wild animal is attacking you!',
        type = 'error',
        duration = 5000
    })
end)

-- Set on Fire (Client)
RegisterNetEvent('qc-devtools:client:setFire', function()
    StartEntityFire(cache.ped)
    lib.notify({
        title = 'Admin Troll',
        description = '🔥 You are on fire!',
        type = 'error'
    })
end)

-- Ragdoll (Client)
RegisterNetEvent('qc-devtools:client:ragdoll', function()
    SetPedToRagdoll(cache.ped, 5000, 5000, 0, 0, 0, 0)
    lib.notify({
        title = 'Admin Troll',
        description = '💫 You feel dizzy!',
        type = 'error'
    })
end)

-- Make Drunk (Client)
RegisterNetEvent('qc-devtools:client:makeDrunk', function()
    -- Apply drunk effect
    SetPedIsDrunk(cache.ped, true)
    
    -- Screen effect
    local drunkEffect = "DrugsMichaelAliensFight"
    RequestAnimPostfxDict(drunkEffect)
    while not HasAnimPostfxLoaded(drunkEffect) do
        Wait(10)
    end
    
    AnimPostFxPlay(drunkEffect, -1, false)
    
    lib.notify({
        title = 'Admin Troll',
        description = '🍺 You feel very drunk!',
        type = 'error',
        duration = 5000
    })
    
    -- Clear after 30 seconds
    SetTimeout(30000, function()
        AnimPostFxStop(drunkEffect)
        SetPedIsDrunk(cache.ped, false)
    end)
end)

-- Explode Player (Client)
RegisterNetEvent('qc-devtools:client:explode', function()
    local coords = GetEntityCoords(cache.ped)
    AddExplosion(coords.x, coords.y, coords.z, 2, 0.5, true, false, 1.0)
    
    lib.notify({
        title = 'Admin Troll',
        description = '💥 BOOM!',
        type = 'error'
    })
end)
