local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 设置
local Settings = {
    Ragebot = false,
    WallCheck = true,
    AutoFire = false,
    ESP = true,
    BoxESP = true,
    NameESP = true,
    HealthESP = true,
    Spinbot = false,
    SpinSpeed = 5,
    AimEnabled = false,
    FOV = 120,
    RapidFire = false,
    Tracers = true,
    HitSound = true
}

local ESPObjects = {}
local BulletTracers = {}

-- 创建UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RageBotMobileUI"
ScreenGui.ResetOnSpawn = false

-- 启动按钮（位于屏幕中间）
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 100, 0, 100)
OpenButton.Position = UDim2.new(0.5, -50, 0.5, -50)  -- 屏幕正中间
OpenButton.AnchorPoint = Vector2.new(0.5, 0.5)
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
OpenButton.Text = "🎯\nRageBot\n点击打开"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextWrapped = true
OpenButton.Visible = true
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0.2, 0)
OpenCorner.Parent = OpenButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "ControlPanel"
MainFrame.Size = UDim2.new(0, 280, 0, 400)  -- 适中大小
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)  -- 屏幕中间
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🎯 RageBot 控制面板"
TitleLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.AnchorPoint = Vector2.new(0, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- 滚动区域
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "OptionsScroll"
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Parent = MainFrame

local OptionsList = Instance.new("UIListLayout")
OptionsList.Padding = UDim.new(0, 8)
OptionsList.Parent = ScrollFrame

-- 功能开关列表
local Toggles = {
    {"Ragebot模式", "Ragebot"},
    {"墙壁检测", "WallCheck"},
    {"自动开火", "AutoFire"},
    {"ESP显示", "ESP"},
    {"旋转身体", "Spinbot"},
    {"自动瞄准", "AimEnabled"},
    {"速射模式", "RapidFire"},
    {"弹道显示", "Tracers"},
    {"命中音效", "HitSound"}
}

-- 创建开关
for i, data in ipairs(Toggles) do
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = data[1] .. "Frame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = data[1]
    toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleLabel.TextSize = 16
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0.5, -15)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleButton.Text = ""
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Name = "Dot"
    toggleDot.Size = UDim2.new(0, 24, 0, 24)
    toggleDot.Position = UDim2.new(0, 3, 0.5, 0)
    toggleDot.AnchorPoint = Vector2.new(0, 0.5)
    toggleDot.BackgroundColor3 = Settings[data[2]] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    toggleDot.Parent = toggleButton
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = toggleDot
    
    -- 设置初始位置
    if Settings[data[2]] then
        toggleDot.Position = UDim2.new(1, -27, 0.5, 0)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        Settings[data[2]] = not Settings[data[2]]
        
        if Settings[data[2]] then
            -- 动画移动到右边
            toggleDot:TweenPosition(UDim2.new(1, -27, 0.5, 0), "Out", "Quad", 0.2)
            toggleDot.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        else
            -- 动画移动到左边
            toggleDot:TweenPosition(UDim2.new(0, 3, 0.5, 0), "Out", "Quad", 0.2)
            toggleDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
        
        -- 播放点击音效
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://3570574871"
        sound.Volume = 0.2
        sound.Parent = toggleButton
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 1)
    end)
    
    toggleButton.Parent = toggleFrame
    toggleFrame.Parent = ScrollFrame
end

-- 状态标签
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 1, -100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "就绪"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- 按钮事件
OpenButton.MouseButton1Click:Connect(function()
    OpenButton.Visible = false
    MainFrame.Visible = true
    
    -- 按钮点击效果
    OpenButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    wait(0.1)
    OpenButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

-- 保护GUI
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- ESP功能
local function CreateESP(player)
    if not player.Character or ESPObjects[player] then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text")
    }
    
    esp.Box.Visible = false
    esp.Box.Color = Color3.fromRGB(0, 255, 0)
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    
    esp.Name.Visible = false
    esp.Name.Color = Color3.fromRGB(255, 255, 255)
    esp.Name.Size = 16
    esp.Name.Text = player.Name
    esp.Name.Outline = true
    esp.Name.Center = true

esp.Health.Visible = false
    esp.Health.Size = 14
    esp.Health.Outline = true
    esp.Health.Center = true
    
    ESPObjects[player] = esp
end

local function UpdateESP()
    if not Settings.ESP then 
        for player, esp in pairs(ESPObjects) do
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Health.Visible = false
        end
        return 
    end
    
    for player, esp in pairs(ESPObjects) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Health.Visible = false
            continue
        end
        
        local char = player.Character
        local hrp = char.HumanoidRootPart
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if hrp and humanoid then
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local scale = 1000 / screenPos.Z
                local size = Vector2.new(3 * scale, 5 * scale)
                
                esp.Box.Size = size
                esp.Box.Position = Vector2.new(screenPos.X - size.X/2, screenPos.Y - size.Y/2)
                esp.Box.Visible = Settings.BoxESP
                
                esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y/2 - 20)
                esp.Name.Visible = Settings.NameESP
                
                esp.Health.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y/2 + 5)
                esp.Health.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                esp.Health.Color = Color3.fromRGB(
                    255 - (humanoid.Health / humanoid.MaxHealth) * 255,
                    (humanoid.Health / humanoid.MaxHealth) * 255,
                    0
                )
                esp.Health.Visible = Settings.HealthESP
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Health.Visible = false
            end
        end
    end
end

-- 获取最近玩家
local function GetClosestPlayer()
    local closest = nil
    local maxDist = Settings.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < maxDist then
                    if Settings.WallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * 1000)
                        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                        
                        if hit and hit:IsDescendantOf(player.Character) then
                            closest = player
                            maxDist = distance
                        end
                    else
                        closest = player
                        maxDist = distance
                    end
                end
            end
        end
    end
    
    return closest
end

-- 命中音效
local HitSounds = {
    "rbxassetid://9129452039",  -- 清脆命中
    "rbxassetid://5442996157",  -- 经典命中
    "rbxassetid://3570574871",  -- 点击声
    "rbxassetid://9119724370"   -- 电子声
}

local function PlayHitSound()
    if Settings.HitSound then
        local sound = Instance.new("Sound")
        sound.SoundId = HitSounds[math.random(1, #HitSounds)]
        sound.Volume = 0.3
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end
end

-- 弹道显示
local function CreateBulletTracer(startPos, endPos)
    if not Settings.Tracers then return end
    
    local tracer = Instance.new("Part")
    tracer.Name = "BulletTracer"
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Transparency = 0.3
    tracer.Material = Enum.Material.Neon
    tracer.Color = Color3.fromRGB(255, 50, 50)
    tracer.Size = Vector3.new(0.1, 0.1, (startPos - endPos).Magnitude)
    tracer.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -(startPos - endPos).Magnitude/2)
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    
    local attachment0 = Instance.new("Attachment")
    local attachment1 = Instance.new("Attachment")
    attachment0.Parent = tracer
    attachment1.Parent = tracer
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Parent = tracer
    
    tracer.Parent = workspace
    table.insert(BulletTracers, tracer)
    
    spawn(function()
        local duration = 2
        local startTime = tick()
        
        while tick() - startTime < duration do
            if tracer and tracer.Parent then
                local alpha = 1 - ((tick() - startTime) / duration)
                tracer.Transparency = 1 - (alpha * 0.7)
                beam.Color = ColorSequence.new(Color3.fromRGB(255 * alpha, 0, 0))
                wait(0.05)
            else
                break
            end
        end
        
        if tracer and tracer.Parent then
            tracer:Destroy()
        end
    end)
end

-- 主循环
local LastShot = 0
local Target = nil
local IsShooting = false

RunService.RenderStepped:Connect(function()
    -- Spinbot
    if Settings.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
    
    -- 自动瞄准
    if Settings.AimEnabled or Settings.Ragebot then
        Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = Target.Character.HumanoidRootPart.Position
            local camera = workspace.CurrentCamera
            
            if Settings.Ragebot then
                -- Ragebot模式
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
                
                if Settings.AutoFire and tick() - LastShot > 0.1 then
                    mouse1press()
                    wait(0.05)
                    mouse1release()
                    LastShot = tick()
                    IsShooting = true
                    
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                        CreateBulletTracer(LocalPlayer.Character.Head.Position, targetPos)
                        PlayHitSound()
                    end
                else
                    IsShooting = false
                end
            else
                -- 平滑自瞄
                local newCFrame = CFrame.new(camera.CFrame.Position, targetPos)
                camera.CFrame = camera.CFrame:Lerp(newCFrame, 0.1)
            end
        end
    end
    
    -- 速射
    if Settings.RapidFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        if tick() - LastShot > 0.05 then
            mouse1press()
            wait(0.01)
            mouse1release()
            LastShot = tick()
            IsShooting = true
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local startPos = LocalPlayer.Character.Head.Position
                local mouse = UserInputService:GetMouseLocation()
                local ray = Camera:ViewportPointToRay(mouse.X, mouse.Y)
                CreateBulletTracer(startPos, startPos + (ray.Direction * 1000))
            end
        end
    end
    
    -- 更新状态标签
    local statusText = "就绪"
    if Settings.AimEnabled or Settings.Ragebot then
        if Target then
            statusText = "锁定: " .. Target.Name
            if IsShooting then
                statusText = statusText .. " [开火]"
            end
        else
            statusText = "搜索目标..."
        end
    end
    StatusLabel.Text = statusText
    
    UpdateESP()
end)

-- 初始化ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        ESPObjects[player].Health:Remove()
        ESPObjects[player] = nil
    end
end)

-- 清理弹道
spawn(function()
    while wait(5) do
        for i = #BulletTracers, 1, -1 do
            local tracer = BulletTracers[i]
            if not tracer or not tracer.Parent then
                table.remove(BulletTracers, i)
            end
        end
    end
end)

-- 关闭脚本
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        for _, esp in pairs(ESPObjects) do
            esp.Box:Remove()
            esp.Name:Remove()
            esp.Health:Remove()
        end
        ESPObjects = {}
        
        for _, tracer in pairs(BulletTracers) do
            if tracer and tracer.Parent then
                tracer:Destroy()
            end
        end
        BulletTracers = {}
        
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy()
        end
        
        print("脚本已关闭")
    end
end)

-- 控制台信息
print("🎯 RageBot Mobile 已加载!")
print("屏幕中间有红色🎯按钮，点击打开控制面板")
print("控制面板可以拖动")
print("按P键关闭脚本")

-- 清理GUI
spawn(function()
    while wait(1) do
        if not ScreenGui or not ScreenGui.Parent then
            print("检测到GUI丢失，重新创建...")
            -- 这里可以添加GUI重新创建的代码
        end
    end
end)