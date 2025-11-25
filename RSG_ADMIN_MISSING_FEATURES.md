# 📋 QC-DevTools vs rsg-adminmenu - Feature Comparison

## 🔍 Analysis Complete

I've analyzed rsg-adminmenu to find missing features and important differences.

---

## ✅ Features QC-DevTools Already Has

| Feature | QC-DevTools | rsg-adminmenu | Status |
|---------|-------------|---------------|--------|
| God Mode | ✅ Custom loop | ✅ Same implementation | ✅ Match |
| Invisibility | ✅ Custom toggle | ✅ Same implementation | ✅ Match |
| Noclip | ✅ Custom WASD | ✅ txAdmin command | ⚠️ Different |
| Teleport to Waypoint | ✅ RSG Core event | ✅ RSG Core event | ✅ Match |
| Revive Self | ✅ Multi-medic support | ✅ rsg-medic only | ✅ Better |
| Revive Player | ✅ Multi-medic support | ✅ rsg-medic only | ✅ Better |
| Freeze Player | ✅ Yes | ✅ Yes | ✅ Match |
| Kick Player | ✅ With reason | ✅ With reason | ✅ Match |
| Ban Player | ✅ With duration | ✅ With reason | ✅ Match |
| Teleport to Player | ✅ Yes | ✅ Yes | ✅ Match |
| Bring Player | ✅ Yes | ✅ Yes | ✅ Match |
| Spectate Player | ✅ Yes | ✅ Yes | ✅ Match |
| Weather Control | ✅ rsg-weather support | ✅ weathersync | ✅ Better |
| Time Control | ✅ Yes | ❌ No | ✅ Extra |
| Announcements | ✅ Yes | ❌ No | ✅ Extra |
| Wild Animal Attack | ✅ Yes | ✅ Yes | ✅ Match |
| Set on Fire | ✅ Yes | ✅ Yes | ✅ Match |
| Ragdoll | ✅ Yes | ❌ No | ✅ Extra |
| Make Drunk | ✅ Yes | ❌ No | ✅ Extra |
| Explode Player | ✅ Yes | ❌ No | ✅ Extra |
| Horse Spawner | ✅ 5 horses | ❌ No | ✅ Extra |
| Money Management | ✅ Add/Remove | ❌ No (separate menu) | ✅ Extra |

---

## ❌ Features QC-DevTools is MISSING

### **1. Menu Position - CAN MOVE WITH MENU OPEN** ⭐⭐⭐
**Importance:** HIGH  
**Issue:** QC-DevTools uses React NUI (fullscreen), rsg-adminmenu uses ox_lib context menus

```lua
-- rsg-adminmenu allows movement
lib.registerContext({
    id = 'players_optionssmenu',
    position = 'top-right',  -- ← Player can move while menu open
    options = options
})
```

**Impact:**
- ❌ QC-DevTools: Full screen NUI blocks movement
- ✅ rsg-adminmenu: Small menu, can walk/ride/shoot

**Solution:** Need to redesign QC-DevTools to use ox_lib context menus OR add option to minimize

---

### **2. Give Item Feature** ⭐⭐⭐
**Importance:** HIGH  
**What it does:**
- Search for items by name
- Filter results
- Give item to player with amount

```lua
-- Example from rsg-adminmenu
1. Search: "revolver"
2. Shows: All revolvers
3. Select item
4. Enter amount
5. Item given to player
```

**Missing in QC-DevTools!**

---

### **3. Player Inventory View** ⭐⭐
**Importance:** MEDIUM  
**What it does:**
- Admin can open and view player inventory
- See what items player has
- Useful for moderation

```lua
serverEvent = 'rsg-adminmenu:server:openinventory',
args = { id = data.player }
```

**Missing in QC-DevTools!**

---

### **4. Player Blips (Show All Players on Map)** ⭐⭐
**Importance:** MEDIUM  
**What it does:**
- Toggle to show all online players on map
- Real-time position updates
- Shows player ID and name on blip

```lua
-- Creates blips for all players
-- Updates every 1 second
-- Can toggle on/off
```

**Missing in QC-DevTools!**

---

### **5. Toggle Player IDs (Above Head)** ⭐⭐
**Importance:** MEDIUM  
**What it does:**
- Shows player server IDs floating above their heads
- Uses txAdmin command
- Useful for identifying players quickly

```lua
ExecuteCommand('txAdmin:menu:togglePlayerIDs')
```

**Missing in QC-DevTools!**

---

### **6. Player Info Display** ⭐⭐
**Importance:** MEDIUM  
**What it does:**
- Shows detailed player information
- Money, job, citizenid, etc.
- Formatted info display

**Status:** QC-DevTools has this but doesn't show all details

---

### **7. txAdmin NoClip Integration** ⭐
**Importance:** LOW (QC-DevTools has custom noclip)  
**Difference:**
- rsg-adminmenu: Uses `txAdmin:menu:noClipToggle`
- QC-DevTools: Custom WASD noclip implementation

**Note:** QC-DevTools implementation is actually BETTER (more control)

---

### **8. Reports System** ⭐⭐⭐
**Importance:** HIGH  
**What it does:**
- Players can submit reports
- Admins can view and manage reports
- Track report status (open/closed)
- Respond to reports

**Missing in QC-DevTools!**

---

### **9. Finances Menu** ⭐
**Importance:** LOW (QC-DevTools has money management)  
**Difference:**
- rsg-adminmenu: Separate finances menu for all players
- QC-DevTools: Money management per player in player menu

**Note:** Different approach, both work

---

## 📊 Summary

### **QC-DevTools Advantages:**
✅ More troll options (5 vs 2)  
✅ Better weather system (rsg-weather + fallback)  
✅ Time control  
✅ Server announcements  
✅ Horse spawner  
✅ Multi-medic support  
✅ Better noclip (WASD control)  
✅ Modern React UI  
✅ Dev tools integration  

### **rsg-adminmenu Advantages:**
✅ **Can move with menu open** (ox_lib context)  
✅ Give item feature  
✅ Player inventory view  
✅ Player blips on map  
✅ Toggle player IDs  
✅ Reports system  
✅ Lightweight (no NUI)  

---

## 🎯 Recommendations

### **CRITICAL to Add:**

#### **1. Menu Movement Solution**
**Problem:** QC-DevTools fullscreen NUI blocks movement  
**Solutions:**
1. **Option A:** Add minimize button to NUI
2. **Option B:** Create ox_lib context menu version
3. **Option C:** Add hotkey to temporarily hide menu

#### **2. Give Item Feature**
**Add to player management:**
- Search item by name
- Select from filtered results
- Enter amount
- Give to player

#### **3. Player Blips**
**Add to self options:**
- Toggle all player blips
- Update positions in real-time
- Show player ID + name

### **NICE to Have:**

#### **4. Player Inventory View**
- Open target player inventory
- View only (no manipulation)

#### **5. Toggle Player IDs**
- Show IDs above player heads
- Uses txAdmin if available

#### **6. Reports System**
- Full player report system
- Admin queue management
- Response system

---

## 🔧 Implementation Priority

### **Phase 1: Critical (Movement)**
1. Add menu minimize/hide hotkey
2. OR create ox_lib context menu alternative

### **Phase 2: Essential Features**
1. Give item feature
2. Player blips toggle
3. Player inventory view

### **Phase 3: Additional**
1. Toggle player IDs
2. Reports system
3. Enhanced player info

---

## 💡 Menu Movement - Technical Options

### **Option 1: Minimize Button**
```typescript
// Add to React UI
<button onClick={minimizeMenu}>
    Minimize (Hold M to show)
</button>
```

### **Option 2: ox_lib Context Alternative**
```lua
-- Create ox_lib version alongside React version
Config.UseOxLibMenu = true  -- Toggle in config
```

### **Option 3: ESC to Hide**
```lua
-- Allow ESC to hide menu but keep data
-- Press admin command again to show
```

---

## 🎨 UI Comparison

### **rsg-adminmenu (ox_lib context):**
```
┌─────────────────────┐
│ Admin Menu          │ ← Small box, top-right
│ • Option 1          │    Player can move
│ • Option 2          │    Can shoot
│ • Option 3          │    Can ride
└─────────────────────┘
   [Player walking around]
```

### **QC-DevTools (React NUI):**
```
┌──────────────────────────────┐
│                              │
│      FULLSCREEN NUI          │ ← Blocks everything
│                              │    Can't move
│    🛡️ Admin Menu            │    Can't shoot
│                              │    Can't interact
│                              │
└──────────────────────────────┘
```

---

## 🔍 Feature Details

### **Give Item Implementation**
```lua
-- Step 1: Player selects target
-- Step 2: Search item dialog
local searchInput = lib.inputDialog('Search Item', {
    {
        type = 'input',
        label = 'Search',
        placeholder = 'revolver, bandage...',
        required = true
    }
})

-- Step 3: Filter RSGCore.Shared.Items
local keyword = searchInput[1]:lower()
local options = {}
for _, item in pairs(RSGCore.Shared.Items) do
    if item.label:lower():find(keyword) then
        options[#options+1] = {
            value = item.name,
            label = item.label
        }
    end
end

-- Step 4: Select item + amount
local result = lib.inputDialog('Give Item', {
    {
        type = 'select',
        label = 'Item',
        options = options,
        search = true
    },
    {
        type = 'number',
        label = 'Amount',
        required = true,
        min = 1
    }
})

-- Step 5: Give item
TriggerServerEvent('qc-devtools:server:giveItem', targetId, result[1], result[2])
```

### **Player Blips Implementation**
```lua
-- Toggle blips
local playerBlips = {}
local blipsEnabled = false

RegisterNetEvent('qc-devtools:client:toggleBlips', function()
    blipsEnabled = not blipsEnabled
    
    if blipsEnabled then
        CreateThread(function()
            while blipsEnabled do
                Wait(1000)
                -- Get all players
                RSGCore.Functions.TriggerCallback('qc-devtools:server:getPlayers', function(players)
                    for _, player in pairs(players) do
                        if not playerBlips[player.id] then
                            -- Create blip
                            local blip = BlipAddForCoords(1664425300, player.coords.x, player.coords.y, player.coords.z)
                            SetBlipSprite(blip, GetHashKey('blip_ambient_companion'))
                            SetBlipName(blip, 'ID: ' .. player.id .. ' ' .. player.name)
                            playerBlips[player.id] = blip
                        else
                            -- Update position
                            SetBlipCoords(playerBlips[player.id], player.coords.x, player.coords.y, player.coords.z)
                        end
                    end
                end)
            end
        end)
    else
        -- Remove all blips
        for _, blip in pairs(playerBlips) do
            RemoveBlip(blip)
        end
        playerBlips = {}
    end
end)
```

---

## ✅ Conclusion

QC-DevTools is already MORE FEATURE-RICH than rsg-adminmenu, but has ONE CRITICAL ISSUE:

**❌ Can't move with menu open (fullscreen NUI)**

### **Solution:**
Add a **minimize/hide hotkey** OR create an **ox_lib context menu alternative**.

### **Additional Features to Add:**
1. Give item (HIGH priority)
2. Player blips (MEDIUM priority)
3. Player inventory view (MEDIUM priority)
4. Reports system (MEDIUM priority)

---

**Would you like me to implement any of these missing features?**

Options:
1. Add menu minimize/hide functionality
2. Create ox_lib context menu version
3. Add give item feature
4. Add player blips toggle
5. Add all missing features

Let me know what you'd like to prioritize!
