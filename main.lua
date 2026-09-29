local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Clicker Simulator",
    Icon = "sword",
    Theme = "Dark",
    Folder = "ClickerFarm",
    Collapsed = false,
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
    Desc = "Portal + Free Portal",
    Callback = function()
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera

        local function getHrp()
            local char = player.Character
            if not char then return nil end
            return char:FindFirstChild("HumanoidRootPart")
        end

        local function findPrompt(obj)
            if not obj then return nil end
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("ProximityPrompt") then
                    return child
                end
                local found = findPrompt(child)
                if found then return found end
            end
            return nil
        end

        local function findText(obj)
            if not obj then return nil end
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("TextLabel") then
                    return child.Text
                end
                local found = findText(child)
                if found then return found end
            end
            return nil
        end

        while not getHrp() do wait(0.5) end

        -- 1. ТП к RaidPortal + нажать E
        local hrp = getHrp()
        local portal = workspace._MAP.Interact.RaidPortal.Portal
        if portal then
            hrp.CFrame = portal.CFrame + Vector3.new(-5, 3, -5)
            camera.CFrame = CFrame.lookAt(
                hrp.Position + Vector3.new(-55, 3, -33),
                portal.Position
            )
            wait(0.1)

            local prompt = findPrompt(workspace._MAP.Interact.RaidPortal)
            if prompt then
                prompt:InputHoldBegin()
                wait(1)
                prompt:InputHoldEnd()
            end
            wait(2)
        end

        -- 2. ТП к свободному порталу
        local raids = workspace._THINGS.Minigames.RaidEvent.Portals.Raids
        if not raids then return end

        local freeNum = nil
        for i = 1, 10 do
            local raid = raids:FindFirstChild(tostring(i))
            if raid then
                local bb = raid:FindFirstChild("Billboard")
                if bb then
                    local text = findText(bb)
                    if text and text:find("Unclaimed") then
                        freeNum = i
                        break
                    end
                end
            end
        end

        if freeNum then
            local pad = raids[tostring(freeNum)].Pad.Part
            hrp = getHrp()
            if hrp and pad then
                hrp.CFrame = pad.CFrame + Vector3.new(0, 5, 0)
                camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(0,3,0), pad.Position)
                wait(10)
            end
        end
    end
})   

local respawnWait = 0.1

local gateWait = 1.2

RaidSec:Toggle({
    Title = "Auto Farm Loop",
    Desc = "Clicks + Gates + Shadow (loop)",
    Value = false,
    Callback = function(v)
        farmRunning = v
        if v then
            task.spawn(function()
                while farmRunning do
                    local ok, err = pcall(function()
                        local VIM = game:GetService("VirtualInputManager")
                        VIM:SendMouseButtonEvent(950, 667, 0, true, game, 0)
                        wait(0.3)
                        VIM:SendMouseButtonEvent(950, 667, 0, false, game, 0)
                        wait(0.4)
                        VIM:SendMouseButtonEvent(639, 679, 0, true, game, 0)
                        wait(0.3)
                        VIM:SendMouseButtonEvent(639, 679, 0, false, game, 0)
                        wait(3)

                        local player = game.Players.LocalPlayer
                        local camera = workspace.CurrentCamera

                        local function getHrp()
                            local char = player.Character
                            if not char then return nil end
                            return char:FindFirstChild("HumanoidRootPart")
                        end

                        while not getHrp() and farmRunning do wait(0.5) end
                        if not farmRunning then return end

                        local rooms = workspace._THINGS.Minigames.RaidLobby.Rooms
                        if not rooms then
                            wait(5)
                            return
                        end

                        for i = 1, 6 do
                            if not farmRunning then return end
                            local room = rooms[tostring(i)]
                            if room then
                                local gate = room.Gate[tostring(1)]
                                if gate then
                                    local hrp = getHrp()
                                    if hrp then
                                        hrp.CFrame = gate.CFrame + Vector3.new(0, 3, 0)
                                        camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(0, 3, 0), gate.Position)
                                    end
                                end
                            end
                            wait(gateWait)
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
                                        camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(0, 3, 0), shadow.Position)
                                    end
                                end
                            end
                        end
                    end)

                    if not ok then
                        wait(5)
                    end
                    wait(3)
                end
            end)
        end
    end
})

RaidSec:Input({
    Title = "Gate Wait",
    Desc = "Delay between gates (sec)",
    Value = "1.2",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            gateWait = num
        end
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
