local player = game:GetService("Players").LocalPlayer
local sg = Instance.new("ScreenGui")
sg.Name = "MyGUI"
sg.ResetOnSpawn = false
sg.DisplayOrder = 9999
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(300, 200)
frame.Position = UDim2.fromOffset(50, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.ZIndex = 1
frame.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "My Cheat"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.ZIndex = 2
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Name = "TP"
btn.Size = UDim2.new(1, -20, 0, 35)
btn.Position = UDim2.new(0, 10, 0, 40)
btn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
btn.Text = "TP"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true
btn.Font = Enum.Font.Gotham
btn.ZIndex = 2
btn.BorderSizePixel = 0
btn.Parent = frame

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

btn.MouseButton1Click:Connect(function()
    print("Нажали TP!")
end)

print("GUI создан")   
