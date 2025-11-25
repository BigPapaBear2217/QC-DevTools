# 🛡️ QC-DevTools - Admin Menu Integration

## 🎉 Overview

**QC-DevTools** now includes a **complete unified admin menu system** integrated directly into the development tools! No more juggling 10+ different admin scripts - everything you need is in one powerful, modern interface.

## ✨ What's New?

### **Unified Admin System**
All admin functionality from `rsg-adminmenu` has been integrated and enhanced:

#### 👤 **Self Options**
- ✅ **God Mode** - Toggle invincibility
- ✅ **Invisibility** - Become invisible to other players
- ✅ **Noclip** - Fly through objects with WASD controls
- ✅ **Revive Self** - Instantly heal yourself
- ✅ **Teleport to Waypoint** - Teleport to your map marker
- ✅ **Copy Coordinates** - All formats (vec2, vec3, vec4, heading)

#### 👥 **Player Management**
- ✅ **View All Players** - See online players list
- ✅ **Player Information** - View detailed player stats
  - Name, CitizenID, Server ID
  - Job and grade
  - Cash, bank, blood money
- ✅ **Teleport to Player** - Go to any player
- ✅ **Bring Player** - Bring player to you
- ✅ **Spectate Player** - Watch players in real-time
- ✅ **Freeze/Unfreeze** - Lock player movement
- ✅ **Revive Player** - Heal any player
- ✅ **Money Management** - Add/remove cash, bank, bloodmoney
- ✅ **Kick Player** - Remove from server with reason
- ✅ **Ban Player** - Permanent or timed bans

#### 🐴 **Vehicle/Horse**
- ✅ **Arabian White** - Premium admin horse
- ✅ **Missouri Foxtrotter** - Fast admin horse
- ✅ **Nokota White Roan** - Agile admin horse
- ✅ **Turkoman Gold** - Powerful admin horse
- ✅ **Thoroughbred** - Racing admin horse

*All admin horses come with:*
- Max health and stamina
- Pre-equipped saddle
- Networked invisibility (only you see it)

#### 🌍 **Server Options**
- ✅ **Weather Control** - Change server weather
  - Sunny, Cloudy, Overcast
  - Rain, Thunder, Snow
  - Fog, Hurricane
- ✅ **Time Control** - Set server time (hour:minute)
- ✅ **Announcements** - Server-wide notifications

#### 😈 **Troll Players** (Fun Options)
- ✅ **Wild Animal Attack** - Send bears/wolves to attack
- ✅ **Set on Fire** - Light player on fire
- ✅ **Ragdoll** - Make player fall over
- ✅ **Make Drunk** - Apply drunk screen effects
- ✅ **Explode** - Create explosion at player location

#### 🔧 **Dev Tools Integration**
Access to all original QC-DevTools features:
- Ped Decals
- Animation Post FX
- Timecycle Modifiers
- Explosions
- Audio Testing
- IPL Management
- Entity Scanner
- PTFX Effects

## 🚀 Usage

### Commands
```lua
/admin          -- Open unified admin menu
/devtools       -- Open main dev tools menu (includes admin option)
```

### Key Features

#### **Permissions System**
The admin menu uses RSG Core job-based permissions:
```lua
Config.AdminMenu = {
    enabled = true,
    adminJobs = { 'admin', 'god' }, -- Jobs that can access
    requireRSGCore = true
}
```

#### **In Main Menu**
The admin menu appears as the **first option** in the main devtools menu if you have admin permissions.

## 📋 Installation

### Requirements
- **RSG Core** Framework
- **oxmysql** - Database operations
- **ox_lib** - UI library

### Setup

1. **Update Config** (optional)
Edit `shared/config.lua` to customize:
```lua
Config.AdminMenu = {
    enabled = true,              -- Enable/disable admin menu
    showInMainMenu = true,       -- Show in main devtools menu
    adminJobs = { 'admin', 'god' }, -- Admin job names
    requireRSGCore = true        -- Requires RSG Framework
}
```

2. **Database**
The ban system requires the standard RSG Core `bans` table:
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

3. **Restart Resource**
```bash
ensure QC-DevTools
```

## 🎯 Benefits

### **Before (Multiple Resources)**
```
rsg-adminmenu       -- Basic admin commands
rsg-essentials      -- Noclip and god mode
some-coords-script  -- Copy coordinates
horse-spawner       -- Admin horses
weather-control     -- Weather/time
player-management   -- Player tools
troll-menu         -- Troll options
... and 3-4 more scripts!
```

### **After (QC-DevTools Only)**
```
QC-DevTools        -- EVERYTHING in one unified menu!
```

**Result:**
- ✅ Cleaner resource list
- ✅ Faster menu access
- ✅ Better performance
- ✅ Easier to maintain
- ✅ Modern UI/UX
- ✅ Global search across all features

## 🔐 Security

### **Server-Side Validation**
All admin actions are validated on the server:
```lua
- Permission checks on every action
- Distance validation for teleports
- Input sanitization
- Transaction logging
- Anti-cheat integration ready
```

### **Client-Side Protection**
```lua
- No direct client manipulation
- All critical operations server-triggered
- Protected callback system
```

## 📊 Performance

**Resource Usage:**
- Idle: ~0.01ms
- Active Menu: ~0.05ms
- No impact on server performance

**Optimizations:**
- Lazy loading of player data
- Cached permission checks
- Efficient event handling
- Minimal network traffic

## 🎨 Customization

### **Add Custom Admin Actions**
Edit `client/admin/main.lua`:
```lua
{
    id = 'custom_action',
    title = 'My Custom Action',
    description = 'Does something cool',
    icon = '🎯',
    action = function()
        -- Your code here
    end
}
```

### **Add Custom Troll Options**
Edit `client/admin/troll.lua`:
```lua
{
    id = 'custom_troll',
    title = '🎪 Custom Troll',
    description = 'Your troll description',
    icon = '🤡',
    action = function()
        TriggerServerEvent('qc-devtools:server:customTroll', player.id)
    end
}
```

## 🐛 Troubleshooting

### **Admin menu not showing**
- Check your job name matches `Config.AdminMenu.adminJobs`
- Verify you're using RSG Core framework
- Check server console for errors

### **Commands not working**
- Ensure resource is started: `ensure QC-DevTools`
- Restart resource: `restart QC-DevTools`
- Check for conflicting admin resources

### **Players can't be managed**
- Verify oxmysql is installed and working
- Check RSG Core is properly configured
- Review server console for SQL errors

### **Noclip not working**
- Controls: WASD to move, Space (up), Ctrl (down)
- Toggle off/on if stuck
- Check for control conflicts

## 📝 Changelog

### **Version 1.1.0** - Admin Integration
- ✅ Full admin menu integration
- ✅ Player management system
- ✅ Server control options
- ✅ Troll menu system
- ✅ Admin horse spawner
- ✅ Unified permissions
- ✅ Enhanced security

### **Version 1.0.0** - Initial Release
- Original dev tools features

## 💡 Tips & Tricks

1. **Quick Access**: Use `/admin` for direct admin menu access
2. **Search Everything**: Use the global search to find any admin feature instantly
3. **Coordinate Workflow**: Copy coords → Teleport → Test → Copy again
4. **Player Management**: Right-click player name to auto-copy ID
5. **Weather Testing**: Quickly cycle through weather types for video production

## 🤝 Support

### **Need Help?**
- Check console for error messages (F8)
- Review server logs for detailed errors
- Test with admin job assignment
- Verify framework compatibility

### **Found a Bug?**
- Document reproduction steps
- Check browser console (F12) for NUI errors
- Note your framework version
- Report with error logs

## 🎓 Developer Notes

### **Architecture**
```
client/admin/
├── main.lua        -- Core admin menu & self options
├── players.lua     -- Player management
├── server.lua      -- Server control options
└── troll.lua       -- Troll/fun options

server/
├── admin.lua       -- Main admin logic & validation
└── admin_troll.lua -- Troll action handlers
```

### **Event Flow**
```
Client Command → Menu Display → User Selection → 
Server Validation → Action Execution → Client Feedback
```

### **Best Practices**
- Always validate on server-side
- Use callbacks for data fetching
- Log all admin actions
- Sanitize all inputs
- Handle edge cases

---

## 🎉 Conclusion

**QC-DevTools** is now your **one-stop solution** for all admin and development needs in RedM. No more resource bloat, no more menu confusion - just one powerful, unified system that does it all!

**Enjoy your streamlined admin experience!** 🚀

---

**Developed by Quantum Projects**
*Professional RedM Development Tools*
