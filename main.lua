repeat task.wait() until game:IsLoaded()
if shared.packet then shared.packet:Uninject() end

if identifyexecutor and ({identifyexecutor()})[1] == 'Argon' then
	getgenv().setthreadidentity = nil
end

getgenv().setthreadidentity = function() end
getgenv().run = function(func)
	local suc, err = pcall(function() func() end)
	if (not suc) then
		warn('Error in module! Error log: '..debug.traceback(tostring(err)))
	end
end

local suc, err = pcall(function()
	return getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
end)
if (not suc) then shared.CheatEngineMode = true end

local packet
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and packet then
		packet:CreateNotification('Packet', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
if hookfunction == nil then getgenv().hookfunction = function() end end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
getgenv().cloneref = function(obj) return obj end
local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))

local oldtbl = {}
local function finishLoading()
	packet.Init = nil
	packet:Load()
	task.spawn(function()
		repeat
			shared.VapeFullyLoaded = packet.Loaded
			packet:Save()
			task.wait(10)
		until not packet.Loaded
	end)
	task.spawn(function()
		repeat
			shared.packet.ObjectsThatCanBeSaved = shared.packet.ObjectsThatCanBeSaved or {}
			if oldtbl ~= packet.Modules then
				oldtbl = packet.Modules
				for i,v in pairs(packet.Modules) do
					v.ToggleButton = function(...)
						v:Toggle(...)
					end
					if tostring(i) == "Breaker" then
						shared.packet.ObjectsThatCanBeSaved.NukerOptionsButton = {Api = v}
					end
					shared.packet.ObjectsThatCanBeSaved[tostring(i).."OptionsButton"] = {Api = v}
				end
			end
			pcall(function()
				local uipallet = packet.libraries.uipallet
				local hue, saturation, value = uipallet.Main:toHSV()
				shared.packet.ObjectsThatCanBeSaved["Gui ColorSliderColor"] = {Api = {Hue = 0, Sat = 0, Value = 0}}
                shared.packet.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, shared.packet.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, shared.packet.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value = packet.MainColor:toHSV()
			end)
			shared.GuiLibrary = shared.packet
			task.wait(10)
		until not packet.Loaded
	end)

	local function getExecutor()
		if identifyexecutor ~= nil and type(identifyexecutor) == "function" then
			local suc, res = pcall(function()
				return identifyexecutor()
			end)   
			if suc then
				return tostring(res)
			else
				return ''
			end
		else
			return ''
		end
	end
	local function isSalad()
		return string.find(string.lower(getExecutor()), 'salad')
	end

	local teleportedServers
	packet:Register('core', playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.VapeIndependent) then
			teleportedServers = true
			local teleportScript = [[
				repeat task.wait() until game:IsLoaded()
				if getgenv and not getgenv().shared then shared.CheatEngineMode = true; getgenv().shared = {}; end
				shared.VapeSwitchServers = true
				shared.vapereload = true
				if shared.VapeDeveloper or shared.VoidDev then
					if isfile('vwpacket/NewMainScript.lua') then
						loadstring(readfile("vwpacket/NewMainScript.lua"))()
					else
						
					end
				else
					
				end
			]]
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if shared.VoidDev then
				teleportScript = 'shared.VoidDev = true\n'..teleportScript
			end
			if shared.CustomCommit then
				teleportScript = "shared.CustomCommit = '"..shared.CustomCommit.."'\n"..teleportScript
			end
			if shared.ClosetCheatMode then
				teleportScript = 'shared.ClosetCheatMode = true\n'..teleportScript
			end
			if shared.RiseMode then
				teleportScript = 'shared.RiseMode = true\n'..teleportScript
			end
			if shared.VapePrivate then
				teleportScript = 'shared.VapePrivate = true\n'..teleportScript
			end
			if shared.NoVoidwareModules then
				teleportScript = 'shared.NoVoidwareModules = true\n'..teleportScript
			end
			if shared.ProfilesDisabled then
				teleportScript = 'shared.ProfilesDisabled = true\n'..teleportScript
			end
			if shared.NoAutoExecute then
				teleportScript = 'shared.NoAutoExecute = true\n'..teleportScript
			end
			if shared.TeleportExploitAutowinEnabled then
				teleportScript = 'shared.TeleportExploitAutowinEnabled = true\n'..teleportScript
			end
			if shared.VapeCustomProfile then
				teleportScript = "shared.VapeCustomProfile = '"..shared.VapeCustomProfile.."'\n"..teleportScript
			end
			if shared.TestingMode then
				teleportScript = 'shared.TestingMode = true\n'..teleportScript
			end
			packet:Save()
			if not isSalad() then
				queue_on_teleport(teleportScript)
			end
		end
	end))

	if not shared.vapereload then
		if not packet.Categories then return end
		packet:CreateNotification('Finished Loading', packet.VapeButton and 'Press the button in the top right to open GUI' or 'Press '..packet.Keybind[1]:upper()..' to open GUI', 5)
	end
end

local VWFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWRewrite/main/libraries/VoidwareFunctions.lua", true))()
--pload('libraries/VoidwareFunctions.lua', true, true)
VWFunctions.GlobaliseObject("VoidwareFunctions", VWFunctions)
VWFunctions.GlobaliseObject("VWFunctions", VWFunctions)

packet = pload('gui.lua', true, true)
packet.gui.ScreenInsets = Enum.ScreenInsets.None
packet.gui:WaitForChild("ScaledGui").Position = UDim2.new(0, 0, 0.1, 0)
shared.packet = packet
shared.vape = packet
shared.vape = shared.packet
getgenv().packet = packet
getgenv().vape = packet
getgenv().GuiLibrary = packet
shared.GuiLibrary = packet

getgenv().InfoNotification = function(title, msg, dur)
	warn('info', tostring(title), tostring(msg), tostring(dur))
	packet:CreateNotification(title, msg, dur)
end
getgenv().warningNotification = function(title, msg, dur)
	warn('warn', tostring(title), tostring(msg), tostring(dur))
	packet:CreateNotification(title, msg, dur, 'warning')
end
getgenv().errorNotification = function(title, msg, dur)
	warn("error", tostring(title), tostring(msg), tostring(dur))
	packet:CreateNotification(title, msg, dur, 'alert')
end
if shared.CheatEngineMode then
	InfoNotification("Voidware | CheatEngineMode", "Due to your executor not supporting some functions \n some modules might be missing!", 5) 
end
--[[pcall(function()
	if (not isfile('vape/discord2.txt')) then
		task.spawn(function() InfoNotification("Whitelist", "Was whitelisted and your whitelist dissapeared? Join back the discord server :D       ", 30) end)
		task.spawn(function() InfoNotification("Discord", "New server! discord.gg/voidware!              ", 30) end)
		task.spawn(function() warningNotification("Discord", "New server! discord.gg/voidware!             ", 30) end)
		task.spawn(function() errorNotification("Discord", "New server! discord.gg/voidware!              ", 30) end)
		writefile('vape/discord2.txt', '')
	end
end)--]]

local bedwarsID = {
	game = {6872274481, 8444591321, 8560631822},
	lobby = {6872265039}
}
if not shared.VapeIndependent then
	pload('games/universal.lua', true)
	pload('games/VWUniversal.lua', true)
	local fileName1 = game.PlaceId..".lua"
	local fileName2 = game.PlaceId..".lua"
	local fileName3 = ''
	local isGame = table.find(bedwarsID.game, game.PlaceId)
	local isLobby = table.find(bedwarsID.lobby, game.PlaceId)
	local CE = shared.CheatEngineMode and "CE" or ""
	if isGame then
		if game.PlaceId ~= 6872274481 then packet.Place = 6872274481 end
		fileName1 = CE.."6872274481.lua"
		fileName2 = "VW6872274481.lua"
	end
	if isLobby then
		fileName1 = CE.."6872265039.lua"
		fileName2 = "VW6872265039.lua"
	end
	warn("[CheatEngineMode]: ", tostring(shared.CheatEngineMode))
	warn("[TestingMode]: ", tostring(shared.TestingMode))
	warn("[FileName1]: ", tostring(fileName1), " [FileName2]: ", tostring(fileName2), " [FileName3]: ", tostring(fileName3))

	pload('games/'..tostring(fileName1))
	pload('games/'..tostring(fileName2))
	finishLoading()
else
	packet.Init = finishLoading
	return packet
end