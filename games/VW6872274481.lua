local lplr = game:GetService("Players").LocalPlayer
local store = shared.GlobalStore
local vape = shared.vape
local gameCamera = game.Workspace.CurrentCamera

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

run(function()
	function IsAlive(plr)
		plr = plr or lplr
		if not plr.Character then return false end
		if not plr.Character:FindFirstChild("Head") then return false end
		if not plr.Character:FindFirstChild("Humanoid") then return false end
		if plr.Character:FindFirstChild("Humanoid").Health < 0.11 then return false end
		return true
	end
	local Slowmode = {Value = 2}
	GodMode = vape.Categories.Blatant:CreateModule({
		Name = "Auto Dodge",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait()
						local res, msg = pcall(function()
							if (not vape.Modules.Fly.Enabled) and (not vape.Modules.InfiniteFly.Enabled) then
								for i, v in pairs(game:GetService("Players"):GetChildren()) do
									if v.Team ~= lplr.Team and IsAlive(v) and IsAlive(lplr) then
										if v and v ~= lplr then
											local TargetDistance = lplr:DistanceFromCharacter(v.Character:FindFirstChild("HumanoidRootPart").CFrame.p)
											if TargetDistance < 25 then
												if not lplr.Character:WaitForChild("HumanoidRootPart"):FindFirstChildOfClass("BodyVelocity") then
													repeat task.wait() until shared.GlobalStore.matchState ~= 0
													if not (v.Character.HumanoidRootPart.Velocity.Y < -10*5) then
														lplr.Character.Archivable = true
				
														local Clone = lplr.Character:Clone()
														Clone.Parent = game.Workspace
														Clone.Head:ClearAllChildren()
														gameCamera.CameraSubject = Clone:FindFirstChild("Humanoid")
					
														for i,v in pairs(Clone:GetChildren()) do
															if string.lower(v.ClassName):find("part") and v.Name ~= "HumanoidRootPart" then
																v.Transparency = 1
															end
															if v:IsA("Accessory") then
																v:FindFirstChild("Handle").Transparency = 1
															end
														end
					
														lplr.Character:WaitForChild("HumanoidRootPart").CFrame = lplr.Character:WaitForChild("HumanoidRootPart").CFrame + Vector3.new(0,100,0)
					
														GodMode:Clean(game:GetService("RunService").RenderStepped:Connect(function()
															if Clone ~= nil and Clone:FindFirstChild("HumanoidRootPart") then
																Clone.HumanoidRootPart.Position = Vector3.new(lplr.Character:WaitForChild("HumanoidRootPart").Position.X, Clone.HumanoidRootPart.Position.Y, lplr.Character:WaitForChild("HumanoidRootPart").Position.Z)
															end
														end))
					
														task.wait(Slowmode.Value/10)
														lplr.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(lplr.Character:WaitForChild("HumanoidRootPart").Velocity.X, -1, lplr.Character:WaitForChild("HumanoidRootPart").Velocity.Z)
														lplr.Character:WaitForChild("HumanoidRootPart").CFrame = Clone.HumanoidRootPart.CFrame
														gameCamera.CameraSubject = lplr.Character:FindFirstChild("Humanoid")
														Clone:Destroy()
														task.wait(0.15)
													end
												end
											end
										end
									end
								end
							end
						end)
						if not res then warn(msg) end
					until (not GodMode.Enabled)
				end)
			end
		end
	})
	Slowmode = GodMode:CreateSlider({
		Name = "Slowmode",
		Function = function() end,
		Default = 2,
		Min = 1,
		Max = 25
	})
end)

repeat task.wait() until shared.vape

local function run(func)
    local suc, err = pcall(function()
        func()
    end)
    if err then warn("[VW4481.lua Error]: "..tostring(debug.traceback(err))) end
end

local entitylib = shared.vape.entitylib
local entityLibrary = entitylib
local lplr = game:GetService("Players").LocalPlayer

run(function()
	local AntiHit = {}
	local physEngine = game:GetService("RunService")
	local worldSpace = game.Workspace
	local camView = worldSpace.CurrentCamera
	local plyr = lplr
	local entSys = entitylib
	local queryutil = {}
	function queryutil:setQueryIgnored(part, index)
		if index == nil then index = true end
		if part then part:SetAttribute("gamecore_GameQueryIgnore", index) end
	end
	local utilPack = {QueryUtil = queryutil}

	local dupeNode, altHeight, initOk, sysOk = nil, nil, false, true
	shared.anchorBase = nil
	shared.evadeFlag = false

	local trigSet = {p = true, n = false, w = false}
	local shiftMode = "Up"
	local scanRad = 30

	local function genTwin()
		if entSys.isAlive and entSys.character.Humanoid.Health > 0 and entSys.character.HumanoidRootPart then
			altHeight = entSys.character.Humanoid.HipHeight
			shared.anchorBase = entSys.character.HumanoidRootPart
			utilPack.QueryUtil:setQueryIgnored(shared.anchorBase, true)
			if not plyr.Character or not plyr.Character.Parent then return false end

			plyr.Character.Parent = game
			dupeNode = shared.anchorBase:Clone()
			dupeNode.Parent = plyr.Character
			shared.anchorBase.Parent = camView
			dupeNode.CFrame = shared.anchorBase.CFrame

			plyr.Character.PrimaryPart = dupeNode
			entSys.character.HumanoidRootPart = dupeNode
			entSys.character.RootPart = dupeNode
			plyr.Character.Parent = worldSpace

			for _, x in plyr.Character:GetDescendants() do
				if x:IsA('Weld') or x:IsA('Motor6D') then
					if x.Part0 == shared.anchorBase then x.Part0 = dupeNode end
					if x.Part1 == shared.anchorBase then x.Part1 = dupeNode end
				end
			end
			return true
		end
		return false
	end

	local function resetCore()
		if not entSys.isAlive or not shared.anchorBase or not shared.anchorBase:IsDescendantOf(game) then
			shared.anchorBase = nil
			dupeNode = nil
			return false
		end

		if not plyr.Character or not plyr.Character.Parent then return false end

		plyr.Character.Parent = game

		shared.anchorBase.Parent = plyr.Character
		shared.anchorBase.CanCollide = true
		shared.anchorBase.Velocity = Vector3.zero 
		shared.anchorBase.Anchored = false 

		plyr.Character.PrimaryPart = shared.anchorBase
		entSys.character.HumanoidRootPart = shared.anchorBase
		entSys.character.RootPart = shared.anchorBase

		for _, x in plyr.Character:GetDescendants() do
			if x:IsA('Weld') or x:IsA('Motor6D') then
				if x.Part0 == dupeNode then x.Part0 = shared.anchorBase end
				if x.Part1 == dupeNode then x.Part1 = shared.anchorBase end
			end
		end

		local prevLoc = dupeNode and dupeNode.CFrame or shared.anchorBase.CFrame
		if dupeNode then
			dupeNode:Destroy()
			dupeNode = nil
		end

		plyr.Character.Parent = worldSpace
		shared.anchorBase.CFrame = prevLoc

		if entSys.character.Humanoid then
			entSys.character.Humanoid.HipHeight = altHeight or 2
		end

		shared.anchorBase = nil
		shared.evadeFlag = false
		altHeight = nil

		return true
	end

	local function shiftPos()
		if not entSys.isAlive or not shared.anchorBase or not AntiHit.on then return end

		local hits = entSys.AllPosition({
			Range = scanRad,
			Wallcheck = trigSet.w or nil,
			Part = 'RootPart',
			Players = trigSet.p,
			NPCs = trigSet.n,
			Limit = 1
		})

		if #hits > 0 and not shared.evadeFlag then
			local base = entSys.character.RootPart
			if base then
				shared.evadeFlag = true
				local targetY = shiftMode == "Up" and 150 or 0
				shared.anchorBase.CFrame = CFrame.new(base.CFrame.X, targetY, base.CFrame.Z)
				task.wait(0.15)
				shared.anchorBase.CFrame = base.CFrame
				task.wait(0.05)
				shared.evadeFlag = false
			end
		end
	end

	function AntiHit:engage()
		if self.on then return end
		self.on = true

		initOk = genTwin()
		if not initOk then
			self:disengage()
			return
		end

		self.physHook = physEngine.PreSimulation:Connect(function(dt)
			if entSys.isAlive and shared.anchorBase and entSys.character.RootPart then
				local currBase = entSys.character.RootPart
				local currPos = currBase.CFrame

				if not isnetworkowner(shared.anchorBase) then
					currBase.CFrame = shared.anchorBase.CFrame
					currBase.Velocity = shared.anchorBase.Velocity
					return
				end
				if not shared.evadeFlag then
					shared.anchorBase.CFrame = currPos
				end
				shared.anchorBase.Velocity = Vector3.zero
				shared.anchorBase.CanCollide = false
				shiftPos()
			else
				self:disengage() 
			end
		end)

		self.respawnHook = entSys.Events.LocalAdded:Connect(function(_)
			if self.on then
				self:disengage() 
				task.wait(0.1) 
				self:engage() 
			end
		end)
	end

	local Antihit_core = {Enabled = false}

	function AntiHit:disengage()
		self.on = false
		local success, err = pcall(resetCore)
		if not success then
			warn("AntiHit resetCore failed: " .. tostring(err))
		end
		if self.physHook then
			self.physHook:Disconnect()
			self.physHook = nil
		end
		if self.respawnHook then
			self.respawnHook:Disconnect()
			self.respawnHook = nil
		end
	end

	Antihit_core = vape.Categories.World:CreateModule({
		Name = "AntiHit V2",
		Function = function(active)
			if active then
				warningNotification("Antihit V2", "Warning: this is still experimental!", 3)
			end
			task.spawn(function()
				repeat task.wait() until store.matchState > 0 or not Antihit_core.Enabled
				if not Antihit_core.Enabled then return end
				if active then
					AntiHit:engage()
				else
					AntiHit:disengage()
				end
			end)
		end,
		Tooltip = "Dodges attacks."
	})

	Antihit_core:CreateTargets({
		Players = true,
		NPCs = false
	})
	Antihit_core:CreateDropdown({
		Name = "Shift Type",
		List = {"Up", "Down"},
		Value = "Up",
		Function = function(opt) shiftMode = opt end
	})
	Antihit_core:CreateSlider({
		Name = "Scan Perimeter",
		Min = 1,
		Max = 30,
		Default = 30,
		Suffix = function(v) return v == 1 and "span" or "spans" end,
		Function = function(v) scanRad = v end
	})
end)

run(function()
	local Maid = {}
	Maid.__index = Maid
	
	function Maid.new()
		return setmetatable({ Tasks = {} }, Maid)
	end
	
	function Maid:Add(task)
		if typeof(task) == "RBXScriptConnection" or
		   (typeof(task) == "Instance" and task.Destroy) or
		   typeof(task) == "function" or
		   (typeof(task) == "table" and (task.Destroy or task.Disconnect)) then
			table.insert(self.Tasks, task)
		else
			warn("[Maid] Invalid task type: " .. typeof(task))
		end
		return task
	end
	
	function Maid:Clean()
		for _, task in ipairs(self.Tasks) do
			local success, errorMsg = pcall(function()
				if typeof(task) == "RBXScriptConnection" then
					task:Disconnect()
				elseif typeof(task) == "Instance" then
					task:Destroy()
				elseif typeof(task) == "function" then
					task()
				elseif typeof(task) == "table" then
					if task.Destroy then
						task:Destroy()
					elseif task.Disconnect then
						task:Disconnect()
					end
				end
			end)
			if not success then
				warn("[Maid] Error cleaning task: " .. tostring(errorMsg))
			end
		end
		table.clear(self.Tasks)
	end
	
	local Services = setmetatable({}, {
		__index = function(self, key)
			local suc, service = pcall(game.GetService, game, key)
			if suc and service then
				self[key] = service
				return service
			else
				warn(`[Services] Warning: "{key}" is not a valid Roblox service.`)
				return nil
			end
		end
	})
	
    local Players = Services.Players
    local Workspace = Services.Workspace
    local maid = Maid.new()
    local BetterSpectator = { Enabled = false }
    local Choice = { Value = Players.LocalPlayer.Name }
    local playerConnections = {} 
    local connectedPlayerMaid = nil 
    local localCharacter = nil
    local refreshDebounce = false 
    local lastRefreshTime = 0 

    local function getPlayerList()
        local playerList = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:IsDescendantOf(Workspace) and player.Character.ClassName == "Model" then
                table.insert(playerList, player.Name)
            end
        end
        return playerList
    end

    local function findLocalCharacter()
        if localCharacter and localCharacter:IsDescendantOf(Workspace) and localCharacter.Name == Players.LocalPlayer.Name then
            return localCharacter
        end
        local char = Workspace:FindFirstChild(Players.LocalPlayer.Name)
        if char and char.ClassName == "Model" then
            localCharacter = char
            return char
        end
        return nil
    end

    local function saveLocalCharacter()
        local char = Players.LocalPlayer.Character
        if char and char:IsDescendantOf(Workspace) and char.ClassName == "Model" and char.Name == Players.LocalPlayer.Name then
            localCharacter = char
        else
            localCharacter = findLocalCharacter()
        end
    end

    local function connectPlayer(player)
        if playerConnections[player] then
            playerConnections[player]:Clean()
        end
        local playerMaid = Maid.new()
        playerMaid:Add(player.CharacterAdded:Connect(function()
            if not refreshDebounce then
                refreshChoices()
            end
        end))
        playerMaid:Add(player.CharacterRemoving:Connect(function()
            if not refreshDebounce then
                refreshChoices()
            end
        end))
        playerConnections[player] = playerMaid
    end

    local function clearConnections()
        for _, connectionMaid in pairs(playerConnections) do
            connectionMaid:Clean()
        end
        table.clear(playerConnections)
    end

    local function initiatePlayers()
        clearConnections()
        for _, player in ipairs(Players:GetPlayers()) do
            connectPlayer(player)
        end
    end

    local function updateChoice(playerName)
        local player = Players:FindFirstChild(playerName)
        if not player or not player.Character or not player.Character:IsDescendantOf(Workspace) then
            warningNotification("BetterSpectator", "Selected player is invalid or has no character.", 2)
            Choice.Value = Players.LocalPlayer.Name
            Players.LocalPlayer.Character = findLocalCharacter()
            if connectedPlayerMaid then
                connectedPlayerMaid:Clean()
                connectedPlayerMaid = nil
            end
            return
        end

        saveLocalCharacter()
        Players.LocalPlayer.Character = player.Character

        if connectedPlayerMaid then
            connectedPlayerMaid:Clean()
        end
        connectedPlayerMaid = Maid.new()
        connectedPlayerMaid:Add(player.CharacterRemoving:Connect(function()
            Players.LocalPlayer.Character = findLocalCharacter()
            warningNotification("BetterSpectator", "Spectated player died. Waiting for respawn...", 2)
        end))
        connectedPlayerMaid:Add(player.CharacterAdded:Connect(function(newChar)
            saveLocalCharacter()
            Players.LocalPlayer.Character = newChar
            InfoNotification("BetterSpectator", "Spectated player respawned.", 2)
        end))

        InfoNotification("BetterSpectator", "Now spectating " .. player.Name .. ".", 2)
    end

    function refreshChoices()
        if refreshDebounce or tick() - lastRefreshTime < 0.5 then
            return
        end
        refreshDebounce = true
        lastRefreshTime = tick()

        local playerList = getPlayerList()
        Choice:Change(playerList)
        initiatePlayers()

        if BetterSpectator.Enabled and Choice.Value ~= Players.LocalPlayer.Name then
            updateChoice(Choice.Value)
        else
            Players.LocalPlayer.Character = findLocalCharacter()
            if connectedPlayerMaid then
                connectedPlayerMaid:Clean()
                connectedPlayerMaid = nil
            end
        end

        refreshDebounce = false
    end

    BetterSpectator = vape.Categories.Utility:CreateModule({
        Name = "BetterSpectator",
        Function = function(enabled)
            if enabled then
                BetterSpectator.Enabled = true
                initiatePlayers()
                maid:Add(Players.PlayerAdded:Connect(function(player)
                    connectPlayer(player)
                    refreshChoices()
                end))
                maid:Add(Players.PlayerRemoving:Connect(function(player)
                    if playerConnections[player] then
                        playerConnections[player]:Clean()
                        playerConnections[player] = nil
                    end
                    if Choice.Value == player.Name then
                        Choice.Value = Players.LocalPlayer.Name
                        updateChoice(Choice.Value)
                    end
                    refreshChoices()
                end))
                maid:Add(clearConnections)
                maid:Add(function()
                    if connectedPlayerMaid then
                        connectedPlayerMaid:Clean()
                        connectedPlayerMaid = nil
                    end
                    Players.LocalPlayer.Character = findLocalCharacter()
                    Choice.Value = Players.LocalPlayer.Name
                end)
                refreshChoices()
            else
                BetterSpectator.Enabled = false
                maid:Clean()
            end
        end,
        Tooltip = "Allows spectating other players by switching your character's perspective."
    })

    Choice = BetterSpectator:CreateDropdown({
        Name = "Player",
        List = getPlayerList(),
        Default = Players.LocalPlayer.Name,
        Function = function(value)
            Choice.Value = value
            if BetterSpectator.Enabled then
                updateChoice(value)
            end
        end
    })
end)

shared.slowmode = 0
run(function()
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

if not shared.CheatEngineMode then
	local inputService = game:GetService('UserInputService')
	local isMobile = inputService.TouchEnabled and not inputService.KeyboardEnabled and not inputService.MouseEnabled
	run(function()
		local controller
		local LegacyLayout = {Enabled = false}
		LegacyLayout = vape.Categories.World:CreateModule({
			Name = "LegacyLayout",
			Function = function(call)
				if not controller then
					controller = require(game:GetService("ReplicatedStorage").rbxts_include.node_modules["@flamework"].core.out).Flamework.resolveDependency("@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController").mobileAbilityUIController.mobileLayoutController
				end
				if call and not isMobile then
					warningNotification("LegacyLayout", "Mobile devices only!", 3)
					--LegacyLayout:Toggle(false)
				end
				controller:setIsLegacyMode(call)
			end
		})
	end)
end

if not shared.CheatEngineMode then
	run(function()
		local KnitInit, Knit
		repeat
			KnitInit, Knit = pcall(function()
				return debug.getupvalue(require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.knit).setup, 6)
			end)
			if KnitInit then break end
			task.wait()
		until KnitInit

		if not debug.getupvalue(Knit.Start, 1) then
			repeat task.wait() until debug.getupvalue(Knit.Start, 1)
		end

		local Players = game:GetService("Players")

		shared.PERMISSION_CONTROLLER_HASANYPERMISSIONS_REVERT = shared.PERMISSION_CONTROLLER_HASANYPERMISSIONS_REVERT or Knit.Controllers.PermissionController.hasAnyPermissions
		shared.MATCH_CONTROLLER_GETPLAYERPARTY_REVERT = shared.MATCH_CONTROLLER_GETPLAYERPARTY_REVERT or Knit.Controllers.MatchController.getPlayerParty

		local AC_MOD_View = {
			playerConnections = {},
			Enabled = false,
			Friends = {}, 
			parties = {}, 
			teamMap = {}, 
			display = {},
			isRefreshing = false,
			cacheDirty = true,
			disable_disguises = false,
			disguises = {},
			teamData = {}
		}

		AC_MOD_View.controller = Knit.Controllers.PermissionController
		AC_MOD_View.match_controller = Knit.Controllers.MatchController

		function AC_MOD_View:getPartyById(displayId)
			if not displayId then return end
			displayId = tostring(displayId)
			if self.display[displayId] then return self.display[displayId] end
			for _, party in pairs(self.parties) do
				if party.displayId == tostring(displayId) then
					self.display[displayId] = party
					return party
				end
			end
		end

		function AC_MOD_View:refreshDisplayCache()
			for _, plr in pairs(Players:GetPlayers()) do
				local playerId = tostring(plr.UserId)

				local playerPartyId = self.teamMap[playerId]
				if playerPartyId ~= nil then
					self:getPartyById(playerPartyId)
				end
				task.wait()
			end
		end

		function AC_MOD_View:refreshDisplayCacheAsync()
			task.spawn(self.refreshDisplayCache, self)
		end

		function AC_MOD_View:getPlayerTeamData(plr)
			if self.teamData[plr] then return self.teamData[plr] end

			self.teamData[plr] = {}

			local teamMembers = {}
			local playerTeam = plr.Team 
			if not playerTeam then
				return teamMembers 
			end

			local playerId = tostring(plr.UserId)
			self.Friends[playerId] = self.Friends[playerId] or {}

			for _, otherPlayer in pairs(Players:GetPlayers()) do
				if otherPlayer == plr then continue end 

				local otherPlayerId = tostring(otherPlayer.UserId)
				local areFriends = self.Friends[playerId][otherPlayerId]

				if areFriends == nil then
					local suc, res = pcall(function()
						return plr:IsFriendsWith(otherPlayer.UserId)
					end)
					areFriends = suc and res or false

					if suc then
						self.Friends[playerId][otherPlayerId] = areFriends
						self.Friends[otherPlayerId] = self.Friends[otherPlayerId] or {}
						self.Friends[otherPlayerId][playerId] = areFriends
					end
				end

				if areFriends and otherPlayer.Team == playerTeam then
					table.insert(teamMembers, otherPlayerId)
				end
			end

			self.teamData[plr] = teamMembers

			return teamMembers
		end

		function AC_MOD_View:refreshPlayerTeamData()
			for i,v in pairs(Players:GetPlayers()) do
				self:getPlayerTeamData(v)
				task.wait()
			end
		end

		function AC_MOD_View:refreshPlayerTeamDataAsync()
			task.spawn(self.refreshPlayerTeamData, self)
		end

		function AC_MOD_View:refreshTeamMap()
			local allTeams = {}
			for _, p in pairs(Players:GetPlayers()) do
				local teamMembers = self:getPlayerTeamData(p)
				if teamMembers and #teamMembers > 0 then 
					allTeams[p] = teamMembers
				end
			end

			local validTeams = {}
			for playerInTeams, members in pairs(allTeams) do
				local playerIdInTeams = tostring(playerInTeams.UserId)
				local cleanedMembers = {}

				for _, memberId in pairs(members) do
					local memberIdStr = tostring(memberId)
					if memberIdStr == playerIdInTeams then
						print("Warning: Player " .. playerIdInTeams .. " has themselves in their team list.")
					else
						table.insert(cleanedMembers, memberIdStr)
					end
				end

				if #cleanedMembers > 0 then
					validTeams[playerInTeams] = cleanedMembers
				end
			end

			self.parties = {}
			self.teamMap = {}
			local teamId = 0
			for playerInTeams, members in pairs(validTeams) do
				local playerIdInTeams = tostring(playerInTeams.UserId)
				if not self.teamMap[playerIdInTeams] then
					self.teamMap[playerIdInTeams] = teamId
					table.insert(self.parties, {
						displayId = tostring(teamId),
						members = members
					})
					teamId = teamId + 1

					for _, memberId in pairs(members) do
						self.teamMap[memberId] = teamId - 1
					end
				end
			end

			self.cacheDirty = false
			self.isRefreshing = false
		end

		function AC_MOD_View:refreshTeamMapAsync()
			if self.isRefreshing then return end 
			self.isRefreshing = true
			task.spawn(function()
				self:refreshTeamMap()
			end)
		end

		function AC_MOD_View:getPlayerParty(plr)
			if not plr or not plr:IsA("Player") then
				return nil
			end

			local playerId = tostring(plr.UserId)

			if self.cacheDirty or not next(self.teamMap) then
				self:refreshTeamMapAsync()
			end

			local playerPartyId = self.teamMap[playerId]
			if playerPartyId ~= nil then
				return self:getPartyById(playerPartyId)
			end

			return nil 
		end

		AC_MOD_View.mockGetPlayerParty = function(self, plr)
			local parties = self.parties 
			if parties ~= nil and #parties > 0 then
				return shared.MATCH_CONTROLLER_GETPLAYERPARTY_REVERT(self, plr)
			end
			return AC_MOD_View:getPlayerParty(plr)
		end

		function AC_MOD_View:toggleDisableDisguises()
			if not self.Enabled then return end
			if self.disable_disguises then
				for _,v in pairs(Players:GetPlayers()) do
					if v == Players.LocalPlayer then continue end
					if tostring(v:GetAttribute("Disguised")) == "true" then
						v:SetAttribute("Disguised", false)
						InfoNotification("Remove Disguises", "Disabled streamer mode for "..tostring(v.Name).."!", 3)
						table.insert(self.disguises, v)
					end
				end
			else
				for i,v in pairs(self.disguises) do
					if tostring(v:GetAttribute("Disguised")) ~= "true" then
						v:SetAttribute("Disguised", true)
						InfoNotification("Remove Disguises", "Re - enabled Streamer mode for "..tostring(v.Name).."!", 2)
					end
				end
				table.clear(self.disguises)
			end
		end

		function AC_MOD_View:refreshCore()
			self:refreshTeamMapAsync()
			self:refreshDisplayCacheAsync()
			self:refreshPlayerTeamDataAsync()

			self:toggleDisableDisguises()
		end

		function AC_MOD_View:refreshCoreAsync()
			task.spawn(self.refreshCore, self)
		end

		function AC_MOD_View:init()
			self.Enabled = true
			self.controller.hasAnyPermissions = function(self)
				return true
			end
			self.match_controller.getPlayerParty = self.mockGetPlayerParty

			self.playerConnections = {
				added = Players.PlayerAdded:Connect(function(player)
					self.cacheDirty = true
					self:refreshCoreAsync()
					player:GetPropertyChangedSignal("Team"):Connect(function()
						self.cacheDirty = true
						self:refreshCoreAsync()
					end)
				end),
				removed = Players.PlayerRemoving:Connect(function(player)
					local playerId = tostring(player.UserId)
					self.Friends[playerId] = nil 
					for _, cache in pairs(self.Friends) do
						cache[playerId] = nil
					end
					self.cacheDirty = true
					self:refreshCoreAsync()
				end)
			}

			self:refreshCore()
		end

		function AC_MOD_View:disable()
			self.Enabled = false

			self.controller.hasAnyPermissions = shared.PERMISSION_CONTROLLER_HASANYPERMISSIONS_REVERT
			self.match_controller.getPlayerParty = shared.MATCH_CONTROLLER_GETPLAYERPARTY_REVERT

			if self.playerConnections then
				for _, v in pairs(self.playerConnections) do
					pcall(function() v:Disconnect() end)
				end
				table.clear(self.playerConnections)
			end

			self.parties = {}
			self.teamMap = {}
			self.Friends = {}
			self.display = {}
			self.teamData = {}
			self.cacheDirty = true

			self:toggleDisableDisguises()
		end

		AC_MOD_View.moduleInstance = vape.Categories.World:CreateModule({
			Name = "AC MOD View",
			Function = function(call)
				if call then
					AC_MOD_View:init()
				else
					AC_MOD_View:disable()
				end
			end
		})

		AC_MOD_View.disableDisguisesToggle = AC_MOD_View.moduleInstance:CreateToggle({
			Name = "Remove Disguises",
			Function = function(call)
				AC_MOD_View.disable_disguises = call
				AC_MOD_View:toggleDisableDisguises()
			end,
			Default = true
		})
	end)
end

run(function()
    local BedAssist = {Enabled = false}
    local bedassistrange = {Value = 30}
    local bedassistsmoothness = {Value = 6}
    local bedassistangle = {Value = 70}
    local bedassistfirstperson = {Enabled = false}
    local bedassistshopcheck = {Enabled = false}

    local camera = workspace.CurrentCamera
    local runService = game:GetService("RunService")
    local collectionService = game:GetService("CollectionService")
    local lplr = game.Players.LocalPlayer

    local beds = {}
    local Connections = {}

    local function isFirstPerson()
        if not (lplr.Character and lplr.Character:FindFirstChild("Head")) then return false end
        return (lplr.Character.Head.Position - camera.CFrame.Position).Magnitude < 2
    end

    local function getClosestEnemyBed(playerPos)
        local closestBed = nil
        local closestDistance = bedassistrange.Value

        for _, bed in pairs(beds) do
            if bed.Parent ~= nil then
                if bed.Name == "bed" and tostring(bed:GetAttribute("TeamId")) == tostring(lplr:GetAttribute("Team")) then
                    continue
                end
                if bed:GetAttribute("BedShieldEndTime") and bed:GetAttribute("BedShieldEndTime") > game.Workspace:GetServerTimeNow() then
                    continue
                end
                local distance = (playerPos - bed.Position).Magnitude
                if distance <= closestDistance then
                    local delta = (bed.Position - playerPos)
                    local localfacing = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character.HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1) or Vector3.new(1, 0, 0)
                    local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                    if angle <= math.rad(bedassistangle.Value) / 2 then
                        closestDistance = distance
                        closestBed = bed
                    end
                end
            end
        end

        return closestBed
    end

    BedAssist = vape.Categories.Utility:CreateModule({
        Name = "BedAssist",
        Function = function(callback)
            if callback then
                beds = collectionService:GetTagged("bed")
                local connection
                connection = runService.Heartbeat:Connect(function(dt)
                    if not BedAssist.Enabled then
                        connection:Disconnect()
                        camera.CameraType = Enum.CameraType.Custom
                        return
                    end
                    if not entityLibrary.isAlive then
                        return
                    end
                    if bedassistfirstperson.Enabled and not isFirstPerson() then
                        return
                    end
                    if bedassistshopcheck.Enabled then
                        local isShop = lplr:FindFirstChild("PlayerGui") and lplr.PlayerGui:FindFirstChild("ItemShop")
                        if isShop then return end
                    end

                    local playerPos = entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position
                    local closestBed = getClosestEnemyBed(playerPos)

                    if closestBed then
                        local bedPos = closestBed.Position
                        local currentCFrame = camera.CFrame
                        local targetCFrame = CFrame.lookAt(currentCFrame.Position, bedPos)
                        local lerpAmount = bedassistsmoothness.Value / 2
                        camera.CFrame = currentCFrame:Lerp(targetCFrame, lerpAmount * dt)
                    end
                end)
                table.insert(Connections, connection)
            else
                for _, v in pairs(Connections) do
                    pcall(function()
                        v:Disconnect()
                    end)
                end
                Connections = {}
                table.clear(beds)
                camera.CameraType = Enum.CameraType.Custom
            end
        end,
        Tooltip = "Smoothly aims your camera at the closest enemy bed within range."
    })

    bedassistrange = BedAssist:CreateSlider({
        Name = "Assist Range",
        Min = 10,
        Max = 100,
        Function = function(val) end,
        Default = 30,
        Suffix = function(val) 
            return val == 1 and "stud" or "studs" 
        end
    })

    bedassistsmoothness = BedAssist:CreateSlider({
        Name = "Aim Speed",
        Min = 1,
        Max = 20,
        Function = function(val) end,
        Default = 6
    })

    bedassistangle = BedAssist:CreateSlider({
        Name = "Max Angle",
        Min = 10,
        Max = 360,
        Function = function(val) end,
        Default = 70
    })

    bedassistfirstperson = BedAssist:CreateToggle({
        Name = "First Person Only",
        Function = function() end,
        Default = false,
        Tooltip = "Only activates in first-person mode."
    })

    bedassistshopcheck = BedAssist:CreateToggle({
        Name = "Shop Check",
        Function = function() end,
        Default = false,
        Tooltip = "Disables aiming when in the shop menu."
    })

    table.insert(Connections, collectionService:GetInstanceAddedSignal("bed"):Connect(function(bed)
        table.insert(beds, bed)
    end))

    table.insert(Connections, collectionService:GetInstanceRemovedSignal("bed"):Connect(function(bed)
        local i = table.find(beds, bed)
        if i then
            table.remove(beds, i)
        end
    end))
end)

pcall(function()
    local function sreadfile(filename)
        local suc, content = pcall(readfile, filename)
        if not suc then
            warn("Failed to read file " .. filename .. ": " .. tostring(content))
            return nil
        end
        return content
    end

    local function createSandbox()
        return setmetatable({AutoWinModule = AutoWinModule, shared = shared}, {__index = getgenv()})
    end

    local function errorHandler(err)
        local stackTrace = debug.traceback("Error in loaded script: " .. tostring(err), 2)
        warn(stackTrace)
        return nil
    end

    local function executeProtected()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/ProjectThingy.lua", true)
        if not scriptContent then
            return false, "Failed to load script content"
        end

        local suc, func = pcall(loadstring, scriptContent)
        if not suc then
            warn("Failed to compile script: " .. tostring(func))
            return false, func
        end

		pcall(function()
			setfenv(func, createSandbox())
		end)

        local suc, res = xpcall(func, errorHandler)
        if not suc then
            return false, res
        end

        return true, res
    end

    local suc, res = executeProtected()
    if not suc then
        print("Script execution failed: " .. tostring(res))
    end
end)