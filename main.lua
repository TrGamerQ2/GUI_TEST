local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Clicker Simulator", "DarkTheme")

local Tab = Window:NewTab("Raid")
local Section = Tab:NewSection("Farm", "Auto Raid")

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local function getHrp()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function findText(o)
    if not o then return nil end
    for _, c in pairs(o:GetChildren()) do
        if c:IsA("TextLabel") then return c.Text end
        local f = findText(c)
        if f then return f end
    end
    return nil
end

Section:NewButton("TP to Free Portal", "Teleport to unclaimed portal", function()
    local raids = workspace._THINGS.Minigames.RaidEvent.Portals.Raids
    if not raids then return end
    local freeNum = nil
    for i = 1, 10 do
        local raid = raids:FindFirstChild(tostring(i))
        if raid then
            local bb = raid:FindFirstChild("Billboard")
            if bb and findText(bb) and findText(bb):find("Unclaimed") then
                freeNum = i
                break
            end
        end
    end
    if freeNum then
        local pad = raids[tostring(freeNum)].Pad.Part
        local hrp = getHrp()
        if hrp and pad then
            hrp.CFrame = pad.CFrame
            camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(0,3,0), pad.Position)
        end
    end
end)

Section:NewButton("Max + Start Raid", "Max difficulty + Start", function()
    local gui = player.PlayerGui:FindFirstChild("RaidCreate")
    if not gui or not gui.Enabled then return end
    local right = gui.Frame.Container.Right
    local start = gui.Frame.Container.Start
    for i = 1, 10 do
        if not start.Active then break end
        right:Activate()
        wait(0.3)
    end
    if start.Active then
        start:Activate()
    end
end)

Section:NewButton("Gates 1-6 + Shadow", "TP through all gates", function()
    local rooms = workspace._THINGS.Minigames.RaidLobby.Rooms
    if not rooms then return end
    for i = 1, 6 do
        local room = rooms[tostring(i)]
        if room then
            local gate = room.Gate[tostring(1)]
            if gate then
                local hrp = getHrp()
                if hrp then
                    hrp.CFrame = gate.CFrame + Vector3.new(0, 3, 0)
                    camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(0,3,0), gate.Position)
                end
            end
        end
        wait(1.2)
    end
    local interact = workspace._THINGS.Minigames.RaidLobby.Interact
    if interact then
        local door = interact:GetChildren()[4]
        if door then
            local shadow = door:FindFirstChild("Shadow")
            if shadow then
                local hrp = getHrp()
                if hrp then
                    hrp.CFrame = shadow.CFrame
                    camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(0,3,0), shadow.Position)
                end
            end
        end
    end
end)

Section:NewButton("Clicks", "Auto click (950,667) + (639,679)", function()
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendMouseButtonEvent(950, 667, 0, true, game, 0)
    wait(0.3)
    VIM:SendMouseButtonEvent(950, 667, 0, false, game, 0)
    wait(0.4)
    VIM:SendMouseButtonEvent(639, 679, 0, true, game, 0)
    wait(0.3)
    VIM:SendMouseButtonEvent(639, 679, 0, false, game, 0)
end)

-- ============ ДОПОЛНИТЕЛЬНЫЕ ВКЛАДКИ ============

local Tab2 = Window:NewTab("Clicker")
local Sec2 = Tab2:NewSection("Auto Click", "Clicker Simulator")
Sec2:NewButton("Auto Click", "Click at (895, 640)", function()
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendMouseButtonEvent(895, 640, 0, true, game, 0)
    wait(0.1)
    VIM:SendMouseButtonEvent(895, 640, 0, false, game, 0)
end)

local Tab3 = Window:NewTab("Pets")
local Sec3 = Tab3:NewSection("Pets", "Pet Management")
Sec3:NewButton("Equip Best", "Equip best pet", function()
    print("Equip Best")
end)

local Tab4 = Window:NewTab("Upgrades")
local Sec4 = Tab4:NewSection("Upgrades", "Buy Upgrades")
Sec4:NewButton("Buy All", "Buy all available upgrades", function()
    print("Buy All")
end)

local Tab5 = Window:NewTab("Rebirth")
local Sec5 = Tab5:NewSection("Rebirth", "Rebirth System")
Sec5:NewButton("Auto Rebirth", "Rebirth when possible", function()
    print("Auto Rebirth")
end)

local Tab6 = Window:NewTab("Teleport")
local Sec6 = Tab6:NewSection("Teleport", "Quick TP")
Sec6:NewButton("TP Spawn", "Teleport to spawn", function()
    local hrp = getHrp()
    if hrp then
        hrp.CFrame = CFrame.new(0, 50, 0)
    end
end)

local Tab7 = Window:NewTab("Me")
local Sec7 = Tab7:NewSection("Stats", "Character Stats (0-200)")

Sec7:NewSlider("WalkSpeed", "WalkSpeed", 0, 200, 16, function(v)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)

Sec7:NewSlider("JumpPower", "JumpPower", 0, 200, 50, function(v)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = v end
    end
end)

Sec7:NewSlider("JumpHeight", "JumpHeight", 0, 200, 7, function(v)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpHeight = v end
    end
end)

Sec7:NewSlider("SwimSpeed", "SwimSpeed", 0, 200, 14, function(v)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.SwimSpeed = v end
    end
end)

Sec7:NewSlider("WalkAnimScale", "Walk Animation Scale", 0, 200, 1, function(v)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkAnimationScale = v end
    end
end)

Sec7:NewSlider("RunAnimScale", "Run Animation Scale", 0, 200, 1, function(v)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.RunAnimationScale = v end
    end
end)

Sec7:NewButton("Reset All", "Reset all to default", function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.JumpHeight = 7
            hum.SwimSpeed = 14
            hum.WalkAnimationScale = 1
            hum.RunAnimationScale = 1
        end
    end
end)      

local Tab8 = Window:NewTab("ESP")
local Sec8 = Tab8:NewSection("ESP", "See through walls")
Sec8:NewButton("Toggle ESP", "Enable/disable ESP", function()
    print("ESP toggled")
end)

local Tab9 = Window:NewTab("Settings")
local Sec9 = Tab9:NewSection("Settings", "Script Config")
Sec9:NewButton("Reset All", "Reset all settings", function()
    print("Reset")
end)   
