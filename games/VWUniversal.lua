repeat task.wait() until game:IsLoaded()
repeat task.wait() until shared.GuiLibrary

local GuiLibrary = shared.GuiLibrary
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset
local entityLibrary = entitylib

local baseDirectory = shared.RiseMode and "rise/" or "vape/"

local runService = game:GetService("RunService")
local RunService = runService
local runservice = runService

local function run(func)
	local suc, err = pcall(function()
		func()
	end)
	if err then warn("[VWUniversal.lua Module Error]: "..tostring(debug.traceback(err))) end
end
local vapeConnections = {}
GuiLibrary.SelfDestructEvent.Event:Connect(function()
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)

task.spawn(function()
    pcall(function()
        if not isfile("Local_VW_Update_Log.json") then
            shared.UpdateLogBypass = true
        end
		loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/VWUpdateLog.lua", true))()
        shared.UpdateLogBypass = nil
    end)
end)

run(function()
	local ChangeLog = {Enabled = false}
	ChangeLog = vape.Categories.World:CreateModule({
		Name = ".ChangeLog ⭐",
		Function = function(call)
			if call then
				ChangeLog:Toggle()
                InfoNotification("ChangeLog", "Loading changelog...", 3)
                shared.UpdateLogBypass = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/VWUpdateLog.lua", true))()
			end
		end
	})
    pcall(function()
		ChangeLog.Object.TextSize = 20
	end)
end)

task.spawn(function()
	pcall(function()
		local httpService = game:GetService("HttpService")
		local function loadJson(path)
			local suc, res = pcall(function()
				return httpService:JSONDecode(readfile(path))
			end)
			return suc and type(res) == 'table' and res or nil, res
		end

		local function filterStackTrace(stackTrace)
			stackTrace = stackTrace or "Unknown"
			if type(stackTrace) ~= "string" then 
				stackTrace = "INVALID: " .. tostring(stackTrace) 
			end
			if type(stackTrace) == "string" then
				return string.split(stackTrace, "\n") or {stackTrace}
			end
			return {"Unknown"}
		end

		local function saveError(message, stackTrace)
			stackTrace = stackTrace or ''
			local errorLog = {
				Message = tostring(message), 
				StackTrace = filterStackTrace(stackTrace)
			}
			local S_Name = "CONSOLE"
			local main = {}
			if isfile('VW_Error_Log.json') then
				local res = loadJson('VW_Error_Log.json')
				main = res or main
			end
			main["LogInfo"] = {
				Version = "Normal",
				Executor = identifyexecutor and ({identifyexecutor()})[1] or "Unknown executor",
				CheatEngineMode = tostring(shared.CheatEngineMode or "Unknown") 
			}
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
			local dateKey = toDate()
			local placeJobKey = tostring(game.PlaceId) .. " | " .. tostring(game.JobId)
			main[dateKey] = main[dateKey] or {}
			main[dateKey][placeJobKey] = main[dateKey][placeJobKey] or {}
			main[dateKey][placeJobKey][S_Name] = main[dateKey][placeJobKey][S_Name] or {}
			table.insert(main[dateKey][placeJobKey][S_Name], {
				Time = getExecutionTime(),
				Data = errorLog
			})
			local success, jsonResult = pcall(function()
				return httpService:JSONEncode(main)
			end)
			if success then
				writefile('VW_Error_Log.json', jsonResult)
			else
				warn("Failed to encode JSON: " .. jsonResult)
			end
		end

		if shared.DEBUGLOGGING then 
			pcall(function()
				shared.DEBUGLOGGING:Disconnect()
			end)
		end
		shared.DEBUGLOGGING = game:GetService("ScriptContext").Error:Connect(function(message, stack, script)
			if not script then
				saveError(message, stack)
			end
		end)
	end)
end)

local colors = {
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Yellow = Color3.fromRGB(255, 255, 0),
    Cyan = Color3.fromRGB(0, 255, 255),
    Magenta = Color3.fromRGB(255, 0, 255),
    Gray = Color3.fromRGB(128, 128, 128),
    DarkGray = Color3.fromRGB(64, 64, 64),
    LightGray = Color3.fromRGB(192, 192, 192),
    Orange = Color3.fromRGB(255, 165, 0),
    Pink = Color3.fromRGB(255, 192, 203),
    Purple = Color3.fromRGB(128, 0, 128),
    Brown = Color3.fromRGB(139, 69, 19),
    LimeGreen = Color3.fromRGB(50, 205, 50),
    NavyBlue = Color3.fromRGB(0, 0, 128),
    Olive = Color3.fromRGB(128, 128, 0),
    Teal = Color3.fromRGB(0, 128, 128),
    Maroon = Color3.fromRGB(128, 0, 0),
    Gold = Color3.fromRGB(255, 215, 0),
    Silver = Color3.fromRGB(192, 192, 192),
    SkyBlue = Color3.fromRGB(135, 206, 235),
    Violet = Color3.fromRGB(238, 130, 238)
}
VoidwareFunctions.GlobaliseObject("ColorTable", colors)
VoidwareFunctions.LoadFunctions("Universal")
VoidwareFunctions.LoadServices()

local lplr = game:GetService("Players").LocalPlayer
local lightingService = game:GetService("Lighting")
local core
pcall(function() core = game:GetService('CoreGui') end)

local newcolor = function() return {Hue = 0, Sat = 0, Value = 0} end

run(function()
    local Ambience = {Enabled = false}
    local TimeToggle = {Enabled = false}
    local TimeSlider = {Value = 12} 
    local FogToggle = {Enabled = false}
    local FogDensity = {Value = 0.5}
    local ColorTint = {Hue = 0, Sat = 0, Value = 1} 
    local PresetDropdown = {Value = "Day"}

    local Lighting = vape.Services.Lighting
    local RunService = vape.Services.RunService
    local tweenService = vape.Services.TweenService

    local originalSettings = {
        TimeOfDay = Lighting.TimeOfDay,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness
    }

    local presets = {
        Day = {Time = 12, FogDensity = 0, Hue = 0, Sat = 0, Value = 1}, 
        Night = {Time = 0, FogDensity = 0.2, Hue = 0.67, Sat = 0.1, Value = 0.3}, 
        Sunset = {Time = 18, FogDensity = 0.3, Hue = 0.05, Sat = 0.5, Value = 0.8}, 
        Twilight = {Time = 20, FogDensity = 0.4, Hue = 0.6, Sat = 0.3, Value = 0.5}, 
        Misty = {Time = 8, FogDensity = 0.7, Hue = 0.5, Sat = 0.1, Value = 0.9} 
    }

    local function applyPreset(presetName)
        local preset = presets[presetName]
        if preset then
            TimeSlider.Value = preset.Time
            FogDensity.Value = preset.FogDensity
            ColorTint.Hue = preset.Hue
            ColorTint.Sat = preset.Sat
            ColorTint.Value = preset.Value
            Ambience:UpdateLighting() 
        end
    end

    local function updateLighting()
        if Ambience.Enabled then
            if TimeToggle.Enabled then
                local timeInHours = TimeSlider.Value
                Lighting.ClockTime = timeInHours
            end
            if FogToggle.Enabled then
                local fogEnd = 1000 * (1 - FogDensity.Value) + 50
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                tweenService:Create(Lighting, tweenInfo, {
                    FogStart = fogEnd * 0.1,
                    FogEnd = fogEnd,
                    FogColor = Color3.fromHSV(ColorTint.Hue, ColorTint.Sat, ColorTint.Value)
                }):Play()
            else
                Lighting.FogStart = originalSettings.FogStart
                Lighting.FogEnd = originalSettings.FogEnd
                Lighting.FogColor = originalSettings.FogColor
            end
            Lighting.Ambient = Color3.fromHSV(ColorTint.Hue, ColorTint.Sat * 0.5, ColorTint.Value * 0.5)
            Lighting.Brightness = math.clamp(ColorTint.Value, 0.5, 2) 
        end
    end

    Ambience = vape.Categories.Render:CreateModule({
        Name = "Ambience",
        Function = function(call)
            Ambience.Enabled = call
            if call then
                Ambience:Clean(RunService.Heartbeat:Connect(function()
                    updateLighting()
                end))
            else
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                tweenService:Create(Lighting, tweenInfo, {
                    ClockTime = tonumber(originalSettings.TimeOfDay:match("(%d+)%.")) or 14,
                    FogStart = originalSettings.FogStart,
                    FogEnd = originalSettings.FogEnd,
                    FogColor = originalSettings.FogColor,
                    Ambient = originalSettings.Ambient,
                    Brightness = originalSettings.Brightness
                }):Play()
            end
        end,
        Tooltip = "Customizes the game's atmosphere with time, fog, and color effects"
    })

    TimeToggle = Ambience:CreateToggle({
        Name = "Custom Time",
        Function = function(call)
            TimeToggle.Enabled = call
            if call and Ambience.Enabled then
                updateLighting()
            end
        end,
        Default = false
    })

    TimeSlider = Ambience:CreateSlider({
        Name = "Time of Day",
        Min = 0,
        Max = 24,
        Default = 12,
        Function = function(val)
            TimeSlider.Value = val
            if TimeToggle.Enabled and Ambience.Enabled then
                updateLighting()
            end
        end,
        Suffix = function(val) return string.format("%.1f hr", val) end
    })

    FogToggle = Ambience:CreateToggle({
        Name = "Fog",
        Function = function(call)
            FogToggle.Enabled = call
            if Ambience.Enabled then
                updateLighting()
            end
        end,
        Default = false
    })

    FogDensity = Ambience:CreateSlider({
        Name = "Fog Density",
        Min = 0,
        Max = 1,
        Default = 0.5,
        Function = function(val)
            if FogToggle.Enabled and Ambience.Enabled then
                updateLighting()
            end
        end,
        Suffix = function(val) return string.format("%.2f", val) end
    })

    ColorTint = Ambience:CreateColorSlider({
        Name = "Color Tint",
        Function = function(h, s, v)
            if Ambience.Enabled then
                updateLighting()
            end
        end
    })

    PresetDropdown = Ambience:CreateDropdown({
        Name = "Preset",
        List = {"Day", "Night", "Sunset", "Twilight", "Misty"},
        Function = function(val)
            if Ambience.Enabled then
                applyPreset(val)
            end
        end,
        Default = "Day"
    })
end)

run(function()
    local Weather = {Enabled = false}
    local WeatherType = {Value = "Snow"}
    local Intensity = {Value = 30}
    local Spread = {Value = 35}
    local Height = {Value = 100}
    local WindToggle = {Enabled = false}

    local RunService = vape.Services.RunService
    local Players = vape.Services.Players 
    local LocalPlayer = Players.LocalPlayer
    local tweenService = vape.Services.TweenService
    local entityLibrary = entityLibrary

    local weatherPart = nil
    local particleEmitter = nil
    local windEmitter = nil
    local atmosphere = game.Lighting:FindFirstChild("WeatherAtmosphere") or Instance.new("Atmosphere")
    atmosphere.Name = "WeatherAtmosphere"
    atmosphere.Parent = game.Lighting
    atmosphere.Density = 0

    local weatherConfigs = {
        Snow = {
            Texture = "rbxassetid://8158344433",
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.04, 1.31, 0.33),
                NumberSequenceKeypoint.new(0.75, 0.98, 0.44),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.17),
                NumberSequenceKeypoint.new(0.23, 0.63, 0.37),
                NumberSequenceKeypoint.new(0.56, 0.39, 0.28),
                NumberSequenceKeypoint.new(0.91, 0.52),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(8, 14),
            Speed = NumberRange.new(8, 18),
            RotSpeed = NumberRange.new(300),
            WindAccel = Vector3.new(0, 0, 1)
        },
        Rain = {
            Texture = "rbxassetid://2577181963",
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1, 0),
                NumberSequenceKeypoint.new(0.1, 0.5, 0),
                NumberSequenceKeypoint.new(1, 0.3, 0)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(2, 4),
            Speed = NumberRange.new(20, 30),
            RotSpeed = NumberRange.new(0),
            WindAccel = Vector3.new(2, 0, 0)
        },
        Fog = {
            
        }
    }

    local function updateWeather()
        if not Weather.Enabled then return end

        if WeatherType.Value == "Fog" then
            if particleEmitter then particleEmitter.Enabled = false end
            if windEmitter then windEmitter.Enabled = false end
            local targetDensity = Intensity.Value / 100
            tweenService:Create(atmosphere, TweenInfo.new(1, Enum.EasingStyle.Quad), {Density = targetDensity}):Play()
        else
            atmosphere.Density = 0
            if not weatherPart then
                weatherPart = Instance.new("Part")
                weatherPart.Name = "WeatherParticle"
                weatherPart.Size = Vector3.new(240, 0.5, 240)
                weatherPart.Transparency = 1
                weatherPart.CanCollide = false
                weatherPart.Anchored = true
                weatherPart.Parent = game.Workspace

                particleEmitter = Instance.new("ParticleEmitter")
                particleEmitter.EmissionDirection = Enum.NormalId.Bottom
                particleEmitter.Parent = weatherPart

                windEmitter = Instance.new("ParticleEmitter")
                windEmitter.EmissionDirection = Enum.NormalId.Bottom
                windEmitter.Parent = weatherPart
            end

            if entityLibrary.isAlive and entityLibrary.character.HumanoidRootPart then
                weatherPart.Position = entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, Height.Value, 0)
            end

            local config = weatherConfigs[WeatherType.Value]
            if config then
                particleEmitter.Rate = Intensity.Value
                particleEmitter.VelocitySpread = Spread.Value
                particleEmitter.Texture = config.Texture
                particleEmitter.Size = config.Size
                particleEmitter.Transparency = config.Transparency
                particleEmitter.Lifetime = config.Lifetime
                particleEmitter.Speed = config.Speed
                particleEmitter.RotSpeed = config.RotSpeed
                particleEmitter.SpreadAngle = Vector2.new(Spread.Value, Spread.Value)
                particleEmitter.Enabled = true

                if WindToggle.Enabled then
                    windEmitter.Rate = Intensity.Value * 0.5 
                    windEmitter.VelocitySpread = Spread.Value
                    windEmitter.Texture = config.Texture
                    windEmitter.Size = config.Size
                    windEmitter.Transparency = config.Transparency
                    windEmitter.Lifetime = config.Lifetime
                    windEmitter.Speed = config.Speed
                    windEmitter.RotSpeed = config.RotSpeed / 2
                    windEmitter.SpreadAngle = Vector2.new(Spread.Value, Spread.Value)
                    windEmitter.Acceleration = config.WindAccel
                    windEmitter.Enabled = true
                else
                    windEmitter.Enabled = false
                end
            end
        end
    end

    Weather = vape.Categories.Render:CreateModule({
        Name = "Weather",
        Function = function(callback)
            Weather.Enabled = callback
            if callback then
                Weather:Clean(RunService.Heartbeat:Connect(function()
                    updateWeather()
                end))
            else
                if weatherPart then
                    weatherPart:Destroy()
                    weatherPart = nil
                    particleEmitter = nil
                    windEmitter = nil
                end
                tweenService:Create(atmosphere, TweenInfo.new(1, Enum.EasingStyle.Quad), {Density = 0}):Play()
            end
        end,
        Tooltip = "Adds dynamic weather effects like snow, rain, and fog",
        Clean = function(connection)
            if connection then
                connection:Disconnect()
            end
        end
    })

    WeatherType = Weather:CreateDropdown({
        Name = "Weather Type",
        List = {"Snow", "Rain", "Fog"},
        Function = function(val)
            WeatherType.Value = val
            if Weather.Enabled then
                updateWeather()
            end
        end,
        Default = "Snow"
    })

    Intensity = Weather:CreateSlider({
        Name = "Intensity",
        Min = 0,
        Max = 100,
        Default = 30,
        Function = function(val)
            Intensity.Value = val
            if Weather.Enabled then
                updateWeather()
            end
        end,
        Suffix = function(val) return val .. " units" end
    })

    Spread = Weather:CreateSlider({
        Name = "Spread",
        Min = 0,
        Max = 100,
        Default = 35,
        Function = function(val)
            Spread.Value = val
            if Weather.Enabled then
                updateWeather()
            end
        end,
        Suffix = function(val) return val .. " degrees" end
    })

    Height = Weather:CreateSlider({
        Name = "Height",
        Min = 50,
        Max = 200,
        Default = 100,
        Function = function(val)
            Height.Value = val
            if Weather.Enabled then
                updateWeather()
            end
        end,
        Suffix = function(val) return val .. " studs" end
    })

    WindToggle = Weather:CreateToggle({
        Name = "Wind",
        Function = function(call)
            WindToggle.Enabled = call
            if Weather.Enabled then
                updateWeather()
            end
        end,
        Default = false
    })
end)

run(function()
    local Trails = {Enabled = false}
    local TrailColor = {Hue = 0, Sat = 1, Value = 1} -- Default red
    local TrailDistance = {Value = 7}
    local TrailLifetime = {Value = 1}
    local TrailWidth = {Value = 1}

    local RunService = vape.Services.RunService
    local Players = vape.Services.Players 
    local LocalPlayer = Players.LocalPlayer
    local tweenService = vape.Services.TweenService

    local trail = nil
    local lastPosition = nil

    local function updateTrail()
        if not Trails.Enabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if trail then trail.Enabled = false end
            return
        end

        local rootPart = LocalPlayer.Character.HumanoidRootPart

        if not trail then
            trail = Instance.new("Trail")
            trail.Name = "PlayerTrail"
            trail.Texture = "rbxassetid://446111271" 
            trail.Parent = rootPart
            trail.Attachment0 = Instance.new("Attachment", rootPart)
            trail.Attachment1 = Instance.new("Attachment", rootPart)
            trail.Attachment0.Name = "TrailStart"
            trail.Attachment1.Name = "TrailEnd"
        end

        trail.Color = ColorSequence.new(Color3.fromHSV(TrailColor.Hue, TrailColor.Sat, TrailColor.Value))
        trail.Lifetime = TrailLifetime.Value
        trail.WidthScale = NumberSequence.new(TrailWidth.Value, TrailWidth.Value * 0.5) 
        trail.Enabled = true

        local currentPosition = rootPart.Position
        if not lastPosition or (currentPosition - lastPosition).Magnitude > TrailDistance.Value then
            trail.Attachment1.Position = Vector3.new(0, 0, 0) 
            trail.Attachment0.Position = lastPosition and (lastPosition - currentPosition) or Vector3.new(0, 0, 0)
            lastPosition = currentPosition
        end
    end

    Trails = vape.Categories.Render:CreateModule({
        Name = "Trails",
        Function = function(callback)
            Trails.Enabled = callback
            if callback then
                Trails:Clean(RunService.Heartbeat:Connect(function()
                    updateTrail()
                end))
            else
                if trail then
                    trail.Enabled = false
                    trail:Destroy()
                    trail = nil
                end
                lastPosition = nil
            end
        end,
        Tooltip = "Adds a cool trail effect to your character as you move",
        Clean = function(connection)
            if connection then
                connection:Disconnect()
            end
        end
    })

    TrailColor = Trails:CreateColorSlider({
        Name = "Trail Color",
        Function = function(h, s, v)
            if Trails.Enabled then
                updateTrail()
            end
        end
    })

    TrailDistance = Trails:CreateSlider({
        Name = "Distance",
        Min = 1,
        Max = 20,
        Default = 7,
        Function = function(val)
            TrailDistance.Value = val
            if Trails.Enabled then
                updateTrail()
            end
        end,
        Suffix = function(val) return val .. " studs" end
    })

    TrailLifetime = Trails:CreateSlider({
        Name = "Lifetime",
        Min = 0.1,
        Max = 5,
        Default = 1,
        Function = function(val)
            TrailLifetime.Value = val
            if Trails.Enabled then
                updateTrail()
            end
        end,
        Suffix = function(val) return string.format("%.1f s", val) end
    })

    TrailWidth = Trails:CreateSlider({
        Name = "Width",
        Min = 0.1,
        Max = 5,
        Default = 1,
        Function = function(val)
            TrailWidth.Value = val
            if Trails.Enabled then
                updateTrail()
            end
        end,
        Suffix = function(val) return string.format("%.1f", val) end
    })
end)

run(function()
    local Torch = {Enabled = false}
    local TorchRange = {Value = 20}
    local TorchBrightness = {Value = 2}
    local TorchColor = {Hue = 0.11, Sat = 1, Value = 1}

    local RunService = vape.Services.RunService
    local Players = vape.Services.Players
    local LocalPlayer = Players.LocalPlayer

    local torchLight = nil

    local function updateTorch()
        if not Torch.Enabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if torchLight then torchLight.Enabled = false end
            return
        end

        local rootPart = LocalPlayer.Character.HumanoidRootPart

        if not torchLight then
            torchLight = Instance.new("PointLight")
            torchLight.Name = "TorchLight"
            torchLight.Parent = rootPart
        end

        torchLight.Range = TorchRange.Value
        torchLight.Brightness = TorchBrightness.Value
        torchLight.Color = Color3.fromHSV(TorchColor.Hue, TorchColor.Sat, TorchColor.Value)
        torchLight.Enabled = true
    end

    Torch = vape.Categories.Render:CreateModule({
        Name = "Torch",
        Function = function(callback)
            Torch.Enabled = callback
            if callback then
                Torch:Clean(RunService.Heartbeat:Connect(function()
                    updateTorch()
                end))
            else
                if torchLight then
                    torchLight.Enabled = false
                    torchLight:Destroy()
                    torchLight = nil
                end
            end
        end,
        Tooltip = "Adds a torch-like light to your character"
    })

    TorchRange = Torch:CreateSlider({
        Name = "Range",
        Min = 5,
        Max = 50,
        Default = 20,
        Function = function(val)
            TorchRange.Value = val
            if Torch.Enabled then
                updateTorch()
            end
        end,
        Suffix = function(val) return val .. " studs" end
    })

    TorchBrightness = Torch:CreateSlider({
        Name = "Brightness",
        Min = 0.1,
        Max = 5,
        Default = 2,
        Function = function(val)
            TorchBrightness.Value = val
            if Torch.Enabled then
                updateTorch()
            end
        end,
        Suffix = function(val) return string.format("%.1f", val) end
    })

    TorchColor = Torch:CreateColorSlider({
        Name = "Color",
        Function = function(h, s, v)
            if Torch.Enabled then
                updateTorch()
            end
        end
    })
end)

run(function()
    local Fire = {Enabled = false}
    local FireSize = {Value = 5}
    local FireHeat = {Value = 10}
    local FireColor = {Hue = 0.05, Sat = 1, Value = 1}

    local RunService = vape.Services.RunService
    local Players = vape.Services.Players
    local LocalPlayer = Players.LocalPlayer
    local tweenService = vape.Services.TweenService

    local fireEffect = nil

    local function updateFire()
        if not Fire.Enabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if fireEffect then fireEffect.Enabled = false end
            return
        end

        local rootPart = LocalPlayer.Character.HumanoidRootPart

        if not fireEffect then
            fireEffect = Instance.new("Fire")
            fireEffect.Name = "FireEffect"
            fireEffect.Parent = rootPart
        end

        fireEffect.Size = FireSize.Value
        fireEffect.Heat = FireHeat.Value
        fireEffect.Color = Color3.fromHSV(FireColor.Hue, FireColor.Sat, FireColor.Value)
        fireEffect.SecondaryColor = Color3.fromHSV(FireColor.Hue + 0.05, FireColor.Sat * 0.8, FireColor.Value * 0.8) 
        fireEffect.Enabled = true
    end

    Fire = vape.Categories.Render:CreateModule({
        Name = "Fire",
        Function = function(callback)
            Fire.Enabled = callback
            if callback then
                Fire:Clean(RunService.Heartbeat:Connect(function()
                    updateFire()
                end))
            else
                if fireEffect then
                    fireEffect.Enabled = false
                    fireEffect:Destroy()
                    fireEffect = nil
                end
            end
        end,
        Tooltip = "Adds a fiery effect to your character"
    })

    FireSize = Fire:CreateSlider({
        Name = "Size",
        Min = 1,
        Max = 20,
        Default = 5,
        Function = function(val)
            FireSize.Value = val
            if Fire.Enabled then
                updateFire()
            end
        end,
        Suffix = function(val) return val .. " units" end
    })

    FireHeat = Fire:CreateSlider({
        Name = "Heat",
        Min = 0,
        Max = 25,
        Default = 10,
        Function = function(val)
            FireHeat.Value = val
            if Fire.Enabled then
                updateFire()
            end
        end,
        Suffix = function(val) return val .. " units" end
    })

    FireColor = Fire:CreateColorSlider({
        Name = "Color",
        Function = function(h, s, v)
            if Fire.Enabled then
                updateFire()
            end
        end
    })
end)

run(function()
	local LightingTheme = {Enabled = false}
	local LightingThemeType = {Value = "LunarNight"}
	local themesky
	local themeobjects = {}
	local oldthemesettings = {
		Ambient = lightingService.Ambient,
		FogEnd = lightingService.FogEnd,
		FogStart = lightingService.FogStart,
		OutdoorAmbient = lightingService.OutdoorAmbient,
	}
	local function dumptable(tab, tabtype, sortfunction)
		local data = {}
		for i,v in pairs(tab) do
			local tabtype = tabtype and tabtype == 1 and i or v
			table.insert(data, tabtype)
		end
		if sortfunction and type(sortfunction) == "function" then
			table.sort(data, sortfunction)
		end
		return data
	end
	local themetable = {
		Purple = function()
			if themesky then
                themesky.SkyboxBk = "rbxassetid://8539982183"
                themesky.SkyboxDn = "rbxassetid://8539981943"
                themesky.SkyboxFt = "rbxassetid://8539981721"
                themesky.SkyboxLf = "rbxassetid://8539981424"
                themesky.SkyboxRt = "rbxassetid://8539980766"
                themesky.SkyboxUp = "rbxassetid://8539981085"
				lightingService.Ambient = Color3.fromRGB(170, 0, 255)
				themesky.MoonAngularSize = 0
                themesky.SunAngularSize = 0
                themesky.StarCount = 3e3
			end
		end,
		Galaxy = function()
			if themesky then
                themesky.SkyboxBk = "rbxassetid://159454299"
                themesky.SkyboxDn = "rbxassetid://159454296"
                themesky.SkyboxFt = "rbxassetid://159454293"
                themesky.SkyboxLf = "rbxassetid://159454293"
                themesky.SkyboxRt = "rbxassetid://159454293"
                themesky.SkyboxUp = "rbxassetid://159454288"
                lightingService.FogEnd = 200
                lightingService.FogStart = 0
				themesky.SunAngularSize = 0
				lightingService.OutdoorAmbient = Color3.fromRGB(172, 18, 255)
			end
		end,
		BetterNight = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://155629671"
                themesky.SkyboxDn = "rbxassetid://12064152"
                themesky.SkyboxFt = "rbxassetid://155629677"
                themesky.SkyboxLf = "rbxassetid://155629662"
                themesky.SkyboxRt = "rbxassetid://155629666"
                themesky.SkyboxUp = "rbxassetid://155629686"
				lightingService.FogColor = Color3.new(0, 20, 64)
				themesky.SunAngularSize = 0
			end
		end,
		BetterNight2 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://248431616"
                themesky.SkyboxDn = "rbxassetid://248431677"
                themesky.SkyboxFt = "rbxassetid://248431598"
                themesky.SkyboxLf = "rbxassetid://248431686"
                themesky.SkyboxRt = "rbxassetid://248431611"
                themesky.SkyboxUp = "rbxassetid://248431605"
				themesky.StarCount = 3000
			end
		end,
		MagentaOrange = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://566616113"
                themesky.SkyboxDn = "rbxassetid://566616232"
                themesky.SkyboxFt = "rbxassetid://566616141"
                themesky.SkyboxLf = "rbxassetid://566616044"
                themesky.SkyboxRt = "rbxassetid://566616082"
                themesky.SkyboxUp = "rbxassetid://566616187"
				themesky.StarCount = 3000
			end
		end,
		Purple2 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://8107841671"
				themesky.SkyboxDn = "rbxassetid://6444884785"
				themesky.SkyboxFt = "rbxassetid://8107841671"
				themesky.SkyboxLf = "rbxassetid://8107841671"
				themesky.SkyboxRt = "rbxassetid://8107841671"
				themesky.SkyboxUp = "rbxassetid://8107849791"
				themesky.SunTextureId = "rbxassetid://6196665106"
				themesky.MoonTextureId = "rbxassetid://6444320592"
				themesky.MoonAngularSize = 0
			end
		end,
		Galaxy2 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://14164368678"
				themesky.SkyboxDn = "rbxassetid://14164386126"
				themesky.SkyboxFt = "rbxassetid://14164389230"
				themesky.SkyboxLf = "rbxassetid://14164398493"
				themesky.SkyboxRt = "rbxassetid://14164402782"
				themesky.SkyboxUp = "rbxassetid://14164405298"
				themesky.SunTextureId = "rbxassetid://8281961896"
				themesky.MoonTextureId = "rbxassetid://6444320592"
				themesky.SunAngularSize = 0
				themesky.MoonAngularSize = 0
				lightingService.OutdoorAmbient = Color3.fromRGB(172, 18, 255)
			end
		end,
		Pink = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://271042516"
				themesky.SkyboxDn = "rbxassetid://271077243"
				themesky.SkyboxFt = "rbxassetid://271042556"
				themesky.SkyboxLf = "rbxassetid://271042310"
				themesky.SkyboxRt = "rbxassetid://271042467"
				themesky.SkyboxUp = "rbxassetid://271077958"
			end
		end,
		Purple3 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://433274085"
				themesky.SkyboxDn = "rbxassetid://433274194"
				themesky.SkyboxFt = "rbxassetid://433274131"
				themesky.SkyboxLf = "rbxassetid://433274370"
				themesky.SkyboxRt = "rbxassetid://433274429"
				themesky.SkyboxUp = "rbxassetid://433274285"
				lightingService.FogColor = Color3.new(170, 0, 255)
				lightingService.FogEnd = 200
				lightingService.FogStart = 0
			end
		end,
		DarkishPink = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://570555736"
				themesky.SkyboxDn = "rbxassetid://570555964"
				themesky.SkyboxFt = "rbxassetid://570555800"
				themesky.SkyboxLf = "rbxassetid://570555840"
				themesky.SkyboxRt = "rbxassetid://570555882"
				themesky.SkyboxUp = "rbxassetid://570555929"
			end
		end,
		Space = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://166509999"
			themesky.SkyboxDn = "rbxassetid://166510057"
			themesky.SkyboxFt = "rbxassetid://166510116"
			themesky.SkyboxLf = "rbxassetid://166510092"
			themesky.SkyboxRt = "rbxassetid://166510131"
			themesky.SkyboxUp = "rbxassetid://166510114"
		end,
		Galaxy3 = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://14543264135"
			themesky.SkyboxDn = "rbxassetid://14543358958"
			themesky.SkyboxFt = "rbxassetid://14543257810"
			themesky.SkyboxLf = "rbxassetid://14543275895"
			themesky.SkyboxRt = "rbxassetid://14543280890"
			themesky.SkyboxUp = "rbxassetid://14543371676"
		end,
		NetherWorld = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://14365019002"
			themesky.SkyboxDn = "rbxassetid://14365023350"
			themesky.SkyboxFt = "rbxassetid://14365018399"
			themesky.SkyboxLf = "rbxassetid://14365018705"
			themesky.SkyboxRt = "rbxassetid://14365018143"
			themesky.SkyboxUp = "rbxassetid://14365019327"
		end,
		Nebula = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://5260808177"
			themesky.SkyboxDn = "rbxassetid://5260653793"
			themesky.SkyboxFt = "rbxassetid://5260817288"
			themesky.SkyboxLf = "rbxassetid://5260800833"
			themesky.SkyboxRt = "rbxassetid://5260811073"
			themesky.SkyboxUp = "rbxassetid://5260824661"
			lightingService.Ambient = Color3.fromRGB(170, 0, 255)
		end,
		PurpleNight = function()
			if themesky then
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://5260808177"
			themesky.SkyboxDn = "rbxassetid://5260653793"
			themesky.SkyboxFt = "rbxassetid://5260817288"
			themesky.SkyboxLf = "rbxassetid://5260800833"
			themesky.SkyboxRt = "rbxassetid://5260800833"
			themesky.SkyboxUp = "rbxassetid://5084576400"
			lightingService.Ambient = Color3.fromRGB(170, 0, 255)
			end
		end,
		Aesthetic = function()
			if themesky then
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://1417494030"
			themesky.SkyboxDn = "rbxassetid://1417494146"
			themesky.SkyboxFt = "rbxassetid://1417494253"
			themesky.SkyboxLf = "rbxassetid://1417494402"
			themesky.SkyboxRt = "rbxassetid://1417494499"
			themesky.SkyboxUp = "rbxassetid://1417494643"
			end
		end,
		Aesthetic2 = function()
			if themesky then
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://600830446"
			themesky.SkyboxDn = "rbxassetid://600831635"
			themesky.SkyboxFt = "rbxassetid://600832720"
			themesky.SkyboxLf = "rbxassetid://600886090"
			themesky.SkyboxRt = "rbxassetid://600833862"
			themesky.SkyboxUp = "rbxassetid://600835177"
			end
		end,
		Pastel = function()
			if themesky then
			themesky.SunAngularSize = 0
			themesky.MoonAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://2128458653"
			themesky.SkyboxDn = "rbxassetid://2128462480"
			themesky.SkyboxFt = "rbxassetid://2128458653"
			themesky.SkyboxLf = "rbxassetid://2128462027"
			themesky.SkyboxRt = "rbxassetid://2128462027"
			themesky.SkyboxUp = "rbxassetid://2128462236"
			end
		end,
		PurpleClouds = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://570557514"
			themesky.SkyboxDn = "rbxassetid://570557775"
			themesky.SkyboxFt = "rbxassetid://570557559"
			themesky.SkyboxLf = "rbxassetid://570557620"
			themesky.SkyboxRt = "rbxassetid://570557672"
			themesky.SkyboxUp = "rbxassetid://570557727"
			lightingService.Ambient = Color3.fromRGB(172, 18, 255)
			end
		end,
		BetterSky = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://591058823"
			themesky.SkyboxDn = "rbxassetid://591059876"
			themesky.SkyboxFt = "rbxassetid://591058104"
			themesky.SkyboxLf = "rbxassetid://591057861"
			themesky.SkyboxRt = "rbxassetid://591057625"
			themesky.SkyboxUp = "rbxassetid://591059642"
			end
		end,
		BetterNight3 = function()
			if themesky then
			themesky.MoonTextureId = "rbxassetid://1075087760"
			themesky.SkyboxBk = "rbxassetid://2670643994"
			themesky.SkyboxDn = "rbxassetid://2670643365"
			themesky.SkyboxFt = "rbxassetid://2670643214"
			themesky.SkyboxLf = "rbxassetid://2670643070"
			themesky.SkyboxRt = "rbxassetid://2670644173"
			themesky.SkyboxUp = "rbxassetid://2670644331"
			themesky.MoonAngularSize = 1.5
			themesky.StarCount = 500
			pcall(function()
			local MoonColorCorrection = Instance.new("ColorCorrection")
			table.insert(themeobjects, MoonColorCorrection)
			MoonColorCorrection.Enabled = true
			MoonColorCorrection.TintColor = Color3.fromRGB(189, 179, 178)
			MoonColorCorrection.Parent = game.Workspace
			local MoonBlur = Instance.new("BlurEffect")
			table.insert(themeobjects, MoonBlur)
			MoonBlur.Enabled = true
			MoonBlur.Size = 9
			MoonBlur.Parent = game.Workspace
			local MoonBloom = Instance.new("BloomEffect")
			table.insert(themeobjects, MoonBloom)
			MoonBloom.Enabled = true
			MoonBloom.Intensity = 100
			MoonBloom.Size = 56
			MoonBloom.Threshold = 5
			MoonBloom.Parent = game.Workspace
			end)
			end
		end,
		Orange = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://150939022"
			themesky.SkyboxDn = "rbxassetid://150939038"
			themesky.SkyboxFt = "rbxassetid://150939047"
			themesky.SkyboxLf = "rbxassetid://150939056"
			themesky.SkyboxRt = "rbxassetid://150939063"
			themesky.SkyboxUp = "rbxassetid://150939082"
			end
		end,
		DarkMountains = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://5098814730"
				themesky.SkyboxDn = "rbxassetid://5098815227"
				themesky.SkyboxFt = "rbxassetid://5098815653"
				themesky.SkyboxLf = "rbxassetid://5098816155"
				themesky.SkyboxRt = "rbxassetid://5098820352"
				themesky.SkyboxUp = "rbxassetid://5098819127"
			end
		end,
		FlamingSunset = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://415688378"
			themesky.SkyboxDn = "rbxassetid://415688193"
			themesky.SkyboxFt = "rbxassetid://415688242"
			themesky.SkyboxLf = "rbxassetid://415688310"
			themesky.SkyboxRt = "rbxassetid://415688274"
			themesky.SkyboxUp = "rbxassetid://415688354"
			end
		end,
		NewYork = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://11333973069"
			themesky.SkyboxDn = "rbxassetid://11333969768"
			themesky.SkyboxFt = "rbxassetid://11333964303"
			themesky.SkyboxLf = "rbxassetid://11333971332"
			themesky.SkyboxRt = "rbxassetid://11333982864"
			themesky.SkyboxUp = "rbxassetid://11333967970"
			themesky.SunAngularSize = 0
			end
		end,
		Aesthetic3 = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://151165214"
			themesky.SkyboxDn = "rbxassetid://151165197"
			themesky.SkyboxFt = "rbxassetid://151165224"
			themesky.SkyboxLf = "rbxassetid://151165191"
			themesky.SkyboxRt = "rbxassetid://151165206"
			themesky.SkyboxUp = "rbxassetid://151165227"
			end
		end,
		FakeClouds = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://8496892810"
			themesky.SkyboxDn = "rbxassetid://8496896250"
			themesky.SkyboxFt = "rbxassetid://8496892810"
			themesky.SkyboxLf = "rbxassetid://8496892810"
			themesky.SkyboxRt = "rbxassetid://8496892810"
			themesky.SkyboxUp = "rbxassetid://8496897504"
			themesky.SunAngularSize = 0
			end
		end,
		LunarNight = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://187713366"
				themesky.SkyboxDn = "rbxassetid://187712428"
				themesky.SkyboxFt = "rbxassetid://187712836"
				themesky.SkyboxLf = "rbxassetid://187713755"
				themesky.SkyboxRt = "rbxassetid://187714525"
				themesky.SkyboxUp = "rbxassetid://187712111"
				themesky.SunAngularSize = 0
				themesky.StarCount = 0
			end
		end,
		PitchDark = function()
			themesky.StarCount = 0
			lightingService.TimeOfDay = "00:00:00"
			LightingTheme:Clean(lightingService:GetPropertyChangedSignal("TimeOfDay"):Connect(function()
				pcall(function()
				themesky.StarCount = 0
				lightingService.TimeOfDay = "00:00:00"
				end)
			end))
		end
	}
	LightingTheme = vape.Categories.World:CreateModule({
		Name = "LightingTheme",
		Tooltip = "Add a whole new look to your game.",
		ExtraText = function() return LightingThemeType.Value end,
		Function = function(callback) 
			if callback then 
				task.spawn(function()
					task.wait()
					themesky = Instance.new("Sky")
					local success, err = pcall(themetable[LightingThemeType.Value])
					err = err and " | "..err or ""
					vapeAssert(success, "LightingTheme", "Failed to load the "..LightingThemeType.Value.." theme."..err, 5)
					themesky.Parent = success and lightingService or nil
					LightingTheme:Clean(lightingService.ChildAdded:Connect(function(v)
						if success and v:IsA("Sky") then 
							v.Parent = nil
						end
					end))
				end)
			else
				if themesky then 
					themesky = pcall(function() themesky:Destroy() end)
					for i,v in pairs(themeobjects) do 
						pcall(function() v:Destroy() end)
					end
					table.clear(themeobjects)
					for i,v in pairs(lightingService:GetChildren()) do 
						if v:IsA("Sky") and themesky then 
							pcall(function()
								v.Parent = nil 
								v.Parent = lightingService
							end)
						end
					end
					for i,v in pairs(oldthemesettings) do 
						pcall(function() lightingService[i] = v end)
					end
				end
				themesky = nil
			end
		end
	})
	LightingThemeType = LightingTheme:CreateDropdown({
		Name = "Theme",
		List = dumptable(themetable, 1),
		Function = function()
			if LightingTheme.Enabled then 
				LightingTheme:Toggle(false)
				LightingTheme:Toggle(false)
			end
		end
	})
end)

local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({Tasks = {}}, Maid)
end

function Maid:Add(task)
    if typeof(task) == "RBXScriptConnection" or (typeof(task) == "Instance" and task.Destroy) or typeof(task) == "function" then
        table.insert(self.Tasks, task)
    end
    return task
end

function Maid:Clean()
    for _, task in ipairs(self.Tasks) do
		pcall(function()
			if typeof(task) == "RBXScriptConnection" then
				task:Disconnect()
			elseif typeof(task) == "Instance" then
				task:Destroy()
			elseif typeof(task) == "function" then
				task()
			end
		end)
    end
	table.clear(self.Tasks)
    self.Tasks = {}
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

run(function()
    local maid = Maid.new()
    local CustomChat = {Enabled = false}
    local Config = {
        Kill = false,
        ["Bed Break"] = false,
        ["Final Kill"] = false,
        Win = false,
        Defeat = false,
        TypeWrite = false,
        DragEnabled = false,
        CleanOld = false,
		Joins = false,
		Leaves = false,
		Enabled = false,
        Transparency = 1,
        MaxMessages = 50 
    }
	local GradientEnabled = false
    local scale
    local Players
    local guiService
    local StarterGui
    local RunService
    local TweenService
    local inputService
    local TextChatService
    local UserInputService

    local chatColor1, chatColor2, chatColor3, chatThirdColorToggle
    local chatGradient, chatGradientRotationTask

    local function brickColorToRGB(brickColor)
        local color3 = brickColor.Color
        return math.floor(color3.R * 255), math.floor(color3.G * 255), math.floor(color3.B * 255)
    end

    local function makeDraggable(gui, window)
        inputService = inputService or Services.UserInputService
        guiService = guiService or Services.GuiService
        scale = scale or vape.gui.ScaledGui:FindFirstChildOfClass("UIScale")
        if not scale then scale = {Scale = 1} end
        local con = gui.InputBegan:Connect(function(inputObj)
            if window and not window.Visible then return end
            if
                (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
                and (inputObj.Position.Y - gui.AbsolutePosition.Y < 40 or window)
            then
                local dragPosition = Vector2.new(
                    gui.AbsolutePosition.X - inputObj.Position.X,
                    gui.AbsolutePosition.Y - inputObj.Position.Y + guiService:GetGuiInset().Y
                ) / scale.Scale

                local changed = inputService.InputChanged:Connect(function(input)
                    if not Config.DragEnabled then return end
                    if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
                        local position = input.Position
                        if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            dragPosition = (dragPosition // 3) * 3
                            position = (position // 3) * 3
                        end
                        gui.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
                    end
                end)

                local ended
                ended = inputObj.Changed:Connect(function()
                    if inputObj.UserInputState == Enum.UserInputState.End then
                        if changed then
                            changed:Disconnect()
                        end
                        if ended then
                            ended:Disconnect()
                        end
                    end
                end)
            end
        end)
        return con
    end

    local addMessage

    local function typewrite(object, text)
        if not Config.TypeWrite then object.Text = text; return end
        if not object or not text then return end
        if not object:IsA("TextLabel") and not object:IsA("TextBox") then
            warn("typewrite: Object must be a TextLabel or TextBox")
            return
        end

        local function parseChars(str)
            local chars = {}
            local i = 1
            while i <= #str do
                if str:sub(i, i + 4) == "<font" then
                    local tagEnd = str:find(">", i)
                    if tagEnd then
                        table.insert(chars, str:sub(i, tagEnd))
                        i = tagEnd + 1
                    else
                        table.insert(chars, str:sub(i, i))
                        i = i + 1
                    end
                elseif str:sub(i, i + 6) == "</font>" then
                    table.insert(chars, "</font>")
                    i = i + 7
                else
                    table.insert(chars, str:sub(i, i))
                    i = i + 1
                end
            end
            return chars
        end

        object.Text = ""

        local chars = parseChars(text)
        RunService = RunService or Services.RunService
        local index, total = 1, #chars
        local con
        con = RunService.RenderStepped:Connect(function()
            local suc, err = pcall(function()
                if index <= total then
                    object.Text = table.concat(chars, "", 1, index)
                    index = index + 1
                else
                    pcall(function()
                        con:Disconnect()
                    end)
                end
            end)
            if not suc then
                pcall(function()
                    con:Disconnect()
                end)
            end
        end)
    end

    local custom_notify = function(notifType, killerPlayer, killedPlayer, finalKill, data)
        if not (CustomChat.Enabled and addMessage) then return end
        local suc, res = pcall(function()
            if notifType == "kill" then
                if not Config.Kill then return end
                local killedName = killedPlayer and killedPlayer.Name or "Unknown"
                local killerName = killerPlayer and killerPlayer.Name or "Unknown"

                local killedTeamColor = BrickColor.White()
                local killerTeamColor = BrickColor.White()
                if killedPlayer then
                    local killedPlr = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(killedName))
                    killedTeamColor = killedPlr and killedPlr.TeamColor or BrickColor.White()
                end
                if killerPlayer then
                    local killerPlr = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(killerName))
                    killerTeamColor = killerPlr and killerPlr.TeamColor or BrickColor.White()
                end

                local r1, g1, b1 = brickColorToRGB(killedTeamColor)
                local r2, g2, b2 = brickColorToRGB(killerTeamColor)
                local formattedKilled = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r1, g1, b1, killedName)
                local formattedKiller = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r2, g2, b2, killerName)

                local message = string.format("%s was killed by %s", formattedKilled, formattedKiller)

                if finalKill and Config["Final Kill"] then
                    message = message .. " <font color=\"rgb(0,255,255)\">FINAL KILL!</font>"
                end

                addMessage(message, nil, true)

            elseif notifType == "bedbreak" then
                if not Config["Bed Break"] then return end
                local killerName = killerPlayer and killerPlayer.Name or "Unknown"
                local bedName, bedColor = "Unknown", nil
                if data then
                    bedName = data.Name
                    bedColor = data.Color
                end

                local killerTeamColor = BrickColor.White()
                if killerPlayer then
                    local killerPlr = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(killerName))
                    killerTeamColor = killerPlr and killerPlr.TeamColor or BrickColor.White()
                end

                local r, g, b = brickColorToRGB(killerTeamColor)
                local formattedKiller = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, killerName)

                local bedR, bedG, bedB = 255, 255, 255
                if bedColor then
                    if typeof(bedColor) == "BrickColor" then
                        bedR, bedG, bedB = brickColorToRGB(bedColor)
                    elseif typeof(bedColor) == "Color3" then
                        bedR, bedG, bedB = math.floor(bedColor.R * 255), math.floor(bedColor.G * 255), math.floor(bedColor.B * 255)
                    end
                end

                local formattedBed = string.format('<font color="rgb(%d,%d,%d)">%s BED</font>', bedR, bedG, bedB, bedName)

                local message = string.format('<font size="18">BED DESTRUCTION > </font>» %s was destroyed by %s', formattedBed, formattedKiller)
                addMessage(message, nil, true)

            elseif notifType == "win" then
                if not Config.Win then return end
                local teamName = data and data.Name or "Unknown"
                local teamColor = data and data.Color or BrickColor.White()

                local teamR, teamG, teamB = 255, 255, 255
                if teamColor then
                    if typeof(teamColor) == "BrickColor" then
                        teamR, teamG, teamB = brickColorToRGB(teamColor)
                    elseif typeof(teamColor) == "Color3" then
                        teamR, teamG, teamB = math.floor(teamColor.R * 255), math.floor(teamColor.G * 255), math.floor(teamColor.B * 255)
                    end
                end

                teamName = teamName.." TEAM"
                local formattedTeam = string.format('<font color="rgb(%d,%d,%d)">%s</font>', teamR, teamG, teamB, teamName)
                local message = string.format('<font size="20" color="rgb(255,255,0)">🏆 VICTORY! %s has won the game!</font>', formattedTeam)
                addMessage(message, nil, true)

            elseif notifType == "defeat" then
                if not Config.Defeat then return end
                local teamName = data and data.Name or "Unknown"
                local teamColor = data and data.Color or BrickColor.White()

                local teamR, teamG, teamB = 255, 255, 255
                if teamColor then
                    if typeof(teamColor) == "BrickColor" then
                        teamR, teamG, teamB = brickColorToRGB(teamColor)
                    elseif typeof(teamColor) == "Color3" then
                        teamR, teamG, teamB = math.floor(teamColor.R * 255), math.floor(bedColor.G * 255), math.floor(bedColor.B * 255)
                    end
                end

                teamName = teamName.." TEAM"
                local formattedTeam = string.format('<font color="rgb(%d,%d,%d)">%s</font>', teamR, teamG, teamB, teamName)
                local message = string.format('<font size="20" color="rgb(128,128,128)">💔 DEFEAT! %s has lost the game.</font>', formattedTeam)
                addMessage(message, nil, true)
            end
        end)

        if not suc then
            warn("Error in custom_notify function: " .. res)
            addMessage("Error in notification. Check console.", nil, true)
        end
    end

	local updateChatVisibility = function() end

    TextChatService = TextChatService or Services.TextChatService
    local old1, old2, old3 = TextChatService.ChatWindowConfiguration.Enabled, TextChatService.ChatInputBarConfiguration.Enabled, TextChatService.ChannelTabsConfiguration.Enabled
    shared.custom_notify = custom_notify

    CustomChat = vape.Categories.World:CreateModule({
        Name = "CustomChat",
        Function = function(call)
			Config.Enabled = call
            if call then
                Players = Players or Services.Players
                RunService = RunService or Services.RunService
                StarterGui = StarterGui or Services.StarterGui
                TweenService = TweenService or Services.TweenService
                UserInputService = UserInputService or Services.UserInputService

                local core = {
                    font = Enum.Font.SourceSans
                }

                local player = Players.LocalPlayer
                shared.TagRegister = shared.TagRegister or {}
                shared.TagRegister[player] = "<font color='rgb(255,105,180)'>[MEOW]</font>"

                maid:Add(function()
                    TextChatService.ChatWindowConfiguration.Enabled = old1
                    TextChatService.ChatInputBarConfiguration.Enabled = old2
                    TextChatService.ChannelTabsConfiguration.Enabled = old3
                end)

                TextChatService.ChatWindowConfiguration.Enabled = false
                TextChatService.ChatInputBarConfiguration.Enabled = false
                TextChatService.ChannelTabsConfiguration.Enabled = false

                local playerGui = player:WaitForChild("PlayerGui")

                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "CustomChatGui"
                screenGui.Parent = playerGui
                screenGui.ResetOnSpawn = false
                screenGui.Enabled = true

                maid:Add(screenGui)

                local chatFrame = Instance.new("Frame")
                chatFrame.Size = UDim2.new(0.29, 0, 0.4, 0)
                chatFrame.AnchorPoint = Vector2.new(0, 0.2)
                chatFrame.Position = UDim2.new(0, 5, 0.4, 0)
                chatFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                chatFrame.BackgroundTransparency = Config.Transparency/10
                chatFrame.BorderSizePixel = 0
                chatFrame.Parent = screenGui

                chatGradient = Instance.new("UIGradient", chatFrame)
                chatGradient.Rotation = 0
                local function getChatColorFromSlider(slider)
                    return Color3.fromHSV(slider.Hue, slider.Sat, slider.Value)
                end
                function updateChatGradient()
					if not GradientEnabled then
						chatFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
						chatGradient.Enabled = false
					else
						chatFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						chatGradient.Enabled = true
					end
                    local c1 = getChatColorFromSlider(chatColor1)
                    local c2 = getChatColorFromSlider(chatColor2)
                    if chatThirdColorToggle and chatThirdColorToggle.Enabled then
                        local c3 = getChatColorFromSlider(chatColor3)
                        chatGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, c1),
                            ColorSequenceKeypoint.new(0.5, c2),
                            ColorSequenceKeypoint.new(1, c3)
                        })
                    else
                        chatGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, c1),
                            ColorSequenceKeypoint.new(1, c2)
                        })
                    end
                end
                if chatGradientRotationTask then pcall(function() task.cancel(chatGradientRotationTask) end) end
                chatGradientRotationTask = task.spawn(function()
                    while chatFrame and chatFrame.Parent do
                        chatGradient.Rotation = (chatGradient.Rotation + 1) % 360
                        task.wait(0.01)
                    end
                end)

                local chatFrameCorner = Instance.new("UICorner")
                chatFrameCorner.CornerRadius = UDim.new(0, 8)
                chatFrameCorner.Parent = chatFrame

                local scrollingFrame = Instance.new("ScrollingFrame")
                scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
                scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
                scrollingFrame.BackgroundTransparency = 1
                scrollingFrame.BorderSizePixel = 0
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                scrollingFrame.ScrollBarThickness = 0
                scrollingFrame.Parent = chatFrame

                local uiListLayout = Instance.new("UIListLayout")
                uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                uiListLayout.Padding = UDim.new(0, 2)
                uiListLayout.Parent = scrollingFrame

                local inputBox = Instance.new("TextBox")
                inputBox.Size = UDim2.new(0.29, 0, 0, 20)
                inputBox.Position = UDim2.new(0, 5, 0.73, 0)
                inputBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
                inputBox.BackgroundTransparency = Config.Transparency/10
                inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                inputBox.PlaceholderText = "Message in Public..."
                inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                inputBox.Text = ""
                inputBox.TextSize = 14
                inputBox.Font = Enum.Font.SourceSans
                inputBox.ClearTextOnFocus = true
                inputBox.Parent = screenGui

                maid:Add(makeDraggable(chatFrame, inputBox))

                local inputBoxCorner = Instance.new("UICorner")
                inputBoxCorner.CornerRadius = UDim.new(0, 8)
                inputBoxCorner.Parent = inputBox

                local isChatActive = false
                local fadeTimer = 0
                local FADE_DELAY = 5

                updateChatVisibility = function()
                    if isChatActive then
                        TweenService:Create(chatFrame, TweenInfo.new(0.5), {BackgroundTransparency = Config.Transparency/10}):Play()
                        TweenService:Create(inputBox, TweenInfo.new(0.5), {BackgroundTransparency = Config.Transparency/10, TextTransparency = 0}):Play()
                    else
                        TweenService:Create(chatFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
                        TweenService:Create(inputBox, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
                    end
                end

				pcall(updateChatGradient)

                local function resetFadeTimer()
                    fadeTimer = 0
                    isChatActive = true
                    updateChatVisibility()
                end

                maid:Add(RunService.Heartbeat:Connect(function(deltaTime)
                    if not isChatActive then return end
                    fadeTimer = fadeTimer + deltaTime
                    if fadeTimer >= FADE_DELAY and not inputBox:IsFocused() then
                        isChatActive = false
                        updateChatVisibility()
                    end
                end))

                addMessage = function(message, senderName, isSystem, teamColor, noSeparator)
                    local suc, res = pcall(function()
                        local messages = scrollingFrame:GetChildren()
                        local messageCount = 0
                        for _, child in ipairs(messages) do
                            if child:IsA("Frame") then
                                messageCount = messageCount + 1
                            end
                        end
                        if messageCount >= Config.MaxMessages then
                            for _, child in ipairs(messages) do
                                if child:IsA("Frame") then
                                    child:Destroy()
                                    break 
                                end
                            end
                        end

                        local messageFrame = Instance.new("Frame")
                        messageFrame.Size = UDim2.new(1, -10, 0, 20)
                        messageFrame.Position = UDim2.new(0, 0, 0, 0)
                        messageFrame.BackgroundTransparency = 1
                        messageFrame.Parent = scrollingFrame

                        local senderLabel = Instance.new("TextLabel")
                        senderLabel.Name = "Sender"
                        senderLabel.Size = UDim2.new(0, 0, 1, 0)
                        senderLabel.Position = UDim2.new(0, 0, 0, 0)
                        senderLabel.BackgroundTransparency = 1
                        senderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        senderLabel.TextSize = 16
                        senderLabel.Font = core.font
                        senderLabel.TextXAlignment = Enum.TextXAlignment.Left
                        senderLabel.RichText = true
                        senderLabel.TextTransparency = 1
                        senderLabel.Parent = messageFrame

                        local separatorLabel = Instance.new("TextLabel")
                        separatorLabel.Name = "Separator"
                        separatorLabel.Size = UDim2.new(0, 20, 0, 20)
                        separatorLabel.Position = UDim2.new(0, 0, 0, 0)
                        separatorLabel.BackgroundTransparency = 1
                        separatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        senderLabel.TextSize = 16
                        separatorLabel.TextSize = 14
                        separatorLabel.Font = core.font
                        separatorLabel.TextXAlignment = Enum.TextXAlignment.Left
                        separatorLabel.RichText = true
                        separatorLabel.Text = "»"
                        separatorLabel.TextTransparency = 1
                        separatorLabel.Parent = messageFrame

                        local messageLabel = Instance.new("TextLabel")
                        messageLabel.Name = "Message"
                        messageLabel.Size = UDim2.new(0, 0, 1, 0)
                        messageLabel.Position = UDim2.new(0, 0, 0, 0)
                        messageLabel.BackgroundTransparency = 1
                        messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        messageLabel.TextSize = 15
                        messageLabel.Font = Enum.Font.FredokaOne
                        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
                        messageLabel.RichText = true
                        messageLabel.TextTransparency = 1
                        messageLabel.Parent = messageFrame

                        for _, child in ipairs(messageFrame:GetChildren()) do
                            if child:IsA("TextLabel") then
                                TweenService:Create(child, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
                            end
                        end

                        task.spawn(function()
                            task.wait(10)
                            if messageFrame and messageFrame.Parent and not isChatActive and Config.CleanOld then
                                for _, child in ipairs(messageFrame:GetChildren()) do
                                    if child:IsA("TextLabel") then
                                        TweenService:Create(child, TweenInfo.new(1), {TextTransparency = 1}):Play()
                                    end
                                end
                                task.wait(1)
                                if messageFrame and messageFrame.Parent then
                                    messageFrame:Destroy()
                                end
                            end
                        end)

                        local final_message, formatted_message

                        if isSystem then
                            senderLabel.Text = ""
                            separatorLabel.Text = "»"
                            final_message = message
                        else
                            local r, g, b = brickColorToRGB(teamColor or BrickColor.White())
                            local formattedSender = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, senderName)
                            local formattedMessage = string.format('<font size="12">%s</font>', message)

                            local tagText = ""
                            TagRegister = shared.TagRegister or {}
                            local senderPlayer = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(senderName))
                            if senderPlayer then
                                local tags = {}
                                if TagRegister[senderPlayer] then
                                    table.insert(tags, TagRegister[senderPlayer])
                                end

                                local tagsFolder = senderPlayer:FindFirstChild("Tags")
                                if tagsFolder and tagsFolder:IsA("Folder") then
                                    local folderContents = tagsFolder:GetChildren()
                                    local validTags = {}
                                    for _, child in ipairs(folderContents) do
                                        if child:IsA("StringValue") then
                                            table.insert(validTags, {Name = child.Name, Value = child.Value})
                                        end
                                    end

                                    table.sort(validTags, function(a, b)
                                        local aNum, bNum = tonumber(a.Name), tonumber(b.Name)
                                        if aNum and bNum then
                                            return aNum < bNum
                                        else
                                            return a.Name < b.Name
                                        end
                                    end)

                                    for _, tag in ipairs(validTags) do
                                        table.insert(tags, tag.Value)
                                    end
                                end

                                if #tags > 0 then
                                    tagText = table.concat(tags, " ") .. " "
                                end
                            end

                            senderLabel.Text = tagText .. formattedSender
                            separatorLabel.Text = "»"
                            final_message = message
                            formatted_message = formattedMessage
                        end
                        if noSeparator then separatorLabel.Text = '' end

                        senderLabel.TextWrapped = false
                        messageLabel.TextWrapped = true

                        local senderBounds = senderLabel.TextBounds
                        senderLabel.Size = UDim2.new(0, senderBounds.X, 1, 0)

                        separatorLabel.Position = UDim2.new(0, senderBounds.X + 5, 0, 0)

                        local separatorBounds = separatorLabel.TextBounds
                        messageLabel.Position = UDim2.new(0, senderBounds.X + separatorBounds.X + 10, 0.07, 0)
                        messageLabel.Size = UDim2.new(1, -(senderBounds.X + separatorBounds.X), 1, 0)

                        local messageBounds = messageLabel.TextBounds
                        local totalHeight = math.max(20, math.max(senderBounds.Y, messageBounds.Y))
                        messageFrame.Size = UDim2.new(1, -10, 0, totalHeight)

                        local totalHeightCanvas = uiListLayout.AbsoluteContentSize.Y
                        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeightCanvas)
                        scrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, totalHeightCanvas - scrollingFrame.AbsoluteSize.Y))

                        typewrite(messageLabel, final_message)
                        if formatted_message then
                            messageLabel.Text = formatted_message
                        end

                        resetFadeTimer()
                    end)

                    if not suc then
                        warn("Error adding message: " .. res)
                        local errorMessage = "Error displaying message. Check console for details."
                        local errorFrame = Instance.new("Frame")
                        errorFrame.Size = UDim2.new(1, -10, 0, 20)
                        errorFrame.BackgroundTransparency = 1
                        errorFrame.Parent = scrollingFrame

                        local errorSeparator = Instance.new("TextLabel")
                        errorSeparator.Size = UDim2.new(0, 20, 0, 20)
                        errorSeparator.Position = UDim2.new(0, 0, 0, 0)
                        errorSeparator.BackgroundTransparency = 1
                        errorSeparator.TextColor3 = Color3.fromRGB(255, 255, 255)
                        errorSeparator.TextSize = 10
                        errorSeparator.Font = Enum.Font.SourceSans
                        errorSeparator.TextXAlignment = Enum.TextXAlignment.Left
                        errorSeparator.RichText = true
                        errorSeparator.Text = "»"
                        errorSeparator.Parent = errorFrame

                        local errorLabel = Instance.new("TextLabel")
                        errorLabel.Size = UDim2.new(1, -20, 1, 0)
                        errorLabel.Position = UDim2.new(0, 20, 0, 0)
                        errorLabel.BackgroundTransparency = 1
                        errorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        errorLabel.TextSize = 16
                        errorLabel.Font = Enum.Font.SourceSans
                        errorLabel.TextXAlignment = Enum.TextXAlignment.Left
                        errorLabel.RichText = true
                        errorLabel.Text = errorMessage
                        errorLabel.TextWrapped = true
                        errorLabel.Parent = errorFrame

                        local errorBounds = errorLabel.TextBounds
                        errorFrame.Size = UDim2.new(1, -10, 0, math.max(20, errorBounds.Y))
                        errorSeparator.Position = UDim2.new(0, 0, 0, (errorBounds.Y - errorSeparator.TextSize) / 2)

                        local totalHeight = uiListLayout.AbsoluteContentSize.Y
                        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                        scrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, totalHeight - scrollingFrame.AbsoluteSize.Y))
                    end
                end
                shared.addMessage = addMessage

                maid:Add(function()
                    addMessage = nil
                    shared.addMessage = nil
                end)

                local function focused()
                    resetFadeTimer()
                end

                local function focusLost() end

                maid:Add(chatFrame.MouseEnter:Connect(focused))
                maid:Add(chatFrame.MouseLeave:Connect(focusLost))

                maid:Add(inputBox.Focused:Connect(focused))
                maid:Add(inputBox.FocusLost:Connect(focusLost))

                maid:Add(function()
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
                end)

                local textChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

                maid:Add(inputBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and inputBox.Text ~= "" then
                        local suc, res = pcall(function()
                            local message = inputBox.Text
                            if (message:split(""))[1] == "/" then
                                task.spawn(function() textChannel:SendAsync(message) end)
                            else
                                textChannel:SendAsync(message)
                            end
                            inputBox.Text = ""
                        end)

                        if not suc then
                            warn("Error sending message: " .. res)
                            addMessage("Error sending message. Check console.", nil, true)
                        end
                    end
                end))

                maid:Add(TextChatService.MessageReceived:Connect(function(textChatMessage)
                    local suc, res = pcall(function()
                        local sender = textChatMessage.TextSource and Players:GetPlayerByUserId(textChatMessage.TextSource.UserId)
                        local senderName = sender and sender.Name or "System"
                        local teamColor = sender and sender.TeamColor or nil
                        local message = textChatMessage.Text
                        local isSystem = not textChatMessage.TextSource
                        addMessage(message, senderName, isSystem, teamColor)
                    end)

                    if not suc then
                        warn("Error handling received message: " .. res)
                        addMessage("Error receiving message. Check console.", nil, true)
                    end
                end))

                maid:Add(UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.KeyCode == Enum.KeyCode.Slash then
                        local suc, res = pcall(function()
                            inputBox:CaptureFocus()
                            inputBox.Text = ""
                        end)

                        if not suc then
                            warn("Error focusing input box: " .. res)
                            addMessage("Error focusing chat input. Check console.", nil, true)
                        end
                    end
                end))

				maid:Add(Players.PlayerAdded:Connect(function(player)
                    if Config.Joins and addMessage then
                        local playerName = player.DisplayName or player.Name
                        local message = string.format('<font color="rgb(85, 255, 85)">%s has joined the game.</font>', playerName)
                        addMessage(message, nil, true)
                    end
                end))

                maid:Add(Players.PlayerRemoving:Connect(function(player)
                    if Config.Leaves and addMessage then
                        local playerName = player.DisplayName or player.Name
                        local message = string.format('<font color="rgb(255, 255, 85)">%s has left the game.</font>', playerName)
                        addMessage(message, nil, true)
                    end
                end))

                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

                addMessage("Custom chat enabled successfully!", "System", true, Color3.fromRGB(255, 255, 255))
            else
                maid:Clean()
            end
        end
    })

    CustomChat:CreateToggle({
        Name = "Typewrite",
        Function = function(call) Config.TypeWrite = call end,
        Default = true
    })
	if shared.VoidDev then
		CustomChat:CreateToggle({
			Name = "Draggable",
			Function = function(call) Config.DragEnabled = call end
		})
	end
    CustomChat:CreateToggle({
        Name = "Clean Old Messages",
        Function = function(call) Config.CleanOld = call end
    })
    CustomChat:CreateSlider({
        Name = "Background Transparency",
        Min = 0,
        Max = 10,
        Default = 1,
        Function = function(val)
            Config.Transparency = val
            if CustomChat.Enabled then
                updateChatVisibility()
            end
        end
    })
    CustomChat:CreateSlider({
        Name = "Max Displayed Messages",
        Min = 10,
        Max = 100,
        Round = 0,
        Default = 50,
        Function = function(val)
            Config.MaxMessages = val
        end
    })
    for i, v in pairs(Config) do
        if i == "TypeWrite" or i == "DragEnabled" or i == "CleanOld" or i == "Transparency" or i == "MaxMessages" or i == "Enabled" then continue end
        CustomChat:CreateToggle({
            Name = "Display "..tostring(i),
            Function = function(call) 
				Config[i] = call; 
			end,
            Default = true
        })
    end

	CustomChat:CreateToggle({
		Name = "Gradient",
		Function = function(call)
			GradientEnabled = call
		end,
		Default = false
	})

    chatColor1 = CustomChat:CreateColorSlider({
        Name = 'Chat Color 1',
        DefaultValue = 0,
        DefaultOpacity = 1,
        Function = function(h, s, v, o)
            if chatGradient then updateChatGradient() end
        end
    })
    chatColor2 = CustomChat:CreateColorSlider({
        Name = 'Chat Color 2',
        DefaultValue = 0.5,
        DefaultOpacity = 1,
        Function = function(h, s, v, o)
            if chatGradient then updateChatGradient() end
        end
    })
    chatColor3 = CustomChat:CreateColorSlider({
        Name = 'Chat Color 3',
        DefaultValue = 0.75,
        DefaultOpacity = 1,
        Function = function(h, s, v, o)
            if chatGradient then updateChatGradient() end
        end
    })
    chatColor3.Object.Visible = false
    chatThirdColorToggle = CustomChat:CreateToggle({
        Name = 'Third Chat Color',
        Default = false,
        Function = function(val)
            chatColor3.Object.Visible = val
            if chatGradient then updateChatGradient() end
        end
    })
end)

run(function()
	local maid = Maid.new()
	local StreamerMode = {Enabled = false}
	local Config = {
		Name = "chasemaser",
		DisplayName = "chase",
		UserId = "22808138"
	}
	local Players
	local RunService
	StreamerMode = vape.Categories.World:CreateModule({
		Name = "StreamerMode",
		Function = function(call)
			if call then
				Players = Players or Services.Players
				RunService = RunService or Services.RunService
				local function plrthing(obj, property)
					for i,v in pairs(Players:GetChildren()) do
						if v == lplr then
							obj[property] = obj[property]:gsub(v.Name, Config["Name"])
							obj[property] = obj[property]:gsub(v.DisplayName, Config["DisplayName"])
							obj[property] = obj[property]:gsub(v.UserId, Config["UserId"])
							pcall(function()
								obj.RichText = true
							end)
						else continue end
					end
				end
				
				local function newobj(v)
					if v:IsA("TextLabel") or v:IsA("TextButton") then
						plrthing(v, "Text")
						maid:Add(v:GetPropertyChangedSignal("Text"):connect(function()
							plrthing(v, "Text")
						end))
					end
					if v:IsA("ImageLabel") then
						plrthing(v, "Image")
						maid:Add(v:GetPropertyChangedSignal("Image"):connect(function()
							plrthing(v, "Image")
						end))
					end
				end

				--[[local index, total = game:GetDescendants()
				local con
				con = RunService.RenderStepped:Connect(function()
					local suc, err = pcall(function()
						if index <= #total then
							newobj(total[index])
							index = index + 1
						else
							pcall(function()
								con:Disconnect()
							end)
						end
					end)
					if not suc then
						pcall(function()
							con:Disconnect()
						end)
					end
				end)
				maid:Add(con)--]]
				for i,v in pairs(game:GetDescendants()) do
					newobj(v)
				end
				maid:Add(game.DescendantAdded:connect(newobj))
			else
				maid:Clean()
			end
		end
	})
	for i,v in pairs(Config) do
		StreamerMode:CreateTextBox({
			Name = tostring(i),
			Default = v,
			Function = function(val)
				Config[i] = tostring(val)
			end
		})
	end
end)