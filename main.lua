local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Raid Farm", "DarkTheme")

local Tab = Window:NewTab("Raid")
local Section = Tab:NewSection("Фарм", "Raid Farm")

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
