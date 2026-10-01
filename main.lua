local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ============ KEY SYSTEM ============
local VALID_KEYS = { "BRUNO", "VICTOR", "SIMEX" }

local function isValidKey(key)
    for _, k in ipairs(VALID_KEYS) do
        if key:upper() == k:upper() then return true end
    end
    return false
end

local Window = WindUI:CreateWindow({
    Title = "VERIFICATION",
    Icon = "star",
    Theme = "Dark",
})

local unlocked = false
local createMainUI

local autoRaid = false
local myPortal = nil
local inWorld2 = false
local gateWait = 1.2
local firstClaim = true

local KeyTab = Window:Tab({ Title = "KEY", Icon = "key" })

KeyTab:Input({
    Title = "Введите ключ",
    Placeholder = "XXXX-XXXX",
    Callback = function(value)
        if isValidKey(value) then
            WindUI:Notify({ Title = "Успех", Content = "Доступ открыт!", Duration = 3 })
            createMainUI()
        else
            WindUI:Notify({ Title = "Ошибка", Content = "Неверный ключ", Duration = 3 })
        end
    end,
})

-- ============ MAIN UI ============
createMainUI = function()
    if unlocked then return end
    unlocked = true

    local vim = game:GetService("VirtualInputManager")
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local myName = player.Name

    local function getHrp()
        local char = player.Character
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function findPrompt(obj)
        if not obj then return nil end
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("ProximityPrompt") then return child end
            local found = findPrompt(child)
            if found then return found end
        end
        return nil
    end

    local function findText(obj)
        if not obj then return nil end
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("TextLabel") then return child.Text end
            local found = findText(child)
            if found then return found end
        end
        return nil
    end

    local function click(x, y)
        vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.05)
        vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
        task.wait(0.1)
    end

    local function getRaids()
        local things = workspace:FindFirstChild("_THINGS")
        if not things then return nil end
        local mg = things:FindFirstChild("Minigames")
        if not mg then return nil end
        local re = mg:FindFirstChild("RaidEvent")
        if not re then return nil end
        local portals = re:FindFirstChild("Portals")
        if not portals then return nil end
        return portals:FindFirstChild("Raids")
    end

    local function tpToPortal(num)
        local raids = getRaids()
        if not raids then return false end
        local raid = raids:FindFirstChild(tostring(num))
        if not raid then return false end
        local pad = raid:FindFirstChild("Pad")
        if not pad then return false end
        local part = pad:FindFirstChild("Part")
        if not part then return false end
        local hrp = getHrp()
        if not hrp then return false end
        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
        camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(0,3,0), part.Position)
        return true
    end

    local function findMyPortal()
        local raids = getRaids()
        if not raids then return nil end
        for i = 1, 10 do
            local raid = raids:FindFirstChild(tostring(i))
            if raid then
                local bb = raid:FindFirstChild("Billboard")
                if bb then
                    local text = findText(bb)
                    if text and text:find(myName, 1, true) then
                        return i
                    end
                end
            end
        end
        return nil
    end

    local function enterWorld2()
        local map = workspace:FindFirstChild("_MAP")
        if not map then return false end
        local interact = map:FindFirstChild("Interact")
        if not interact then return false end
        local raidPortal = interact:FindFirstChild("RaidPortal")
        if not raidPortal then return false end
        local portal = raidPortal:FindFirstChild("Portal")
        if not portal then return false end

        local hrp = getHrp()
        if not hrp then return false end

        hrp.CFrame = portal.CFrame + Vector3.new(-5, 3, -5)
        camera.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(-55, 3, -33), portal.Position)
        task.wait(0.1)

        local prompt = findPrompt(raidPortal)
        if prompt then
            prompt:InputHoldBegin()
            task.wait(1)
            prompt:InputHoldEnd()
        end
        task.wait(2)
        return true
    end

    local function selectDifficulty()
        local rld = nil
        for _ = 1, 60 do
            if not autoRaid then break end
            rld = player.PlayerGui:FindFirstChild("RaidCreate")
            if rld then break end
            task.wait(0.05)
        end

        if not rld then return end

        local frame = rld:FindFirstChild("Frame")
        if not frame then return end
        local container = frame:FindFirstChild("Container")
        if not container then return end
        local nextUnlock = container:FindFirstChild("NextUnlocks")
        if not nextUnlock or not nextUnlock:IsA("TextLabel") then return end

        local myLvl = tonumber(player.PlayerGui:FindFirstChild("RaidLvlDmg")
            and player.PlayerGui.RaidLvlDmg:FindFirstChild("Container")
            and player.PlayerGui.RaidLvlDmg.Container:FindFirstChild("Progress")
            and player.PlayerGui.RaidLvlDmg.Container.Progress:FindFirstChild("Lvl")
            and player.PlayerGui.RaidLvlDmg.Container.Progress.Lvl.Text:match("(%d+)")) or 0

        for _ = 1, 10 do
            if not autoRaid then break end
            local needLvl = tonumber(nextUnlock.Text:match("(%d+)")) or 99999
            if myLvl >= needLvl then
                click(1197, 589)
                task.wait(0.1)
            else
                break
            end
        end

        WindUI:Notify({ Title = "Raid", Content = "Готово! Lvl " .. myLvl, Duration = 2 })
    end

    local function farmLoop()
        while autoRaid do
            click(1250, 730)
            task.wait(0.4)
            click(900, 730)
            task.wait(3)

            local rooms = workspace:FindFirstChild("_THINGS")
            if rooms then rooms = rooms:FindFirstChild("Minigames") end
            if rooms then rooms = rooms:FindFirstChild("RaidLobby") end
            if rooms then rooms = rooms:FindFirstChild("Rooms") end

            if not rooms then break end

            for i = 1, 6 do
                if not autoRaid then break end
                local room = rooms:FindFirstChild(tostring(i))
                if room then
                    local gateFolder = room:FindFirstChild("Gate")
                    if gateFolder then
                        local gate = gateFolder:FindFirstChild("1")
                        if gate then
                            local h = getHrp()
                            if h then
                                h.CFrame = gate.CFrame + Vector3.new(0, 3, 0)
                                camera.CFrame = CFrame.lookAt(h.Position + Vector3.new(0, 3, 0), gate.Position)
                            end
                        end
                    end
                end
                task.wait(gateWait)
            end

            local interact = workspace:FindFirstChild("_THINGS")
            if interact then interact = interact:FindFirstChild("Minigames") end
            if interact then interact = interact:FindFirstChild("RaidLobby") end
            if interact then interact = interact:FindFirstChild("Interact") end

            if interact then
                local children = interact:GetChildren()
                local door = children[4]
                if door then
                    local shadow = door:FindFirstChild("Shadow")
                    if shadow then
                        local h = getHrp()
                        if h then
                            h.CFrame = shadow.CFrame
                            camera.CFrame = CFrame.lookAt(h.Position + Vector3.new(0, 3, 0), shadow.Position)
                        end
                    end
                end
            end

            task.wait(3)
        end
    end

    local RaidTab = Window:Tab({ Title = "Raid", Icon = "swords" })
    local RaidSec = RaidTab:Section({ Title = "Auto Raid" })

    -- ============ TOGGLE 1: Full ============
    RaidSec:Toggle({
        Title = "Auto Raid (Spawn)",
        Desc = "Если вы находитесь на спавне",
        Callback = function(state)
            autoRaid = state

            if state then
                task.spawn(function()
                    while autoRaid do
                        while not getHrp() and autoRaid do task.wait(0.5) end
                        if not autoRaid then break end

                        enterWorld2()

                        local found = findMyPortal()
                        if found then
                            myPortal = found
                            inWorld2 = true
                            tpToPortal(found)
                            task.wait(0.3)
                        else
                            local raids = getRaids()
                            if not raids then
                                task.wait(3)
                                continue
                            end

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

                            if not freeNum then
                                WindUI:Notify({ Title = "Raid", Content = "Нет свободных порталов", Duration = 2 })
                                task.wait(5)
                                continue
                            end

                            if tpToPortal(freeNum) then
                                myPortal = freeNum
                                inWorld2 = true
                                task.wait(0.3)
                            else
                                task.wait(2)
                                continue
                            end
                        end

                        if firstClaim then
                            for _ = 1, 50 do
                                if not autoRaid then break end
                                local msg = player.PlayerGui:FindFirstChild("Message")
                                if msg then
                                    local btn = msg:FindFirstChild("Frame")
                                        and msg.Frame:FindFirstChild("Buttons")
                                        and msg.Frame.Buttons:FindFirstChild("Button")
                                        and msg.Frame.Buttons.Button:FindFirstChild("Main")
                                    if btn then
                                        task.wait(0.1)
                                        local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                                        local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2 + 30
                                        click(x, y)
                                        break
                                    end
                                end
                                task.wait(0.1)
                            end
                            firstClaim = false
                        end

                        selectDifficulty()
                        farmLoop()

                        if autoRaid and myPortal then
                            tpToPortal(myPortal)
                        end

                        task.wait(3)
                    end
                end)
            else
                WindUI:Notify({ Title = "Raid", Content = "Auto Raid выключен", Duration = 2 })
            end
        end,
    })

    -- ============ TOGGLE 2: World 2 ============
    RaidSec:Toggle({
        Title = "Auto Raid (World 2)",
        Desc = "Если вы находитесь в мире с порталами для Raids",
        Callback = function(state)
            autoRaid = state

            if state then
                task.spawn(function()
                    while autoRaid do
                        while not getHrp() and autoRaid do task.wait(0.5) end
                        if not autoRaid then break end

                        local found = findMyPortal()
                        if found then
                            myPortal = found
                            tpToPortal(found)
                            task.wait(0.3)
                        else
                            WindUI:Notify({ Title = "Ошибка", Content = "Свой портал не найден", Duration = 3 })
                            task.wait(3)
                            continue
                        end

                        for _ = 1, 50 do
                            if not autoRaid then break end
                            local msg = player.PlayerGui:FindFirstChild("Message")
                            if msg then
                                local btn = msg:FindFirstChild("Frame")
                                    and msg.Frame:FindFirstChild("Buttons")
                                    and msg.Frame.Buttons:FindFirstChild("Button")
                                    and msg.Frame.Buttons.Button:FindFirstChild("Main")
                                if btn then
                                    task.wait(0.1)
                                    local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                                    local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2 + 30
                                    click(x, y)
                                    break
                                end
                            end
                            task.wait(0.1)
                        end

                        selectDifficulty()
                        farmLoop()

                        if autoRaid and myPortal then
                            tpToPortal(myPortal)
                        end

                        task.wait(3)
                    end
                end)
            else
                WindUI:Notify({ Title = "Raid", Content = "World 2 Raid выключен", Duration = 2 })
            end
        end,
    })

    RaidSec:Input({
        Title = "Задержка",
        Desc = "Телепорт между дверьми (сек)",
        Value = "1.2",
        Callback = function(v)
            local num = tonumber(v)
            if num and num > 0 then
                gateWait = num
            end
        end
    })
end   
