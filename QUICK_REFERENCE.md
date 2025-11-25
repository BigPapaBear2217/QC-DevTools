# 🚀 QC-DevTools - Quick Reference Card

## ⚡ Commands

```bash
/devtools        # Main menu (dev tools + admin)
/admin           # Direct admin menu access
/dev_decals      # Quick ped decals access
```

---

## 🛡️ Admin Menu Structure

```
🛡️ Admin Menu
├── 👤 Self Options
│   ├── God Mode (toggle)
│   ├── Invisibility (toggle)
│   ├── Noclip (toggle)
│   ├── Revive Self
│   ├── Teleport to Waypoint
│   └── Copy Coordinates (vec2/3/4, heading)
│
├── 👥 Player Management
│   ├── View Info (money, job, IDs)
│   ├── Teleport To Player
│   ├── Bring Player
│   ├── Spectate Player
│   ├── Freeze/Unfreeze
│   ├── Revive Player
│   ├── Money Options (add/remove)
│   ├── Kick Player
│   └── Ban Player
│
├── 🐴 Horse Spawner
│   ├── Arabian White
│   ├── Missouri Foxtrotter
│   ├── Nokota White Roan
│   ├── Turkoman Gold
│   └── Thoroughbred
│
├── 🌍 Server Options
│   ├── Weather Control (8 types)
│   ├── Time Control (hour:minute)
│   └── Server Announcement
│
└── 😈 Troll Menu
    ├── Wild Animal Attack
    ├── Set on Fire
    ├── Ragdoll
    ├── Make Drunk
    └── Explode Player
```

---

## 🔧 Dev Tools Structure

```
🔧 Development Tools
├── 🎨 Ped Decals (scars, damage, blood)
├── 🎬 Animation Post FX (visual effects)
├── 🌅 Timecycle Modifiers (environmental)
├── 💥 Explosions (all types)
├── 🔊 Audio Testing (sounds, music)
├── 🏗️ IPL Management (interiors)
├── ✨ PTFX Effects (particles)
└── 🎯 Entity Information (scanner)
```

---

## 🎯 Common Workflows

### **Admin Tasks**
```
Quick Revive:          /admin → Self → Revive
God Mode:              /admin → Self → God Mode
Teleport to Player:    /admin → Players → Select → Teleport To
Kick Player:           /admin → Players → Select → Kick
Change Weather:        /admin → Server → Weather → Select
Get Admin Horse:       /admin → Horse → Arabian White
```

### **Development Tasks**
```
Get Coordinates:       /devtools → Admin → Self → Coordinates
Test Decals:          /devtools → Ped Decals → Select Category
Scan Entity:          /devtools → Entity Info → Look & Right-Click
Test Audio:           /devtools → Audio → Select Sound
Spawn Test Horse:     /admin → Horse → Any Horse
```

### **Testing Workflows**
```
Location Testing:
1. /devtools → Admin → Coordinates → Copy Vec4
2. Teleport somewhere
3. Test features
4. /devtools → Admin → Self → Teleport to Waypoint

Weather Testing:
1. /admin → Server → Weather → Set
2. Test visuals
3. Change time if needed
4. Take screenshots

Player Testing:
1. /admin → Players → Select → Bring
2. Test features together
3. Teleport back when done
```

---

## 🎮 Keyboard Shortcuts

### **Noclip Controls**
```
W           - Forward
S           - Backward
A           - Left
D           - Right
Space       - Up
Ctrl        - Down
Mouse       - Look around
```

### **Entity Scanner**
```
Look        - Scan entity
Right-Click - Capture entity data
```

---

## 🔐 Permission Setup

### **Config File Location**
`QC-DevTools/shared/config.lua`

### **Set Admin Jobs**
```lua
Config.AdminMenu = {
    enabled = true,
    adminJobs = { 'admin', 'god' },  -- Edit here
    requireRSGCore = true
}
```

### **Give Player Admin Job (SQL)**
```sql
-- Get player's citizenid first
SELECT citizenid, charinfo FROM players WHERE citizenid = 'ABC12345';

-- Set admin job
UPDATE players 
SET job = '{"name":"admin","label":"Administrator","payment":0,"onduty":true,"isboss":true,"grade":{"name":"Boss","level":4}}' 
WHERE citizenid = 'ABC12345';
```

### **Give Player Admin Job (In-Game)**
```
Use your existing job system or rsg-bossmenu
```

---

## 🚨 Emergency Commands

### **If Stuck in Noclip**
```
/admin → Self Options → Noclip (toggle off)
OR restart resource: restart QC-DevTools
```

### **If Invisible**
```
/admin → Self Options → Invisibility (toggle off)
```

### **If God Mode Stuck**
```
/admin → Self Options → God Mode (toggle off)
Die/respawn to reset
```

### **If Spectating**
```
/admin → Players → Select → Spectate (toggle off)
```

---

## 📊 Config Quick Reference

### **Enable/Disable Admin Menu**
```lua
Config.AdminMenu.enabled = true  -- or false
```

### **Change Commands**
```lua
Config.Commands = {
    mainMenu = 'devtools',   -- Main menu
    adminMenu = 'admin',     -- Admin menu
    pedDecals = 'dev_decals' -- Decals shortcut
}
```

### **Disable Specific Modules**
```lua
Config.Categories = {
    {
        id = 'ptfx',
        enabled = false,  -- Disable this module
    }
}
```

---

## 🔍 Troubleshooting Quick Fixes

### **Menu Won't Open**
```bash
# Check console
F8

# Common fixes
ensure ox_lib
ensure rsg-core
restart QC-DevTools
```

### **No Admin Option**
```lua
-- Check job name in config matches your job
-- Default: { 'admin', 'god' }
Config.AdminMenu.adminJobs = { 'admin', 'god', 'moderator' }
```

### **Player Actions Don't Work**
```bash
# Check dependencies
ensure oxmysql
ensure rsg-core

# Check server console for errors
```

### **NUI Not Showing**
```bash
# Rebuild UI
cd QC-DevTools/html
npm install
npm run build
restart QC-DevTools
```

---

## 💡 Pro Tips

### **Efficiency Tips**
1. **Use Search**: Type in menu to search all features instantly
2. **Clipboard**: Coordinates auto-copy when you select them
3. **Quick Access**: Use `/admin` instead of `/devtools` for admin tasks
4. **Combine Tools**: Use entity scanner + admin horse for quick testing

### **Admin Tips**
1. **Noclip First**: Enable noclip before long-distance travels
2. **God Mode**: Keep on during testing to avoid deaths
3. **Horse Spawner**: Faster than walking between test locations
4. **Spectate**: Great for monitoring suspicious players

### **Developer Tips**
1. **Coordinate Workflow**: Copy coords → Test → Paste into code
2. **Entity Scanner**: Right-click to capture all entity data at once
3. **Weather Control**: Perfect lighting for screenshots
4. **PTFX Testing**: Test particle effects before implementing

---

## 📞 Quick Help

### **Documentation Files**
```
README.md                - Main documentation
README_ADMIN.md          - Admin system details
INSTALLATION.md          - Setup guide
INTEGRATION_SUMMARY.md   - Technical details
QUICK_REFERENCE.md       - This file
```

### **Console Commands**
```
F8                       - Open client console
Server console           - View server logs
Browser F12              - Debug NUI issues
```

### **Common Errors**
```
"RSGCore object not found"     → ensure rsg-core
"No permission"                → Check admin job config
"Player not found"             → Player disconnected
"Module not loaded"            → restart QC-DevTools
```

---

## 🎯 Feature Count

### **Admin Features: 28+**
- Self Options: 6
- Player Actions: 9
- Horses: 5
- Server Controls: 3
- Troll Options: 5

### **Dev Features: 100+**
- Ped Decals: 50+
- Audio Items: 20+
- Explosions: 15+
- And more...

---

## 🔄 Update Checklist

### **Before Updating**
- [ ] Backup config file
- [ ] Note current version
- [ ] Document any custom changes

### **After Updating**
- [ ] Merge config changes
- [ ] Run database updates (if any)
- [ ] Rebuild UI (if modified)
- [ ] Test all features
- [ ] Check for breaking changes

---

## 📊 Resource Info

```
Name:           QC-DevTools
Version:        1.1.0
Type:           Development & Admin Tool
Framework:      RSG Core
Dependencies:   ox_lib, oxmysql
Performance:    ~0.05ms average
```

---

## 🎉 Quick Start (New Users)

### **1. First Login**
```
/devtools
```

### **2. Get Admin Horse**
```
/admin → Horse → Arabian White
```

### **3. Test God Mode**
```
/admin → Self → God Mode
```

### **4. Try Teleport**
```
Set waypoint on map
/admin → Self → Teleport to Waypoint
```

### **5. Copy Coordinates**
```
/admin → Self → Coordinates → Vec4
```

**You're Ready!** 🚀

---

**💡 Remember:** Type in any menu to use global search!

**Developed by Quantum Projects**
