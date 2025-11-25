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

-- Wild Animal Attack
RegisterNetEvent('qc-devtools:server:wildAttack', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    TriggerClientEvent('qc-devtools:client:wildAttack', targetId)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Troll',
        description = '🐻 Wild animal sent!',
        type = 'success'
    })
end)

-- Set Player on Fire
RegisterNetEvent('qc-devtools:server:setFire', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    TriggerClientEvent('qc-devtools:client:setFire', targetId)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Troll',
        description = '🔥 Player set on fire!',
        type = 'success'
    })
end)

-- Ragdoll Player
RegisterNetEvent('qc-devtools:server:ragdoll', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    TriggerClientEvent('qc-devtools:client:ragdoll', targetId)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Troll',
        description = '💫 Player ragdolled!',
        type = 'success'
    })
end)

-- Make Player Drunk
RegisterNetEvent('qc-devtools:server:makeDrunk', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    TriggerClientEvent('qc-devtools:client:makeDrunk', targetId)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Troll',
        description = '🍺 Player is now drunk!',
        type = 'success'
    })
end)

-- Explode Player
RegisterNetEvent('qc-devtools:server:explodePlayer', function(targetId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    TriggerClientEvent('qc-devtools:client:explode', targetId)
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Troll',
        description = '💥 Player exploded!',
        type = 'success'
    })
end)

print('^2[QC-DevTools]^0 Admin troll module loaded successfully!')
