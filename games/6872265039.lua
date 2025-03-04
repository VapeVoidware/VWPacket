repeat task.wait() until shared.vape
shared.vape = vape
local lplr = vape.Services.Players.LocalPlayer
local function run(func) func() end
run(function()
	local QueueCardMods = {}
	local QueueCardGradientToggle = {Enabled = true}
	local QueueCardGradient = {Hue = 0, Sat = 0, Value = 0}
	local QueueCardGradient2 = {Hue = 0, Sat = 0, Value = 0}
	local function patchQueueCard()
		if lplr.PlayerGui:FindFirstChild('QueueApp') then 
            for i = 1, 3 do
                if QueueCardGradientToggle.Enabled then 
                    lplr.PlayerGui.QueueApp['1'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    local gradient = (lplr.PlayerGui.QueueApp['1']:FindFirstChildWhichIsA('UIGradient') or Instance.new('UIGradient', lplr.PlayerGui.QueueApp['1']))
                    local tbl = {
						module = vape.watermark,
						gradient = gradient
					}
					function tbl:GetEnabled()
						return QueueCardMods.Enabled
					end
					vape.whitelistedlines["queuecardmods"] = tbl
                end
                task.wait()
            end
		end
	end
	QueueCardMods = vape.Categories.World:CreateModule({
		Name = 'QueueCardMods',
		Tooltip = 'Mods the QueueApp at the end of the game.',
		Function = function(calling) 
			if calling then 
				patchQueueCard()
				QueueCardMods:Clean(lplr.PlayerGui.ChildAdded:Connect(patchQueueCard))
			end
		end
	})
end)