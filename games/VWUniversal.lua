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
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/VWUpdateLog.lua", true))()
            shared.UpdateLogBypass = nil
        end
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
    local lightingService = vape.Services.Lighting
    local LightingTheme = {Enabled = false}
    local LightingThemeType = {Value = "LunarNight"}
    local TintToggle = {Enabled = false}
    local TintColor = {Hue = 0, Sat = 0, Value = 1}
    local CustomTimeToggle = {Enabled = false}
    local TimeOfDaySlider = {Value = 12}
    local themesky
    local themeobjects = {}
    local oldthemesettings = {
        Ambient = lightingService.Ambient,
        FogEnd = lightingService.FogEnd,
        FogStart = lightingService.FogStart,
        OutdoorAmbient = lightingService.OutdoorAmbient,
        ClockTime = lightingService.ClockTime
    }

    local function dumptable(tab, tabtype, sortfunction)
        local data = {}
        for i, v in pairs(tab) do
            local entry = tabtype and tabtype == 1 and i or v
            table.insert(data, entry)
        end
        if sortfunction and type(sortfunction) == "function" then
            table.sort(data, sortfunction)
        end
        return data
    end

    local themetable = {
        Purple = function()
            return {
                Sky = {
                    SkyboxBk = "rbxassetid://8539982183",
                    SkyboxDn = "rbxassetid://8539981943",
                    SkyboxFt = "rbxassetid://8539981721",
                    SkyboxLf = "rbxassetid://8539981424",
                    SkyboxRt = "rbxassetid://8539980766",
                    SkyboxUp = "rbxassetid://8539981085",
                    MoonAngularSize = 0,
                    SunAngularSize = 0,
                    StarCount = 3000
                },
                Lighting = {
                    Ambient = Color3.fromRGB(170, 0, 255)
                },
                Effects = {}
            }
        end,
        Galaxy = function()
            return {
                Sky = {
                    SkyboxBk = "rbxassetid://159454299",
                    SkyboxDn = "rbxassetid://159454296",
                    SkyboxFt = "rbxassetid://159454293",
                    SkyboxLf = "rbxassetid://159454293",
                    SkyboxRt = "rbxassetid://159454293",
                    SkyboxUp = "rbxassetid://159454288",
                    SunAngularSize = 0
                },
                Lighting = {
                    FogEnd = 200,
                    FogStart = 0,
                    OutdoorAmbient = Color3.fromRGB(172, 18, 255)
                },
                Effects = {}
            }
        end,
        BetterNight = function()
            return {
                Sky = {
                    SkyboxBk = "rbxassetid://155629671",
                    SkyboxDn = "rbxassetid://12064152",
                    SkyboxFt = "rbxassetid://155629677",
                    SkyboxLf = "rbxassetid://155629662",
                    SkyboxRt = "rbxassetid://155629666",
                    SkyboxUp = "rbxassetid://155629686",
                    SunAngularSize = 0
                },
                Lighting = {
                    FogColor = Color3.fromRGB(0, 20, 64)
                },
                Effects = {}
            }
        end,
        BetterNight3 = function()
            return {
                Sky = {
                    MoonTextureId = "rbxassetid://1075087760",
                    SkyboxBk = "rbxassetid://2670643994",
                    SkyboxDn = "rbxassetid://2670643365",
                    SkyboxFt = "rbxassetid://2670643214",
                    SkyboxLf = "rbxassetid://2670643070",
                    SkyboxRt = "rbxassetid://2670644173",
                    SkyboxUp = "rbxassetid://2670644331",
                    MoonAngularSize = 1.5,
                    StarCount = 500
                },
                Lighting = {},
                Effects = {
                    ColorCorrection = {
                        Enabled = true,
                        TintColor = Color3.fromRGB(189, 179, 178)
                    },
                    BlurEffect = {
                        Enabled = true,
                        Size = 9
                    },
                    BloomEffect = {
                        Enabled = true,
                        Intensity = 100,
                        Size = 56,
                        Threshold = 5
                    }
                }
            }
        end,
        Sunset = function()
            return {
                Sky = {
                    SkyboxBk = "rbxassetid://271042516",
                    SkyboxDn = "rbxassetid://271077243",
                    SkyboxFt = "rbxassetid://271042556",
                    SkyboxLf = "rbxassetid://271042310",
                    SkyboxRt = "rbxassetid://271042467",
                    SkyboxUp = "rbxassetid://271077958",
                    SunAngularSize = 10,
                    MoonAngularSize = 0
                },
                Lighting = {
                    Ambient = Color3.fromRGB(255, 140, 0),
                    OutdoorAmbient = Color3.fromRGB(255, 165, 0),
                    ClockTime = 18 -- 6 PM
                },
                Effects = {}
            }
        end,
        Ocean = function()
            return {
                Sky = {
                    SkyboxBk = "rbxassetid://591058823",
                    SkyboxDn = "rbxassetid://591059876",
                    SkyboxFt = "rbxassetid://591058104",
                    SkyboxLf = "rbxassetid://591057861",
                    SkyboxRt = "rbxassetid://591057625",
                    SkyboxUp = "rbxassetid://591059642",
                    SunAngularSize = 15,
                    MoonAngularSize = 0
                },
                Lighting = {
                    Ambient = Color3.fromRGB(0, 191, 255),
                    OutdoorAmbient = Color3.fromRGB(135, 206, 235)
                },
                Effects = {}
            }
        end,
        SpaceStation = function()
            return {
                Sky = {
                    SkyboxBk = "rbxassetid://166509999",
                    SkyboxDn = "rbxassetid://166510057",
                    SkyboxFt = "rbxassetid://166510116",
                    SkyboxLf = "rbxassetid://166510092",
                    SkyboxRt = "rbxassetid://166510131",
                    SkyboxUp = "rbxassetid://166510114",
                    MoonAngularSize = 0,
                    SunAngularSize = 0,
                    StarCount = 5000
                },
                Lighting = {
                    Ambient = Color3.fromRGB(50, 50, 50),
                    OutdoorAmbient = Color3.fromRGB(100, 100, 150)
                },
                Effects = {}
            }
        end,
        LunarNight = function()
            return {
                Sky = {
                    SkyboxBk = "rbxassetid://187713366",
                    SkyboxDn = "rbxassetid://187712428",
                    SkyboxFt = "rbxassetid://187712836",
                    SkyboxLf = "rbxassetid://187713755",
                    SkyboxRt = "rbxassetid://187714525",
                    SkyboxUp = "rbxassetid://187712111",
                    SunAngularSize = 0,
                    StarCount = 0
                },
                Lighting = {
                    ClockTime = 0 -- Midnight
                },
                Effects = {}
            }
        end
    }

    LightingTheme = vape.Categories.World:CreateModule({
        Name = "LightingTheme",
        Tooltip = "Add a whole new look to your game.",
        ExtraText = function() return LightingThemeType.Value end,
        Function = function(callback)
            if callback then
                local themeSettings = themetable[LightingThemeType.Value]()
                if themeSettings then
                    if not themesky then
                        themesky = Instance.new("Sky")
                        themesky.Parent = lightingService
                    end
                    for prop, value in pairs(themeSettings.Sky) do
                        themesky[prop] = value
                    end
                    for prop, value in pairs(themeSettings.Lighting) do
                        lightingService[prop] = value
                    end
                    for effectType, effectProps in pairs(themeSettings.Effects) do
                        local effect = Instance.new(effectType)
                        for prop, value in pairs(effectProps) do
                            effect[prop] = value
                        end
                        effect.Parent = game.Workspace
                        table.insert(themeobjects, effect)
                    end
                    if TintToggle.Enabled then
                        local colorCorrection = Instance.new("ColorCorrectionEffect")
                        colorCorrection.TintColor = Color3.fromHSV(TintColor.Hue, TintColor.Sat, TintColor.Value)
                        colorCorrection.Enabled = true
                        colorCorrection.Parent = game.Workspace
                        table.insert(themeobjects, colorCorrection)
                    end
                    if CustomTimeToggle.Enabled then
                        lightingService.ClockTime = TimeOfDaySlider.Value
                    end
                    LightingTheme:Clean(lightingService.ChildAdded:Connect(function(v)
                        if v:IsA("Sky") and v ~= themesky then
                            v.Parent = nil
                        end
                    end))
                end
            else
                if themesky then
                    themesky:Destroy()
                    themesky = nil
                end
                for _, obj in pairs(themeobjects) do
                    obj:Destroy()
                end
                table.clear(themeobjects)
                for prop, value in pairs(oldthemesettings) do
                    lightingService[prop] = value
                end
            end
        end
    })

    LightingThemeType = LightingTheme:CreateDropdown({
        Name = "Theme",
        List = dumptable(themetable, 1),
        Function = function()
            if LightingTheme.Enabled then
                LightingTheme:Toggle()
                LightingTheme:Toggle()
            end
        end
    })

    TintToggle = LightingTheme:CreateToggle({
        Name = "Enable Tint",
        Function = function(call)
            if LightingTheme.Enabled then
                LightingTheme:Toggle()
                LightingTheme:Toggle()
            end
        end
    })

    TintColor = LightingTheme:CreateColorSlider({
        Name = "Tint Color",
        Function = function(h, s, v)
            if TintToggle.Enabled and LightingTheme.Enabled then
                for _, obj in pairs(themeobjects) do
                    if obj:IsA("ColorCorrectionEffect") then
                        obj.TintColor = Color3.fromHSV(h, s, v)
                        break
                    end
                end
            end
        end
    })

    CustomTimeToggle = LightingTheme:CreateToggle({
        Name = "Custom Time",
        Function = function(call)
            if LightingTheme.Enabled then
                if call then
                    lightingService.ClockTime = TimeOfDaySlider.Value
                else
                    local themeSettings = themetable[LightingThemeType.Value]()
                    if themeSettings.Lighting.ClockTime then
                        lightingService.ClockTime = themeSettings.Lighting.ClockTime
                    end
                end
            end
        end
    })

    TimeOfDaySlider = LightingTheme:CreateSlider({
        Name = "Time of Day",
        Min = 0,
        Max = 24,
        Default = 12,
        Function = function(val)
            TimeOfDaySlider.Value = val
            if CustomTimeToggle.Enabled and LightingTheme.Enabled then
                lightingService.ClockTime = val
            end
        end,
        Suffix = function(val) return string.format("%.1f hr", val) end
    })
end)