# 📋 QC-DevTools - TODO List

**Last Updated:** January 2025  
**Status:** Work in Progress

---

## ❌ **CRITICAL - Must Fix First**

### 1. Free Character Movement with Menu Open ⭐⭐⭐ (HIGHEST PRIORITY)
**Issue:** Menu currently blocks all movement (fullscreen NUI)
**Impact:** Can't walk, ride, shoot, or interact while menu is open

**Solution Options:**
1. **Option A:** Create ox_lib context menu version (best for RSG/RedM)
2. **Option B:** Add keybind to toggle menu visibility
3. **Option C:** Use minimal overlay instead of fullscreen

**Why Critical:** Makes testing and admin work very difficult

**Technical Notes:**
- RedM uses different keybind system than GTA5
- Check `rsg-core` documentation for proper keybind implementation
- Native RedM uses: `RegisterKeyMapping()` and `RegisterCommand()`
- Example: `/admin toggle` command instead of M key
- Or use ox_lib context menus (position = 'top-right')

**Recommended Approach:**
```lua
-- Option 1: Command-based toggle
RegisterCommand('menutoggle', function()
    if nuiOpened then
        if nuiHidden then
            -- Show menu
        else
            -- Hide menu
        end
    end
end)

RegisterKeyMapping('menutoggle', 'Toggle Admin Menu', 'keyboard', 'M')
```

**Files to Modify:**
- `client/nui.lua` - Add toggle logic
- `html/src/App.tsx` - Handle hide/show messages
- Consider: Create ox_lib alternative

**Status:** Need team member to implement with proper RedM keybinds

---

## ❌ **BROKEN - Core Features Not Working**

### 2. Revive Self ⭐⭐⭐
**Status:** ✅ FIXED - Testing needed
**Location:** `/admin → Self Options → Revive Self`
**Expected:** Should revive player with fade effects and full health/stamina
**Fix Applied:**
- Changed `cache.ped` to `PlayerPedId()`
- Added debug prints to console
- Added notifications for each revive method
- Supports rsg-medic, QC-AdvancedMedic, and direct fallback

**Testing:**
1. `/admin → Self Options → Revive Self`
2. Check F8 console for debug messages
3. Should see which method is being used
4. Should revive with fade effects

**Files Modified:**
- `client/admin/main.lua` (lines 141-173)

### 3. Weather Control ⭐⭐
**Status:** ✅ WORKING (Was permission issue - user needed admin job)
**Location:** `/admin → Server Options → Weather Control`
**How it works:**
- Checks for rsg-weather (uses if available)
- Falls back to direct weather change
- Admin job required: 'admin' or 'god'
**Files:**
- `client/admin/server.lua`
- `server/admin.lua`

### 4. Time Control ⭐⭐
**Status:** Not working
**Location:** `/admin → Server Options → Time Control`
**Expected:** Should change server time for all players
**Current:** Time doesn't change
**Files Involved:**
- `client/admin/server.lua`
- `server/admin.lua`

### 5. Server Announcement ⭐⭐
**Status:** Not working
**Location:** `/admin → Server Options → Announcement`
**Expected:** Should send notification to all players
**Current:** No notification appears
**Files Involved:**
- `client/admin/server.lua`
- `server/admin.lua`

### 6. Give Item ⭐⭐⭐
**Status:** Not working
**Location:** `/admin → Advanced Tools → Give Item`
**Expected:** Search items, select player, give item
**Current:** Does nothing or errors
**Files Involved:**
- `client/admin/advanced.lua`
- `server/admin_advanced.lua`

### 7. Give Item to Self ⭐⭐⭐
**Status:** Not working
**Location:** `/admin → Advanced Tools → Give Item to Self`
**Expected:** Quick item give to yourself
**Current:** Does nothing or errors
**Files Involved:**
- `client/admin/advanced.lua`
- `server/admin_advanced.lua`

### 8. View Inventory ⭐⭐
**Status:** Not working (both options)
**Locations:**
- `/admin → Advanced Tools → View Inventory` (others)
- `/admin → Advanced Tools → View My Inventory` (self)
**Expected:** Should open inventory UI or show item list
**Current:** Does nothing or errors
**Files Involved:**
- `client/admin/advanced.lua`
- `server/admin_advanced.lua`
- rsg-inventory integration

---

## ❌ **INCOMPLETE - Partially Working**

### 9. Reports System ⭐⭐
**Status:** Partially working
**Working:**
- ✅ `/report` command works
- ✅ Reports are created
- ✅ Can see reports list
- ✅ Refresh button works
- ✅ Create test report works

**Not Working:**
- ❌ Can't view report details when clicking on report
- ❌ Can't read actual report content
- ❌ Can't respond to reports
- ❌ Can't close/delete reports

**Files Involved:**
- `client/admin/reports.lua`
- `server/admin_reports.lua`

### 10. Troll Players ⭐
**Status:** Missing self-troll option
**Working:**
- ✅ Can troll other players

**Missing:**
- ❌ Can't troll yourself for testing
- ❌ Need "Troll Self" option for admins

**Files Involved:**
- `client/admin/troll.lua`
- `server/admin_troll.lua`

### 11. Teleport to Player ⭐⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Teleport To`
**Expected:** Admin teleports to selected player location
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`
- `server/admin.lua`

### 12. Bring Player ⭐⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Bring Player`
**Expected:** Selected player teleports to admin location
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`
- `server/admin.lua`

### 13. Spectate Player ⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Spectate`
**Expected:** Admin spectates selected player (camera follows them)
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`

### 14. Freeze Player ⭐⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Freeze`
**Expected:** Selected player cannot move (frozen in place)
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`
- `server/admin.lua`

### 15. Revive Player ⭐⭐⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Revive`
**Expected:** Selected player is revived with full health/stamina
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`
- `server/admin.lua`

### 16. Money Operations ⭐⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Money Options`
**Expected:** Can add/remove cash, bank, bloodmoney from players
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`
- `server/admin.lua`

### 17. Kick Player ⭐⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Kick`
**Expected:** Selected player is kicked from server with reason
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`
- `server/admin.lua`

### 18. Ban Player ⭐⭐⭐
**Status:** Unknown (can't test solo)
**Location:** `/admin → Player Management → Select Player → Ban`
**Expected:** Selected player is banned (permanent or timed) with reason
**Current:** Unknown - needs testing with other players
**Files Involved:**
- `client/admin/players.lua`
- `server/admin.lua`

---

## 🆕 **NEW FEATURES TO ADD**

### 19. Item Search with Images 🆕
**Status:** Not implemented yet
**Description:** Visual item picker with images from inventory
**Features to Add:**
- Search through `rsg-core/shared/items.lua`
- Fetch item images from inventory `images/` folder
- Display item image in search results
- Visual grid/list view
- Click on image to select item
- Preview item details (label, description, weight)

**Example:**
```
Search: "revolver"
Results:
[IMG] Cattleman Revolver
[IMG] Schofield Revolver  
[IMG] Double-Action Revolver
```

**Files to Create/Modify:**
- `client/admin/item_search.lua` (new)
- `html/src/components/ItemSearch.tsx` (new)
- Modify give item system to use new picker

**Image Source:** 
- `rsg-inventory/html/images/` folder
- Fallback to placeholder if image not found

---

## ✅ **WORKING - No Issues**

### Working Features:
- ✅ Admin Menu Opens (`/admin`)
- ✅ Dev Tools Menu Opens (`/devtools`)
- ✅ Menu Navigation (can navigate between menus)
- ✅ Player Blips Toggle (shows players on map)
- ✅ Toggle Player IDs (shows IDs above heads)
- ✅ God Mode Toggle
- ✅ Invisibility Toggle
- ✅ Noclip Toggle
- ✅ Copy Coordinates
- ✅ Horse Spawner (all 5 horses work)

---

## 🎯 **Fix Priority Order**

### Phase 1: Critical UX (Week 1)
1. **Free Movement with Menu** - CRITICAL for testing
2. **Revive Self** - Core admin feature
3. **Give Item to Self** - Needed for testing

### Phase 2: Core Admin (Week 1)
4. **View Inventory** - Check items
5. **Weather Control** - Server management
6. **Time Control** - Server management
7. **Announcement** - Server communication

### Phase 3: Reports & Testing (Week 2)
8. **Reports Details View** - Complete reports system
9. **Troll Self** - Testing option

### Phase 4: Player Management (Week 2-3) - Needs Multiple Players
10. **Teleport to Player** - Test with other players
11. **Bring Player** - Test with other players
12. **Spectate Player** - Test with other players
13. **Freeze Player** - Test with other players
14. **Revive Player** - Test with other players
15. **Money Operations** - Test with other players
16. **Kick Player** - Test with other players
17. **Ban Player** - Test with other players

### Phase 5: Enhancements (Week 3-4)
18. **Item Search with Images** - Visual improvement

---

## 📝 **Testing Notes**

### How to Test Each Feature:

#### **Revive:**
```
1. Take damage or die
2. /admin → Self Options → Revive Self
3. Should revive with fade effect
```

#### **Weather:**
```
1. /admin → Server Options → Weather Control
2. Select weather type
3. Weather should change for all players
```

#### **Time:**
```
1. /admin → Server Options → Time Control
2. Enter hour (0-23) and minute (0-59)
3. Time should change for all players
```

#### **Announcement:**
```
1. /admin → Server Options → Announcement
2. Type message
3. All players should see notification
```

#### **Give Item:**
```
1. /admin → Advanced Tools → Give Item to Self
2. Search for item (e.g., "revolver")
3. Select item and amount
4. Item should appear in inventory
```

#### **View Inventory:**
```
1. /admin → Advanced Tools → View My Inventory
2. Should open inventory UI or show item list
```

#### **Reports:**
```
1. /report → Submit test report
2. /admin → Advanced Tools → Reports
3. Click on report
4. Should see report details
5. Should be able to respond/close/delete
```

---

## 🐛 **Known Issues**

### Current Bugs:
1. Fullscreen NUI blocks movement
2. Revive not triggering properly
3. Server options not sending to server correctly
4. Give item callback not working
5. Reports details not displaying
6. No self-troll option

### Console Errors to Check:
- Check F8 for client errors
- Check server console for server errors
- Check for missing events
- Check for callback failures

---

## 📁 **Files That Need Work**

### Client Files:
- `client/admin/main.lua` - Revive fix
- `client/admin/server.lua` - Weather/time/announcement fix
- `client/admin/advanced.lua` - Give item/inventory fix
- `client/admin/reports.lua` - Report details view fix
- `client/admin/troll.lua` - Add self-troll option

### Server Files:
- `server/admin.lua` - Weather/time/announcement handlers
- `server/admin_advanced.lua` - Give item/inventory handlers
- `server/admin_reports.lua` - Report details callback

### New Files to Create:
- `client/admin/item_search.lua` - Image-based item search
- `html/src/components/ItemSearch.tsx` - React component

---

## 💡 **Ideas for Future**

### Future Enhancements:
- [ ] Database storage for reports
- [ ] Discord webhook for reports
- [ ] Player notes system
- [ ] Saved coordinates/locations
- [ ] Teleport history
- [ ] Admin action logs
- [ ] Keybind customization
- [ ] Quick admin toolbar (hotkeys)
- [ ] Drag & drop menu positioning
- [ ] Theme customization
- [ ] Multi-language support

---

## 📊 **Progress Tracker**

**Total Features:** 60+
- ✅ Working: 10 features (17%)
- ❌ Broken: 8 features (13%)
- ❌ Incomplete: 2 features (3%)
- ⚠️ Unknown/Need Testing: 8 features (13%) - Player Management
- 🆕 To Add: 1 feature (2%)
- ✅ Complete: 31 features (52%)

**Estimated Time to Fix All:**
- Phase 1 (Critical): 2-3 days
- Phase 2 (Core): 2-3 days
- Phase 3 (Reports): 1-2 days
- Phase 4 (Player Management): 2-3 days (needs multiple players)
- Phase 5 (Enhancement): 3-5 days

**Total:** ~3 weeks for complete system

---

## 📞 **Help Needed**

### Testing Requirements:
- [ ] Need multiple players online to test player management
- [ ] Need to test on live server with real players
- [ ] Need to test reports with real player submissions

### Documentation Needed:
- [ ] Video tutorial for admins
- [ ] Command reference card
- [ ] Troubleshooting guide
- [ ] Setup guide for new servers

---

## ✅ **Completion Criteria**

### Feature is "Done" When:
1. ✅ Works as expected
2. ✅ No errors in console
3. ✅ Tested with multiple scenarios
4. ✅ Documented in README
5. ✅ No known bugs

---

**Next Step:** Start with #1 (Free Movement) to make testing easier, then fix core features.

**Questions?** Ask before starting each fix!

---

**Status:** Ready to Start  
**Priority:** Fix #1 First (Free Movement)  
**Timeline:** 2 weeks for complete system
