# QC-DevTools

![License: GPLv3](https://img.shields.io/badge/License-GPLv3-yellow.svg)
![Platform: RedM](https://img.shields.io/badge/Platform-RedM-red)
![Framework: React](https://img.shields.io/badge/Frontend-React-lightblue)
![Language: Lua](https://img.shields.io/badge/Backend-Lua-orange)
![Version: Beta](https://img.shields.io/badge/Version-Beta-important)

**Advanced RedM Development Tools Framework**

*By Quantum Projects*

## 🚀 Overview

QC-DevTools is a comprehensive, modular development framework for RedM featuring a modern React-based NUI interface, global search functionality, and automatic clipboard integration. Designed to streamline testing and development workflows for RedM server developers.

## ✨ Features
-  🎨 **Modern NUI Interface**
- 🔍 **Global Search System**
- 📋 **Automatic Clipboard Integration**
- 🧩 **Modular Architecture**

## 📦 Included Modules

### 🔧 **Development Tools**
- 🎨 **Ped Decals** - Apply decals, scars, and damage effects
- 💥 **Explosions** - Test all explosion types safely
- 🔊 **Audio System** - Test sounds, music, and speech
- 🏢 **IPL Management** - Enable/disable interior placements
- 🎭 **Animation Post FX** - Visual effects and filters
- 🌅 **Timecycle Modifiers** - Environmental visual effects
- ✨ **PTFX Effects** - Particle effects testing
- 📡 **Entity Information** - Advanced entity scanner

### 🛡️ **Admin System** (NEW in v1.1.0)
- 👤 **Self Options** - God mode, invisibility, noclip, revive, teleport
- 👥 **Player Management** - View info, teleport, spectate, freeze, money, kick/ban
- 🐴 **Horse Spawner** - 5 premium admin horses with max stats
- 🌍 **Server Control** - Weather, time, announcements
- 😈 **Troll Menu** - Fun options (animal attacks, fire, drunk, explosions)

## 🛠️ Installation

### **Quick Start**
1. **Download** the latest release
2. **Extract** to your RedM resources folder
3. **Add dependencies** to server.cfg:
   ```cfg
   ensure oxmysql
   ensure ox_lib
   ensure rsg-core
   ensure QC-DevTools
   ```
4. **Configure** admin jobs in `shared/config.lua`:
   ```lua
   Config.AdminMenu.adminJobs = { 'admin', 'god' }
   ```
5. **Import database** (for ban system):
   ```sql
   -- See INSTALLATION.md for SQL
   ```
6. **Restart** server and enjoy!

📖 **Detailed Instructions:** See [INSTALLATION.md](INSTALLATION.md)

### Entity Scanner
1. Navigate to "Entity Information"
2. Scanner activates automatically
3. Look at entities to see live data
4. Right-click to capture and view details

## 🖼️ Preview

<img width="534" height="857" alt="image" src="https://github.com/user-attachments/assets/c2f26dc1-f9b4-4824-a190-f1829a938388" />

## 🎮 Usage

### **Commands**
```bash
/devtools        # Open main development tools menu
/admin           # Open admin menu directly
/dev_decals      # Quick access to ped decals
```

### **For Administrators**
1. Open admin menu with `/admin` or `/devtools`
2. Select from available options:
   - **Self Options** - Personal admin powers
   - **Player Management** - Control other players
   - **Server Options** - Weather, time, announcements
   - **Troll Menu** - Fun interactions
   - **Horse Spawner** - Get admin horses

📖 **Full Admin Guide:** See [README_ADMIN.md](README_ADMIN.md)

### **For Developers**
1. Open with `/devtools`
2. Use global search (type to search all features)
3. Navigate through categories
4. Test features with clipboard auto-copy
5. Use entity scanner for coordinates and hashes

## 🔧 Development

### Creating Custom Modules

QC-DevTools features a comprehensive module development system. See [MODULE_DEVELOPMENT.md](MODULE_DEVELOPMENT.md) for detailed instructions on:

- Module structure and organization
- Menu system API usage
- Notification system integration
- Auto-copy functionality implementation
- Global search integration
- Testing and deployment

### Module Development Quick Start
```lua
-- Basic module template
RegisterNetEvent('qc-devtools:client:openYourModule')
AddEventHandler('qc-devtools:client:openYourModule', function()
    local menuData = {
        id = 'yourmodule',
        title = 'Your Module',
        subtitle = 'Module description',
        options = {
            {
                id = 'action1',
                title = 'Action Button',
                description = 'Performs an action',
                icon = '🎯'
            }
        }
    }
    ShowDevToolsMenu(menuData)
end)
```

## 🎨 UI Customization

The NUI interface supports theming and customization:
- Modify `html/src/index.css` for styling changes
- Update assets in `html/public/assets/`
- React components in `html/src/components/`
- Build with `npm run build` in the html directory

## 🐛 Troubleshooting

### Common Issues

**Menu not opening:**
- Check F8 console for errors
- Verify resource is started: `ensure QC-DevTools`
- Check dependencies are loaded

**Admin menu not showing:**
- Verify your job matches `Config.AdminMenu.adminJobs`
- Check you're using RSG Core framework
- Restart resource: `restart QC-DevTools`

**NUI not loading:**
- Ensure `html/dist/` folder exists
- Run `npm install && npm run build` in html directory

**Player management not working:**
- Check RSG Core is loaded first
- Verify oxmysql connection
- Review server console for errors

📖 **Full Troubleshooting:** See [INSTALLATION.md](INSTALLATION.md)

## 📋 Requirements

### **Essential**
- **RedM** server (latest build)
- **RSG Core** framework
- **ox_lib** - UI library
- **oxmysql** - Database operations

### **Optional**
- **rsg-medic** - For revive functionality
- **rsg-log** - For admin action logging
- **Node.js** - For UI development only

## 🤝 Contributing

QC-DevTools is open source! We welcome contributions from the community.

### How to Contribute

1. **Fork** this repository
2. **Create** a feature branch
3. **Make** your changes following our coding standards
4. **Test** thoroughly across different scenarios  
5. **Submit** a pull request with detailed description

### Contribution Guidelines

- Follow existing code patterns and structure
- Include comprehensive error handling
- Test all functionality before submitting
- Respect the modular architecture

### Report Issues

If you encounter bugs or have feature requests:
- Check existing issues first
- Provide detailed reproduction steps
- Include error logs and system information
- Be respectful and constructive

For direct contact, reach out to the project maintainer.

## 📄 License

This project is open source and available under the GPLv3 License. Feel free to use, modify, and distribute according to the license terms.

## 🙏 Credits

### 🏗️ **Core Development**
**Quantum Projects** - *Project Architecture, NUI Framework & Module Integration*

### 📚 **Original Tool Inspirations**
QC-DevTools builds upon the excellent work of several community developers:

- **[Wartype](https://github.com/iamvillain)** - *Audio Development Tool*  
  Original audio system implementations and RedM audio native research

- **[Blaze Scripts](https://github.com/Blaze-Scripts)** - *Entity Information Tool*  
  Entity scanning methodologies and raycasting techniques

- **[RicX](https://github.com/zelbeus)** - *Animation Post FX Tool*  
  Visual effects system and animation post FX implementations

- **[T3chman](https://github.com/t3chman)** - *IPL Management Tool*  
  Interior placement systems and IPL handling techniques

### 💪 **Powered By Open Source**
*QC-DevTools is built on the shoulders of giants - we're proud to contribute back to the RedM development community with our own open source modular tool for developers.*

**🚀 Developed with ❤️ by Quantum Projects**

*Professional RedM development tools for the modern developer*
