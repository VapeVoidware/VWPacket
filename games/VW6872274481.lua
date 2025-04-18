local lplr = game:GetService("Players").LocalPlayer
local store = shared.GlobalStore
local vape = shared.vape

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