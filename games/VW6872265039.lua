task.spawn(function()
    pcall(function()
        repeat task.wait() until shared.vapewhitelist
        local lplr = game:GetService("Players").LocalPlayer
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