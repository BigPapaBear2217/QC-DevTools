-- Server Options Menu
RegisterNetEvent('qc-devtools:client:admin_server_menu', function()
    local menuData = {
        id = 'admin_server_menu',
        title = '🌍 Server Options',
        subtitle = 'Control server settings',
        back = 'qc_admin_main',
        options = {
            {
                id = 'weather',
                title = '🌤️ Weather Control',
                description = 'Change server weather',
                icon = '☁️'
            },
            {
                id = 'time',
                title = '🕐 Time Control',
                description = 'Change server time',
                icon = '⏰'
            },
            {
                id = 'announce',
                title = '📢 Announcement',
                description = 'Send server-wide announcement',
                icon = '📣'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)

-- Handle server options menu selections
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'admin_server_menu' then
        if optionId == 'weather' then
            TriggerEvent('qc-devtools:client:weatherMenu')
        elseif optionId == 'time' then
            TriggerEvent('qc-devtools:client:timeMenu')
        elseif optionId == 'announce' then
            TriggerEvent('qc-devtools:client:announceMenu')
        end
    end
end)

-- Weather Menu
RegisterNetEvent('qc-devtools:client:weatherMenu', function()
    -- RDR2 Weather Types (compatible with weathersync)
    local weatherTypes = {
        { value = 'sunny', label = '☀️ Sunny - Clear sunny day' },
        { value = 'highpressure', label = '🌤️ High Pressure - Clear and bright' },
        { value = 'clouds', label = '☁️ Clouds - Cloudy weather' },
        { value = 'overcast', label = '🌥️ Overcast - Overcast skies' },
        { value = 'overcastdark', label = '⛅ Overcast Dark - Dark overcast' },
        { value = 'drizzle', label = '🌦️ Drizzle - Light rain' },
        { value = 'rain', label = '🌧️ Rain - Heavy rain' },
        { value = 'shower', label = '🌧️ Shower - Rain shower' },
        { value = 'thunder', label = '⛈️ Thunder - Thunderstorm' },
        { value = 'thunderstorm', label = '⛈️ Thunderstorm - Heavy storm' },
        { value = 'snow', label = '❄️ Snow - Snowy weather' },
        { value = 'snowlight', label = '🌨️ Light Snow - Light snowfall' },
        { value = 'blizzard', label = '🌨️ Blizzard - Heavy snow' },
        { value = 'groundblizzard', label = '❄️ Ground Blizzard - Ground level snow' },
        { value = 'whiteout', label = '🌫️ Whiteout - Heavy snow conditions' },
        { value = 'fog', label = '🌫️ Fog - Foggy conditions' },
        { value = 'misty', label = '🌫️ Misty - Light fog' },
        { value = 'sandstorm', label = '🌪️ Sandstorm - Dust storm' },
        { value = 'hurricane', label = '🌀 Hurricane - Extreme weather' },
        { value = 'hail', label = '🧊 Hail - Hailstorm' },
        { value = 'sleet', label = '🧊 Sleet - Freezing rain' }
    }
    
    local input = lib.inputDialog('🌤️ Weather Control', {
        {
            type = 'select',
            label = 'Select Weather Type',
            description = 'Choose the weather for the server',
            options = weatherTypes,
            required = true,
            default = 'sunny'
        }
    })
    
    if not input then return end
    
    local selectedWeather = input[1]
    TriggerServerEvent('qc-devtools:server:setWeather', selectedWeather)
end)

-- Time Menu
RegisterNetEvent('qc-devtools:client:timeMenu', function()
    local input = lib.inputDialog('🕐 Time Control', {
        {
            type = 'number',
            label = 'Hour (0-23)',
            required = true,
            min = 0,
            max = 23,
            default = 12
        },
        {
            type = 'number',
            label = 'Minute (0-59)',
            required = true,
            min = 0,
            max = 59,
            default = 0
        }
    })
    
    if not input then return end
    
    TriggerServerEvent('qc-devtools:server:setTime', input[1], input[2])
end)

-- Announcement Menu
RegisterNetEvent('qc-devtools:client:announceMenu', function()
    print('[QC-DevTools] Announcement menu opened')
    
    local input = lib.inputDialog('📢 Server Announcement', {
        {
            type = 'textarea',
            label = 'Message',
            required = true,
            placeholder = 'Enter announcement message...',
            min = 5,
            max = 200
        }
    })
    
    if not input then 
        print('[QC-DevTools] Announcement cancelled')
        return 
    end
    
    print('[QC-DevTools] Sending announcement:', input[1])
    TriggerServerEvent('qc-devtools:server:announce', input[1])
end)

-- Set Weather (Client) - Fallback only
RegisterNetEvent('qc-devtools:client:setWeather', function(weather)
    -- This is only used when weathersync is NOT running
    -- weathersync handles weather changes automatically when it's active
    
    local weatherName = weather or 'sunny'
    
    -- RDR2 Weather Native: _SET_WEATHER_TYPE
    -- Native hash: 0x59174F1AFE095B5A
    -- Parameters: weatherType (hash), p1 (bool), p2 (bool), p3 (bool), transitionTime (float), p5 (bool)
    Citizen.InvokeNative(0x59174F1AFE095B5A, GetHashKey(weatherName), true, true, true, 10.0, false)
    
    lib.notify({
        title = 'Weather',
        description = 'Weather changed to ' .. weatherName,
        type = 'success'
    })
end)

-- Set Time (Client)
RegisterNetEvent('qc-devtools:client:setTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)

-- Freeze Player (Client)
RegisterNetEvent('qc-devtools:client:freezePlayer', function(freeze)
    FreezeEntityPosition(cache.ped, freeze)
    
    if freeze then
        lib.notify({
            title = 'Admin',
            description = 'You have been frozen by an admin!',
            type = 'error'
        })
    else
        lib.notify({
            title = 'Admin',
            description = 'You have been unfrozen!',
            type = 'success'
        })
    end
end)
