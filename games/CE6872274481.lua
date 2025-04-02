repeat task.wait() until game:IsLoaded()

local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
local textservice = game:GetService("TextService")
local getfontsize = function(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end
	return textservice:GetTextBoundsAsync(fontsize)
end
local getcustomasset = vape.Libraries.getcustomasset

local GuiLibrary = vape

local playersService = game:GetService("Players")
local textService = game:GetService("TextService")
local lightingService = game:GetService("Lighting")
local textChatService = game:GetService("TextChatService")
local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local runservice = runService
local RunService = runservice
local tweenService = game:GetService("TweenService")
local tweenservice = tweenService 
local collectionService = game:GetService("CollectionService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local gameCamera = game.Workspace.CurrentCamera
local lplr = playersService.LocalPlayer
entitylib.entityList = entitylib.List
local entityLibrary = entitylib
local entitylibrary = entitylib
local vapeConnections = {}
local vapeCachedAssets = {}
local function encode(tbl)
    return game:GetService("HttpService"):JSONEncode(tbl)
end
VoidwareFunctions.GlobaliseObject("encode", encode)
local function decode(tbl)
    return game:GetService("HttpService"):JSONDecode(tbl)
end
VoidwareFunctions.GlobaliseObject("decode", decode)
local function cprint(tbl)
	for i, v in pairs(tbl) do
		print(tostring(tbl), tostring(i), tostring(v))
	end
end
VoidwareFunctions.GlobaliseObject("cprint", cprint)

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return (str:gsub('<[^<>]->', ''))
end

local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new("BindableEvent")
		return self[index]
	end
})
local vapeTargetInfo = shared.VapeTargetInfo or {Targets = {}}
local vapeInjected = true

local CheatEngineHelper = {
    SprintEnabled = false
}
local store = {
	damageBlockFail = tick(),
	attackReach = 0,
	attackReachUpdate = tick(),
	blocks = {},
	blockPlacer = {},
	blockPlace = tick(),
	blockRaycast = RaycastParams.new(),
	equippedKit = "",
	forgeMasteryPoints = 0,
	forgeUpgrades = {},
	grapple = tick(),
	inventories = {},
	localInventory = {
		inventory = {
			items = {},
			armor = {}
		},
		hotbar = {}
	},
	localHand = {},
	hand = {},
	matchState = 1,
	matchStateChanged = tick(),
	pots = {},
	queueType = "idk",--"bedwars_test",
	scythe = tick(),
	statistics = {
		beds = 0,
		kills = 0,
		lagbacks = 0,
		lagbackEvent = Instance.new("BindableEvent"),
		reported = 0,
		universalLagbacks = 0
	},
	whitelist = {
		chatStrings1 = {helloimusinginhaler = "vape"},
		chatStrings2 = {vape = "helloimusinginhaler"},
		clientUsers = {},
		oldChatFunctions = {}
	},
	zephyrOrb = 0
}
local bedwars = {
    ProjectileRemote = "ProjectileFire",
    EquipItemRemote = "SetInvItem",
    DamageBlockRemote = "DamageBlock",
    ReportRemote = "ReportPlayer",
    PickupRemote = "PickupItemDrop",
    CannonAimRemote = "AimCannon",
    CannonLaunchRemote = "LaunchSelfFromCannon",
    AttackRemote = "SwordHit",
    GuitarHealRemote = "PlayGuitar",
	EatRemote = "ConsumeItem",
	SpawnRavenRemote = "SpawnRaven",
	MageRemote = "LearnElementTome",
	DragonRemote = "RequestDragonPunch",
	ConsumeSoulRemote = "ConsumeGrimReaperSoul",
	TreeRemote = "ConsumeTreeOrb",
	PickupMetalRemote = "CollectCollectableEntity",
	BatteryRemote = "ConsumeBattery"
}
local function extractTime(timeText)
	local minutes, seconds = string.match(timeText, "(%d+):(%d%d)")
    local tbl = {
        minutes = tonumber(minutes),
        seconds = tonumber(seconds)
    }
	function tbl:toSeconds()
		return tonumber(minutes) and tonumber(seconds) and tonumber(minutes)*60 + tonumber(seconds)
	end
	return tbl
end
local function getRemotes(paths)
    local allRemotes = {}
    local function filterDescendants(descendants, classNames)
        local filtered = {}
        if typeof(classNames) ~= "table" then
            classNames = {classNames}
        end
        for _, descendant in pairs(descendants) do
            for _, className in pairs(classNames) do
                if descendant:IsA(className) then
                    table.insert(filtered, descendant)
                    break 
                end
            end
        end
        return filtered
    end
    for _, path in pairs(paths) do
        local objectToGetDescendantsFrom = game
        for _, subfolder in pairs(string.split(path, ".")) do
            objectToGetDescendantsFrom = objectToGetDescendantsFrom:FindFirstChild(subfolder)
            if not objectToGetDescendantsFrom then
                --warn("Path " .. path .. " does not exist.")
                break
            end
        end
        if objectToGetDescendantsFrom then
            local remotes = filterDescendants(objectToGetDescendantsFrom:GetDescendants(), {"BindableEvent", "RemoteEvent", "RemoteFunction", "UnreliableRemoteEvent"})
            for _, remote in pairs(remotes) do
                table.insert(allRemotes, remote)
            end
        end
    end
    return allRemotes
end
--[[bedwars.Client = {}
function bedwars.Client:Get(remName, customTable, resRequired)
    --warn("B", remName, customTable)
    local remotes = customTable or getRemotes({"ReplicatedStorage"})
    for i,v in pairs(remotes) do
        --warn("C", i,v, v.Name, remName)
        if v.Name == remName then return v end
        if v.Name == remName or string.find(v.Name, remName) then  
			if (not resRequired) then return v else
				local tbl = {}
				function tbl:InvokeServer()
					local tbl2 = {}
					local res = v:InvokeServer()
					function tbl2:andThen(func)
						func(res)
					end
					return tbl2
				end
				return tbl
			end
			return v
        end
    end

	warn(debug.traceback("[bedwars.Client:Get]: Failure finding remote! Remote: "..tostring(remName).." CustomTable: "..tostring(customTable or "no table specified").." Using backup table..."))
	local backupTable = {}
	function backupTable:FireServer() return false end
	function backupTable:InvokeServer() return false end
	--- big brain moment :)
    return backupTable
end
function bedwars.Client:GetNamespace(nameSpace, blacklist)
    local remotes = getRemotes({"ReplicatedStorage"})
    local resolvedRemotes = {}
    local blacklist = blacklist or {}
    for i,v in pairs(remotes) do
        if (v.Name == nameSpace or string.find(v.Name, nameSpace)) and (not table.find(blacklist, v.Name)) then table.insert(resolvedRemotes, v) end
    end
    --for i,v in pairs(resolvedRemotes) do print("A", i, v) end
    local resolveFunctionTable = {}
    resolveFunctionTable.Namespace = resolvedRemotes
    function resolveFunctionTable:Get(remName)
        return bedwars.Client:Get(remName, resolvedRemotes)
    end
    return resolveFunctionTable
end--]]
bedwars.Client = {}
local cache = {} 
local namespaceCache = {}

local NetworkLogger = {
    usageStats = {},
    threshold = 20, 
    warningCooldown = 5, 
    lastWarning = {}
}

local function logRemoteUsage(remoteName, callType)
	remoteName = tostring(remoteName)
    local timeNow = tick()
    local key = remoteName .. "_" .. callType
    
    if not NetworkLogger.usageStats[key] then
        NetworkLogger.usageStats[key] = {
            count = 0,
            lastReset = timeNow,
            peakRate = 0
        }
    end
    
    local stats = NetworkLogger.usageStats[key]
    stats.count = stats.count + 1

	if shared.VoidDev then
		print(`Logged fire from {tostring(remoteName)} | {tostring(stats.count)}`)
	end
    
    if timeNow - stats.lastReset >= 1 then
        local rate = stats.count / (timeNow - stats.lastReset)
        stats.peakRate = math.max(stats.peakRate, rate)
        stats.count = 0
        stats.lastReset = timeNow
        
        if rate > NetworkLogger.threshold then
            if not NetworkLogger.lastWarning[key] or (timeNow - NetworkLogger.lastWarning[key] >= NetworkLogger.warningCooldown) then
				if shared.VoidDev then
					warn(string.format("[NetworkLogger] Excessive remote usage detected!\n" .."Remote: %s\nCallType: %s\nRate: %.2f calls/sec\nPeak: %.2f calls/sec", remoteName, callType, rate, stats.peakRate))
					warningNotification("NetworkLogger", string.format("Excessive remote usage detected!\n" .."Remote: %s\nCallType: %s\nRate: %.2f calls/sec\nPeak: %.2f calls/sec", remoteName, callType, rate, stats.peakRate), 3)
				end
                NetworkLogger.lastWarning[key] = timeNow
            end
        end
    end
end

local function decorateRemote(remote, src)
	local isFunction = string.find(string.lower(remote.ClassName), "function")
	local isEvent = string.find(string.lower(remote.ClassName), "remoteevent")
	local isBindable = string.find(string.lower(remote.ClassName), "bindable")

	if isFunction then
		function src:CallServer(...)
			local args = {...}
			logRemoteUsage(remote, "InvokeServer")
			return remote:InvokeServer(unpack(args))
		end
	elseif isEvent then
		function src:CallServer(...)
			local args = {...}
			logRemoteUsage(remote, "FireServer")
			return remote:FireServer(unpack(args))
		end
	elseif isBindable then
		function src:CallServer(...)
			local args = {...}
			logRemoteUsage(remote, "BindableFire")
			return remote:Fire(unpack(args))
		end
	end

	function src:InvokeServer(...)
		local args = {...}
		src:CallServer(unpack(args))
	end

	function src:FireServer(...)
		local args = {...}
		src:CallServer(unpack(args))
	end

	function src:SendToServer(...)
		local args = {...}
		src:CallServer(unpack(...))
	end

	function src:CallServerAsync(...)
		local args = {...}
		src:CallServer(unpack(args))
	end

	src.instance = remote

	return src
end

function bedwars.Client:Get(remName, customTable, resRequired)
    if cache[remName] then
        return cache[remName] 
    end
    local remotes = customTable or getRemotes({"ReplicatedStorage"})
    for _, v in pairs(remotes) do
        if v.Name == remName or string.find(v.Name, remName) then  
            local remote
            if not resRequired then
                remote = decorateRemote(v, {})
            else
                local tbl = {}
                function tbl:InvokeServer()
                    local tbl2 = {}
                    local res = v:InvokeServer()
                    function tbl2:andThen(func)
                        func(res)
                    end
                    return tbl2
                end
				tbl = decorateRemote(v, tbl)
                remote = tbl
            end
            
            cache[remName] = remote 
            return remote
        end
    end
    warn(debug.traceback("[bedwars.Client:Get]: Failure finding remote! Remote: " .. tostring(remName) .. " CustomTable: " .. tostring(customTable or "no table specified") .. " Using backup table..."))
    local backupTable = {}
    function backupTable:FireServer() return false end
    function backupTable:InvokeServer() return false end
    cache[remName] = backupTable
    return backupTable
end

function bedwars.Client:GetNamespace(nameSpace, blacklist)
    local cacheKey = nameSpace .. (blacklist and table.concat(blacklist, ",") or "")
    if namespaceCache[cacheKey] then
        return namespaceCache[cacheKey]
    end
    local remotes = getRemotes({"ReplicatedStorage"})
    local resolvedRemotes = {}
    blacklist = blacklist or {}
    for _, v in pairs(remotes) do
        if (v.Name == nameSpace or string.find(v.Name, nameSpace)) and not table.find(blacklist, v.Name) then
            table.insert(resolvedRemotes, v)
        end
    end
    local resolveFunctionTable = {Namespace = resolvedRemotes}
    function resolveFunctionTable:Get(remName)
        return bedwars.Client:Get(remName, resolvedRemotes)
    end
    namespaceCache[cacheKey] = resolveFunctionTable 
    return resolveFunctionTable
end

function bedwars.Client:WaitFor(remName)
	local tbl = {}
	function tbl:andThen(func)
		repeat task.wait() until bedwars.Client:Get(remName)
		func(bedwars.Client:Get(remName).instance.OnClientEvent)
	end
	return tbl
end
bedwars.ClientStoreHandler = {}
function bedwars.ClientStoreHandler:dispatch(tbl)
    --- pov u can't reverse engineer this function :skull:
end
bedwars.ItemHandler = {}
bedwars.ItemHandler.ItemMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("ItemMeta.json"))
--decode(readfile("vape/CheatEngine/ItemMeta.json"))
bedwars.ItemHandler.getItemMeta = function(item)
    for i,v in pairs(bedwars.ItemHandler.ItemMeta) do
        if i == item then return v end
    end
    return nil
end
bedwars.ItemTable = bedwars.ItemHandler.ItemMeta.items
bedwars.KitMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("KitMeta.json"))
--decode(readfile("vape/CheatEngine/KitMeta.json"))
bedwars.ProdAnimationsMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("ProdAnimationsMeta.json"))
--decode(readfile('vape/CheatEngine/ProdAnimationsMeta.json'))
bedwars.AnimationTypeMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("AnimationTypeMeta.json"))
bedwars.AnimationType = bedwars.AnimationTypeMeta
--decode(readfile('vape/CheatEngine/AnimationTypeMeta.json'))
bedwars.AnimationController = {
	ProdAnimationsMeta = bedwars.ProdAnimationsMeta,
	AnimationTypeMeta = bedwars.AnimationTypeMeta
}
function bedwars.AnimationController:getAssetId(IndexId)
	return bedwars.AnimationController.ProdAnimationsMeta[IndexId]
end
bedwars.AnimationUtil = {}
function bedwars.AnimationUtil:playAnimation(plr, id)
    repeat task.wait() until plr.Character
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then warn("[bedwars.AnimationUtil:playAnimation]: Humanoid not found in the character"); return end
    local animation = Instance.new("Animation")
    animation.AnimationId = id
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    local animationTrack = animator:LoadAnimation(animation)
    animationTrack:Play()
    return animationTrack 
end
function bedwars.AnimationUtil:fetchAnimationIndexId(name)
	if not bedwars.AnimationController.AnimationTypeMeta[name] then return nil end
	for i,v in pairs(bedwars.AnimationController.AnimationTypeMeta) do
		if i == name then return v end
	end
	return nil
end
bedwars.GameAnimationUtil = {}
bedwars.GameAnimationUtil.playAnimation = function(plr, id)
	return bedwars.AnimationUtil:playAnimation(plr, bedwars.AnimationController:getAssetId(id))
end
bedwars.ViewmodelController = {}
function bedwars.ViewmodelController:playAnimation(id)
	return bedwars.AnimationUtil:playAnimation(game:GetService("Players").LocalPlayer, bedwars.AnimationController:getAssetId(id))
end
bedwars.BlockController = {}
function bedwars.BlockController:isBlockBreakable() return true end
function bedwars.BlockController:getBlockPosition(block)
    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Exclude
    RayParams.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character}
    RayParams.IgnoreWater = true
    local RayRes = game.Workspace:Raycast(type(block) == "userdata" and block.Position or block + Vector3.new(0, 30, 0), Vector3.new(0, -35, 0), RayParams)
    local targetBlock
    if RayRes then
        targetBlock = RayRes.Instance or type(block) == "userdata" and black or nil		
        local function resolvePos(pos) return Vector3.new(math.round(pos.X / 3), math.round(pos.Y / 3), math.round(pos.Z / 3)) end
        return resolvePos(targetBlock.Position)
    else
        return false
    end
end
function bedwars.BlockController:getBlockPosition2(position)
    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Exclude
    RayParams.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character, game.Workspace.Camera}
    RayParams.IgnoreWater = true
    local startPosition = position + Vector3.new(0, 30, 0)
    local direction = Vector3.new(0, -35, 0)
    local RayRes = game.Workspace:Raycast(startPosition, direction, RayParams)
    if RayRes then
        local targetBlock = RayRes.Instance
        if targetBlock then
            local function resolvePos(pos)
                return Vector3.new(
                    math.round(pos.X / 3),
                    math.round(pos.Y / 3),
                    math.round(pos.Z / 3)
                )
            end
            return resolvePos(targetBlock.Position)
        end
    end
    return nil
end

local function getBestTool(block)
	local tool = nil
	local blockmeta = bedwars.ItemTable[block]
	local blockType = blockmeta.block and blockmeta.block.breakType
	if blockType then
		local best = 0
		for i,v in pairs(store.localInventory.inventory.items) do
			local meta = bedwars.ItemTable[v.itemType]
			if meta.breakBlock and meta.breakBlock[blockType] and meta.breakBlock[blockType] >= best then
				best = meta.breakBlock[blockType]
				tool = v
			end
		end
	end
	return tool
end
function bedwars.BlockController:calculateBlockDamage(plr, posTbl)
	local tool = getBestTool(tostring(posTbl.block))
	local tooldmg = bedwars.ItemTable[tostring(tool.itemType)].breakBlock
	if table.find(tooldmg, tostring(tool)) then tooldmg = tooldmg[tostring(tool)] else
		for i,v in pairs(tooldmg) do tooldmg = v break end
	end
	return tooldmg
end
function bedwars.BlockController:getAnimationController()
	return bedwars.AnimationController
end
function bedwars.BlockController:resolveBreakPosition(pos)
	return Vector3.new(math.round(pos.X / 3), math.round(pos.Y / 3), math.round(pos.Z / 3))
end
function bedwars.BlockController:resolveRaycastResult(block)
	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude
	RayParams.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character}
	RayParams.IgnoreWater = true
	return game.Workspace:Raycast(block.Position + Vector3.new(0, 30, 0), Vector3.new(0, -35, 0), RayParams)
end
local cachedNormalSides = {}
for i,v in pairs(Enum.NormalId:GetEnumItems()) do if v.Name ~= "Bottom" then table.insert(cachedNormalSides, v) end end
local function getPlacedBlock(pos, strict)
    if not pos then 
        warn(debug.traceback("[getPlacedBlock]: pos is nil!")) 
        return nil 
    end

    local checkDistance = 1
    local regionSize = Vector3.new(0.1, 0.1, 0.1) 
    
    local nearbyParts = {}
    local directions = {
        Vector3.new(1, 0, 0),  
        Vector3.new(-1, 0, 0), 
        Vector3.new(0, 1, 0),  
        Vector3.new(0, -1, 0),  
        Vector3.new(0, 0, 1), 
        Vector3.new(0, 0, -1)  
    }
    
    local centerRegion = Region3.new(pos - regionSize/2, pos + regionSize/2)
    local centerParts = game.Workspace:FindPartsInRegion3(centerRegion, nil, math.huge)
    for _, part in pairs(centerParts) do
        if part and part.ClassName == "Part" and part.Parent then
            if strict then
                if part.Parent.Name == 'Blocks' and part.Parent.ClassName == "Folder" then
                    table.insert(nearbyParts, part)
                end
            else
                table.insert(nearbyParts, part)
            end
        end
    end
    
    for _, dir in pairs(directions) do
        local checkPos = pos + dir * checkDistance
        local region = Region3.new(checkPos - regionSize/2, checkPos + regionSize/2)
        local parts = game.Workspace:FindPartsInRegion3(region, nil, math.huge)
        
        for _, part in pairs(parts) do
            if part and part.ClassName == "Part" and part.Parent then
                if strict then
                    if part.Parent.Name == 'Blocks' and part.Parent.ClassName == "Folder" then
                        table.insert(nearbyParts, part)
                    end
                else
                    table.insert(nearbyParts, part)
                end
            end
        end
    end
    
    if #nearbyParts > 0 then
        return nearbyParts[1]
    end
    return nil
end
VoidwareFunctions.GlobaliseObject("getPlacedBlock", getPlacedBlock)
function bedwars.BlockController:getStore()
	local tbl = {}
	function tbl:getBlockData(pos)
		return getPlacedBlock(pos)
	end
	function tbl:getBlockAt(pos)
		return getPlacedBlock(pos)
	end
	return tbl
end
local function isBlockCovered(pos)
	local coveredsides = 0
	for i, v in pairs(cachedNormalSides) do
		local blockpos = (pos + (Vector3.FromNormalId(v) * 3))
		local block = getPlacedBlock(blockpos)
		if block then
			coveredsides = coveredsides + 1
		end
	end
	return coveredsides == #cachedNormalSides
end
local failedBreak = 0
bedwars.breakBlock = function(block, anim)
    if vape.Modules.InfiniteFly.Enabled or lplr:GetAttribute("DenyBlockBreak") then return end
	if block.Name == "bed" and tostring(block:GetAttribute("TeamId")) == tostring(game:GetService("Players").LocalPlayer:GetAttribute("Team")) then return end
    local resolvedPos = bedwars.BlockController:getBlockPosition(block)
    if resolvedPos then
		local result = bedwars.Client:Get(bedwars.DamageBlockRemote):InvokeServer({
            blockRef = {
                blockPosition = resolvedPos
            },
            hitPosition = resolvedPos,
            hitNormal = resolvedPos
        })
		if result ~= "failed" then
			failedBreak = 0
			task.spawn(function()
				local animation
				if anim then
					local lplr = game:GetService("Players").LocalPlayer
					animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(bedwars.AnimationUtil:fetchAnimationIndexId("BREAK_BLOCK")))
					--bedwars.ViewmodelController:playAnimation(15)
				end
				task.wait(0.3)
				if animation ~= nil then
					animation:Stop()
					animation:Destroy()
				end
			end)
		else
			failedBreak = failedBreak + 1
		end
    end
end
local updateitem = Instance.new("BindableEvent")
table.insert(vapeConnections, updateitem.Event:Connect(function(inputObj)
	if inputService:IsMouseButtonPressed(0) then
		game:GetService("ContextActionService"):CallFunction("block-break", Enum.UserInputState.Begin, newproxy(true))
	end
end))
local function encode(tbl)
    return game:GetService("HttpService"):JSONEncode(tbl)
end
local lplr = game:GetService("Players").LocalPlayer
local function corehotbarswitch(tool)
	local function findChild(name, className, children, nodebug)
		children = children:GetChildren()
        for i,v in pairs(children) do if v.Name == name and v.ClassName == className then return v end end
        local args = {Name = tostring(name), ClassName == tostring(className), Children = children}
		if not nodebug then
			warn("[findChild]: CHILD NOT FOUND! Args: ", game:GetService("HttpService"):JSONEncode(args), name, className, children)
		end
        return nil
    end
	local function resolveHotbar()
		local hotbar
		hotbar = findChild("hotbar", "ScreenGui", lplr:WaitForChild("PlayerGui"))
		if not hotbar then return false end

		local _1 = findChild("1", "Frame", hotbar)
		if not _1 then return false end

		local ItemsHotbar = findChild("ItemsHotbar", "Frame", _1)
		if not ItemsHotbar then return false end

		return {
			hotbar = hotbar,
			items = ItemsHotbar
		}
	end
	local function resolveItemHotbar(hotbar)
		if tostring(hotbar) == "10" then return "blacklisted" end
		local res = {
			id = hotbar.Name,
			toolImage = "",
			toolAmount = 0,
			object = hotbar
		}
		if not tonumber(res.id) then return false end

		local _1 = findChild("1", "ImageButton", hotbar)
		if not _1 then return false end

		local __1 = findChild("1", "TextLabel", _1, true)
		if __1 then 
			res.toolAmount = tonumber(__1.Text) or nil
		end

		local _3 = findChild("3", "Frame", _1, true)
		if not _3 then return false end

		local ___1 = findChild("1", "ImageLabel", _3, true)
		if not ___1 then return false end
		res.toolImage = ___1.Image

		return res
	end
	local function resolveItemsHotbar(hotbar)
		local res = {}
		for i,v in pairs(hotbar:GetChildren()) do
			local rev = resolveItemHotbar(v)
			local name = tostring(v.Name)
			if rev and type(rev) == "table" then 
				if res[name] then warn("Duplication found! Overwriting... ["..name.."]") end
				res[name] = rev
			else
				if rev == "blacklisted" then continue end
				if res[name] then warn("Duplication found! Overwriting... ["..name.."]") end
				res[name] = {
					object = v
				}
			end
		end
		return res
	end
	local function findTool(items_rev, img)
		local res = {
			tool = nil,
			activated = nil
		}
		for i,v in pairs(items_rev) do
			if v.toolImage and tostring(v.toolImage) == tostring(img) then 
				res.tool = v
			end
			local img = findChild("1", "ImageButton", v.object)
			if img and img.Position ~= UDim2.new(0, 0, 0, 0) then
				res.activated = v
			end
		end
		return res
	end
	local function deactivatify(object)
		local img = findChild("1", "ImageButton", object)
		if img then
			img.Position = UDim2.new(0, 0, 0, 0)
			img.BorderColor3 = Color3.fromRGB(114, 127, 172)
			local text = findChild("1", "TextLabel", img)
			text.TextColor3 = Color3.fromRGB(255, 255, 255)
			text.BackgroundColor3 = Color3.fromRGB(114, 127, 172)
		end
	end
	local function activatify(object)
		local img = findChild("1", "ImageButton", object)
		if img then
			img.Position = UDim2.new(0, 0, -0.075, 0)
			img.BorderColor3 = Color3.fromRGB(255, 255, 255)
			local text = findChild("1", "TextLabel", img)
			text.TextColor3 = Color3.fromRGB(0, 0, 0)
			text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
	task.spawn(function()
		local function run(func)
			local suc, err = pcall(function()
				func()
			end)
			if err then warn("[CoreSwitch Error]: "..tostring(debug.traceback(err))) end
		end
		run(function()
			if not lplr.Character then return false end

			if not tool then
				tool = lplr.Character and lplr.Character:FindFirstChild('HandInvItem') and lplr.Character:FindFirstChild('HandInvItem').Value or nil
			end
			if not tool then return false end
			tool = tostring(tool)

			local hotbar_rev = resolveHotbar()
			if not hotbar_rev then return false end

			local ItemsHotbar = hotbar_rev.items
			local items_rev = resolveItemsHotbar(ItemsHotbar)
			if not items_rev then return false end
		
			repeat task.wait() until (bedwars.ItemMeta ~= nil and type(bedwars.ItemMeta) == "table") or (bedwars.ItemTable ~= nil and type(bedwars.ItemTable) == "table")
			local meta = ((bedwars.ItemMeta and bedwars.ItemMeta[tool]) or (bedwars.ItemTable and bedwars.ItemTable[tool]))
			if ((not meta) or (meta ~= nil and (not meta.image))) then return false end

			local img = meta.image
			
			local tool_rev = findTool(items_rev, img)
			if ((not tool_rev) or ((tool_rev ~= nil) and (not tool_rev.tool))) then return false end
			local rev = {
				image = findChild("1", "ImageButton", tool_rev.tool.object)
			}
			if tool_rev.activated then 
				rev.activate = findChild("1", "ImageButton", tool_rev.activated.object)
			end
			if (not rev.image) then return false end

			if rev.activate then
				deactivatify(tool_rev.activated.object)
			end
			activatify(tool_rev.tool.object)
		end)	
	end)
end

local function coreswitch(tool, ignore)
    local character = lplr.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if not ignore then
		local currentHandItem
		for _, acc in character:GetChildren() do
			if acc:IsA("Accessory") and acc:GetAttribute("InvItem") == true and acc:GetAttribute("ArmorSlot") == nil and acc:GetAttribute("IsBackpack") == nil then
				currentHandItem = acc
				break
			end
		end
		if currentHandItem then
			currentHandItem:Destroy()
		end
	
		for _, weld in pairs(character:GetDescendants()) do
			if weld:IsA("Weld") and weld.Name == "HandItemWeld" then
				weld:Destroy()
			end
		end
	
		local inventoryFolder = character:FindFirstChild("InventoryFolder")
		if not inventoryFolder or not inventoryFolder.Value then return end
		local toolInstance = inventoryFolder.Value:FindFirstChild(tool.Name)
		if not toolInstance then return end
		local clone = toolInstance:Clone()
	
		clone:SetAttribute("InvItem", true)
	
		humanoid:AddAccessory(clone)
	
		local handle = clone:FindFirstChild("Handle")
		if handle and handle:IsA("BasePart") then
			local attachment = handle:FindFirstChildWhichIsA("Attachment")
			if attachment then
				local characterAttachment = character:FindFirstChild(attachment.Name, true)
				if characterAttachment and characterAttachment:IsA("Attachment") then
					local weld = Instance.new("Weld")
					weld.Name = "HandItemWeld"
					weld.Part0 = characterAttachment.Parent 
					weld.Part1 = handle
					weld.C0 = characterAttachment.CFrame
					weld.C1 = attachment.CFrame
					weld.Parent = handle
				end
			end
		end
	
		local handInvItem = character:FindFirstChild("HandInvItem")
		if handInvItem then
			handInvItem.Value = tool
		end
	end

	pcall(function()
		local res = bedwars.Client:Get(bedwars.EquipItemRemote):InvokeServer({hand = tool})
		if res ~= nil and res == true then
			local handInvItem = character:FindFirstChild("HandInvItem")
			if handInvItem then
				handInvItem.Value = tool
			end
		elseif string.find(string.lower(tostring(res)), 'promise') then
			res:andThen(function(res)
				if res == true then
					local handInvItem = character:FindFirstChild("HandInvItem")
					if handInvItem then
						handInvItem.Value = tool
					end
				end
			end)
		end
	end)

    corehotbarswitch()

    return true
end

local function switchItem(tool, delayTime)
	local _tool = lplr.Character and lplr.Character:FindFirstChild('HandInvItem') and lplr.Character:FindFirstChild('HandInvItem').Value or nil
	if _tool ~= nil and _tool ~= tool then
		coreswitch(tool, true)
	end
end
VoidwareFunctions.GlobaliseObject("switchItem", switchItem)
local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (entityLibrary.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool.tool) then
		--[[if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars.ClientStoreHandler:dispatch({
					type = "InventorySelectHotbarSlot",
					slot = getHotbarSlot(tool.itemType)
				})
				vapeEvents.InventoryChanged.Event:Wait()
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end--]]
		switchItem(tool.tool)
	end
end
bedwars.ClientDamageBlock = {}
function bedwars.ClientDamageBlock:Get(rem)
	local a = bedwars.Client:Get(bedwars.DamageBlockRemote)
	local tbl = {}
	function tbl:CallServerAsync(call)
		local res = a:InvokeServer(call)
		local tbl2 = {}
		function tbl2:andThen(func)
			func(res)
		end
		return tbl2
	end
	return tbl
end
function bedwars.ClientDamageBlock:WaitFor(remName)
	return bedwars.Client:WaitFor(remName)
end
local function getLastCovered(pos, normal)
	local lastfound, lastpos = nil, nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock, extrablockpos = getPlacedBlock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			lastfound, lastpos = extrablock, extrablockpos
			if not covered then
				break
			end
		else
			break
		end
	end
	return lastfound, lastpos
end

local healthbarblocktable = {
	blockHealth = -1,
	breakingBlockPosition = Vector3.zero
}
local physicsUpdate = 1 / 60
local getBlockHealth = function() end
getBlockHealth = function(block, blockpos)
	return block:GetAttribute('Health')
end

local function getTool(breakType)
	local bestTool, bestToolSlot, bestToolDamage = nil, nil, 0
	for slot, item in store.localInventory.inventory.items do
		local toolMeta = bedwars.ItemTable[item.itemType].breakBlock
		if toolMeta then
			local toolDamage = toolMeta[breakType] or 0
			if toolDamage > bestToolDamage then
				bestTool, bestToolSlot, bestToolDamage = item, slot, toolDamage
			end
		end
	end
	return bestTool, bestToolSlot
end

local getBlockHits = function() end
getBlockHits = function(block, blockpos)
	if not block then return 0 end
	local breaktype = bedwars.ItemTable[block.Name] and bedwars.ItemTable[block.Name].block and bedwars.ItemTable[block.Name].block.breakType
	local tool = getTool(breaktype)
	tool = tool and bedwars.ItemTable[tool.itemType].breakBlock[breaktype] or 2
	return getBlockHealth(block, bedwars.BlockController:getBlockPosition(blockpos)) / tool
end

local cache = {}
local sides = {
    Vector3.new(3, 0, 0),  
    Vector3.new(-3, 0, 0),
    Vector3.new(0, 3, 0), 
    Vector3.new(0, -3, 0), 
    Vector3.new(0, 0, 3),  
    Vector3.new(0, 0, -3)
}
local calculatePath = function() end
calculatePath = function(target, blockpos)
	if cache[blockpos] then
		return unpack(cache[blockpos])
	end
	local visited, unvisited, distances, air, path = {}, {{0, blockpos}}, {[blockpos] = 0}, {}, {}
	local blocks = {}
	for _ = 1, 10000 do
		local _, node = next(unvisited)
		if not node then break end
		table.remove(unvisited, 1)
		visited[node[2]] = true
		for _, side in sides do
			side = node[2] + side
			if visited[side] then continue end
			local block = getPlacedBlock(side)
			if not block or block:GetAttribute('NoBreak') or block == target then
				if not block then
					air[node[2]] = true
				end
				continue
			end
			table.insert(blocks, block)
			local curdist = getBlockHits(block, side) + node[1]
			if curdist < (distances[side] or math.huge) then
				table.insert(unvisited, {curdist, side})
				distances[side] = curdist
				path[side] = node[2]
			end
		end
	end
	local pos, cost = nil, math.huge
	for node in air do
		if distances[node] < cost then
			pos, cost = node, distances[node]
		end
	end
	if pos then
		cache[blockpos] = { pos, cost, path, blocks }
		return pos, cost, path, blocks
	end
end

local getPickaxe = function() end

bedwars.breakBlock2 = function(block, anim)
	if lplr:GetAttribute('DenyBlockBreak') or not entitylib.isAlive or vape.Modules.InfiniteFly.Enabled then print('exit 1') return end
	local cost, pos, target, path, blocks = math.huge, nil, nil, nil, {}

	for _, v in ({block.Position / 3}) do
		local dpos, dcost, dpath, dblocks = calculatePath(block, v * 3)
		if dpos and dcost < cost then
			cost, pos, target, path = dcost, dpos, v * 3, dpath
			blocks = dblocks
		end
	end

	if pos then
		if (entitylib.character.RootPart.Position - pos).Magnitude > 30 then return end
		local roundedPosition = bedwars.BlockController:getBlockPosition(pos)
		local dblock, dpos = bedwars.BlockController:getStore():getBlockAt(roundedPosition), roundedPosition
		if not dblock then dblock = blocks[1] end
		--if not dblock then print('exit 3', dpos) return end

		if (game.Workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.4 then
			local tool
			if dblock and bedwars.ItemTable[dblock.Name] then
				local breaktype = bedwars.ItemTable[dblock.Name].block.breakType
				tool = getTool(breaktype)
			else
				tool = getPickaxe()
			end
			if tool then
				switchItem(tool.tool)
			end
		end

		local result = bedwars.Client:Get(bedwars.DamageBlockRemote):InvokeServer({
            blockRef = {blockPosition = dpos},
			hitPosition = pos,
			hitNormal = Vector3.FromNormalId(Enum.NormalId.Right)
        })
		print(dblock, dpos, pos, result)
		if result then
			if result == 'cancelled' then
				store.damageBlockFail = tick() + 1
				print('exit 4')
				return
			end

			if anim then
				local animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
				bedwars.ViewmodelController:playAnimation(15)
				task.wait(0.3)
				animation:Stop()
				animation:Destroy()
			end
		end

		return pos, path, target
	else print('exit 2') end
end
bedwars.placeBlock = function(pos, blockName)
	--if (not isBlockCovered(Vector3.new(pos.X/3, pos.Y/3, pos.Z/3))) then
		bedwars.Client:GetNamespace("PlaceBlock", {"PlaceBlockEvent"}):Get("PlaceBlock"):InvokeServer({
			["blockType"] = blockName,
			["position"] = Vector3.new(pos.X/3, pos.Y/3, pos.Z/3),
			["blockData"] = 0
		})
	--end
end
bedwars.getIcon = function(item, showinv)
	local itemmeta = bedwars.ItemTable[item.itemType]
	if itemmeta and showinv then
		return itemmeta.image or ""
	end
	return ""
end
bedwars.getInventory = function(plr)
	local inv = {
		items = {},
		armor = {}
	}
	local repInv = plr.Character and plr.Character:FindFirstChild("InventoryFolder") and plr.Character:FindFirstChild("InventoryFolder").Value
	if repInv then
		if repInv.ClassName and repInv.ClassName == "Folder" then
			for i,v in pairs(repInv:GetChildren()) do
				if not v:GetAttribute("CustomSpawned") then
					table.insert(inv.items, {
						tool = v,
						itemType = tostring(v),
						amount = v:GetAttribute("Amount")
					})
				end
			end
		end
	end
	local plrInvTbl = {
		"ArmorInvItem_0",
		"ArmorInvItem_1",
		"ArmorInvItem_2"
	}
	local function allowed(char)
		local state = true
		for i,v in pairs(plrInvTbl) do if (not char:FindFirstChild(v)) then state = false end end
		return state
	end
	local plrInv = plr.Character and allowed(plr.Character)
	if plrInv then
		for i,v in pairs(plrInvTbl) do
			table.insert(inv.armor, tostring(plr.Character:FindFirstChild(v).Value) == "" and "empty" or tostring(plr.Character:FindFirstChild(v).Value) ~= "" and {
				tool = v,
				itemType = tostring(plr.Character:FindFirstChild(v).Value)
			})
		end
	end
	return inv
end
bedwars.getKit = function(plr)
	return plr:GetAttribute("PlayingAsKit") or "none"
end
bedwars.QueueController = {}
function bedwars.QueueController:leaveParty()
    bedwars.Client:Get("LeaveParty"):InvokeServer()
end
function bedwars.QueueController:joinQueue(queueType)
    bedwars.Client:Get("joinQueue"):FireServer({["queueType"] = queueType})
end
bedwars.InfernalShieldController = {}
function bedwars.InfernalShieldController:raiseShield()
    bedwars.Client:Get("UseInfernalShield"):FireServer({["raised"] = true})
end
bedwars.SwordController = {
    lastSwing = tick(),
	lastAttack = game.Workspace:GetServerTimeNow()
}
bedwars.SwordController.isClickingTooFast = function() end
function bedwars.SwordController:canSee() return true end
-- bedwars.SwordController:playSwordEffect(swordmeta, false)
function bedwars.SwordController:playSwordEffect(swordmeta, status)
	task.spawn(function()
		local animation
		local animName = swordmeta.displayName:find(" Scythe") and "SCYTHE_SWING" or "SWORD_SWING"
		local animCooldown = swordmeta.displayName:find(" Scythe") and 0.3 or 0.15
		local lplr = game:GetService("Players").LocalPlayer
		animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(bedwars.AnimationUtil:fetchAnimationIndexId(animName)))
		task.wait(animCooldown)
		if animation ~= nil then animation:Stop(); animation:Destroy() end
	end)
end
function bedwars.SwordController:swingSwordAtMouse()
	pcall(function() return bedwars.Client:Get("SwordSwingMiss"):FireServer({["weapon"] = store.localHand.tool, ["chargeRatio"] = 0}) end)
end
bedwars.ScytheController = {}
function bedwars.ScytheController:playLocalAnimation() -- kinda useless but eh 
	task.spawn(function()
		local animation
		local lplr = game:GetService("Players").LocalPlayer
		animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(bedwars.AnimationUtil:fetchAnimationIndexId("SCYTHE_SWING")))
		task.wait(0.3)
		if animation ~= nil then
			animation:Stop()
			animation:Destroy()
		end
	end)
end
bedwars.SettingsController = {}
function bedwars.SettingsController:setFOV(num)
	gameCamera.FieldOfView = num
end
bedwars.AppController = {}
function bedwars.AppController:isAppOpen(appName)
	return game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild(appName)
end
bedwars.KillEffectMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("KillEffectMeta.json"))
--decode(readfile('vape/CheatEngine/KillEffectMeta.json'))
bedwars.BalloonController = {}
function bedwars.BalloonController:inflateBalloon()
	bedwars.Client:Get("InflateBalloon"):FireServer()
end
bedwars.SoundList = decode(VoidwareFunctions.fetchCheatEngineSupportFile("SoundListMeta.json"))
--decode(readfile('vape/CheatEngine/SoundListMeta.json'))
bedwars.SoundManager = {}
function bedwars.SoundManager:playSound(soundId)
	local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Parent = game.Workspace
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end
bedwars.MatchController = {}
function bedwars.MatchController:fetchPlayerTeam(plr)
	return tostring(plr.Team)
end
function bedwars.MatchController:fetchGameTime()
	local time, timeTable, suc = 0, {seconds = 0, minutes = 0}, false
	local window = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TopBarAppGui")
	if window then
		local frame = window:FindFirstChild("TopBarApp")
		if frame then
			for i,v in pairs(frame:GetChildren()) do
				if v.ClassName == "Frame" and v:FindFirstChild("4") and v:FindFirstChild("5") then
					if v:FindFirstChild("4").ClassName == "ImageLabel" and v:FindFirstChild("5").ClassName == "TextLabel" then
						time, timeTable, suc = extractTime(v:FindFirstChild("5").Text):toSeconds(), {
							seconds = extractTime(v:FindFirstChild("5").Text).seconds,
							minutes = extractTime(v:FindFirstChild("5").Text).minutes
						}, true
						break
					end
				end
			end
		end
	end
	return time, timeTable, suc
end
local lastTime, timeMoving = 0, true
task.spawn(function()
	repeat 
		local time, timeTable, suc = bedwars.MatchController:fetchGameTime()
		if time == lastTime then timeMoving = false else timeMoving = true end
		lastTime = time
		--warn("Checked time! ", time == lastTime, timeMoving)
		task.wait(2)
	until (not shared.VapeExecuted)
end)
function bedwars.MatchController:fetchMatchState()
	local matchState = 0

	local time, timeTable, suc
	--repeat time, timeTable, suc = bedwars.MatchController:fetchGameTime() until suc 
	time, timeTable, suc = bedwars.MatchController:fetchGameTime()
	if (not suc) then time, timeTable, suc = bedwars.MatchController:fetchGameTime() end
	local plrTeam = bedwars.MatchController:fetchPlayerTeam(game:GetService("Players").LocalPlayer)

	if time > 0 then matchState = plrTeam == "Spectators" and 2 or 1 else matchState = 0 end
	if (not timeMoving) and time > 0 then matchState = 2 end

	if (not suc) then warn("[bedwars.MatchController:fetchMatchState]: Failure getting valid time!"); matchState = 1 end

	--print(matchState, time, encode(timeTable), suc, plrTeam)

	return matchState
end
bedwars.RavenController = {}
function bedwars.RavenController:detonateRaven()
	bedwars.Client:Get("DetonateRaven"):InvokeServer()
end
bedwars.DefaultKillEffect = {}
bedwars.DefaultKillEffect.onKill = function(p3, p4, p5, p6)
	--- :shrug:
end
vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
	local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
	local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
	bedwars.DefaultKillEffect.onKill(nil, nil, killed, nil)
end)
bedwars.CooldownController = {}
local cooldownTable = {}
function cooldownTable:fetchIndexes()
	local indexes = {}
	for i,v in pairs(cooldownTable) do if type(v) ~= "function" then table.insert(indexes, v) end end
	return indexes
end
function cooldownTable:fetchItemIndex(item)
	local itemIndex
	for i,v in pairs(cooldownTable:fetchIndexes()) do if v.item == item then itemIndex = i end break end
	if (not itemIndex) then warn("[cooldownTable:fetchItemIndex]: FAILURE! itemIndex for "..tostring(item).." not found!"); return nil end
	return itemIndex
end
function cooldownTable:revokeCooldownAction(item)
	local itemIndex = cooldownTable:fetchItemIndex(item)
	if (not itemIndex) then warn("[cooldownTable:revokeCooldownAction]: Failure! Item: "..tostring(item)); return end
	cooldownTable[itemIndex].canceled = true
end
function cooldownTable:activateCooldownAction(item)
	local itemIndex = cooldownTable:fetchItemIndex(item)
	if (not itemIndex) then warn("[cooldownTable:activateCooldownAction]: Failure! Item: "..tostring(item)); return end
	task.spawn(function()
		repeat
			cooldownTable[itemIndex].cooldown = cooldownTable[itemIndex].cooldown - 0.1
			task.wait(0.1)
		until cooldownTable[itemIndex].cooldown == 0 or cooldownTable[itemIndex].cooldown < 0 or cooldownTable[itemIndex].canceled
		cooldownTable[itemIndex].cooldown = 0
		cooldownTable[itemIndex] = nil
	end)
end
function cooldownTable:registerCooldownItem(item, cooldown)
	cooldownTable[tostring(game:GetService("HttpService"):GenerateGUID(false))] = {["item"] = item, ["cooldown"] = cooldown, ["canceled"] = false} 
end
bedwars.CooldownController.CooldownTable = cooldownTable
function bedwars.CooldownController:setOnCooldown(item, cooldown)
	cooldownTable:registerCooldownItem(item, cooldown)
	cooldownTable:activateCooldownAction(item)
end
function bedwars.CooldownController:getRemainingCooldown(item)
	local itemIndex = cooldownTable:fetchItemIndex(item)
	if (not itemIndex) then cooldownTable:registerCooldownItem(item, 0) return 0 end
	return cooldownTable[itemIndex].cooldown
end
bedwars.AbilityController = {}
function bedwars.AbilityController:canUseAbility(ability) return true end -- no reverse engineering possible :(
function bedwars.AbilityController:useAbility(ability)
	bedwars.Client:Get("useAbility"):FireServer(ability)
end
bedwars.ShopItemsMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("ShopItemsMeta.json"))
--decode(readfile('vape/CheatEngine/ShopItemsMeta.json'))
bedwars.ShopItems = bedwars.ShopItemsMeta.ShopItems
local bowConstants = {}
local function getBowConstants()
	pcall(function()
		repeat task.wait() until entityLibrary.character.HumanoidRootPart
		local characterPosition = entityLibrary.character.HumanoidRootPart.Position
		targetPosition = Vector3.new(0, -60, 0) -- :)
	
		local relX = (0 - characterPosition.X) * 0.1 
		local relY = (-60 - characterPosition.Y) * 0.05
		local relZ = (0 - characterPosition.Z) * 0.1
	
		return {
			RelX = relX,
			RelY = relY,
			RelZ = relZ
		}
	end)
end
bowConstants = getBowConstants()
bedwars.BowConstantsTable = bowConstants
bedwars.ProjectileMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("ProjectileMeta.json"))
--decode(readfile('vape/CheatEngine/ProjectileMeta.json'))
bedwars.ProjectileUtil = {}
function bedwars.ProjectileUtil:createProjectile(p15, p16, p17, p18)
	local l__Projectiles__19, l__ProjectileMeta__5, l__Workspace__3, l__CollectionService__12 = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Projectiles"), bedwars.ProjectileMeta, game.Workspace, collectionService
	local u20 = nil;
	u20 = function(p19)
		return "projectile:" .. tostring(p19);
	end;
	local v68 = l__ProjectileMeta__5[p16].projectileModel;
	if v68 == nil then
		v68 = p16;
	end;
	local v69 = l__Projectiles__19:WaitForChild(v68);
	assert(v69, "Projectile model for projectile " .. p16 .. " can't be found.");
	local v70 = v69:Clone();
	assert(v70.PrimaryPart, "Primary part missing on projectile " .. v70.Name);
	v70.Name = p16;
	if p18 == nil then
		return nil;
	end;
	v70:SetPrimaryPartCFrame(p18);
	v70.Parent = l__Workspace__3;
	v70:SetAttribute("ProjectileShooter", p15.UserId);
	l__CollectionService__12:AddTag(v70, u20(p15.UserId));
	return v70;
end
function bedwars.ProjectileUtil.setupProjectileConstantOrientation(p22, p23)
	local l__ProjectileMeta__5, l__Players__9 = bedwars.ProjectileMeta, game:GetService("Players")
	local v76 = l__ProjectileMeta__5[p22.Name];
	if v76.useServerModel and p23 ~= l__Players__9.LocalPlayer then
		return v75;
	end;
	return v75;
end
bedwars.ProjectileController = {}
function bedwars.ProjectileController:createLocalProjectile(p29, p30, p31, p32, p33, p34, p35, p36)
	local l__ProjectileMeta__18, l__ProjectileUtil__20, l__Players__10 = bedwars.ProjectileMeta, bedwars.ProjectileUtil, game:GetService("Players")
	local v40 = l__ProjectileMeta__18[p31];
	local v41 = l__ProjectileUtil__20.createProjectile(l__Players__10.LocalPlayer, p30, p31, (l__Players__10.LocalPlayer.Character:GetPrimaryPartCFrame()));
	if not v41 or not (not v40.useServerModel) then
		return;
	end;
	l__ProjectileUtil__20.setupProjectileConstantOrientation(v41, l__Players__10.LocalPlayer);
	local v42 = 1;
	local v43 = p36;
	if v43 ~= nil then
		v43 = v43.drawDurationSeconds;
	end;
	local v44 = v43 ~= nil;
	p30 = bedwars.ItemTable[p31]
	if v44 then
		local v45 = p30;
		if v45 ~= nil then
			v45 = v45.maxStrengthChargeSec;
		end;
		v44 = v45;
	end;
	if v44 ~= 0 and v44 == v44 and v44 then
		v42 = math.clamp(p36.drawDurationSeconds / p30.maxStrengthChargeSec, 0, 1);
	end;
	local v46 = v40.gravitationalAcceleration;
	if v46 == nil then
		v46 = 196.2;
	end;
	local v47 = {};
	local v48 = p30;
	if v48 ~= nil then
		v48 = v48.relativeOverride;
	end;
	v47.relative = v48;
	v47.projectileSource = p30;
	v47.drawPercent = v42;
	return v41;
end
bedwars.MageKitUtil = {}
bedwars.MageKitUtil.MageElementVisualizations = decode(VoidwareFunctions.fetchCheatEngineSupportFile("MageKitUtileMeta.json")).MageElementMeta
--decode(readfile('vape/CheatEngine/MageKitUtileMeta.json')).MageElementMeta
bedwars.BalanceFile = decode(VoidwareFunctions.fetchCheatEngineSupportFile("BalanceFireMeta.json"))
--decode(readfile('vape/CheatEngine/BalanceFireMeta.json'))
bedwars.MageController = {}
bedwars.FishermanController = {}
bedwars.FishermanController.startMinigame = function() end
bedwars.DragonSlayerController = {}
function bedwars.DragonSlayerController:playPunchAnimation(animPos)
	return bedwars.GameAnimationUtil.playAnimation(game:GetService("Players").LocalPlayer, bedwars.AnimationType.DRAGON_SLAYER_PUNCH)
end
function bedwars.DragonSlayerController:fetchDragonEmblems()
	return game.Workspace:FindFirstChild("DragonEmblems") and game.Workspace:FindFirstChild("DragonEmblems").ClassName and game.Workspace:FindFirstChild("DragonEmblems").ClassName == "Folder" and game.Workspace:FindFirstChild("DragonEmblems"):GetChildren() or {}
end
bedwars.DragonSlayerController.emblemCache = {}
function bedwars.DragonSlayerController:fetchDragonEmblemData(emblem)
    --[[if self.emblemCache[emblem] then
        return self.emblemCache[emblem] 
    end--]]
    local c = emblem and emblem.Parent and emblem.ClassName and emblem.ClassName == "Model" and emblem:GetChildren() or {}
    local cn = #c
    local tbl = {
        stackCount = 0,
        CFrame = emblem:GetPrimaryPartCFrame()
    }
    if cn == 3 then
        for i, v in pairs(c) do
            if v.Parent and v.ClassName and v.ClassName == "MeshPart" then
                if tostring(v.BrickColor) == "Persimmon" then
                    tbl.stackCount = tbl.stackCount + 1
                end
            end
        end
    end
    self.emblemCache[emblem] = tbl
    return tbl
end
function bedwars.DragonSlayerController:deleteEmblem(emblem) 
	pcall(function() emblem:Destroy() end)
end
function bedwars.DragonSlayerController:resolveTarget(emblemCFrame)
	local target
	local maxDistance = 5
	for i, v in pairs(game.Workspace:GetChildren()) do
		if v and v.Parent and v.ClassName == "Model" and #v:GetChildren() > 0 and v.PrimaryPart then
			local distance = (v:GetPrimaryPartCFrame().Position - emblemCFrame.Position).Magnitude
			if distance <= maxDistance then target = v break end
		end
	end
	return target
end
bedwars.GrimReaperController = {}
function bedwars.GrimReaperController:fetchSoulsByPosition()
	local souls = {}
	for i,v in pairs(game.Workspace:GetChildren()) do
		if v and v.Parent and v.ClassName and v.ClassName == "Model" and v.Name == "GrimReaperSoul" and v:FindFirstChild("GrimSoul") then
			table.insert(souls, v)
		end
	end
	return souls
end
bedwars.SpiritAssassinController = {}
function bedwars.SpiritAssassinController:fetchSpiritOrbs()
	local orbs = {}
	for i,v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "SpiritOrb" and v.ClassName == "Model" and v:GetAttribute("SpiritSecret") then
			table.insert(orbs, v)
		end
	end
	return orbs
end
function bedwars.SpiritAssassinController:activateOrb(orb)
	bedwars.Client:GetNamespace("UseSpirit", {"SpiritAssassinWinEffectUseSpirit", "SpiritAssassinUseSpirit"}):Get("UseSpirit"):InvokeServer({["secret"] = tostring(orb:GetAttribute("SpiritSecret"))})
end
function bedwars.SpiritAssassinController:Invoke()
	for i,v in pairs(self:fetchSpiritOrbs()) do self:activateOrb(v) end
end
bedwars.WarlockController = {cooldown = 3, last = 0}
function bedwars.WarlockController:link(target)
	if target then
		local current = tick()
		if current - self.last < self.cooldown then return end
		self.last = current
		return bedwars.Client:Get("WarlockLinkTarget"):InvokeServer({["target"] = target})
	else return nil end
end
bedwars.EmberController = {}
function bedwars.EmberController:BladeRelease(blade)
	if blade then
		return bedwars.Client:Get('HellBladeRelease'):FireServer({chargeTime = 1, player = lplr, weapon = blade})
	else return nil end
end
bedwars.KaidaController = {}
function bedwars.KaidaController:request(target)
	--if shared.vapewhitelist.localprio > 0 then
		if target then 
			return bedwars.Client:Get("SummonerClawAttackRequest"):FireServer({["clientTime"] = tick(), ["direction"] = (target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HumanoidRootPart").Position - lplr.Character.HumanoidRootPart.Position).unit, ["position"] = target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HumanoidRootPart").Position})
		else return nil end
	--end
end
bedwars.DaoController = {chargingMaid = nil}
bedwars.StoreController = {}
function bedwars.StoreController:fetchLocalHand()
	repeat task.wait() until game:GetService("Players").LocalPlayer.Character
	return game:GetService("Players").LocalPlayer.Character:FindFirstChild("HandInvItem")
end
function bedwars.StoreController:updateLocalInventory()
	store.localInventory.inventory = bedwars.getInventory(game:GetService("Players").LocalPlayer)
end
function bedwars.StoreController:updateEquippedKit()
	store.equippedKit = bedwars.getKit(game:GetService("Players").LocalPlayer)
end
function bedwars.StoreController:updateMatchState()
	store.matchState = bedwars.MatchController:fetchMatchState()
end
function bedwars.StoreController:updateBowConstantsTable(targetPos)
	bedwars.BowConstantsTable = getBowConstants(targetPos)
end
function bedwars.StoreController:updateStoreBlocks()
	store.blocks = collectionService:GetTagged("block")
end
function bedwars.StoreController:updateZephyrOrb()
	if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("StatusEffectHudScreen") and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("StatusEffectHudScreen"):FindFirstChild("StatusEffectHud") and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("StatusEffectHudScreen"):FindFirstChild("StatusEffectHud"):FindFirstChild("WindWalkerEffect") and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("StatusEffectHudScreen"):FindFirstChild("StatusEffectHud"):FindFirstChild("WindWalkerEffect"):FindFirstChild("EffectStack") and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("StatusEffectHudScreen"):FindFirstChild("StatusEffectHud"):FindFirstChild("WindWalkerEffect"):FindFirstChild("EffectStack").ClassName and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("StatusEffectHudScreen"):FindFirstChild("StatusEffectHud"):FindFirstChild("WindWalkerEffect"):FindFirstChild("EffectStack").ClassName == "TextLabel" then store.zephyrOrb = tonumber(game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("StatusEffectHudScreen"):FindFirstChild("StatusEffectHud"):FindFirstChild("WindWalkerEffect"):FindFirstChild("EffectStack").Text) end
end
function bedwars.StoreController:updateLocalHand()
	local currentHand = bedwars.StoreController:fetchLocalHand()
	if (not currentHand) then store.localHand = {} return end
	local handType = ""
	if currentHand and currentHand.Value and currentHand.Value ~= "" then
		local handData = bedwars.ItemTable[tostring(currentHand.Value)]
		handType = handData.sword and "sword" or handData.block and "block" or tostring(currentHand.Value):find("bow") and "bow"
	end
	store.localHand = {tool = currentHand and currentHand.Value, itemType = currentHand and currentHand.Value and tostring(currentHand.Value) or "", Type = handType, amount = currentHand and currentHand:GetAttribute("Amount") and type(currentHand:GetAttribute("Amount")) == "number" or 0}
	store.localHand.toolType = store.localHand.Type
	store.hand = store.localHand
end
VoidwareFunctions.GlobaliseObject("StoreTable", {})
function bedwars.StoreController:executeStoreTable()
	for i,v in pairs(shared.StoreTable) do
		if type(v) == "function" then task.spawn(function() pcall(function() v() end) end) end
	end
end
--[[local UpdateIndexes = {}
function bedwars.StoreController:registerUpdateIndex(func, cooldown)
	table.insert(updateIndexes, {
		Function = func,
		WaitTime = cooldown
	})
end
bedwars.StoreController:registerUpdateIndex(function() bedwars.StoreController:updateLocalHand() end, 0.1)
bedwars.StoreController:registerUpdateIndex(function() bedwars.StoreController:updateLocalInventory() end, 0.1)
bedwars.StoreController:registerUpdateIndex(function() bedwars.StoreController:updateEquippedKit() end, 0.5)
bedwars.StoreController:registerUpdateIndex(function() bedwars.StoreController:updateMatchState() end, 0.1)
bedwars.StoreController:registerUpdateIndex(function() bedwars.StoreController:updateStoreBlocks() end, 1)
bedwars.StoreController:registerUpdateIndex(function() bedwars.StoreController:executeStoreTable() end, 0.5)
bedwars.StoreController:registerUpdateIndex(function() if store.equippedKit == "wind_walker" then bedwars.StoreController:updateZephyrOrbe() end end, 0.5)--]]

function bedwars.StoreController:updateStore()
	task.spawn(function() pcall(function() self:updateLocalHand() end) end)
	task.wait(0.1)
	task.spawn(function() pcall(function() self:updateLocalInventory() end) end)
	task.wait(0.1)
	task.spawn(function() pcall(function() self:updateEquippedKit() end) end)
	task.wait(0.1)
	task.spawn(function() pcall(function() self:updateMatchState() end) end)
	task.wait(0.1)
	task.spawn(function() pcall(function() self:updateStoreBlocks() end) end)
	task.wait(0.1)
	task.spawn(function() pcall(function() self:executeStoreTable() end) end)
	if store.equippedKit == "wind_walker" then
		task.wait(0.1)
		task.spawn(function() pcall(function() self:updateZephyrOrb() end) end)
	end
end
pcall(function() bedwars.StoreController:updateStore() end)

for i, v in pairs({"MatchEndEvent", "EntityDeathEvent", "EntityDamageEvent", "BedwarsBedBreak", "BalloonPopped", "AngelProgress"}) do
	bedwars.Client:WaitFor(v):andThen(function(connection)
		table.insert(vapeConnections, connection:Connect(function(...)
			vapeEvents[v]:Fire(...)
		end))
	end)
end
for i, v in pairs({"PlaceBlockEvent", "BreakBlockEvent"}) do
	bedwars.ClientDamageBlock:WaitFor(v):andThen(function(connection)
		table.insert(vapeConnections, connection:Connect(function(...)
			vapeEvents[v]:Fire(...)
		end))
	end)
end
VoidwareFunctions.GlobaliseObject("vapeEvents", vapeEvents)
table.insert(shared.StoreTable, function()
	VoidwareFunctions.GlobaliseObject("vapeEvents", vapeEvents)
end)

store.blockRaycast.FilterType = Enum.RaycastFilterType.Include
store.blocks = collectionService:GetTagged("block")
store.blockRaycast.FilterDescendantsInstances = {store.blocks}
table.insert(vapeConnections, collectionService:GetInstanceAddedSignal("block"):Connect(function(block)
	table.insert(store.blocks, block)
	store.blockRaycast.FilterDescendantsInstances = {store.blocks}
end))
table.insert(vapeConnections, collectionService:GetInstanceRemovedSignal("block"):Connect(function(block)
	local index = table.find(store.blocks, block)
	if index then
		table.remove(store.blocks, index)
		store.blockRaycast.FilterDescendantsInstances = {store.blocks}
	end
end))
local AutoLeave = {Enabled = false}

task.spawn(function()
	repeat
		task.wait(1)
		pcall(function() bedwars.StoreController:updateStore() end)
	until (not shared.vape)
end)

table.insert(vapeConnections, game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	gameCamera = game.Workspace.CurrentCamera or game.Workspace:FindFirstChildWhichIsA("gameCamera")
end))
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local networkownerswitch = tick()
--ME WHEN THE MOBILE EXPLOITS ADD A DISFUNCTIONAL ISNETWORKOWNER (its for compatability I swear!!)
local isnetworkowner = function(part)
	local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()
end
VoidwareFunctions.GlobaliseObject("isnetworkowner", isnetworkowner)
local getcustomasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local synapsev3 = syn and syn.toast_notification and "V3" or ""
local worldtoscreenpoint = function(pos)
	if synapsev3 == "V3" then
		local scr = worldtoscreen({pos})
		return scr[1] - Vector3.new(0, 36, 0), scr[1].Z > 0
	end
	return gameCamera.WorldToScreenPoint(gameCamera, pos)
end
local worldtoviewportpoint = function(pos)
	if synapsev3 == "V3" then
		local scr = worldtoscreen({pos})
		return scr[1], scr[1].Z > 0
	end
	return gameCamera.WorldToViewportPoint(gameCamera, pos)
end

local function vapeGithubRequest(scripturl)
	if not isfile("vape/"..scripturl) then
		local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/vapevoidware/"..readfile("vape/commithash.txt").."/"..scripturl, true) end)
		assert(suc, res)
		assert(res ~= "404: Not Found", res)
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("vape/"..scripturl, res)
	end
	return readfile("vape/"..scripturl)
end

local function downloadVapeAsset(path)
	if not isfile(path) then
		task.spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = vape.gui
			task.wait(0.1)
			textlabel:Destroy()
		end)
		local suc, req = pcall(function() return vapeGithubRequest(path:gsub("vape/assets", "assets")) end)
		if suc and req then
			writefile(path, req)
		else
			return ""
		end
	end
	if not vapeCachedAssets[path] then vapeCachedAssets[path] = getcustomasset(path) end
	return vapeCachedAssets[path]
end

local function run(func)
	local suc, err = pcall(function()
		func()
	end)
	if err then warn("[CE687224481.lua Module Error]: "..tostring(debug.traceback(err))) end
end

local function isFriend(plr, recolor)
	return false
end

local function isTarget(plr)
	return false
end

local function isVulnerable(plr) return plr.Humanoid and plr.Humanoid.Health or 1 > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField") end
VoidwareFunctions.GlobaliseObject("isVulnarable", isVulnarable)

local function getPlayerColor(plr)
	return tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color
end

local function LaunchAngle(v, g, d, h, higherArc)
	local v2 = v * v
	local v4 = v2 * v2
	local root = -math.sqrt(v4 - g*(g*d*d + 2*h*v2))
	return math.atan((v2 + root) / (g * d))
end

local function LaunchDirection(start, target, v, g)
	local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
	local h = target.Y - start.Y
	local d = horizontal.Magnitude
	local a = LaunchAngle(v, g, d, h)

	if a ~= a then
		return g == 0 and (target - start).Unit * v
	end

	local vec = horizontal.Unit * v
	local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
	return CFrame.fromAxisAngle(rotAxis, a) * vec
end

local physicsUpdate = 1 / 60

local function predictGravity(playerPosition, vel, bulletTime, targetPart, Gravity)
	local estimatedVelocity = vel.Y
	local rootSize = (targetPart.Humanoid.HipHeight + (targetPart.RootPart.Size.Y / 2))
	local velocityCheck = (tick() - targetPart.JumpTick) < 0.2
	vel = vel * physicsUpdate

	for i = 1, math.ceil(bulletTime / physicsUpdate) do
		if velocityCheck then
			estimatedVelocity = estimatedVelocity - (Gravity * physicsUpdate)
		else
			estimatedVelocity = 0
			playerPosition = playerPosition + Vector3.new(0, -0.03, 0) -- bw hitreg is so bad that I have to add this LOL
			rootSize = rootSize - 0.03
		end

		local floorDetection = game.Workspace:Raycast(playerPosition, Vector3.new(vel.X, (estimatedVelocity * physicsUpdate) - rootSize, vel.Z), store.blockRaycast)
		if floorDetection then
			playerPosition = Vector3.new(playerPosition.X, floorDetection.Position.Y + rootSize, playerPosition.Z)
			local bouncepad = floorDetection.Instance:FindFirstAncestor("gumdrop_bounce_pad")
			if bouncepad and bouncepad:GetAttribute("PlacedByUserId") == targetPart.Player.UserId then
				estimatedVelocity = 130 - (Gravity * physicsUpdate)
				velocityCheck = true
			else
				estimatedVelocity = targetPart.Humanoid.JumpPower - (Gravity * physicsUpdate)
				velocityCheck = targetPart.Jumping
			end
		end

		playerPosition = playerPosition + Vector3.new(vel.X, velocityCheck and estimatedVelocity * physicsUpdate or 0, vel.Z)
	end

	return playerPosition, Vector3.new(0, 0, 0)
end

local whitelist = shared.vapewhitelist
local RunLoops = shared.RunLoops

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	vapeInjected = false
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)

local function getItem(itemName, inv)
	for slot, item in pairs(inv or store.localInventory.inventory.items) do
		if item.itemType == itemName then
			return item, slot
		end
	end
	return nil
end
VoidwareFunctions.GlobaliseObject("getItem", getItem)

local cache = {}
local function getItemNear(itemName, inv)
    inv = inv or store.localInventory.inventory.items
    if cache[itemName] then
        local cachedItem, cachedSlot = cache[itemName].item, cache[itemName].slot
        if inv[cachedSlot] and inv[cachedSlot].itemType == cachedItem.itemType then
            return cachedItem, cachedSlot
        else
            cache[itemName] = nil
        end
    end
    for slot, item in pairs(inv) do
        if item.itemType == itemName or item.itemType:find(itemName) then
            cache[itemName] = { item = item, slot = slot }
            return item, slot
        end
    end
    return nil
end
VoidwareFunctions.GlobaliseObject("getItemNear", getItemNear)

local function getHotbarSlot(itemName)
	for slotNumber, slotTable in pairs(store.localInventory.hotbar) do
		if slotTable.item and slotTable.item.itemType == itemName then
			return slotNumber - 1
		end
	end
	return nil
end
VoidwareFunctions.GlobaliseObject("getHotbarSlot", getHotbarSlot)

local function getNearbyObjects(origin, distance)
    assert(typeof(origin) == "Vector3", "Origin must be a Vector3")
    assert(typeof(distance) == "number" and distance > 0, "Distance must be a positive number")
    local minBound = origin - Vector3.new(distance, distance, distance)
    local maxBound = origin + Vector3.new(distance, distance, distance)
    local region = Region3.new(minBound, maxBound)
    local workspaceObjects = game.Workspace:FindPartsInRegion3WithIgnoreList(region, {}, math.huge)
    local nearbyObjects = {}
    for _, part in pairs(workspaceObjects) do
        if (part.Position - origin).Magnitude <= distance then
            table.insert(nearbyObjects, part)
        end
    end
    return nearbyObjects
end
VoidwareFunctions.GlobaliseObject("getNearyObjects", getNearbyObjects)

local function getShieldAttribute(char)
	local returnedShield = 0
	for attributeName, attributeValue in pairs(char:GetAttributes()) do
		if attributeName:find("Shield") and type(attributeValue) == "number" then
			returnedShield = returnedShield + attributeValue
		end
	end
	return returnedShield
end
VoidwareFunctions.GlobaliseObject("getShieldAttribute", getShieldAttribute)

getPickaxe = function()
	return getItemNear("pick")
end

local function getAxe()
	local bestAxe, bestAxeSlot = nil, nil
	for slot, item in pairs(store.localInventory.inventory.items) do
		if item.itemType:find("axe") and item.itemType:find("pickaxe") == nil and item.itemType:find("void") == nil then
			bextAxe, bextAxeSlot = item, slot
		end
	end
	return bestAxe, bestAxeSlot
end

local function getClaw()
	for slot, item in store.localInventory.inventory.items do
		if item.itemType and string.find(string.lower(tostring(item.itemType)), "summoner_claw") then
			return item, slot, 12
		end
	end
end

local function getSword()
	local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
	for slot, item in pairs(store.localInventory.inventory.items) do
		if store.equippedKit == "summoner" then
			return getClaw()
		end
		local swordMeta = bedwars.ItemTable[item.itemType].sword
		if swordMeta then
			local swordDamage = swordMeta.damage or 0
			if swordDamage > bestSwordDamage then
				bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
			end
		end
	end
	return bestSword, bestSwordSlot
end
VoidwareFunctions.GlobaliseObject("getSword", getSword)

local function getBow()
	local bestBow, bestBowSlot, bestBowStrength = nil, nil, 0
	for slot, item in pairs(store.localInventory.inventory.items) do
		if item.itemType:find("bow") then
			local tab = bedwars.ItemTable[item.itemType].projectileSource
			local ammo = tab.projectileType("arrow")
			local dmg = bedwars.ProjectileMeta[ammo].combat.damage
			if dmg > bestBowStrength then
				bestBow, bestBowSlot, bestBowStrength = item, slot, dmg
			end
		end
	end
	return bestBow, bestBowSlot
end

local function getWool()
	local wool = getItemNear("wool")
	return wool and wool.itemType, wool and wool.amount
end

local function getBlock()
	for slot, item in pairs(store.localInventory.inventory.items) do
		if bedwars.ItemTable[item.itemType].block then
			return item.itemType, item.amount
		end
	end
end

local function attackValue(vec)
	return {value = vec}
end

--[[local function getSpeed()
	local speed = 0
	if lplr.Character then
		local SpeedDamageBoost = lplr.Character:GetAttribute("SpeedBoost")
		if SpeedDamageBoost and SpeedDamageBoost > 1 then
			speed = speed + (8 * (SpeedDamageBoost - 1))
		end
		if store.grapple > tick() then
			speed = speed + 90
		end
		if store.scythe > tick() then
			speed = speed + 5
		end
		if lplr.Character:GetAttribute("GrimReaperChannel") then
			speed = speed + 20
		end
		local armor = store.localInventory.inventory.armor[3]
		if type(armor) ~= "table" then armor = {itemType = ""} end
		if armor.itemType == "speed_boots" then
			speed = speed + 12
		end
		if store.zephyrOrb ~= 0 then
			speed = speed + 12
		end
	end
	return speed
end--]]
local isZephyr = false
--local desyncboost = {Enabled = false}
--local killauraNearPlayer
local oldhealth
local lastdamagetick = tick()
task.spawn(function()
	repeat task.wait() until entityLibrary.isAlive
	oldhealth = game:GetService("Players").LocalPlayer.Character.Humanoid.Health
	game:GetService("Players").LocalPlayer.Character.Humanoid.HealthChanged:Connect(function(new)
		repeat task.wait() until entityLibrary.isAlive
		if new < oldhealth then
			lastdamagetick = tick() + 0.25
		end
		oldhealth = new
	end)
end)
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
	pcall(function()
		repeat task.wait() until entityLibrary.isAlive
		local oldhealth = game:GetService("Players").LocalPlayer.Character.Humanoid.Health
		repeat task.wait() until game:GetService("Players").LocalPlayer.Character.Humanoid
		game:GetService("Players").LocalPlayer.Character.Humanoid.HealthChanged:Connect(function(new)
			if new < oldhealth then
				lastdamagetick = tick() + 0.25
			end
			oldhealth = new
		end)
	end)
end)
shared.zephyrActive = false
shared.scytheActive = false
shared.SpeedBoostEnabled = false
shared.scytheSpeed = 5
local function getSpeed(reduce)
	local speed = 0
	if lplr.Character then
		local SpeedDamageBoost = lplr.Character:GetAttribute("SpeedBoost")
		if SpeedDamageBoost and SpeedDamageBoost > 1 then
			speed = speed + (8 * (SpeedDamageBoost - 1))
		end
		if store.grapple > tick() then
			speed = speed + 90
		end
		if store.scythe > tick() and shared.scytheActive then
			speed = speed + shared.scytheSpeed
		end
		if lplr.Character:GetAttribute("GrimReaperChannel") then
			speed = speed + 20
		end
		if lastdamagetick > tick() and shared.SpeedBoostEnabled then
			speed = speed + 10
		end;
		local armor = store.localInventory.inventory.armor[3]
		if type(armor) ~= "table" then armor = {itemType = ""} end
		if armor.itemType == "speed_boots" then
			speed = speed + 12
		end
		if store.zephyrOrb ~= 0 then
			speed = speed + 12
		end
		if store.zephyrOrb ~= 0 and shared.zephyrActive then
			isZephyr = true
		else
			isZephyr = false
		end
	end
	pcall(function()
		--speed = speed + (CheatEngineHelper.SprintEnabled and 23 - game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed or 0)
	end)
	return reduce and speed ~= 1 and math.max(speed * (0.8 - (0.3 * math.floor(speed))), 1) or speed
end
VoidwareFunctions.GlobaliseObject("getSpeed", getSpeed)

local Reach = {Enabled = false}
local blacklistedblocks = {bed = true, ceramic = true}
local oldpos = Vector3.zero

local function getScaffold(vec, diagonaltoggle)
	local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3)
	local speedCFrame = (oldpos - realvec)
	local returedpos = realvec
	if entityLibrary.isAlive then
		local angle = math.deg(math.atan2(-entityLibrary.character.Humanoid.MoveDirection.X, -entityLibrary.character.Humanoid.MoveDirection.Z))
		local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
		if goingdiagonal and ((speedCFrame.X == 0 and speedCFrame.Z ~= 0) or (speedCFrame.X ~= 0 and speedCFrame.Z == 0)) and diagonaltoggle then
			return oldpos
		end
	end
	return realvec
end
VoidwareFunctions.GlobaliseObject("getScaffold", getScaffold)

local function waitForChildOfType(obj, name, timeout, prop)
	local check, returned = tick() + timeout
	repeat
		returned = prop and obj[name] or obj:FindFirstChildOfClass(name)
		if returned or check < tick() then
			break
		end
		task.wait()
	until false
	return returned
end

local function getBestTool(block)
	local tool = nil
	local blockmeta = bedwars.ItemTable[block]
	local blockType = blockmeta.block and blockmeta.block.breakType
	if blockType then
		local best = 0
		for i,v in pairs(store.localInventory.inventory.items) do
			local meta = bedwars.ItemTable[v.itemType]
			if meta.breakBlock and meta.breakBlock[blockType] and meta.breakBlock[blockType] >= best then
				best = meta.breakBlock[blockType]
				tool = v
			end
		end
	end
	return tool
end
VoidwareFunctions.GlobaliseObject("getBestTool", getBestTool)

local function GetPlacedBlocksNear(pos, normal)
	local blocks = {}
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getPlacedBlock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			if bedwars.BlockController:isBlockBreakable({blockPosition = blockpos}, lplr) and (not blacklistedblocks[extrablock.Name]) then
				table.insert(blocks, extrablock.Name)
			end
			lastfound = extrablock
			if not covered then
				break
			end
		else
			break
		end
	end
	return blocks
end

local function getBestBreakSide(pos)
	local softest, softestside = 9e9, Enum.NormalId.Top
	for i,v in pairs(cachedNormalSides) do
		local sidehardness = 0
		for i2,v2 in pairs(GetPlacedBlocksNear(pos, v)) do
			if bedwars.ItemTable[v2] then
				local blockmeta = bedwars.ItemTable[v2].block
				sidehardness = sidehardness + (blockmeta and blockmeta.health or 10)
				if blockmeta then
					local tool = getBestTool(v2)
					if tool then
						sidehardness = sidehardness - bedwars.ItemTable[tool.itemType].breakBlock[blockmeta.breakType]
					end
				end
			end
		end
		if sidehardness <= softest then
			softest = sidehardness
			softestside = v
		end
	end
	return softestside, softest
end

local function EntityNearPosition(distance, ignore, overridepos)
	local closestEntity, closestMagnitude = nil, distance
	if entityLibrary.isAlive then
		for i, v in pairs(entityLibrary.List) do
			if not v.Targetable then continue end
			local mag = (entityLibrary.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
			if overridepos and mag > distance then
				mag = (overridepos - v.RootPart.Position).magnitude
			end
			if mag <= closestMagnitude then
				closestEntity, closestMagnitude = v, mag
			end
		end
		if not ignore then
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "Void Enemy Dummy" or v.Name == "Emerald Enemy Dummy" or v.Name == "Diamond Enemy Dummy" or v.Name == "Leather Enemy Dummy" or v.Name == "Regular Enemy Dummy" or v.Name == "Iron Enemy Dummy" then
					if v.PrimaryPart then
						local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
						if overridepos and mag > distance then
							mag = (overridepos - v2.PrimaryPart.Position).magnitude
						end
						if mag <= closestMagnitude then
							closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
						end
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("Monster")) do
				if v.PrimaryPart and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("GuardianOfDream")) do
				if v.PrimaryPart and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("DiamondGuardian")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "DiamondGuardian", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("GolemBoss")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "GolemBoss", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("Drone")) do
				if v.PrimaryPart and tonumber(v:GetAttribute("PlayerUserId")) ~= lplr.UserId then
					local droneplr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
					if droneplr and droneplr.Team == lplr.Team then continue end
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "Drone", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i,v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "InfectedCrateEntity" and v.ClassName == "Model" and v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "InfectedCrateEntity", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(store.pots) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "Pot", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
		end
	end
	return closestEntity
end
VoidwareFunctions.GlobaliseObject("EntityNearPosition", EntityNearPosition)

local function EntityNearMouse(distance)
	local closestEntity, closestMagnitude = nil, distance
	if entityLibrary.isAlive then
		local mousepos = inputService.GetMouseLocation(inputService)
		for i, v in pairs(entityLibrary.List) do
			if not v.Targetable then continue end
			if isVulnerable(v) then
				local vec, vis = worldtoscreenpoint(v.RootPart.Position)
				local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
				if vis and mag <= closestMagnitude then
					closestEntity, closestMagnitude = v, v.Target and -1 or mag
				end
			end
		end
	end
	return closestEntity
end
VoidwareFunctions.GlobaliseObject("EntityNearMouse", EntityNearMouse)

local function isWhitelistedBed(bed)
    if bed and bed.Name == 'bed' then
        for i, v in pairs(playersService:GetPlayers()) do
            if bed:GetAttribute("Team"..(v:GetAttribute("Team") or 0).."NoBreak") and not ({whitelist:get(v)})[2] then
                return true
            end
        end
    end
    return false
end

run(function()
	local oldstart = entitylib.start
	local function customEntity(ent)
		if ent:HasTag('inventory-entity') and not ent:HasTag('Monster') then
			return
		end

		entitylib.addEntity(ent, nil, ent:HasTag('Drone') and function(self)
			local droneplr = playersService:GetPlayerByUserId(self.Character:GetAttribute('PlayerUserId'))
			return not droneplr or lplr:GetAttribute('Team') ~= droneplr:GetAttribute('Team')
		end or function(self)
			return lplr:GetAttribute('Team') ~= self.Character:GetAttribute('Team')
		end)
	end

	task.spawn(function()
		repeat
			task.wait()
			if entitylib.isAlive then
				entitylib.groundTick = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and tick() or entitylib.groundTick
			end
		until not shared.vape
	end)

	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			for _, ent in collectionService:GetTagged('entity') do
				customEntity(ent)
			end
			table.insert(entitylib.Connections, collectionService:GetInstanceAddedSignal('entity'):Connect(customEntity))
			table.insert(entitylib.Connections, collectionService:GetInstanceRemovedSignal('entity'):Connect(function(ent)
				entitylib.removeEntity(ent)
			end))
		end
	end

	entitylib.addPlayer = function(plr)
		if plr.Character then
			entitylib.refreshEntity(plr.Character, plr)
		end
		entitylib.PlayerConnections[plr] = {
			plr.CharacterAdded:Connect(function(char)
				entitylib.refreshEntity(char, plr)
			end),
			plr.CharacterRemoving:Connect(function(char)
				entitylib.removeEntity(char, plr == lplr)
			end),
			plr:GetAttributeChangedSignal('Team'):Connect(function()
				for _, v in entitylib.List do
					if v.Targetable ~= entitylib.targetCheck(v) then
						entitylib.refreshEntity(v.Character, v.Player)
					end
				end

				if plr == lplr then
					entitylib.start()
				else
					entitylib.refreshEntity(plr.Character, plr)
				end
			end)
		}
	end

	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum, humrootpart, head
			if plr then
				hum = waitForChildOfType(char, 'Humanoid', 10)
				humrootpart = hum and waitForChildOfType(hum, 'RootPart', game.Workspace.StreamingEnabled and 9e9 or 10, true)
				head = char:WaitForChild('Head', 10) or humrootpart
			else
				hum = {HipHeight = 0.5}
				humrootpart = waitForChildOfType(char, 'PrimaryPart', 10, true)
				head = humrootpart
			end
			local updateobjects = plr and plr ~= lplr and {
				char:WaitForChild('ArmorInvItem_0', 5),
				char:WaitForChild('ArmorInvItem_1', 5),
				char:WaitForChild('ArmorInvItem_2', 5),
				char:WaitForChild('HandInvItem', 5)
			} or {}

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = (char:GetAttribute('Health') or 100) + getShieldAttribute(char),
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
					Jumps = 0,
					JumpTick = tick(),
					Jumping = false,
					LandTick = tick(),
					MaxHealth = char:GetAttribute('MaxHealth') or 100,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					TeamCheck = teamfunc
				}

				if plr == lplr then
					entity.AirTime = tick()
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
					table.insert(entitylib.Connections, char.AttributeChanged:Connect(function(attr)
						vapeEvents.AttributeChanged:Fire(attr)
					end))
				else
					entity.Targetable = entitylib.targetCheck(entity)

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							entity.Health = (char:GetAttribute('Health') or 100) + getShieldAttribute(char)
							entity.MaxHealth = char:GetAttribute('MaxHealth') or 100
							entitylib.Events.EntityUpdated:Fire(entity)
						end))
					end

					for _, v in updateobjects do
						table.insert(entity.Connections, v:GetPropertyChangedSignal('Value'):Connect(function()
							task.delay(0.1, function()
								if bedwars.getInventory then
									store.inventories[plr] = bedwars.getInventory(plr)
									entitylib.Events.EntityUpdated:Fire(entity)
								end
							end)
						end))
					end

					if plr then
						local anim = char:FindFirstChild('Animate')
						if anim then
							pcall(function()
								anim = anim.jump:FindFirstChildWhichIsA('Animation').AnimationId
								table.insert(entity.Connections, hum.Animator.AnimationPlayed:Connect(function(playedanim)
									if playedanim.Animation.AnimationId == anim then
										entity.JumpTick = tick()
										entity.Jumps += 1
										entity.LandTick = tick() + 1
										entity.Jumping = entity.Jumps > 1
									end
								end))
							end)
						end

						task.delay(0.1, function()
							if bedwars.getInventory then
								store.inventories[plr] = bedwars.getInventory(plr)
							end
						end)
					end
					table.insert(entitylib.List, entity)
					entitylib.Events.EntityAdded:Fire(entity)
				end

				table.insert(entity.Connections, char.ChildRemoved:Connect(function(part)
					if part == humrootpart or part == hum or part == head then
						if part == humrootpart and hum.RootPart then
							humrootpart = hum.RootPart
							entity.RootPart = hum.RootPart
							entity.HumanoidRootPart = hum.RootPart
							return
						end
						entitylib.removeEntity(char, plr == lplr)
					end
				end))
			end
			entitylib.EntityThreads[char] = nil
		end)
	end

	entitylib.getUpdateConnections = function(ent)
		local char = ent.Character
		local tab = {
			char:GetAttributeChangedSignal('Health'),
			char:GetAttributeChangedSignal('MaxHealth'),
			{
				Connect = function()
					ent.Friend = ent.Player and isFriend(ent.Player) or nil
					ent.Target = ent.Player and isTarget(ent.Player) or nil
					return {Disconnect = function() end}
				end
			}
		}

		for name, val in char:GetAttributes() do
			if name:find('Shield') and type(val) == 'number' then
				table.insert(tab, char:GetAttributeChangedSignal(name))
			end
		end

		return tab
	end

	entitylib.targetCheck = function(ent)
		if ent.TeamCheck then
			return ent:TeamCheck()
		end
		if ent.NPC then return true end
		if isFriend(ent.Player) then return false end
		if not select(2, whitelist:get(ent.Player)) then return false end
		return lplr:GetAttribute('Team') ~= ent.Player:GetAttribute('Team')
	end
	vape:Clean(entitylib.Events.LocalAdded:Connect(updateVelocity))
end)
entitylib.start()

run(function()
	local checked = {}
	local function check(v)
		if table.find(checked, v) then return end
		local npcNames = {"Void Enemy Dummy", "Emerald Enemy Dummy", "Diamond Enemy Dummy", "Leather Enemy Dummy", "Regular Enemy Dummy", "Iron Enemy Dummy"}
		local function isNPC(name)
			for i,v in pairs(npcNames) do
				if string.find(string.lower(name), string.lower(v)) then return true end
			end
			return false
		end
		if isNPC(v.Name) then
			if v.PrimaryPart then
				v.Name = v.Name.." | "..tostring(#checked)
				entitylib.addEntity(v, nil, function() return true end)
				table.insert(checked, v)
			end
		end
	end
	for i, v in pairs(game.Workspace:GetChildren()) do
		check(v)
	end
	local con
	local con2
	con = game.Workspace.ChildAdded:Connect(function(v)
		if not shared.vape then pcall(function()
			con:Disconnect()
			table.clear(checked)
		end) end
		check(v)
	end)
	con2 = game.Workspace.ChildRemoved:Connect(function(v)
		if not shared.vape then pcall(function()
			con2:Disconnect()
			table.clear(checked)
		end) end
		if table.find(checked, v) then
			entitylib.removeEntity(v)
		end
	end)
end)

for _, v in {'Parkour', 'Music Player', 'Spin Bot', 'Desync', 'Weather', 'Trails', 'Fire', 'Disabler', 'Gravity', 'HighJump', 'AntiRagdoll', 'TriggerBot', 'SilentAim', 'PlayerModel', 'AutoRejoin', 'Panic', 'Rejoin', 'Timer', 'ServerHop', 'MouseTP', 'MurderMystery', 'Waypoints', 'Arrows', 'Tracers', 'Search', "GamingChair", "Health"} do
	vape:Remove(v)
end

local sortmethods = {
	Damage = function(a, b)
		return a.Entity.Character:GetAttribute('LastDamageTakenTime') < b.Entity.Character:GetAttribute('LastDamageTakenTime')
	end,
	Threat = function(a, b)
		return getStrength(a.Entity) > getStrength(b.Entity)
	end,
	Kit = function(a, b)
		return (a.Entity.Player and kitorder[a.Entity.Player:GetAttribute('PlayingAsKit')] or 0) > (b.Entity.Player and kitorder[b.Entity.Player:GetAttribute('PlayingAsKit')] or 0)
	end,
	Health = function(a, b)
		return a.Entity.Health < b.Entity.Health
	end,
	Angle = function(a, b)
		local selfrootpos = entitylib.character.RootPart.Position
		local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
		local angle = math.acos(localfacing:Dot(((a.Entity.RootPart.Position - selfrootpos) * Vector3.new(1, 0, 1)).Unit))
		local angle2 = math.acos(localfacing:Dot(((b.Entity.RootPart.Position - selfrootpos) * Vector3.new(1, 0, 1)).Unit))
		return angle < angle2
	end
}

local function Wallcheck(attackerCharacter, targetCharacter, additionalIgnore)
    if not (attackerCharacter and targetCharacter) then
        return false
    end

    local humanoidRootPart = attackerCharacter.PrimaryPart
    local targetRootPart = targetCharacter.PrimaryPart
    if not (humanoidRootPart and targetRootPart) then
        return false
    end

    local origin = humanoidRootPart.Position
    local targetPosition = targetRootPart.Position
    local direction = targetPosition - origin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.RespectCanCollide = true

    local ignoreList = {attackerCharacter}
    
    if additionalIgnore and typeof(additionalIgnore) == "table" then
        for _, item in pairs(additionalIgnore) do
            table.insert(ignoreList, item)
        end
    end

    raycastParams.FilterDescendantsInstances = ignoreList

    local raycastResult = workspace:Raycast(origin, direction, raycastParams)

    if raycastResult then
        if raycastResult.Instance:IsDescendantOf(targetCharacter) then
            return true
        else
            return false
        end
    else
        return true
    end
end

run(function()
	local function isFirstPerson()
		if not (lplr.Character and lplr.Character:FindFirstChild("Head")) then return nil end
		return (lplr.Character.Head.Position - gameCamera.CFrame.Position).Magnitude < 2
	end
	local AimAssist
	local Targets
	local Sort
	local AimSpeed
	local Distance
	local AngleSlider
	local StrafeIncrease
	local KillauraTarget
	local ClickAim
	local ShopCheck
	local FirstPersonCheck
	
	AimAssist = vape.Categories.Combat:CreateModule({
		Name = 'Aim Assist',
		Function = function(callback)
			if callback then
				AimAssist:Clean(runService.Heartbeat:Connect(function(dt)
					if entitylib.isAlive and store.localHand.Type == 'sword' and ((not ClickAim.Enabled) or (tick() - bedwars.SwordController.lastSwing) < 0.4) then
						local ent = entitylib.EntityPosition({
							Range = Distance.Value,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Sort = sortmethods[Sort.Value]
						})
	
						if ent then
							if FirstPersonCheck.Enabled then
								if not isFirstPerson() then return end
							end
							if ShopCheck.Enabled then
								local isShop = lplr:FindFirstChild("PlayerGui") and lplr:FindFirstChild("PlayerGui"):FindFirstChild("ItemShop") or nil
								if isShop then return end
							end
							if Targets.Walls.Enabled then
								if not Wallcheck(lplr.Character, ent.Character) then return end
							end
							pcall(function()
								local plr = ent
								targetinfo.Targets.AimAssist = {
									Humanoid = {
										Health = (plr.Character:GetAttribute("Health") or plr.Humanoid.Health) + getShieldAttribute(plr.Character),
										MaxHealth = plr.Character:GetAttribute("MaxHealth") or plr.Humanoid.MaxHealth
									},
									Player = plr.Player
								}
							end)
							local delta = (ent.RootPart.Position - entitylib.character.RootPart.Position)
							local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
							local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
							if angle >= (math.rad(AngleSlider.Value) / 2) then return end
							pcall(function()
								targetinfo.Targets[ent] = tick() + 1
							end)
							gameCamera.CFrame = gameCamera.CFrame:Lerp(CFrame.lookAt(gameCamera.CFrame.p, ent.RootPart.Position), (AimSpeed.Value + (StrafeIncrease.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 10 or 0)) * dt)
						end
					end
				end))
			else pcall(function() targetinfo.Targets.AimAssist = nil end) end
		end,
		Tooltip = 'Smoothly aims to closest valid target with sword'
	})
	Targets = AimAssist:CreateTargets({
		Players = true, 
		Walls = true
	})
	local methods = {'Damage', 'Distance'}
	for i in sortmethods do
		if not table.find(methods, i) then
			table.insert(methods, i)
		end
	end
	Sort = AimAssist:CreateDropdown({
		Name = 'Target Mode',
		List = methods
	})
	AimSpeed = AimAssist:CreateSlider({
		Name = 'Aim Speed',
		Min = 1,
		Max = 20,
		Default = 6
	})
	Distance = AimAssist:CreateSlider({
		Name = 'Distance',
		Min = 1,
		Max = 30,
		Default = 30,
		Suffx = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	AngleSlider = AimAssist:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 70
	})
	ClickAim = AimAssist:CreateToggle({
		Name = 'Click Aim',
		Default = true
	})
	KillauraTarget = AimAssist:CreateToggle({
		Name = 'Use killaura target'
	})
	ShopCheck = AimAssist:CreateToggle({
		Name = "Shop Check",
		Function = function() end,
		Default = false
	})
	FirstPersonCheck = AimAssist:CreateToggle({
		Name = "First Person Check",
		Function = function() end,
		Default = false
	})
	StrafeIncrease = AimAssist:CreateToggle({Name = 'Strafe increase'})
end)

run(function()
	local Sprint = {Enabled = false}
	local oldSprintFunction
	Sprint = vape.Categories.Combat:CreateModule({
		["Name"] = "Sprint",
		["Function"] = function(callback)
			if callback then
				sprinten = true
				thread = task.spawn(function()
					repeat task.wait()
						if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
							game:GetService("Players").LocalPlayer:SetAttribute("Sprinting", true)
							game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 20
						end
					until not sprinten
				end)
			else 
				sprinten = false
				if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
					game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 16
				end
				game:GetService("Players").LocalPlayer:SetAttribute("Sprinting", false)
				if thread then
					task.cancel(thread)
					thread = nil
				end
			end 
		end,
		["Tooltip"] = "Sets your sprinting to true."
	})
	game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
		if sprinten then
			character:WaitForChild("Humanoid").WalkSpeed = 23
		else
			character:WaitForChild("Humanoid").WalkSpeed = 16
		end
	end)
	game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function(character)
		if character:WaitForChild("Humanoid") then
			character:WaitForChild("Humanoid").WalkSpeed = 16
		end
	end)
end)

run(function()
	local function isXeno()
		local status = false

		if identifyexecutor ~= nil and type(identifyexecutor) == "function" then
			local suc, res = pcall(function()
				return identifyexecutor()
			end)   
			res = tostring(res)
			if string.find(string.lower(res), 'xeno') then status = true end
		else status = false end

		return status
	end
	if isXeno() then
		local CombatConstant

		local Value
		
		Reach = vape.Categories.Combat:CreateModule({
			Name = 'Reach',
			Function = function(callback)
				
			end,
			Tooltip = 'Extends attack reach'
		})
		Value = Reach:CreateSlider({
			Name = 'Range',
			Min = 0,
			Max = 18,
			Default = 18,
			Function = function(val)
				if Reach.Enabled then
					
				end
			end,
			Suffix = function(val)
				return val == 1 and 'stud' or 'studs'
			end
		})
	end
end)

run(function()
	local StaffDetector
	local Mode
	local Profile
	local Users
	local blacklistedclans = {'gg', 'gg2', 'DV', 'DV2'}
	local blacklisteduserids = {1502104539, 3826146717, 4531785383, 1049767300, 4926350670, 653085195, 184655415, 2752307430, 5087196317, 5744061325, 1536265275}
	local joined = {}
	
	local function getRole(plr, id)
		local suc, res = pcall(function() 
			return plr:GetRankInGroup(id)
		end)
		if not suc then 
			InfoNotification('StaffDetector', res, 30, 'alert') 
		end
		return suc and res or 0
	end
	
	local function staffFunction(plr, checktype)
		if not vape.Loaded then repeat task.wait() until vape.Loaded end
		InfoNotification('StaffDetector', 'Staff Detected ('..checktype..'): '..plr.Name..' ('..plr.UserId..')', 60, 'alert')
		whitelist.customtags[plr.Name] = {{text = 'GAME STAFF', color = Color3.new(1, 0, 0)}}
	
		if Mode.Value == 'Uninject' then
			task.spawn(function() 
				vape:Uninject() 
			end)
			game:GetService('StarterGui'):SetCore('SendNotification', {
				Title = 'StaffDetector',
				Text = 'Staff Detected ('..checktype..')\n'..plr.Name..' ('..plr.UserId..')',
				Duration = 60,
			})
		elseif Mode.Value == 'Profile' then
			vape.Save = function() end
			if vape.Profile ~= Profile.Value then
				vape:Load(true, Profile.Value)
			end
		elseif Mode.Value == 'AutoConfig' then
			local safe = {'AutoClicker', 'Reach', 'Sprint', 'HitFix', 'StaffDetector'}
			vape.Save = function() end
			for i, v in vape.Modules do
				if not (table.find(safe, i) or v.Category == 'Render') then
					if v.Enabled then 
						v:Toggle() 
					end
					v:SetBind('')
				end
			end
		end
	end
	
	local function checkFriends(list)
		for _, v in list do
			if joined[v] then 
				return joined[v] 
			end
		end
		return nil
	end
	
	local function checkJoin(plr, connection)
		if not plr:GetAttribute('Team') and plr:GetAttribute('Spectator') and not bedwars.Store:getState().Game.customMatch then
			connection:Disconnect()
			local tab, pages = {}, playersService:GetFriendsAsync(plr.UserId)
			for _ = 1, 4 do
				for _, v in pages:GetCurrentPage() do 
					table.insert(tab, v.Id) 
				end
				if pages.IsFinished then break end
				pages:AdvanceToNextPageAsync()
			end
	
			local friend = checkFriends(tab)
			if not friend then
				staffFunction(plr, 'impossible_join')
			else
				InfoNotification('StaffDetector', string.format('Spectator %s joined from %s', plr.Name, friend), 20, 'warning')
			end
		end
	end
	
	local function playerAdded(plr)
		joined[plr.UserId] = plr.Name
		if plr == lplr then return end
		if table.find(blacklisteduserids, plr.UserId) or table.find(Users.ListEnabled, tostring(plr.UserId)) then
			staffFunction(plr, 'blacklisted_user')
			return
		end
	
		if getRole(plr, 5774246) >= 100 then
			staffFunction(plr, 'staff_role')
		else
			local connection
			connection = plr:GetAttributeChangedSignal('Spectator'):Connect(function() checkJoin(plr, connection) end)
			checkJoin(plr, connection)
			StaffDetector:Clean(connection)
			if not plr:GetAttribute('ClanTag') then
				plr:GetAttributeChangedSignal('ClanTag'):Wait()
			end
			if table.find(blacklistedclans, plr:GetAttribute('ClanTag')) and vape.Loaded then
				connection:Disconnect()
				staffFunction(plr, 'blacklisted_clan_'..plr:GetAttribute('ClanTag'):lower())
			end
		end
	end
	
	StaffDetector = vape.Categories.Utility:CreateModule({
		Name = 'StaffDetector',
		Function = function(callback)
			if callback then
				StaffDetector:Clean(playersService.PlayerAdded:Connect(playerAdded))
				for _, v in playersService:GetPlayers() do 
					task.spawn(playerAdded, v) 
				end
			else
				table.clear(joined)
			end
		end,
		Tooltip = 'Detects people with a staff rank ingame'
	})
	Mode = StaffDetector:CreateDropdown({
		Name = 'Mode',
		List = {'Uninject', 'Profile', 'AutoConfig', 'Notify'},
		Function = function(val)
			if Profile.Object then
				Profile.Object.Visible = val == 'Profile'
			end
		end
	})
	Profile = StaffDetector:CreateTextBox({
		Name = 'Profile',
		Default = 'default',
		Darker = true,
		Visible = false
	})
	Users = StaffDetector:CreateTextList({
		Name = 'Users',
		Placeholder = 'player (userid)'
	})
	
	task.spawn(function()
		repeat task.wait(1) until vape.Loaded or vape.Loaded == nil
		if vape.Loaded and not StaffDetector.Enabled then
			StaffDetector:Toggle()
		end
	end)
end)

run(function()
	local InfiniteFly
	InfiniteFly = vape.Categories.Blatant:CreateModule({
		Name = "InfiniteFly",
		Function = function(callback)
			if callback then
				InfiniteFly:Toggle()
			end
		end,
		Tooltip = "Makes you go zoom",
		ExtraText = function()
			return "Heatseeker"
		end
	})
end)

local autobankballoon = false
run(function()
	local Fly = {Enabled = false}
	local FlyMode = {Value = "CFrame"}
	local FlyVerticalSpeed = {Value = 40}
	local FlyVertical = {Enabled = true}
	local FlyAutoPop = {Enabled = true}
	local FlyAnyway = {Enabled = false}
	local FlyAnywayProgressBar = {Enabled = false}
	local FlyDamageAnimation = {Enabled = false}
	local FlyTP = {Enabled = false}
	local FlyMobileButtons = {Enabled = false}
	local FlyAnywayProgressBarFrame
	local olddeflate
	local FlyUp = false
	local FlyDown = false
	local FlyCoroutine
	local groundtime = tick()
	local onground = false
	local lastonground = false
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	local mobileControls = {}

	local function createMobileButton(name, position, icon)
		local button = Instance.new("TextButton")
		button.Name = name
		button.Size = UDim2.new(0, 60, 0, 60)
		button.Position = position
		button.BackgroundTransparency = 0.2
		button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		button.BorderSizePixel = 0
		button.Text = icon
		button.TextScaled = true
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.Font = Enum.Font.SourceSansBold
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = button
		return button
	end

	local function cleanupMobileControls()
		for _, control in pairs(mobileControls) do
			if control then
				control:Destroy()
			end
		end
		mobileControls = {}
	end

	local function setupMobileControls()
		cleanupMobileControls()
		local gui = Instance.new("ScreenGui")
		gui.Name = "FlyControls"
		gui.ResetOnSpawn = false
		gui.Parent = lplr.PlayerGui

		local upButton = createMobileButton("UpButton", UDim2.new(0.9, -70, 0.7, -140), "↑")
		local downButton = createMobileButton("DownButton", UDim2.new(0.9, -70, 0.7, -70), "↓")

		mobileControls.UpButton = upButton
		mobileControls.DownButton = downButton
		mobileControls.ScreenGui = gui

		upButton.Parent = gui
		downButton.Parent = gui

		return upButton, downButton
	end

	local function inflateBalloon()
		if not Fly.Enabled then return end
		if entityLibrary.isAlive and (lplr.Character:GetAttribute("InflatedBalloons") or 0) < 1 then
			autobankballoon = true
			if getItem("balloon") then
				bedwars.BalloonController:inflateBalloon()
				return true
			end
		end
		return false
	end

	Fly = vape.Categories.Blatant:CreateModule({
		Name = "Fly",
		Function = function(callback)
			if callback then
				olddeflate = bedwars.BalloonController.deflateBalloon
				bedwars.BalloonController.deflateBalloon = function() end
				Fly:Clean(inputService.InputBegan:Connect(function(input1)
					if FlyVertical.Enabled and inputService:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
							FlyUp = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
							FlyDown = true
						end
					end
				end))
				Fly:Clean(inputService.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space or input1.KeyCode == Enum.KeyCode.ButtonA then
						FlyUp = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift or input1.KeyCode == Enum.KeyCode.ButtonL2 then
						FlyDown = false
					end
				end))

				local isMobile = inputService.TouchEnabled and not inputService.KeyboardEnabled and not inputService.MouseEnabled
				if FlyMobileButtons.Enabled or isMobile then
					local upButton, downButton = setupMobileControls()
					
					Fly:Clean(upButton.MouseButton1Down:Connect(function()
						if FlyVertical.Enabled then FlyUp = true end
					end))
					Fly:Clean(upButton.MouseButton1Up:Connect(function()
						FlyUp = false
					end))
					Fly:Clean(downButton.MouseButton1Down:Connect(function()
						if FlyVertical.Enabled then FlyDown = true end
					end))
					Fly:Clean(downButton.MouseButton1Up:Connect(function()
						FlyDown = false
					end))
				end

				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						Fly:Clean(jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
							if not mobileControls.UpButton then 
								FlyUp = jumpButton.ImageRectOffset.X == 146 and FlyVertical.Enabled
							end
						end))
						if not mobileControls.UpButton then
							FlyUp = jumpButton.ImageRectOffset.X == 146 and FlyVertical.Enabled
						end
					end)
				end

				Fly:Clean(vapeEvents.BalloonPopped.Event:Connect(function(poppedTable)
					if poppedTable.inflatedBalloon and poppedTable.inflatedBalloon:GetAttribute("BalloonOwner") == lplr.UserId then
						lastonground = not onground
						repeat task.wait() until (lplr.Character:GetAttribute("InflatedBalloons") or 0) <= 0 or not Fly.Enabled
						inflateBalloon()
					end
				end))
				Fly:Clean(vapeEvents.AutoBankBalloon.Event:Connect(function()
					repeat task.wait() until getItem("balloon")
					inflateBalloon()
				end))

				local balloons
				if entityLibrary.isAlive and (not store.queueType:find("mega")) then
					balloons = inflateBalloon()
				end
				local megacheck = store.queueType:find("mega") or store.queueType == "winter_event"

				task.spawn(function()
					repeat task.wait() until store.queueType ~= "bedwars_test" or (not Fly.Enabled)
					if not Fly.Enabled then return end
					megacheck = store.queueType:find("mega") or store.queueType == "winter_event"
				end)

				local flyAllowed = entityLibrary.isAlive and ((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or store.matchState == 2 or megacheck) and 1 or 0
				if flyAllowed <= 0 and shared.damageanim and (not balloons) then
					shared.damageanim()
					bedwars.SoundManager:playSound(bedwars.SoundList["DAMAGE_"..math.random(1, 3)])
				end

				if FlyAnywayProgressBarFrame and flyAllowed <= 0 and (not balloons) then
					FlyAnywayProgressBarFrame.Visible = true
					pcall(function() FlyAnywayProgressBarFrame.Frame:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true) end)
				end

				groundtime = tick() + (2.6 + (entityLibrary.groundTick - tick()))
				FlyCoroutine = coroutine.create(function()
					repeat
						repeat task.wait() until (groundtime - tick()) < 0.6 and not onground
						flyAllowed = ((lplr.Character and lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or store.matchState == 2 or megacheck) and 1 or 0
						if (not Fly.Enabled) then break end
						local Flytppos = -99999
						if flyAllowed <= 0 and FlyTP.Enabled and entityLibrary.isAlive then
							local ray = game.Workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), store.blockRaycast)
							if ray then
								Flytppos = entityLibrary.character.HumanoidRootPart.Position.Y
								local args = {entityLibrary.character.HumanoidRootPart.CFrame:GetComponents()}
								args[2] = ray.Position.Y + (entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight
								entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(unpack(args))
								task.wait(0.12)
								if (not Fly.Enabled) then break end
								flyAllowed = ((lplr.Character and lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or store.matchState == 2 or megacheck) and 1 or 0
								if flyAllowed <= 0 and Flytppos ~= -99999 and entityLibrary.isAlive then
									local args = {entityLibrary.character.HumanoidRootPart.CFrame:GetComponents()}
									args[2] = Flytppos
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(unpack(args))
								end
							end
						end
					until (not Fly.Enabled)
				end)
				coroutine.resume(FlyCoroutine)
				Fly:Clean(runservice.Heartbeat:Connect(function(delta)
					if entityLibrary.isAlive then
						local playerMass = (entityLibrary.character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						flyAllowed = ((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or store.matchState == 2 or megacheck) and 1 or 0
						playerMass = playerMass + (flyAllowed > 0 and 4 or 0) * (tick() % 0.4 < 0.2 and -1 or 1)

						if FlyAnywayProgressBarFrame then
							FlyAnywayProgressBarFrame.Visible = flyAllowed <= 0
							FlyAnywayProgressBarFrame.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
							pcall(function()
								FlyAnywayProgressBarFrame.Frame.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
							end)
						end

						if flyAllowed <= 0 then
							local newray = getPlacedBlock(entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, (entityLibrary.character.Humanoid.HipHeight * -2) - 1, 0))
							onground = newray and true or false
							if lastonground ~= onground then
								if (not onground) then
									groundtime = tick() + (2.6 + (entityLibrary.groundTick - tick()))
									if FlyAnywayProgressBarFrame then
										FlyAnywayProgressBarFrame.Frame:TweenSize(UDim2.new(0, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, groundtime - tick(), true)
									end
								else
									if FlyAnywayProgressBarFrame then
										FlyAnywayProgressBarFrame.Frame:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
									end
								end
							end
							if FlyAnywayProgressBarFrame then
								FlyAnywayProgressBarFrame.TextLabel.Text = math.max(onground and 2.5 or math.floor((groundtime - tick()) * 10) / 10, 0).."s"
							end
							lastonground = onground
						else
							onground = true
							lastonground = true
						end

						local flyVelocity = entityLibrary.character.Humanoid.MoveDirection * (FlyMode.Value == "Normal" and FlySpeed.Value or 20)
						entityLibrary.character.HumanoidRootPart.Velocity = flyVelocity + (Vector3.new(0, playerMass + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0))
						if FlyMode.Value ~= "Normal" then
							entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + (entityLibrary.character.Humanoid.MoveDirection * ((FlySpeed.Value + getSpeed()) - 20)) * delta
						end
					end
				end))
			else
				pcall(function() coroutine.close(FlyCoroutine) end)
				autobankballoon = false
				waitingforballoon = false
				lastonground = nil
				FlyUp = false
				FlyDown = false
				if FlyAnywayProgressBarFrame then
					FlyAnywayProgressBarFrame.Visible = false
				end
				if FlyAutoPop.Enabled then
					if entityLibrary.isAlive and lplr.Character:GetAttribute("InflatedBalloons") then
						for i = 1, lplr.Character:GetAttribute("InflatedBalloons") do
							olddeflate()
						end
					end
				end
				bedwars.BalloonController.deflateBalloon = olddeflate
				olddeflate = nil
				cleanupMobileControls()
			end
		end,
		Tooltip = "Makes you go zoom (longer Fly discovered by exelys and Cqded)",
		ExtraText = function()
			return "Heatseeker"
		end
	})
	FlySpeed = Fly:CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end,
		Default = 23
	})
	FlyVerticalSpeed = Fly:CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 100,
		Function = function(val) end,
		Default = 44
	})
	FlyVertical = Fly:CreateToggle({
		Name = "Y Level",
		Function = function() end,
		Default = true
	})
	FlyAutoPop = Fly:CreateToggle({
		Name = "Pop Balloon",
		Function = function() end,
		Tooltip = "Pops balloons when Fly is disabled."
	})
	FlyAnywayProgressBar = Fly:CreateToggle({
		Name = "Progress Bar",
		Function = function(callback)
			if callback then
				FlyAnywayProgressBarFrame = Instance.new("Frame")
				FlyAnywayProgressBarFrame.AnchorPoint = Vector2.new(0.5, 0)
				FlyAnywayProgressBarFrame.Position = UDim2.new(0.5, 0, 1, -200)
				FlyAnywayProgressBarFrame.Size = UDim2.new(0.2, 0, 0, 20)
				FlyAnywayProgressBarFrame.BackgroundTransparency = 0.5
				FlyAnywayProgressBarFrame.BorderSizePixel = 0
				FlyAnywayProgressBarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
				FlyAnywayProgressBarFrame.Visible = Fly.Enabled
				FlyAnywayProgressBarFrame.Parent = vape.gui
				local FlyAnywayProgressBarFrame2 = FlyAnywayProgressBarFrame:Clone()
				FlyAnywayProgressBarFrame2.AnchorPoint = Vector2.new(0, 0)
				FlyAnywayProgressBarFrame2.Position = UDim2.new(0, 0, 0, 0)
				FlyAnywayProgressBarFrame2.Size = UDim2.new(1, 0, 0, 20)
				FlyAnywayProgressBarFrame2.BackgroundTransparency = 0
				FlyAnywayProgressBarFrame2.Visible = true
				FlyAnywayProgressBarFrame2.Parent = FlyAnywayProgressBarFrame
				local FlyAnywayProgressBartext = Instance.new("TextLabel")
				FlyAnywayProgressBartext.Text = "2s"
				FlyAnywayProgressBartext.Font = Enum.Font.Gotham
				FlyAnywayProgressBartext.TextStrokeTransparency = 0
				FlyAnywayProgressBartext.TextColor3 =  Color3.new(0.9, 0.9, 0.9)
				FlyAnywayProgressBartext.TextSize = 20
				FlyAnywayProgressBartext.Size = UDim2.new(1, 0, 1, 0)
				FlyAnywayProgressBartext.BackgroundTransparency = 1
				FlyAnywayProgressBartext.Position = UDim2.new(0, 0, -1, 0)
				FlyAnywayProgressBartext.Parent = FlyAnywayProgressBarFrame
			else
				if FlyAnywayProgressBarFrame then FlyAnywayProgressBarFrame:Destroy() FlyAnywayProgressBarFrame = nil end
			end
		end,
		Tooltip = "show amount of Fly time",
		Default = true
	})
	local oldcamupdate
	local camcontrol
	local Flydamagecamera = {Enabled = false}
	FlyDamageAnimation = Fly:CreateToggle({
		Name = "Damage Animation",
		Function = function(callback)
			if Flydamagecamera.Object then
				Flydamagecamera.Object.Visible = callback
			end
			if callback then
				task.spawn(function()
					repeat
						task.wait(0.1)
						for i,v in pairs(getconnections(gameCamera:GetPropertyChangedSignal("CameraType"))) do
							if v.Function then
								camcontrol = debug.getupvalue(v.Function, 1)
							end
						end
					until camcontrol
					local caminput = require(lplr.PlayerScripts.PlayerModule.CameraModule.CameraInput)
					local num = Instance.new("IntValue")
					local numanim
					shared.damageanim = function()
						if numanim then numanim:Cancel() end
						if Flydamagecamera.Enabled then
							num.Value = 1000
							numanim = tweenService:Create(num, TweenInfo.new(0.5), {Value = 0})
							numanim:Play()
						end
					end
					oldcamupdate = camcontrol.Update
					camcontrol.Update = function(self, dt)
						if camcontrol.activeCameraController then
							camcontrol.activeCameraController:UpdateMouseBehavior()
							local newCameraCFrame, newCameraFocus = camcontrol.activeCameraController:Update(dt)
							gameCamera.CFrame = newCameraCFrame * CFrame.Angles(0, 0, math.rad(num.Value / 100))
							gameCamera.Focus = newCameraFocus
							if camcontrol.activeTransparencyController then
								camcontrol.activeTransparencyController:Update(dt)
							end
							if caminput.getInputEnabled() then
								caminput.resetInputForFrameEnd()
							end
						end
					end
				end)
			else
				shared.damageanim = nil
				if camcontrol then
					camcontrol.Update = oldcamupdate
				end
			end
		end
	})
	Flydamagecamera = Fly:CreateToggle({
		Name = "Camera Animation",
		Function = function() end,
		Default = true
	})
	Flydamagecamera.Object.BorderSizePixel = 0
	Flydamagecamera.Object.BackgroundTransparency = 0
	Flydamagecamera.Object.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Flydamagecamera.Object.Visible = false
	FlyTP = Fly:CreateToggle({
		Name = "TP Down",
		Function = function() end,
		Default = true
	})
	FlyMobileButtons = Fly:CreateToggle({
		Name = "Mobile Buttons",
		Default = false,
		Function = function(callback)
			if Fly.Enabled then
				Fly:Toggle()
				Fly:Toggle()
			end
		end
	})
end)

local killauraNearPlayer
local lplr = game:GetService("Players").LocalPlayer

local anims = {
	Normal = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.05},
		{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.05}
	},
	Slow = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.15}
	},
	New = {
		{CFrame = CFrame.new(0.69, -0.77, 1.47) * CFrame.Angles(math.rad(-33), math.rad(57), math.rad(-81)), Time = 0.12},
		{CFrame = CFrame.new(0.74, -0.92, 0.88) * CFrame.Angles(math.rad(147), math.rad(71), math.rad(53)), Time = 0.12}
	},
	Latest = {
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-51)), Time = 0.1},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-179), math.rad(54), math.rad(33)), Time = 0.1}
	},
	["Vertical Spin"] = {
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(180), math.rad(3), math.rad(13)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(-5), math.rad(8)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(-0), math.rad(-0)), Time = 0.1}
	},
	Exhibition = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
	},
	["Exhibition Old"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
		{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
	}
}

local weaplist = {
	{"rageblade", 100}, {"emerald_sword", 99}, {"deathbloom", 99},
	{"glitch_void_sword", 98}, {"sky_scythe", 98}, {"diamond_sword", 97},
	{"iron_sword", 96}, {"stone_sword", 95}, {"wood_sword", 94},
	{"emerald_dao", 93}, {"diamond_dao", 99}, {"diamond_dagger", 99},
	{"diamond_great_hammer", 99}, {"diamond_scythe", 99}, {"iron_dao", 97},
	{"iron_scythe", 97}, {"iron_dagger", 97}, {"iron_great_hammer", 97},
	{"stone_dao", 96}, {"stone_dagger", 96}, {"stone_great_hammer", 96},
	{"stone_scythe", 96}, {"wood_dao", 95}, {"wood_scythe", 95},
	{"wood_great_hammer", 95}, {"wood_dagger", 95}, {"frosty_hammer", 1}
}

local function getweapon()
	local bestrank = 0
	local inv = lplr.Character.InventoryFolder.Value
	local bestweap
	
	for _, weap in ipairs(weaplist) do
		if weap[2] > bestrank and inv:FindFirstChild(weap[1]) then
			bestweap = weap[1]
			bestrank = weap[2]
		end
	end
	return inv:FindFirstChild(bestweap)
end

local function gettargets(range, maxt, limit)
	local targets = {}
	local playerpos = lplr.Character.PrimaryPart.Position
	local playerlook = lplr.Character.PrimaryPart.CFrame.LookVector * Vector3.new(1, 0, 1)
	
	for _, plr in pairs(game.Players:GetPlayers()) do
		pcall(function()
			if plr == lplr or plr.Team == lplr.Team then return end
			if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then return end
			
			local dist = (plr.Character.PrimaryPart.Position - playerpos).Magnitude
			
			if plr.Character.Humanoid.Health > 0 and dist <= range then
				if limit then
					local delta = (plr.Character.PrimaryPart.Position - playerpos)
					local angle = math.acos(playerlook:Dot((delta * Vector3.new(1, 0, 1)).Unit))
					if angle > (math.rad(limit) / 2) then return end
				end
				
				local dat = {
					Player = plr,
					Character = plr.Character,
					Health = plr.Character.Humanoid.Health,
					MaxHealth = plr.Character.Humanoid.MaxHealth
				}
				
				table.insert(targets, dat)
			end
		end)
	end
	
	table.sort(targets, function(a, b)
		local distA = (a.Character.PrimaryPart.Position - playerpos).Magnitude
		local distB = (b.Character.PrimaryPart.Position - playerpos).Magnitude
		return distA < distB
	end)
	
	if maxt and #targets > maxt then
		for i = maxt + 1, #targets do
			targets[i] = nil
		end
	end
	
	return targets
end

local function EntityNearPosition(distance, ignore, overridepos)
	local closestEntity, closestMagnitude = nil, distance
	if entityLibrary.isAlive then
		for i, v in pairs(entitylib.List) do
			if not v.Targetable then continue end
			if not v.Humanoid then continue end
			if isVulnerable(v) then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then
					mag = (overridepos - v.RootPart.Position).magnitude
				end
				if mag <= closestMagnitude then
					closestEntity, closestMagnitude = v, mag
				end
			end
		end
		if not ignore then
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "Void Enemy Dummy" or v.Name == "Emerald Enemy Dummy" or v.Name == "Diamond Enemy Dummy" or v.Name == "Leather Enemy Dummy" or v.Name == "Regular Enemy Dummy" or v.Name == "Iron Enemy Dummy" then
					if v.PrimaryPart then
						local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
						if overridepos and mag > distance then
							mag = (overridepos - v2.PrimaryPart.Position).magnitude
						end
						if mag <= closestMagnitude then
							closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
						end
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("Monster")) do
				if v.PrimaryPart and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("GuardianOfDream")) do
				if v.PrimaryPart and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("DiamondGuardian")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "DiamondGuardian", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("GolemBoss")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "GolemBoss", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("Drone")) do
				if v.PrimaryPart and tonumber(v:GetAttribute("PlayerUserId")) ~= lplr.UserId then
					local droneplr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
					if droneplr and droneplr.Team == lplr.Team then continue end
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "Drone", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i,v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "InfectedCrateEntity" and v.ClassName == "Model" and v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "InfectedCrateEntity", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(store.pots) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "Pot", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
		end
	end
	return closestEntity
end

local killauraNearPlayer
local lplr = game:GetService("Players").LocalPlayer

local anims = {
	Normal = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.05},
		{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.05}
	},
	Slow = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.15}
	},
	New = {
		{CFrame = CFrame.new(0.69, -0.77, 1.47) * CFrame.Angles(math.rad(-33), math.rad(57), math.rad(-81)), Time = 0.12},
		{CFrame = CFrame.new(0.74, -0.92, 0.88) * CFrame.Angles(math.rad(147), math.rad(71), math.rad(53)), Time = 0.12}
	},
	Latest = {
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-51)), Time = 0.1},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-179), math.rad(54), math.rad(33)), Time = 0.1}
	},
	["Vertical Spin"] = {
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(180), math.rad(3), math.rad(13)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(-5), math.rad(8)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(-0), math.rad(-0)), Time = 0.1}
	},
	Exhibition = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
	},
	["Exhibition Old"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
		{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
	}
}

local weaplist = {
	{"rageblade", 100}, {"emerald_sword", 99}, {"deathbloom", 99},
	{"glitch_void_sword", 98}, {"sky_scythe", 98}, {"diamond_sword", 97},
	{"iron_sword", 96}, {"stone_sword", 95}, {"wood_sword", 94},
	{"emerald_dao", 93}, {"diamond_dao", 99}, {"diamond_dagger", 99},
	{"diamond_great_hammer", 99}, {"diamond_scythe", 99}, {"iron_dao", 97},
	{"iron_scythe", 97}, {"iron_dagger", 97}, {"iron_great_hammer", 97},
	{"stone_dao", 96}, {"stone_dagger", 96}, {"stone_great_hammer", 96},
	{"stone_scythe", 96}, {"wood_dao", 95}, {"wood_scythe", 95},
	{"wood_great_hammer", 95}, {"wood_dagger", 95}, {"frosty_hammer", 1}
}

local function getweapon()
	local bestrank = 0
	local inv = lplr.Character.InventoryFolder.Value
	local bestweap
	
	for _, weap in ipairs(weaplist) do
		if weap[2] > bestrank and inv:FindFirstChild(weap[1]) then
			bestweap = weap[1]
			bestrank = weap[2]
		end
	end
	return inv:FindFirstChild(bestweap)
end

local function gettargets(range, maxt, limit)
	local targets = {}
	local playerpos = lplr.Character.PrimaryPart.Position
	local playerlook = lplr.Character.PrimaryPart.CFrame.LookVector * Vector3.new(1, 0, 1)
	
	for _, plr in pairs(game.Players:GetPlayers()) do
		pcall(function()
			if plr == lplr or plr.Team == lplr.Team then return end
			if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then return end
			
			local dist = (plr.Character.PrimaryPart.Position - playerpos).Magnitude
			
			if plr.Character.Humanoid.Health > 0 and dist <= range then
				if limit then
					local delta = (plr.Character.PrimaryPart.Position - playerpos)
					local angle = math.acos(playerlook:Dot((delta * Vector3.new(1, 0, 1)).Unit))
					if angle > (math.rad(limit) / 2) then return end
				end
				
				local dat = {
					Player = plr,
					Character = plr.Character,
					Health = plr.Character.Humanoid.Health,
					MaxHealth = plr.Character.Humanoid.MaxHealth
				}
				
				table.insert(targets, dat)
				targetinfo.Targets[dat] = tick() + 1
			end
		end)
	end
	
	table.sort(targets, function(a, b)
		local distA = (a.Character.PrimaryPart.Position - playerpos).Magnitude
		local distB = (b.Character.PrimaryPart.Position - playerpos).Magnitude
		return distA < distB
	end)
	
	if maxt and #targets > maxt then
		for i = maxt + 1, #targets do
			targets[i] = nil
		end
	end
	
	return targets
end

local RunLoops = {
    RenderStepTable = {},
    StepTable = {},
    HeartTable = {}
}

local function BindToLoop(tableName, service, name, func)
	local oldfunc = func
	func = function(delta) VoidwareFunctions.handlepcall(pcall(function() oldfunc(delta) end)) end
    if RunLoops[tableName][name] == nil then
        RunLoops[tableName][name] = service:Connect(func)
        table.insert(vapeConnections, RunLoops[tableName][name])
    end
end

local function UnbindFromLoop(tableName, name)
    if RunLoops[tableName][name] then
        RunLoops[tableName][name]:Disconnect()
        RunLoops[tableName][name] = nil
    end
end

function RunLoops:BindToRenderStep(name, func)
    BindToLoop("RenderStepTable", runService.RenderStepped, name, func)
end

function RunLoops:UnbindFromRenderStep(name)
    UnbindFromLoop("RenderStepTable", name)
end

function RunLoops:BindToStepped(name, func)
    BindToLoop("StepTable", runService.Stepped, name, func)
end

function RunLoops:UnbindFromStepped(name)
    UnbindFromLoop("StepTable", name)
end

function RunLoops:BindToHeartbeat(name, func)
    BindToLoop("HeartTable", runService.Heartbeat, name, func)
end

function RunLoops:UnbindFromHeartbeat(name)
    UnbindFromLoop("HeartTable", name)
end

local anims = {
	Normal = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.05},
		{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.05}
	},
	Slow = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.15}
	},
	New = {
		{CFrame = CFrame.new(0.69, -0.77, 1.47) * CFrame.Angles(math.rad(-33), math.rad(57), math.rad(-81)), Time = 0.12},
		{CFrame = CFrame.new(0.74, -0.92, 0.88) * CFrame.Angles(math.rad(147), math.rad(71), math.rad(53)), Time = 0.12}
	},
	Latest = {
		{CFrame = CFrame.new(0.69, -0.7, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-51)), Time = 0.1},
		{CFrame = CFrame.new(0.16, -1.16, 0.5) * CFrame.Angles(math.rad(-179), math.rad(54), math.rad(33)), Time = 0.1}
	},
	["Vertical Spin"] = {
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(180), math.rad(3), math.rad(13)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(-5), math.rad(8)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(-0), math.rad(-0)), Time = 0.1}
	},
	Exhibition = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
	},
	["Exhibition Old"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
		{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
	},
	Pulse = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.5},
		{CFrame = CFrame.new(0.69, -0.72, 0.6) * CFrame.Angles(math.rad(-20), math.rad(0), math.rad(0)), Time = 1.0},
		{CFrame = CFrame.new(0.69, -0.68, 0.6) * CFrame.Angles(math.rad(20), math.rad(0), math.rad(0)), Time = 1.5},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 2.0}
	},
	["Slowly Smooth"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.25},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.5},
		{CFrame = CFrame.new(0.150, -0.8, 0.1) * CFrame.Angles(math.rad(-45), math.rad(40), math.rad(-75)), Time = 0.75},
		{CFrame = CFrame.new(0.02, -0.8, 0.05) * CFrame.Angles(math.rad(-60), math.rad(60), math.rad(-95)), Time = 1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 1.25},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 1.5},
	},
	["Latest Remake"] = {
		{CFrame = CFrame.new(0.68, -0.72, 0.12) * CFrame.Angles(math.rad(-63), math.rad(57), math.rad(-49)), Time = 0.4},
		{CFrame = CFrame.new(0.17, -1.18, 0.52) * CFrame.Angles(math.rad(-177), math.rad(56), math.rad(31)), Time = 0.4}
	},
	["Exhibition Fast"] = {
		{CFrame = CFrame.new(0.7, -0.7, 0.6) * CFrame.Angles(math.rad(-20), math.rad(50), math.rad(-90)), Time = 0.05},
		{CFrame = CFrame.new(0.8, -0.8, 0.5) * CFrame.Angles(math.rad(-60), math.rad(60), math.rad(-80)), Time = 0.07},
	},
	["Smooth Gaming"] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.25},
		{CFrame = CFrame.new(0.68, -0.72, 0.12) * CFrame.Angles(math.rad(-63), math.rad(57), math.rad(-49)), Time = 0.4},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.6},
		{CFrame = CFrame.new(0.17, -1.18, 0.52) * CFrame.Angles(math.rad(-177), math.rad(56), math.rad(31)), Time = 0.6},
		{CFrame = CFrame.new(0.150, -0.8, 0.1) * CFrame.Angles(math.rad(-45), math.rad(40), math.rad(-75)), Time = 0.8},
		{CFrame = CFrame.new(0.02, -0.8, 0.05) * CFrame.Angles(math.rad(-60), math.rad(60), math.rad(-95)), Time = 1.0},
		{CFrame = CFrame.new(0.8, -0.8, 0.5) * CFrame.Angles(math.rad(-60), math.rad(60), math.rad(-80)), Time = 1.2},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 1.4},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 1.6}
	}	
}

local cleanTable = function(tab)
	local res = {}
	for i,v in pairs(tab) do table.insert(res, tostring(i)) end
	return res
end

local function isFirstPerson()
	if not entitylib.isAlive then return false end
	return (entitylib.character.Head.Position - gameCamera.CFrame.Position).Magnitude < 2
end

bedwars.ViewModel = workspace.CurrentCamera.Viewmodel.RightHand.RightWrist
local oldrotation = bedwars.ViewModel.C0

local originalArmC0, originalNeckC0, originalRootC0

local Attacking
local killauraNearPlayer = Attacking
run(function()
	local inputService = inputService or game:GetService("UserInputService")
	local tweenService = tweenService or game:GetService("TweenService")
	local TweenService = TweenService or tweenService
	vape.Libraries = vape.Libraries or {}
	vape.Libraries.auraanims = vape.Libraries.auraanims or {
		Normal = {
			{CFrame = CFrame.new(-0.17, -0.14, -0.12) * CFrame.Angles(math.rad(-53), math.rad(50), math.rad(-64)), Time = 0.1},
			{CFrame = CFrame.new(-0.55, -0.59, -0.1) * CFrame.Angles(math.rad(-161), math.rad(54), math.rad(-6)), Time = 0.08},
			{CFrame = CFrame.new(-0.62, -0.68, -0.07) * CFrame.Angles(math.rad(-167), math.rad(47), math.rad(-1)), Time = 0.03},
			{CFrame = CFrame.new(-0.56, -0.86, 0.23) * CFrame.Angles(math.rad(-167), math.rad(49), math.rad(-1)), Time = 0.03}
		},
		Random = {},
		['Horizontal Spin'] = {
			{CFrame = CFrame.Angles(math.rad(-10), math.rad(-90), math.rad(-80)), Time = 0.12},
			{CFrame = CFrame.Angles(math.rad(-10), math.rad(180), math.rad(-80)), Time = 0.12},
			{CFrame = CFrame.Angles(math.rad(-10), math.rad(90), math.rad(-80)), Time = 0.12},
			{CFrame = CFrame.Angles(math.rad(-10), 0, math.rad(-80)), Time = 0.12}
		},
		['Vertical Spin'] = {
			{CFrame = CFrame.Angles(math.rad(-90), 0, math.rad(15)), Time = 0.12},
			{CFrame = CFrame.Angles(math.rad(180), 0, math.rad(15)), Time = 0.12},
			{CFrame = CFrame.Angles(math.rad(90), 0, math.rad(15)), Time = 0.12},
			{CFrame = CFrame.Angles(0, 0, math.rad(15)), Time = 0.12}
		},
		Exhibition = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
		},
		['Exhibition Old'] = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
			{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
			{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
		}
	}
	local Killaura
	local Targets
	local Sort
	local Range
	local RangeCircle
	local RangeCirclePart
	local UpdateRate
	local AngleSlider
	local MaxTargets
	local Mouse
	local Swing
	local GUI
	local BoxColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local Face
	local Animation
	local AnimationMode
	local AnimationSpeed
	local AnimationTween
	local Limit
	local LegitAura
	local Sync
	local Particles, Boxes = {}, {}
	local anims, AnimDelay, AnimTween, armC0 = vape.Libraries.auraanims, tick()
	local AttackRemote = {FireServer = function() end}
	task.spawn(function()
		AttackRemote = bedwars.Client:Get(bedwars.AttackRemote)
	end)

	local function createRangeCircle()
		local suc, err = pcall(function()
			if (not shared.CheatEngineMode) then
				RangeCirclePart = Instance.new("MeshPart")
				RangeCirclePart.MeshId = "rbxassetid://3726303797"
				if shared.RiseMode and GuiLibrary.GUICoreColor and GuiLibrary.GUICoreColorChanged then
					RangeCirclePart.Color = GuiLibrary.GUICoreColor
					GuiLibrary.GUICoreColorChanged.Event:Connect(function()
						RangeCirclePart.Color = GuiLibrary.GUICoreColor
					end)
				else
					RangeCirclePart.Color = Color3.fromHSV(BoxColor["Hue"], BoxColor["Sat"], BoxColor.Value)
				end
				RangeCirclePart.CanCollide = false
				RangeCirclePart.Anchored = true
				RangeCirclePart.Material = Enum.Material.Neon
				RangeCirclePart.Size = Vector3.new(Range.Value * 0.7, 0.01, Range.Value * 0.7)
				if Killaura.Enabled then
					RangeCirclePart.Parent = gameCamera
				end
				RangeCirclePart:SetAttribute("gamecore_GameQueryIgnore", true)
			end
		end)
		if (not suc) then
			pcall(function()
				if RangeCirclePart then
					RangeCirclePart:Destroy()
					RangeCirclePart = nil
				end
				InfoNotification("Killaura - Range Visualiser Circle", "There was an error creating the circle. Disabling...", 2)
			end)
		end
	end

	local function getAttackData()
		if Mouse.Enabled then
			if not inputService:IsMouseButtonPressed(0) then return false end
		end

		if GUI.Enabled then
			--if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then return false end
		end

		local sword = Limit.Enabled and store.localHand or getSword()
		if not sword or not sword.tool then return false end

		local meta = bedwars.ItemTable[sword.tool.Name]
		if Limit.Enabled then
			if store.localHand.Type ~= 'sword' or bedwars.DaoController.chargingMaid then return false end
		end

		if LegitAura.Enabled then
			if (tick() - bedwars.SwordController.lastSwing) > 0.1 then return false end
		end

		return sword, meta
	end

	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				if RangeCircle.Enabled then
					createRangeCircle()
				end
				if inputService.TouchEnabled then
					pcall(function()
						lplr.PlayerGui.MobileUI['2'].Visible = Limit.Enabled
					end)
				end

				if Animation.Enabled and not (identifyexecutor and table.find({'Argon', 'Delta'}, ({identifyexecutor()})[1])) then
					local fake = {
						Controllers = {
							ViewmodelController = {
								isVisible = function()
									return not Attacking
								end,
								playAnimation = function(...)
									local args = {...}
									if not Attacking then
										pcall(function()
											bedwars.ViewmodelController:playAnimation(select(2, unpack(args)))
										end)
									end
								end
							}
						}
					}
					--debug.setupvalue(bedwars.SwordController.playSwordEffect, 6, fake)
					--debug.setupvalue(bedwars.ScytheController.playLocalAnimation, 3, fake)

					task.spawn(function()
						local started = false
						repeat
							if Attacking then
								if not armC0 then
									armC0 = gameCamera.Viewmodel.RightHand.RightWrist.C0
								end
								local first = not started
								started = true

								if AnimationMode.Value == 'Random' then
									anims.Random = {{CFrame = CFrame.Angles(math.rad(math.random(1, 360)), math.rad(math.random(1, 360)), math.rad(math.random(1, 360))), Time = 0.12}}
								end

								for _, v in anims[AnimationMode.Value] do
									AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(first and (AnimationTween.Enabled and 0.001 or 0.1) or v.Time / AnimationSpeed.Value, Enum.EasingStyle.Linear), {
										C0 = armC0 * v.CFrame
									})
									AnimTween:Play()
									AnimTween.Completed:Wait()
									first = false
									if (not Killaura.Enabled) or (not Attacking) then break end
								end
							elseif started then
								started = false
								AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
									C0 = armC0
								})
								AnimTween:Play()
							end

							if not started then
								task.wait(1 / UpdateRate.Value)
							end
						until (not Killaura.Enabled) or (not Animation.Enabled)
					end)
				end

				repeat
					pcall(function()
						if entitylib.isAlive and entitylib.character.HumanoidRootPart then
							TweenService:Create(RangeCirclePart, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = entitylib.character.HumanoidRootPart.Position - Vector3.new(0, entitylib.character.Humanoid.HipHeight, 0)}):Play()
						end
					end)
					local attacked, sword, meta = {}, getAttackData()
					Attacking = false
					killauraNearPlayer = Attacking
					store.KillauraTarget = nil
					pcall(function() vapeTargetInfo.Targets.Killaura = nil end)
					if sword then
						local isClaw = string.find(string.lower(tostring(sword and sword.itemType or "")), "summoner_claw")
						local plrs = entitylib.AllPosition({
							Range = Range.Value,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Limit = MaxTargets.Value,
							Sort = sortmethods[Sort.Value]
						})
						if #plrs > 0 then
							switchItem(sword.tool, 0)
							local selfpos = entitylib.character.RootPart.Position
							local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

							for _, v in plrs do
								if Targets.Walls.Enabled then
									if not Wallcheck(lplr.Character, v.Character) then continue end
								end
								local delta = (v.RootPart.Position - selfpos)
								local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
								if angle > (math.rad(AngleSlider.Value) / 2) then continue end

								table.insert(attacked, v)
								targetinfo.Targets[v] = tick() + 1
								pcall(function()
									local plr = v
									vapeTargetInfo.Targets.Killaura = {
										Humanoid = {
											Health = (plr.Character:GetAttribute("Health") or plr.Humanoid.Health) + getShieldAttribute(plr.Character),
											MaxHealth = plr.Character:GetAttribute("MaxHealth") or plr.Humanoid.MaxHealth
										},
										Player = plr.Player
									}
								end)
								if not Attacking then
									Attacking = true
									killauraNearPlayer = Attacking
									store.KillauraTarget = v
									if not isClaw then
										if not Swing.Enabled and AnimDelay <= tick() and not LegitAura.Enabled then
											AnimDelay = tick() + (meta.sword.respectAttackSpeedForEffects and meta.sword.attackSpeed or (Sync.Enabled and 0.24 or 0.14))
											bedwars.SwordController:playSwordEffect(meta, 0)
											if meta.displayName:find(' Scythe') then
												bedwars.ScytheController:playLocalAnimation()
											end
	
											if vape.ThreadFix then
												setthreadidentity(8)
											end
										end
									end
								end
								
								local actualRoot = v.Character.PrimaryPart
								if actualRoot then
									local dir = CFrame.lookAt(selfpos, actualRoot.Position).LookVector
									local pos = selfpos + dir * math.max(delta.Magnitude - 14.399, 0)
									bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
									bedwars.SwordController.lastSwing = tick()
									store.attackReach = (delta.Magnitude * 100) // 1 / 100
									store.attackReachUpdate = tick() + 1
									if isClaw then
										bedwars.KaidaController:request(v.Character)
									else
										AttackRemote:FireServer({
											weapon = sword.tool,
											chargedAttack = {chargeRatio = meta.sword.chargedAttack and not meta.sword.chargedAttack.disableOnGrounded and 0.999 or 0},
											entityInstance = v.Character,
											validate = {
												raycast = {
													cameraPosition = {value = pos},
													cursorDirection = {value = dir}
												},
												targetPosition = {value = actualRoot.Position},
												selfPosition = {value = pos}
											}
										})
									end
								end
							end
						end
					end

					for i, v in Boxes do
						v.Adornee = attacked[i] and attacked[i].RootPart or nil
						if v.Adornee then
							v.Color3 = Color3.fromHSV(BoxColor.Hue, BoxColor.Sat, BoxColor.Value)
							v.Transparency = 1 - BoxColor.Opacity
						end
					end

					for i, v in Particles do
						v.Position = attacked[i] and attacked[i].RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
						v.Parent = attacked[i] and gameCamera or nil
					end

					if Face.Enabled and attacked[1] then
						local vec = attacked[1].RootPart.Position * Vector3.new(1, 0, 1)
						entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(vec.X, entitylib.character.RootPart.Position.Y + 0.001, vec.Z))
					end
					pcall(function() if RangeCirclePart ~= nil then RangeCirclePart.Parent = gameCamera end end)

					task.wait(#attacked > 0 and #attacked * 0.02 or 1 / UpdateRate.Value)
				until not Killaura.Enabled
			else
				store.KillauraTarget = nil
				for _, v in Boxes do
					v.Adornee = nil
				end
				for _, v in Particles do
					v.Parent = nil
				end
				if inputService.TouchEnabled then
					pcall(function()
						lplr.PlayerGui.MobileUI['2'].Visible = true
					end)
				end
				--debug.setupvalue(bedwars.SwordController.playSwordEffect, 6, bedwars.Knit)
				--debug.setupvalue(bedwars.ScytheController.playLocalAnimation, 3, bedwars.Knit)
				Attacking = false
				killauraNearPlayer = Attacking
				if armC0 then
					AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
						C0 = armC0
					})
					AnimTween:Play()
				end
				if RangeCirclePart ~= nil then RangeCirclePart:Destroy() end
			end
		end,
		Tooltip = 'Attack players around you\nwithout aiming at them.'
	})
	Targets = Killaura:CreateTargets({
		Players = true,
		NPCs = true
	})
	local methods = {'Damage', 'Distance'}
	for i in sortmethods do
		if not table.find(methods, i) then
			table.insert(methods, i)
		end
	end
	Range = Killaura:CreateSlider({
		Name = 'Attack range',
		Min = 1,
		Max = 18,
		Default = 18,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	RangeCircle = Killaura:CreateToggle({
		Name = "Range Visualiser",
		Function = function(call)
			if call then
				createRangeCircle()
			else
				if RangeCirclePart then
					RangeCirclePart:Destroy()
					RangeCirclePart = nil
				end
			end
		end
	})
	AngleSlider = Killaura:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 360
	})
	UpdateRate = Killaura:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Suffix = 'hz'
	})
	MaxTargets = Killaura:CreateSlider({
		Name = 'Max targets',
		Min = 1,
		Max = 5,
		Default = 5
	})
	Sort = Killaura:CreateDropdown({
		Name = 'Target Mode',
		List = methods
	})
	Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
	Swing = Killaura:CreateToggle({Name = 'No Swing'})
	GUI = Killaura:CreateToggle({Name = 'GUI check'})
	Killaura:CreateToggle({
		Name = 'Show target',
		Function = function(callback)
			BoxColor.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local box = Instance.new('BoxHandleAdornment')
					box.Adornee = nil
					box.AlwaysOnTop = true
					box.Size = Vector3.new(3, 5, 3)
					box.CFrame = CFrame.new(0, -0.5, 0)
					box.ZIndex = 0
					box.Parent = vape.gui
					Boxes[i] = box
				end
			else
				for _, v in Boxes do
					v:Destroy()
				end
				table.clear(Boxes)
			end
		end
	})
	BoxColor = Killaura:CreateColorSlider({
		Name = 'Attack Color',
		Darker = true,
		DefaultOpacity = 0.5,
		Visible = false,
		Function = function(hue, sat, val)
			if Killaura.Enabled and RangeCirclePart ~= nil then
				RangeCirclePart.Color = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	Killaura:CreateToggle({
		Name = 'Target particles',
		Function = function(callback)
			ParticleTexture.Object.Visible = callback
			ParticleColor1.Object.Visible = callback
			ParticleColor2.Object.Visible = callback
			ParticleSize.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local part = Instance.new('Part')
					part.Size = Vector3.new(2, 4, 2)
					part.Anchored = true
					part.CanCollide = false
					part.Transparency = 1
					part.CanQuery = false
					part.Parent = Killaura.Enabled and gameCamera or nil
					local particles = Instance.new('ParticleEmitter')
					particles.Brightness = 1.5
					particles.Size = NumberSequence.new(ParticleSize.Value)
					particles.Shape = Enum.ParticleEmitterShape.Sphere
					particles.Texture = ParticleTexture.Value
					particles.Transparency = NumberSequence.new(0)
					particles.Lifetime = NumberRange.new(0.4)
					particles.Speed = NumberRange.new(16)
					particles.Rate = 128
					particles.Drag = 16
					particles.ShapePartial = 1
					particles.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
					})
					particles.Parent = part
					Particles[i] = part
				end
			else
				for _, v in Particles do
					v:Destroy()
				end
				table.clear(Particles)
			end
		end
	})
	ParticleTexture = Killaura:CreateTextBox({
		Name = 'Texture',
		Default = 'rbxassetid://14736249347',
		Function = function()
			for _, v in Particles do
				v.ParticleEmitter.Texture = ParticleTexture.Value
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor1 = Killaura:CreateColorSlider({
		Name = 'Color Begin',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor2 = Killaura:CreateColorSlider({
		Name = 'Color End',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, val))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleSize = Killaura:CreateSlider({
		Name = 'Size',
		Min = 0,
		Max = 1,
		Default = 0.2,
		Decimal = 100,
		Function = function(val)
			for _, v in Particles do
				v.ParticleEmitter.Size = NumberSequence.new(val)
			end
		end,
		Darker = true,
		Visible = false
	})
	Face = Killaura:CreateToggle({Name = 'Face target'})
	Animation = Killaura:CreateToggle({
		Name = 'Custom Animation',
		Function = function(callback)
			AnimationMode.Object.Visible = callback
			AnimationTween.Object.Visible = callback
			AnimationSpeed.Object.Visible = callback
			if Killaura.Enabled then
				Killaura:Toggle()
				Killaura:Toggle()
			end
		end
	})
	local animnames = {}
	for i in anims do
		table.insert(animnames, i)
	end
	AnimationMode = Killaura:CreateDropdown({
		Name = 'Animation Mode',
		List = animnames,
		Darker = true,
		Visible = false
	})
	AnimationSpeed = Killaura:CreateSlider({
		Name = 'Animation Speed',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10,
		Darker = true,
		Visible = false
	})
	AnimationTween = Killaura:CreateToggle({
		Name = 'No Tween',
		Darker = true,
		Visible = false
	})
	Limit = Killaura:CreateToggle({
		Name = 'Limit to items',
		Function = function(callback)
			if inputService.TouchEnabled and Killaura.Enabled then
				pcall(function()
					lplr.PlayerGui.MobileUI['2'].Visible = callback
				end)
			end
		end,
		Tooltip = 'Only attacks when the sword is held'
	})
	LegitAura = Killaura:CreateToggle({
		Name = 'Swing only',
		Tooltip = 'Only attacks while swinging manually'
	})
	Sync = Killaura:CreateToggle({
		Name = 'Synced Animation',
		Tooltip = 'Plays animation with hit attempt'
	})
end)

local LongJump = {Enabled = false}
run(function()
	local damagetimer = 0
	local damagetimertick = 0
	local directionvec
	local LongJumpSpeed = {Value = 1.5}
	local projectileRemote = bedwars.Client:Get(bedwars.ProjectileRemote)

	local function calculatepos(vec)
		local returned = vec
		if entityLibrary.isAlive then
			local newray = game.Workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, returned, store.blockRaycast)
			if newray then returned = (newray.Position - entityLibrary.character.HumanoidRootPart.Position) end
		end
		return returned
	end

	local damagemethods = {
		--[[fireball = function(fireball, pos)
			if not LongJump.Enabled then return end
			pos = pos - (entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 0.2)
			if not (getPlacedBlock(pos - Vector3.new(0, 3, 0)) or getPlacedBlock(pos - Vector3.new(0, 6, 0))) then
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://4809574295"
				sound.Parent = game.Workspace
				sound.Ended:Connect(function()
					sound:Destroy()
				end)
				sound:Play()
			end
			local origpos = pos
			local offsetshootpos = (CFrame.new(pos, pos + Vector3.new(0, -60, 0)) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).p
			local ray = game.Workspace:Raycast(pos, Vector3.new(0, -30, 0), store.blockRaycast)
			if ray then
				pos = ray.Position
				offsetshootpos = pos
			end
			task.spawn(function()
				switchItem(fireball.tool)
				bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta.fireball, "fireball", "fireball", offsetshootpos, "", Vector3.new(0, -60, 0), {drawDurationSeconds = 1})
				projectileRemote:InvokeServer(fireball.tool, "fireball", "fireball", offsetshootpos, pos, Vector3.new(0, -60, 0), game:GetService("HttpService"):GenerateGUID(true), {drawDurationSeconds = 1}, game.Workspace:GetServerTimeNow() - 0.045)
			end)
		end,--]]
		tnt = function(tnt, pos2)
			if not LongJump.Enabled then return end
			local pos = Vector3.new(pos2.X, getScaffold(Vector3.new(0, pos2.Y - (((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight) - 1.5), 0)).Y, pos2.Z)
			local block = bedwars.placeBlock(pos, "tnt")
		end,
		cannon = function(tnt, pos2)
			task.spawn(function()
				local pos = Vector3.new(pos2.X, getScaffold(Vector3.new(0, pos2.Y - (((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight) - 1.5), 0)).Y, pos2.Z)
				local block = bedwars.placeBlock(pos, "cannon")
				task.delay(0.1, function()
					local block, pos2 = getPlacedBlock(pos)
					if block and block.Name == "cannon" and (entityLibrary.character.HumanoidRootPart.CFrame.p - block.Position).Magnitude < 20 then
						switchToAndUseTool(block)
						local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
						local damage = bedwars.BlockController:calculateBlockDamage(lplr, {
							blockPosition = pos2,
							block = block
						})
						bedwars.Client:Get(bedwars.CannonAimRemote):FireServer({
							cannonBlockPos = pos2,
							lookVector = vec
						})
						local broken = 0.1
						if damage < block:GetAttribute("Health") then
							task.spawn(function()
								broken = 0.4
								bedwars.breakBlock(block)
							end)
						end
						task.delay(broken, function()
							for i = 1, 3 do
								local call = bedwars.Client:Get(bedwars.CannonLaunchRemote):InvokeServer({cannonBlockPos = bedwars.BlockController:getBlockPosition(block)})
								if call then
									bedwars.breakBlock(block)
									task.delay(0.1, function()
										damagetimer = LongJumpSpeed.Value * 5
										damagetimertick = tick() + 2.5
										directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
									end)
									break
								end
								task.wait(0.1)
							end
						end)
					end
				end)
			end)
		end,
		wood_dao = function(tnt, pos2)
			task.spawn(function()
				switchItem(tnt.tool)
				if not (not lplr.Character:GetAttribute("CanDashNext") or lplr.Character:GetAttribute("CanDashNext") < game.Workspace:GetServerTimeNow()) then
					repeat task.wait() until (not lplr.Character:GetAttribute("CanDashNext") or lplr.Character:GetAttribute("CanDashNext") < game.Workspace:GetServerTimeNow()) or not LongJump.Enabled
				end
				if LongJump.Enabled then
					local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
					replicatedStorage["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer("dash", {
						direction = vec,
						origin = entityLibrary.character.HumanoidRootPart.CFrame.p,
						weapon = tnt.itemType
					})
					damagetimer = LongJumpSpeed.Value * 3.5
					damagetimertick = tick() + 2.5
					directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
				end
			end)
		end,
		jade_hammer = function(tnt, pos2)
			task.spawn(function()
				if not bedwars.AbilityController:canUseAbility("jade_hammer_jump") then
					repeat task.wait() until bedwars.AbilityController:canUseAbility("jade_hammer_jump") or not LongJump.Enabled
					task.wait(0.1)
				end
				if bedwars.AbilityController:canUseAbility("jade_hammer_jump") and LongJump.Enabled then
					bedwars.AbilityController:useAbility("jade_hammer_jump")
					local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
					damagetimer = LongJumpSpeed.Value * 2.75
					damagetimertick = tick() + 2.5
					directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
				end
			end)
		end,
		void_axe = function(tnt, pos2)
			task.spawn(function()
				if not bedwars.AbilityController:canUseAbility("void_axe_jump") then
					repeat task.wait() until bedwars.AbilityController:canUseAbility("void_axe_jump") or not LongJump.Enabled
					task.wait(0.1)
				end
				if bedwars.AbilityController:canUseAbility("void_axe_jump") and LongJump.Enabled then
					bedwars.AbilityController:useAbility("void_axe_jump")
					local vec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
					damagetimer = LongJumpSpeed.Value * 2.75
					damagetimertick = tick() + 2.5
					directionvec = Vector3.new(vec.X, 0, vec.Z).Unit
				end
			end)
		end
	}
	damagemethods.stone_dao = damagemethods.wood_dao
	damagemethods.iron_dao = damagemethods.wood_dao
	damagemethods.diamond_dao = damagemethods.wood_dao
	damagemethods.emerald_dao = damagemethods.wood_dao

	local oldgrav
	local LongJumpacprogressbarframe = Instance.new("Frame")
	LongJumpacprogressbarframe.AnchorPoint = Vector2.new(0.5, 0)
	LongJumpacprogressbarframe.Position = UDim2.new(0.5, 0, 1, -200)
	LongJumpacprogressbarframe.Size = UDim2.new(0.2, 0, 0, 20)
	LongJumpacprogressbarframe.BackgroundTransparency = 0.5
	LongJumpacprogressbarframe.BorderSizePixel = 0
	LongJumpacprogressbarframe.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
	LongJumpacprogressbarframe.Visible = LongJump.Enabled
	LongJumpacprogressbarframe.Parent = vape.gui
	local LongJumpacprogressbarframe2 = LongJumpacprogressbarframe:Clone()
	LongJumpacprogressbarframe2.AnchorPoint = Vector2.new(0, 0)
	LongJumpacprogressbarframe2.Position = UDim2.new(0, 0, 0, 0)
	LongJumpacprogressbarframe2.Size = UDim2.new(1, 0, 0, 20)
	LongJumpacprogressbarframe2.BackgroundTransparency = 0
	LongJumpacprogressbarframe2.Visible = true
	LongJumpacprogressbarframe2.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
	LongJumpacprogressbarframe2.Parent = LongJumpacprogressbarframe
	local LongJumpacprogressbartext = Instance.new("TextLabel")
	LongJumpacprogressbartext.Text = "2.5s"
	LongJumpacprogressbartext.Font = Enum.Font.Gotham
	LongJumpacprogressbartext.TextStrokeTransparency = 0
	LongJumpacprogressbartext.TextColor3 =  Color3.new(0.9, 0.9, 0.9)
	LongJumpacprogressbartext.TextSize = 20
	LongJumpacprogressbartext.Size = UDim2.new(1, 0, 1, 0)
	LongJumpacprogressbartext.BackgroundTransparency = 1
	LongJumpacprogressbartext.Position = UDim2.new(0, 0, -1, 0)
	LongJumpacprogressbartext.Parent = LongJumpacprogressbarframe
	LongJump = vape.Categories.Blatant:CreateModule({
		Name = "LongJump",
		Function = function(callback)
			if callback then
				LongJump:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
					if damageTable.entityInstance == lplr.Character and (not damageTable.knockbackMultiplier or not damageTable.knockbackMultiplier.disabled) then
						local knockbackBoost = damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal and damageTable.knockbackMultiplier.horizontal * LongJumpSpeed.Value or LongJumpSpeed.Value
						if damagetimertick < tick() or knockbackBoost >= damagetimer then
							damagetimer = knockbackBoost
							damagetimertick = tick() + 2.5
							local newDirection = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
							directionvec = Vector3.new(newDirection.X, 0, newDirection.Z).Unit
						end
					end
				end))
				task.spawn(function()
					task.spawn(function()
						repeat
							task.wait()
							if LongJumpacprogressbarframe then
								LongJumpacprogressbarframe.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
								LongJumpacprogressbarframe2.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
							end
						until (not LongJump.Enabled)
					end)
					local LongJumpOrigin = entityLibrary.isAlive and entityLibrary.character.HumanoidRootPart.Position
					local tntcheck
					for i,v in pairs(damagemethods) do
						local item = getItem(i)
						if item then
							if i == "tnt" then
								local pos = getScaffold(LongJumpOrigin)
								tntcheck = Vector3.new(pos.X, LongJumpOrigin.Y, pos.Z)
								v(item, pos)
							else
								v(item, LongJumpOrigin)
							end
							break
						end
					end
					local changecheck
					LongJumpacprogressbarframe.Visible = true
					LongJump:Clean(runservice.Heartbeat:Connect(function(dt)
						if entityLibrary.isAlive then
							if entityLibrary.character.Humanoid.Health <= 0 then
								LongJump:Toggle(false)
								return
							end
							if not LongJumpOrigin then
								LongJumpOrigin = entityLibrary.character.HumanoidRootPart.Position
							end
							local newval = damagetimer ~= 0
							if changecheck ~= newval then
								if newval then
									LongJumpacprogressbarframe2:TweenSize(UDim2.new(0, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 2.5, true)
								else
									LongJumpacprogressbarframe2:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
								end
								changecheck = newval
							end
							if newval then
								local newnum = math.max(math.floor((damagetimertick - tick()) * 10) / 10, 0)
								if LongJumpacprogressbartext then
									LongJumpacprogressbartext.Text = newnum.."s"
								end
								if directionvec == nil then
									directionvec = entityLibrary.character.HumanoidRootPart.CFrame.lookVector
								end
								local longJumpCFrame = Vector3.new(directionvec.X, 0, directionvec.Z)
								local newvelo = longJumpCFrame.Unit == longJumpCFrame.Unit and longJumpCFrame.Unit * (newnum > 1 and damagetimer or 20) or Vector3.zero
								newvelo = Vector3.new(newvelo.X, 0, newvelo.Z)
								longJumpCFrame = longJumpCFrame * (getSpeed() + 3) * dt
								local ray = game.Workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, longJumpCFrame, store.blockRaycast)
								if ray then
									longJumpCFrame = Vector3.zero
									newvelo = Vector3.zero
								end

								entityLibrary.character.HumanoidRootPart.Velocity = newvelo
								entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + longJumpCFrame
							else
								LongJumpacprogressbartext.Text = "2.5s"
								entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(LongJumpOrigin, LongJumpOrigin + entityLibrary.character.HumanoidRootPart.CFrame.lookVector)
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								if tntcheck then
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(tntcheck + entityLibrary.character.HumanoidRootPart.CFrame.lookVector, tntcheck + (entityLibrary.character.HumanoidRootPart.CFrame.lookVector * 2))
								end
							end
						else
							if LongJumpacprogressbartext then
								LongJumpacprogressbartext.Text = "2.5s"
							end
							LongJumpOrigin = nil
							tntcheck = nil
						end
					end))
				end)
			else
				LongJumpacprogressbarframe.Visible = false
				directionvec = nil
				tntcheck = nil
				LongJumpOrigin = nil
				damagetimer = 0
				damagetimertick = 0
			end
		end,
		Tooltip = "Lets you jump farther (Not landing on same level & Spamming can lead to lagbacks)"
	})
	LongJumpSpeed = LongJump:CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 52,
		Function = function() end,
		Default = 52
	})
end)

local vapeConnections = {}

local runService = game:GetService("RunService")

local RunLoops = {
    RenderStepTable = {},
    StepTable = {},
    HeartTable = {}
}

local function BindToLoop(tableName, service, name, func)
	local oldfunc = func
	func = function(delta) VoidwareFunctions.handlepcall(pcall(function() oldfunc(delta) end)) end
    if RunLoops[tableName][name] == nil then
        RunLoops[tableName][name] = service:Connect(func)
        table.insert(vapeConnections, RunLoops[tableName][name])
    end
end

local function UnbindFromLoop(tableName, name)
    if RunLoops[tableName][name] then
        RunLoops[tableName][name]:Disconnect()
        RunLoops[tableName][name] = nil
    end
end

function RunLoops:BindToRenderStep(name, func)
    BindToLoop("RenderStepTable", runService.RenderStepped, name, func)
end

function RunLoops:UnbindFromRenderStep(name)
    UnbindFromLoop("RenderStepTable", name)
end

function RunLoops:BindToStepped(name, func)
    BindToLoop("StepTable", runService.Stepped, name, func)
end

function RunLoops:UnbindFromStepped(name)
    UnbindFromLoop("StepTable", name)
end

function RunLoops:BindToHeartbeat(name, func)
    BindToLoop("HeartTable", runService.Heartbeat, name, func)
end

function RunLoops:UnbindFromHeartbeat(name)
    UnbindFromLoop("HeartTable", name)
end

run(function()
    local NoFall = {}
	local MitigationChoice = {Value = "VelocityClamp"}
	local RishThreshold = {Value = 30}
    local PredictiveAnalysis = {}
    local MitigationStrategies = {}
    local velocityHistory = {}
    local maxHistory = 10
    
    local function recordVelocity()
        if not entitylib.isAlive or not entitylib.character or not entitylib.character.RootPart then return end
        local velocity = entitylib.character.RootPart.Velocity
        table.insert(velocityHistory, velocity.Y)
        if #velocityHistory > maxHistory then
            table.remove(velocityHistory, 1)
        end
    end
    
    local function analyzeFallRisk()
        if #velocityHistory < maxHistory then return 0 end
        local downwardTrend = 0
        for i = 2, #velocityHistory do
            if velocityHistory[i] < velocityHistory[i - 1] and velocityHistory[i] < 0 then
                downwardTrend = downwardTrend + (velocityHistory[i - 1] - velocityHistory[i])
            end
        end
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {lplr.Character}
        local rootPos = entitylib.character.RootPart.Position
        local rayResult = workspace:Raycast(rootPos, Vector3.new(0, -50, 0), raycastParams)
        local distanceToGround = rayResult and (rootPos.Y - rayResult.Position.Y) or math.huge
        local riskFactor = downwardTrend * (distanceToGround > 10 and 1.5 or 1)
        return riskFactor, distanceToGround
    end
    
    local function hasMitigationItem()
        for _, item in pairs(store.localInventory.inventory.items) do
			if item and item.itemType and string.find(string.lower(tostring(item.itemType)), 'wool') then 
				return item
			end
        end
        return nil
    end
    
    MitigationStrategies.VelocityClamp = function(risk)
        if not entitylib.isAlive or not entitylib.character or not entitylib.character.RootPart then return end
        local root = entitylib.character.RootPart
        local currentVelocity = root.Velocity
        if currentVelocity.Y < -50 then
            root.Velocity = Vector3.new(currentVelocity.X, math.clamp(currentVelocity.Y, -50, math.huge), currentVelocity.Z)
        end
    end
    
    MitigationStrategies.TeleportBuffer = function(distance)
        if not entitylib.isAlive or not entitylib.character or not entitylib.character.RootPart then return end
        local root = entitylib.character.RootPart
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {lplr.Character}
        local rayResult = workspace:Raycast(root.Position, Vector3.new(0, -distance - 2, 0), raycastParams)
        if rayResult and distance > 10 then
            local safePos = rayResult.Position + Vector3.new(0, 3, 0)
            pcall(function()
                root.CFrame = CFrame.new(safePos)
            end)
        end
    end
    
    MitigationStrategies.ItemDeploy = function(item)
        if not item then return end
        local root = entitylib.character.RootPart
        local belowPos = root.Position - Vector3.new(0, 3, 0)
        bedwars.placeBlock(belowPos, item.itemType, true)
    end
    
    NoFall = vape.Categories.Utility:CreateModule({
        Name = 'NoFall',
        Function = function(callback)
            if callback then
                RunLoops:BindToHeartbeat('NoFallMonitor', function()
                    recordVelocity()
                    local risk, distance = analyzeFallRisk()
                    if risk > RishThreshold.Value then
						if MitigationChoice.Value ~= "ItemDeploy" then
							MitigationStrategies[MitigationChoice.Value](MitigationChoice.Value == "VelocityClamp" and risk or MitigationChoice.Value == "TeleportBuffer" and distance)
						else
							local mitigationItem = hasMitigationItem()
							if mitigationItem then
								if distance < 10 then
									MitigationStrategies.ItemDeploy(mitigationItem)
								end
							else
								warningNotification("NoFall", "Mitigation Item not found. Using VelocityClamp instead...", 3)
								MitigationStrategies.VelocityClamp(risk)
							end
						end
                    end
                end)
            else
                RunLoops:UnbindFromHeartbeat('NoFallMonitor')
                table.clear(velocityHistory)
            end
        end,
        Tooltip = 'Prevents fall damage'
    })

	RishThreshold = NoFall:CreateSlider({
		Name = "Risk Threshold",
		Function = function() end,
		Min = 5,
		Max = 100,
		Default = 30
	})

	MitigationChoice = NoFall:CreateDropdown({
		Name = "Mitigation Strategies",
		Default = "VelocityClamp",
		List = {"VelocityClamp", "TeleportBuffer", "ItemDeploy"},
		Function = function()
			if MitigationChoice.Value == "ItemDeploy" then
				warningNotification("Mitigation Strategies - ItemDeploy", "Not yet finished! Its recommended to use VelocityClamp instead.", 1.5)
			end
		end
	})
end)

local spiderActive = false
local holdingshift = false

--until I find a way to make the spam switch item thing not bad I'll just get rid of it, sorry.
local Scaffold = {Enabled = false}
run(function()
	local scaffoldtext = Instance.new("TextLabel")
	scaffoldtext.Font = Enum.Font.SourceSans
	scaffoldtext.TextSize = 20
	scaffoldtext.BackgroundTransparency = 1
	scaffoldtext.TextColor3 = Color3.fromRGB(255, 0, 0)
	scaffoldtext.Size = UDim2.new(0, 0, 0, 0)
	scaffoldtext.Position = UDim2.new(0.5, 0, 0.5, 30)
	scaffoldtext.Text = "0"
	scaffoldtext.Visible = false
	scaffoldtext.Parent = vape.gui
	local ScaffoldExpand = {Value = 1}
	local ScaffoldDiagonal = {Enabled = false}
	local ScaffoldTower = {Enabled = false}
	local ScaffoldDownwards = {Enabled = false}
	local ScaffoldStopMotion = {Enabled = false}
	local ScaffoldBlockCount = {Enabled = false}
	local ScaffoldHandCheck = {Enabled = false}
	local ScaffoldMouseCheck = {Enabled = false}
	local ScaffoldAnimation = {Enabled = false}
	local scaffoldstopmotionval = false
	local scaffoldposcheck = tick()
	local scaffoldstopmotionpos = Vector3.zero
	local scaffoldposchecklist = {}
	task.spawn(function()
		for x = -3, 3, 3 do
			for y = -3, 3, 3 do
				for z = -3, 3, 3 do
					if Vector3.new(x, y, z) ~= Vector3.new(0, 0, 0) then
						table.insert(scaffoldposchecklist, Vector3.new(x, y, z))
					end
				end
			end
		end
	end)

	local function checkblocks(pos)
		for i,v in pairs(scaffoldposchecklist) do
			if getPlacedBlock(pos + v) then
				return true
			end
		end
		return false
	end

	local function closestpos(block, pos)
		local startpos = block.Position - (block.Size / 2) - Vector3.new(1.5, 1.5, 1.5)
		local endpos = block.Position + (block.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		local speedCFrame = block.Position + (pos - block.Position)
		return Vector3.new(math.clamp(speedCFrame.X, startpos.X, endpos.X), math.clamp(speedCFrame.Y, startpos.Y, endpos.Y), math.clamp(speedCFrame.Z, startpos.Z, endpos.Z))
	end

	local function getclosesttop(newmag, pos)
		local closest, closestmag = pos, newmag * 3
		if entityLibrary.isAlive then
			for i,v in pairs(store.blocks) do
				local close = closestpos(v, pos)
				local mag = (close - pos).magnitude
				if mag <= closestmag then
					closest = close
					closestmag = mag
				end
			end
		end
		return closest
	end

	local oldspeed
	Scaffold = vape.Categories.Blatant:CreateModule({
		Name = "Scaffold",
		Function = function(callback)
			if callback then
				scaffoldtext.Visible = ScaffoldBlockCount.Enabled
				if entityLibrary.isAlive then
					scaffoldstopmotionpos = entityLibrary.character.HumanoidRootPart.CFrame.p
				end
				task.spawn(function()
					repeat
						task.wait()
						if ScaffoldHandCheck.Enabled then
							if store.localHand.Type ~= "block" then continue end
						end
						if ScaffoldMouseCheck.Enabled then
							if not inputService:IsMouseButtonPressed(0) then continue end
						end
						if entityLibrary.isAlive then
							local wool, woolamount = getWool()
							if store.localHand.Type == "block" then
								wool = store.localHand.tool.Name
								woolamount = getItem(store.localHand.tool.Name).amount or 0
							elseif (not wool) then
								wool, woolamount = getBlock()
							end

							scaffoldtext.Text = (woolamount and tostring(woolamount) or "0")
							scaffoldtext.TextColor3 = woolamount and (woolamount >= 128 and Color3.fromRGB(9, 255, 198) or woolamount >= 64 and Color3.fromRGB(255, 249, 18)) or Color3.fromRGB(255, 0, 0)
							if not wool then continue end

							local towering = ScaffoldTower.Enabled and inputService:IsKeyDown(Enum.KeyCode.Space) and game:GetService("UserInputService"):GetFocusedTextBox() == nil
							if towering then
								if (not scaffoldstopmotionval) and ScaffoldStopMotion.Enabled then
									scaffoldstopmotionval = true
									scaffoldstopmotionpos = entityLibrary.character.HumanoidRootPart.CFrame.p
								end
								entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 28, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								if ScaffoldStopMotion.Enabled and scaffoldstopmotionval then
									entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(scaffoldstopmotionpos.X, entityLibrary.character.HumanoidRootPart.CFrame.p.Y, scaffoldstopmotionpos.Z))
								end
							else
								scaffoldstopmotionval = false
							end

							for i = 1, ScaffoldExpand.Value do
								local speedCFrame = getScaffold((entityLibrary.character.HumanoidRootPart.Position + ((scaffoldstopmotionval and Vector3.zero or entityLibrary.character.Humanoid.MoveDirection) * (i * 3.5))) + Vector3.new(0, -((entityLibrary.character.HumanoidRootPart.Size.Y / 2) + entityLibrary.character.Humanoid.HipHeight + (inputService:IsKeyDown(Enum.KeyCode.LeftShift) and ScaffoldDownwards.Enabled and 4.5 or 1.5))), 0)
								speedCFrame = Vector3.new(speedCFrame.X, speedCFrame.Y - (towering and 4 or 0), speedCFrame.Z)
								if speedCFrame ~= oldpos then
									if not checkblocks(speedCFrame) then
										local oldspeedCFrame = speedCFrame
										speedCFrame = getScaffold(getclosesttop(20, speedCFrame))
										if getPlacedBlock(speedCFrame) then speedCFrame = oldspeedCFrame end
									end
									if ScaffoldAnimation.Enabled then
										if not getPlacedBlock(speedCFrame) then
										bedwars.ViewmodelController:playAnimation(bedwars.AnimationType.FP_USE_ITEM)
										end
									end
									task.spawn(bedwars.placeBlock, speedCFrame, wool, ScaffoldAnimation.Enabled)
									if ScaffoldExpand.Value > 1 then
										task.wait(0.01)
									end
									oldpos = speedCFrame
								end
							end
						end
					until (not Scaffold.Enabled)
				end)
			else
				scaffoldtext.Visible = false
				oldpos = Vector3.zero
				oldpos2 = Vector3.zero
			end
		end,
		Tooltip = "Helps you make bridges/scaffold walk."
	})
	ScaffoldExpand = Scaffold:CreateSlider({
		Name = "Expand",
		Min = 1,
		Max = 8,
		Function = function(val) end,
		Default = 1,
		Tooltip = "Build range"
	})
	ScaffoldDiagonal = Scaffold:CreateToggle({
		Name = "Diagonal",
		Function = function() end,
		Default = true
	})
	ScaffoldTower = Scaffold:CreateToggle({
		Name = "Tower",
		Function = function() end
	})
	ScaffoldMouseCheck = Scaffold:CreateToggle({
		Name = "Require mouse down",
		Function = function() end,
		Tooltip = "Only places when left click is held.",
	})
	ScaffoldDownwards  = Scaffold:CreateToggle({
		Name = "Downwards",
		Function = function() end,
		Tooltip = "Goes down when left shift is held."
	})
	ScaffoldStopMotion = Scaffold:CreateToggle({
		Name = "Stop Motion",
		Function = function() end,
		Tooltip = "Stops your movement when going up"
	})
	ScaffoldStopMotion.Object.BackgroundTransparency = 0
	ScaffoldStopMotion.Object.BorderSizePixel = 0
	ScaffoldStopMotion.Object.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ScaffoldStopMotion.Object.Visible = ScaffoldTower.Enabled
	ScaffoldBlockCount = Scaffold:CreateToggle({
		Name = "Block Count",
		Function = function(callback)
			if Scaffold.Enabled then
				scaffoldtext.Visible = callback
			end
		end,
		Tooltip = "Shows the amount of blocks in the middle."
	})
	ScaffoldHandCheck = Scaffold:CreateToggle({
		Name = "Hand Check",
		Function = function() end,
		Tooltip = "Only builds with blocks in your hand.",
		Default = false
	})
	ScaffoldAnimation = Scaffold:CreateToggle({
		Name = "Animation",
		Function = function() end
	})
end)

local antivoidvelo
run(function()
	local Speed = {Enabled = false}
	local SpeedMode = {Value = "CFrame"}
	local SpeedValue = {Value = 1}
	local SpeedValueLarge = {Value = 1}
	local SpeedJump = {Enabled = false}
	local SpeedJumpHeight = {Value = 20}
	local SpeedJumpAlways = {Enabled = false}
	local SpeedJumpSound = {Enabled = false}
	local SpeedJumpVanilla = {Enabled = false}
	local SpeedAnimation = {Enabled = false}
	local SpeedDamageBoost = {Enabled = false}
	local raycastparameters = RaycastParams.new()
	local damagetick = tick()

	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B"}
	Speed = vape.Categories.Blatant:CreateModule({
		Name = "Speed",
		Function = function(callback)
			if callback then
				if SpeedValue.Value == 23.3 then SpeedValue.Value = 21 end
				shared.SpeedBoostEnabled = SpeedDamageBoost.Enabled
				Speed:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
					if damageTable.entityInstance == lplr.Character and (damageTable.damageType ~= 0 or damageTable.extra and damageTable.extra.chargeRatio ~= nil) and (not (damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.disabled or damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal == 0)) and SpeedDamageBoost.Enabled then 
						damagetick = tick() + 0.4
						lastdamagetick = tick() + 0.4
					end
				end))
				Speed:Clean(runservice.Heartbeat:Connect(function(delta)
					if entityLibrary.isAlive then
						if not (isnetworkowner(entityLibrary.character.HumanoidRootPart) and entityLibrary.character.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing and (not spiderActive) and (not vape.Modules.InfiniteFly.Enabled) and (not vape.Modules.Fly.Enabled)) then return end
						if vape.Modules.GrappleExploitOptionsButton and vape.Modules.GrappleExploit.Enabled then return end
						if LongJump.Enabled then return end
						if SpeedAnimation.Enabled then
							for i, v in pairs(entityLibrary.character.Humanoid:GetPlayingAnimationTracks()) do
								if v.Name == "WalkAnim" or v.Name == "RunAnim" then
									v:AdjustSpeed(entityLibrary.character.Humanoid.WalkSpeed / 16)
								end
							end
						end

						local speedValue = damagetick > tick() and SpeedValue.Value * 2.25 - 1 or SpeedValue.Value + getSpeed()
						local speedVelocity = entityLibrary.character.Humanoid.MoveDirection * (SpeedMode.Value == "Normal" and SpeedValue.Value or 20)
						entityLibrary.character.HumanoidRootPart.Velocity = antivoidvelo or Vector3.new(speedVelocity.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, speedVelocity.Z)
						if SpeedMode.Value ~= "Normal" then
							local speedCFrame = entityLibrary.character.Humanoid.MoveDirection * (speedValue - 20) * delta
							raycastparameters.FilterDescendantsInstances = {lplr.Character}
							local ray = game.Workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, speedCFrame, raycastparameters)
							if ray then speedCFrame = (ray.Position - entityLibrary.character.HumanoidRootPart.Position) end
							entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + speedCFrame
						end

						if SpeedJump.Enabled and (not Scaffold.Enabled) and (SpeedJumpAlways.Enabled or killauraNearPlayer) then
							if (entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entityLibrary.character.Humanoid.MoveDirection ~= Vector3.zero then
								if SpeedJumpSound.Enabled then
									pcall(function() entityLibrary.character.HumanoidRootPart.Jumping:Play() end)
								end
								if SpeedJumpVanilla.Enabled then
									entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								else
									entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, SpeedJumpHeight.Value, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								end
							end
						end
					end
				end))
			end
		end,
		Tooltip = "Increases your movement.",
		ExtraText = function()
			return "Heatseeker"
		end
	})
	Speed.Restart = function()
		if Speed.Enabled then Speed:Toggle(false); Speed:Toggle(false) end
	end
	--[[SpeedDamageBoost = Speed:CreateToggle({
		Name = "Damage Boost",
		Function = Speed.Restart,
		Default = true
	})--]]
	SpeedValue = Speed:CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end,
		Default = 21
	})
	SpeedValueLarge = Speed:CreateSlider({
		Name = "Big Mode Speed",
		Min = 1,
		Max = 23,
		Function = function(val) end,
		Default = 23
	})
	SpeedJump = Speed:CreateToggle({
		Name = "AutoJump",
		Function = function(callback)
			if SpeedJumpHeight.Object then SpeedJumpHeight.Object.Visible = callback end
			if SpeedJumpAlways.Object then
				SpeedJumpAlways.Object.Visible = callback
			end
			if SpeedJumpSound.Object then SpeedJumpSound.Object.Visible = callback end
			if SpeedJumpVanilla.Object then SpeedJumpVanilla.Object.Visible = callback end
		end,
		Default = true
	})
	SpeedJumpHeight = Speed:CreateSlider({
		Name = "Jump Height",
		Min = 0,
		Max = 30,
		Default = 25,
		Function = function() end
	})
	SpeedJumpAlways = Speed:CreateToggle({
		Name = "Always Jump",
		Function = function() end
	})
	SpeedJumpSound = Speed:CreateToggle({
		Name = "Jump Sound",
		Function = function() end
	})
	SpeedJumpVanilla = Speed:CreateToggle({
		Name = "Real Jump",
		Function = function() end
	})
	SpeedAnimation = Speed:CreateToggle({
		Name = "Slowdown Anim",
		Function = function() end
	})
end)

run(function()
	local FieldOfViewValue = {Value = 70}
	local FieldOfView = {Enabled = false}
	FieldOfView = vape.Categories.Render:CreateModule({
		Name = "FOV",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() bedwars.SettingsController:setFOV(FieldOfViewValue.Value) until (not FieldOfView.Enabled)
				end)
			end
		end
	})
	FieldOfViewValue = FieldOfView:CreateSlider({
		Name = "FOV",
		Min = 30,
		Max = 120,
		Function = function(val)
			if FieldOfView.Enabled then
				bedwars.SettingsController:setFOV(FieldOfViewValue.Value)
			end
		end
	})
end)

run(function()
	local NameTags
	local Targets
	local Color
	local Background
	local DisplayName
	local Health
	local Distance
	local Equipment
	local DrawingToggle
	local Scale
	local FontOption
	local Teammates
	local DistanceCheck
	local DistanceLimit
	local Strings, Sizes, Reference = {}, {}, {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	local methodused
	local fontitems = {'Arial'}
	local kititems = {
		jade = 'jade_hammer',
		archer = 'tactical_crossbow',
		cowgirl = 'lasso',
		dasher = 'wood_dao',
		axolotl = 'axolotl',
		yeti = 'snowball',
		smoke = 'smoke_block',
		trapper = 'snap_trap',
		pyro = 'flamethrower',
		davey = 'cannon',
		regent = 'void_axe',
		baker = 'apple',
		builder = 'builder_hammer',
		farmer_cletus = 'carrot_seeds',
		melody = 'guitar',
		barbarian = 'rageblade',
		gingerbread_man = 'gumdrop_bounce_pad',
		spirit_catcher = 'spirit',
		fisherman = 'fishing_rod',
		oil_man = 'oil_consumable',
		santa = 'tnt',
		miner = 'miner_pickaxe',
		sheep_herder = 'crook',
		beast = 'speed_potion',
		metal_detector = 'metal_detector',
		cyber = 'drone',
		vesta = 'damage_banner',
		lumen = 'light_sword',
		ember = 'infernal_saber',
		queen_bee = 'bee'
	}
	
	local Added = {
		Normal = function(ent)
			if not Targets.Players.Enabled and ent.Player then return end
			if not Targets.NPCs.Enabled and ent.NPC then return end
			if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
			local EntityNameTag = Instance.new('TextLabel')
			EntityNameTag.BackgroundColor3 = Color3.new()
			EntityNameTag.BorderSizePixel = 0
			EntityNameTag.Visible = false
			EntityNameTag.RichText = true
			EntityNameTag.AnchorPoint = Vector2.new(0.5, 1)
			EntityNameTag.Name = ent.Player and ent.Player.Name or ent.Character.Name
			EntityNameTag.FontFace = FontOption.Value
			EntityNameTag.TextSize = 14 * Scale.Value
			EntityNameTag.BackgroundTransparency = Background.Value
			Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
			if Health.Enabled then
				local healthColor = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
				Strings[ent] = Strings[ent]..' <font color="rgb('..tostring(math.floor(healthColor.R * 255))..','..tostring(math.floor(healthColor.G * 255))..','..tostring(math.floor(healthColor.B * 255))..')">'..math.round(ent.Health)..'</font>'
			end
			if Distance.Enabled then
				Strings[ent] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..Strings[ent]
			end
			if Equipment.Enabled then
				for i, v in {'Hand', 'Helmet', 'Chestplate', 'Boots', 'Kit'} do
					local Icon = Instance.new('ImageLabel')
					Icon.Name = v
					Icon.Size = UDim2.fromOffset(30, 30)
					Icon.Position = UDim2.fromOffset(-60 + (i * 30), -30)
					Icon.BackgroundTransparency = 1
					Icon.Image = ''
					Icon.Parent = EntityNameTag
				end
			end
			local nametagSize = getfontsize(removeTags(Strings[ent]), EntityNameTag.TextSize, EntityNameTag.FontFace, Vector2.new(100000, 100000))
			EntityNameTag.Size = UDim2.fromOffset(nametagSize.X + 8, nametagSize.Y + 7)
			EntityNameTag.Text = Strings[ent]
			EntityNameTag.TextColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			EntityNameTag.Parent = Folder
			Reference[ent] = EntityNameTag
		end,
		Drawing = function(ent)
			if not Targets.Players.Enabled and ent.Player then return end
			if not Targets.NPCs.Enabled and ent.NPC then return end
			if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
			local EntityNameTag = {}
			EntityNameTag.BG = Drawing.new('Square')
			EntityNameTag.BG.Filled = true
			EntityNameTag.BG.Transparency = 1 - Background.Value
			EntityNameTag.BG.Color = Color3.new()
			EntityNameTag.BG.ZIndex = 1
			EntityNameTag.Text = Drawing.new('Text')
			EntityNameTag.Text.Size = 15 * Scale.Value
			EntityNameTag.Text.Font = (math.clamp((table.find(fontitems, FontOption.Value) or 1) - 1, 0, 3))
			EntityNameTag.Text.ZIndex = 2
			Strings[ent] = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
			if Health.Enabled then
				Strings[ent] = Strings[ent]..' '..math.round(ent.Health)
			end
			if Distance.Enabled then
				Strings[ent] = '[%s] '..Strings[ent]
			end
			EntityNameTag.Text.Text = Strings[ent]
			EntityNameTag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			EntityNameTag.BG.Size = Vector2.new(EntityNameTag.Text.TextBounds.X + 8, EntityNameTag.Text.TextBounds.Y + 7)
			Reference[ent] = EntityNameTag
		end
	}
	
	local Removed = {
		Normal = function(ent)
			local v = Reference[ent]
			if v then
				Reference[ent] = nil
				Strings[ent] = nil
				Sizes[ent] = nil
				v:Destroy()
			end
		end,
		Drawing = function(ent)
			local v = Reference[ent]
			if v then
				Reference[ent] = nil
				Strings[ent] = nil
				Sizes[ent] = nil
				for _, obj in v do
					pcall(function() 
						obj.Visible = false 
						obj:Remove() 
					end)
				end
			end
		end
	}
	
	local Updated = {
		Normal = function(ent)
			local EntityNameTag = Reference[ent]
			if EntityNameTag then
				Sizes[ent] = nil
				Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
				if Health.Enabled then
					local healthColor = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
					Strings[ent] = Strings[ent]..' <font color="rgb('..tostring(math.floor(healthColor.R * 255))..','..tostring(math.floor(healthColor.G * 255))..','..tostring(math.floor(healthColor.B * 255))..')">'..math.round(ent.Health)..'</font>'
				end
				if Distance.Enabled then
					Strings[ent] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..Strings[ent]
				end
				if Equipment.Enabled and store.inventories[ent.Player] then
					local inventory = store.inventories[ent.Player]
					EntityNameTag.Hand.Image = bedwars.getIcon(inventory.hand or {itemType = ''}, true)
					EntityNameTag.Helmet.Image = bedwars.getIcon(inventory.armor[4] or {itemType = ''}, true)
					EntityNameTag.Chestplate.Image = bedwars.getIcon(inventory.armor[5] or {itemType = ''}, true)
					EntityNameTag.Boots.Image = bedwars.getIcon(inventory.armor[6] or {itemType = ''}, true)
					EntityNameTag.Kit.Image = bedwars.getIcon({itemType = kititems[ent.Player:GetAttribute('PlayingAsKit')] or ''}, true)
				end
				local nametagSize = getfontsize(removeTags(Strings[ent]), EntityNameTag.TextSize, EntityNameTag.FontFace, Vector2.new(100000, 100000))
				EntityNameTag.Size = UDim2.fromOffset(nametagSize.X + 8, nametagSize.Y + 7)
				EntityNameTag.Text = Strings[ent]
			end
		end,
		Drawing = function(ent)
			local EntityNameTag = Reference[ent]
			if EntityNameTag then
				Sizes[ent] = nil
				Strings[ent] = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
				if Health.Enabled then
					Strings[ent] = Strings[ent]..' '..math.round(ent.Health)
				end
				if Distance.Enabled then
					Strings[ent] = '[%s] '..Strings[ent]
					EntityNameTag.Text.Text = entitylib.isAlive and string.format(Strings[ent], (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude // 1) or Strings[ent]
				else
					EntityNameTag.Text.Text = Strings[ent]
				end
				EntityNameTag.BG.Size = Vector2.new(EntityNameTag.Text.TextBounds.X + 8, EntityNameTag.Text.TextBounds.Y + 7)
				EntityNameTag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			end
		end
	}
	
	local ColorFunc = {
		Normal = function(hue, sat, val)
			local tagColor = Color3.fromHSV(hue, sat, val)
			for i, v in Reference do
				v.TextColor3 = entitylib.getEntityColor(i) or tagColor
			end
		end,
		Drawing = function(hue, sat, val)
			local tagColor = Color3.fromHSV(hue, sat, val)
			for i, v in Reference do
				v.Text.Text.Color = entitylib.getEntityColor(i) or tagColor
			end
		end
	}
	
	local Loop = {
		Normal = function()
			for ent, EntityNameTag in Reference do
				if DistanceCheck.Enabled then
					local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
					if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
						EntityNameTag.Visible = false
						continue
					end
				end
				local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
				EntityNameTag.Visible = headVis
				if not headVis then
					continue
				end
				if Distance.Enabled and entitylib.isAlive then
					local mag = (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude // 1
					if Sizes[ent] ~= mag then
						EntityNameTag.Text = string.format(Strings[ent], mag)
						local nametagSize = getfontsize(removeTags(EntityNameTag.Text), EntityNameTag.TextSize, EntityNameTag.FontFace, Vector2.new(100000, 100000))
						EntityNameTag.Size = UDim2.fromOffset(nametagSize.X + 8, nametagSize.Y + 7)
						Sizes[ent] = mag
					end
				end
				EntityNameTag.Position = UDim2.fromOffset(headPos.X, headPos.Y)
			end
		end,
		Drawing = function()
			for ent, EntityNameTag in Reference do
				if DistanceCheck.Enabled then
					local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
					if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
						EntityNameTag.Text.Visible = false
						EntityNameTag.BG.Visible = false
						continue
					end
				end
				local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
				EntityNameTag.Text.Visible = headVis
				EntityNameTag.BG.Visible = headVis and Background.Enabled
				if not headVis then
					continue
				end
				if Distance.Enabled and entitylib.isAlive then
					local mag = (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude // 1
					if Sizes[ent] ~= mag then
						EntityNameTag.Text.Text = string.format(Strings[ent], mag)
						EntityNameTag.BG.Size = Vector2.new(EntityNameTag.Text.TextBounds.X + 8, EntityNameTag.Text.TextBounds.Y + 7)
						Sizes[ent] = mag
					end
				end
				EntityNameTag.BG.Position = Vector2.new(headPos.X - (EntityNameTag.BG.Size.X / 2), headPos.Y + (EntityNameTag.BG.Size.Y / 2))
				EntityNameTag.Text.Position = EntityNameTag.BG.Position + Vector2.new(4, 2.5)
			end
		end
	}
	
	NameTags = vape.Categories.Render:CreateModule({
		Name = 'NameTags',
		Function = function(callback)
			if callback then
				methodused = DrawingToggle.Enabled and 'Drawing' or 'Normal'
				if Removed[methodused] then
					NameTags:Clean(entitylib.Events.EntityRemoved:Connect(Removed[methodused]))
				end
				if Added[methodused] then
					for _, v in entitylib.List do
						if Reference[v] then 
							Removed[methodused](v) 
						end
						Added[methodused](v)
					end
					NameTags:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
						if Reference[ent] then 
							Removed[methodused](ent) 
						end
						Added[methodused](ent)
					end))
				end
				if Updated[methodused] then
					NameTags:Clean(entitylib.Events.EntityUpdated:Connect(Updated[methodused]))
					for _, v in entitylib.List do 
						Updated[methodused](v) 
					end
				end
				if ColorFunc[methodused] then
				end
				if Loop[methodused] then
					NameTags:Clean(runService.RenderStepped:Connect(Loop[methodused]))
				end
			else
				if Removed[methodused] then
					for i in Reference do 
						Removed[methodused](i) 
					end
				end
			end
		end,
		Tooltip = 'Renders nametags on entities through walls.'
	})
	Targets = NameTags:CreateTargets({
		Players = true, 
		Function = function()
		if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end
	})
	FontOption = NameTags:CreateFont({
		Name = 'Font',
		Blacklist = 'Arial',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end
	})
	Color = NameTags:CreateColorSlider({
		Name = 'Player Color',
		Function = function(hue, sat, val)
			if NameTags.Enabled and ColorFunc[methodused] then
				ColorFunc[methodused](hue, sat, val)
			end
		end
	})
	Scale = NameTags:CreateSlider({
		Name = 'Scale',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end,
		Default = 1,
		Min = 0.1,
		Max = 1.5,
		Decimal = 10
	})
	Background = NameTags:CreateSlider({
		Name = 'Transparency',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end,
		Default = 0.5,
		Min = 0,
		Max = 1,
		Decimal = 10
	})
	Health = NameTags:CreateToggle({
		Name = 'Health',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end
	})
	Distance = NameTags:CreateToggle({
		Name = 'Distance',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end
	})
	Equipment = NameTags:CreateToggle({
		Name = 'Equipment',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end
	})
	DisplayName = NameTags:CreateToggle({
		Name = 'Use Displayname',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end,
		Default = true
	})
	Teammates = NameTags:CreateToggle({
		Name = 'Priority Only',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end,
		Default = true
	})
	DrawingToggle = NameTags:CreateToggle({
		Name = 'Drawing',
		Function = function() 
			if NameTags.Enabled then 
				NameTags:Toggle() 
				NameTags:Toggle() 
			end 
		end,
	})
	DistanceCheck = NameTags:CreateToggle({
		Name = 'Distance Check',
		Function = function(callback)
			DistanceLimit.Object.Visible = callback
		end
	})
	DistanceLimit = NameTags:CreateSlider({
		Name = 'Player Distance',
		Min = 0,
		Max = 256,
		Default = 64,
		Darker = true,
		Visible = false
	})
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
	GodMode = vape.Categories.World:CreateModule({
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
													repeat task.wait() until store.matchState ~= 0
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

run(function()
	local AntiAFK = {Enabled = false}
	AntiAFK = vape.Categories.Utility:CreateModule({
		Name = "Anti AFK",
		Function = function(callback)
			if callback then
				bedwars.Client:Get("AfkInfo"):FireServer({
					afk = false
				})
			end
		end
	})
end)

local autobankapple = false
run(function()
	local AutoBuy = {Enabled = false}
	local AutoBuyArmor = {Enabled = false}
	local AutoBuySword = {Enabled = false}
	local AutoBuyGen = {Enabled = false}
	local AutoBuyProt = {Enabled = false}
	local AutoBuySharp = {Enabled = false}
	local AutoBuyDestruction = {Enabled = false}
	local AutoBuyDiamond = {Enabled = false}
	local AutoBuyAlarm = {Enabled = false}
	local AutoBuyGui = {Enabled = false}
	local AutoBuyTierSkip = {Enabled = true}
	local AutoBuyRange = {Value = 20}
	local AutoBuyCustom = {ObjectList = {}, RefreshList = function() end}
	local AutoBankUIToggle = {Enabled = false}
	local AutoBankDeath = {Enabled = false}
	local AutoBankStay = {Enabled = false}
	local buyingthing = false
	local shoothook
	local bedwarsshopnpcs = {}
	local id
	local armors = {
		[1] = "leather_chestplate",
		[2] = "iron_chestplate",
		[3] = "diamond_chestplate",
		[4] = "emerald_chestplate"
	}

	local swords = {
		[1] = "wood_sword",
		[2] = "stone_sword",
		[3] = "iron_sword",
		[4] = "diamond_sword",
		[5] = "emerald_sword"
	}

	local scythes = {
		[1] = "wood_scythe",
		[2] = "stone_scythe",
		[3] = "iron_scythe",
		[4] = "diamond_scythe",
		[5] = "mythic_scythe"
	}

	local axes = {
		[1] = "wood_axe",
		[2] = "stone_axe",
		[3] = "iron_axe",
		[4] = "diamond_axe"
	}

	local pickaxes = {
		[1] = "wood_pickaxe",
		[2] = "stone_pickaxe",
		[3] = "iron_pickaxe",
		[4] = "diamond_pickaxe"
	}

	task.spawn(function()
		repeat task.wait() until store.matchState ~= 0 or not vapeInjected
		for i,v in pairs(collectionService:GetTagged("BedwarsItemShop")) do
			table.insert(bedwarsshopnpcs, {Position = v.Position, TeamUpgradeNPC = true, Id = v.Name})
		end
		for i,v in pairs(collectionService:GetTagged("TeamUpgradeShopkeeper")) do
			table.insert(bedwarsshopnpcs, {Position = v.Position, TeamUpgradeNPC = false, Id = v.Name})
		end
	end)

	local function nearNPC(range)
		local npc, npccheck, enchant, newid = nil, false, false, nil
		if entityLibrary.isAlive then
			local enchanttab = {}
			for i,v in pairs(collectionService:GetTagged("broken-enchant-table")) do
				table.insert(enchanttab, v)
			end
			for i,v in pairs(collectionService:GetTagged("enchant-table")) do
				table.insert(enchanttab, v)
			end
			for i,v in pairs(enchanttab) do
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= 6 then
					if ((not v:GetAttribute("Team")) or v:GetAttribute("Team") == lplr:GetAttribute("Team")) then
						npc, npccheck, enchant = true, true, true
					end
				end
			end
			for i, v in pairs(bedwarsshopnpcs) do
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= (range or 20) then
					npc, npccheck, enchant = true, (v.TeamUpgradeNPC or npccheck), false
					newid = v.TeamUpgradeNPC and v.Id or newid
				end
			end
			local suc, res = pcall(function() return lplr.leaderstats.Bed.Value == "✅"  end)
			if AutoBankDeath.Enabled and (game.Workspace:GetServerTimeNow() - lplr.Character:GetAttribute("LastDamageTakenTime")) < 2 and suc and res then
				return nil, false, false
			end
			if AutoBankStay.Enabled then
				return nil, false, false
			end
		end
		return npc, not npccheck, enchant, newid
	end

	local function buyItem(itemtab, waitdelay)
		if not id then return end
		local res
		res = bedwars.Client:Get("BedwarsPurchaseItem"):InvokeServer({
			shopItem = itemtab,
			shopId = id
		})
		if waitdelay then
			repeat task.wait() until res ~= nil
		end
	end

	local function getAxeNear(inv)
		for i5, v5 in pairs(inv or store.localInventory.inventory.items) do
			if v5.itemType:find("axe") and v5.itemType:find("pickaxe") == nil then
				return v5.itemType
			end
		end
		return nil
	end

	local function getPickaxeNear(inv)
		for i5, v5 in pairs(inv or store.localInventory.inventory.items) do
			if v5.itemType:find("pickaxe") then
				return v5.itemType
			end
		end
		return nil
	end

	local function getShopItem(itemType)
		if itemType == "axe" then
			itemType = getAxeNear() or "wood_axe"
			itemType = axes[table.find(axes, itemType) + 1] or itemType
		end
		if itemType == "pickaxe" then
			itemType = getPickaxeNear() or "wood_pickaxe"
			itemType = pickaxes[table.find(pickaxes, itemType) + 1] or itemType
		end
		for i,v in pairs(bedwars.ShopItems) do
			if v.itemType == itemType then return v end
		end
		return nil
	end

	local buyfunctions = {
		Armor = function(inv, upgrades, shoptype)
			--- shopType doesnt matter :shrug:
			local inv = store.localInventory.inventory
			local armor = inv.armor
			local currentArmor = armor[2]
			if type(currentArmor) ~= "table" then currentArmor = {itemType = ""} end
			if tostring(currentArmor.itemType) == "nil" then currentArmor = {itemType = ""} end
			local armorToBuy
			if currentArmor.itemType == "" then armorToBuy = "leather_chestplate" end
			if currentArmor.itemType ~= "" and currentArmor.itemType:find("leather") then armorToBuy = "iron_chestplate" end
			if currentArmor.itemType ~= "" and currentArmor.itemType:find("iron") then armorToBuy = "diamond_chestplate" end
			if currentArmor.itemType ~= "" and currentArmor.itemType:find("diamond") then armorToBuy = "emerald_chestplate" end
			if currentArmor.itemType ~= "" and currentArmor.itemType:find("emerald") then armorToBuy = "none" end
			local shopitem = getShopItem(armorToBuy)
			if shopitem then
				local currency = getItem(shopitem.currency, inv.items)
				if currency and currency.amount >= shopitem.price then
					buyItem(getShopItem(armorToBuy))
				end
			end
		end,
		Sword = function(inv, upgrades, shoptype)
			local inv = store.localInventory.inventory
			local currentsword = shared.scythexp and getItemNear("scythe", inv.items) or getItemNear("sword", inv.items)
			local swordindex = (currentsword and table.find(swords, currentsword.itemType) or 0) + 1
			if shared.scythexp then
				swordindex = (currentsword and table.find(scythes, currentsword.itemType) or 0) + 1
			end
			if getItemNear("scythe", inv.items) then 
				if currentsword ~= nil and table.find(scythes, currentsword.itemType) == nil then return end
			else
				if currentsword ~= nil and table.find(swords, currentsword.itemType) == nil then return end
			end
			local highestbuyable = nil
			local tableToDo = shared.scythexp and scythes or swords
			for i = swordindex, #tableToDo, 1 do
				local shopitem = shared.scythexp and getShopItem(scythes[i]) or getShopItem(swords[i])
				if shopitem and i == swordindex then
					local currency = getItem(shopitem.currency, inv.items)
					if currency and currency.amount >= shopitem.price then
						highestbuyable = shopitem
					end
				end
			end
			if highestbuyable and (highestbuyable.ignoredByKit == nil or table.find(highestbuyable.ignoredByKit, store.equippedKit) == nil) then
				buyItem(highestbuyable)
			end
		end
	}

	AutoBuy = vape.Categories.Utility:CreateModule({
		Name = "AutoBuy",
		Function = function(callback)
			if callback then
				buyingthing = false
				task.spawn(function()
					repeat
						task.wait()
						local found, npctype, enchant, newid = nearNPC(AutoBuyRange.Value)
						id = newid
						if found then
							local inv = store.localInventory.inventory
							local currentupgrades = {}
							--bedwars.ClientStoreHandler:getState().Bedwars.teamUpgrades
							if store.equippedKit == "dasher" then
								swords = {
									[1] = "wood_dao",
									[2] = "stone_dao",
									[3] = "iron_dao",
									[4] = "diamond_dao",
									[5] = "emerald_dao"
								}
							elseif store.equippedKit == "ice_queen" then
								swords[5] = "ice_sword"
							elseif store.equippedKit == "ember" then
								swords[5] = "infernal_saber"
							elseif store.equippedKit == "lumen" then
								swords[5] = "light_sword"
							end
							if (AutoBuyGui.Enabled == false or (bedwars.AppController:isAppOpen("BedwarsItemShopApp") or bedwars.AppController:isAppOpen("BedwarsTeamUpgradeApp"))) and (not enchant) then
								for i,v in pairs(AutoBuyCustom.ObjectList) do
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] ~= "true" then
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getWool() or shopitem.itemType, inv.items)
											if currency and currency.amount >= shopitem.price and (actualitem == nil or actualitem.amount < tonumber(autobuyitem[2])) then
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
								for i,v in pairs(buyfunctions) do v(inv, currentupgrades, npctype and "upgrade" or "item") end
								for i,v in pairs(AutoBuyCustom.ObjectList) do
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] == "true" then
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getWool() or shopitem.itemType, inv.items)
											if currency and currency.amount >= shopitem.price and (actualitem == nil or actualitem.amount < tonumber(autobuyitem[2])) then
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
							end
						end
					until (not AutoBuy.Enabled)
				end)
			end
		end,
		Tooltip = "Automatically Buys Swords, Armor, and Team Upgrades\nwhen you walk near the NPC"
	})
	AutoBuyRange = AutoBuy:CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 1,
		Max = 20,
		Default = 20
	})
	AutoBuyArmor = AutoBuy:CreateToggle({
		Name = "Buy Armor",
		Function = function() end,
		Default = true
	})
	AutoBuySword = AutoBuy:CreateToggle({
		Name = "Buy Sword",
		Function = function() end,
		Default = true
	})
	AutoBuyGui = AutoBuy:CreateToggle({
		Name = "Shop GUI Check",
		Function = function() end,
	})
	AutoBuyTierSkip = AutoBuy:CreateToggle({
		Name = "Tier Skip",
		Function = function() end,
		Default = true
	})
	AutoBuyCustom = AutoBuy:CreateTextList({
		Name = "BuyList",
		TempText = "item/amount/priority/after",
		SortFunction = function(a, b)
			local amount1 = a:split("/")
			local amount2 = b:split("/")
			amount1 = #amount1 and tonumber(amount1[3]) or 1
			amount2 = #amount2 and tonumber(amount2[3]) or 1
			return amount1 < amount2
		end
	})
end)

run(function()
    local function getDiamonds()
        local function getItem(itemName, inv)
            for slot, item in pairs(inv or store.localInventory.inventory.items) do
                if item.itemType == itemName then
                    return item, slot
                end
            end
            return nil
        end
        local inv = store.localInventory.inventory
        if inv.items and type(inv.items) == "table" and getItem("diamond", inv.items) and getItem("diamond", inv.items).amount then 
            return tostring(getItem("diamond", inv.items).amount) ~= "inf" and tonumber(getItem("diamond", inv.items).amount) or 9999999999999
        else 
            --warn("failure", inv.items, type(inv.items) == "table", getItem("diamond", inv.items))
            return 0 
        end
    end
    local resolve = {
        ["Armor"] = {
            Name = "ARMOR",
            Upgrades = {[1] = 4, [2] = 8, [3] = 20},
            CurrentUpgrade = 0,
            Function = function()

            end
        },
        ["Damage"] = {
            Name = "DAMAGE",
            Upgrades = {[1] = 5, [2] = 10, [3] = 18},
            CurrentUpgrade = 0,
            Function = function()

            end
        },
        ["Diamond Gen"] = {
            Name = "DIAMOND_GENERATOR",
            Upgrades = {[1] = 4, [2] = 8, [3] = 12},
            CurrentUpgrade = 0,
            Function = function()

            end
        },
        ["Team Gen"] = {
            Name = "TEAM_GENERATOR",
            Upgrades = {[1] = 4, [2] = 8, [3] = 16},
            CurrentUpgrade = 0,
            Function = function()

            end
        }
    }
    local function buyUpgrade(translation)
        if not translation or not resolve[translation] or not type(resolve[translation]) == "table" then return warn(debug.traceback("[buyUpgrade]: Invalid translation given! "..tostring(translation))) end
        local res = bedwars.Client:Get("RequestPurchaseTeamUpgrade"):InvokeServer(resolve[translation].Name)
        if res == true then resolve[translation].CurrentUpgrade = resolve[translation].CurrentUpgrade + 1 else
            if getDiamonds() >= resolve[translation].Upgrades[resolve[translation].CurrentUpgrade + 1] then
                local res2 = bedwars.Client:Get("RequestPurchaseTeamUpgrade"):InvokeServer(resolve[translation].Name)
                if res2 == true then resolve[translation].CurrentUpgrade = resolve[translation].CurrentUpgrade + 1 else
                    warn("Using force use of current upgrade...", translation, tostring(res), tostring(res2))
                    resolve[translation].CurrentUpgrade = resolve[translation].CurrentUpgrade + 1
                end
            end
        end
    end
    local function resolveTeamUpgradeApp(app)
        if (not app) or not app:IsA("ScreenGui") then return "invalid app! "..tostring(app) end
        local function findChild(name, className, children)
            for i,v in pairs(children) do if v.Name == name and v.ClassName == className then return v end end
            local args = {Name = tostring(name), ClassName == tostring(className), Children = children}
            --warn(debug.traceback("[findChild]: CHILD NOT FOUND! Args: "), game:GetService("HttpService"):JSONEncode(args), name, className, children)
            return nil
        end
        local function resolveCard(card, translation)
            local a = "["..tostring(card).." | "..tostring(translation).."] "
            local suc, res = true, a
            local function p(b) suc = false; res = a..tostring(b).." not found!" return suc, res end
            if not card or not translation or not card:IsA("Frame") then suc = false; res = a.."Invalid use of resolveCard!" return suc, res end
            translation = tostring(translation)
            local function resolveUpgradeCost(cost)
                if not cost then return warn(debug.traceback("[resolveUpgradeCost]: Invalid cost given!")) end
                cost = tonumber(cost)
                if resolve[translation] and resolve[translation].Upgrades and type(resolve[translation].Upgrades) == "table" then
                    for i,v in pairs(resolve[translation].Upgrades) do 
                        if v == cost then return i end
                    end
                end
            end
            local Content = findChild("Content", "Frame", card:GetChildren())
            if Content then
                local PurchaseSection = findChild("PurchaseSection", "Frame", Content:GetChildren())
                if PurchaseSection then
                    local Cost_Info = findChild("Cost Info", "Frame", PurchaseSection:GetChildren())
                    if Cost_Info then
                        local Current_Diamond_Required = findChild("2", "TextLabel", Cost_Info:GetChildren())
                        if Current_Diamond_Required then
                            local upgrade = resolveUpgradeCost(Current_Diamond_Required.Text)
                            if upgrade then
                                resolve[translation].CurrentUpgrade = upgrade - 1
                            else warn("invalid upgrade", translation, Current_Diamond_Required.Text) end
                        else return p("Card->Content->PurchaseSection->Cost Info") end
                    else resolve[translation].CurrentUpgrade = 3 return p("Card->Content->PurchaseSection->Cost Info") end
                else return p("Card->Content->PurchaseSection") end
            else return p("Card->Content") end
        end
        local frame2 = findChild("2", "Frame", app:GetChildren())
        if frame2 then
            local TeamUpgradeAppContainer = findChild("TeamUpgradeAppContainer", "ImageButton", frame2:GetChildren())
            if TeamUpgradeAppContainer then
                local UpgradesWrapper = findChild("UpgradesWrapper", "Frame", TeamUpgradeAppContainer:GetChildren())
                if UpgradesWrapper then
                    local suc1, res1, suc2, res2, suc3, res3, suc4, res4 = resolveCard(findChild("ARMOR_Card", "Frame", UpgradesWrapper:GetChildren()), "Armor"), resolveCard(findChild("DAMAGE_Card", "Frame", UpgradesWrapper:GetChildren()), "Damage"), resolveCard(findChild("DIAMOND_GENERATOR_Card", "Frame", UpgradesWrapper:GetChildren()), "Diamond Gen"), resolveCard(findChild("TEAM_GENERATOR_Card", "Frame", UpgradesWrapper:GetChildren()), "Team Gen")
                end
            end
        end
    end
    local function check(app) if app.Name and app:IsA("ScreenGui") and app.Name == "TeamUpgradeApp" then resolveTeamUpgradeApp(app) end end
    local con = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(check)
    GuiLibrary.SelfDestructEvent.Event:Connect(function() pcall(function() con:Disconnect() end) end)
    for i, app in pairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do check(app) end

    local bedwarsshopnpcs = {}
    task.spawn(function()
		repeat task.wait() until store.matchState ~= 0 or not shared.VapeExecuted
		for i,v in pairs(collectionService:GetTagged("TeamUpgradeShopkeeper")) do
			table.insert(bedwarsshopnpcs, {Position = v.Position, TeamUpgradeNPC = false, Id = v.Name})
		end
	end)

    local function nearNPC(range)
		local npc, npccheck, enchant, newid = nil, false, false, nil
		if entityLibrary.isAlive then
			for i, v in pairs(bedwarsshopnpcs) do
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= (range or 20) then
					npc, npccheck, enchant = true, (v.TeamUpgradeNPC or npccheck), false
					newid = v.TeamUpgradeNPC and v.Id or newid
				end
			end
		end
		return npc, not npccheck, enchant, newid
	end

    local AutoBuyDiamond = {Enabled = false}
    local PreferredUpgrade = {Value = "Damage"}
    local AutoBuyDiamondGui = {Enabled = false}
    local AutoBuyDiamondRange = {Value = 20}

    AutoBuyDiamond = vape.Categories.Utility:CreateModule({
        Name = "AutoBuyDiamondUpgrades",
        Function = function(call)
            if call then
                repeat task.wait()
                    if nearNPC(AutoBuyDiamondRange.Value) then
                        if (not AutoBuyDiamondGui.Enabled) or bedwars.AppController:isAppOpen("TeamUpgradeApp") then
                            if resolve[PreferredUpgrade.Value].CurrentUpgrade ~= 3 and getDiamonds() >= resolve[PreferredUpgrade.Value].Upgrades[resolve[PreferredUpgrade.Value].CurrentUpgrade + 1] then buyUpgrade(PreferredUpgrade.Value) end
                            for i,v in pairs(resolve) do if v.CurrentUpgrade ~= 3 and getDiamonds() >= v.Upgrades[v.CurrentUpgrade + 1] then buyUpgrade(i) end end
                        end
                    end
                until (not AutoBuyDiamond.Enabled)
            end
        end,
        Tooltip = "Auto buys diamond upgrades"
    })
    AutoBuyDiamond.Restart = function() if AutoBuyDiamond.Enabled then AutoBuyDiamond:Toggle(false); AutoBuyDiamond:Toggle(false) end end
    AutoBuyDiamondRange = AutoBuyDiamond:CreateSlider({
        Name = "Range",
        Function = function() end,
        Min = 1,
        Max = 20,
        Default = 20
    })
    local real_list = {}
    for i,v in pairs(resolve) do table.insert(real_list, tostring(i)) end
    PreferredUpgrade = AutoBuyDiamond:CreateDropdown({
        Name = "PreferredUpgrade",
        Function = AutoBuyDiamond.Restart,
        List = real_list,
        Default = "Damage"
    })
    AutoBuyDiamondGui = AutoBuyDiamond:CreateToggle({
        Name = "Gui Check",
        Function = AutoBuyDiamond.Restart
    })
end)

run(function()
	local AutoConsume = {Enabled = false}
	local AutoConsumeStar = {Enabled = false}
	local AutoConsumeHealth = {Value = 100}
	local AutoConsumeSpeed = {Enabled = true}
	local AutoConsumeDelay = tick()

	local function AutoConsumeFunc()
		if entityLibrary.isAlive then
			local speedpotion = getItem("speed_potion")
			if lplr.Character:GetAttribute("Health") <= (lplr.Character:GetAttribute("MaxHealth") - (100 - AutoConsumeHealth.Value)) then
				autobankapple = true
				local item = getItem("apple")
				local pot = getItem("heal_splash_potion")
				if (item or pot) and AutoConsumeDelay <= tick() then
					if item then
						bedwars.Client:Get(bedwars.EatRemote):InvokeServer({
							item = item.tool
						})
						AutoConsumeDelay = tick() + 0.6
					else
						--[[local newray = game.Workspace:Raycast((oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, Vector3.new(0, -70, 0), store.blockRaycast)
						print("newray: ", tostring(newray))
						if newray ~= nil then
							local res = bedwars.Client:Get(bedwars.ProjectileRemote):InvokeServer(pot.tool, "heal_splash_potion", "heal_splash_potion", (oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, (oldcloneroot or entityLibrary.character.HumanoidRootPart).Position, Vector3.new(0, -70, 0), game:GetService("HttpService"):GenerateGUID(), {drawDurationSeconds = 1})
							print("res: ", tostring(res))
						end--]]
					end
				end
			else
				autobankapple = false
			end
			local starItem = AutoConsumeStar.Enabled and (getItem("vitality_star") or getItem("crit_star"))
			if starItem then
				bedwars.Client:Get(bedwars.EatRemote):InvokeServer({
					item = starItem.tool
				})
			end
			if speedpotion and (not lplr.Character:GetAttribute("StatusEffect_speed")) and AutoConsumeSpeed.Enabled then
				bedwars.Client:Get(bedwars.EatRemote):InvokeServer({
					item = speedpotion.tool
				})
			end
			if lplr.Character:GetAttribute("Shield_POTION") and ((not lplr.Character:GetAttribute("Shield_POTION")) or lplr.Character:GetAttribute("Shield_POTION") == 0) then
				local shield = getItem("big_shield") or getItem("mini_shield")
				if shield then
					bedwars.Client:Get(bedwars.EatRemote):InvokeServer({
						item = shield.tool
					})
				end
			end
		end
	end

	AutoConsume = vape.Categories.Blatant:CreateModule({
		Name = "AutoConsume",
		Function = function(callback)
			if callback then
				AutoConsume:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(AutoConsumeFunc))
				AutoConsume:Clean(vapeEvents.AttributeChanged.Event:Connect(function(changed)
					if changed:find("Shield") or changed:find("Health") or changed:find("speed") then
						AutoConsumeFunc()
					end
				end))
				task.spawn(function()
					repeat task.wait(1)
						AutoConsumeFunc()
					until (not AutoConsume.Enabled)
				end)
				AutoConsumeFunc()
			end
		end,
		Tooltip = "Automatically heals for you when health or shield is under threshold."
	})
	AutoConsume.Restart = function() if AutoConsume.Enabled then AutoConsume:Toggle(false); AutoConsume:Toggle(false) end end
	AutoConsumeStar = AutoConsume:CreateToggle({
		Name = "Auto Consume Stars",
		Function = AutoConsumeStar.Restart,
		Default = true
	})
	AutoConsumeStar.Object.Visible = (store.equippedKit == "star_collector")
	AutoConsumeHealth = AutoConsume:CreateSlider({
		Name = "Health",
		Min = 1,
		Max = 99,
		Default = 70,
		Function = function() end
	})
	AutoConsumeSpeed = AutoConsume:CreateToggle({
		Name = "Speed Potions",
		Function = function() end,
		Default = true
	})
end)

local sendmessage = function() end
sendmessage = function(text)
	local function createBypassMessage(message)
		local charMappings = {
			["a"] = "ɑ", ["b"] = "ɓ", ["c"] = "ɔ", ["d"] = "ɗ", ["e"] = "ɛ",
			["f"] = "ƒ", ["g"] = "ɠ", ["h"] = "ɦ", ["i"] = "ɨ", ["j"] = "ʝ",
			["k"] = "ƙ", ["l"] = "ɭ", ["m"] = "ɱ", ["n"] = "ɲ", ["o"] = "ɵ",
			["p"] = "ρ", ["q"] = "ɋ", ["r"] = "ʀ", ["s"] = "ʂ", ["t"] = "ƭ",
			["u"] = "ʉ", ["v"] = "ʋ", ["w"] = "ɯ", ["x"] = "x", ["y"] = "ɣ",
			["z"] = "ʐ", ["A"] = "Α", ["B"] = "Β", ["C"] = "Ϲ", ["D"] = "Δ",
			["E"] = "Ε", ["F"] = "Ϝ", ["G"] = "Γ", ["H"] = "Η", ["I"] = "Ι",
			["J"] = "ϳ", ["K"] = "Κ", ["L"] = "Λ", ["M"] = "Μ", ["N"] = "Ν",
			["O"] = "Ο", ["P"] = "Ρ", ["Q"] = "Ϙ", ["R"] = "Ϣ", ["S"] = "Ϛ",
			["T"] = "Τ", ["U"] = "ϒ", ["V"] = "ϝ", ["W"] = "Ω", ["X"] = "Χ",
			["Y"] = "Υ", ["Z"] = "Ζ"
		}
		local bypassMessage = ""
		for i = 1, #message do
			local char = message:sub(i, i)
			bypassMessage = bypassMessage .. (charMappings[char] or char)
		end
		return bypassMessage
	end
	--text = text.." | discord.gg/voidware"
	--text = createBypassMessage(text)
	local textChatService = game:GetService("TextChatService")
	local replicatedStorageService = game:GetService("ReplicatedStorage")
	if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(text)
	else
		replicatedStorageService.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, 'All')
	end
end
getgenv().sendmessage = sendmessage

local bedTeamCache = {}
local function get_bed_team(id)
	if bedTeamCache[id] then
		return true, bedTeamCache[id]
	end
	local teamName = "Unknown"
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player ~= game:GetService("Players").LocalPlayer then
			if player:GetAttribute("Team") and tostring(player:GetAttribute("Team")) == tostring(id) then
				teamName = tostring(player.Team)
				break
			end
		end
	end
	bedTeamCache[id] = teamName
	return false, teamName
end

run(function()
	local AutoToxic
	local GG
	local Toggles, Lists, said, dead = {}, {}, {}
	
	local function sendMessage(name, obj, default)
		local tab = Lists[name].ListEnabled
		local custommsg = #tab > 0 and tab[math.random(1, #tab)] or default
		if not custommsg then return end
		if #tab > 1 and custommsg == said[name] then
			repeat 
				task.wait() 
				custommsg = tab[math.random(1, #tab)] 
			until custommsg ~= said[name]
		end
		said[name] = custommsg
	
		custommsg = custommsg and custommsg:gsub('<obj>', obj or '') or ''
		if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
		else
			replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, 'All')
		end
	end
	
	AutoToxic = vape.Categories.Utility:CreateModule({
		Name = 'AutoToxic',
		Function = function(callback)
			if callback then
				AutoToxic:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
					if Toggles.BedDestroyed.Enabled and bedTable.brokenBedTeam.id == lplr:GetAttribute('Team') then
						sendMessage('BedDestroyed', (bedTable.player.DisplayName or bedTable.player.Name), 'how dare you >:( | <obj>')
					elseif Toggles.Bed.Enabled and bedTable.player.UserId == lplr.UserId then
						local team = bedwars.QueueMeta[store.queueType].teams[tonumber(bedTable.brokenBedTeam.id)]
						sendMessage('Bed', team and team.displayName:lower() or 'white', 'nice bed lul | <obj>')
					end
				end))
				AutoToxic:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill then
						local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
						local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
						if not killed or not killer then return end
						if killed == lplr then
							if (not dead) and killer ~= lplr and Toggles.Death.Enabled then
								dead = true
								sendMessage('Death', (killer.DisplayName or killer.Name), 'my gaming chair subscription expired :( | <obj>')
							end
						elseif killer == lplr and Toggles.Kill.Enabled then
							sendMessage('Kill', (killed.DisplayName or killed.Name), 'vxp on top | <obj>')
						end
					end
				end))
				AutoToxic:Clean(vapeEvents.MatchEndEvent.Event:Connect(function(winstuff)
					if GG.Enabled then
						if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
							textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('gg')
						else
							replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('gg', 'All')
						end
					end
					
					local myTeam = bedwars.Store:getState().Game.myTeam
					if myTeam and myTeam.id == winstuff.winningTeamId or lplr.Neutral then
						if Toggles.Win.Enabled then 
							sendMessage('Win', nil, 'yall garbage') 
						end
					end
				end))
			end
		end,
		Tooltip = 'Says a message after a certain action'
	})
	GG = AutoToxic:CreateToggle({
		Name = 'AutoGG',
		Default = true
	})
	for _, v in {'Kill', 'Death', 'Bed', 'BedDestroyed', 'Win'} do
		Toggles[v] = AutoToxic:CreateToggle({
			Name = v..' ',
			Function = function(callback)
				if Lists[v] then
					Lists[v].Object.Visible = callback
				end
			end
		})
		Lists[v] = AutoToxic:CreateTextList({
			Name = v,
			Darker = true,
			Visible = false
		})
	end
end)

run(function()
	local ChestStealer = {Enabled = false}
	local ChestStealerDistance = {Value = 1}
	local ChestStealerDelay = {Value = 1}
	local ChestStealerOpen = {Enabled = false}
	local ChestStealerSkywars = {Enabled = true}
	local doneChests = {}
	local cheststealerdelays = {}
	local chests = {}
	local cheststealerfuncs = {
		Open = function()
			if bedwars.AppController:isAppOpen("ChestApp") then
				local chest = lplr.Character:FindFirstChild("ObservedChestFolder")
				if table.find(doneChests, chest) then return end
				table.insert(doneChests, chest)
				local chestitems = chest and chest.Value and chest.Value:GetChildren() or {}
				if #chestitems > 0 then
					for i3,v3 in pairs(chestitems) do
						if v3:IsA("Accessory") and (cheststealerdelays[v3] == nil or cheststealerdelays[v3] < tick()) then
							task.spawn(function()
								pcall(function()
									cheststealerdelays[v3] = tick() + 0.2
									bedwars.Client:GetNamespace("Inventory"):Get("ChestGetItem"):InvokeServer(chest.Value, v3)
								end)
							end)
							task.wait(ChestStealerDelay.Value / 100)
						end
					end
				end
			end
		end,
		Closed = function()
			for i, v in pairs(chests) do
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - v.Position).magnitude <= ChestStealerDistance.Value then
					local chest = v:FindFirstChild("ChestFolderValue")
					chest = chest and chest.Value or nil
					if table.find(doneChests, chest) then return end
					local chestitems = chest and chest:GetChildren() or {}
					if #chestitems > 0 then
						bedwars.Client:GetNamespace("Inventory"):Get("SetObservedChest"):FireServer(chest)
						for i3,v3 in pairs(chestitems) do
							task.wait(0.1)
							if v3:IsA("Accessory") and (cheststealerdelays[v3] == nil or cheststealerdelays[v3] < tick()) then
								task.spawn(function()
									pcall(function()
										cheststealerdelays[v3] = tick() + 0.2
										bedwars.Client:GetNamespace("Inventory"):Get("ChestGetItem"):InvokeServer(v.ChestFolderValue.Value, v3)
									end)
								end)
								task.wait(ChestStealerDelay.Value / 100)
							end
						end
						bedwars.Client:GetNamespace("Inventory"):Get("SetObservedChest"):FireServer(nil)
					end
					table.insert(doneChests, chest)
				end
			end
		end
	}

	ChestStealer = vape.Categories.Utility:CreateModule({
		Name = "Chest Stealer",
		Function = function(callback)
			if callback then
				chests = collectionService:GetTagged("chest")
				task.spawn(function()
					repeat task.wait(5)
						chests = collectionService:GetTagged("chest")
					until (not ChestStealer.Enabled)
				end)
				task.spawn(function()
					repeat task.wait() until store.matchState > 0
					repeat
						task.wait(0.4)
						if entityLibrary.isAlive then
							cheststealerfuncs[ChestStealerOpen.Enabled and "Open" or "Closed"]()
						end
					until (not ChestStealer.Enabled)
				end)
			else table.clear(doneChests) end
		end,
		Tooltip = "Grabs items from near chests."
	})
	ChestStealerDistance = ChestStealer:CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 18,
		Function = function() end,
		Default = 18
	})
	ChestStealerDelay = ChestStealer:CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Function = function() end,
		Default = 1,
		Double = 100
	})
	ChestStealerOpen = ChestStealer:CreateToggle({
		Name = "GUI Check",
		Function = function() end
	})
	--[[ChestStealerSkywars = ChestStealer:CreateToggle({
		Name = "Only Skywars",
		Function = function() end,
		Default = true
	})--]]
end)

local lagbackedaftertouch = false
run(function()
	local AntiVoidPart
	local AntiVoidConnection
	local AntiVoidMode = {Value = "Normal"}
	local AntiVoidMoveMode = {Value = "Normal"}
	local AntiVoid = {Enabled = false, Connections = {}}
	local AntiVoidTransparent = {Value = 50}
	local AntiVoidColor = {Hue = 1, Sat = 1, Value = 0.55}
	local lastvalidpos

	local GuiSync = {Enabled = false}

	local function closestpos(block)
		local startpos = block.Position - (block.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		local endpos = block.Position + (block.Size / 2) - Vector3.new(1.5, 1.5, 1.5)
		local newpos = block.Position + (entityLibrary.character.HumanoidRootPart.Position - block.Position)
		return Vector3.new(math.clamp(newpos.X, startpos.X, endpos.X), endpos.Y + 3, math.clamp(newpos.Z, startpos.Z, endpos.Z))
	end

	local function getclosesttop(newmag)
		local closest, closestmag = nil, newmag * 3
		if entityLibrary.isAlive then
			local tops = {}
			for i,v in pairs(store.blocks) do
				local close = getScaffold(closestpos(v), false)
				if getPlacedBlock(close) then continue end
				if close.Y < entityLibrary.character.HumanoidRootPart.Position.Y then continue end
				if (close - entityLibrary.character.HumanoidRootPart.Position).magnitude <= newmag * 3 then
					table.insert(tops, close)
				end
			end
			for i,v in pairs(tops) do
				local mag = (v - entityLibrary.character.HumanoidRootPart.Position).magnitude
				if mag <= closestmag then
					closest = v
					closestmag = mag
				end
			end
		end
		return closest
	end

	local antivoidypos = 20
	local antivoiding = false
	AntiVoid = vape.Categories.Utility:CreateModule({
		Name = "AntiVoid",
		Function = function(callback)
			if callback then
				task.spawn(function()
					AntiVoidPart = Instance.new("Part")
					AntiVoidPart.CanCollide = AntiVoidMode.Value == "Collide"
					AntiVoidPart.Size = Vector3.new(10000, 1, 10000)
					AntiVoidPart.Anchored = true
					AntiVoidPart.Material = Enum.Material.Neon
					AntiVoidPart.Color = Color3.fromHSV(AntiVoidColor.Hue, AntiVoidColor.Sat, AntiVoidColor.Value)
					AntiVoidPart.Transparency = 1 - (AntiVoidTransparent.Value / 100)
					AntiVoidPart.Position = Vector3.new(0, antivoidypos, 0)
					AntiVoidPart.Parent = game.Workspace
					if AntiVoidMoveMode.Value == "Classic" and antivoidypos == 0 then
						AntiVoidPart.Parent = nil
					end
					if GuiSync.Enabled then
						--AntiVoidPart.Color
						pcall(function()
							if shared.RiseMode and GuiLibrary.GUICoreColor and GuiLibrary.GUICoreColorChanged then
								AntiVoidPart.Color = GuiLibrary.GUICoreColor
								AntiVoid:Clean(GuiLibrary.GUICoreColorChanged.Event:Connect(function()
									if AntiVoid.Enabled and GuiSync.Enabled then
										AntiVoidPart.Color = GuiLibrary.GUICoreColor
									end
								end))
							else
								local color = vape.GUIColor
								AntiVoidPart.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
								AntiVoid:Clean(runservice.RenderStepped:Connect(function()
									if AntiVoid.Enabled then
										color = vape.GUIColor
										AntiVoidPart.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
									end
								end))
							end
						end)
					end
					AntiVoidConnection = AntiVoidPart.Touched:Connect(function(touchedpart)
						if touchedpart.Parent == lplr.Character and entityLibrary.isAlive then
							if (not antivoiding) and (not vape.Modules.Fly.Enabled) and entityLibrary.character.Humanoid.Health > 0 and AntiVoidMode.Value ~= "Collide" then
								if AntiVoidMode.Value == "Velocity" then
									entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(entityLibrary.character.HumanoidRootPart.Velocity.X, 100, entityLibrary.character.HumanoidRootPart.Velocity.Z)
								else
									antivoiding = true
									local pos = getclosesttop(1000)
									if pos then
										local lastTeleport = lplr:GetAttribute("LastTeleported")
										AntiVoid:Clean(runservice.Heartbeat:Connect(function(dt)
											if entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and isnetworkowner(entityLibrary.character.HumanoidRootPart) and (entityLibrary.character.HumanoidRootPart.Position - pos).Magnitude > 1 and AntiVoid.Enabled and lplr:GetAttribute("LastTeleported") == lastTeleport then
												local hori1 = Vector3.new(entityLibrary.character.HumanoidRootPart.Position.X, 0, entityLibrary.character.HumanoidRootPart.Position.Z)
												local hori2 = Vector3.new(pos.X, 0, pos.Z)
												local newpos = (hori2 - hori1).Unit
												local realnewpos = CFrame.new(newpos == newpos and entityLibrary.character.HumanoidRootPart.CFrame.p + (newpos * ((3 + getSpeed()) * dt)) or Vector3.zero)
												entityLibrary.character.HumanoidRootPart.CFrame = CFrame.new(realnewpos.p.X, pos.Y, realnewpos.p.Z)
												antivoidvelo = newpos == newpos and newpos * 20 or Vector3.zero
												entityLibrary.character.HumanoidRootPart.Velocity = Vector3.new(antivoidvelo.X, entityLibrary.character.HumanoidRootPart.Velocity.Y, antivoidvelo.Z)
												if getPlacedBlock((entityLibrary.character.HumanoidRootPart.CFrame.p - Vector3.new(0, 1, 0)) + entityLibrary.character.HumanoidRootPart.Velocity.Unit) or getPlacedBlock(entityLibrary.character.HumanoidRootPart.CFrame.p + Vector3.new(0, 3)) then
													pos = pos + Vector3.new(0, 1, 0)
												end
											else
												antivoidvelo = nil
												antivoiding = false
											end
										end))
									else
										entityLibrary.character.HumanoidRootPart.CFrame += Vector3.new(0, 100000, 0)
										antivoiding = false
									end
								end
							end
						end
					end)
					repeat
						if entityLibrary.isAlive and AntiVoidMoveMode.Value == "Normal" then
							local ray = game.Workspace:Raycast(entityLibrary.character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), store.blockRaycast)
							if ray or vape.Modules.Fly.Enabled or vape.Modules.InfiniteFly.Enabled then
								AntiVoidPart.Position = entityLibrary.character.HumanoidRootPart.Position - Vector3.new(0, 21, 0)
							end
						end
						task.wait()
					until (not AntiVoid.Enabled)
				end)
			else
				if AntiVoidConnection then AntiVoidConnection:Disconnect() end
				if AntiVoidPart then
					AntiVoidPart:Destroy()
				end
			end
		end,
		Tooltip = "Gives you a chance to get on land (Bouncing Twice, abusing, or bad luck will lead to lagbacks)"
	})
	AntiVoid.Restart = function() if AntiVoid.Enbaled then AntiVoid:Toggle(false); AntiVoid:Toggle(false) end end
	AntiVoidMoveMode = AntiVoid:CreateDropdown({
		Name = "Position Mode",
		Function = function(val)
			if val == "Classic" then
				task.spawn(function()
					repeat task.wait() until store.matchState ~= 0 or not vapeInjected
					if vapeInjected and AntiVoidMoveMode.Value == "Classic" and antivoidypos == 0 and AntiVoid.Enabled then
						local lowestypos = 99999
						for i,v in pairs(store.blocks) do
							local newray = game.Workspace:Raycast(v.Position + Vector3.new(0, 800, 0), Vector3.new(0, -1000, 0), store.blockRaycast)
							if i % 200 == 0 then
								task.wait(0.06)
							end
							if newray and newray.Position.Y <= lowestypos then
								lowestypos = newray.Position.Y
							end
						end
						antivoidypos = lowestypos - 8
					end
					if AntiVoidPart then
						AntiVoidPart.Position = Vector3.new(0, antivoidypos, 0)
						AntiVoidPart.Parent = game.Workspace
					end
				end)
			end
		end,
		List = {"Normal", "Classic"}
	})
	AntiVoidMode = AntiVoid:CreateDropdown({
		Name = "Move Mode",
		Function = function(val)
			if AntiVoidPart then
				AntiVoidPart.CanCollide = val == "Collide"
			end
		end,
		List = {"Normal", "Collide", "Velocity"}
	})
	AntiVoidTransparent = AntiVoid:CreateSlider({
		Name = "Invisible",
		Min = 1,
		Max = 100,
		Default = 50,
		Function = function(val)
			if AntiVoidPart then
				AntiVoidPart.Transparency = 1 - (val / 100)
			end
		end,
	})
	AntiVoidColor = AntiVoid:CreateColorSlider({
		Name = "Color",
		Function = function(h, s, v)
			if AntiVoidPart then
				AntiVoidPart.Color = Color3.fromHSV(h, s, v)
			end
		end
	})
	GuiSync = AntiVoid:CreateToggle({
		Name = "GUI Color Sync",
		Function = function(call)
			pcall(function() AntiVoidColor.Object.Visible = not call end)	
			AntiVoid.Restart()
		end
	})
end)

run(function()
	local Nuker = {Enabled = false}
	local nukerrange = {Value = 1}
	local nukerslowmode = {Value = 0.2}
	local nukereffects = {Enabled = false}
	local nukeranimation = {Enabled = false}
	local nukernofly = {Enabled = false}
	local nukerlegit = {Enabled = false}
	local nukerown = {Enabled = false}
	local nukerluckyblock = {Enabled = false}
	local nukerironore = {Enabled = false}
	local nukerbeds = {Enabled = false}
	local nukercustom = {RefreshValues = function() end, ObjectList = {}}
	local InstantBreak = {Enabled = false}
	local luckyblocktable = {}

	local hit = 0
	local customlist, parts = {}, {}

	Nuker = vape.Categories.World:CreateModule({
		Name = "Nuker",
		Function = function(callback)
			if callback then
				for _ = 1, 30 do
					local part = Instance.new('Part')
					part.Anchored = true
					part.CanQuery = false
					part.CanCollide = false
					part.Transparency = 1
					part.Parent = gameCamera
					local highlight = Instance.new('BoxHandleAdornment')
					highlight.Size = Vector3.one
					highlight.AlwaysOnTop = true
					highlight.ZIndex = 1
					highlight.Transparency = 0.5
					highlight.Adornee = part
					highlight.Parent = part
					table.insert(parts, part)
				end

				for i,v in pairs(store.blocks) do
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end
				Nuker:Clean(collectionService:GetInstanceAddedSignal("block"):Connect(function(v)
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end))
				Nuker:Clean(collectionService:GetInstanceRemovedSignal("block"):Connect(function(v)
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.remove(luckyblocktable, table.find(luckyblocktable, v))
					end
				end))
				task.spawn(function()
					repeat
						if (not nukernofly.Enabled or not vape.Modules.Fly.Enabled) then
							local broke = not entityLibrary.isAlive
							local tool = (not nukerlegit.Enabled) and {Name = "wood_axe"} or store.localHand.tool
							if nukerbeds.Enabled then
								for i, obj in pairs(collectionService:GetTagged("bed")) do
									if broke then break end
									if obj.Parent ~= nil then
										if tostring(obj:GetAttribute("TeamId")) == tostring(lplr:GetAttribute("Team")) then continue end 
										if obj:GetAttribute("BedShieldEndTime") then
											if obj:GetAttribute("BedShieldEndTime") > game.Workspace:GetServerTimeNow() then continue end
										end
										if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - obj.Position).magnitude <= nukerrange.Value then
											if tool and bedwars.ItemTable[tool.Name].breakBlock then
												local target, path, endpos = bedwars.breakBlock2(obj, nukeranimation.Enabled)
												if path then
													local currentnode = target
													for _, part in parts do
														part.Position = currentnode or Vector3.zero
														if currentnode then
															part.BoxHandleAdornment.Color3 = currentnode == endpos and Color3.new(1, 0.2, 0.2) or currentnode == target and Color3.new(0.2, 0.2, 1) or Color3.new(0.2, 1, 0.2)
														end
														currentnode = path[currentnode]
													end
												end
												task.wait(nukerslowmode.Value == 0 and (store.damageBlockFail > tick() and 4.5 or 0) or 0.25)
												break
											end
										end
									end
								end
							end
							broke = broke and not entityLibrary.isAlive
							for i, obj in pairs(luckyblocktable) do
								if broke then break end
								if entityLibrary.isAlive then
									if obj and obj.Parent ~= nil then
										if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - obj.Position).magnitude <= nukerrange.Value and (nukerown.Enabled or obj:GetAttribute("PlacedByUserId") ~= lplr.UserId) then
											if tool and bedwars.ItemTable[tool.Name].breakBlock then
												bedwars.breakBlock(obj, nukeranimation.Enabled)
												break
											end
										end
									end
								end
							end
						end
						task.wait()
					until (not Nuker.Enabled)
				end)
			else
				luckyblocktable = {}
				for _, v in parts do
					v:ClearAllChildren()
					v:Destroy()
				end
				table.clear(parts)
			end
		end,
		Tooltip = "Automatically destroys beds & luckyblocks around you."
	})
	InstantBreak = Nuker:CreateToggle({
		Name = "Instant Break",
		Function = function(call)
			if call then nukerslowmode.Value = 0 else nukerslowmode.Value = 2.5 end
		end
	})
	nukerrange = Nuker:CreateSlider({
		Name = "Break range",
		Min = 1,
		Max = 30,
		Function = function(val) end,
		Default = 30
	})
	nukerlegit = Nuker:CreateToggle({
		Name = "Hand Check",
		Function = function() end
	})
	--[[nukereffects = Nuker:CreateToggle({
		Name = "Show HealthBar & Effects",
		Function = function(callback)
			if not callback then
				bedwars.BlockBreaker.healthbarMaid:DoCleaning()
			end
		 end,
		Default = true
	})--]]
	nukeranimation = Nuker:CreateToggle({
		Name = "Break Animation",
		Function = function() end
	})
	nukerown = Nuker:CreateToggle({
		Name = "Self Break",
		Function = function() end,
	})
	nukerbeds = Nuker:CreateToggle({
		Name = "Break Beds",
		Function = function(callback) end,
		Default = true
	})
	nukernofly = Nuker:CreateToggle({
		Name = "Fly Disable",
		Function = function() end
	})
	nukerluckyblock = Nuker:CreateToggle({
		Name = "Break LuckyBlocks",
		Function = function(callback)
			if callback then
				luckyblocktable = {}
				for i,v in pairs(store.blocks) do
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end
			else
				luckyblocktable = {}
			end
		 end,
		Default = true
	})
	--[[nukerironore = Nuker:CreateToggle({
		Name = "Break IronOre",
		Function = function(callback)
			if callback then
				luckyblocktable = {}
				for i,v in pairs(store.blocks) do
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end
			else
				luckyblocktable = {}
			end
		end
	})--]]
	nukercustom = Nuker:CreateTextList({
		Name = "NukerList",
		TempText = "block (tesla_trap)",
		AddFunction = function()
			luckyblocktable = {}
			for i,v in pairs(store.blocks) do
				if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) then
					table.insert(luckyblocktable, v)
				end
			end
		end
	})
end)

run(function()
	local ChestESPList = {ObjectList = {}, RefreshList = function() end}
	local function nearchestitem(item)
		for i,v in next, (ChestESPList.ObjectList) do 
			if item:find(v) then return v end
		end
	end
	local function refreshAdornee(v)
		local chest = v.Adornee.ChestFolderValue.Value
		local chestitems = chest and chest:GetChildren() or {}
		for i2,v2 in next, (v.Frame:GetChildren()) do
			if v2:IsA('ImageLabel') then
				v2:Remove()
			end
		end
		v.Enabled = false
		local alreadygot = {}
		for itemNumber, item in next, (chestitems) do
			if alreadygot[item.Name] == nil and (table.find(ChestESPList.ObjectList, item.Name) or nearchestitem(item.Name)) then 
				alreadygot[item.Name] = true
				v.Enabled = true
				local blockimage = Instance.new('ImageLabel')
				blockimage.Size = UDim2.new(0, 32, 0, 32)
				blockimage.BackgroundTransparency = 1
				blockimage.Image = bedwars.getIcon({itemType = item.Name}, true)
				blockimage.Parent = v.Frame
			end
		end
	end

	local ChestESPFolder = Instance.new('Folder')
	ChestESPFolder.Name = 'ChestESPFolder'
	ChestESPFolder.Parent = vape.gui
	local ChestESP = {}
	local ChestESPBackground = {}

	local function chestfunc(v)
		task.spawn(function()
			local billboard = Instance.new('BillboardGui')
			billboard.Parent = ChestESPFolder
			billboard.Name = 'chest'
			billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
			billboard.Size = UDim2.new(0, 42, 0, 42)
			billboard.AlwaysOnTop = true
			billboard.Adornee = v
			local frame = Instance.new('Frame')
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = Color3.new(0, 0, 0)
			frame.BackgroundTransparency = ChestESPBackground.Enabled and 0.5 or 1
			frame.Parent = billboard
			local uilistlayout = Instance.new('UIListLayout')
			uilistlayout.FillDirection = Enum.FillDirection.Horizontal
			uilistlayout.Padding = UDim.new(0, 4)
			uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uilistlayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				billboard.Size = UDim2.new(0, math.max(uilistlayout.AbsoluteContentSize.X + 12, 42), 0, 42)
			end)
			uilistlayout.Parent = frame
			local uicorner = Instance.new('UICorner')
			uicorner.CornerRadius = UDim.new(0, 4)
			uicorner.Parent = frame
			local chest = v:WaitForChild('ChestFolderValue').Value
			if chest then 
				ChestESP:Clean(chest.ChildAdded:Connect(function(item)
					if table.find(ChestESPList.ObjectList, item.Name) or nearchestitem(item.Name) then 
						refreshAdornee(billboard)
					end
				end))
				ChestESP:Clean(chest.ChildRemoved:Connect(function(item)
					if table.find(ChestESPList.ObjectList, item.Name) or nearchestitem(item.Name) then 
						refreshAdornee(billboard)
					end
				end))
				refreshAdornee(billboard)
			end
		end)
	end

	ChestESP = vape.Categories.Utility:CreateModule({
		Name = 'Chest ESP',
		Function = function(calling)
			if calling then
				task.spawn(function()
					ChestESP:Clean(collectionService:GetInstanceAddedSignal('chest'):Connect(chestfunc))
					for i,v in next, (collectionService:GetTagged('chest')) do chestfunc(v) end
				end)
			else
				ChestESPFolder:ClearAllChildren()
			end
		end
	})
	ChestESPList = ChestESP:CreateTextList({
		Name = 'ItemList',
		TempText = 'item or part of item',
		AddFunction = function()
			if ChestESP.Enabled then 
				ChestESP:Toggle(false)
				ChestESP:Toggle(false)
			end
		end,
		RemoveFunction = function()
			if ChestESP.Enabled then 
				ChestESP:Toggle(false)
				ChestESP:Toggle(false)
			end
		end
	})
	ChestESPBackground = ChestESP:CreateToggle({
		Name = 'Background',
		Function = function()
			if ChestESP.Enabled then 
				ChestESP:Toggle(false)
				ChestESP:Toggle(false)
			end
		end,
		Default = true
	})
end)

run(function()
	local KitESP = {Enabled = false}
	local Background
	local Color
	local espobjs = {}
	local espfold = Instance.new("Folder")
	espfold.Parent = vape.gui

	local function espadd(v, icon)
		local billboard = Instance.new("BillboardGui")
		billboard.Parent = espfold
		billboard.Name = icon
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.Size = UDim2.fromOffset(36, 36)
		billboard.AlwaysOnTop = true
		billboard.Adornee = v
		local image = Instance.new("ImageLabel")
		image.BorderSizePixel = 0
		image.Image = bedwars.getIcon({itemType = icon}, true)
		image.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		image.BackgroundTransparency = 1 - (Background.Enabled and Color.Opacity or 0)
		image.Size = UDim2.fromOffset(36, 36)
		image.AnchorPoint = Vector2.new(0.5, 0.5)
		image.Parent = billboard
		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 4)
		uicorner.Parent = image
		espobjs[v] = billboard
	end

	local function addKit(tag, icon, custom)
		if (not custom) then
			KitESP:Clean(collectionService:GetInstanceAddedSignal(tag):Connect(function(v)
				espadd(v.PrimaryPart, icon)
			end))
			KitESP:Clean(collectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
				if espobjs[v.PrimaryPart] then
					espobjs[v.PrimaryPart]:Destroy()
					espobjs[v.PrimaryPart] = nil
				end
			end))
			for i,v in pairs(collectionService:GetTagged(tag)) do
				espadd(v.PrimaryPart, icon)
			end
		else
			local function check(v)
				if v.Name == tag and v.ClassName == "Model" then
					espadd(v.PrimaryPart, icon)
				end
			end
			KitESP:Clean(game.Workspace.ChildAdded:Connect(check))
			KitESP:Clean(game.Workspace.ChildRemoved:Connect(function(v)
				pcall(function()
					if espobjs[v.PrimaryPart] then
						espobjs[v.PrimaryPart]:Destroy()
						espobjs[v.PrimaryPart] = nil
					end
				end)
			end))
			for i,v in pairs(game.Workspace:GetChildren()) do
				check(v)
			end
		end
	end

	local esptbl = {
		["metal_detector"] = {
			{"hidden-metal", "iron"}
		},
		["beekeeper"] = {
			{"bee", "bee"}
		},
		["bigman"] = {
			{"treeOrb", "natures_essence_1"}
		},
		["alchemist"] = {
			{"Thorns", "thorns", true},
			{"Mushrooms", "mushrooms", true},
			{"Flower", "wild_flower", true}
		},
		["star_collector"] = {
			{"CritStar", "crit_star", true},
			{"VitalityStar", "vitality_star", true}
		},
		["spirit_gardener"] = {
			{"SpiritGardenerEnergy", "spirit", true}
		}
	}

	KitESP = vape.Categories.Utility:CreateModule({
		Name = "KitESP",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until store.equippedKit ~= ""
					if KitESP.Enabled then
						local p1 = esptbl[store.equippedKit]
						if (not p1) then return end
						for i,v in pairs(p1) do 
							addKit(unpack(v))
						end
					end
				end)
			else
				espfold:ClearAllChildren()
				table.clear(espobjs)
			end
		end
	})
	
	Background = KitESP:CreateToggle({
		Name = 'Background',
		Function = function(callback)
			if Color and Color.Object then Color.Object.Visible = callback end
			for _, v in espobjs do
				v.ImageLabel.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
				v.Blur.Visible = callback
			end
		end,
		Default = true
	})
	Color = KitESP:CreateColorSlider({
		Name = 'Background Color',
		DefaultValue = 0,
		DefaultOpacity = 0.5,
		Function = function(hue, sat, val, opacity)
			for _, v in espobjs do
				v.ImageLabel.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				v.ImageLabel.BackgroundTransparency = 1 - opacity
			end
		end,
		Darker = true
	})
end)

--VoidwareFunctions.GlobaliseObject("store", store)
VoidwareFunctions.GlobaliseObject("GlobalStore", store)

--VoidwareFunctions.GlobaliseObject("bedwars", bedwars)
VoidwareFunctions.GlobaliseObject("GlobalBedwars", bedwars)

VoidwareFunctions.GlobaliseObject("VapeBWLoaded", true)
local function createMonitoredTable(originalTable, onChange)
    local proxy = {}
    local mt = {
        __index = originalTable,
        __newindex = function(t, key, value)
            local oldValue = originalTable[key]
            originalTable[key] = value
            if onChange then
                onChange(key, oldValue, value)
            end
        end
    }
    setmetatable(proxy, mt)
    return proxy
end
local function onChange(key, oldValue, newValue)
   --print("Changed key:", key, "from", oldValue, "to", newValue)
   	--VoidwareFunctions.GlobaliseObject("store", store)
	VoidwareFunctions.GlobaliseObject("GlobalStore", store)
end
local function onChange2(key, oldValue, newValue)
	--print("Changed key:", key, "from", oldValue, "to", newValue)
	--VoidwareFunctions.GlobaliseObject("bedwars", bedwars)
	VoidwareFunctions.GlobaliseObject("GlobalBedwars", bedwars)
 end

store = createMonitoredTable(store, onChange)
bedwars = createMonitoredTable(bedwars, onChange2)

--if (not shared.CheatEngineMode) then pload("CustomModules/S6872274481.lua") end