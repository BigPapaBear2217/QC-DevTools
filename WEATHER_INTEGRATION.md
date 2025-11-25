# 🌤️ QC-DevTools - Weather System Integration

## 📋 Overview

QC-DevTools now supports **rsg-weather system** with automatic detection and fallback!

---

## ✅ Supported Weather Systems

### **Priority Order:**

1. **rsg-weather** (Kong Projects) - Advanced weather system
2. **Direct Native Fallback** - Basic weather control

---

## 🔍 How It Works

### **Automatic Detection**
```lua
if GetResourceState('rsg-weather') == 'started' then
    -- Use rsg-weather system with all features
else
    -- Use direct native weather control
end
```

---

## 🌦️ Weather Types

### **rsg-weather System (10 types):**
- ☀️ **SUNNY** - Clear sunny day
- ☁️ **CLOUDS** - Cloudy weather
- 🌥️ **OVERCAST** - Overcast skies
- 🌧️ **RAIN** - Heavy rain
- 🌦️ **DRIZZLE** - Light rain
- ⛈️ **THUNDER** - Thunderstorm
- ❄️ **SNOW** - Snowy weather
- 🌨️ **BLIZZARD** - Heavy snow
- 🌫️ **FOG** - Foggy conditions
- 🌪️ **SANDSTORM** - Dust storm

### **Features with rsg-weather:**
✅ Smooth weather transitions  
✅ Temperature simulation  
✅ Regional weather zones  
✅ Player needs affected by weather  
✅ Job-specific weather bonuses  
✅ Weather history tracking  
✅ Forecast system  
✅ Database persistence  

### **Fallback (Direct Native):**
- Basic weather change
- No transitions
- No temperature system
- Instant change

---

## 🎯 Integration Details

### **Server-Side (server/admin.lua)**
```lua
RegisterNetEvent('qc-devtools:server:setWeather', function(weather)
    if GetResourceState('rsg-weather') == 'started' then
        -- Use rsg-weather:server:setWeather event
        TriggerEvent('rsg-weather:server:setWeather', weather)
    else
        -- Fallback to direct client-side change
        TriggerClientEvent('qc-devtools:client:setWeather', -1, weather)
    end
end)
```

### **Client-Side (client/admin/server.lua)**
```lua
RegisterNetEvent('qc-devtools:client:setWeather', function(weather)
    if GetResourceState('rsg-weather') == 'started' then
        -- rsg-weather handles it via server event
        return
    else
        -- Direct native weather change
        Citizen.InvokeNative(0x59174F1AFE095B5A, GetHashKey(weather), ...)
    end
end)
```

---

## 📊 Comparison

| Feature | rsg-weather | Fallback |
|---------|-------------|----------|
| Weather Types | 10 types | 10 types |
| Smooth Transitions | ✅ Yes | ❌ No |
| Temperature | ✅ Yes | ❌ No |
| Regional Zones | ✅ Yes | ❌ No |
| Player Effects | ✅ Yes | ❌ No |
| Job Integration | ✅ Yes | ❌ No |
| History Tracking | ✅ Yes | ❌ No |
| Forecasts | ✅ Yes | ❌ No |
| Database | ✅ Yes | ❌ No |
| Admin Commands | ✅ Enhanced | ✅ Basic |

---

## 🧪 Testing Guide

### **Test with rsg-weather:**
```bash
# Ensure rsg-weather is started
ensure rsg-weather
restart QC-DevTools

# Test in-game
/admin → Server Options → Weather Control
# Should see 10 weather types
# Changes should be smooth with transitions
```

### **Test Fallback (No rsg-weather):**
```bash
# Stop rsg-weather
stop rsg-weather
restart QC-DevTools

# Test in-game
/admin → Server Options → Weather Control
# Should still work with instant changes
```

---

## 🎨 rsg-weather Features

### **When rsg-weather is Running:**

#### **1. Smooth Transitions**
- Weather changes gradually over 30 seconds
- No sudden jarring changes
- Configurable transition time

#### **2. Temperature System**
- Each weather has temperature range
- Affects player comfort
- Can affect hunger/thirst rates
- Cold weather = faster hunger
- Hot weather = faster thirst

#### **3. Regional Weather Zones**
- Different weather in different areas:
  - Valentine
  - Saint Denis
  - Blackwater
  - Armadillo
  - Strawberry
  - Rhodes
  - Annesburg
  - Tumbleweed

#### **4. Player Effects**
- Visibility affected by fog/snow
- Movement speed in blizzards
- Clothing temperature bonuses
- Job-specific weather benefits

#### **5. Advanced Features**
- Weather forecast system
- Historical weather data
- Database persistence
- Regional differences
- Dynamic weather cycles

---

## 🔧 rsg-weather Events

### **Server Events:**
```lua
-- Set weather (admin)
TriggerEvent('rsg-weather:server:setWeather', weatherType)

-- Set temperature (admin)
TriggerEvent('rsg-weather:server:setTemperature', temperature)
```

### **Client Events:**
```lua
-- Weather update
'rsg-weather:client:weatherUpdate'

-- Temperature update
'rsg-weather:client:temperatureUpdate'
```

### **Exports:**
```lua
-- Get current weather
exports['rsg-weather']:GetCurrentWeather()

-- Get current temperature
exports['rsg-weather']:GetCurrentTemperature()

-- Get weather in region
exports['rsg-weather']:GetWeatherInRegion(zoneName)
```

---

## 🎯 Usage

### **Basic Weather Change:**
```
1. /admin
2. Server Options
3. Weather Control
4. Select weather type
5. Weather changes (smoothly if rsg-weather active)
```

### **With rsg-weather Active:**
- Smooth 30-second transition
- Temperature automatically adjusts
- Regional zones update
- Player effects apply
- History recorded

### **Without rsg-weather:**
- Instant weather change
- Basic visual effect
- No temperature
- No zones
- No history

---

## 📋 Configuration

### **QC-DevTools Side:**
No configuration needed - automatic detection!

### **rsg-weather Side:**
```lua
-- In rsg-weather/config.lua

-- Weather transition settings
Config.WeatherTransition = {
    enabled = true,
    transitionTime = 30.0,
    smoothTransitions = true,
    allowInstantChange = false, -- Admin can override
}

-- Admin commands
Config.AdminCommands = {
    enabled = true,
    requiredGrade = 'admin',
}
```

---

## 🆚 Weather System Comparison

### **rsg-weather Advantages:**
- ✅ Professional weather system
- ✅ Smooth transitions
- ✅ Temperature simulation
- ✅ Regional zones
- ✅ Player needs integration
- ✅ Job bonuses
- ✅ Database persistence
- ✅ Forecast system

### **Direct Fallback Advantages:**
- ✅ No dependencies
- ✅ Instant changes
- ✅ Simple & lightweight
- ✅ Works everywhere

---

## 🎓 Developer Notes

### **Event Flow with rsg-weather:**
```
Admin Menu → QC-DevTools Client → QC-DevTools Server
    ↓
Detects rsg-weather running
    ↓
Triggers: rsg-weather:server:setWeather
    ↓
rsg-weather processes:
    - Validates admin permission
    - Sets global weather
    - Calculates temperature
    - Updates all clients
    - Smooth transition
    - Records history
    ↓
All players see weather change
```

### **Event Flow without rsg-weather:**
```
Admin Menu → QC-DevTools Client → QC-DevTools Server
    ↓
No rsg-weather detected
    ↓
Triggers: qc-devtools:client:setWeather (all clients)
    ↓
Direct native weather change
    ↓
Instant weather change for all
```

---

## 🚀 Recommended Setup

### **Option 1: Full Weather System**
```cfg
ensure rsg-weather
ensure QC-DevTools
```
**Best for:** Roleplay servers, immersive gameplay

### **Option 2: Basic Weather**
```cfg
ensure QC-DevTools
```
**Best for:** Simple servers, minimal dependencies

---

## 💡 Pro Tips

### **With rsg-weather:**
1. Weather changes are gradual - wait 30 seconds for full effect
2. Temperature affects player needs - consider when testing
3. Regional zones mean different areas have different weather
4. Job bonuses may apply (farmers, fishermen, etc.)

### **Without rsg-weather:**
1. Changes are instant
2. Use for quick testing
3. No side effects on players
4. Simple visual change only

---

## 🐛 Troubleshooting

### **Weather Not Changing (with rsg-weather):**
1. Check rsg-weather is running: `ensure rsg-weather`
2. Verify admin permissions in rsg-weather config
3. Check console for errors
4. Wait 30 seconds for transition

### **Weather Not Changing (fallback):**
1. Check QC-DevTools admin permissions
2. Verify weather type name is correct (uppercase)
3. Check client console for errors

### **rsg-weather Not Detected:**
1. Verify resource name is exactly "rsg-weather"
2. Ensure it's started before QC-DevTools
3. Check `GetResourceState('rsg-weather')` in F8

---

## ✅ Compatibility

### **Works With:**
- ✅ rsg-weather (any version)
- ✅ weathersync (fallback will be used)
- ✅ No weather system (fallback works)

### **No Conflicts:**
- ✅ Can run with other weather systems (last one wins)
- ✅ Clean fallback logic
- ✅ No interference with other admin tools

---

## 🎊 Summary

### **Integration: COMPLETE** ✅

Weather control now supports:
- ✅ rsg-weather advanced system (if installed)
- ✅ Direct native fallback (if not installed)
- ✅ 10 weather types
- ✅ Automatic detection
- ✅ Zero configuration

### **Benefits:**
- Best of both worlds
- Automatic compatibility
- Professional features (if rsg-weather)
- Always works (fallback)

---

**Weather Integration Complete!** 🌤️

QC-DevTools now intelligently uses rsg-weather when available!

---

**Updated:** January 2025  
**Version:** 1.1.3  
**Status:** Weather System Integrated ✅
