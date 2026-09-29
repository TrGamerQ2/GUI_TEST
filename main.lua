local player = game.Players.LocalPlayer

-- Главное окно
local sg = Instance.new("ScreenGui")
sg.Name = "CheatGUI"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999
sg.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 200)
frame.Position = UDim2.fromOffset(50, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "My Cheat"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Вкладки (кнопки)
local tabs = {"Main", "Raid", "Settings"}
local tabFrames = {}
local tabContent = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 25)
    btn.Position = UDim2.new(0, 5 + (i-1)*92, 0, 32)
    btn.Text = tabName
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    -- Контент вкладки
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -70)
    content.Position = UDim2.new(0, 5, 0, 62)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = frame

    tabFrames[i] = btn
    tabContent[i] = content

    btn.MouseButton1Click:Connect(function()
        for j = 1, #tabs do
            tabContent[j].Visible = (j == i)
            tabFrames[j].BackgroundColor3 = (j == i) and Color3.fromRGB(50, 100, 200) or Color3.fromRGB(50, 50, 50)
        end
    end)
end

-- Активная вкладка (первая)
tabFrames[1].BackgroundColor3 = Color3.fromRGB(50, 100, 200)

-- Пример кнопки во вкладке "Raid"
local raidBtn = Instance.new("TextButton")
raidBtn.Size = UDim2.new(1, -20, 0, 35)
raidBtn.Position = UDim2.new(0, 10, 0, 5)
raidBtn.Text = "TP to Free Portal"
raidBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
raidBtn.TextColor3 = Color3.new(1, 1, 1)
raidBtn.TextScaled = true
raidBtn.Font = Enum.Font.Gotham
raidBtn.Parent = tabContent[2]
Instance.new("UICorner", raidBtn).CornerRadius = UDim.new(0, 4)

raidBtn.MouseButton1Click:Connect(function()
    print("TP!")
    -- твой код
end)

print("GUI готов")   
