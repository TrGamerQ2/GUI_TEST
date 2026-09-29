local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Clicker Simulator",
    Icon = "sword",
    Theme = "Dark",
    Folder = "ClickerFarm",
})

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

local function applyStat(prop, value)
    pcall(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum[prop] = value
    end)
end

-- ============ RAID ============
local RaidTab = Window:Tab({ Title = "Raid", Icon = "swords" })
local RaidSec = RaidTab:Section({ Title = "Auto Raid" })

RaidSec:Button({
    Title = "TP to Free Portal",
    Desc = "Teleport to unclaimed portal",
    Callback = function()
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
    end
})

RaidSec:Button({
    Title = "Max + Start Raid",
    Desc = "Max difficulty + Start",
    Callback = function()
        local gui = player.PlayerGui:FindFirstChild("RaidCreate")
        if not gui or not gui.Enabled then return end
        local right = gui.Frame.Container.Right
        local start = gui.Frame.Container.Start
        for i = 1, 10 do
            if not start.Active then break end
            right:Activate()
            wait(0.3)
        end
        if start.Active then start:Activate() end
    end
})

RaidSec:Button({
    Title = "Gates 1-6 + Shadow",
    Desc = "TP through all gates",
    Callback = function()
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
    end
})

RaidSec:Button({
    Title = "Clicks",
    Desc = "Auto click (950,667) + (639,679)",
    Callback = function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(950, 667, 0, true, game, 0)
        wait(0.3)
        VIM:SendMouseButtonEvent(950, 667, 0, false, game, 0)
        wait(0.4)
        VIM:SendMouseButtonEvent(639, 679, 0, true, game, 0)
        wait(0.3)
        VIM:SendMouseButtonEvent(639, 679, 0, false, game, 0)
    end
})

-- ============ ME (Input'ы) ============
local MeTab = Window:Tab({ Title = "Me", Icon = "user" })
local MeSec = MeTab:Section({ Title = "Stats" })

MeSec:Input({
    Title = "WalkSpeed",
    Desc = "Default: 16",
    Value = "16",
    Callback = function(v)
        applyStat("WalkSpeed", tonumber(v) or 16)
    end
})

MeSec:Input({
    Title = "JumpPower",
    Desc = "Default: 50",
    Value = "50",
    Callback = function(v)
        applyStat("JumpPower", tonumber(v) or 50)
    end
})

MeSec:Input({
    Title = "JumpHeight",
    Desc = "Default: 7",
    Value = "7",
    Callback = function(v)
        applyStat("JumpHeight", tonumber(v) or 7)
    end
})

MeSec:Input({
    Title = "SwimSpeed",
    Desc = "Default: 14",
    Value = "14",
    Callback = function(v)
        applyStat("SwimSpeed", tonumber(v) or 14)
    end
})

MeSec:Button({
    Title = "Reset All",
    Desc = "Reset to default",
    Callback = function()
        applyStat("WalkSpeed", 16)
        applyStat("JumpPower", 50)
        applyStat("JumpHeight", 7)
        applyStat("SwimSpeed", 14)
    end
})

-- ============ CLICKER ============
local ClickerTab = Window:Tab({ Title = "Clicker", Icon = "mouse" })
local ClickerSec = ClickerTab:Section({ Title = "Auto Click" })
ClickerSec:Button({
    Title = "Auto Click",
    Desc = "Click at (895, 640)",
    Callback = function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(895, 640, 0, true, game, 0)
        wait(0.1)
        VIM:SendMouseButtonEvent(895, 640, 0, false, game, 0)
    end
})

-- ============ TELEPORT ============
local TPTab = Window:Tab({ Title = "Teleport", Icon = "map" })
local TPSection = TPTab:Section({ Title = "Teleport" })
TPSection:Button({
    Title = "TP Spawn",
    Desc = "Teleport to spawn",
    Callback = function()
        local hrp = getHrp()
        if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
    end
})

-- ============ ESP ============
local ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" })
local ESPSection = ESPTab:Section({ Title = "ESP" })
ESPSection:Toggle({
    Title = "Enable ESP",
    Desc = "See through walls",
    Value = false,
    Callback = function(v)
        print("ESP: " .. tostring(v))
    end
})

-- ============ SETTINGS ============
local SetTab = Window:Tab({ Title = "Settings", Icon = "settings" })
local SetSection = SetTab:Section({ Title = "Settings" })
SetSection:Button({
    Title = "Reset All",
    Desc = "Reset all settings",
    Callback = function()
        print("Reset")
    end
})   
