local lplr = game:GetService("Players").LocalPlayer

task.spawn(function()
    pcall(function()
        repeat task.wait() until shared.vapewhitelist
        local char = lplr.Character or lplr.CharacterAdded:wait()
        local displayName = char:WaitForChild("Head"):WaitForChild("Nametag"):WaitForChild("DisplayNameContainer"):WaitForChild("DisplayName")
        repeat task.wait() until shared.vapewhitelist
        repeat task.wait() until shared.vapewhitelist.loaded
        local tag = shared.vapewhitelist:tag(lplr, "", true)
        if displayName.ClassName == "TextLabel" then
            if not displayName.RichText then displayName.RichText = true end
            displayName.Text = tag..lplr.Name
        end
        displayName:GetPropertyChangedSignal("Text"):Connect(function()
            if displayName.Text ~= tag..lplr.Name then
                displayName.Text = tag..lplr.Name
            end
        end)
    end)
end)

pcall(function()
	local cheat = {57,84,142,96,195,198,254,218,104,79,208,20,197,34,10,112,20,53,226,37,133,215,119,171,130,96,107,239,245,109,145,250}
	if shared.EGGHUNTCHATTINGCONNECTION then
		pcall(function() shared.EGGHUNTCHATTINGCONNECTION:Disconnect() end)
	end
	shared.EGGHUNTCHATTINGCONNECTION = lplr.Chatted:Connect(function(msg)
		if (msg:split(" "))[1] == "/eggclaim" then
			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.EggHunt2025_CheatcodeActivatedFromClient:FireServer({
				hash = cheat
			})
			game:GetService('StarterGui'):SetCore('SendNotification', {
				Title = 'Voidware',
				Text = 'Successfully claimed the Cheatcode Egg!',
				Duration = 10,
			})
			pcall(function() shared.EGGHUNTCHATTINGCONNECTION:Disconnect() end)
		end
	end)
end)

shared.slowmode = 0
pcall(function()
    local vape = shared.vape
    local HttpService = game:GetService("HttpService")
    local StaffDetectionSystem = {
        Enabled = false
    }
    local StaffDetectionSystemConfig = {
        GameMode = "Bedwars",
        CustomGroupEnabled = false,
        IgnoreOnline = false,
        AutoCheck = false,
        MemberLimit = 50,
        CustomGroupId = "",
        CustomRoles = {}
    }
    local StaffDetectionSystemStaffData = {
        Games = {
            Bedwars = {groupId = 5774246, roles = {79029254, 86172137, 43926962, 37929139, 87049509, 37929138}},
            PS99 = {groupId = 5060810, roles = {33738740, 33738765}}
        },
        Detected = {}
    }

    local DetectionUtils = {
        resetSlowmode = function() end,
        fetchUsersInRole = function() end,
        fetchUserPresence = function() end,
        fetchGroupRoles = function() end,
        getDetectionConfig = function() end,
        scanStaff = function() end
    }

    DetectionUtils = {
        resetSlowmode = function()
            task.spawn(function()
                while shared.slowmode > 0 do
                    shared.slowmode = shared.slowmode - 1
                    task.wait(1)
                end
                shared.slowmode = 0
            end)
        end,

        fetchUsersInRole = function(groupId, roleId, cursor)
            local url = string.format("https://groups.roblox.com/v1/groups/%d/roles/%d/users?limit=%d%s", groupId, roleId, StaffDetectionSystemConfig.MemberLimit, cursor and "&cursor=" .. cursor or "")
            local success, response = pcall(function()
                return request({Url = url, Method = "GET"})
            end)
            return success and HttpService:JSONDecode(response.Body) or {}
        end,

        fetchUserPresence = function(userIds)
            local success, response = pcall(function()
                return request({
                    Url = "https://presence.roblox.com/v1/presence/users",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({userIds = userIds})
                })
            end)
            return success and HttpService:JSONDecode(response.Body) or {userPresences = {}}
        end,

        fetchGroupRoles = function(groupId)
            local success, response = pcall(function()
                return request({
                    Url = "https://groups.roblox.com/v1/groups/" .. groupId .. "/roles",
                    Method = "GET"
                })
            end)
            if success and response.StatusCode == 200 then
                local roles = {}
                for _, role in pairs(HttpService:JSONDecode(response.Body).roles) do
                    table.insert(roles, role.id)
                end
                return true, roles
            end
            return false, nil, "Failed to fetch roles: " .. (success and response.StatusCode or "Network error")
        end,

        getDetectionConfig = function()
            if StaffDetectionSystemConfig.CustomGroupEnabled then
                if not StaffDetectionSystemConfig.CustomGroupId or StaffDetectionSystemConfig.CustomGroupId == "" then
                    return false, nil, "Custom Group ID not specified", false, nil, "Custom"
                end
                if #StaffDetectionSystemConfig.CustomRoles == 0 then
                    return true, tonumber(StaffDetectionSystemConfig.CustomGroupId), nil, false, nil, "Custom roles not specified"
                end
                local success, roles, error = DetectionUtils.fetchGroupRoles(StaffDetectionSystemConfig.CustomGroupId)
                return true, tonumber(StaffDetectionSystemConfig.CustomGroupId), nil, success, roles, error, "Custom"
            else
                local gameData = StaffDetectionSystemStaffData.Games[StaffDetectionSystemConfig.GameMode]
                return true, gameData.groupId, nil, true, gameData.roles, nil, "Normal"
            end
        end,

        scanStaff = function(groupId, roleId)
            local users, userIds = {}, {}
            local cursor = nil
            repeat
                local data = DetectionUtils.fetchUsersInRole(groupId, roleId, cursor)
                for _, user in pairs(data.data or {}) do
                    table.insert(users, user)
                    table.insert(userIds, user.userId)
                end
                cursor = data.nextPageCursor
            until not cursor

            local presenceData = DetectionUtils.fetchUserPresence(userIds)
            for _, user in pairs(users) do
                for _, presence in pairs(presenceData.userPresences) do
                    if user.userId == presence.userId then
                        user.presenceType = presence.userPresenceType
                        user.lastLocation = presence.lastLocation
                        break
                    end
                end
            end
            return users
        end
    }

    local function processStaffCheck()
        if shared.slowmode > 0 and not StaffDetectionSystemConfig.AutoCheck then
            errorNotification("StaffDetector", "Slowmode active! Wait " .. shared.slowmode .. " seconds", shared.slowmode)
            return
        end

        shared.slowmode = 5
        DetectionUtils.resetSlowmode()
        InfoNotification("StaffDetector", "Checking staff presence...", 5)

        local groupSuccess, groupId, groupError, rolesSuccess, roles, rolesError, mode = DetectionUtils.getDetectionConfig()
        if not groupSuccess or not rolesSuccess then
            shared.slowmode = 0
            if groupError then errorNotification("StaffDetector", groupError, 5) end
            if rolesError then errorNotification("StaffDetector", rolesError, 5) end
            return
        end

        local detectedStaff, uniqueIds = {}, {}
        for _, roleId in pairs(roles) do
            for _, user in pairs(DetectionUtils.scanStaff(groupId, roleId)) do
				local resolve = {
					["Offline"] = '<font color="rgb(128,128,128)">Offline</font>',
					["Online"] = '<font color="rgb(0,255,0)">Online</font>',
					["In Game"] = '<font color="rgb(16, 150, 234)">In Game</font>',
					["In Studio"] = '<font color="rgb(255,165,0)">In Studio</font>'
				}
                local status = ({
                    [0] = "Offline",
                    [1] = "Online",
                    [2] = "In Game",
                    [3] = "In Studio"
                })[user.presenceType or 0]

                if (status == "In Game" or (not StaffDetectionSystemConfig.IgnoreOnline and status == "Online")) and
                   not table.find(uniqueIds, user.userId) then
                    table.insert(uniqueIds, user.userId)
                    local userData = {UserID = tostring(user.userId), Username = user.username, Status = status}
                    if not table.find(detectedStaff, userData) then
                        table.insert(detectedStaff, userData)
                        errorNotification("StaffDetector", "@" .. userData.Username .. "(" .. userData.UserID .. ") is " .. resolve[status], 7)
                    end
                end
            end
        end
        InfoNotification("StaffDetector", #detectedStaff .. " staff members detected online/in-game!", 7)
    end

    StaffDetectionSystem = vape.Categories.Utility:CreateModule({
        Name = 'StaffFetcher - Roblox',
        Function = function(enabled)
            StaffDetectionSystem.Enabled = enabled
            if enabled then
                if StaffDetectionSystemConfig.AutoCheck then
                    task.spawn(function()
                        repeat
                            processStaffCheck()
                            task.wait(30)
                        until not StaffDetectionSystem.Enabled or not StaffDetectionSystemConfig.AutoCheck
                        StaffDetectionSystem:Toggle(false)
                    end)
                else
                    processStaffCheck()
                    StaffDetectionSystem:Toggle(false)
                end
            end
        end
    })

    local StaffDetectionSystemUI = {}

    local gameList = {}
    for game in pairs(StaffDetectionSystemStaffData.Games) do table.insert(gameList, game) end
    StaffDetectionSystemUI.GameSelector = StaffDetectionSystem:CreateDropdown({
        Name = "Game Mode",
        Function = function(value) StaffDetectionSystemConfig.GameMode = value end,
        List = gameList
    })

    StaffDetectionSystemUI.RolesList = StaffDetectionSystem:CreateTextList({
        Name = "Custom Roles",
        TempText = "Role ID (number)",
        Function = function(values) StaffDetectionSystemConfig.CustomRoles = values end
    })

    StaffDetectionSystemUI.GroupIdInput = StaffDetectionSystem:CreateTextBox({
        Name = "Custom Group ID",
        TempText = "Group ID (number)",
        Function = function(value) StaffDetectionSystemConfig.CustomGroupId = value end
    })

    StaffDetectionSystem:CreateToggle({
        Name = "Custom Group",
        Function = function(enabled)
            StaffDetectionSystemConfig.CustomGroupEnabled = enabled
            StaffDetectionSystemUI.GroupIdInput.Object.Visible = enabled
            StaffDetectionSystemUI.RolesList.Object.Visible = enabled
            StaffDetectionSystemUI.GameSelector.Object.Visible = not enabled
        end,
        Tooltip = "Use a custom staff group",
        Default = false
    })

    StaffDetectionSystem:CreateToggle({
        Name = "Ignore Online Staff",
        Function = function(enabled) StaffDetectionSystemConfig.IgnoreOnline = enabled end,
        Tooltip = "Only show in-game staff, ignoring online staff",
        Default = false
    })

    StaffDetectionSystem:CreateSlider({
        Name = "Member Limit",
        Min = 1,
        Max = 100,
        Function = function(value) StaffDetectionSystemConfig.MemberLimit = value end,
        Default = 50
    })

    StaffDetectionSystem:CreateToggle({
        Name = "Auto Check",
        Function = function(enabled)
            StaffDetectionSystemConfig.AutoCheck = enabled
            if enabled and shared.slowmode > 0 then
                errorNotification("StaffDetector", "Disable Auto Check to use manually during slowmode!", 5)
            end
        end,
        Tooltip = "Automatically check every 30 seconds",
        Default = false
    })

    StaffDetectionSystemUI.GroupIdInput.Object.Visible = false
    StaffDetectionSystemUI.RolesList.Object.Visible = false
end)