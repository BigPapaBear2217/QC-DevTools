local RSGCore = exports['rsg-core']:GetCoreObject()

-- Variables
local godmode = false
local invisible = false
local noclip = false

-- Admin Main Menu
RegisterNetEvent('qc-devtools:client:openadminmenu', function()
    local menuData = {
        id = 'qc_admin_main',
        title = '🛡️ Admin Menu',
        subtitle = 'Complete Administration System',
        options = {
            {
                id = 'admin_self',
                title = '👤 Self Options',
                description = 'God mode, invisibility, teleport, etc.',
                icon = '🛡️'
            },
            {
                id = 'admin_players',
                title = '👥 Player Management',
                description = 'View, manage, and moderate players',
                icon = '👥'
            },
            {
                id = 'admin_vehicle',
                title = '🐴 Vehicle/Horse',
                description = 'Spawn admin horses and vehicles',
                icon = '🐴'
            },
            {
                id = 'admin_server',
                title = '🌍 Server Options',
                description = 'Weather, time, announcements',
                icon = '🌍'
            },
            {
                id = 'admin_troll',
                title = '😈 Troll Players',
                description = 'Fun troll options for players',
                icon = '😈'
            },
            {
                id = 'admin_advanced',
                title = '🔧 Advanced Tools',
                description = 'Give items, player blips, reports, etc.',
                icon = '⚙️'
            },
            {
                id = 'devtools_back',
                title = '🔧 Back to Dev Tools',
                description = 'Return to main dev tools menu',
                icon = '◀️'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle admin menu selections
RegisterNetEvent('qc-devtools:nui:optionSelected')
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'qc_admin_main' then
        if optionId == 'admin_self' then
            TriggerEvent('qc-devtools:client:admin_self_menu')
        elseif optionId == 'admin_players' then
            TriggerEvent('qc-devtools:client:admin_players_menu')
        elseif optionId == 'admin_vehicle' then
            TriggerEvent('qc-devtools:client:admin_vehicle_menu')
        elseif optionId == 'admin_server' then
            TriggerEvent('qc-devtools:client:admin_server_menu')
        elseif optionId == 'admin_troll' then
            TriggerEvent('qc-devtools:client:admin_troll_menu')
        elseif optionId == 'admin_advanced' then
            TriggerEvent('qc-devtools:client:advancedOptions')
        elseif optionId == 'devtools_back' then
            TriggerEvent('qc-devtools:client:openMain')
        end
    end
end)

-- Self Options Menu
RegisterNetEvent('qc-devtools:client:admin_self_menu', function()
    local menuData = {
        id = 'admin_self_menu',
        title = '👤 Self Options',
        subtitle = 'Personal admin controls',
        back = 'qc_admin_main',
        options = {
            {
                id = 'godmode',
                title = godmode and '✅ God Mode (ON)' or '❌ God Mode (OFF)',
                description = 'Toggle invincibility',
                icon = '🛡️'
            },
            {
                id = 'invisible',
                title = invisible and '✅ Invisibility (ON)' or '❌ Invisibility (OFF)',
                description = 'Toggle visibility',
                icon = '👻'
            },
            {
                id = 'noclip',
                title = noclip and '✅ Noclip (ON)' or '❌ Noclip (OFF)',
                description = 'Toggle noclip mode',
                icon = '🚀'
            },
            {
                id = 'revive',
                title = '❤️ Revive Self',
                description = 'Fully heal yourself',
                icon = '💊'
            },
            {
                id = 'teleport_waypoint',
                title = '📍 Teleport to Waypoint',
                description = 'Teleport to your map marker',
                icon = '🎯'
            },
            {
                id = 'coords',
                title = '📊 Copy Coordinates',
                description = 'Copy your current coordinates',
                icon = '📐'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle self options menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_self_menu' then
        if optionId == 'godmode' then
            TriggerEvent('qc-devtools:client:togglegodmode')
        elseif optionId == 'invisible' then
            TriggerEvent('qc-devtools:client:toggleinvisible')
        elseif optionId == 'noclip' then
            TriggerEvent('qc-devtools:client:togglenoclip')
        elseif optionId == 'revive' then
            -- Support both rsg-medic and qc-medic (or fallback to direct natives)
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            
            print('[QC-DevTools] Revive Self clicked - Resource checks:')
            print('  rsg-medic:', GetResourceState('rsg-medic'))
            print('  QC-AdvancedMedic:', GetResourceState('QC-AdvancedMedic'))
            
            -- Try rsg-medic first
            if GetResourceState('rsg-medic') == 'started' then
                print('[QC-DevTools] Using rsg-medic revive')
                TriggerEvent('rsg-medic:client:playerRevive')
                lib.notify({ title = 'Admin', description = 'Reviving with rsg-medic...', type = 'success' })
            elseif GetResourceState('QC-AdvancedMedic') == 'started' then
                print('[QC-DevTools] Using QC-AdvancedMedic adminRevive')
                TriggerEvent('QC-AdvancedMedic:client:adminRevive')
                lib.notify({ title = 'Admin', description = 'Reviving with QC-AdvancedMedic...', type = 'success' })
            else
                -- Direct fallback implementation
                print('[QC-DevTools] Using direct fallback revive')
                lib.notify({ title = 'Admin', description = 'Reviving (direct)...', type = 'inform' })
                
                DoScreenFadeOut(500)
                Wait(500)
                
                -- Resurrect player
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, heading, true, false)
                
                -- Set health and cores
                SetEntityInvincible(ped, false)
                SetEntityHealth(ped, GetEntityMaxHealth(ped))
                ClearPedBloodDamage(ped)
                
                -- Restore cores (Health and Stamina)
                Citizen.InvokeNative(0xC6258F41D86676E0, ped, 0, 100.0) -- Health core
                Citizen.InvokeNative(0xC6258F41D86676E0, ped, 1, 100.0) -- Stamina core
                
                -- Set attributes
                Citizen.InvokeNative(0x4AF5A4C7B9157D14, ped, 0, 100.0) -- Health
                Citizen.InvokeNative(0x4AF5A4C7B9157D14, ped, 1, 100.0) -- Stamina
                
                -- Reset death state
                TriggerServerEvent("RSGCore:Server:SetMetaData", "isdead", false)
                LocalPlayer.state:set('isDead', false, true)
                
                Wait(500)
                DoScreenFadeIn(1000)
                
                lib.notify({ title = 'Admin', description = 'You have been revived!', type = 'success' })
            end
        elseif optionId == 'teleport_waypoint' then
            -- Use RSG Core teleport event
            TriggerEvent('RSGCore:Command:GoToMarker')
        elseif optionId == 'coords' then
            TriggerEvent('qc-devtools:client:admin_coords_menu')
        end
    end
end)

-- Coordinates Menu
RegisterNetEvent('qc-devtools:client:admin_coords_menu', function()
    local coords = GetEntityCoords(cache.ped)
    local heading = GetEntityHeading(cache.ped)
    
    local menuData = {
        id = 'admin_coords_menu',
        title = '📊 Coordinates',
        subtitle = 'Copy coordinate formats',
        back = 'admin_self_menu',
        options = {
            {
                id = 'vec2',
                title = 'Vector2',
                description = string.format('vec2(%.2f, %.2f)', coords.x, coords.y),
                icon = '📋'
            },
            {
                id = 'vec3',
                title = 'Vector3',
                description = string.format('vec3(%.2f, %.2f, %.2f)', coords.x, coords.y, coords.z),
                icon = '📋'
            },
            {
                id = 'vec4',
                title = 'Vector4',
                description = string.format('vec4(%.2f, %.2f, %.2f, %.2f)', coords.x, coords.y, coords.z, heading),
                icon = '📋'
            },
            {
                id = 'heading',
                title = 'Heading Only',
                description = string.format('%.2f', heading),
                icon = '📋'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle coords menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_coords_menu' then
        local coords = GetEntityCoords(cache.ped)
        local heading = GetEntityHeading(cache.ped)
        
        if optionId == 'vec2' then
            local coordStr = string.format('vec2(%.2f, %.2f)', coords.x, coords.y)
            lib.setClipboard(coordStr)
            lib.notify({ title = 'Copied!', description = 'Vector2 copied to clipboard', type = 'success' })
        elseif optionId == 'vec3' then
            local coordStr = string.format('vec3(%.2f, %.2f, %.2f)', coords.x, coords.y, coords.z)
            lib.setClipboard(coordStr)
            lib.notify({ title = 'Copied!', description = 'Vector3 copied to clipboard', type = 'success' })
        elseif optionId == 'vec4' then
            local coordStr = string.format('vec4(%.2f, %.2f, %.2f, %.2f)', coords.x, coords.y, coords.z, heading)
            lib.setClipboard(coordStr)
            lib.notify({ title = 'Copied!', description = 'Vector4 copied to clipboard', type = 'success' })
        elseif optionId == 'heading' then
            local headingStr = string.format('%.2f', heading)
            lib.setClipboard(headingStr)
            lib.notify({ title = 'Copied!', description = 'Heading copied to clipboard', type = 'success' })
        end
    end
end)

-- God Mode Toggle
RegisterNetEvent('qc-devtools:client:togglegodmode', function()
    godmode = not godmode
    
    if godmode then
        lib.notify({ title = 'God Mode', description = 'God mode enabled!', type = 'success' })
        CreateThread(function()
            while godmode do
                Wait(0)
                SetPlayerInvincible(cache.playerId, true)
            end
            SetPlayerInvincible(cache.playerId, false)
        end)
    else
        lib.notify({ title = 'God Mode', description = 'God mode disabled!', type = 'inform' })
    end
    
    -- Refresh menu
    TriggerEvent('qc-devtools:client:admin_self_menu')
end)

-- Invisibility Toggle
RegisterNetEvent('qc-devtools:client:toggleinvisible', function()
    invisible = not invisible
    
    if invisible then
        SetEntityVisible(cache.ped, false)
        lib.notify({ title = 'Invisibility', description = 'You are now invisible!', type = 'success' })
    else
        SetEntityVisible(cache.ped, true)
        lib.notify({ title = 'Invisibility', description = 'You are now visible!', type = 'inform' })
    end
    
    -- Refresh menu
    TriggerEvent('qc-devtools:client:admin_self_menu')
end)

-- Noclip Toggle
RegisterNetEvent('qc-devtools:client:togglenoclip', function()
    noclip = not noclip
    
    if noclip then
        lib.notify({ title = 'Noclip', description = 'Noclip enabled! Use WASD to fly', type = 'success' })
        CreateThread(function()
            while noclip do
                Wait(0)
                local ped = cache.ped
                local x, y, z = table.unpack(GetEntityCoords(ped, true))
                local dx, dy, dz = GetCamDirection()
                local speed = 2.0
                
                if IsControlPressed(0, 0x8FD015D8) then -- W
                    x = x + speed * dx
                    y = y + speed * dy
                    z = z + speed * dz
                end
                if IsControlPressed(0, 0xD27782E3) then -- S
                    x = x - speed * dx
                    y = y - speed * dy
                    z = z - speed * dz
                end
                if IsControlPressed(0, 0x7065027D) then -- A
                    x = x + speed * (-dy)
                    y = y + speed * dx
                end
                if IsControlPressed(0, 0xB4E465B4) then -- D
                    x = x - speed * (-dy)
                    y = y - speed * dx
                end
                if IsControlPressed(0, 0x8FFC75D6) then -- Space (up)
                    z = z + speed
                end
                if IsControlPressed(0, 0x26E9DC00) then -- Ctrl (down)
                    z = z - speed
                end
                
                SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
                SetEntityInvincible(ped, true)
                SetEntityVisible(ped, false)
            end
            SetEntityVisible(cache.ped, true)
            SetEntityInvincible(cache.ped, false)
        end)
    else
        lib.notify({ title = 'Noclip', description = 'Noclip disabled!', type = 'inform' })
    end
    
    -- Refresh menu
    TriggerEvent('qc-devtools:client:admin_self_menu')
end)

-- Helper function to get camera direction
function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(cache.ped)
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end

-- Vehicle/Horse Menu
RegisterNetEvent('qc-devtools:client:admin_vehicle_menu', function()
    local menuData = {
        id = 'admin_vehicle_menu',
        title = '🐴 Vehicle/Horse',
        subtitle = 'Spawn vehicles and horses',
        back = 'qc_admin_main',
        options = {
            {
                id = 'arabian_white',
                title = 'Arabian White',
                description = 'Spawn admin Arabian White horse',
                icon = '🐴'
            },
            {
                id = 'missouri',
                title = 'Missouri Foxtrotter',
                description = 'Spawn admin Missouri Foxtrotter',
                icon = '🐴'
            },
            {
                id = 'nokota',
                title = 'Nokota White Roan',
                description = 'Spawn admin Nokota horse',
                icon = '🐴'
            },
            {
                id = 'turkoman',
                title = 'Turkoman Gold',
                description = 'Spawn admin Turkoman horse',
                icon = '🐴'
            },
            {
                id = 'thoroughbred',
                title = 'Thoroughbred',
                description = 'Spawn admin Thoroughbred horse',
                icon = '🐴'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle vehicle menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_vehicle_menu' then
        if optionId == 'arabian_white' then
            TriggerEvent('qc-devtools:client:spawnhorse', `a_c_horse_arabian_white`)
        elseif optionId == 'missouri' then
            TriggerEvent('qc-devtools:client:spawnhorse', `a_c_horse_missourifoxtrotter_sablechampagne`)
        elseif optionId == 'nokota' then
            TriggerEvent('qc-devtools:client:spawnhorse', `a_c_horse_nokota_whiteroan`)
        elseif optionId == 'turkoman' then
            TriggerEvent('qc-devtools:client:spawnhorse', `a_c_horse_turkoman_gold`)
        elseif optionId == 'thoroughbred' then
            TriggerEvent('qc-devtools:client:spawnhorse', `a_c_horse_thoroughbred_reversedappleblack`)
        end
    end
end)

-- Spawn Horse
RegisterNetEvent('qc-devtools:client:spawnhorse', function(horseHash)
    local pos = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 3.0, 0.0)
    local heading = GetEntityHeading(cache.ped)
    
    if not IsModelInCdimage(horseHash) then
        lib.notify({ title = 'Error', description = 'Invalid horse model!', type = 'error' })
        return
    end
    
    RequestModel(horseHash)
    while not HasModelLoaded(horseHash) do
        Wait(0)
    end
    
    local horsePed = CreatePed(horseHash, pos.x, pos.y, pos.z - 1, heading, true, false)
    TaskMountAnimal(cache.ped, horsePed, 10000, -1, 1.0, 1, 0, 0)
    SetRandomOutfitVariation(horsePed, true)
    EnableAttributeOverpower(horsePed, 0, 5000.0) -- health overpower
    EnableAttributeOverpower(horsePed, 1, 5000.0) -- stamina overpower
    SetPlayerOwnsMount(cache.ped, horsePed)
    ApplyShopItemToPed(horsePed, -447673416, true, true, true) -- add saddle
    NetworkSetEntityInvisibleToNetwork(horsePed, true)
    
    lib.notify({ title = 'Horse Spawned', description = 'Admin horse spawned successfully!', type = 'success' })
end)

print('^2[QC-DevTools]^0 Admin module loaded successfully!')
