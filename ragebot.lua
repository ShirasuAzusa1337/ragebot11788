local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local MobileUIEnabled = false
local MainFrame = nil

-- 设置
local Settings = {
    RagebotEnabled = false,
    WallCheck = true,
    AutoFire = false,
    ESP = true,
    Spinbot = false,
    SpinSpeed = 5,
    AimEnabled = false,
    FOV = 100,
    RapidFire = false,
    Tracers = true,
    HitSound = true
}

function CreateMobileUI()
    if not MainFrame then
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "MobileRageBotUI"
        
        local Frame = Instance.new("Frame")
        Frame.Name = "MainFrame"
        Frame.Size = UDim2.new(0.3, 0, 0.5, 0)
        Frame.Position = UDim2.new(0.02, 0, 0.25, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Frame.BackgroundTransparency = 0.2
        Frame.BorderSizePixel = 0
        Frame.Visible = MobileUIEnabled
        Frame.Parent = ScreenGui
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = Frame
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.Parent = Frame
        
        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingTop = UDim.new(0, 10)
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.Parent = Frame
        
        -- 标题
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundTransparency = 1
        Title.Text = "RageBot Mobile"
        Title.TextColor3 = Color3.fromRGB(255, 100, 100)
        Title.TextSize = 20
        Title.Font = Enum.Font.GothamBold
        Title.Parent = Frame
        
        -- 开关按钮
        local ToggleButtons = {
            {"Ragebot", "RagebotEnabled"},
            {"Wall Check", "WallCheck"},
            {"Auto Fire", "AutoFire"},
            {"ESP", "ESP"},
            {"Spinbot", "Spinbot"},
            {"Aimbot", "AimEnabled"},
            {"Rapid Fire", "RapidFire"},
            {"Tracers", "Tracers"},
            {"Hit Sound", "HitSound"}
        }
        
        for i, data in ipairs(ToggleButtons) do
            local button = Instance.new("TextButton")
            button.Name = data[1] .. "Button"
            button.Size = UDim2.new(1, 0, 0, 40)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            button.BorderSizePixel = 0
            button.Text = data[1]
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
            button.TextSize = 16
            button.Font = Enum.Font.Gotham
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = button
            
            local statusDot = Instance.new("Frame")
            statusDot.Name = "StatusDot"
            statusDot.Size = UDim2.new(0, 10, 0, 10)
            statusDot.Position = UDim2.new(0.9, 0, 0.5, 0)
            statusDot.AnchorPoint = Vector2.new(0.5, 0.5)
            statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            statusDot.BorderSizePixel = 0
            
            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = statusDot
            
            statusDot.Parent = button
            
            button.MouseButton1Click:Connect(function()
                Settings[data[2]] = not Settings[data[2]]
                statusDot.BackgroundColor3 = Settings[data[2]] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
                
                -- 播放点击音效
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://3570574871"
                sound.Volume = 0.3
                sound.Parent = button
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 1)
            end)
            
            button.Parent = Frame
        end
        
        -- 关闭按钮
        local CloseButton = Instance.new("TextButton")
        CloseButton.Name = "CloseButton"
        CloseButton.Size = UDim2.new(1, 0, 0, 50)
        CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        CloseButton.BorderSizePixel = 0
        CloseButton.Text = "关闭界面"
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextSize = 18
        CloseButton.Font = Enum.Font.GothamBold
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 6)
        closeCorner.Parent = CloseButton
        
        CloseButton.MouseButton1Click:Connect(function()
            MobileUIEnabled = false
            Frame.Visible = false
        end)
        
        CloseButton.Parent = Frame
        
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = game:GetService("CoreGui")
        elseif gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = game:GetService("CoreGui")
        end
        
        MainFrame = Frame
    end
end

CreateMobileUI()
-- 创建移动端切换按钮
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "MobileToggleButton"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0.5, 0, 0.9, 0)
ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "🎮"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Visible = UserInputService.TouchEnabled

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MobileUIEnabled = not MobileUIEnabled
    if MainFrame then
        MainFrame.Visible = MobileUIEnabled
    end
    ToggleButton.BackgroundColor3 = MobileUIEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(255, 50, 50)
end)

if syn and syn.protect_gui then
    syn.protect_gui(ToggleButton)
    ToggleButton.Parent = game:GetService("CoreGui")
elseif gethui then
    ToggleButton.Parent = gethui()
else
    ToggleButton.Parent = game:GetService("CoreGui")
end

local HitSounds = {
    "rbxassetid://9129452039",  -- 清脆命中
    "rbxassetid://5442996157",  -- 经典命中
    "rbxassetid://3570574871",  -- 点击声
    "rbxassetid://9119724370"   -- 电子声
}

function PlayHitSound()
    if Settings.HitSound then
        local sound = Instance.new("Sound")
        sound.SoundId = HitSounds[math.random(1, #HitSounds)]
        sound.Volume = 0.3
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end
end

local ESPObjects = {}
local ESPConnections = {}

function CreateESP(player)
    if not player.Character or ESPObjects[player] then return end
    
    local char = player.Character
    local esp = {
        Box = nil,
        Name = nil,
        Health = nil
    }
    
    -- 创建方框
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(0, 255, 0)
    box.Thickness = 2
    box.Filled = false
    esp.Box = box
    
    -- 创建名字标签
    local nameLabel = Drawing.new("Text")
    nameLabel.Visible = false
    nameLabel.Color = Color3.fromRGB(255, 255, 255)
    nameLabel.Size = 16
    nameLabel.Text = player.Name
    nameLabel.Outline = true
    nameLabel.Center = true
    esp.Name = nameLabel
    
    -- 创建血量标签
    local healthLabel = Drawing.new("Text")
    healthLabel.Visible = false
    healthLabel.Size = 14
    healthLabel.Outline = true
    healthLabel.Center = true
    esp.Health = healthLabel
    
    ESPObjects[player] = esp
    
    -- 监听玩家离开
    ESPConnections[player] = player.CharacterRemoving:Connect(function()
        if ESPObjects[player] then
            if esp.Box then esp.Box:Remove() end
            if esp.Name then esp.Name:Remove() end
            if esp.Health then esp.Health:Remove() end
            ESPObjects[player] = nil
        end
    end)
end

function UpdateESP()
    if not Settings.ESP then return end
    
    for player, esp in pairs(ESPObjects) do
        if not player or not player.Character or player.Character:FindFirstChild("HumanoidRootPart") == nil then
            if esp.Box then esp.Box.Visible = false end
            if esp.Name then esp.Name.Visible = false end
            if esp.Health then esp.Health.Visible = false end
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
                
                -- 更新方框
                esp.Box.Size = size
                esp.Box.Position = Vector2.new(screenPos.X - size.X/2, screenPos.Y - size.Y/2)
                esp.Box.Visible = Settings.ESP
                
                -- 更新名字
                esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y/2 - 20)
                esp.Name.Visible = Settings.ESP
                
                -- 更新血量
                if humanoid then
                    esp.Health.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y/2 + 5)
                    esp.Health.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    esp.Health.Color = Color3.fromRGB(
                        255 - (humanoid.Health / humanoid.MaxHealth) * 255,
                        (humanoid.Health / humanoid.MaxHealth) * 255,
                        0
                    )
                    esp.Health.Visible = Settings.ESP
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Health.Visible = false
            end
        end
    end
end

function ClearESP()
    for player, esp in pairs(ESPObjects) do
        if esp.Box then esp.Box:Remove() end
        if esp.Name then esp.Name:Remove() end
        if esp.Health then esp.Health:Remove() end
    end
    ESPObjects = {}
    
    for player, conn in pairs(ESPConnections) do
        conn:Disconnect()
    end
    ESPConnections = {}
end

function GetClosestPlayer()
    local closest = nil
    local maxDist = Settings.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hrp = char.HumanoidRootPart
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < maxDist then
                    if Settings.WallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * 1000)
                        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                        
                        if hit and hit:IsDescendantOf(char) then
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

-- 弹道显示
local BulletTracers = {}

function CreateBulletTracer(startPos, endPos)
    if not Settings.Tracers then return end
    
    local tracer = Instance.new("Part")
    tracer.Name = "BulletTracer"
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Transparency = 0.3
    tracer.Material = Enum.Material.Neon
    tracer.Color = Color3.fromRGB(255, 100, 100)
    tracer.Size = Vector3.new(0.1, 0.1, (startPos - endPos).Magnitude)
    tracer.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -(startPos - endPos).Magnitude/2)
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 50, 50))
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
    
    -- 渐隐效果
    spawn(function()
        local duration = 2
        local startTime = tick()
        
        while tick() - startTime < duration do
            if tracer and tracer.Parent then
                local alpha = 1 - ((tick() - startTime) / duration)
                tracer.Transparency = 1 - (alpha * 0.7)
                beam.Color = ColorSequence.new(Color3.fromRGB(255 * alpha, 50 * alpha, 50 * alpha))
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

local LastShot = 0
local Target = nil

RunService.RenderStepped:Connect(function()
    -- Spinbot
    if Settings.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
    
    -- 自动瞄准
    if Settings.AimEnabled then
        Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = Target.Character.HumanoidRootPart.Position
            local camera = workspace.CurrentCamera
            
            if Settings.RagebotEnabled then
                -- Ragebot模式：直接锁定
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
                
                -- 自动开火
                if Settings.AutoFire and tick() - LastShot > 0.1 then
                    -- 模拟射击
                    mouse1press()
                    wait(0.05)
                    mouse1release()
                    LastShot = tick()
                    
                    -- 创建弹道
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                        local startPos = LocalPlayer.Character.Head.Position
                        CreateBulletTracer(startPos, targetPos)
                        PlayHitSound()
                    end
                end
            else
                -- 平滑瞄准
                local smooth = 0.1
                local newCFrame = CFrame.new(camera.CFrame.Position, targetPos)
                camera.CFrame = camera.CFrame:Lerp(newCFrame, smooth)
            end
        end
    end
    
    -- 速射模式
    if Settings.RapidFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        if tick() - LastShot > 0.05 then
            mouse1press()
            wait(0.01)
            mouse1release()
            LastShot = tick()
            
            -- 创建弹道
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local startPos = LocalPlayer.Character.Head.Position
                local mouse = UserInputService:GetMouseLocation()
                local ray = Camera:ViewportPointToRay(mouse.X, mouse.Y)
                CreateBulletTracer(startPos, startPos + (ray.Direction * 1000))
            end
        end
    end
    
    -- 更新ESP
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not ESPObjects[player] then
                CreateESP(player)
            end
        end
        UpdateESP()
    end
end)
-- 初始化ESP
spawn(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
end)

-- 新玩家加入
Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

-- 玩家离开
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
        if ESPObjects[player].Name then ESPObjects[player].Name:Remove() end
        if ESPObjects[player].Health then ESPObjects[player].Health:Remove() end
        ESPObjects[player] = nil
    end
    if ESPConnections[player] then
        ESPConnections[player]:Disconnect()
        ESPConnections[player] = nil
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
-- 控制台信息
print("===============================")
print("RageBot 已加载!")
print("功能列表:")
print("- 手机版UI开关")
print("- Ragebot模式")
print("- 墙壁检测")
print("- 自动开火")
print("- ESP显示")
print("- Spinbot")
print("- 自动瞄准")
print("- 速射模式")
print("- 弹道显示")
print("- 命中音效")
print("===============================")
print("移动端: 点击右下角按钮打开UI")
print("按P键关闭脚本")
print("===============================")

-- 关闭脚本
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        ClearESP()
        for _, tracer in pairs(BulletTracers) do
            if tracer and tracer.Parent then
                tracer:Destroy()
            end
        end
        if MainFrame and MainFrame.Parent then
            MainFrame.Parent:Destroy()
        end
        if ToggleButton and ToggleButton.Parent then
            ToggleButton:Destroy()
        end
        print("脚本已关闭")
    end
end)