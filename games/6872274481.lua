local run = function(func)
	if shared.VoidDev then
		func()
	else
		local suc, err = pcall(function() func() end)
		if (not suc) then errorNotification("Vape 4481", 'Failure executing function: '..tostring(err), 3); warn(debug.traceback(tostring(err))) end
	end
end
local cloneref = function(obj)
	return obj
end
local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new('BindableEvent')
		return self[index]
	end
})

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

local networkownerswitch = tick()
-- xylex ._.
local isnetworkowner = function(part)
	return true
	--[[local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()--]]
end
local gameCamera = game.Workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local entitylibrary = entitylib
local entityLibrary = entitylib
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
local getcustomassets = {
	['vape/assets/new/add.png'] = 'rbxassetid://14368300605',
	['vape/assets/new/alert.png'] = 'rbxassetid://14368301329',
	['vape/assets/new/allowedicon.png'] = 'rbxassetid://14368302000',
	['vape/assets/new/allowedtab.png'] = 'rbxassetid://14368302875',
	['vape/assets/new/arrowmodule.png'] = 'rbxassetid://14473354880',
	['vape/assets/new/back.png'] = 'rbxassetid://14368303894',
	['vape/assets/new/bind.png'] = 'rbxassetid://14368304734',
	['vape/assets/new/bindbkg.png'] = 'rbxassetid://14368305655',
	['vape/assets/new/blatanticon.png'] = 'rbxassetid://14368306745',
	['vape/assets/new/blockedicon.png'] = 'rbxassetid://14385669108',
	['vape/assets/new/blockedtab.png'] = 'rbxassetid://14385672881',
	['vape/assets/new/blur.png'] = 'rbxassetid://14898786664',
	['vape/assets/new/blurnotif.png'] = 'rbxassetid://16738720137',
	['vape/assets/new/close.png'] = 'rbxassetid://14368309446',
	['vape/assets/new/closemini.png'] = 'rbxassetid://14368310467',
	['vape/assets/new/colorpreview.png'] = 'rbxassetid://14368311578',
	['vape/assets/new/combaticon.png'] = 'rbxassetid://14368312652',
	['vape/assets/new/customsettings.png'] = 'rbxassetid://14403726449',
	['vape/assets/new/dots.png'] = 'rbxassetid://14368314459',
	['vape/assets/new/edit.png'] = 'rbxassetid://14368315443',
	['vape/assets/new/expandright.png'] = 'rbxassetid://14368316544',
	['vape/assets/new/expandup.png'] = 'rbxassetid://14368317595',
	['vape/assets/new/friendstab.png'] = 'rbxassetid://14397462778',
	['vape/assets/new/guisettings.png'] = 'rbxassetid://14368318994',
	['vape/assets/new/guislider.png'] = 'rbxassetid://14368320020',
	['vape/assets/new/guisliderrain.png'] = 'rbxassetid://14368321228',
	['vape/assets/new/guiv4.png'] = 'rbxassetid://14368322199',
	['vape/assets/new/guivape.png'] = 'rbxassetid://14657521312',
	['vape/assets/new/info.png'] = 'rbxassetid://14368324807',
	['vape/assets/new/inventoryicon.png'] = 'rbxassetid://14928011633',
	['vape/assets/new/legit.png'] = 'rbxassetid://14425650534',
	['vape/assets/new/legittab.png'] = 'rbxassetid://14426740825',
	['vape/assets/new/miniicon.png'] = 'rbxassetid://14368326029',
	['vape/assets/new/notification.png'] = 'rbxassetid://16738721069',
	['vape/assets/new/overlaysicon.png'] = 'rbxassetid://14368339581',
	['vape/assets/new/overlaystab.png'] = 'rbxassetid://14397380433',
	['vape/assets/new/pin.png'] = 'rbxassetid://14368342301',
	['vape/assets/new/profilesicon.png'] = 'rbxassetid://14397465323',
	['vape/assets/new/radaricon.png'] = 'rbxassetid://14368343291',
	['vape/assets/new/rainbow_1.png'] = 'rbxassetid://14368344374',
	['vape/assets/new/rainbow_2.png'] = 'rbxassetid://14368345149',
	['vape/assets/new/rainbow_3.png'] = 'rbxassetid://14368345840',
	['vape/assets/new/rainbow_4.png'] = 'rbxassetid://14368346696',
	['vape/assets/new/range.png'] = 'rbxassetid://14368347435',
	['vape/assets/new/rangearrow.png'] = 'rbxassetid://14368348640',
	['vape/assets/new/rendericon.png'] = 'rbxassetid://14368350193',
	['vape/assets/new/rendertab.png'] = 'rbxassetid://14397373458',
	['vape/assets/new/search.png'] = 'rbxassetid://14425646684',
	['vape/assets/new/expandicon.png'] = 'rbxassetid://14368353032',
	['vape/assets/new/targetinfoicon.png'] = 'rbxassetid://14368354234',
	['vape/assets/new/targetnpc1.png'] = 'rbxassetid://14497400332',
	['vape/assets/new/targetnpc2.png'] = 'rbxassetid://14497402744',
	['vape/assets/new/targetplayers1.png'] = 'rbxassetid://14497396015',
	['vape/assets/new/targetplayers2.png'] = 'rbxassetid://14497397862',
	['vape/assets/new/targetstab.png'] = 'rbxassetid://14497393895',
	['vape/assets/new/textguiicon.png'] = 'rbxassetid://14368355456',
	['vape/assets/new/textv4.png'] = 'rbxassetid://14368357095',
	['vape/assets/new/textvape.png'] = 'rbxassetid://14368358200',
	['vape/assets/new/utilityicon.png'] = 'rbxassetid://14368359107',
	['vape/assets/new/vape.png'] = 'rbxassetid://14373395239',
	['vape/assets/new/warning.png'] = 'rbxassetid://14368361552',
	['vape/assets/new/worldicon.png'] = 'rbxassetid://14368362492'
}
local getcustomasset = function(path)
	return getcustomassets[path] or ""
end

local store = {
	attackReach = 0,
	attackReachUpdate = tick(),
	damage = {},
	damageBlockFail = tick(),
	hand = {},
	localHand = {},
	inventory = {
		inventory = {
			items = {},
			armor = {}
		},
		hotbar = {}
	},
	inventories = {},
	matchState = 0,
	queueType = 'bedwars_test',
	tools = {}
}
local TweenService = game:GetService("TweenService")
local Reach = {}
local HitBoxes = {}
local InfiniteFly
local AntiVoidPart
local TrapDisabler
local bedwars, remotes, sides, oldinvrender = {}, {}, {}

local function addBlur(parent)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 89, 1, 52)
	blur.Position = UDim2.fromOffset(-48, -31)
	blur.BackgroundTransparency = 1
	blur.Image = getcustomasset('vape/assets/new/blur.png')
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(52, 31, 261, 502)
	blur.Parent = parent
	return blur
end

local CollectionService = game:GetService("CollectionService")

local function collection(tags, module, customadd, customremove)
    tags = typeof(tags) ~= 'table' and {tags} or tags
    local objs, connections = {}, {}

    for _, tag in tags do
        --print("Monitoring tag:", tag)
        table.insert(connections, CollectionService:GetInstanceAddedSignal(tag):Connect(function(v)
            --print("Added:", v, "to tag:", tag)
            if customadd then
                customadd(objs, v, tag)
                return
            end
            table.insert(objs, v)
        end))
        table.insert(connections, CollectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
            --print("Removed:", v, "from tag:", tag)
            if customremove then
                customremove(objs, v, tag)
                return
            end
            local index = table.find(objs, v)
            if index then
                table.remove(objs, index)
            end
        end))

        for _, v in CollectionService:GetTagged(tag) do
            --print("Initial object with tag", tag, ":", v)
            if customadd then
                customadd(objs, v, tag)
                continue
            end
            table.insert(objs, v)
        end
    end

    local cleanFunc = function()
        print("Cleaning up...")
        for _, v in connections do
            v:Disconnect()
        end
        table.clear(connections)
        table.clear(objs)
    end

    if module then
        --print("Module detected, but Clean not implemented:", module)
        -- module:Clean(cleanFunc)
    end
    return objs, cleanFunc
end

local function getBestArmor(slot)
	local closest, mag = nil, 0

	for _, item in store.inventory.inventory.items do
		local meta = item and bedwars.ItemMeta[item.itemType] or {}

		if meta.armor and meta.armor.slot == slot then
			local newmag = (meta.armor.damageReductionMultiplier or 0)

			if newmag > mag then
				closest, mag = item, newmag
			end
		end
	end

	return closest
end

local function getBow()
	local bestBow, bestBowSlot, bestBowDamage = nil, nil, 0
	for slot, item in store.inventory.inventory.items do
		local bowMeta = bedwars.ItemMeta[item.itemType].projectileSource
		if bowMeta and table.find(bowMeta.ammoItemTypes, 'arrow') then
			local bowDamage = bedwars.ProjectileMeta[bowMeta.projectileType('arrow')].combat.damage or 0
			if bowDamage > bestBowDamage then
				bestBow, bestBowSlot, bestBowDamage = item, slot, bowDamage
			end
		end
	end
	return bestBow, bestBowSlot
end

local function getItem(itemName, inv)
	for slot, item in (inv or store.inventory.inventory.items) do
		if item.itemType == itemName then
			return item, slot
		end
	end
	return nil
end

local function getClaw()
	for slot, item in store.inventory.inventory.items do
		if item.itemType and string.find(string.lower(tostring(item.itemType)), "summoner_claw") then
			return item, slot, 12
		end
	end
end

local function getSword()
	local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
	for slot, item in store.inventory.inventory.items do
		if store.equippedKit == "summoner" then
			return getClaw()
		end
		local swordMeta = bedwars.ItemMeta[item.itemType].sword
		if swordMeta then
			local swordDamage = swordMeta.damage or 0
			if swordDamage > bestSwordDamage then
				bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
			end
		end
	end
	return bestSword, bestSwordSlot
end

local function getTool(breakType)
	local bestTool, bestToolSlot, bestToolDamage = nil, nil, 0
	for slot, item in store.inventory.inventory.items do
		local toolMeta = bedwars.ItemMeta[item.itemType].breakBlock
		if toolMeta then
			local toolDamage = toolMeta[breakType] or 0
			if toolDamage > bestToolDamage then
				bestTool, bestToolSlot, bestToolDamage = item, slot, toolDamage
			end
		end
	end
	return bestTool, bestToolSlot
end

local function getWool()
	for _, wool in (inv or store.inventory.inventory.items) do
		if wool.itemType:find('wool') then
			return wool and wool.itemType, wool and wool.amount
		end
	end
end

local function getStrength(plr)
	if not plr.Player then
		return 0
	end
	local strength = 0
	for _, v in (store.inventories[plr.Player] or {items = {}}).items do
		local itemmeta = bedwars.ItemMeta[v.itemType]
		if itemmeta and itemmeta.sword and itemmeta.sword.damage > strength then
			strength = itemmeta.sword.damage
		end
	end
	return strength
end

local function getPlacedBlock(pos)
	if not pos then
		return
	end
	local roundedPosition = bedwars.BlockController:getBlockPosition(pos)
	return bedwars.BlockController:getStore():getBlockAt(roundedPosition), roundedPosition
end

local function getBlocksInPoints(s, e)
	local blocks, list = bedwars.BlockController:getStore(), {}
	for x = s.X, e.X do
		for y = s.Y, e.Y do
			for z = s.Z, e.Z do
				local vec = Vector3.new(x, y, z)
				if blocks:getBlockAt(vec) then
					table.insert(list, vec * 3)
				end
			end
		end
	end
	return list
end

local function getNearGround(range)
	range = Vector3.new(3, 3, 3) * (range or 10)
	local localPosition, mag, closest = entitylib.character.RootPart.Position, 60
	local blocks = getBlocksInPoints(bedwars.BlockController:getBlockPosition(localPosition - range), bedwars.BlockController:getBlockPosition(localPosition + range))

	for _, v in blocks do
		if not getPlacedBlock(v + Vector3.new(0, 3, 0)) then
			local newmag = (localPosition - v).Magnitude
			if newmag < mag then
				mag, closest = newmag, v + Vector3.new(0, 3, 0)
			end
		end
	end

	table.clear(blocks)
	return closest
end

local function getShieldAttribute(char)
	local returned = 0
	for name, val in char:GetAttributes() do
		if name:find('Shield') and type(val) == 'number' and val > 0 then
			returned += val
		end
	end
	return returned
end

local function getSpeed()
	local multi, increase, modifiers = 0, true, bedwars.SprintController:getMovementStatusModifier():getModifiers()

	for v in modifiers do
		local val = v.constantSpeedMultiplier and v.constantSpeedMultiplier or 0
		if val and val > math.max(multi, 1) then
			increase = false
			multi = val - (0.06 * math.round(val))
		end
	end

	for v in modifiers do
		multi += math.max((v.moveSpeedMultiplier or 0) - 1, 0)
	end

	if multi > 0 and increase then
		multi += 0.16 + (0.02 * math.round(multi))
	end

	return 20 * (multi + 1)
end

local function getTableSize(tab)
	local ind = 0
	for _ in tab do
		ind += 1
	end
	return ind
end

local function hotbarSwitch(slot)
	if slot and store.inventory.hotbarSlot ~= slot then
		bedwars.Store:dispatch({
			type = 'InventorySelectHotbarSlot',
			slot = slot
		})
		vapeEvents.InventoryChanged.Event:Wait()
		return true
	end
	return false
end

local function isFriend(plr, recolor)
	return nil
end

local function isTarget(plr)
	return nil
end

local function notif(...) return
	vape:CreateNotification(...)
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return (str:gsub('<[^<>]->', ''))
end

local function roundPos(vec)
	return Vector3.new(math.round(vec.X / 3) * 3, math.round(vec.Y / 3) * 3, math.round(vec.Z / 3) * 3)
end

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
			--warn("[findChild]: CHILD NOT FOUND! Args: ", game:GetService("HttpService"):JSONEncode(args), name, className, children)
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
		local res = bedwars.Client:Get(remotes.EquipItem):CallServerAsync({hand = tool})
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

    return true
end

local function switchItem(tool, delayTime)
	local _tool = lplr.Character and lplr.Character:FindFirstChild('HandInvItem') and lplr.Character:FindFirstChild('HandInvItem').Value or nil
	if _tool ~= nil and _tool ~= tool then
		coreswitch(tool, true)
		corehotbarswitch()
	end
end

local function waitForChildOfType(obj, name, timeout, prop)
	local check, returned = tick() + timeout
	repeat
		returned = prop and obj[name] or obj:FindFirstChildOfClass(name)
		if returned and returned.Name ~= 'UpperTorso' or check < tick() then
			break
		end
		task.wait()
	until false
	return returned
end

local frictionTable, oldfrict = {}, {}
local frictionConnection
local frictionState

local function modifyVelocity(v)
	if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' and not oldfrict[v] then
		oldfrict[v] = v.CustomPhysicalProperties or 'none'
		v.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.2, 0.5, 1, 1)
	end
end

local function updateVelocity(force)
	local newState = getTableSize(frictionTable) > 0
	if frictionState ~= newState or force then
		if frictionConnection then
			frictionConnection:Disconnect()
		end
		if newState then
			if entitylib.isAlive then
				for _, v in entitylib.character.Character:GetDescendants() do
					modifyVelocity(v)
				end
				frictionConnection = entitylib.character.Character.DescendantAdded:Connect(modifyVelocity)
			end
		else
			for i, v in oldfrict do
				i.CustomPhysicalProperties = v ~= 'none' and v or nil
			end
			table.clear(oldfrict)
		end
	end
	frictionState = newState
end

local kitorder = {
	hannah = 5,
	spirit_assassin = 4,
	dasher = 3,
	jade = 2,
	regent = 1
}

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

local HttpService = game:GetService("HttpService")
local function loadJson(path)
	local suc, res = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)
	return suc and type(res) == 'table' and res or nil, res
end
local function toTime(timestamp)
	timestamp = timestamp or os.time()
	local dateTable = os.date("*t", timestamp)
	local timeString = string.format("%02d:%02d:%02d", dateTable.hour, dateTable.min, dateTable.sec)
	return timeString
end
local function toDate(timestamp)
	timestamp = timestamp or os.time()
	local dateTable = os.date("*t", timestamp)
	local dateString = string.format("%02d/%02d/%02d", dateTable.day, dateTable.month, dateTable.year % 100)
	return dateString
end
local function getExecutionTime()
	return {["toTime"] = toTime(), ["toDate"] = toDate()}
end
local function saveErrorLog(err, S_Name)
	if not err then return end
	if not S_Name then S_Name = "Not specified" end
	local main = {}
	if isfile('VW_Error_Log.json') then
		local res = loadJson('VW_Error_Log.json')
		main = res or main
	end
	local errorLog = {
		Name = S_Name,
		CheatEngineMode = shared ~= nil and type(shared) == "table" and shared.CheatEngineMode,
		Response = tostring(err),
		Debug = debug.traceback(tostring(err)),
		PlaceId = game.PlaceId,
		JobId = game.JobId
	}
	main.DebugLog = main.DebugLog or {}
	main.DebugLog[toDate()] = main.DebugLog[toDate()] or {}
	main.DebugLog[toDate()][tostring(game.PlaceId).." | "..tostring(game.JobId)] = main[toDate()][tostring(game.PlaceId).." | "..tostring(game.JobId)] or {}
	main.DebugLog[toDate()][tostring(game.PlaceId).." | "..tostring(game.JobId)][S_Name] = main[toDate()][tostring(game.PlaceId).." | "..tostring(game.JobId)][S_Name] or {}
	table.insert(main.DebugLog[toDate()][tostring(game.PlaceId).." | "..tostring(game.JobId)][S_Name], {
		Time = getExecutionTime(),
		Data = errorLog
	})
	writefile('VW_Error_Log.json', HttpService:JSONEncode(main))
	errorNotification("Voidware -  Error Logger", 'If you can please send the\n VW_Error_Log.json file in your workspace to erchodev#0 or discord.gg/voidware', 10)
	warn('---------------[ERROR LOG START]--------------')
	warn(HttpService:JSONEncode(errorLog))
	warn('---------------[ERROR LOG END]--------------')
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

local bedwars2 = {}
bedwars2.Client = {}
local cache = {} 
local namespaceCache = {}

local function decorateRemote(remote, src)
	local isFunction = string.find(string.lower(remote.ClassName), "function")
	local isEvent = string.find(string.lower(remote.ClassName), "remoteevent")
	local isBindable = string.find(string.lower(remote.ClassName), "bindable")

	if isFunction then
		function src:CallServer(...)
			local args = {...}
			return remote:InvokeServer(unpack(args))
		end
	elseif isEvent then
		function src:CallServer(...)
			local args = {...}
			return remote:FireServer(unpack(args))
		end
	elseif isBindable then
		function src:CallServer(...)
			local args = {...}
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

local remotes_cache

function bedwars2.Client:Get(remName, customTable, resRequired, strict)
	if customTable ~= nil and customTable == 0 then 
		customTable = nil
		resRequired = nil
		strict = true
	end
    if cache[remName] then
        return cache[remName] 
    end
	remotes_cache = remotes_cache or getRemotes({"ReplicatedStorage"})
    local remotes = customTable or remotes_cache
    for _, v in pairs(remotes) do
        if (v.Name == remName) or ((not strict) and string.find(v.Name, remName)) then  
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

function bedwars2.Client:GetNamespace(nameSpace, blacklist)
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
        return bedwars2.Client:Get(remName, resolvedRemotes)
    end
    namespaceCache[cacheKey] = resolveFunctionTable 
    return resolveFunctionTable
end

function bedwars2.Client:WaitFor(remName)
	local tbl = {}
	function tbl:andThen(func)
		repeat task.wait() until bedwars2.Client:Get(remName)
		func(bedwars2.Client:Get(remName).OnClientEvent)
	end
	return tbl
end

run(function()
    local KnitInit, Knit
    repeat
        KnitInit, Knit = pcall(function()
            return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
        end)
        if KnitInit then break end
        task.wait()
    until KnitInit

    if not debug.getupvalue(Knit.Start, 1) then
        repeat task.wait() until debug.getupvalue(Knit.Start, 1)
    end

    local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
    local InventoryUtil = require(replicatedStorage.TS.inventory['inventory-util']).InventoryUtil
    local Client = require(replicatedStorage.TS.remotes).default.Client
    local OldGet, OldBreak = Client.Get

    local moduleDefinitions = {
		BlockEngineClientEvents = function() return require(replicatedStorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents end,
        AnimationType = function() return require(replicatedStorage.TS.animation['animation-type']).AnimationType end,
        AnimationUtil = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out['shared'].util['animation-util']).AnimationUtil end,
        AppController = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.controllers['app-controller']).AppController end,
        AbilityController = function() return Flamework.resolveDependency('@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController') end,
        BedwarsKitMeta = function() return require(replicatedStorage.TS.games.bedwars.kit['bedwars-kit-meta']).BedwarsKitMeta end,
        BlockBreaker = function() return Knit.Controllers.BlockBreakController.blockBreaker end,
        BlockController = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out).BlockEngine end,
        BlockPlacer = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.client.placement['block-placer']).BlockPlacer end,
        BlockEngine = function() return require(lplr.PlayerScripts.TS.lib['block-engine']['client-block-engine']).ClientBlockEngine end,
        BowConstantsTable = function() return debug.getupvalue(Knit.Controllers.ProjectileController.enableBeam, 8) end,
        ClickHold = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.ui.lib.util['click-hold']).ClickHold end,
        Client = function() return Client end,
        ClientConstructor = function() return require(replicatedStorage['rbxts_include']['node_modules']['@rbxts'].net.out.client) end,
        ClientDamageBlock = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.shared.remotes).BlockEngineRemotes.Client end,
        CombatConstant = function() return require(replicatedStorage.TS.combat['combat-constant']).CombatConstant end,
        DamageIndicator = function() return Knit.Controllers.DamageIndicatorController.spawnDamageIndicator end,
        DefaultKillEffect = function() return require(lplr.PlayerScripts.TS.controllers.game.locker['kill-effect'].effects['default-kill-effect']) end,
        EmoteType = function() return require(replicatedStorage.TS.locker.emote['emote-type']).EmoteType end,
        GameAnimationUtil = function() return require(replicatedStorage.TS.animation['animation-util']).GameAnimationUtil end,
        HudAliveCount = function() return require(lplr.PlayerScripts.TS.controllers.global['top-bar'].ui.game['hud-alive-player-counts']).HudAlivePlayerCounts end,
        ItemMeta = function() return debug.getupvalue(require(replicatedStorage.TS.item['item-meta']).getItemMeta, 1) end,
        KillEffectMeta = function() return require(replicatedStorage.TS.locker['kill-effect']['kill-effect-meta']).KillEffectMeta end,
        KillFeedController = function() return Flamework.resolveDependency('client/controllers/game/kill-feed/kill-feed-controller@KillFeedController') end,
        Knit = function() return Knit end,
        KnockbackUtil = function() return require(replicatedStorage.TS.damage['knockback-util']).KnockbackUtil end,
        NametagController = function() return Knit.Controllers.NametagController end,
        MatchEndScreenController = function() return Flamework.resolveDependency('client/controllers/game/match/match-end-screen-controller@MatchEndScreenController') end,
        MageKitUtil = function() return require(replicatedStorage.TS.games.bedwars.kit.kits.mage['mage-kit-util']).MageKitUtil end,
        ProjectileMeta = function() return require(replicatedStorage.TS.projectile['projectile-meta']).ProjectileMeta end,
        QueryUtil = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).GameQueryUtil end,
        QueueCard = function() return require(lplr.PlayerScripts.TS.controllers.global.queue.ui['queue-card']).QueueCard end,
        QueueMeta = function() return require(replicatedStorage.TS.game['queue-meta']).QueueMeta end,
        Roact = function() return require(replicatedStorage['rbxts_include']['node_modules']['@rbxts']['roact'].src) end,
        RuntimeLib = function() return require(replicatedStorage['rbxts_include'].RuntimeLib) end,
        SoundList = function() return require(replicatedStorage.TS.sound['game-sound']).GameSound end,
        SoundManager = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).SoundManager end,
        Store = function() return require(lplr.PlayerScripts.TS.ui.store).ClientStore end,
        TeamUpgradeMeta = function() return debug.getupvalue(require(replicatedStorage.TS.games.bedwars['team-upgrade']['team-upgrade-meta']).getTeamUpgradeMeta, 1) end,
        UILayers = function() return require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).UILayers end,
        VisualizerUtils = function() return require(lplr.PlayerScripts.TS.lib.visualizer['visualizer-utils']).VisualizerUtils end,
        WeldTable = function() return require(replicatedStorage.TS.util['weld-util']).WeldUtil end,
        WinEffectMeta = function() return require(replicatedStorage.TS.locker['win-effect']['win-effect-meta']).WinEffectMeta end,
    }

	local calculatePath = function() end
	local getBlockHealth = function() end
	local getBlockHits = function() end

	local cache, blockhealthbar = {}, {blockHealth = -1, breakingBlockPosition = Vector3.zero}

    bedwars = setmetatable({
        getIcon = function(item, showinv)
            local itemmeta = bedwars.ItemMeta[item.itemType]
            return itemmeta and showinv and itemmeta.image or ''
        end,
        getInventory = function(plr)
            local suc, res = pcall(function()
                return InventoryUtil.getInventory(plr)
            end)
            return suc and res or { items = {}, armor = {} }
        end,
        placeBlock = function(pos, item)
            if getItem(item) then
                store.blockPlacer.blockType = item
                return store.blockPlacer:placeBlock(bedwars.BlockController:getBlockPosition(pos))
            end
        end,
        breakBlock = function(block, effects, anim, customHealthbar)
            if lplr:GetAttribute('DenyBlockBreak') or not entitylib.isAlive or InfiniteFly.Enabled then return end
            local handler = bedwars.BlockController:getHandlerRegistry():getHandler(block.Name)
            local cost, pos, target, path = math.huge

            for _, v in (handler and handler:getContainedPositions(block) or {block.Position / 3}) do
                local dpos, dcost, dpath = calculatePath(block, v * 3)
                if dpos and dcost < cost then
                    cost, pos, target, path = dcost, dpos, v * 3, dpath
                end
            end

            if pos then
                if (entitylib.character.RootPart.Position - pos).Magnitude > 30 then return end
                local dblock, dpos = getPlacedBlock(pos)
                if not dblock then return end

                if (game.Workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.4 then
                    local breaktype = bedwars.ItemMeta[dblock.Name].block.breakType
                    local tool = store.tools[breaktype]
                    if tool then
                        switchItem(tool.tool)
                    end
                end

                if blockhealthbar.blockHealth == -1 or dpos ~= blockhealthbar.breakingBlockPosition then
                    blockhealthbar.blockHealth = getBlockHealth(dblock, dpos)
                    blockhealthbar.breakingBlockPosition = dpos
                end

                bedwars.ClientDamageBlock:Get('DamageBlock'):CallServerAsync({
                    blockRef = {blockPosition = dpos},
                    hitPosition = pos,
                    hitNormal = Vector3.FromNormalId(Enum.NormalId.Right)
                }):andThen(function(result)
                    if result then
                        if result == 'cancelled' then
                            store.damageBlockFail = tick() + 1
                            return
                        end

                        if effects then
                            local blockdmg = (blockhealthbar.blockHealth - (result == 'destroyed' and 0 or getBlockHealth(dblock, dpos)))
                            customHealthbar = customHealthbar or bedwars.BlockBreaker.updateHealthbar
                            customHealthbar(bedwars.BlockBreaker, {blockPosition = dpos}, blockhealthbar.blockHealth, dblock:GetAttribute('MaxHealth'), blockdmg, dblock)
                            blockhealthbar.blockHealth = math.max(blockhealthbar.blockHealth - blockdmg, 0)

                            if blockhealthbar.blockHealth <= 0 then
                                bedwars.BlockBreaker.breakEffect:playBreak(dblock.Name, dpos, lplr)
                                bedwars.BlockBreaker.healthbarMaid:DoCleaning()
                                blockhealthbar.breakingBlockPosition = Vector3.zero
                            else
                                bedwars.BlockBreaker.breakEffect:playHit(dblock.Name, dpos, lplr)
                            end
                        end

                        if anim then
                            local animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
                            bedwars.ViewmodelController:playAnimation(15)
                            task.wait(0.3)
                            animation:Stop()
                            animation:Destroy()
                        end
                    end
                end)

                if effects then
                    return pos, path, target
                end
            end
        end
    }, {
        __index = function(self, ind)
            if moduleDefinitions[ind] then
                local value = moduleDefinitions[ind]()
                rawset(self, ind, value)
                return value
            end
            local controller = Knit.Controllers[ind]
            if controller then
                rawset(self, ind, controller)
                return controller
            end
            return nil
        end
    })

	local function dumpRemote(tab)
        local ind
        for i, v in tab do
            if v == 'Client' then
                ind = i
                break
            end
        end
        return ind and tab[ind + 1] or ''
    end

    local remz = {
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
        BatteryRemote = "ConsumeBattery",
        DragonBreath = "DragonBreath",
        AckKnockback = "AckKnockback",
        MinerDig = "DestroyPetrifiedPlayer",
        ReportPlayer = "ReportPlayer",
        ResetCharacter = "ResetCharacter",
        HarvestCrop = "CropHarvest",
        PickUpBee = "PickUpBee",
        AfkStatus = "AfkInfo",
        WarlockTarget = "WarlockLinkTarget",
        SpawnRaven = "SpawnRaven",
        HannahKill = "HannahPromptTrigger",
        SummonerClawAttack = "SummonerClawAttackRequest",
        CryptGravestone = "ActivateGravestone",
        WhisperProjectile = "OwlFireProjectile"
    }

    local remoteDefinitions = {
        AttackEntity = function()
            local remote = dumpRemote(debug.getconstants(Knit.Controllers.SwordController.sendServerRequest))
            if remote == '' and shared.VoidDev then
                notif('Vape', 'Failed to grab remote (AttackEntity)', 10, 'alert')
            end
            return remote
        end,
        DepositPinata = function()
            local remote = dumpRemote(debug.getconstants(debug.getproto(debug.getproto(Knit.Controllers.PiggyBankController.KnitStart, 2), 5)))
            if remote == '' and shared.VoidDev then
                notif('Vape', 'Failed to grab remote (DepositPinata)', 10, 'alert')
            end
            return remote
        end,
        DragonEndFly = function()
            local remote = dumpRemote(debug.getconstants(debug.getproto(Knit.Controllers.VoidDragonController.flapWings, 1)))
            if remote == '' and shared.VoidDev then
                notif('Vape', 'Failed to grab remote (DragonEndFly)', 10, 'alert')
            end
            return remote
        end,
        DragonFly = function()
            local remote = dumpRemote(debug.getconstants(Knit.Controllers.VoidDragonController.flapWings))
            if remote == '' and shared.VoidDev then
                notif('Vape', 'Failed to grab remote (DragonFly)', 10, 'alert')
            end
            return remote
        end,
        DropItem = function()
            local remote = dumpRemote(debug.getconstants(Knit.Controllers.ItemDropController.dropItemInHand))
            if remote == '' and shared.VoidDev then
                notif('Vape', 'Failed to grab remote (DropItem)', 10, 'alert')
            end
            return remote
        end,
        MageSelect = function()
            local remote = dumpRemote(debug.getconstants(debug.getproto(Knit.Controllers.MageController.registerTomeInteraction, 1)))
            if remote == '' and shared.VoidDev then
                notif('Vape', 'Failed to grab remote (MageSelect)', 10, 'alert')
            end
            return remote
        end,
        AckKnockback = function() return bedwars2.Client:Get(remz.AckKnockback, 0) end,
        ConsumeBattery = function() return bedwars2.Client:Get(remz.BatteryRemote, 0) end,
        DragonBreath = function() return bedwars2.Client:Get(remz.DragonBreath, 0) end,
        KaliyahPunch = function() return bedwars2.Client:Get(remz.DragonRemote, 0) end,
        PickupMetal = function() return bedwars2.Client:Get(remz.PickupMetalRemote, 0) end,
        MinerDig = function() return bedwars2.Client:Get(remz.MinerDig, 0) end,
        ReportPlayer = function() return bedwars2.Client:Get(remz.ReportPlayer, 0) end,
        CannonAim = function() return bedwars2.Client:Get(remz.CannonAimRemote, 0) end,
        CannonLaunch = function() return bedwars2.Client:Get(remz.CannonLaunchRemote, 0) end,
        ConsumeItem = function() return bedwars2.Client:Get(remz.EatRemote, 0) end,
        GuitarHeal = function() return bedwars2.Client:Get(remz.GuitarHealRemote, 0) end,
        ResetCharacter = function() return bedwars2.Client:Get(remz.ResetCharacter, 0) end,
        EquipItem = function() return bedwars2.Client:Get(remz.EquipItemRemote, 0) end,
        PickupItem = function() return bedwars2.Client:Get(remz.PickupRemote, 0) end,
        HarvestCrop = function() return bedwars2.Client:Get(remz.HarvestCrop, 0) end,
        ConsumeSoul = function() return bedwars2.Client:Get(remz.ConsumeSoulRemote, 0) end,
        ConsumeTreeOrb = function() return bedwars2.Client:Get(remz.TreeRemote, 0) end,
        BeePickup = function() return bedwars2.Client:Get(remz.PickUpBee, 0) end,
        FireProjectile = function() return bedwars2.Client:Get(remz.ProjectileRemote, 0) end,
        AfkStatus = function() return bedwars2.Client:Get(remz.AfkStatus, 0) end,
        WarlockTarget = function() return bedwars2.Client:Get(remz.WarlockTarget, 0) end,
        SpawnRaven = function() return bedwars2.Client:Get(remz.SpawnRaven, 0) end,
        HannahKill = function() return bedwars2.Client:Get(remz.HannahKill, 0) end,
        SummonerClawAttack = function() return bedwars2.Client:Get(remz.SummonerClawAttack, 0) end,
        ActivateGravestone = function() return bedwars2.Client:Get(remz.CryptGravestone, 0) end,
        OwlFireProjectile = function() return bedwars2.Client:Get(remz.WhisperProjectile, 0) end
    }

    remotes = setmetatable({}, {
        __index = function(self, ind)
            if remoteDefinitions[ind] then
                local value = remoteDefinitions[ind]()
                rawset(self, ind, value)
                return value
            end
            return nil
        end
    })

    OldBreak = bedwars.BlockController.isBlockBreakable

    Client.Get = function(self, remoteName)
        if type(remoteName) == "table" then
            remoteName = remoteName.instance.Name
        end
        local call = OldGet(self, remoteName)
        if remoteName == remotes.AttackEntity then
            return {
                instance = call.instance,
                SendToServer = function(_, attackTable, ...)
                    local suc, plr = pcall(function()
                        return playersService:GetPlayerFromCharacter(attackTable.entityInstance)
                    end)

                    local selfpos = attackTable.validate.selfPosition.value
                    local targetpos = attackTable.validate.targetPosition.value
                    store.attackReach = ((selfpos - targetpos).Magnitude * 100) // 1 / 100
                    store.attackReachUpdate = tick() + 1

                    if Reach.Enabled or HitBoxes.Enabled then
                        attackTable.validate.raycast = attackTable.validate.raycast or {}
                        attackTable.validate.selfPosition.value += CFrame.lookAt(selfpos, targetpos).LookVector * math.max((selfpos - targetpos).Magnitude - 14.399, 0)
                    end

                    if suc and plr then
                        if not select(2, whitelist:get(plr)) then return end
                    end

                    return call:SendToServer(attackTable, ...)
                end
            }
        elseif remoteName == 'StepOnSnapTrap' and TrapDisabler.Enabled then
            return { SendToServer = function() end }
        end
        return call
    end

    bedwars.BlockController.isBlockBreakable = function(self, breakTable, plr)
        local obj = bedwars.BlockController:getStore():getBlockAt(breakTable.blockPosition)
        if obj and obj.Name == 'bed' then
            for _, plr in playersService:GetPlayers() do
                if obj:GetAttribute('Team'..(plr:GetAttribute('Team') or 0)..'NoBreak') and not select(2, whitelist:get(plr)) then
                    return false
                end
            end
        end
        return OldBreak(self, breakTable, plr)
    end

    store.blockPlacer = bedwars.BlockPlacer.new(bedwars.BlockEngine, 'wool_white')

   	getBlockHealth = function(block, blockpos)
        local blockdata = bedwars.BlockController:getStore():getBlockData(blockpos)
        return (blockdata and (blockdata:GetAttribute('1') or blockdata:GetAttribute('Health')) or block:GetAttribute('Health'))
    end

    getBlockHits = function(block, blockpos)
        if not block then return 0 end
        local breaktype = bedwars.ItemMeta[block.Name].block.breakType
        local tool = store.tools[breaktype]
        tool = tool and bedwars.ItemMeta[tool.itemType].breakBlock[breaktype] or 2
        return getBlockHealth(block, bedwars.BlockController:getBlockPosition(blockpos)) / tool
    end

    calculatePath = function(target, blockpos)
        if cache[blockpos] then
            return unpack(cache[blockpos])
        end
        local visited, unvisited, distances, air, path = {}, {{0, blockpos}}, {[blockpos] = 0}, {}, {}
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
            cache[blockpos] = { pos, cost, path }
            return pos, cost, path
        end
    end

    for _, v in Enum.NormalId:GetEnumItems() do
        table.insert(sides, Vector3.FromNormalId(v) * 3)
    end

    local function updateStore(new, old)
        if new.Bedwars ~= old.Bedwars then
            store.equippedKit = new.Bedwars.kit ~= 'none' and new.Bedwars.kit or ''
        end
        if new.Game ~= old.Game then
            store.matchState = new.Game.matchState
            store.queueType = new.Game.queueType or 'bedwars_test'
        end
        if new.Inventory ~= old.Inventory then
            local newinv = (new.Inventory and new.Inventory.observedInventory or {inventory = {}})
            local oldinv = (old.Inventory and old.Inventory.observedInventory or {inventory = {}})
            store.inventory = newinv
            store.localInventory = newinv
            if newinv ~= oldinv then
                vapeEvents.InventoryChanged:Fire()
            end
            if newinv.inventory.items ~= oldinv.inventory.items then
                vapeEvents.InventoryAmountChanged:Fire()
                store.tools.sword = getSword()
                for _, v in {'stone', 'wood', 'wool'} do
                    store.tools[v] = getTool(v)
                end
            end
            if newinv.inventory.hand ~= oldinv.inventory.hand then
                local currentHand, toolType = new.Inventory.observedInventory.inventory.hand, ''
                if currentHand then
                    local handData = bedwars.ItemMeta[currentHand.itemType]
                    toolType = handData.sword and 'sword' or handData.block and 'block' or currentHand.itemType:find('bow') and 'bow'
                end
                store.hand = {
                    tool = currentHand and currentHand.tool,
                    amount = currentHand and currentHand.amount or 0,
                    toolType = toolType
                }
                store.hand.itemType = store.tool and store.tool.Name
                store.localHand = store.hand
            end
        end
    end

    local storeChanged = bedwars.Store.changed:connect(updateStore)
    updateStore(bedwars.Store:getState(), {})

    task.spawn(function()
        pcall(function()
            for _, event in {'MatchEndEvent', 'EntityDeathEvent', 'EntityDamageEvent', 'BedwarsBedBreak', 'BalloonPopped', 'AngelProgress', 'GrapplingHookFunctions'} do
                if not vape.Connections then return end
                bedwars.Client:WaitFor(event):andThen(function(connection)
                    vape:Clean(connection:Connect(function(...)
                        vapeEvents[event]:Fire(...)
                    end))
                end)
            end
            for _, event in {'PlaceBlockEvent', 'BreakBlockEvent'} do
                bedwars.ClientDamageBlock:WaitFor(event):andThen(function(connection)
                    if not vape.Connections then return end
                    vape:Clean(connection:Connect(function(data)
                        for i, v in cache do
                            if ((data.blockRef.blockPosition * 3) - v[1]).Magnitude <= 30 then
                                table.clear(v[3])
                                table.clear(v)
                                cache[i] = nil
                            end
                        end
                        vapeEvents[event]:Fire(data)
                    end))
                end)
            end
        end)
    end)

    store.blocks = collection('block', gui)
    store.shop = collection({'BedwarsItemShop', 'TeamUpgradeShopkeeper'}, gui, function(tab, obj)
        table.insert(tab, {
            Id = obj.Name,
            RootPart = obj,
            Shop = obj:HasTag('BedwarsItemShop'),
            Upgrades = obj:HasTag('TeamUpgradeShopkeeper')
        })
    end)
    store.enchant = collection({'enchant-table', 'broken-enchant-table'}, gui, nil, function(tab, obj, tag)
        if obj:HasTag('enchant-table') and tag == 'broken-enchant-table' then return end
        obj = table.find(tab, obj)
        if obj then
            table.remove(tab, obj)
        end
    end)

    task.spawn(function()
        repeat
            if entitylib.isAlive then
                entitylib.character.AirTime = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and tick() or entitylib.character.AirTime
            end
            for _, v in entitylib.List do
                v.LandTick = math.abs(v.RootPart.Velocity.Y) < 0.1 and v.LandTick or tick()
                if (tick() - v.LandTick) > 0.2 and v.Jumps ~= 0 then
                    v.Jumps = 0
                    v.Jumping = false
                end
            end
            task.wait()
        until vape.Loaded == nil
    end)

    pcall(function()
        if getthreadidentity and setthreadidentity then
            local old = getthreadidentity()
            setthreadidentity(2)
            bedwars.Shop = require(replicatedStorage.TS.games.bedwars.shop['bedwars-shop']).BedwarsShop
            bedwars.ShopItems = debug.getupvalue(debug.getupvalue(bedwars.Shop.getShopItem, 1), 2)
            bedwars.Shop.getShopItem('iron_sword', lplr)
            setthreadidentity(old)
            store.shopLoaded = true
        else
            task.spawn(function()
                repeat
                    task.wait(0.1)
                until vape.Loaded == nil or bedwars.AppController:isAppOpen('BedwarsItemShopApp')
                bedwars.Shop = require(replicatedStorage.TS.games.bedwars.shop['bedwars-shop']).BedwarsShop
                bedwars.ShopItems = debug.getupvalue(debug.getupvalue(bedwars.Shop.getShopItem, 1), 2)
                store.shopLoaded = true
            end)
        end
    end)

    vape:Clean(function()
        Client.Get = OldGet
        bedwars.BlockController.isBlockBreakable = OldBreak
        store.blockPlacer:disable()
        for _, v in vapeEvents do
            v:Destroy()
        end
        for _, v in cache do
            table.clear(v[3])
            table.clear(v)
        end
        table.clear(store.blockPlacer)
        table.clear(vapeEvents)
        table.clear(bedwars)
        table.clear(store)
        table.clear(cache)
        table.clear(sides)
        table.clear(remotes)
        storeChanged:disconnect()
        storeChanged = nil
    end)
end)

local KaidaController = {}
function KaidaController:request(target)
	if target then 
		return bedwars2.Client:Get("SummonerClawAttackRequest"):FireServer({["clientTime"] = tick(), ["direction"] = (target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HumanoidRootPart").Position - lplr.Character.HumanoidRootPart.Position).unit, ["position"] = target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HumanoidRootPart").Position})
	else return nil end
end

if not bedwars.Client then
	errorNotification('Voidware Bedwars', "There was a critical loading error! \n Please report this issue to erchodev#0 or discord.gg/voidware", 10)
end
assert(bedwars.Client ~= nil and type(bedwars.Client) == "table", "There was a critical loading error! \n Please report this issue to erchodev#0 or discord.gg/voidware")

for _, v in {'ESP', 'Parkour', 'Music Player', 'Spin Bot', 'Desync', 'Weather', 'Trails', 'Fire', 'Disabler', 'Gravity', 'HighJump', 'AntiRagdoll', 'TriggerBot', 'SilentAim', 'PlayerModel', 'AutoRejoin', 'Panic', 'Rejoin', 'Timer', 'ServerHop', 'MouseTP', 'MurderMystery', 'Waypoints', 'Arrows', 'Tracers', 'Search', "GamingChair", "Health"} do
	vape:Remove(v)
end

--[[run(function()
	local DoubleHighJump = {Enabled = false}
	local DoubleHighJumpHeight = {Value = 500}
	local DoubleHighJumpHeight2 = {Value = 500}
	local jumps = 0
	DoubleHighJump = vape.Categories.Blatant:CreateModule({
		Name = "DoubleHighJump",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					if entityLibrary.isAlive and lplr.Character:WaitForChild("Humanoid").FloorMaterial == Enum.Material.Air or jumps > 0 then 
						DoubleHighJump:Toggle()
						return
					end
					for i = 1, 2 do 
						if not entityLibrary.isAlive then
							DoubleHighJump:Toggle()
							return  
						end
						if i == 2 and lplr.Character:WaitForChild("Humanoid").FloorMaterial ~= Enum.Material.Air then 
							continue
						end
						lplr.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0, i == 1 and DoubleHighJumpHeight.Value or DoubleHighJumpHeight2.Value, 0)
						jumps = i
						task.wait(i == 1 and 1 or 0.3)
					end
					task.spawn(function()
						for i = 1, 20 do 
							if entityLibrary.isAlive then 
								lplr.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Landed)
							end
						end
					end)
					task.delay(1.6, function() jumps = 0 end)
					if DoubleHighJump.Enabled then
					   DoubleHighJump:Toggle(false)
					end
				end)
			end
		end,
        Tooltip = "A very interesting high jump.",
	})
	DoubleHighJumpHeight = DoubleHighJump:CreateSlider({
		Name = "First Jump",
		Min = 50,
		Max = 500,
		Default = 500
	})
	DoubleHighJumpHeight2 = DoubleHighJump:CreateSlider({
		Name = "Second Jump",
		Min = 50,
		Max = 450,
		Default = 450
	})
end)--]]

run(function()
	local AutoClicker
	local CPS
	local BlockCPS = {}
	local Thread
	
	local function AutoClick()
		if Thread then
			task.cancel(Thread)
		end
	
		Thread = task.delay(1 / 7, function()
			repeat
				if not bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
					local blockPlacer = bedwars.BlockPlacementController.blockPlacer
					if store.hand.toolType == 'block' and blockPlacer then
						if (game.Workspace:GetServerTimeNow() - bedwars.BlockCpsController.lastPlaceTimestamp) >= ((1 / 12) * 0.5) then
							local mouseinfo = blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
							if mouseinfo and mouseinfo.placementPosition == mouseinfo.placementPosition then
								task.spawn(blockPlacer.placeBlock, blockPlacer, mouseinfo.placementPosition)
							end
						end
					elseif store.hand.toolType == 'sword' and bedwars.DaoController.chargingMaid == nil then
						bedwars.SwordController:swingSwordAtMouse()
					end
				end
	
				task.wait(1 / (store.hand.toolType == 'block' and BlockCPS or CPS).Value)
			until not AutoClicker.Enabled
		end)
	end
	
	AutoClicker = vape.Categories.Combat:CreateModule({
		Name = 'Auto Clicker',
		Function = function(callback)
			if callback then
				AutoClicker:Clean(inputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						AutoClick()
					end
				end))
	
				AutoClicker:Clean(inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Thread then
						task.cancel(Thread)
						Thread = nil
					end
				end))
	
				if inputService.TouchEnabled then
					pcall(function()
						AutoClicker:Clean(lplr.PlayerGui.MobileUI['2'].MouseButton1Down:Connect(AutoClick))
						AutoClicker:Clean(lplr.PlayerGui.MobileUI['2'].MouseButton1Up:Connect(function()
							if Thread then
								task.cancel(Thread)
								Thread = nil
							end
						end))
					end)
				end
			else
				if Thread then
					task.cancel(Thread)
					Thread = nil
				end
			end
		end,
		Tooltip = 'Hold attack button to automatically click'
	})
	CPS = AutoClicker:CreateSlider({
		Name = 'CPS',
		Min = 1,
		Max = 9,
        Default = 7
	})
	AutoClicker:CreateToggle({
		Name = 'Place Blocks',
		Default = true,
		Function = function(callback)
			if BlockCPS.Object then
				BlockCPS.Object.Visible = callback
			end
		end
	})
	BlockCPS = AutoClicker:CreateSlider({
		Name = 'Block CPS',
		Min = 1,
		Max = 12,
        Default = 12,
		Darker = true
	})
end)

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
					if entitylib.isAlive and store.hand.toolType == 'sword' and ((not ClickAim.Enabled) or (tick() - bedwars.SwordController.lastSwing) < 0.4) then
						local ent = KillauraTarget.Enabled and store.KillauraTarget or entitylib.EntityPosition({
							Range = Distance.Value,
							Part = 'RootPart',
							Wallcheck = Targets.Walls.Enabled,
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
							pcall(function()
								local plr = ent
								vapeTargetInfo.Targets.AimAssist = {
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
							targetinfo.Targets[ent] = tick() + 1
							gameCamera.CFrame = gameCamera.CFrame:Lerp(CFrame.lookAt(gameCamera.CFrame.p, ent.RootPart.Position), (AimSpeed.Value + (StrafeIncrease.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 10 or 0)) * dt)
						end
					end
				end))
			end
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
		Function = function() end
	})
	FirstPersonCheck = AimAssist:CreateToggle({
		Name = "First Person Check",
		Function = function() end,
		Default = false
	})
	StrafeIncrease = AimAssist:CreateToggle({Name = 'Strafe increase'})
end)

run(function()
	local Mode
	local Expand
	local objects, set = {}
	
	local function createHitbox(ent)
		if ent.Targetable and ent.Player then
			local hitbox = Instance.new('Part')
			hitbox.Size = Vector3.new(3, 6, 3) + Vector3.one * (Expand.Value / 5)
			hitbox.Position = ent.RootPart.Position
			hitbox.CanCollide = false
			hitbox.Massless = true
			hitbox.Transparency = 1
			hitbox.Parent = ent.Character
			local weld = Instance.new('Motor6D')
			weld.Part0 = hitbox
			weld.Part1 = ent.RootPart
			weld.Parent = hitbox
			objects[ent] = hitbox
		end
	end
	
	HitBoxes = vape.Categories.Combat:CreateModule({
		Name = 'Hit Boxes',
		Function = function(callback)
			if callback then
				if Mode.Value == 'Sword' then
					debug.setconstant(bedwars.SwordController.swingSwordInRegion, 6, (Expand.Value / 3))
					set = true
				else
					HitBoxes:Clean(entitylib.Events.EntityAdded:Connect(createHitbox))
					HitBoxes:Clean(entitylib.Events.EntityRemoving:Connect(function(ent)
						if objects[ent] then
							objects[ent]:Destroy()
							objects[ent] = nil
						end
					end))
					for _, ent in entitylib.List do
						createHitbox(ent)
					end
				end
			else
				if set then
					debug.setconstant(bedwars.SwordController.swingSwordInRegion, 6, 3.8)
					set = nil
				end
				for _, part in objects do
					part:Destroy()
				end
				table.clear(objects)
			end
		end,
		Tooltip = 'Expands attack hitbox'
	})
	Mode = HitBoxes:CreateDropdown({
		Name = 'Mode',
		List = {'Sword', 'Player'},
		Function = function()
			if HitBoxes.Enabled then
				HitBoxes:Toggle()
				HitBoxes:Toggle()
			end
		end,
		Tooltip = 'Sword - Increases the range around you to hit entities\nPlayer - Increases the players hitbox'
	})
	Expand = HitBoxes:CreateSlider({
		Name = 'Expand amount',
		Min = 0,
		Max = 14.4,
		Default = 14.4,
		Decimal = 10,
		Function = function(val)
			if HitBoxes.Enabled then
				if Mode.Value == 'Sword' then
					debug.setconstant(bedwars.SwordController.swingSwordInRegion, 6, (val / 3))
				else
					for _, part in objects do
						part.Size = Vector3.new(3, 6, 3) + Vector3.one * (val / 5)
					end
				end
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)

run(function()
	local Velocity
	local Horizontal
	local Vertical
	local Chance
	local TargetCheck
	local rand, old = Random.new()
	
	Velocity = vape.Categories.Combat:CreateModule({
		Name = 'Velocity',
		Function = function(callback)
			if callback then
				old = bedwars.KnockbackUtil.applyKnockback
				bedwars.KnockbackUtil.applyKnockback = function(root, mass, dir, knockback, ...)
					if rand:NextNumber(0, 100) > Chance.Value then return end
					local check = (not TargetCheck.Enabled) or entitylib.EntityPosition({
						Range = 50,
						Part = 'RootPart',
						Players = true
					})
	
					if check then
						knockback = knockback or {}
						if Horizontal.Value == 0 and Vertical.Value == 0 then return end
						knockback.horizontal = (knockback.horizontal or 1) * (Horizontal.Value / 100)
						knockback.vertical = (knockback.vertical or 1) * (Vertical.Value / 100)
					end
					
					return old(root, mass, dir, knockback, ...)
				end
			else
				bedwars.KnockbackUtil.applyKnockback = old
			end
		end,
		Tooltip = 'Reduces knockback taken'
	})
	Horizontal = Velocity:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Vertical = Velocity:CreateSlider({
		Name = 'Vertical',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Chance = Velocity:CreateSlider({
		Name = 'Chance',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
	TargetCheck = Velocity:CreateToggle({Name = 'Only when targeting'})
end)

run(function()
	local Value
	
	Reach = vape.Categories.Combat:CreateModule({
		Name = 'Reach',
		Function = function(callback)
			bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = callback and Value.Value + 2 or 14.4
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
				bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE = val + 2
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)

local Attacking
run(function()
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
		AttackRemote = bedwars.Client:Get(remotes.AttackEntity).instance
	end)

	local function createRangeCircle()
		local suc, err = pcall(function()
			if (not shared.CheatEngineMode) then
				RangeCirclePart = Instance.new("MeshPart")
				RangeCirclePart.MeshId = "rbxassetid://3726303797"
				vape.ColorConnect(function()
					pcall(function()
						RangeCirclePart.Color = vape.MainColor
					end)
				end)
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
			if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then return false end
		end

		local sword = Limit.Enabled and store.hand or store.tools.sword
		if not sword or not sword.tool then return false end

		local meta = bedwars.ItemMeta[sword.tool.Name]
		if Limit.Enabled then
			if store.hand.toolType ~= 'sword' or bedwars.DaoController.chargingMaid then return false end
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
					store.KillauraTarget = nil
					pcall(function() vapeTargetInfo.Targets.Killaura = nil end)
					if sword then
						local isClaw = string.find(string.lower(tostring(sword and sword.itemType or "")), "summoner_claw")
						local plrs = entitylib.AllPosition({
							Range = Range.Value,
							Wallcheck = Targets.Walls.Enabled or nil,
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
								local delta = (v.RootPart.Position - selfpos)
								local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
								if angle > (math.rad(AngleSlider.Value) / 2) then continue end

								table.insert(attacked, v)
								--targetinfo.Targets[v] = tick() + 1
								pcall(function()
									local plr = v
									targetinfo.Targets.Killaura = {
										Humanoid = {
											Health = (plr.Character:GetAttribute("Health") or plr.Humanoid.Health) + getShieldAttribute(plr.Character),
											MaxHealth = plr.Character:GetAttribute("MaxHealth") or plr.Humanoid.MaxHealth
										},
										Player = plr.Player
									}
								end)
								if not Attacking then
									Attacking = true
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
									store.attackReach = (delta.Magnitude * 100) // 1 / 100
									store.attackReachUpdate = tick() + 1
									if isClaw then
										KaidaController:request(v.Character)
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
						else
							targetinfo.Targets = {}
						end
					end

					pcall(function()
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
					end)

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
				debug.setupvalue(bedwars.SwordController.playSwordEffect, 6, bedwars.Knit)
				debug.setupvalue(bedwars.ScytheController.playLocalAnimation, 3, bedwars.Knit)
				Attacking = false
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

local LongJump
local Fly

run(function()
	local Value
	local CameraDir
	local start
	local JumpTick, JumpSpeed, Direction = tick(), 0
	local projectileRemote = {InvokeServer = function() end}
	task.spawn(function()
		projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
	end)
	
	local function launchProjectile(item, pos, proj, speed, dir)
		if not pos then return end
	
		pos = pos - dir * 0.1
		local shootPosition = (CFrame.lookAlong(pos, Vector3.new(0, -speed, 0)) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ)))
		switchItem(item.tool, 0)
		task.wait(0.1)
		bedwars.ProjectileController:createLocalProjectile(bedwars.ProjectileMeta[proj], proj, proj, shootPosition.Position, '', shootPosition.LookVector * speed, {drawDurationSeconds = 1})
		if projectileRemote:InvokeServer(item.tool, proj, proj, shootPosition.Position, pos, shootPosition.LookVector * speed, httpService:GenerateGUID(true), {drawDurationSeconds = 1}, workspace:GetServerTimeNow() - 0.045) then
			local shoot = bedwars.ItemMeta[item.itemType].projectileSource.launchSound
			shoot = shoot and shoot[math.random(1, #shoot)] or nil
			if shoot then
				bedwars.SoundManager:playSound(shoot)
			end
		end
	end
	
	local LongJumpMethods = {
		cannon = function(_, pos, dir)
			pos = pos - Vector3.new(0, (entitylib.character.HipHeight + (entitylib.character.RootPart.Size.Y / 2)) - 3, 0)
			local rounded = Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
			bedwars.placeBlock(rounded, 'cannon', false)
	
			task.delay(0, function()
				local block, blockpos = getPlacedBlock(rounded)
				if block and block.Name == 'cannon' and (entitylib.character.RootPart.Position - block.Position).Magnitude < 20 then
					local breaktype = bedwars.ItemMeta[block.Name].block.breakType
					local tool = store.tools[breaktype]
					if tool then
						switchItem(tool.tool)
					end
	
					bedwars.Client:Get(remotes.CannonAim):SendToServer({
						cannonBlockPos = blockpos,
						lookVector = dir
					})
	
					local broken = 0.1
					if bedwars.BlockController:calculateBlockDamage(lplr, {blockPosition = blockpos}) < block:GetAttribute('Health') then
						broken = 0.4
						bedwars.breakBlock(block, true, true)
					end
	
					task.delay(broken, function()
						for _ = 1, 3 do
							local call = bedwars.Client:Get(remotes.CannonLaunch):CallServer({cannonBlockPos = blockpos})
							if call then
								bedwars.breakBlock(block, true, true)
								JumpSpeed = 5.25 * Value.Value
								JumpTick = tick() + 2.3
								Direction = Vector3.new(dir.X, 0, dir.Z).Unit
								break
							end
							task.wait(0.1)
						end
					end)
				end
			end)
		end,
		cat = function(_, _, dir)
			LongJump:Clean(vapeEvents.CatPounce.Event:Connect(function()
				JumpSpeed = 4.5 * Value.Value
				JumpTick = tick() + 2.5
				Direction = Vector3.new(dir.X, 0, dir.Z).Unit
				entitylib.character.RootPart.Velocity = Vector3.zero
			end))
	
			if not bedwars.AbilityController:canUseAbility('CAT_POUNCE') then
				repeat task.wait() until bedwars.AbilityController:canUseAbility('CAT_POUNCE') or not LongJump.Enabled
			end
	
			if bedwars.AbilityController:canUseAbility('CAT_POUNCE') and LongJump.Enabled then
				bedwars.AbilityController:useAbility('CAT_POUNCE')
			end
		end,
		fireball = function(item, pos, dir)
			launchProjectile(item, pos, 'fireball', 60, dir)
			task.wait(0.05)
			JumpSpeed = 2 * Value.Value
			JumpTick = tick() + 1.5
			Direction = Vector3.new(dir.X, 0, dir.Z).Unit
		end,
		grappling_hook = function(item, pos, dir)
			launchProjectile(item, pos, 'grappling_hook_projectile', 140, dir)
		end,
		jade_hammer = function(item, _, dir)
			if not bedwars.AbilityController:canUseAbility(item.itemType..'_jump') then
				repeat task.wait() until bedwars.AbilityController:canUseAbility(item.itemType..'_jump') or not LongJump.Enabled
			end
	
			if bedwars.AbilityController:canUseAbility(item.itemType..'_jump') and LongJump.Enabled then
				bedwars.AbilityController:useAbility(item.itemType..'_jump')
				JumpSpeed = 2.5 * Value.Value
				JumpTick = tick() + 2.5
				Direction = Vector3.new(dir.X, 0, dir.Z).Unit
			end
		end,
		tnt = function(item, pos, dir)
			pos = pos - Vector3.new(0, (entitylib.character.HipHeight + (entitylib.character.RootPart.Size.Y / 2)) - 3, 0)
			local rounded = Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
			start = Vector3.new(rounded.X, start.Y, rounded.Z) + (dir * (item.itemType == 'pirate_gunpowder_barrel' and 2.6 or 0.2))
			bedwars.placeBlock(rounded, item.itemType, false)
		end,
		wood_dao = function(item, pos, dir)
			if (lplr.Character:GetAttribute('CanDashNext') or 0) > workspace:GetServerTimeNow() or not bedwars.AbilityController:canUseAbility('dash') then
				repeat task.wait() until (lplr.Character:GetAttribute('CanDashNext') or 0) < workspace:GetServerTimeNow() and bedwars.AbilityController:canUseAbility('dash') or not LongJump.Enabled
			end
	
			if LongJump.Enabled then
				bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
				switchItem(item.tool, 0.1)
				replicatedStorage['events-@easy-games/game-core:shared/game-core-networking@getEvents.Events'].useAbility:FireServer('dash', {
					direction = dir,
					origin = pos,
					weapon = item.itemType
				})
				JumpSpeed = 4.5 * Value.Value
				JumpTick = tick() + 2.4
				Direction = Vector3.new(dir.X, 0, dir.Z).Unit
			end
		end
	}
	for _, v in {'stone_dao', 'iron_dao', 'diamond_dao', 'emerald_dao'} do
		LongJumpMethods[v] = LongJumpMethods.wood_dao
	end
	LongJumpMethods.void_axe = LongJumpMethods.jade_hammer
	LongJumpMethods.siege_tnt = LongJumpMethods.tnt
	LongJumpMethods.pirate_gunpowder_barrel = LongJumpMethods.tnt
	
	LongJump = vape.Categories.Blatant:CreateModule({
		Name = 'Long Jump',
		Function = function(callback)
			frictionTable.LongJump = callback or nil
			updateVelocity()
			if callback then
				LongJump:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
					if damageTable.entityInstance == lplr.Character and damageTable.fromEntity == lplr.Character and (not damageTable.knockbackMultiplier or not damageTable.knockbackMultiplier.disabled) then
						local knockbackBoost = bedwars.KnockbackUtil.calculateKnockbackVelocity(Vector3.one, 1, {
							vertical = 0,
							horizontal = (damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal or 1)
						}).Magnitude * 1.1
	
						if knockbackBoost >= JumpSpeed then
							local pos = damageTable.fromPosition and Vector3.new(damageTable.fromPosition.X, damageTable.fromPosition.Y, damageTable.fromPosition.Z) or damageTable.fromEntity and damageTable.fromEntity.PrimaryPart.Position
							if not pos then return end
							local vec = (entitylib.character.RootPart.Position - pos)
							JumpSpeed = knockbackBoost
							JumpTick = tick() + 2.5
							Direction = Vector3.new(vec.X, 0, vec.Z).Unit
						end
					end
				end))
				LongJump:Clean(vapeEvents.GrapplingHookFunctions.Event:Connect(function(dataTable)
					if dataTable.hookFunction == 'PLAYER_IN_TRANSIT' then
						local vec = entitylib.character.RootPart.CFrame.LookVector
						JumpSpeed = 2.5 * Value.Value
						JumpTick = tick() + 2.5
						Direction = Vector3.new(vec.X, 0, vec.Z).Unit
					end
				end))
	
				start = entitylib.isAlive and entitylib.character.RootPart.Position or nil
				LongJump:Clean(runService.PreSimulation:Connect(function(dt)
					local root = entitylib.isAlive and entitylib.character.RootPart or nil
	
					if root and isnetworkowner(root) then
						if JumpTick > tick() then
							root.AssemblyLinearVelocity = Direction * (getSpeed() + ((JumpTick - tick()) > 1.1 and JumpSpeed or 0)) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
							if entitylib.character.Humanoid.FloorMaterial == Enum.Material.Air and not start then
								root.AssemblyLinearVelocity += Vector3.new(0, dt * (workspace.Gravity - 23), 0)
							else
								root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 15, root.AssemblyLinearVelocity.Z)
							end
							start = nil
						else
							if start then
								root.CFrame = CFrame.lookAlong(start, root.CFrame.LookVector)
							end
							root.AssemblyLinearVelocity = Vector3.zero
							JumpSpeed = 0
						end
					else
						start = nil
					end
				end))
	
				if store.hand and LongJumpMethods[store.hand.tool.Name] then
					task.spawn(LongJumpMethods[store.hand.tool.Name], getItem(store.hand.tool.Name), start, (CameraDir.Enabled and gameCamera or entitylib.character.RootPart).CFrame.LookVector)
					return
				end
	
				for i, v in LongJumpMethods do
					local item = getItem(i)
					if item or store.equippedKit == i then
						task.spawn(v, item, start, (CameraDir.Enabled and gameCamera or entitylib.character.RootPart).CFrame.LookVector)
						break
					end
				end
			else
				JumpTick = tick()
				Direction = nil
				JumpSpeed = 0
			end
		end,
		ExtraText = function()
			return 'Heatseeker'
		end,
		Tooltip = 'Lets you jump farther'
	})
	Value = LongJump:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 37,
		Default = 37,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	CameraDir = LongJump:CreateToggle({
		Name = 'Camera Direction'
	})
end)

run(function()
	local Sprint
	local old
	
	Sprint = vape.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then 
					pcall(function() 
						lplr.PlayerGui.MobileUI['4'].Visible = false 
					end) 
				end
				old = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local call = old(...)
					bedwars.SprintController:startSprinting()
					return call
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function() 
					task.delay(0.1, function() 
						bedwars.SprintController:stopSprinting() 
					end) 
				end))
				bedwars.SprintController:stopSprinting()
			else
				if inputService.TouchEnabled then 
					pcall(function() 
						lplr.PlayerGui.MobileUI['4'].Visible = true 
					end) 
				end
				bedwars.SprintController.stopSprinting = old
				bedwars.SprintController:stopSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)

run(function()
    local Desync = {Enabled = false}
    local RunService = vape.Services.RunService
    local InputService = vape.Services.InputService
    local LocalPlayer = vape.Services.Players.LocalPlayer
    local SetProperty = sethiddenproperty or function() end

    local function startDesync()
        task.spawn(function()
            while Desync.Enabled do
                task.wait()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local loop = RunService.Heartbeat:Connect(function()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
                        task.wait()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
                        task.wait()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
                        task.wait()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
                        task.wait()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
                        task.wait()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
                        task.wait()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
                        task.wait()
                        SetProperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true)
                        task.wait()
                    end)
                    task.wait()
                    if loop then
                        loop:Disconnect()
                    end
                end
            end
        end)
    end

    Desync = vape.Categories.Blatant:CreateModule({
        Name = "Desync",
        Function = function(callback)
            if callback then
                startDesync()
            end
        end,
        Tooltip = "Toggles network desync with a keybind, adjustable delay and interval"
    })

    Desync.Delay = Desync:CreateSlider({
        Name = "Delay",
        Min = 0,
        Max = 1000, 
        Default = 1,
        Suffix = function(val) return val .. "ms" end
    })

    Desync.Interval = Desync:CreateSlider({
        Name = "Interval",
        Min = 1,
        Max = 50,
        Default = 5,
        Suffix = function(val) return val .. "ms" end
    })
end) --- Credits to https://github.com/EphRex/ephram.lol/blob/858c4b48553210e7d69db7c7e98292e30e00b19c/desync.lua#L28

run(function()
	local Speed
	local Value
	local WallCheck
	local AutoJump
	local AlwaysJump
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	
	Speed = vape.Categories.Blatant:CreateModule({
		Name = 'Speed',
		Function = function(callback)
			frictionTable.Speed = callback or nil
			updateVelocity()
			pcall(function()
				debug.setconstant(bedwars.WindWalkerController.updateSpeed, 7, callback and 'constantSpeedMultiplier' or 'moveSpeedMultiplier')
			end)
	
			if callback then
				Speed:Clean(runService.PreSimulation:Connect(function(dt)
					bedwars.StatefulEntityKnockbackController.lastImpulseTime = callback and math.huge or time()
					if entitylib.isAlive and not Fly.Enabled and not InfiniteFly.Enabled and not LongJump.Enabled and isnetworkowner(entitylib.character.RootPart) then
						local state = entitylib.character.Humanoid:GetState()
						if state == Enum.HumanoidStateType.Climbing then return end
	
						local root, velo = entitylib.character.RootPart, getSpeed()
						local moveDirection = AntiVoidDirection or entitylib.character.Humanoid.MoveDirection
						local destination = (moveDirection * math.max(Value.Value - velo, 0) * dt)
	
						if WallCheck.Enabled then
							rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
							rayCheck.CollisionGroup = root.CollisionGroup
							local ray = workspace:Raycast(root.Position, destination, rayCheck)
							if ray then
								destination = ((ray.Position + ray.Normal) - root.Position)
							end
						end
	
						root.CFrame += destination
						root.AssemblyLinearVelocity = (moveDirection * velo) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
						if AutoJump.Enabled and (state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Landed) and moveDirection ~= Vector3.zero and (Attacking or AlwaysJump.Enabled) then
							entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end))
			end
		end,
		ExtraText = function()
			return 'Heatseeker'
		end,
		Tooltip = 'Increases your movement with various methods.'
	})
	Value = Speed:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 23,
		Default = 23,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	WallCheck = Speed:CreateToggle({
		Name = 'Wall Check',
		Default = true
	})
	AutoJump = Speed:CreateToggle({
		Name = 'AutoJump',
		Function = function(callback)
			AlwaysJump.Object.Visible = callback
		end
	})
	AlwaysJump = Speed:CreateToggle({
		Name = 'Always Jump',
		Visible = false,
		Darker = true
	})
end)

run(function()
	local Value
	local VerticalValue
	local WallCheck
	local PopBalloons
	local TP
	local lastonground = false
	local MobileButtons
	local FlyAnywayProgressBar = {Enabled = false}
	local FlyAnywayProgressBarFrame
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	local up, down, old = 0, 0
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

	Fly = vape.Categories.Blatant:CreateModule({
		Name = 'Fly',
		Function = function(callback)
			frictionTable.Fly = callback or nil
			updateVelocity()
			if callback then
				up, down, old = 0, 0, bedwars.BalloonController.deflateBalloon
				bedwars.BalloonController.deflateBalloon = function() end
				local tpTick, tpToggle, oldy = tick(), true

				if lplr.Character and (lplr.Character:GetAttribute('InflatedBalloons') or 0) == 0 and getItem('balloon') then
					bedwars.BalloonController:inflateBalloon()
				end

				Fly:Clean(vapeEvents.AttributeChanged.Event:Connect(function(changed)
					if changed == 'InflatedBalloons' and (lplr.Character:GetAttribute('InflatedBalloons') or 0) == 0 and getItem('balloon') then
						bedwars.BalloonController:inflateBalloon()
					end
				end))

				task.spawn(function()
					repeat
						task.wait()
						if entitylib.isAlive then
							entityLibrary.groundTick = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and tick() or entityLibrary.groundTick
						end
					until not Fly.Enabled
				end)

				Fly:Clean(runService.Heartbeat:Connect(function(delta)
					if entityLibrary.isAlive then
						local playerMass = (entityLibrary.character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						flyAllowed = ((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or store.matchState == 2 or megacheck) and 1 or 0
						playerMass = playerMass + (flyAllowed > 0 and 4 or 0) * (tick() % 0.4 < 0.2 and -1 or 1)

						if FlyAnywayProgressBarFrame then
							FlyAnywayProgressBarFrame.Visible = Fly.Enabled and flyAllowed <= 0
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
								FlyAnywayProgressBarFrame.Visible = Fly.Enabled and groundtime ~= nil
								if groundtime ~= nil then
									FlyAnywayProgressBarFrame.TextLabel.Text = math.max(onground and 2.5 or math.floor((groundtime - tick()) * 10) / 10, 0).."s"
								end
							end
							lastonground = onground
						else
							onground = true
							lastonground = true
						end
					end
				end))

				Fly:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive and not InfiniteFly.Enabled and isnetworkowner(entitylib.character.RootPart) then
						local flyAllowed = (lplr.Character:GetAttribute('InflatedBalloons') and lplr.Character:GetAttribute('InflatedBalloons') > 0) or store.matchState == 2
						local mass = (1.5 + (flyAllowed and 6 or 0) * (tick() % 0.4 < 0.2 and -1 or 1)) + ((up + down) * VerticalValue.Value)
						local root, moveDirection = entitylib.character.RootPart, entitylib.character.Humanoid.MoveDirection
						local velo = getSpeed()
						local destination = (moveDirection * math.max(Value.Value - velo, 0) * dt)
						rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera, AntiVoidPart}
						rayCheck.CollisionGroup = root.CollisionGroup

						if WallCheck.Enabled then
							local ray = workspace:Raycast(root.Position, destination, rayCheck)
							if ray then
								destination = ((ray.Position + ray.Normal) - root.Position)
							end
						end

						if FlyAnywayProgressBarFrame and not flyAllowed then
							FlyAnywayProgressBarFrame.Visible = true
							pcall(function() FlyAnywayProgressBarFrame.Frame:TweenSize(UDim2.new(1, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true) end)
						end

						if not flyAllowed then
							if tpToggle then
								local airleft = (tick() - entitylib.character.AirTime)
								if airleft > 2 then
									if not oldy then
										local ray = workspace:Raycast(root.Position, Vector3.new(0, -1000, 0), rayCheck)
										if ray and TP.Enabled then
											tpToggle = false
											oldy = root.Position.Y
											tpTick = tick() + 0.11
											root.CFrame = CFrame.lookAlong(Vector3.new(root.Position.X, ray.Position.Y + entitylib.character.HipHeight, root.Position.Z), root.CFrame.LookVector)
										end
									end
								end
							else
								if oldy and tpTick < tick() then
									local newpos = Vector3.new(root.Position.X, oldy, root.Position.Z)
									root.CFrame = CFrame.lookAlong(newpos, root.CFrame.LookVector)
									tpToggle = true
									oldy = nil
									entitylib.character.AirTime = tick()
								else
									mass = 0
								end
							end
						else
							tpToggle = true
							oldy = nil
						end

						root.CFrame += destination
						root.AssemblyLinearVelocity = (moveDirection * velo) + Vector3.new(0, mass, 0)
					end
				end))

				local isMobile = inputService.TouchEnabled and not inputService.KeyboardEnabled and not inputService.MouseEnabled
				local MobileEnabled = MobileButtons.Enabled or isMobile
				if MobileEnabled then
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

					Fly:Clean(upButton.MouseButton1Down:Connect(function()
						up = 1
					end))
					Fly:Clean(upButton.MouseButton1Up:Connect(function()
						up = 0
					end))
					Fly:Clean(downButton.MouseButton1Down:Connect(function()
						down = -1
					end))
					Fly:Clean(downButton.MouseButton1Up:Connect(function()
						down = 0
					end))
				end

				Fly:Clean(inputService.InputBegan:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
							up = 1
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							down = -1
						end
					end
				end))
				Fly:Clean(inputService.InputEnded:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
						up = 0
					elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
						down = 0
					end
				end))
				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						Fly:Clean(jumpButton:GetPropertyChangedSignal('ImageRectOffset'):Connect(function()
							if not mobileControls.UpButton then
								up = jumpButton.ImageRectOffset.X == 146 and 1 or 0
							end
						end))
					end)
				end
			else
				if FlyAnywayProgressBarFrame then
					FlyAnywayProgressBarFrame.Visible = false
				end
				lastonground = nil
				bedwars.BalloonController.deflateBalloon = old
				if PopBalloons.Enabled and entitylib.isAlive and (lplr.Character:GetAttribute('InflatedBalloons') or 0) > 0 then
					for _ = 1, 3 do
						bedwars.BalloonController:deflateBalloon()
					end
				end
				cleanupMobileControls()
			end
		end,
		ExtraText = function()
			return 'Heatseeker'
		end,
		Tooltip = 'Makes you go zoom.'
	})
	Value = Fly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 23,
		Default = 23,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	VerticalValue = Fly:CreateSlider({
		Name = 'Vertical Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	WallCheck = Fly:CreateToggle({
		Name = 'Wall Check',
		Default = true
	})
	PopBalloons = Fly:CreateToggle({
		Name = 'Pop Balloons',
		Default = true
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
	TP = Fly:CreateToggle({
		Name = 'TP Down',
		Default = true
	})
	MobileButtons = Fly:CreateToggle({
		Name = "Mobile Buttons",
		Function = function() 
			if Fly.Enabled then
				Fly:Toggle()
				Fly:Toggle()
			end
		end
	})
end)

run(function()
	local PickupRange
	local Range
	local Network
	local Lower
	
	PickupRange = vape.Categories.Render:CreateModule({
		Name = 'Item Physics',
		Function = function(callback)
			if callback then
				local items = collection('ItemDrop', PickupRange)
				repeat
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position
						for _, v in items do
							if tick() - (v:GetAttribute('ClientDropTime') or 0) < 2 then continue end
							if isnetworkowner(v) and Network.Enabled and entitylib.character.Humanoid.Health > 0 then 
								v.CFrame = CFrame.new(localPosition - Vector3.new(0, 3, 0)) 
							end
							
							if (localPosition - v.Position).Magnitude <= Range.Value then
								if Lower.Enabled and (localPosition.Y - v.Position.Y) < (entitylib.character.HipHeight - 1) then continue end
								task.spawn(function()
									bedwars.Client:Get(remotes.PickupItem):CallServerAsync({
										itemDrop = v
									}):andThen(function(suc)
										if suc and bedwars.SoundList then
											bedwars.SoundManager:playSound(bedwars.SoundList.PICKUP_ITEM_DROP)
											local sound = bedwars.ItemMeta[v.Name].pickUpOverlaySound
											if sound then
												bedwars.SoundManager:playSound(sound, {
													position = v.Position,
													volumeMultiplier = 0.9
												})
											end
										end
									end)
								end)
							end
						end
					end
					task.wait(0.1)
				until not PickupRange.Enabled
			end
		end,
		Tooltip = 'Picks up items from a farther distance'
	})
	Range = PickupRange:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 10,
		Default = 10,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	Network = PickupRange:CreateToggle({
		Name = 'Network TP',
		Default = true
	})
	Lower = PickupRange:CreateToggle({Name = 'Feet Check'})
end)

--[[run(function()
    local MotionBlur = {Enabled = false}
    local Power = {Value = 4}
    local BlurEffect = Instance.new("BlurEffect", vape.Services.Lighting)
    BlurEffect.Size = 0
    local CameraPosition = {}
    local function update()
        local CameraPosition = {X = gameCamera.CFrame.X, Z = gameCamera.CFrame.Z}
    end
    local function tween(obj, stat)
        vape.Services.TweenService:Create(obj, TweenInfo.new(1), stat):Play()
    end
    MotionBlur = vape.Categories.Render:CreateModule({
        Name = "MotionBlur",
        Function = function(call)
            if call then
                update()
                task.spawn(function()    
                    repeat task.wait()
                        local calc = (CameraPosition.X - gameCamera.CFrame.X) + (CameraPosition.Z - gameCamera.CFrame.Z)
                        if calc < 0 then
                            calc *= -1
                        end
                        if calc > 0.1 then
                            tween(blur, {Size = calc * Power.Value})
                        else
                            tween(blur, {Size = 0})
                        end
                        update()
                    until not MotionBlur.Enabled
                end)
            end
        end,
    })
    Power = MotionBlur:CreateSlider({
        Name = "Power",
        Min = 1,
        Max = 10,
        Default = 4
    })
end)--]]

run(function()
    local MotionBlur = {Enabled = false}
    local BaseBlurToggle = {Enabled = false}
    local BaseBlurIntensity = {Value = 10}
    local DynamicBlurToggle = {Enabled = false}
    local DynamicSensitivity = {Value = 0.5}
    local BlurMode = {Value = "Player Speed"}

    local Lighting = vape.Services.Lighting
    local RunService = vape.Services.RunService
    local Players = vape.Services.Players
    local LocalPlayer = Players.LocalPlayer
    local Camera = gameCamera

    local blurEffect = Lighting:FindFirstChild("MotionBlur") or Instance.new("BlurEffect")
    blurEffect.Name = "MotionBlur"
    blurEffect.Size = 0 
    blurEffect.Parent = Lighting

    local originalBlurSize = blurEffect.Size

    local function getPlayerSpeed()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            return rootPart.Velocity.Magnitude
        end
        return 0
    end

    local function getCameraSpeed()
        if not Camera then return 0 end
        local lastCFrame = Camera.CFrame
        task.wait(1/60)
        local currentCFrame = Camera.CFrame
        local delta = (currentCFrame.Position - lastCFrame.Position).Magnitude
        return delta * 60 
    end

    local function updateBlur()
        if MotionBlur.Enabled then
            local baseSize = BaseBlurToggle.Enabled and BaseBlurIntensity.Value or 0
            local dynamicSize = 0

            if DynamicBlurToggle.Enabled then
                local speed = 0
                if BlurMode.Value == "Player Speed" then
                    speed = getPlayerSpeed()
                elseif BlurMode.Value == "Camera Speed" then
                    speed = getCameraSpeed()
                end
                dynamicSize = math.clamp(speed * DynamicSensitivity.Value, 0, 50)
            end

            blurEffect.Size = math.clamp(baseSize + dynamicSize, 0, 50)
        else
            blurEffect.Size = 0
        end
    end

    MotionBlur = vape.Categories.Render:CreateModule({
        Name = "MotionBlur",
        Function = function(call)
            MotionBlur.Enabled = call
            if call then
                blurEffect.Enabled = true
                MotionBlur:Clean(RunService.Heartbeat:Connect(function()
                    updateBlur()
                end))
            else
                blurEffect.Size = 0
                blurEffect.Enabled = false
            end
        end,
        Tooltip = "Adds a motion blur effect based on movement or camera speed",
    })

    BaseBlurToggle = MotionBlur:CreateToggle({
        Name = "Base Blur",
        Function = function(call)
            BaseBlurToggle.Enabled = call
            if MotionBlur.Enabled then
                updateBlur()
            end
        end,
        Default = true
    })

    BaseBlurIntensity = MotionBlur:CreateSlider({
        Name = "Base Intensity",
        Min = 0,
        Max = 30,
        Default = 10,
        Function = function(val)
            BaseBlurIntensity.Value = val
            if BaseBlurToggle.Enabled and MotionBlur.Enabled then
                updateBlur()
            end
        end,
        Suffix = function(val) return val .. " units" end
    })

    DynamicBlurToggle = MotionBlur:CreateToggle({
        Name = "Dynamic Blur",
        Function = function(call)
            DynamicBlurToggle.Enabled = call
            if MotionBlur.Enabled then
                updateBlur()
            end
        end,
        Default = false
    })

    DynamicSensitivity = MotionBlur:CreateSlider({
        Name = "Dynamic Sensitivity",
        Min = 0,
        Max = 2,
        Default = 0.5,
        Function = function(val)
            DynamicSensitivity.Value = val
            if DynamicBlurToggle.Enabled and MotionBlur.Enabled then
                updateBlur()
            end
        end,
        Suffix = function(val) return string.format("%.2f", val) end
    })

    BlurMode = MotionBlur:CreateDropdown({
        Name = "Blur Mode",
        List = {"Player Speed", "Camera Speed", "Constant"},
        Function = function(val)
            BlurMode.Value = val
            if MotionBlur.Enabled then
                updateBlur()
            end
        end,
        Default = "Player Speed"
    })

    blurEffect.Size = 0
    blurEffect.Enabled = false
end)

run(function()
    vape.Categories.Render:CreateModule({
        Name = "Target Info",
        Function = function(call)
            vape.Settings.targetinfoenabled = call
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
	local FOV
	local Value
	local old, old2
	
	FOV = vape.Categories.Render:CreateModule({
		Name = 'FOV',
		Function = function(callback)
			if callback then
				old = bedwars.FovController.setFOV
				old2 = bedwars.FovController.getFOV
				bedwars.FovController.setFOV = function(self) 
					return old(self, Value.Value) 
				end
				bedwars.FovController.getFOV = function() 
					return Value.Value 
				end
			else
				bedwars.FovController.setFOV = old
				bedwars.FovController.getFOV = old2
			end
			
			bedwars.FovController:setFOV(bedwars.Store:getState().Settings.fov)
		end,
		Tooltip = 'Adjusts camera vision'
	})
	Value = FOV:CreateSlider({
		Name = 'FOV',
		Min = 30,
		Max = 120
	})
end)

run(function()
	local ChestSteal
	local Range
	local Open
	local Skywars
	local Delays = {}
	
	local function lootChest(chest)
		chest = chest and chest.Value or nil
		local chestitems = chest and chest:GetChildren() or {}
		if #chestitems > 1 and (Delays[chest] == nil or Delays[chest] < tick()) then
			Delays[chest] = tick() + 0.3
			bedwars.Client:GetNamespace('Inventory'):Get('SetObservedChest'):SendToServer(chest)
	
			for _, v in chestitems do
				if v:IsA('Accessory') then
					task.spawn(function()
						pcall(function()
							bedwars.Client:GetNamespace('Inventory'):Get('ChestGetItem'):CallServer(chest, v)
						end)
					end)
				end
			end
	
			bedwars.Client:GetNamespace('Inventory'):Get('SetObservedChest'):SendToServer(nil)
		end
	end
	
	ChestSteal = vape.Categories.Utility:CreateModule({
		Name = 'Chest Stealer',
		Function = function(callback)
			if callback then
				local chests = collection('chest', ChestSteal)
				repeat task.wait() until store.queueType ~= 'bedwars_test'
				if (not Skywars.Enabled) or store.queueType:find('skywars') then
					repeat
						if entitylib.isAlive and store.matchState ~= 2 then
							if Open.Enabled then
								if bedwars.AppController:isAppOpen('ChestApp') then
									lootChest(lplr.Character:FindFirstChild('ObservedChestFolder'))
								end
							else
								local localPosition = entitylib.character.RootPart.Position
								for _, v in chests do
									if (localPosition - v.Position).Magnitude <= Range.Value then
										lootChest(v:FindFirstChild('ChestFolderValue'))
									end
								end
							end
						end
						task.wait(0.1)
					until not ChestSteal.Enabled
				end
			end
		end,
		Tooltip = 'Grabs items from near chests.'
	})
	Range = ChestSteal:CreateSlider({
		Name = 'Range',
		Min = 0,
		Max = 18,
		Default = 18,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	Open = ChestSteal:CreateToggle({Name = 'GUI Check'})
	Skywars = ChestSteal:CreateToggle({
		Name = 'Only Skywars',
		Function = function()
			if ChestSteal.Enabled then
				ChestSteal:Toggle()
				ChestSteal:Toggle()
			end
		end,
		Default = true
	})
end)

--[[run(function()
	local PickupRange
	local Range
	local Network
	local Lower
	
	PickupRange = vape.Categories.Utility:CreateModule({
		Name = 'Insta Pickup',
		Function = function(callback)
			if callback then
				local items = collection('ItemDrop', PickupRange)
				repeat
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position
						for _, v in items do
							if tick() - (v:GetAttribute('ClientDropTime') or 0) < 2 then continue end
							if isnetworkowner(v) and Network.Enabled and entitylib.character.Humanoid.Health > 0 then 
								v.CFrame = CFrame.new(localPosition - Vector3.new(0, 3, 0)) 
							end
							
							if (localPosition - v.Position).Magnitude <= Range.Value then
								if Lower.Enabled and (localPosition.Y - v.Position.Y) < (entitylib.character.HipHeight - 1) then continue end
								task.spawn(function()
									bedwars.Client:Get(remotes.PickupItem):CallServerAsync({
										itemDrop = v
									}):andThen(function(suc)
										if suc and bedwars.SoundList then
											bedwars.SoundManager:playSound(bedwars.SoundList.PICKUP_ITEM_DROP)
											local sound = bedwars.ItemMeta[v.Name].pickUpOverlaySound
											if sound then
												bedwars.SoundManager:playSound(sound, {
													position = v.Position,
													volumeMultiplier = 0.9
												})
											end
										end
									end)
								end)
							end
						end
					end
					task.wait(0.1)
				until not PickupRange.Enabled
			end
		end,
		Tooltip = 'Picks up items from a farther distance'
	})
	Range = PickupRange:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 10,
		Default = 10,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	Network = PickupRange:CreateToggle({
		Name = 'Network TP',
		Default = true
	})
	Lower = PickupRange:CreateToggle({Name = 'Feet Check'})
end)--]]

local AntiVoidDirection
run(function()
	local AntiVoid
	local Mode
	local Material
	local Color
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true

	local function getLowGround()
		local mag = math.huge
		for _, pos in bedwars.BlockController:getStore():getAllBlockPositions() do
			pos = pos * 3
			if pos.Y < mag and not getPlacedBlock(pos + Vector3.new(0, 3, 0)) then
				mag = pos.Y
			end
		end
		return mag
	end

	AntiVoid = vape.Categories.Utility:CreateModule({
		Name = 'AntiVoid',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.matchState ~= 0 or (not AntiVoid.Enabled)
				if not AntiVoid.Enabled then return end

				local pos, debounce = getLowGround(), tick()
				if pos ~= math.huge then
					AntiVoidPart = Instance.new('Part')
					AntiVoidPart.Size = Vector3.new(10000, 1, 10000)
					AntiVoidPart.Transparency = 1 - Color.Opacity
					AntiVoidPart.Material = Enum.Material[Material.Value]
					AntiVoidPart.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
					AntiVoidPart.Position = Vector3.new(0, pos - 2, 0)
					AntiVoidPart.CanCollide = Mode.Value == 'Collide'
					AntiVoidPart.Anchored = true
					AntiVoidPart.CanQuery = false
					AntiVoidPart.Parent = workspace
					AntiVoid:Clean(AntiVoidPart)
					AntiVoid:Clean(AntiVoidPart.Touched:Connect(function(touched)
						if touched.Parent == lplr.Character and entitylib.isAlive and debounce < tick() then
							debounce = tick() + 0.1
							if Mode.Value == 'Normal' then
								local top = getNearGround()
								if top then
									local lastTeleport = lplr:GetAttribute('LastTeleported')
									local connection
									connection = runService.PreSimulation:Connect(function()
										if vape.Modules.Fly.Enabled or vape.Modules.InfiniteFly.Enabled or vape.Modules.LongJump.Enabled then
											connection:Disconnect()
											AntiVoidDirection = nil
											return
										end

										if entitylib.isAlive and lplr:GetAttribute('LastTeleported') == lastTeleport then
											local delta = ((top - entitylib.character.RootPart.Position) * Vector3.new(1, 0, 1))
											local root = entitylib.character.RootPart
											AntiVoidDirection = delta.Unit == delta.Unit and delta.Unit or Vector3.zero
											root.Velocity *= Vector3.new(1, 0, 1)
											rayCheck.FilterDescendantsInstances = {gameCamera, lplr.Character}
											rayCheck.CollisionGroup = root.CollisionGroup

											local ray = workspace:Raycast(root.Position, AntiVoidDirection, rayCheck)
											if ray then
												for _ = 1, 10 do
													local dpos = roundPos(ray.Position + ray.Normal * 1.5) + Vector3.new(0, 3, 0)
													if not getPlacedBlock(dpos) then
														top = Vector3.new(top.X, pos.Y, top.Z)
														break
													end
												end
											end

											root.CFrame += Vector3.new(0, top.Y - root.Position.Y, 0)
											if not frictionTable.Speed then
												root.AssemblyLinearVelocity = (AntiVoidDirection * getSpeed()) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
											end

											if delta.Magnitude < 1 then
												connection:Disconnect()
												AntiVoidDirection = nil
											end
										else
											connection:Disconnect()
											AntiVoidDirection = nil
										end
									end)
									AntiVoid:Clean(connection)
								end
							elseif Mode.Value == 'Velocity' then
								entitylib.character.RootPart.Velocity = Vector3.new(entitylib.character.RootPart.Velocity.X, 100, entitylib.character.RootPart.Velocity.Z)
							end
						end
					end))
				end
			else
				AntiVoidDirection = nil
			end
		end,
		Tooltip = 'Help\'s you with your Parkinson\'s\nPrevents you from falling into the void.'
	})
	Mode = AntiVoid:CreateDropdown({
		Name = 'Move Mode',
		List = {'Normal', 'Collide', 'Velocity'},
		Function = function(val)
			if AntiVoidPart then
				AntiVoidPart.CanCollide = val == 'Collide'
			end
		end,
	Tooltip = 'Normal - Smoothly moves you towards the nearest safe point\nVelocity - Launches you upward after touching\nCollide - Allows you to walk on the part'
	})
	local materials = {'ForceField'}
	for _, v in Enum.Material:GetEnumItems() do
		if v.Name ~= 'ForceField' then
			table.insert(materials, v.Name)
		end
	end
	Material = AntiVoid:CreateDropdown({
		Name = 'Material',
		List = materials,
		Function = function(val)
			if AntiVoidPart then
				AntiVoidPart.Material = Enum.Material[val]
			end
		end
	})
	Color = AntiVoid:CreateColorSlider({
		Name = 'Color',
		DefaultOpacity = 0.5,
		Function = function(h, s, v, o)
			if AntiVoidPart then
				AntiVoidPart.Color = Color3.fromHSV(h, s, v)
				AntiVoidPart.Transparency = 1 - o
			end
		end
	})
end)

run(function()
	local FastDrop
	
	FastDrop = vape.Categories.Utility:CreateModule({
		Name = 'FastDrop',
		Function = function(callback)
			if callback then
				repeat
					if entitylib.isAlive and (not store.inventory.opened) and (inputService:IsKeyDown(Enum.KeyCode.H) or inputService:IsKeyDown(Enum.KeyCode.Backspace)) and inputService:GetFocusedTextBox() == nil then
						task.spawn(bedwars.ItemDropController.dropItemInHand)
						task.wait()
					else
						task.wait(0.1)
					end
				until not FastDrop.Enabled
			end
		end,
		Tooltip = 'Drops items fast when you hold Q'
	})
end)

run(function()
	vape.Categories.Utility:CreateModule({
		Name = 'Anti AFK',
		Function = function(callback)
			if callback then
				for _, v in getconnections(lplr.Idled) do
					pcall(function()
						v:Disconnect()
					end)
				end
	
				for _, v in getconnections(runService.Heartbeat) do
					pcall(function()
						if type(v.Function) == 'function' and table.find(debug.getconstants(v.Function), remotes.AfkStatus) then
							pcall(function() v:Disconnect() end)
						end
					end)
				end
	
				bedwars.Client:Get(remotes.AfkStatus):SendToServer({
					afk = false
				})
			end
		end,
		Tooltip = 'Lets you stay ingame without getting kicked'
	})
end)

local function encode(tbl)
    return game:GetService("HttpService"):JSONEncode(tbl)
end
local function decode(tbl)
    return game:GetService("HttpService"):JSONDecode(tbl)
end
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
local autobankapple = false
run(function()
	bedwars.ShopItemsMeta = decode(VoidwareFunctions.fetchCheatEngineSupportFile("ShopItemsMeta.json"))
	bedwars.ShopItems = bedwars.ShopItemsMeta.ShopItems
	local AutoBuy = {Enabled = false}
	local AutoBuyArmor = {Enabled = false}
	local AutoBuySword = {Enabled = false}
	local AutoBuyGen = {Enabled = false}
	local AutoBuyAxolotl = {Enabled = false}
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

	local axolotls = {
		[1] = "shield_axolotl",
		[2] = "damage_axolotl",
		[3] = "break_speed_axolotl",
		[4] = "health_regen_axolotl"
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
		res = bedwars2.Client:Get("BedwarsPurchaseItem"):InvokeServer({
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

	local function metafyAxolotl(name)
		local data = {
			["ShieldAxolotl"] = "shield_axolotl",
			["DamageAxolotl"] = "damage_axolotl",
			["BreakSpeedAxolotl"] = "break_speed_axolotl",
			["HealthRegenAxolotl"] = "health_regen_axolotl"
		}
		return data[name] or ""
	end

	local function getAxolotls()
		local res = {}
		local data_folder = workspace:FindFirstChild("AxolotlModel")
		if not data_folder then return res, true end

		for i,v in pairs(data_folder:GetChildren()) do
			if v.ClassName ~= "Model" then continue end
			local owner = v:FindFirstChild("AxolotlData")
			if not owner then continue end
			if owner.ClassName ~= "ObjectValue" then continue end
			if not owner.Value then continue end
			if tostring(owner.Value) == lplr.Name.."_Axolotl" then
				table.insert(res, {
					axolotlType = v.Name,
					name = metafyAxolotl(v.Name)
				})
			end
		end

		return res
	end

	local function getAxolotl(metaName, inv)
		for i,v in pairs(inv) do
			if v.name == metaName then return v end
		end
		return nil
	end

	local buyfunctions = {
		Armor = function(inv, upgrades, shoptype)
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
		end,
		Axolotl = function(inv, upgrades, shoptype)
			if store.equippedKit ~= "axolotl" then return end
			if not AutoBuyAxolotl.Enabled then return end

			local inv = store.localInventory.inventory
			local inv_axolotls, abort = getAxolotls()
			if abort then return end

			local tableToDo = axolotls

			local axolotlindex = 0
			for i,v in pairs(axolotls) do
				if getAxolotl(v, inv_axolotls) then
					axolotlindex = i
				end
			end
			axolotlindex = axolotlindex + 1

			local highestbuyable = nil
			for i = axolotlindex, #tableToDo, 1 do
				local shopitem = getShopItem(axolotls[i])
				if shopitem and i == axolotlindex then
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
							elseif store.equippedKit == "pyro" then
								swords[6] = "flamethrower"
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
	AutoBuyAxolotl = AutoBuy:CreateToggle({
		Name = "Buy Axolotl",
		Function = function() end,
		Default = true
	})
	AutoBuyAxolotl.Object.Visible = false
	task.spawn(function()
		repeat task.wait() until store.equippedKit ~= ""
		AutoBuyAxolotl.Object.Visible = store.equippedKit == "axolotl"
	end)
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
        for _, item in pairs(store.inventory.inventory.items) do
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

run(function()
    local BlockIn = {}
	local HandCheck = {Enabled = false}
    
    local PatternArchitect = {}
    PatternArchitect.__index = PatternArchitect
    
    function PatternArchitect.new()
        local self = setmetatable({}, PatternArchitect)
        self.fixedPattern = {
            Vector3.new(3, 0, 0),
            Vector3.new(0, 0, 3),
            Vector3.new(-3, 0, 0),
            Vector3.new(0, 0, -3),
            Vector3.new(3, 3, 0),
            Vector3.new(0, 3, 3),
            Vector3.new(-3, 3, 0),
            Vector3.new(0, 3, -3),
            Vector3.new(0, 6, 0)
        }
        return self
    end
    
    function PatternArchitect:GenerateAdaptiveBlueprint(origin)
        local blueprint = {}
        for i, offset in ipairs(self.fixedPattern) do
            blueprint[i] = origin + offset
        end
        return blueprint
    end
    
    local BlockStrategist = {}
    BlockStrategist.__index = BlockStrategist
    
    function BlockStrategist.new()
        local self = setmetatable({}, BlockStrategist)
        self.cache = nil
        return self
    end
    
    function BlockStrategist:EvaluateInventory(inventory)
        if self.cache then return self.cache end
        
        local blocks = {}
        for _, item in pairs(inventory) do
            local meta = bedwars.ItemMeta[item.itemType]
            if meta.block then
                blocks[#blocks + 1] = {itemType = item.itemType, score = meta.block.health or 0}
            end
        end
        table.sort(blocks, function(a, b) return a.score < b.score end)
        self.cache = blocks
        return blocks
    end
    
    function BlockStrategist:ResetCache()
        self.cache = nil
    end
    
    BlockIn = vape.Categories.Utility:CreateModule({
        Name = 'BlockIn',
        Function = function(callback)
            if not callback then return end
            
            if not entitylib.isAlive or not entitylib.character or not entitylib.character.RootPart then
                errorNotification('BlockIn', 'Unable to initialize BlockIn: Player data missing', 5)
                BlockIn:Toggle()
                return
            end

			if HandCheck.Enabled then
				if not (store.hand and store.hand.toolType == "block") then
					errorNotification("BlockIn | Hand Check", "You aren't holding a block!", 1.5)
					BlockIn:Toggle()
					return
				end
			end
            
            local architect = PatternArchitect.new()
            local strategist = BlockStrategist.new()
            
            local origin = entitylib.character.RootPart.Position
            local blocks = strategist:EvaluateInventory(store.inventory.inventory.items)
            
            if #blocks == 0 then
                errorNotification('BlockIn', 'No suitable blocks available for BlockIn', 5)
                BlockIn:Toggle()
                return
            end
            
            local blueprint = architect:GenerateAdaptiveBlueprint(origin)
            
            task.spawn(function()
                local blockIndex = 1
                local blockCount = #blocks
                
                for i, pos in ipairs(blueprint) do
                    if not BlockIn.Enabled then break end
                    local blockAtPos = bedwars.BlockController:getStore():getBlockAt(bedwars.BlockController:getBlockPosition(pos))
                    if not blockAtPos then
                        local block = blocks[blockIndex]
                        local success = pcall(function()
                            bedwars.placeBlock(pos, block.itemType, false)
                        end)
                        if not success then
                            errorNotification('BlockIn', 'Failed to place block at position', 3)
                        end
                        blockIndex = (blockIndex % blockCount) + 1
                        task.wait(0.05) 
                    end
                end
                
                strategist:ResetCache()
                if BlockIn.Enabled then
                    BlockIn:Toggle()
                end
            end)
        end,
        Tooltip = 'Shields you from attacks for when you are attacking a bed'
    })

	HandCheck = BlockIn:CreateToggle({
		Name = "Hand Check",
		Function = function() end,
		Default = false
	})
end)

run(function()
	local AutoPlay
	local Random
	
	local function isEveryoneDead()
		return #bedwars.Store:getState().Party.members <= 0
	end
	
	local function joinQueue()
		--if not bedwars.Store:getState().Game.customMatch and bedwars.Store:getState().Party.leader.userId == lplr.UserId and bedwars.Store:getState().Party.queueState == 0 then
			if Random.Enabled then
				local listofmodes = {}
				for i, v in bedwars.QueueMeta do
					if not v.disabled and not v.voiceChatOnly and not v.rankCategory then 
						table.insert(listofmodes, i) 
					end
				end
				bedwars.QueueController:joinQueue(listofmodes[math.random(1, #listofmodes)])
			else
				bedwars.QueueController:joinQueue(store.queueType)
			end
		--end
	end
	
	AutoPlay = vape.Categories.World:CreateModule({
		Name = 'Auto Queue',
		Function = function(callback)
			if callback then
				AutoPlay:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill and deathTable.entityInstance == lplr.Character and isEveryoneDead() and store.matchState ~= 2 then
						joinQueue()
					end
				end))
				AutoPlay:Clean(vapeEvents.MatchEndEvent.Event:Connect(joinQueue))
			end
		end,
		Tooltip = 'Automatically queues after the match ends.'
	})
	Random = AutoPlay:CreateToggle({
		Name = 'Random',
		Tooltip = 'Chooses a random mode'
	})
end)

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
	local Value
	local VerticalValue
	local WallCheck
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	local overlapCheck = OverlapParams.new()
	overlapCheck.RespectCanCollide = true
	local up, down = 0, 0
	local success, proper = false, true
	local clone, oldroot, hip, valid
	
	local function doClone()
		if entitylib.isAlive and entitylib.character.Humanoid.Health > 0 then
			hip = entitylib.character.Humanoid.HipHeight
			oldroot = entitylib.character.HumanoidRootPart
			if not lplr.Character.Parent then return false end
			lplr.Character.Parent = game
			clone = oldroot:Clone()
			clone.Parent = lplr.Character
			oldroot.Parent = gameCamera
			bedwars.QueryUtil:setQueryIgnored(oldroot, true)
			clone.CFrame = oldroot.CFrame
			lplr.Character.PrimaryPart = clone
			lplr.Character.Parent = workspace
			for _, v in lplr.Character:GetDescendants() do
				if v:IsA('Weld') or v:IsA('Motor6D') then
					if v.Part0 == oldroot then v.Part0 = clone end
					if v.Part1 == oldroot then v.Part1 = clone end
				end
			end
			return true
		end
		return false
	end
	
	local function revertClone()
		if not oldroot or not oldroot.Parent or not entitylib.isAlive then return false end
		lplr.Character.Parent = game
		oldroot.Parent = lplr.Character
		lplr.Character.PrimaryPart = oldroot
		lplr.Character.Parent = workspace
		oldroot.CanCollide = true
		for _, v in lplr.Character:GetDescendants() do
			if v:IsA('Weld') or v:IsA('Motor6D') then
				if v.Part0 == clone then v.Part0 = oldroot end
				if v.Part1 == clone then v.Part1 = oldroot end
			end
		end
		local oldclonepos = clone.Position.Y
		if clone then
			clone:Destroy()
			clone = nil
		end
		local origcf = {oldroot.CFrame:GetComponents()}
		if valid then origcf[2] = oldclonepos end
		oldroot.CFrame = CFrame.new(unpack(origcf))
		oldroot.Transparency = 1
		oldroot = nil
		entitylib.character.Humanoid.HipHeight = hip or 2
	end
	
	InfiniteFly = vape.Categories.Blatant:CreateModule({
		Name = 'InfiniteFly',
		Function = function(callback)
			frictionTable.InfiniteFly = callback or nil
			updateVelocity()
			if callback then
				if vape.Modules.Invisibility and vape.Modules.Invisibility.Enabled then
					vape.Modules.Invisibility:Toggle()
					notif('InfiniteFly', 'Invisibility cannot be used with InfiniteFly', 3, 'warning')
				end
	
				if not proper then
					notif('InfiniteFly', 'Broken state detected', 3, 'alert')
					InfiniteFly:Toggle()
					return
				end
	
				success = doClone()
				if not success then
					InfiniteFly:Toggle()
					return
				end
	
				InfiniteFly:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive then
						local mass = 1.5 + ((up + down) * VerticalValue.Value)
						local root = entitylib.character.RootPart
						local moveDirection = entitylib.character.Humanoid.MoveDirection
						local velo = getSpeed()
						local destination = (moveDirection * math.max(Value.Value - velo, 0) * dt)
						rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
						if WallCheck.Enabled then
							local ray = workspace:Raycast(root.Position, destination, rayCheck)
							if ray then 
								destination = ((ray.Position + ray.Normal) - root.Position) 
							end
						end
						root.CFrame += destination
						root.AssemblyLinearVelocity = (moveDirection * velo) + Vector3.new(0, mass, 0)
	
						local speedCFrame = {oldroot.CFrame:GetComponents()}
						if isnetworkowner(oldroot) then
							speedCFrame[1] = clone.CFrame.X
							speedCFrame[3] = clone.CFrame.Z
							if speedCFrame[2] < 2000 then speedCFrame[2] = 100000 end
							oldroot.CFrame = CFrame.new(unpack(speedCFrame))
							oldroot.Velocity = Vector3.new(clone.Velocity.X, oldroot.Velocity.Y, clone.Velocity.Z)
						else
							speedCFrame[2] = clone.CFrame.Y
							clone.CFrame = CFrame.new(unpack(speedCFrame))
						end
					end
				end))
				up, down = 0, 0
				InfiniteFly:Clean(inputService.InputBegan:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
							up = 1
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							down = -1
						end
					end
				end))
				InfiniteFly:Clean(inputService.InputEnded:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
						up = 0
					elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
						down = 0
					end
				end))
				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						InfiniteFly:Clean(jumpButton:GetPropertyChangedSignal('ImageRectOffset'):Connect(function()
							up = jumpButton.ImageRectOffset.X == 146 and 1 or 0
						end))
					end)
				end
			else
				if success and clone and oldroot and proper then
					proper = false
					overlapCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
					overlapCheck.CollisionGroup = oldroot.CollisionGroup
					local ray = workspace:Blockcast(CFrame.new(oldroot.Position.X, clone.CFrame.p.Y, oldroot.Position.Z), Vector3.new(3, entitylib.character.HipHeight, 3), Vector3.new(0, -1000, 0), rayCheck)
					local origcf = {clone.CFrame:GetComponents()}
					origcf[1] = oldroot.Position.X
					origcf[2] = ray and ray.Position.Y + entitylib.character.HipHeight or clone.CFrame.p.Y
					origcf[3] = oldroot.Position.Z
					oldroot.CanCollide = true
					oldroot.Transparency = 0
					oldroot.Velocity = clone.Velocity * Vector3.new(1, 0, 1)
					oldroot.CFrame = CFrame.new(unpack(origcf))
	
					local touched = false
					local connection = runService.PreSimulation:Connect(function()
						if oldroot then
							oldroot.Velocity = Vector3.zero
							valid = false
							if touched then return end
							local cf = {clone.CFrame:GetComponents()}
							cf[2] = oldroot.CFrame.Y
							local newcf = CFrame.new(unpack(cf))
							for _, v in workspace:GetPartBoundsInBox(newcf, oldroot.Size, overlapCheck) do
								if (v.Position.Y + (v.Size.Y / 2)) > (newcf.p.Y + 0.5) then
									touched = true
									return
								end
							end
							if not workspace:Raycast(newcf.Position, Vector3.new(0, -entitylib.character.HipHeight, 0), rayCheck) then return end
							oldroot.CFrame = newcf
							oldroot.Velocity = (clone.Velocity * Vector3.new(1, 0, 1))
							valid = true
						end
					end)
	
					notif('InfiniteFly', 'Waiting 1.1s to land', 1.1)
					task.delay(1.1, function()
						notif('InfiniteFly', 'Landed!', 1)
						connection:Disconnect()
						proper = true
						if oldroot and clone then 
							revertClone() 
						end
					end)
				end
			end
		end,
		ExtraText = function() 
			return 'Heatseeker' 
		end,
		Tooltip = 'Makes you go zoom.'
	})
	Value = InfiniteFly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 23,
		Default = 23,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	VerticalValue = InfiniteFly:CreateSlider({
		Name = 'Vertical Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	WallCheck = InfiniteFly:CreateToggle({
		Name = 'Wall Check',
		Default = true
	})
end)

local function getBestTool(block)
	bedwars.ItemTable = bedwars.ItemTable or bedwars.ItemMeta
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

local cachedNormalSides = {}
for i,v in pairs(Enum.NormalId:GetEnumItems()) do if v.Name ~= "Bottom" then table.insert(cachedNormalSides, v) end end

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

local blacklistedblocks = {
	bed = true,
	ceramic = true
}

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
	bedwars.ItemTable = bedwars.ItemTable or bedwars.ItemMeta
	local softest, softestside = 9e9, Enum.NormalId.Top
	for i,v in pairs(cachedNormalSides) do
		local sidehardness = 0
		for i2,v2 in pairs(GetPlacedBlocksNear(pos, v)) do
			local blockmeta = bedwars.ItemTable[v2].block
			sidehardness = sidehardness + (blockmeta and blockmeta.health or 10)
			if blockmeta then
				local tool = getBestTool(v2)
				if tool then
					sidehardness = sidehardness - bedwars.ItemTable[tool.itemType].breakBlock[blockmeta.breakType]
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

local function getHotbarSlot(itemName)
	for slotNumber, slotTable in pairs(store.localInventory.hotbar) do
		if slotTable.item and slotTable.item.itemType == itemName then
			return slotNumber - 1
		end
	end
	return nil
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (entityLibrary.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool.tool) then
		if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars.Store:dispatch({
					type = "InventorySelectHotbarSlot",
					slot = getHotbarSlot(tool.itemType)
				})
				vapeEvents.InventoryChanged.Event:Wait()
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end
		switchItem(tool.tool)
	end
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

run(function()
	local function customHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
		if block:GetAttribute('NoHealthbar') then return end
		if not self.healthbarPart or not self.healthbarBlockRef or self.healthbarBlockRef.blockPosition ~= blockRef.blockPosition then
			self.healthbarMaid:DoCleaning()
			self.healthbarBlockRef = blockRef
			local create = bedwars.Roact.createElement
			local percent = math.clamp(health / maxHealth, 0, 1)
			local cleanCheck = true
			local part = Instance.new('Part')
			part.Size = Vector3.one
			part.CFrame = CFrame.new(bedwars.BlockController:getWorldPosition(blockRef.blockPosition))
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = workspace
			self.healthbarPart = part
			bedwars.QueryUtil:setQueryIgnored(self.healthbarPart, true)
	
			local mounted = bedwars.Roact.mount(create('BillboardGui', {
				Size = UDim2.fromOffset(249, 102),
				StudsOffset = Vector3.new(0, 2.5, 0),
				Adornee = part,
				MaxDistance = 40,
				AlwaysOnTop = true
			}, {
				create('Frame', {
					Size = UDim2.fromOffset(160, 50),
					Position = UDim2.fromOffset(44, 32),
					BackgroundColor3 = Color3.new(),
					BackgroundTransparency = 0.5
				}, {
					create('UICorner', {CornerRadius = UDim.new(0, 5)}),
					create('ImageLabel', {
						Size = UDim2.new(1, 89, 1, 52),
						Position = UDim2.fromOffset(-48, -31),
						BackgroundTransparency = 1,
						Image = getcustomasset('vape/assets/new/blur.png'),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(52, 31, 261, 502)
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(13, 12),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Color3.new(),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(12, 11),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = color.Dark(uipallet.Text, 0.16),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('Frame', {
						Size = UDim2.fromOffset(138, 4),
						Position = UDim2.fromOffset(12, 32),
						BackgroundColor3 = uipallet.Main
					}, {
						create('UICorner', {CornerRadius = UDim.new(1, 0)}),
						create('Frame', {
							[bedwars.Roact.Ref] = self.healthbarProgressRef,
							Size = UDim2.fromScale(percent, 1),
							BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
						}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
					})
				})
			}), part)
	
			self.healthbarMaid:GiveTask(function()
				cleanCheck = false
				self.healthbarBlockRef = nil
				bedwars.Roact.unmount(mounted)
				if self.healthbarPart then
					self.healthbarPart:Destroy()
				end
				self.healthbarPart = nil
			end)
	
			bedwars.RuntimeLib.Promise.delay(5):andThen(function()
				if cleanCheck then
					self.healthbarMaid:DoCleaning()
				end
			end)
		end
	
		local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
		tweenService:Create(self.healthbarProgressRef:getValue(), TweenInfo.new(0.3), {
			Size = UDim2.fromScale(newpercent, 1), BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
		}):Play()
	end

	local healthbarblocktable = {
		blockHealth = -1,
		breakingBlockPosition = Vector3.zero
	}

	local breakBlock = function(pos, effects, normal, bypass, anim)
		if vape.Modules.InfiniteFly and vape.Modules.InfiniteFly.Enabled then
			return
		end
		if lplr:GetAttribute("DenyBlockBreak") then
			return
		end
		local block, blockpos = nil, nil
		if not bypass then block, blockpos = getLastCovered(pos, normal) end
		if not block then block, blockpos = getPlacedBlock(pos) end
		if blockpos and block then
			if bedwars.BlockEngineClientEvents.DamageBlock:fire(block.Name, blockpos, block):isCancelled() then
				return
			end
			local blockhealthbarpos = {blockPosition = Vector3.zero}
			local blockdmg = 0
			if block and block.Parent ~= nil then
				if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - (blockpos * 3)).magnitude > 30 then return end
				store.blockPlace = tick() + 0.1
				switchToAndUseTool(block)
				blockhealthbarpos = {
					blockPosition = blockpos
				}
				task.spawn(function()
					bedwars.ClientDamageBlock:Get("DamageBlock"):CallServerAsync({
						blockRef = blockhealthbarpos,
						hitPosition = blockpos * 3,
						hitNormal = Vector3.FromNormalId(normal)
					}):andThen(function(result)
						if result ~= "failed" then
							failedBreak = 0
							if healthbarblocktable.blockHealth == -1 or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition then
								local blockdata = bedwars.BlockController:getStore():getBlockData(blockhealthbarpos.blockPosition)
								local blockhealth = blockdata and (blockdata:GetAttribute("Health") or blockdata:GetAttribute(lplr.Name .. "_Health")) or block:GetAttribute("Health")
								healthbarblocktable.blockHealth = blockhealth
								healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
							end
							healthbarblocktable.blockHealth = result == "destroyed" and 0 or healthbarblocktable.blockHealth
							blockdmg = bedwars.BlockController:calculateBlockDamage(lplr, blockhealthbarpos)
							healthbarblocktable.blockHealth = math.max(healthbarblocktable.blockHealth - blockdmg, 0)
							if effects then
								customHealthbar(bedwars.BlockBreaker, blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg, block)
								--bedwars.BlockBreaker:updateHealthbar(blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg, block)
								if healthbarblocktable.blockHealth <= 0 then
									bedwars.BlockBreaker.breakEffect:playBreak(block.Name, blockhealthbarpos.blockPosition, lplr)
									bedwars.BlockBreaker.healthbarMaid:DoCleaning()
									healthbarblocktable.breakingBlockPosition = Vector3.zero
								else
									bedwars.BlockBreaker.breakEffect:playHit(block.Name, blockhealthbarpos.blockPosition, lplr)
								end
							end
							local animation
							if anim then
								animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
								bedwars.ViewmodelController:playAnimation(15)
							end
							task.wait(0.3)
							if animation ~= nil then
								animation:Stop()
								animation:Destroy()
							end
						else
							failedBreak = failedBreak + 1
						end
					end)
				end)
				task.wait(physicsUpdate)
			end
		end
	end

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
	local luckyblocktable = {}

	local connections = {}
	Nuker = vape.Categories.World:CreateModule({
		Name = "Nuker",
		Function = function(callback)
			if callback then
				bedwars.ItemTable = bedwars.ItemTable or bedwars.ItemMeta
				for i,v in pairs(store.blocks) do
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end
				table.insert(connections, collectionService:GetInstanceAddedSignal("block"):Connect(function(v)
					if table.find(nukercustom.ObjectList, v.Name) or (nukerluckyblock.Enabled and v.Name:find("lucky")) or (nukerironore.Enabled and v.Name == "iron_ore") then
						table.insert(luckyblocktable, v)
					end
				end))
				table.insert(connections, collectionService:GetInstanceRemovedSignal("block"):Connect(function(v)
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
										if obj.Name == "bed" and tostring(obj:GetAttribute("TeamId")) == tostring(lplr:GetAttribute("Team")) then continue end
										if obj:GetAttribute("BedShieldEndTime") then
											if obj:GetAttribute("BedShieldEndTime") > game.Workspace:GetServerTimeNow() then continue end
										end
										if ((entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - obj.Position).magnitude <= nukerrange.Value then
											if tool and bedwars.ItemTable[tool.Name].breakBlock and bedwars.BlockController:isBlockBreakable({blockPosition = obj.Position / 3}, lplr) then
												local res, amount = getBestBreakSide(obj.Position)
												local res2, amount2 = getBestBreakSide(obj.Position + Vector3.new(0, 0, 3))
												broke = true
												breakBlock((amount < amount2 and obj.Position or obj.Position + Vector3.new(0, 0, 3)), nukereffects.Enabled, (amount < amount2 and res or res2), false, nukeranimation.Enabled)
												task.wait(nukerslowmode.Value ~= 0 and nukerslowmode.Value/10 or 0)
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
											if tool and bedwars.ItemTable[tool.Name].breakBlock and bedwars.BlockController:isBlockBreakable({blockPosition = obj.Position / 3}, lplr) then
												breakBlock(obj.Position, nukereffects.Enabled, getBestBreakSide(obj.Position), true, nukeranimation.Enabled)
												task.wait(nukerslowmode.Value ~= 0 and nukerslowmode.Value/10 or 0)
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
				table.clear(luckyblocktable)
				for i,v in pairs(connections) do
					pcall(function() v:Disconnect() end)
				end
				table.clear(connections)
			end
		end,
		Tooltip = "Automatically destroys beds & luckyblocks around you."
	})
	nukerslowmode = Nuker:CreateSlider({
		Name = "Break Slowmode",
		Min = 0,
		Max = 10,
		Function = function() end,
		Default = 2
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
	nukereffects = Nuker:CreateToggle({
		Name = "Show HealthBar & Effects",
		Function = function(callback)
			if not callback then
				bedwars.BlockBreaker.healthbarMaid:DoCleaning()
			end
		 end,
		Default = true
	})
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
	nukerironore = Nuker:CreateToggle({
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
	})
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
	
--[[run(function()
	local Nuker
	local Range
	local UpdateRate
	local Custom
	local Bed
	local LuckyBlock
	local IronOre
	local Effect
	local CustomHealth = {}
	local Animation
	local SelfBreak
	local InstantBreak
	local LimitItem
	local customlist, parts = {}, {}
	
	local function customHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
		if block:GetAttribute('NoHealthbar') then return end
		if not self.healthbarPart or not self.healthbarBlockRef or self.healthbarBlockRef.blockPosition ~= blockRef.blockPosition then
			self.healthbarMaid:DoCleaning()
			self.healthbarBlockRef = blockRef
			local create = bedwars.Roact.createElement
			local percent = math.clamp(health / maxHealth, 0, 1)
			local cleanCheck = true
			local part = Instance.new('Part')
			part.Size = Vector3.one
			part.CFrame = CFrame.new(bedwars.BlockController:getWorldPosition(blockRef.blockPosition))
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = workspace
			self.healthbarPart = part
			bedwars.QueryUtil:setQueryIgnored(self.healthbarPart, true)
	
			local mounted = bedwars.Roact.mount(create('BillboardGui', {
				Size = UDim2.fromOffset(249, 102),
				StudsOffset = Vector3.new(0, 2.5, 0),
				Adornee = part,
				MaxDistance = 40,
				AlwaysOnTop = true
			}, {
				create('Frame', {
					Size = UDim2.fromOffset(160, 50),
					Position = UDim2.fromOffset(44, 32),
					BackgroundColor3 = Color3.new(),
					BackgroundTransparency = 0.5
				}, {
					create('UICorner', {CornerRadius = UDim.new(0, 5)}),
					create('ImageLabel', {
						Size = UDim2.new(1, 89, 1, 52),
						Position = UDim2.fromOffset(-48, -31),
						BackgroundTransparency = 1,
						Image = getcustomasset('vape/assets/new/blur.png'),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(52, 31, 261, 502)
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(13, 12),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Color3.new(),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(12, 11),
						BackgroundTransparency = 1,
						Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = color.Dark(uipallet.Text, 0.16),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('Frame', {
						Size = UDim2.fromOffset(138, 4),
						Position = UDim2.fromOffset(12, 32),
						BackgroundColor3 = uipallet.Main
					}, {
						create('UICorner', {CornerRadius = UDim.new(1, 0)}),
						create('Frame', {
							[bedwars.Roact.Ref] = self.healthbarProgressRef,
							Size = UDim2.fromScale(percent, 1),
							BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
						}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
					})
				})
			}), part)
	
			self.healthbarMaid:GiveTask(function()
				cleanCheck = false
				self.healthbarBlockRef = nil
				bedwars.Roact.unmount(mounted)
				if self.healthbarPart then
					self.healthbarPart:Destroy()
				end
				self.healthbarPart = nil
			end)
	
			bedwars.RuntimeLib.Promise.delay(5):andThen(function()
				if cleanCheck then
					self.healthbarMaid:DoCleaning()
				end
			end)
		end
	
		local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
		tweenService:Create(self.healthbarProgressRef:getValue(), TweenInfo.new(0.3), {
			Size = UDim2.fromScale(newpercent, 1), BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
		}):Play()
	end
	
	local hit = 0
	
	local function attemptBreak(tab, localPosition)
		if not tab then return end
		for _, v in tab do
			if (v.Position - localPosition).Magnitude < Range.Value and bedwars.BlockController:isBlockBreakable({blockPosition = v.Position / 3}, lplr) then
				if not SelfBreak.Enabled and v:GetAttribute('PlacedByUserId') == lplr.UserId then continue end
				if (v:GetAttribute('BedShieldEndTime') or 0) > workspace:GetServerTimeNow() then continue end
				if LimitItem.Enabled and not (store.hand.tool and bedwars.ItemMeta[store.hand.tool.Name].breakBlock) then continue end
	
				hit += 1
				local target, path, endpos = bedwars.breakBlock(v, Effect.Enabled, Animation.Enabled, CustomHealth.Enabled and customHealthbar or nil, InstantBreak.Enabled)
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
	
				task.wait(InstantBreak.Enabled and (store.damageBlockFail > tick() and 4.5 or 0) or 0.25)
	
				return true
			end
		end
	
		return false
	end
	
	Nuker = vape.Categories.Minigames:CreateModule({
		Name = 'Nuker',
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
	
				local beds = collection('bed', Nuker)
				local luckyblock = collection('LuckyBlock', Nuker)
				local ironores = collection('iron-ore', Nuker)
				customlist = collection('block', Nuker, function(tab, obj)
					if table.find(Custom.ListEnabled, obj.Name) then
						table.insert(tab, obj)
					end
				end)
	
				repeat
					task.wait(1 / UpdateRate.Value)
					if not Nuker.Enabled then return end
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position
	
						if attemptBreak(Bed.Enabled and beds, localPosition) then continue end
						if attemptBreak(customlist, localPosition) then continue end
						if attemptBreak(LuckyBlock.Enabled and luckyblock, localPosition) then continue end
						if attemptBreak(IronOre.Enabled and ironores, localPosition) then continue end
	
						for _, v in parts do
							v.Position = Vector3.zero
						end
					end
				until not Nuker.Enabled
			else
				for _, v in parts do
					v:ClearAllChildren()
					v:Destroy()
				end
				table.clear(parts)
			end
		end,
		Tooltip = 'Break blocks around you automatically'
	})
	Range = Nuker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 30,
		Default = 30,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	UpdateRate = Nuker:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Suffix = 'hz'
	})
	Custom = Nuker:CreateTextList({
		Name = 'Custom',
		Function = function()
			if not customlist then return end
			table.clear(customlist)
			for _, obj in store.blocks do
				if table.find(Custom.ListEnabled, obj.Name) then
					table.insert(customlist, obj)
				end
			end
		end
	})
	Bed = Nuker:CreateToggle({
		Name = 'Break Bed',
		Default = true
	})
	LuckyBlock = Nuker:CreateToggle({
		Name = 'Break Lucky Block',
		Default = true
	})
	IronOre = Nuker:CreateToggle({
		Name = 'Break Iron Ore',
		Default = true
	})
	Effect = Nuker:CreateToggle({
		Name = 'Show Healthbar & Effects',
		Function = function(callback)
			if CustomHealth.Object then
				CustomHealth.Object.Visible = callback
			end
		end,
		Default = true
	})
	CustomHealth = Nuker:CreateToggle({
		Name = 'Custom Healthbar',
		Default = true,
		Darker = true
	})
	Animation = Nuker:CreateToggle({Name = 'Animation'})
	SelfBreak = Nuker:CreateToggle({Name = 'Self Break'})
	InstantBreak = Nuker:CreateToggle({Name = 'Instant Break'})
	LimitItem = Nuker:CreateToggle({
		Name = 'Limit to items',
		Tooltip = 'Only breaks when tools are held'
	})
end)--]]

run(function()
	local Scaffold
	local Expand
	local Tower
	local Downwards
	local Diagonal
	local LimitItem
	local WoolOnly
	local Mouse
	local adjacent, lastpos, label = {}, Vector3.zero
	
	for x = -3, 3, 3 do
		for y = -3, 3, 3 do
			for z = -3, 3, 3 do
				local vec = Vector3.new(x, y, z)
				if vec ~= Vector3.zero then
					table.insert(adjacent, vec)
				end
			end
		end
	end
	
	local function nearCorner(poscheck, pos)
		local startpos = poscheck - Vector3.new(3, 3, 3)
		local endpos = poscheck + Vector3.new(3, 3, 3)
		local check = poscheck + (pos - poscheck).Unit * 100
		return Vector3.new(math.clamp(check.X, startpos.X, endpos.X), math.clamp(check.Y, startpos.Y, endpos.Y), math.clamp(check.Z, startpos.Z, endpos.Z))
	end
	
	local function blockProximity(pos)
		local mag, returned = 60
		local tab = getBlocksInPoints(bedwars.BlockController:getBlockPosition(pos - Vector3.new(21, 21, 21)), bedwars.BlockController:getBlockPosition(pos + Vector3.new(21, 21, 21)))
		for _, v in tab do
			local blockpos = nearCorner(v, pos)
			local newmag = (pos - blockpos).Magnitude
			if newmag < mag then
				mag, returned = newmag, blockpos
			end
		end
		table.clear(tab)
		return returned
	end
	
	local function checkAdjacent(pos)
		for _, v in adjacent do
			if getPlacedBlock(pos + v) then
				return true
			end
		end
		return false
	end
	
	local function getScaffoldBlock()
		if store.hand.toolType == 'block' then
			local suc, isWool = pcall(function() return store.localHand.itemType:find('wool') end)
			if not suc then isWool = false end
			if not WoolOnly.Enabled or isWool then
				return store.hand.tool.Name, store.hand.amount
			end
		elseif (not LimitItem.Enabled) then
			local wool, amount = getWool()
			if wool then
				return wool, amount
			else
				if not WoolOnly.Enabled then
					for _, item in store.inventory.inventory.items do
						if bedwars.ItemMeta[item.itemType].block then
							return item.itemType, item.amount
						end
					end
				end
			end
		end
	
		return nil, 0
	end
	
	Scaffold = vape.Categories.Blatant:CreateModule({
		Name = 'Scaffold',
		Function = function(callback)
			if label then
				label.Visible = callback
			end
	
			if callback then
				repeat
					if entitylib.isAlive then
						local wool, amount = getScaffoldBlock()
	
						if Mouse.Enabled then
							if not inputService:IsMouseButtonPressed(0) then
								wool = nil
							end
						end
	
						if label then
							amount = amount or 0
							label.Text = amount..' <font color="rgb(170, 170, 170)">(Scaffold)</font>'
							label.TextColor3 = Color3.fromHSV((amount / 128) / 2.8, 0.86, 1)
						end
	
						if wool then
							local root = entitylib.character.RootPart
							if Tower.Enabled and inputService:IsKeyDown(Enum.KeyCode.Space) and (not inputService:GetFocusedTextBox()) then
								root.Velocity = Vector3.new(root.Velocity.X, 38, root.Velocity.Z)
							end
	
							for i = Expand.Value, 1, -1 do
								local currentpos = roundPos(root.Position - Vector3.new(0, entitylib.character.HipHeight + (Downwards.Enabled and inputService:IsKeyDown(Enum.KeyCode.LeftShift) and 4.5 or 1.5), 0) + entitylib.character.Humanoid.MoveDirection * (i * 3))
								if Diagonal.Enabled then
									if math.abs(math.round(math.deg(math.atan2(-entitylib.character.Humanoid.MoveDirection.X, -entitylib.character.Humanoid.MoveDirection.Z)) / 45) * 45) % 90 == 45 then
										local dt = (lastpos - currentpos)
										if ((dt.X == 0 and dt.Z ~= 0) or (dt.X ~= 0 and dt.Z == 0)) and ((lastpos - root.Position) * Vector3.new(1, 0, 1)).Magnitude < 2.5 then
											currentpos = lastpos
										end
									end
								end
	
								local block, blockpos = getPlacedBlock(currentpos)
								if not block then
									blockpos = checkAdjacent(blockpos * 3) and blockpos * 3 or blockProximity(currentpos)
									if blockpos then
										task.spawn(bedwars.placeBlock, blockpos, wool, false)
									end
								end
								lastpos = currentpos
							end
						end
					end
	
					task.wait(0.03)
				until not Scaffold.Enabled
			else
				Label = nil
			end
		end,
		Tooltip = 'Helps you make bridges/scaffold walk.'
	})
	Expand = Scaffold:CreateSlider({
		Name = 'Expand',
		Min = 1,
		Max = 6
	})
	Tower = Scaffold:CreateToggle({
		Name = 'Tower',
		Default = true
	})
	Downwards = Scaffold:CreateToggle({
		Name = 'Downwards',
		Default = true
	})
	Diagonal = Scaffold:CreateToggle({
		Name = 'Diagonal',
		Default = true
	})
	WoolOnly = Scaffold:CreateToggle({Name = "Wool Only"})
	LimitItem = Scaffold:CreateToggle({Name = 'Limit to items'})
	Mouse = Scaffold:CreateToggle({Name = 'Require mouse down'})
	Count = Scaffold:CreateToggle({
		Name = 'Block Count',
		Function = function(callback)
			if callback then
				label = Instance.new('TextLabel')
				label.Size = UDim2.fromOffset(100, 20)
				label.Position = UDim2.new(0.5, 6, 0.5, 60)
				label.BackgroundTransparency = 1
				label.AnchorPoint = Vector2.new(0.5, 0)
				label.Text = '0'
				label.TextColor3 = Color3.new(0, 1, 0)
				label.TextSize = 18
				label.RichText = true
				label.Font = Enum.Font.Arial
				label.Visible = Scaffold.Enabled
				label.Parent = vape.gui
			else
				label:Destroy()
				label = nil
			end
		end
	})
end)

run(function()
	local TargetPart
	local Targets
	local FOV
	local Range
	local OtherProjectiles
	local rayCheck = RaycastParams.new()
	rayCheck.FilterType = Enum.RaycastFilterType.Include
	rayCheck.FilterDescendantsInstances = {workspace:FindFirstChild('Map')}
	local old
	local selectedTarget = nil
	local targetOutline = nil
	
	local UserInputService = game:GetService("UserInputService")
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	
	local function updateOutline(target)
		if targetOutline then
			targetOutline:Destroy()
			targetOutline = nil
		end
		if target then
			targetOutline = Instance.new("Highlight")
			targetOutline.FillTransparency = 1
			targetOutline.OutlineColor = Color3.fromRGB(255, 0, 0)
			targetOutline.OutlineTransparency = 0
			targetOutline.Adornee = target.Character
			targetOutline.Parent = target.Character
		end
	end

	local CoreConnections = {}
	
	local function handlePlayerSelection()
		local mouse = lplr:GetMouse()
		local function selectTarget()
			local target = mouse.Target
			if target and target.Parent then
				local plr = game.Players:GetPlayerFromCharacter(target.Parent)
				if plr then
					if selectedTarget == plr then
						selectedTarget = nil
						updateOutline(nil)
					else
						selectedTarget = plr
						updateOutline(plr)
					end
				end
			end
		end
		
		if isMobile then
			local con = UserInputService.TouchTapInWorld:Connect(function(touchPos)
				local ray = workspace.CurrentCamera:ScreenPointToRay(touchPos.X, touchPos.Y)
				local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
				if result and result.Instance then
					mouse.Target = result.Instance
					selectTarget()
				end
			end)
			table.insert(CoreConnections, con)
		else
			table.insert(CoreConnections, mouse.Button1Down:Connect(selectTarget))
		end
	end
	
	local ProjectileAimbot = vape.Categories.World:CreateModule({
		Name = 'ProjectileAimbot',
		Function = function(callback)
			if callback then
				handlePlayerSelection()
				old = bedwars.ProjectileController.calculateImportantLaunchValues
				bedwars.ProjectileController.calculateImportantLaunchValues = function(...)
					local self, projmeta, worldmeta, origin, shootpos = ...
					local originPos = entitylib.isAlive and (shootpos or entitylib.character.RootPart.Position) or Vector3.zero
					
					local plr
					if selectedTarget and selectedTarget.Character and (selectedTarget.Character.PrimaryPart.Position - originPos).Magnitude <= Range.Value then
						plr = selectedTarget
					else
						plr = entitylib.EntityMouse({
							Part = 'RootPart',
							Range = FOV.Value,
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Wallcheck = Targets.Walls.Enabled,
							Origin = originPos
						})
					end
					updateOutline(plr)
					
					if plr and (plr.Character.PrimaryPart.Position - originPos).Magnitude <= Range.Value then
						plr.HipHeight = plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Humanoid").HipHeight or 2
						local pos = shootpos or self:getLaunchPosition(origin)
						if not pos then
							return old(...)
						end
	
						if (not OtherProjectiles.Enabled) and not projmeta.projectile:find('arrow') then
							return old(...)
						end
	
						local meta = projmeta:getProjectileMeta()
						local lifetime = (worldmeta and meta.predictionLifetimeSec or meta.lifetimeSec or 3)
						local gravity = (meta.gravitationalAcceleration or 196.2) * projmeta.gravityMultiplier
						local projSpeed = (meta.launchVelocity or 100)
						local offsetpos = pos + (projmeta.projectile == 'owl_projectile' and Vector3.zero or projmeta.fromPositionOffset)
						local balloons = plr.Character:GetAttribute('InflatedBalloons')
						local playerGravity = workspace.Gravity
	
						if balloons and balloons > 0 then
							playerGravity = (workspace.Gravity * (1 - ((balloons >= 4 and 1.2 or balloons >= 3 and 1 or 0.975))))
						end
	
						if plr.Character.PrimaryPart:FindFirstChild('rbxassetid://8200754399') then
							playerGravity = 6
						end

						if store.hand and store.hand.tool and store.hand.tool.Name:find("spellbook") then
							local targetPos = plr.RootPart.Position
							local selfPos = lplr.Character.PrimaryPart.Position
							local expectedTime = (selfPos - targetPos).Magnitude / 160
							targetPos += (plr.RootPart.Velocity * expectedTime)
							return {
								initialVelocity = (selfPos - targetPos).Unit * -160,
								positionFrom = offsetpos,
								deltaT = 2,
								gravitationalAcceleration = 1,
								drawDurationSeconds = 5
							}
						elseif store.hand and store.hand.tool and store.hand.tool.Name:find("chakram") then
							local targetPos = plr.RootPart.Position
							local selfPos = lplr.Character.PrimaryPart.Position
							local expectedTime = (selfPos - targetPos).Magnitude / 80
							targetPos += (plr.RootPart.Velocity * expectedTime)
							return {
								initialVelocity = (selfPos - targetPos).Unit * -80,
								positionFrom = offsetpos,
								deltaT = 2,
								gravitationalAcceleration = 1,
								drawDurationSeconds = 5
							}
						end
						
						TargetPart.Value = TargetPart.Value == "RootPart" and "PrimaryPart" or TargetPart.Value
						local newlook = CFrame.new(offsetpos, plr.Character[TargetPart.Value].Position) * CFrame.new(projmeta.projectile == 'owl_projectile' and Vector3.zero or Vector3.new(bedwars.BowConstantsTable.RelX, bedwars.BowConstantsTable.RelY, bedwars.BowConstantsTable.RelZ))
						local calc = prediction.SolveTrajectory(newlook.p, projSpeed, gravity, plr.Character[TargetPart.Value].Position, projmeta.projectile == 'telepearl' and Vector3.zero or plr.Character[TargetPart.Value].Velocity, playerGravity, plr.HipHeight, plr.Jumping and 42.6 or nil, rayCheck)
						if calc then
							targetinfo.Targets[plr] = tick() + 1
							return {
								initialVelocity = CFrame.new(newlook.Position, calc).LookVector * projSpeed,
								positionFrom = offsetpos,
								deltaT = lifetime,
								gravitationalAcceleration = gravity,
								drawDurationSeconds = 5
							}
						end
					end
	
					return old(...)
				end
			else
				bedwars.ProjectileController.calculateImportantLaunchValues = old
				if targetOutline then
					targetOutline:Destroy()
					targetOutline = nil
				end
				selectedTarget = nil
				for i,v in pairs(CoreConnections) do
					pcall(function() v:Disconnect() end)
				end
				table.clear(CoreConnections)
			end
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy. Click a player to lock onto them (red outline).'
	})
	
	Targets = ProjectileAimbot:CreateTargets({
		Players = true,
		Walls = true
	})
	TargetPart = ProjectileAimbot:CreateDropdown({
		Name = 'Part',
		List = {'RootPart', 'Head'}
	})
	FOV = ProjectileAimbot:CreateSlider({
		Name = 'FOV',
		Min = 1,
		Max = 1000,
		Default = 1000
	})
	Range = ProjectileAimbot:CreateSlider({
		Name = 'Range',
		Min = 10,
		Max = 500,
		Default = 100,
		Tooltip = 'Maximum distance for target locking'
	})
	OtherProjectiles = ProjectileAimbot:CreateToggle({
		Name = 'Other Projectiles',
		Default = true
	})
end)
	
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
		end
	end
	return closestEntity
end
	
local function Filter(tbl, check)
	for i,v in pairs(tbl) do
		if check(v) then return v end
	end
	return nil
end

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
	local ProjectileAura
	local Targets
	local Range
	local List
	local rayCheck = RaycastParams.new()
	rayCheck.FilterType = Enum.RaycastFilterType.Include

	local projectileRemote = {InvokeServer = function() end}
	local FireDelays = {}
	task.spawn(function()
		projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
	end)

	local function getAmmo(check, item)
		if not check.ammoItemTypes then return item.itemType end
		for _, item in store.inventory.inventory.items do
			if check.ammoItemTypes and table.find(check.ammoItemTypes, item.itemType) then
				return item.itemType
			end
		end
	end
	
	local function getProjectiles()
		local items = {}
		for _, item in store.inventory.inventory.items do
			if item and item.itemType == "mage_spellbook" then
				table.insert(items, {
					item,
					nil, 
					nil,
					0.3
				})
				continue
			end
			if item and item.itemType == "owl_orb" then
				table.insert(items, {
					item,
					nil, 
					nil,
					0.3
				})
				continue
			end
			if item and item.itemType == "light_sword" then
				table.insert(items, {
					item,
					nil, 
					nil,
					0.3
				})
			end
			local proj = bedwars.ItemMeta[item.itemType].projectileSource
			local ammo = proj and getAmmo(proj, item)
			if not table.find(List.ListEnabled, 'sword_wave1') then table.insert(List.ListEnabled, 'sword_wave1') end
			if not table.find(List.ListEnabled, 'ninja_chakram_4') then table.insert(List.ListEnabled, 'ninja_chakram_4') end
			if ammo and table.find(List.ListEnabled, ammo) then
				table.insert(items, {
					item,
					ammo,
					proj.projectileType(ammo),
					proj
				})
			end
		end
		return items
	end

	local HttpService = game:GetService("HttpService")

	local function specialGUID()
		return string.upper((tostring(HttpService:GenerateGUID(false)):split("-"))[1])
	end
	
	local function selfPosition()
		return lplr.Character and lplr.Character.PrimaryPart and lplr.Character.PrimaryPart.Position
	end

	local handle = {
		Lumen = function(ent, item, ammo, projectile, itemMeta)
			if not item.tool then return end
			if not ent then return end
			local selfPos = selfPosition()
			if not selfPos then return end
	
			local vec = ent.RootPart.Position * Vector3.new(1, 0, 1)
			lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(vec.X, lplr.Character.PrimaryPart.Position.Y + 0.001, vec.Z))
	
			local mag = lplr.Character.PrimaryPart.CFrame.LookVector*80
	
			projectileRemote:InvokeServer(
				item.tool,
				"light_sword",
				"sword_wave1",
				Vector3.new(selfPos.X, selfPos.Y + 2, selfPos.Z),
				selfPos,
				mag,
				specialGUID(),
				{
					["shotId"] = specialGUID(),
					["drawDurationSec"] = 0
				},
				workspace:GetServerTimeNow() - 0.045
			)

			targetinfo.Targets[ent] = tick() + 1
			
			pcall(function()
				FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
			end)
		end,
		Umeko = function(ent, item, ammo, projectile, itemMeta)
			if not item.tool then return end
			if not ent then return end
			local selfPos = selfPosition()
			if not selfPos then return end
	
			local vec = ent.RootPart.Position * Vector3.new(1, 0, 1)
			lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(vec.X, lplr.Character.PrimaryPart.Position.Y + 0.001, vec.Z))
	
			switchItem(item.tool)

			local targetPos = ent.RootPart.Position

			local expectedTime = (selfPos - targetPos).Magnitude / 160
			targetPos += (ent.RootPart.Velocity * expectedTime)

			targetinfo.Targets[ent] = tick() + 1

			projectileRemote:InvokeServer(
				item.tool,
				nil,
				"ninja_chakram_4",
				selfPos + Vector3.new(0, 2, 0),
				selfPos,
				(selfPos - targetPos).Unit * -160,
				specialGUID(),
				{
					["shotId"] = specialGUID(),
					["drawDurationSec"] = 1
				},
				workspace:GetServerTimeNow() - 0.045
			)
			
			pcall(function()
				FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
			end)
		end,
		Whim = function(ent, item, ammo, projectile, itemMeta)
			if not item.tool then return end
			if not ent then return end
			local selfPos = selfPosition()
			if not selfPos then return end
	
			local vec = ent.RootPart.Position * Vector3.new(1, 0, 1)
			lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(vec.X, lplr.Character.PrimaryPart.Position.Y + 0.001, vec.Z))
	
			switchItem(item.tool)

			local targetPos = ent.RootPart.Position

			local expectedTime = (selfPos - targetPos).Magnitude / 160
			targetPos += (ent.RootPart.Velocity * expectedTime)

			targetinfo.Targets[ent] = tick() + 1

			projectileRemote:InvokeServer(
				item.tool,
				nil,
				"mage_spell_base",
				selfPos + Vector3.new(0, 2, 0),
				selfPos,
				(selfPos - targetPos).Unit * -160,
				specialGUID(),
				{
					["shotId"] = specialGUID(),
					["drawDurationSec"] = 1
				},
				workspace:GetServerTimeNow() - 0.045
			)
			
			pcall(function()
				FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
			end)
		end,
		Whisper = function(ent, item, ammo, projectile, itemMeta)
			local function getPlayerFromUserId(userId)
				if not userId then return nil end
				local suc = pcall(function()
					userId = tonumber(userId)
				end)
				if not suc then return nil end
				for i,v in pairs(game:GetService("Players"):GetPlayers()) do
					if v.UserId == userId then return v end
				end
			end
			local function getOwl()
				local owl = Filter(game.Workspace:GetChildren(), function(v)
					if v.ClassName and v.ClassName == "Model" and v.Name and v.Name == "ServerOwl" and tostring(v:GetAttribute("Owner")) == tostring(lplr.UserId) and getPlayerFromUserId(tostring(v:GetAttribute("Target"))) then 
						return true
					else
						return false
					end
				end)
				if not owl then return end

				if not item.tool then return end
				if not ent then return end
				local selfPos = selfPosition()
				if not selfPos then return end

				local targetPosition = ent.RootPart.Position
				local direction = (targetPosition - lplr.Character.HumanoidRootPart.Position).unit

				local target = getPlayerFromUserId(tostring(owl:GetAttribute("Target")))
				local ProjectileRefId, direction, fromPosition, initialVelocity = specialGUID(), direction, nil, direction
				local suc = pcall(function()
					fromPosition = target.Character.HumanoidRootPart.Position
				end)
				if not suc then return end

				bedwars.Client:Get(remotes.OwlFireProjectile):SendToServer({
					ProjectileRefId = ProjectileRefId,
					direction = direction,
					fromPosition = fromPosition,
					initialVelocity = initialVelocity
				})
			end
		end
	}
	
	ProjectileAura = vape.Categories.Blatant:CreateModule({
		Name = 'ProjectileAura',
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.5 then
							task.spawn(function()
								local ent = entitylib.EntityPosition({
									Range = Range.Value,
									Part = 'RootPart',
									Players = true,
									NPCs = true
								})
								if ent then
									if Targets.Walls.Enabled then
										if not Wallcheck(lplr.Character, ent.Character) then return end
									end
									local pos = entitylib.character.RootPart.Position
									for _, data in getProjectiles() do
										local item, ammo, projectile, itemMeta = unpack(data)
										if (FireDelays[item.itemType] or 0) < tick() then
											if item.itemType == "light_sword" then
												handle.Lumen(ent, unpack(data))
												continue
											elseif item.itemType == "ninja_chakram_4" then
												handle.Umeko(ent, unpack(data))
												continue
											elseif item.itemType == "mage_spellbook" then
												handle.Whim(ent, unpack(data))
												continue
											elseif item.itemType == "owl_orb" then
												handle.Whisper(ent, unpack(data))
												continue
											end
											rayCheck.FilterDescendantsInstances = {workspace.Map}
											local meta = bedwars.ProjectileMeta[projectile]
											local projSpeed, gravity = meta.launchVelocity, meta.gravitationalAcceleration or 196.2
											local calc = prediction.SolveTrajectory(pos, projSpeed, gravity, ent.RootPart.Position, ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, ent.Jumping and 42.6 or nil, rayCheck)
											if calc then
												targetinfo.Targets[ent] = tick() + 1
												local switched = switchItem(item.tool)
			
												task.spawn(function()
													local dir, id = CFrame.lookAt(pos, calc).LookVector, httpService:GenerateGUID(true)
													local shootPosition = (CFrame.new(pos, calc) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).Position
													bedwars.ProjectileController:createLocalProjectile(meta, ammo, projectile, shootPosition, id, dir * projSpeed, {drawDurationSeconds = 1})
													local res = projectileRemote:InvokeServer(item.tool, ammo, projectile, shootPosition, pos, dir * projSpeed, id, {drawDurationSeconds = 1, shotId = httpService:GenerateGUID(false)}, workspace:GetServerTimeNow() - 0.045)
													if not res then
														FireDelays[item.itemType] = tick()
													else
														local shoot = itemMeta.launchSound
														shoot = shoot and shoot[math.random(1, #shoot)] or nil
														if shoot then
															bedwars.SoundManager:playSound(shoot)
														end
													end
												end)
			
												FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
												if switched then
													task.wait(0.05)
												end
											end
										end
									end
								end
							end)
						end
						task.wait(0.1)
					until not ProjectileAura.Enabled
				end)
			end
		end,
		Tooltip = 'Shoots people around you'
	})
	Targets = ProjectileAura:CreateTargets({
		Players = true,
		Walls = true
	})
	List = ProjectileAura:CreateTextList({
		Name = 'Projectiles',
		Default = {'arrow', 'snowball'}
	})
	Range = ProjectileAura:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 50,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)

run(function()
	local AutoConsume
	local Health
	local SpeedPotion
	local Apple
	local ShieldPotion
	
	local function consumeCheck(attribute)
		if entitylib.isAlive then
			if SpeedPotion.Enabled and (not attribute or attribute == 'StatusEffect_speed') then
				local speedpotion = getItem('speed_potion')
				if speedpotion and (not lplr.Character:GetAttribute('StatusEffect_speed')) then
					for _ = 1, 4 do
						if bedwars.Client:Get(remotes.ConsumeItem):CallServer({item = speedpotion.tool}) then break end
					end
				end
			end
	
			if Apple.Enabled and (not attribute or attribute:find('Health')) then
				if (lplr.Character:GetAttribute('Health') / lplr.Character:GetAttribute('MaxHealth')) <= (Health.Value / 100) then
					local apple = getItem('orange') or (not lplr.Character:GetAttribute('StatusEffect_golden_apple') and getItem('golden_apple')) or getItem('apple')
					
					if apple then
						bedwars.Client:Get(remotes.ConsumeItem):CallServerAsync({
							item = apple.tool
						})
					end
				end
			end
	
			if ShieldPotion.Enabled and (not attribute or attribute:find('Shield')) then
				if (lplr.Character:GetAttribute('Shield_POTION') or 0) == 0 then
					local shield = getItem('big_shield') or getItem('mini_shield')
	
					if shield then
						bedwars.Client:Get(remotes.ConsumeItem):CallServerAsync({
							item = shield.tool
						})
					end
				end
			end
		end
	end
	
	AutoConsume = vape.Categories.Blatant:CreateModule({
		Name = 'AutoConsume',
		Function = function(callback)
			if callback then
				AutoConsume:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(consumeCheck))
				AutoConsume:Clean(vapeEvents.AttributeChanged.Event:Connect(function(attribute)
					if attribute:find('Shield') or attribute:find('Health') or attribute == 'StatusEffect_speed' then
						consumeCheck(attribute)
					end
				end))
				consumeCheck()
			end
		end,
		Tooltip = 'Automatically heals for you when health or shield is under threshold.'
	})
	Health = AutoConsume:CreateSlider({
		Name = 'Health Percent',
		Min = 1,
		Max = 99,
		Default = 70,
		Suffix = '%'
	})
	SpeedPotion = AutoConsume:CreateToggle({
		Name = 'Speed Potions',
		Default = true
	})
	Apple = AutoConsume:CreateToggle({
		Name = 'Apple',
		Default = true
	})
	ShieldPotion = AutoConsume:CreateToggle({
		Name = 'Shield Potions',
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
run(function()
	local StorageESP
	local List
	local Background
	local Color = {}
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local function nearStorageItem(item)
		for _, v in List.ListEnabled do
			if item:find(v) then return v end
		end
	end
	
	local function refreshAdornee(v)
		local chest = v.Adornee:FindFirstChild('ChestFolderValue')
		chest = chest and chest.Value or nil
		if not chest then
			v.Enabled = false
			return
		end
	
		local chestitems = chest and chest:GetChildren() or {}
		for _, obj in v.Frame:GetChildren() do
			if obj:IsA('ImageLabel') and obj.Name ~= 'Blur' then
				obj:Destroy()
			end
		end
	
		v.Enabled = false
		local alreadygot = {}
		for _, item in chestitems do
			if not alreadygot[item.Name] and (table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name)) then
				alreadygot[item.Name] = true
				v.Enabled = true
				local blockimage = Instance.new('ImageLabel')
				blockimage.Size = UDim2.fromOffset(32, 32)
				blockimage.BackgroundTransparency = 1
				blockimage.Image = bedwars.getIcon({itemType = item.Name}, true)
				blockimage.Parent = v.Frame
			end
		end
		table.clear(chestitems)
	end
	
	local function Added(v)
		local chest = v:WaitForChild('ChestFolderValue', 3)
		if not (chest and StorageESP.Enabled) then return end
		chest = chest.Value
		local billboard = Instance.new('BillboardGui')
		billboard.Parent = Folder
		billboard.Name = 'chest'
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.Size = UDim2.fromOffset(36, 36)
		billboard.AlwaysOnTop = true
		billboard.ClipsDescendants = false
		billboard.Adornee = v
		local blur = addBlur(billboard)
		blur.Visible = Background.Enabled
		local frame = Instance.new('Frame')
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		frame.BackgroundTransparency = 1 - (Background.Enabled and Color.Opacity or 0)
		frame.Parent = billboard
		local layout = Instance.new('UIListLayout')
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.Padding = UDim.new(0, 4)
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			billboard.Size = UDim2.fromOffset(math.max(layout.AbsoluteContentSize.X + 4, 36), 36)
		end)
		layout.Parent = frame
		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = frame
		Reference[v] = billboard
		StorageESP:Clean(chest.ChildAdded:Connect(function(item)
			if table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name) then
				refreshAdornee(billboard)
			end
		end))
		StorageESP:Clean(chest.ChildRemoved:Connect(function(item)
			if table.find(List.ListEnabled, item.Name) or nearStorageItem(item.Name) then
				refreshAdornee(billboard)
			end
		end))
		task.spawn(refreshAdornee, billboard)
	end
	
	StorageESP = vape.Categories.Utility:CreateModule({
		Name = 'Chest ESP',
		Function = function(callback)
			if callback then
				StorageESP:Clean(collectionService:GetInstanceAddedSignal('chest'):Connect(Added))
				for _, v in collectionService:GetTagged('chest') do
					task.spawn(Added, v)
				end
			else
				table.clear(Reference)
				Folder:ClearAllChildren()
			end
		end,
		Tooltip = 'Displays items in chests'
	})
	List = StorageESP:CreateTextList({
		Name = 'Item',
		Function = function()
			for _, v in Reference do
				task.spawn(refreshAdornee, v)
			end
		end
	})
	Background = StorageESP:CreateToggle({
		Name = 'Background',
		Function = function(callback)
			if Color.Object then Color.Object.Visible = callback end
			for _, v in Reference do
				v.Frame.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
				v.Blur.Visible = callback
			end
		end,
		Default = true
	})
	Color = StorageESP:CreateColorSlider({
		Name = 'Background Color',
		DefaultValue = 0,
		DefaultOpacity = 0.5,
		Function = function(hue, sat, val, opacity)
			for _, v in Reference do
				v.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				v.Frame.BackgroundTransparency = 1 - opacity
			end
		end,
		Darker = true
	})
end)

run(function()
    local QueueDisplayConfig = {
        ActiveState = false,
        GradientControl = {Enabled = true},
        ColorSettings = {
            Gradient1 = {Hue = 0, Saturation = 0, Brightness = 1},
            Gradient2 = {Hue = 0, Saturation = 0, Brightness = 0.8}
        },
        Animation = {Speed = 0.5, Progress = 0}
    }

    local DisplayUtils = {
        createGradient = function(parent)
            local gradient = parent:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
            gradient.Parent = parent
            return gradient
        end,
        updateColor = function(gradient, config)
            local time = tick() * config.Animation.Speed
            local interp = (math.sin(time) + 1) / 2
            local h = config.ColorSettings.Gradient1.Hue + (config.ColorSettings.Gradient2.Hue - config.ColorSettings.Gradient1.Hue) * interp
            local s = config.ColorSettings.Gradient1.Saturation + (config.ColorSettings.Gradient2.Saturation - config.ColorSettings.Gradient1.Saturation) * interp
            local b = config.ColorSettings.Gradient1.Brightness + (config.ColorSettings.Gradient2.Brightness - config.ColorSettings.Gradient1.Brightness) * interp
            gradient.Color = ColorSequence.new(Color3.fromHSV(h, s, b))
        end
    }

	local CoreConnection

    local function enhanceQueueDisplay()
		pcall(function() 
			CoreConnection:Disconnect()
		end)
        local success, err = pcall(function()
            if not lplr.PlayerGui:FindFirstChild('QueueApp') then return end
            
            for attempt = 1, 3 do
                if QueueDisplayConfig.GradientControl.Enabled then
                    local queueFrame = lplr.PlayerGui.QueueApp['1']
                    queueFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    
                    local gradient = DisplayUtils.createGradient(queueFrame)
                    gradient.Rotation = 180
                    
                    local displayInterface = {
                        module = vape.watermark,
                        gradient = gradient,
                        GetEnabled = function()
                            return QueueDisplayConfig.ActiveState
                        end,
                        SetGradientEnabled = function(state)
                            QueueDisplayConfig.GradientControl.Enabled = state
                            gradient.Enabled = state
                        end
                    }
                    vape.whitelistedlines["enhancedQueueDisplay"] = displayInterface
                    --[[CoreConnection = game:GetService("RunService").RenderStepped:Connect(function()
                        if QueueDisplayConfig.ActiveState and QueueDisplayConfig.GradientControl.Enabled then
                            DisplayUtils.updateColor(gradient, QueueDisplayConfig)
                        end
                    end)--]]
                end
                task.wait(0.1)
            end
        end)
        
        if not success then
            warn("Queue display enhancement failed: " .. tostring(err))
        end
    end

    local QueueDisplayEnhancer
    QueueDisplayEnhancer = vape.Categories.World:CreateModule({
        Name = 'QueueCardMods',
        Tooltip = 'Enhances the QueueApp display with dynamic gradients',
        Function = function(enabled)
            QueueDisplayConfig.ActiveState = enabled
            if enabled then
                enhanceQueueDisplay()
                QueueDisplayEnhancer:Clean(lplr.PlayerGui.ChildAdded:Connect(enhanceQueueDisplay))
			else
				pcall(function() 
					CoreConnection:Disconnect()
				end)
			end
        end
    })

    --[[QueueDisplayEnhancer:CreateSlider({
        Name = "Animation Speed",
        Function = function(speed)
            QueueDisplayConfig.Animation.Speed = math.clamp(speed, 0.1, 5)
        end,
        Min = 1,
        Max = 5,
        Default = 5
    })

    QueueDisplayEnhancer:CreateColorSlider({
        Name = "Color 1",
        Function = function(h, s, v)
            QueueDisplayConfig.ColorSettings.Gradient1 = {Hue = h, Saturation = s, Brightness = v}
        end
    })

    QueueDisplayEnhancer:CreateColorSlider({
        Name = "Color 2",
        Function = function(h, s, v)
            QueueDisplayConfig.ColorSettings.Gradient2 = {Hue = h, Saturation = s, Brightness = v}
        end
    })--]]
end)

run(function()
	local old
	
	vape.Categories.Combat:CreateModule({
		Name = 'NoClickDelay',
		Function = function(callback)
			if callback then
				old = bedwars.SwordController.isClickingTooFast
				bedwars.SwordController.isClickingTooFast = function(self)
					self.lastSwing = tick()
					return false
				end
			else
				bedwars.SwordController.isClickingTooFast = old
			end
		end,
		Tooltip = 'Remove the CPS cap'
	})
end)

run(function()
	local AutoKit
	local Legit
	local Toggles = {}
	
	local function kitCollection(id, func, range, specific)
		local objs = type(id) == 'table' and id or collection(id, AutoKit)
		repeat
			if entitylib.isAlive then
				local localPosition = entitylib.character.RootPart.Position
				for _, v in objs do
					if InfiniteFly.Enabled or not AutoKit.Enabled then break end
					local part = not v:IsA('Model') and v or v.PrimaryPart
					if part and (part.Position - localPosition).Magnitude <= (not Legit.Enabled and specific and math.huge or range) then
						func(v)
					end
				end
			end
			task.wait(0.1)
		until not AutoKit.Enabled
	end
	
	local AutoKitFunctions = {
		necromancer = function()
			local function activateGrave(obj)
				if (not obj) then return warn("[AutoKit - necromancer.activateGrave]: No object specified!") end
				local required_args = {
					armorType = obj:GetAttribute("ArmorType"),
					weaponType = obj:GetAttribute("SwordType"),
					associatedPlayerUserId = obj:GetAttribute("GravestonePlayerUserId"),
					secret = obj:GetAttribute("GravestoneSecret"),
					position = obj:GetAttribute("GravestonePosition")
				}
				for i,v in pairs(required_args) do
					if (not v) then return warn("[AutoKit - necromancer.activateGrave]: A required arg is missing! ArgName: "..tostring(i).." ObjectName: "..tostring(obj.Name)) end
				end
				local args = {
					[1] = {
						["skeletonData"] = {
							["armorType"] = armorType,
							["weaponType"] = weaponType,
							["associatedPlayerUserId"] = associatedPlayerUserId
						},
						["secret"] = secret,
						["position"] = position
					}
				}
				return bedwars.Client:Get(remotes.ActivateGravestone):CallServer(unpack(args))								
			end
			local function verifyAttributes(obj)
				if (not obj) then return warn("[AutoKit - necromancer.verifyAttributes]: No object specified!") end
				local required_attributes = {"ArmorType", "GravestonePlayerUserId", "GravestonePosition", "GravestoneSecret", "SwordType"}
				for i,v in pairs(required_attributes) do
					if (not obj:GetAttribute(v)) then print(v.." not found in "..obj.Name); return false end
				end
				return true
			end
			task.spawn(function()
				local function checkChild(v)
					if not AutoKit.Enabled then return end
					local a = v
					if (not a) then return warn("[AutoKit - Core]: The object went missing before it could get used!") end
					if a.ClassName == "Model" and a:FindFirstChild("Root") and a.Name == "Gravestone" then
						if verifyAttributes(a) then
							local res = activateGrave(a)
							warn("[AutoKit - necromancer.activateGrave - RESULT]: "..tostring(res))
						end
					end
				end
				for i,v in pairs(game.Workspace:GetChildren()) do
					checkChild(v)
				end
				AutoKit:Clean(game.Workspace.ChildAdded:Connect(checkChild))
			end)
		end,
		battery = function()
			repeat
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position
					for i, v in bedwars.BatteryEffectsController.liveBatteries do
						if (v.position - localPosition).Magnitude <= 10 then
							local BatteryInfo = bedwars.BatteryEffectsController:getBatteryInfo(i)
							if not BatteryInfo or BatteryInfo.activateTime >= workspace:GetServerTimeNow() or BatteryInfo.consumeTime + 0.1 >= workspace:GetServerTimeNow() then continue end
							BatteryInfo.consumeTime = workspace:GetServerTimeNow()
							bedwars.Client:Get(remotes.ConsumeBattery):SendToServer({batteryId = i})
						end
					end
				end
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		beekeeper = function()
			kitCollection('bee', function(v)
				bedwars.Client:Get(remotes.BeePickup):SendToServer({beeId = v:GetAttribute('BeeId')})
			end, 18, false)
		end,
		bigman = function()
			kitCollection('treeOrb', function(v)
				if bedwars.Client:Get(remotes.ConsumeTreeOrb):CallServer({treeOrbSecret = v:GetAttribute('TreeOrbSecret')}) then
					v:Destroy()
				end
			end, 12, false)
		end,
		block_kicker = function()
			local old = bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition
			bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = function(...)
				local origin, dir = select(2, ...)
				local plr = entitylib.EntityMouse({
					Part = 'RootPart',
					Range = 1000,
					Origin = origin,
					Players = true,
					Wallcheck = true
				})
	
				if plr then
					local calc = prediction.SolveTrajectory(origin, 100, 20, plr.RootPart.Position, plr.RootPart.Velocity, workspace.Gravity, plr.HipHeight, plr.Jumping and 42.6 or nil)
	
					if calc then
						for i, v in debug.getstack(2) do
							if v == dir then
								debug.setstack(2, i, CFrame.lookAt(origin, calc).LookVector)
							end
						end
					end
				end
	
				return old(...)
			end
	
			AutoKit:Clean(function()
				bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = old
			end)
		end,
		cat = function()
			local old = bedwars.CatController.leap
			bedwars.CatController.leap = function(...)
				vapeEvents.CatPounce:Fire()
				old(...)
			end
	
			AutoKit:Clean(function()
				bedwars.CatController.leap = old
			end)
		end,
		davey = function()
			local old = bedwars.CannonHandController.launchSelf
			bedwars.CannonHandController.launchSelf = function(...)
				local res = {old(...)}
				local self, block = ...
	
				if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
					task.spawn(bedwars.breakBlock, block, false, nil, true)
				end
	
				return unpack(res)
			end
	
			AutoKit:Clean(function()
				bedwars.CannonHandController.launchSelf = old
			end)
		end,
		dragon_slayer = function()
			kitCollection('KaliyahPunchInteraction', function(v)
				bedwars.DragonSlayerController:deleteEmblem(v)
				bedwars.DragonSlayerController:playPunchAnimation(Vector3.zero)
				bedwars.Client:Get(remotes.KaliyahPunch):SendToServer({
					target = v
				})
			end, 18, true)
		end,
		farmer_cletus = function()
			kitCollection('HarvestableCrop', function(v)
				if bedwars.Client:Get(remotes.HarvestCrop):CallServer({position = bedwars.BlockController:getBlockPosition(v.Position)}) then
					bedwars.GameAnimationUtil:playAnimation(lplr.Character, bedwars.AnimationType.PUNCH)
					bedwars.SoundManager:playSound(bedwars.SoundList.CROP_HARVEST)
				end
			end, 10, false)
		end,
		fisherman = function()
			local old = bedwars.FishingMinigameController.startMinigame
			bedwars.FishingMinigameController.startMinigame = function(_, _, result)
				result({win = true})
			end
	
			AutoKit:Clean(function()
				bedwars.FishingMinigameController.startMinigame = old
			end)
		end,
		gingerbread_man = function()
			local old = bedwars.LaunchPadController.attemptLaunch
			bedwars.LaunchPadController.attemptLaunch = function(...)
				local res = {old(...)}
				local self, block = ...
	
				if (workspace:GetServerTimeNow() - self.lastLaunch) < 0.4 then
					if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
						task.spawn(bedwars.breakBlock, block, false, nil, true)
					end
				end
	
				return unpack(res)
			end
	
			AutoKit:Clean(function()
				bedwars.LaunchPadController.attemptLaunch = old
			end)
		end,
		hannah = function()
			kitCollection('HannahExecuteInteraction', function(v)
				local billboard = bedwars.Client:Get(remotes.HannahKill):CallServer({
					user = lplr,
					victimEntity = v
				}) and v:FindFirstChild('Hannah Execution Icon')
	
				if billboard then
					billboard:Destroy()
				end
			end, 30, true)
		end,
		jailor = function()
			kitCollection('jailor_soul', function(v)
				bedwars.JailorController:collectEntity(lplr, v, 'JailorSoul')
			end, 20, false)
		end,
		grim_reaper = function()
			kitCollection(bedwars.GrimReaperController.soulsByPosition, function(v)
				if entitylib.isAlive and lplr.Character:GetAttribute('Health') <= (lplr.Character:GetAttribute('MaxHealth') / 4) and (not lplr.Character:GetAttribute('GrimReaperChannel')) then
					bedwars.Client:Get(remotes.ConsumeSoul):CallServer({
						secret = v:GetAttribute('GrimReaperSoulSecret')
					})
				end
			end, 120, false)
		end,
		melody = function()
			repeat
				local mag, hp, ent = 30, math.huge
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position
					for _, v in entitylib.List do
						if v.Player and v.Player:GetAttribute('Team') == lplr:GetAttribute('Team') then
							local newmag = (localPosition - v.RootPart.Position).Magnitude
							if newmag <= mag and v.Health < hp and v.Health < v.MaxHealth then
								mag, hp, ent = newmag, v.Health, v
							end
						end
					end
				end
	
				if ent and getItem('guitar') then
					bedwars.Client:Get(remotes.GuitarHeal):SendToServer({
						healTarget = ent.Character
					})
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		metal_detector = function()
			kitCollection('hidden-metal', function(v)
				bedwars.Client:Get(remotes.PickupMetal):SendToServer({
					id = v:GetAttribute('Id')
				})
			end, 20, false)
		end,
		miner = function()
			kitCollection('petrified-player', function(v)
				bedwars.Client:Get(remotes.MinerDig):SendToServer({
					petrifyId = v:GetAttribute('PetrifyId')
				})
			end, 6, true)
		end,
		pinata = function()
			kitCollection(lplr.Name..':pinata', function(v)
				if getItem('candy') then
					bedwars.Client:Get(remotes.DepositPinata):CallServer(v)
				end
			end, 6, true)
		end,
		spirit_assassin = function()
			kitCollection('EvelynnSoul', function(v)
				bedwars.SpiritAssassinController:useSpirit(lplr, v)
			end, 120, true)
		end,
		star_collector = function()
			kitCollection('stars', function(v)
				bedwars.StarCollectorController:collectEntity(lplr, v, v.Name)
			end, 20, false)
		end,
		summoner = function()
			AutoKit:Clean(bedwars.Client:Get('SummonerClawAttackFromServer'):Connect(function(data)
				if data.player == lplr then
					bedwars.SummonerKitController:clawAttack(data.player, data.position, data.direction)
				end
			end))
	
			repeat
				local plr = entitylib.EntityPosition({
					Range = 31,
					Part = 'RootPart',
					Players = true,
					Sort = sortmethods.Health
				})
	
				if plr and (lplr.Character:GetAttribute('Health') or 0) > 0 then
					local localPosition = entitylib.character.RootPart.Position
					local shootDir = CFrame.lookAt(localPosition, plr.RootPart.Position).LookVector
					localPosition += shootDir * math.max((localPosition - plr.RootPart.Position).Magnitude - 16, 0)
	
					bedwars.Client:Get(remotes.SummonerClawAttack):SendToServer({
						position = localPosition,
						direction = shootDir,
						clientTime = workspace:GetServerTimeNow()
					})
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		void_dragon = function()
			local old = bedwars.VoidDragonController.voidDragonActive
			local oldflap = bedwars.VoidDragonController.flapWings
	
			bedwars.VoidDragonController.voidDragonActive = function(self, ...)
				local Client = bedwars.Client
				local Remote = remotes.DragonEndFly
				self.SpeedMaid:GiveTask(function()
					Client:Get(Remote):SendToServer()
				end)
	
				task.spawn(function()
					for i = 1, 10 do
						if bedwars.Client:Get(remotes.DragonFly):CallServer() then
							local modifier = bedwars.SprintController:getMovementStatusModifier():addModifier({
								blockSprint = true,
								constantSpeedMultiplier = 1.7
							})
							self.SpeedMaid:GiveTask(modifier)
							break
						end
					end
				end)
	
				return old(self, ...)
			end
			bedwars.VoidDragonController.flapWings = function() end
	
			AutoKit:Clean(function()
				bedwars.VoidDragonController.voidDragonActive = old
				bedwars.VoidDragonController.flapWings = oldflap
				task.spawn(function()
					bedwars.Client:Get(remotes.DragonEndFly):SendToServer()
				end)
			end)
	
			repeat
				if bedwars.VoidDragonController.inDragonForm then
					local plr = entitylib.EntityPosition({
						Range = 30,
						Part = 'RootPart',
						Players = true
					})
	
					if plr then
						bedwars.Client:Get(remotes.DragonBreath):SendToServer({
							player = lplr,
							targetPoint = plr.RootPart.Position
						})
					end
				end
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		warlock = function()
			local lastTarget
			repeat
				if store.hand.tool and store.hand.tool.Name == 'warlock_staff' then
					local plr = entitylib.EntityPosition({
						Range = 30,
						Part = 'RootPart',
						Players = true,
						NPCs = true
					})
	
					if plr and plr.Character ~= lastTarget then
						if not bedwars.Client:Get(remotes.WarlockTarget):CallServer({
							target = plr.Character
						}) then
							plr = nil
						end
					end
	
					lastTarget = plr and plr.Character
				else
					lastTarget = nil
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end,
		wizard = function()
			repeat
				local ability = lplr:GetAttribute('WizardAbility')
				if ability and bedwars.AbilityController:canUseAbility(ability) then
					local plr = entitylib.EntityPosition({
						Range = 50,
						Part = 'RootPart',
						Players = true,
						Sort = sortmethods.Health
					})
	
					if plr then
						bedwars.AbilityController:useAbility(ability, newproxy(true), {target = plr.RootPart.Position})
					end
				end
	
				task.wait(0.1)
			until not AutoKit.Enabled
		end
	}
	
	AutoKit = vape.Categories.Render:CreateModule({
		Name = 'AutoKit',
		Function = function(callback)
			if callback then
				repeat task.wait() until store.equippedKit ~= '' or (not AutoKit.Enabled)
				if AutoKit.Enabled and AutoKitFunctions[store.equippedKit] and Toggles[store.equippedKit].Enabled then
					AutoKitFunctions[store.equippedKit]()
				end
			end
		end,
		Tooltip = 'Automatically uses kit abilities.'
	})
	Legit = AutoKit:CreateToggle({Name = 'Legit Range'})
	local sortTable = {}
	for i in AutoKitFunctions do
		table.insert(sortTable, i)
	end
	table.sort(sortTable, function(a, b)
		return bedwars.BedwarsKitMeta[a].name < bedwars.BedwarsKitMeta[b].name
	end)
	for _, v in sortTable do
		Toggles[v] = AutoKit:CreateToggle({
			Name = bedwars.BedwarsKitMeta[v].name,
			Default = true
		})
	end
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
   	--VoidwareFunctions.GlobaliseObject("store", store)
	VoidwareFunctions.GlobaliseObject("GlobalStore", store)
end
local function onChange2(key, oldValue, newValue)
	--VoidwareFunctions.GlobaliseObject("bedwars", bedwars)
	VoidwareFunctions.GlobaliseObject("GlobalBedwars", bedwars)
end

store = createMonitoredTable(store, onChange)
bedwars = createMonitoredTable(bedwars, onChange2)