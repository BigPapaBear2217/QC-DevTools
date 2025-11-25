# 🚀 QC-DevTools - Installation Guide

## 📋 Requirements

Before installing QC-DevTools, ensure you have the following:

### **Framework & Dependencies**
- ✅ **RedM Server** (Latest build recommended)
- ✅ **RSG Core Framework** - Main framework
- ✅ **ox_lib** - UI library and utilities
- ✅ **oxmysql** - Database operations

### **Optional (for specific features)**
- **rsg-medic** - For revive functionality (or compatible revive system)
- **rsg-log** - For admin action logging

---

## 📦 Installation Steps

### **1. Download/Clone the Resource**
```bash
cd resources
git clone [your-repo-url] QC-DevTools
# OR extract ZIP to resources/QC-DevTools
```

### **2. Install Dependencies**
Ensure these are in your `server.cfg` **before** QC-DevTools:
```cfg
ensure oxmysql
ensure ox_lib
ensure rsg-core
```

### **3. Database Setup**
Run this SQL if you want to use the ban system:
```sql
CREATE TABLE IF NOT EXISTS `bans` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) DEFAULT NULL,
    `license` varchar(50) DEFAULT NULL,
    `discord` varchar(50) DEFAULT NULL,
    `ip` varchar(50) DEFAULT NULL,
    `reason` text DEFAULT NULL,
    `expire` int(11) DEFAULT NULL,
    `bannedby` varchar(255) NOT NULL DEFAULT 'Anticheat',
    PRIMARY KEY (`id`),
    KEY `license` (`license`),
    KEY `discord` (`discord`),
    KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### **4. Configure the Resource**
Edit `shared/config.lua` to customize:

```lua
-- Enable/Disable Admin Menu
Config.AdminMenu = {
    enabled = true,              -- Set to false to disable admin features
    showInMainMenu = true,       -- Show in main devtools menu
    adminJobs = { 'admin', 'god' }, -- Your admin job names
    requireRSGCore = true
}

-- Set your admin jobs
Config.AdminMenu.adminJobs = { 'admin', 'god', 'moderator' }
```

### **5. Add to Server Config**
Add to your `server.cfg`:
```cfg
ensure QC-DevTools
```

### **6. Restart Server**
```bash
# Stop server, then start again
# OR use command:
refresh
ensure QC-DevTools
```

---

## 🎮 First-Time Setup

### **1. Test Basic Access**
In-game, type:
```
/devtools
```
You should see the main development tools menu.

### **2. Test Admin Access**
Make sure your character has an admin job:
```sql
-- In your database
UPDATE players 
SET job = '{"name":"admin","label":"Administrator","payment":0,"onduty":true,"isboss":true,"grade":{"name":"Boss","level":4}}' 
WHERE citizenid = 'YOUR_CITIZEN_ID';
```

Then type:
```
/admin
```
You should see the admin menu.

### **3. Test Dev Tools**
Try each module:
- `/devtools` → Ped Decals
- `/devtools` → Entity Information
- `/devtools` → Audio Testing

---

## ⚙️ Configuration Options

### **Admin Jobs**
Set which jobs can access admin features:
```lua
Config.AdminMenu.adminJobs = { 
    'admin',      -- Full admin
    'god',        -- Super admin
    'moderator'   -- Moderator access
}
```

### **Commands**
Customize commands:
```lua
Config.Commands = {
    mainMenu = 'devtools',  -- Main menu command
    adminMenu = 'admin',    -- Admin menu command
    pedDecals = 'dev_decals' -- Direct decal access
}
```

### **Module Toggle**
Enable/disable specific modules:
```lua
Config.Categories = {
    {
        id = 'adminmenu',
        enabled = true,  -- Set to false to disable
        -- ...
    }
}
```

---

## 🔧 Troubleshooting

### **Menu not opening**
```bash
# Check console:
F8 → Look for errors

# Common fixes:
ensure ox_lib
ensure rsg-core
restart QC-DevTools
```

### **Admin menu not showing**
1. Check your job in database
2. Verify job name matches `Config.AdminMenu.adminJobs`
3. Check console for permission errors
4. Restart resource: `restart QC-DevTools`

### **NUI not loading**
```bash
# Build the UI (if you modified it):
cd QC-DevTools/html
npm install
npm run build

# Then restart resource
```

### **Database errors**
- Verify oxmysql is working: `ensure oxmysql`
- Check MySQL connection in server.cfg
- Verify bans table exists (run SQL above)

### **Player management not working**
- Check RSG Core is loaded: `ensure rsg-core`
- Verify RSG Core version compatibility
- Check server console for callback errors

---

## 📊 Performance Tips

### **Optimize for Production**
```lua
-- In config.lua
Config.Permissions = {
    adminOnly = true,  -- Restrict to admins only
}
```

### **Disable Unused Modules**
```lua
Config.Categories = {
    {
        id = 'ptfx',
        enabled = false,  -- Disable if not needed
    }
}
```

---

## 🆙 Updating

### **From Version 1.0.0 → 1.1.0**
1. Backup your `shared/config.lua`
2. Replace all files except config
3. Merge your config settings
4. Run database updates (if any)
5. Restart resource

### **General Update Process**
```bash
# Pull latest changes
cd resources/QC-DevTools
git pull

# Rebuild UI if needed
cd html
npm run build

# Restart
restart QC-DevTools
```

---

## 🔐 Security Checklist

- ✅ Set proper admin jobs in config
- ✅ Don't give admin to untrusted players
- ✅ Review logs regularly for admin actions
- ✅ Keep framework and dependencies updated
- ✅ Use strong database passwords
- ✅ Test in development before production

---

## 📝 Server.cfg Example

Complete example of proper load order:
```cfg
# Database
set mysql_connection_string "mysql://user:password@localhost/database"

# Core Dependencies
ensure oxmysql
ensure ox_lib
ensure rsg-core

# Additional RSG Resources
ensure rsg-medic
ensure rsg-log

# QC-DevTools (Load after framework)
ensure QC-DevTools

# Your other resources...
```

---

## 🎯 Verification

After installation, verify everything works:

### **Dev Tools Check**
```
/devtools → ✅ Menu opens
→ Ped Decals → ✅ Decals apply
→ Entity Info → ✅ Scanner works
→ Audio → ✅ Sounds play
```

### **Admin Check**
```
/admin → ✅ Menu opens
→ Self Options → ✅ God mode toggles
→ Player Management → ✅ Can see players
→ Horse Spawner → ✅ Horse spawns
```

---

## 💡 Quick Start Commands

```bash
# Essential commands
/devtools        # Main development tools
/admin           # Admin menu
/dev_decals      # Quick access to decals

# Debug commands (dev only)
/ipl_test        # Test IPL teleport
/ipl_nearby      # Show nearby IPLs
```

---

## 🆘 Getting Help

### **Check Logs**
1. Server console (F8 in server)
2. Client console (F8 in-game)
3. Browser console (F12, if NUI issues)

### **Common Error Messages**
- `"RSGCore object not found"` → Ensure rsg-core loaded first
- `"No permission"` → Check admin job configuration
- `"Player not found"` → Target player may have disconnected
- `"Module not loaded"` → Resource not started properly

---

## ✅ Installation Complete!

You should now have:
- ✅ QC-DevTools installed and running
- ✅ Admin menu accessible with `/admin`
- ✅ All dev tools working with `/devtools`
- ✅ Proper permissions configured

**Enjoy your unified admin & dev tools experience!** 🎉

---

**Need more help?** Check:
- `README.md` - Feature documentation
- `README_ADMIN.md` - Admin system details
- Server console for error messages

**Developed by Quantum Projects**
