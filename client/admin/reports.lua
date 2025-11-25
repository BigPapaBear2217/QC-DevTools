local RSGCore = exports['rsg-core']:GetCoreObject()

-------------------------------------------------------------------
-- Reports System
-------------------------------------------------------------------

-- Open Reports Menu
RegisterNetEvent('qc-devtools:client:openReports', function()
    RSGCore.Functions.TriggerCallback('qc-devtools:server:getReports', function(reports)
        if not reports or #reports == 0 then
            lib.notify({ 
                title = 'Reports', 
                description = 'No active reports!', 
                type = 'inform' 
            })
            
            -- Show empty menu with option to refresh
            local menuData = {
                id = 'reports_menu',
                title = '📋 Reports System',
                subtitle = 'No active reports',
                back = 'admin_advanced_menu',
                options = {
                    {
                        id = 'refresh',
                        title = '🔄 Refresh',
                        description = 'Check for new reports',
                        icon = '🔄'
                    },
                    {
                        id = 'test_report',
                        title = '🧪 Create Test Report',
                        description = 'Create a test report for testing',
                        icon = '⚠️'
                    }
                }
            }
            ShowDevToolsMenu(menuData)
            return
        end
        
        local options = {}
        for _, report in ipairs(reports) do
            local statusIcon = report.status == 'open' and '🔴' or '✅'
            table.insert(options, {
                id = 'report_' .. report.id,
                title = statusIcon .. ' Report #' .. report.id .. ' - ' .. report.reporter_name,
                description = report.reason:sub(1, 50) .. (report.reason:len() > 50 and '...' or ''),
                icon = '📝'
            })
        end
        
        -- Add refresh option at top
        table.insert(options, 1, {
            id = 'refresh',
            title = '🔄 Refresh Reports',
            description = 'Check for new reports',
            icon = '🔄'
        })
        
        local menuData = {
            id = 'reports_menu',
            title = '📋 Reports System',
            subtitle = #reports .. ' active report(s)',
            back = 'admin_advanced_menu',
            options = options
        }
        ShowDevToolsMenu(menuData)
    end)
end)

-- Handle reports menu selection
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'reports_menu' then
        if optionId == 'refresh' then
            TriggerEvent('qc-devtools:client:openReports')
        elseif optionId == 'test_report' then
            TriggerServerEvent('qc-devtools:server:createTestReport')
            Wait(500)
            TriggerEvent('qc-devtools:client:openReports')
        else
            local reportId = tonumber(optionId:match('report_(%d+)'))
            if reportId then
                TriggerEvent('qc-devtools:client:viewReport', reportId)
            end
        end
    end
end)

-- View Report Details
RegisterNetEvent('qc-devtools:client:viewReport', function(reportId)
    currentReportId = reportId -- Store current report ID
    RSGCore.Functions.TriggerCallback('qc-devtools:server:getReport', function(report)
        if not report then
            lib.notify({ 
                title = 'Error', 
                description = 'Report not found!', 
                type = 'error' 
            })
            return
        end
        
        local menuData = {
            id = 'report_details',
            title = '📋 Report #' .. report.id,
            subtitle = 'Status: ' .. report.status,
            back = 'reports_menu',
            options = {
                {
                    id = 'info_reporter',
                    title = '👤 Reporter',
                    description = report.reporter_name .. ' (ID: ' .. report.reporter_id .. ')',
                    icon = '👤'
                },
                {
                    id = 'info_reported',
                    title = '🎯 Reported Player',
                    description = report.reported_name and (report.reported_name .. ' (ID: ' .. report.reported_id .. ')') or 'N/A',
                    icon = '🎯'
                },
                {
                    id = 'info_reason',
                    title = '📝 Reason',
                    description = report.reason,
                    icon = '📝'
                },
                {
                    id = 'info_time',
                    title = '🕐 Time',
                    description = report.created_at or 'Unknown',
                    icon = '⏰'
                },
                {
                    id = 'teleport_reporter',
                    title = '➡️ Teleport to Reporter',
                    description = 'Go to the player who made the report',
                    icon = '🎯'
                },
                {
                    id = 'teleport_reported',
                    title = '➡️ Teleport to Reported',
                    description = 'Go to the reported player',
                    icon = '🎯'
                },
                {
                    id = 'respond',
                    title = '💬 Respond',
                    description = 'Send a message to reporter',
                    icon = '✉️'
                },
                {
                    id = 'close_report',
                    title = report.status == 'open' and '✅ Close Report' or '🔓 Reopen Report',
                    description = report.status == 'open' and 'Mark as handled' or 'Mark as open',
                    icon = report.status == 'open' and '✅' or '🔓'
                },
                {
                    id = 'delete_report',
                    title = '🗑️ Delete Report',
                    description = 'Permanently remove this report',
                    icon = '❌'
                }
            }
        }
        ShowDevToolsMenu(menuData)
    end, reportId)
end)

-- Store current report ID
local currentReportId = nil

-- Handle report details actions
AddEventHandler('qc-devtools:nui:optionSelected', function(optionId, optionData, menuId)
    if menuId == 'report_details' then
        if optionId == 'teleport_reporter' then
            RSGCore.Functions.TriggerCallback('qc-devtools:server:getReport', function(report)
                if report and report.reporter_id then
                    TriggerServerEvent('qc-devtools:server:teleportToPlayer', report.reporter_id)
                end
            end, currentReportId)
        elseif optionId == 'teleport_reported' then
            RSGCore.Functions.TriggerCallback('qc-devtools:server:getReport', function(report)
                if report and report.reported_id then
                    TriggerServerEvent('qc-devtools:server:teleportToPlayer', report.reported_id)
                end
            end, currentReportId)
        elseif optionId == 'respond' then
            local input = lib.inputDialog('💬 Respond to Report', {
                {
                    type = 'textarea',
                    label = 'Message',
                    description = 'Your response to the reporter',
                    required = true,
                    min = 5,
                    max = 500
                }
            })
            
            if input then
                TriggerServerEvent('qc-devtools:server:respondToReport', currentReportId, input[1])
            end
        elseif optionId == 'close_report' then
            TriggerServerEvent('qc-devtools:server:toggleReportStatus', currentReportId)
            Wait(500)
            TriggerEvent('qc-devtools:client:openReports')
        elseif optionId == 'delete_report' then
            local confirm = lib.alertDialog({
                header = 'Delete Report',
                content = 'Are you sure you want to delete this report? This cannot be undone.',
                centered = true,
                cancel = true
            })
            
            if confirm == 'confirm' then
                TriggerServerEvent('qc-devtools:server:deleteReport', currentReportId)
                Wait(500)
                TriggerEvent('qc-devtools:client:openReports')
            end
        end
    end
end)

-------------------------------------------------------------------
-- Player Report Creation
-------------------------------------------------------------------
RegisterCommand('report', function(source, args)
    local input = lib.inputDialog('📋 Submit Report', {
        {
            type = 'select',
            label = 'Report Type',
            options = {
                { value = 'player', label = 'Report a Player' },
                { value = 'bug', label = 'Report a Bug' },
                { value = 'help', label = 'Request Help' },
                { value = 'other', label = 'Other' }
            },
            required = true
        },
        {
            type = 'number',
            label = 'Player ID (if reporting player)',
            description = 'Leave blank if not reporting a player',
            required = false,
            min = 0
        },
        {
            type = 'textarea',
            label = 'Description',
            description = 'Describe the issue in detail',
            required = true,
            min = 10,
            max = 500
        }
    })
    
    if not input then return end
    
    TriggerServerEvent('qc-devtools:server:createReport', input[1], input[2], input[3])
end)

print('^2[QC-DevTools]^0 Reports system loaded successfully!')
