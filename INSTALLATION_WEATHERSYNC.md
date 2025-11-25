# 🚀 QC-DevTools - Installation & Setup Guide (Weathersync Fixed)

## 📋 Prerequisites

### **Required Resources:**
- ✅ `rsg-core` (RSG Framework Core)
- ✅ `ox_lib` (OX Library)
- ✅ `oxmysql` (Database)

### **Recommended (for weather/time):**
- ✅ `weathersync` (RSG Framework Weather System)

---

## 📦 Installation Steps

### **Step 1: Download & Extract**
```
1. Download QC-DevTools
2. Extract to your resources folder
3. Rename folder to: QC-DevTools (exact name)
```

### **Step 2: Database Setup**
```sql
-- Import this SQL file:
reports.sql
```

**OR Run this query:**
```sql
CREATE TABLE IF NOT EXISTS `admin_reports` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `reporter_citizenid` VARCHAR(50),
    `reporter_name` VARCHAR(100),
    `reported_citizenid` VARCHAR(50),
    `reported_name` VARCHAR(100),
    `reason` TEXT,
    `status` VARCHAR(20) DEFAULT 'pending',
    `admin_response` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### **Step 3: Server Configuration**
Edit your `server.cfg`:

```cfg
# Core Framework (Required)
ensure rsg-core
ensure ox_lib
ensure oxmysql

# Weather System (Recommended)
ensure weathersync

# Admin Tools
ensure QC-DevTools

# Other resources...
```

**⚠️ IMPORTANT:** Start `weathersync` BEFORE `QC-DevTools`

### **Step 4: Admin Permissions**
Edit `QC-DevTools/shared/config.lua`:

```lua
Config.AdminJobs = {
    ['admin'] = true,
    ['god'] = true,
    ['moderator'] = true
}

-- OR use specific job grades
Config.AdminGrade = 4 -- Minimum grade for admin access
```

### **Step 5: Restart Server**
```
restart rsg-core
restart weathersync
restart QC-DevTools
```

---

## ✅ Verification

### **Check Resources Running:**
```
In F8 Console:
GetResourceState('weathersync')    -- Should return: "started"
GetResourceState('QC-DevTools')    -- Should return: "started"
```

### **Test In-Game:**
```
1. Login as admin
2. Type: /admin
3. Menu should appear
4. Try: Server Options → Weather Control
5. Select any weather type
6. Should change smoothly!
```

---

## 🌤️ Weather System Setup

### **Weathersync Configuration**
Located in: `weathersync/config.lua`

```lua
Config = {}

-- MUST be true for RedM
Config.isRDR = true

-- Default weather on server start
Config.weather = "sunny"

-- All supported RDR2 weather types
Config.weatherTypes = {
    "blizzard",
    "clouds",
    "drizzle",
    "fog",
    "groundblizzard",
    "hail",
    "highpressure",
    "hurricane",
    "misty",
    "overcast",
    "overcastdark",
    "rain",
    "sandstorm",
    "shower",
    "sleet",
    "snow",
    "snowlight",
    "sunny",
    "thunder",
    "thunderstorm",
    "whiteout"
}

-- Weather change settings
Config.baseChanceOfChange = 5 -- 5% chance per interval
Config.syncDelay = 5000 -- 5 seconds sync delay
```

### **Weathersync Permissions** (Optional)
Edit `weathersync/permissions.cfg`:

```cfg
# Allow admins to use weather commands
add_ace group.admin command.weather allow
add_ace group.admin command.time allow
add_ace group.admin command.forecast allow
add_ace group.admin command.weatherui allow
```

---

## 🎮 Usage Guide

### **Admin Menu Access:**
```
/admin - Open admin menu
```

### **Admin Menu Structure:**
```
QC-DevTools Admin
├── Self Options
│   ├── God Mode
│   ├── Invisible
│   ├── Noclip
│   ├── Revive
│   ├── Heal
│   └── Teleport
├── Player Management
│   ├── View Players
│   ├── Kick
│   ├── Ban
│   ├── Freeze
│   └── Teleport to Player
├── Server Options
│   ├── Weather Control ← NEW & FIXED
│   ├── Time Control ← FIXED
│   └── Announcements
├── Advanced Tools
│   ├── Give Item
│   ├── Give Money
│   ├── Set Job
│   └── Revive All
└── Reports
    ├── View Reports
    ├── Respond to Reports
    └── Close Reports
```

### **Weather Control:**
```
1. /admin
2. Server Options
3. Weather Control
4. Select from 21 weather types:
   - Sunny, Clouds, Rain, Thunder
   - Snow, Blizzard, Fog, Sandstorm
   - Hurricane, Hail, Sleet, etc.
5. Weather changes with 10-second smooth transition
```

### **Time Control:**
```
1. /admin
2. Server Options
3. Time Control
4. Enter Hour (0-23) and Minute (0-59)
5. Time synchronizes across all players
```

---

## 🔧 Advanced Configuration

### **QC-DevTools Config** (`shared/config.lua`)

```lua
Config = {}

-- Admin Jobs (who can access admin menu)
Config.AdminJobs = {
    ['admin'] = true,
    ['god'] = true,
    ['moderator'] = true
}

-- Minimum job grade for admin access
Config.AdminGrade = 4

-- Enable/Disable Features
Config.EnableGodMode = true
Config.EnableNoclip = true
Config.EnableWeatherControl = true
Config.EnableTimeControl = true
Config.EnablePlayerManagement = true
Config.EnableTrollCommands = true

-- Teleport Settings
Config.TeleportMarker = true -- Show marker at teleport location
Config.TeleportFadeOut = true -- Fade screen during teleport

-- Notification Settings
Config.NotificationType = 'ox_lib' -- or 'rnotify'
```

---

## 🎨 Other Features

### **Development Tools:**

#### **1. Ped Decals**
```
/devtools → Ped Decals
- Browse and apply decals to peds
- Blood, dirt, wounds, tattoos
- Preview before applying
```

#### **2. Particle Effects (PTFX)**
```
/devtools → Particle Effects
- Test all RDR2 particle effects
- Preview effects in real-time
- Copy effect names for scripting
```

#### **3. AnimPostFX**
```
/devtools → AnimPostFX
- Test screen effects
- Drunk, drugged, damaged effects
- Cinematic filters
```

#### **4. Time Cycles**
```
/devtools → Time Cycles
- Test lighting and atmosphere
- Different time of day looks
- Custom color grading
```

#### **5. Entity Scanner**
```
/devtools → Entity Info
- Scan nearby entities
- Get hashes, models, coords
- Debug entity data
```

#### **6. Audio Tools**
```
/devtools → Audio
- Test audio banks
- Sound sets and flags
- Music events
- Audio streams
```

#### **7. IPLs Management**
```
/devtools → IPLs
- Load/unload interior IPLs
- Toggle map interiors
- Debug interior issues
```

---

## 🐛 Troubleshooting

### **Admin Menu Not Opening:**
1. Check job in `Config.AdminJobs`
2. Verify you have admin job/grade
3. Check F8 console for errors
4. Try: `restart QC-DevTools`

### **Weather Not Changing:**
1. Ensure weathersync is running: `ensure weathersync`
2. Wait 10 seconds for transition
3. Check weathersync started before QC-DevTools
4. Verify admin permissions

### **Time Not Syncing:**
1. Check weathersync is running
2. Verify no other time scripts conflicting
3. Test with `/time 12 0` command

### **"Resource not found":**
1. Check folder name is exactly: `QC-DevTools`
2. Verify in correct resources folder
3. Check server.cfg has `ensure QC-DevTools`

### **Permission Denied:**
1. Check `shared/config.lua` admin settings
2. Verify your job is in `Config.AdminJobs`
3. Check job grade meets `Config.AdminGrade`

### **Database Errors:**
1. Import `reports.sql`
2. Check MySQL connection
3. Verify oxmysql is running

---

## 📊 Performance Tips

### **Optimize for Production:**
```lua
-- In shared/config.lua

-- Disable features you don't need
Config.EnableTrollCommands = false -- Disable if not using

-- Reduce sync intervals
Config.SyncInterval = 5000 -- Increase if needed
```

### **Server.cfg Optimization:**
```cfg
# Load order matters
ensure oxmysql        # 1. Database first
ensure ox_lib         # 2. Library second
ensure rsg-core       # 3. Core third
ensure weathersync    # 4. Weather before admin tools
ensure QC-DevTools    # 5. Admin tools last
```

---

## 🔐 Security Notes

### **Admin Permissions:**
- Only give admin to trusted players
- Use proper job system (not hardcoded)
- Monitor admin actions in logs
- Regular permission audits

### **Server-Side Validation:**
- All admin actions validated server-side
- Distance checks on teleports
- Permission checks on every action
- Anti-cheat integration ready

---

## 📝 Console Commands

### **Weathersync Commands:**
```
/weather <type> [transition] [freeze] [permanentSnow]
/time <day> <hour> <minute> <second>
/forecast - Show weather forecast
/weatherui - Open weather UI
/timescale <value> - Set time speed
```

### **Admin Commands:**
```
/admin - Open admin menu
/noclip - Toggle noclip (if enabled)
/revive [id] - Revive player
/kick [id] [reason] - Kick player
/ban [id] [reason] [hours] - Ban player
```

---

## 📚 Additional Resources

### **Documentation:**
- `README.md` - Main documentation
- `WEATHER_FIX_COMPLETE.md` - Weather fix details
- `WEATHERSYNC_INTEGRATION_FIX.md` - Technical details
- `INSTALLATION.md` - Original installation guide
- `QUICK_REFERENCE.md` - Quick command reference
- `MODULE_DEVELOPMENT.md` - Developer guide

### **Support:**
- GitHub Issues
- Discord Support Server
- RSG Framework Documentation

---

## ✅ Post-Installation Checklist

- [ ] Resources running (weathersync, QC-DevTools)
- [ ] Database table created (admin_reports)
- [ ] Admin permissions configured
- [ ] Server.cfg updated (correct order)
- [ ] Admin menu opens with `/admin`
- [ ] Weather control working (21 types)
- [ ] Time control working (syncs all players)
- [ ] Player management working
- [ ] Reports system working
- [ ] Development tools accessible

---

## 🎉 You're Ready!

### **Quick Test:**
```
1. Login as admin
2. Type: /admin
3. Go to: Server Options → Weather Control
4. Select: Sunny
5. Watch the smooth transition!
```

### **Features to Explore:**
- 🌤️ Weather Control (21 types)
- 🕐 Time Control
- 👥 Player Management
- 🛠️ Development Tools
- 📊 Entity Scanner
- 🎨 Visual Effects
- 🔊 Audio Testing

---

**Installation Complete!** ✅

**Version:** 1.2.0  
**Status:** Production Ready  
**Last Updated:** January 2025  

Enjoy your fully functional QC-DevTools with weathersync integration! 🎊
