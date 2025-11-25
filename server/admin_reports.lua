local RSGCore = exports['rsg-core']:GetCoreObject()

-- In-memory reports storage (you can add database later)
local reports = {}
local reportIdCounter = 1

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

-------------------------------------------------------------------
-- Create Report (Player Command)
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:server:createReport', function(reportType, reportedId, description)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local report = {
        id = reportIdCounter,
        reporter_id = src,
        reporter_name = GetPlayerName(src),
        reporter_citizenid = Player.PlayerData.citizenid,
        reported_id = reportedId,
        reported_name = reportedId and GetPlayerName(reportedId) or nil,
        type = reportType,
        reason = description,
        status = 'open',
        created_at = os.date('%Y-%m-%d %H:%M:%S'),
        admin_response = nil
    }
    
    reports[reportIdCounter] = report
    reportIdCounter = reportIdCounter + 1
    
    -- Notify player
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Report Submitted',
        description = 'Your report (#' .. report.id .. ') has been submitted. An admin will review it shortly.',
        type = 'success',
        duration = 7000
    })
    
    -- Notify all online admins
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if HasAdminPermission(tonumber(playerId)) then
            TriggerClientEvent('ox_lib:notify', tonumber(playerId), {
                title = '📋 New Report',
                description = 'Report #' .. report.id .. ' from ' .. GetPlayerName(src) .. '\nType: ' .. reportType,
                type = 'inform',
                duration = 7000
            })
        end
    end
    
    -- Log
    print('^3[QC-DevTools Reports]^0 New report #' .. report.id .. ' from ' .. GetPlayerName(src))
end)

-------------------------------------------------------------------
-- Get All Reports
-------------------------------------------------------------------
RSGCore.Functions.CreateCallback('qc-devtools:server:getReports', function(source, cb)
    if not HasAdminPermission(source) then
        cb({})
        return
    end
    
    -- Convert to array and filter active reports
    local reportsList = {}
    for _, report in pairs(reports) do
        table.insert(reportsList, report)
    end
    
    -- Sort by ID (newest first)
    table.sort(reportsList, function(a, b) return a.id > b.id end)
    
    cb(reportsList)
end)

-------------------------------------------------------------------
-- Get Single Report
-------------------------------------------------------------------
RSGCore.Functions.CreateCallback('qc-devtools:server:getReport', function(source, cb, reportId)
    if not HasAdminPermission(source) then
        cb(nil)
        return
    end
    
    cb(reports[reportId])
end)

-------------------------------------------------------------------
-- Respond to Report
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:server:respondToReport', function(reportId, message)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local report = reports[reportId]
    if not report then return end
    
    report.admin_response = message
    report.admin_name = GetPlayerName(src)
    report.responded_at = os.date('%Y-%m-%d %H:%M:%S')
    
    -- Notify reporter if online
    local reporterOnline = GetPlayerPing(report.reporter_id) > 0
    if reporterOnline then
        TriggerClientEvent('ox_lib:notify', report.reporter_id, {
            title = '📋 Report Response',
            description = 'Admin response to report #' .. reportId .. ':\n' .. message,
            type = 'inform',
            duration = 10000
        })
    end
    
    -- Notify admin
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Response Sent',
        description = 'Your response has been sent to the reporter.',
        type = 'success'
    })
    
    -- Log
    print('^3[QC-DevTools Reports]^0 Admin ' .. GetPlayerName(src) .. ' responded to report #' .. reportId)
end)

-------------------------------------------------------------------
-- Toggle Report Status (Open/Closed)
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:server:toggleReportStatus', function(reportId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local report = reports[reportId]
    if not report then return end
    
    report.status = report.status == 'open' and 'closed' or 'open'
    report.closed_by = GetPlayerName(src)
    report.closed_at = os.date('%Y-%m-%d %H:%M:%S')
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Report Status',
        description = 'Report #' .. reportId .. ' marked as ' .. report.status,
        type = 'success'
    })
    
    -- Notify reporter if online
    local reporterOnline = GetPlayerPing(report.reporter_id) > 0
    if reporterOnline and report.status == 'closed' then
        TriggerClientEvent('ox_lib:notify', report.reporter_id, {
            title = '📋 Report Closed',
            description = 'Your report #' .. reportId .. ' has been handled by an admin.',
            type = 'success',
            duration = 7000
        })
    end
    
    -- Log
    print('^3[QC-DevTools Reports]^0 Admin ' .. GetPlayerName(src) .. ' changed report #' .. reportId .. ' status to ' .. report.status)
end)

-------------------------------------------------------------------
-- Delete Report
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:server:deleteReport', function(reportId)
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    if reports[reportId] then
        reports[reportId] = nil
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Report Deleted',
            description = 'Report #' .. reportId .. ' has been deleted.',
            type = 'success'
        })
        
        -- Log
        print('^3[QC-DevTools Reports]^0 Admin ' .. GetPlayerName(src) .. ' deleted report #' .. reportId)
    end
end)

-------------------------------------------------------------------
-- Create Test Report (for testing)
-------------------------------------------------------------------
RegisterNetEvent('qc-devtools:server:createTestReport', function()
    local src = source
    
    if not HasAdminPermission(src) then return end
    
    local report = {
        id = reportIdCounter,
        reporter_id = src,
        reporter_name = GetPlayerName(src) .. ' (TEST)',
        reporter_citizenid = 'TEST123',
        reported_id = nil,
        reported_name = nil,
        type = 'help',
        reason = 'This is a test report to demonstrate the reports system functionality.',
        status = 'open',
        created_at = os.date('%Y-%m-%d %H:%M:%S'),
        admin_response = nil
    }
    
    reports[reportIdCounter] = report
    reportIdCounter = reportIdCounter + 1
    
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Test Report',
        description = 'Test report #' .. report.id .. ' created!',
        type = 'success'
    })
end)

-------------------------------------------------------------------
-- Clean Old Reports (Optional - run periodically)
-------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(3600000) -- Every hour
        
        local now = os.time()
        local deleted = 0
        
        for id, report in pairs(reports) do
            if report.status == 'closed' then
                -- Delete closed reports older than 24 hours
                local reportTime = os.time({
                    year = tonumber(report.created_at:sub(1, 4)),
                    month = tonumber(report.created_at:sub(6, 7)),
                    day = tonumber(report.created_at:sub(9, 10)),
                    hour = tonumber(report.created_at:sub(12, 13)),
                    min = tonumber(report.created_at:sub(15, 16)),
                    sec = tonumber(report.created_at:sub(18, 19))
                })
                
                if now - reportTime > 86400 then -- 24 hours
                    reports[id] = nil
                    deleted = deleted + 1
                end
            end
        end
        
        if deleted > 0 then
            print('^3[QC-DevTools Reports]^0 Cleaned ' .. deleted .. ' old reports')
        end
    end
end)

print('^2[QC-DevTools]^0 Reports server module loaded successfully!')
