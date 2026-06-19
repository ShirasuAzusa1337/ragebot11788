--[[
    PremiumUI Framework
    用于 Roblox Studio 游戏开发
    快捷键: RightShift 显示/隐藏面板
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
--  主题配置
-- ══════════════════════════════════════════
local Theme = {
    Background   = Color3.fromRGB(12, 12, 18),
    Surface      = Color3.fromRGB(20, 20, 30),
    SurfaceHover = Color3.fromRGB(28, 28, 42),
    Accent       = Color3.fromRGB(99, 102, 241),   -- 靛蓝
    AccentDim    = Color3.fromRGB(55, 58, 140),
    AccentGlow   = Color3.fromRGB(139, 92, 246),   -- 紫色点缀
    Text         = Color3.fromRGB(230, 230, 245),
    TextDim      = Color3.fromRGB(130, 130, 160),
    Border       = Color3.fromRGB(40, 40, 60),
    Success      = Color3.fromRGB(52, 211, 153),
    Danger       = Color3.fromRGB(248, 113, 113),
    ToggleOff    = Color3.fromRGB(60, 60, 80),
}

-- ══════════════════════════════════════════
--  工具函数
-- ══════════════════════════════════════════
local function tween(obj, props, dur, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(dur or 0.2, style, dir), props):Play()
end

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
end

local function makeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
end

local function makePadding(parent, all, lr, tb)
    local p = Instance.new("UIPadding")
    if all then
        p.PaddingLeft   = UDim.new(0, all)
        p.PaddingRight  = UDim.new(0, all)
        p.PaddingTop    = UDim.new(0, all)
        p.PaddingBottom = UDim.new(0, all)
    else
        p.PaddingLeft   = UDim.new(0, lr or 0)
        p.PaddingRight  = UDim.new(0, lr or 0)
        p.PaddingTop    = UDim.new(0, tb or 0)
        p.PaddingBottom = UDim.new(0, tb or 0)
    end
    p.Parent = parent
end

local function label(parent, text, size, color, weight)
    local l = Instance.new("TextLabel")
    l.Text = text
    l.TextSize = size or 14
    l.TextColor3 = color or Theme.Text
    l.Font = weight or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.AutomaticSize = Enum.AutomaticSize.XY
    l.Parent = parent
    return l
end

-- ══════════════════════════════════════════
--  ScreenGui
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════════
--  主面板
-- ══════════════════════════════════════════
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(0, 320, 0, 480)
Panel.Position = UDim2.new(0.5, -160, 0.5, -240)
Panel.BackgroundColor3 = Theme.Background
Panel.BorderSizePixel = 0
Panel.ClipsDescendants = true
Panel.Parent = ScreenGui
makeCorner(Panel, 12)
makeStroke(Panel, Theme.Border, 1)

-- 顶部渐变光带
local TopGlow = Instance.new("Frame")
TopGlow.Size = UDim2.new(1, 0, 0, 2)
TopGlow.BackgroundColor3 = Theme.Accent
TopGlow.BorderSizePixel = 0
TopGlow.ZIndex = 5
TopGlow.Parent = Panel
Instance.new("UIGradient", TopGlow).Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Theme.AccentGlow),
    ColorSequenceKeypoint.new(0.5, Theme.Accent),
    ColorSequenceKeypoint.new(1,   Theme.AccentGlow),
})

-- 背景渐变
local BgGrad = Instance.new("UIGradient")
BgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(14, 14, 22)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 10, 16)),
})
BgGrad.Rotation = 135
BgGrad.Parent = Panel

-- ══════════════════════════════════════════
--  标题栏
-- ══════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 52)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Panel

-- 图标点缀
local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 8, 0, 8)
Dot.Position = UDim2.new(0, 18, 0.5, -4)
Dot.BackgroundColor3 = Theme.Accent
Dot.BorderSizePixel = 0
Dot.Parent = TitleBar
makeCorner(Dot, 4)
-- 光晕
local DotGlow = Instance.new("ImageLabel")
DotGlow.Size = UDim2.new(0, 24, 0, 24)
DotGlow.Position = UDim2.new(0, 10, 0.5, -12)
DotGlow.BackgroundTransparency = 1
DotGlow.Image = "rbxassetid://6015897843"
DotGlow.ImageColor3 = Theme.Accent
DotGlow.ImageTransparency = 0.5
DotGlow.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Text = "Premium UI"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextColor3 = Theme.Text
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 34, 0, 0)
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local SubText = Instance.new("TextLabel")
SubText.Text = "v1.0  •  RightShift 切换"
SubText.Font = Enum.Font.Gotham
SubText.TextSize = 11
SubText.TextColor3 = Theme.TextDim
SubText.BackgroundTransparency = 1
SubText.Position = UDim2.new(0, 34, 0, 0)
SubText.Size = UDim2.new(1, -80, 1, 0)
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.TextYAlignment = Enum.TextYAlignment.Bottom
SubText.Parent = TitleBar

-- 关闭按钮
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(248, 113, 113)
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.Danger
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
makeCorner(CloseBtn, 6)

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, {BackgroundTransparency = 0.3}, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, {BackgroundTransparency = 0.8}, 0.15)
end)

-- 分割线
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -24, 0, 1)
Divider.Position = UDim2.new(0, 12, 0, 52)
Divider.BackgroundColor3 = Theme.Border
Divider.BorderSizePixel = 0
Divider.Parent = Panel

-- ══════════════════════════════════════════
--  Tab 栏
-- ══════════════════════════════════════════
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, 36)
TabBar.Position = UDim2.new(0, 12, 0, 62)
TabBar.BackgroundColor3 = Theme.Surface
TabBar.BorderSizePixel = 0
TabBar.Parent = Panel
makeCorner(TabBar, 8)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar
makePadding(TabBar, 4)

local TabPages = {}
local ActiveTab = nil

local function makeTab(name, icon, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -4, 1, 0)
    btn.BackgroundColor3 = Theme.SurfaceHover
    btn.BackgroundTransparency = 1
    btn.Text = icon .. "  " .. name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Theme.TextDim
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = TabBar
    makeCorner(btn, 6)

    -- 页面容器
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -24, 1, -116)
    page.Position = UDim2.new(0, 12, 0, 108)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = Panel

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = page

    TabPages[name] = {btn = btn, page = page}

    btn.MouseButton1Click:Connect(function()
        if ActiveTab == name then return end
        -- 隐藏旧 tab
        if ActiveTab then
            local old = TabPages[ActiveTab]
            tween(old.btn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}, 0.2)
            old.page.Visible = false
        end
        ActiveTab = name
        tween(btn, {BackgroundTransparency = 0, TextColor3 = Theme.Text}, 0.2)
        page.Visible = true
    end)

    return page
end

-- ══════════════════════════════════════════
--  组件库
-- ══════════════════════════════════════════

-- 分组标题
local function addSection(page, title)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundTransparency = 1
    row.Parent = page

    local txt = label(row, title, 11, Theme.TextDim, Enum.Font.GothamBold)
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = string.upper(title)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = Theme.Border
    line.BorderSizePixel = 0
    line.Parent = row
end

-- 开关
local function addToggle(page, text, desc, default, callback)
    local state = default or false

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, desc and 54 or 42)
    card.BackgroundColor3 = Theme.Surface
    card.BorderSizePixel = 0
    card.Parent = page
    makeCorner(card, 8)
    makeStroke(card, Theme.Border, 1)
    makePadding(card, nil, 12, 10)

    local titleLbl = label(card, text, 13, Theme.Text, Enum.Font.GothamMedium)
    titleLbl.Size = UDim2.new(1, -50, 0, 18)
    titleLbl.Position = UDim2.new(0, 0, 0, 0)
    titleLbl.AutomaticSize = Enum.AutomaticSize.None

    if desc then
        local descLbl = label(card, desc, 11, Theme.TextDim, Enum.Font.Gotham)
        descLbl.Size = UDim2.new(1, -50, 0, 14)
        descLbl.Position = UDim2.new(0, 0, 0, 22)
        descLbl.AutomaticSize = Enum.AutomaticSize.None
    end

    -- 轨道
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 36, 0, 20)
    track.Position = UDim2.new(1, -36, 0.5, -10)
    track.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
    track.BorderSizePixel = 0
    track.Parent = card
    makeCorner(track, 10)

    -- 滑块
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track
    makeCorner(knob, 7)

    -- 点击区域
    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = card

    local function updateVisual()
        tween(track, {BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff}, 0.2)
        tween(knob, {Position = state
            and UDim2.new(1, -17, 0.5, -7)
            or  UDim2.new(0, 3,   0.5, -7)}, 0.2)
        if state then
            tween(card, {BackgroundColor3 = Color3.fromRGB(24, 24, 38)}, 0.2)
            makeStroke(card, Theme.AccentDim, 1)
        else
            tween(card, {BackgroundColor3 = Theme.Surface}, 0.2)
            makeStroke(card, Theme.Border, 1)
        end
    end

    hitbox.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if callback then callback(state) end
    end)

    hitbox.MouseEnter:Connect(function()
        tween(card, {BackgroundColor3 = Theme.SurfaceHover}, 0.15)
    end)
    hitbox.MouseLeave:Connect(function()
        tween(card, {BackgroundColor3 = state and Color3.fromRGB(24,24,38) or Theme.Surface}, 0.15)
    end)

    updateVisual()
    return {
        GetState = function() return state end,
        SetState = function(v)
            state = v
            updateVisual()
            if callback then callback(state) end
        end,
    }
end

-- 滑块
local function addSlider(page, text, min, max, default, callback)
    local value = math.clamp(default or min, min, max)

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = Theme.Surface
    card.BorderSizePixel = 0
    card.Parent = page
    makeCorner(card, 8)
    makeStroke(card, Theme.Border, 1)
    makePadding(card, nil, 12, 10)

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, 18)
    topRow.BackgroundTransparency = 1
    topRow.Parent = card

    local titleLbl = label(topRow, text, 13, Theme.Text, Enum.Font.GothamMedium)
    titleLbl.Size = UDim2.new(1, -40, 1, 0)
    titleLbl.AutomaticSize = Enum.AutomaticSize.None

    local valLbl = Instance.new("TextLabel")
    valLbl.Text = tostring(value)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextColor3 = Theme.Accent
    valLbl.BackgroundTransparency = 1
    valLbl.Size = UDim2.new(0, 40, 1, 0)
    valLbl.Position = UDim2.new(1, -40, 0, 0)
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = topRow

    -- 轨道
    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, 0, 0, 6)
    trackBg.Position = UDim2.new(0, 0, 0, 30)
    trackBg.BackgroundColor3 = Theme.ToggleOff
    trackBg.BorderSizePixel = 0
    trackBg.Parent = card
    makeCorner(trackBg, 3)

    local trackFill = Instance.new("Frame")
    trackFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    trackFill.BackgroundColor3 = Theme.Accent
    trackFill.BorderSizePixel = 0
    trackFill.Parent = trackBg
    makeCorner(trackFill, 3)

    -- 拖拽逻辑
    local dragging = false

    local function updateValue(x)
        local abs = trackBg.AbsolutePosition
        local w   = trackBg.AbsoluteSize.X
        local t   = math.clamp((x - abs.X) / w, 0, 1)
        value = math.floor(min + t * (max - min) + 0.5)
        tween(trackFill, {Size = UDim2.new(t, 0, 1, 0)}, 0.05)
        valLbl.Text = tostring(value)
        if callback then callback(value) end
    end

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 0, 22)
    hitbox.Position = UDim2.new(0, 0, 0, 24)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = card

    hitbox.MouseButton1Down:Connect(function(x)
        dragging = true
        updateValue(x)
    end)
    hitbox.MouseButton1Up:Connect(function() dragging = false end)
    hitbox.MouseMoved:Connect(function(x)
        if dragging then updateValue(x) end
    end)

    return {
        GetValue = function() return value end,
        SetValue = function(v)
            value = math.clamp(v, min, max)
            local t = (value - min) / (max - min)
            tween(trackFill, {Size = UDim2.new(t, 0, 1, 0)}, 0.1)
            valLbl.Text = tostring(value)
        end,
    }
end

-- 按钮
local function addButton(page, text, accent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = accent and Theme.Accent or Theme.Surface
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = accent and Color3.fromRGB(255,255,255) or Theme.Text
    btn.BorderSizePixel = 0
    btn.Parent = page
    makeCorner(btn, 8)
    if not accent then makeStroke(btn, Theme.Border, 1) end

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = accent and Theme.AccentGlow or Theme.SurfaceHover}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = accent and Theme.Accent or Theme.Surface}, 0.15)
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, {BackgroundColor3 = Theme.AccentDim}, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, {BackgroundColor3 = accent and Theme.AccentGlow or Theme.SurfaceHover}, 0.08)
        if callback then callback() end
    end)

    return btn
end

-- 信息标签
local function addInfo(page, text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
    row.BorderSizePixel = 0
    row.Parent = page
    makeCorner(row, 8)
    makeStroke(row, Color3.fromRGB(40, 80, 120), 1)
    makePadding(row, nil, 12, 8)

    local icon = label(row, "ℹ", 13, Theme.Accent, Enum.Font.GothamBold)
    icon.Size = UDim2.new(0, 20, 1, 0)
    icon.AutomaticSize = Enum.AutomaticSize.None
    icon.TextXAlignment = Enum.TextXAlignment.Center

    local txt = label(row, text, 12, Theme.TextDim, Enum.Font.Gotham)
    txt.Size = UDim2.new(1, -24, 1, 0)
    txt.Position = UDim2.new(0, 24, 0, 0)
    txt.AutomaticSize = Enum.AutomaticSize.None
    txt.TextWrapped = true
end

-- ══════════════════════════════════════════
--  填充页面内容
-- ══════════════════════════════════════════
local page1 = makeTab("功能", "⚡", 1)
local page2 = makeTab("设置", "⚙", 2)

-- 功能页
addSection(page1, "视觉")
addToggle(page1, "玩家高光", "在玩家周围显示发光轮廓", false, function(v)
    print("玩家高光:", v)
end)
addToggle(page1, "名称标签", "显示玩家名称与距离", true, function(v)
    print("名称标签:", v)
end)
addToggle(page1, "血量显示", "在玩家头顶显示血量条", false, function(v)
    print("血量显示:", v)
end)

addSection(page1, "游戏")
addToggle(page1, "速度提升", "提高角色移动速度", false, function(v)
    print("速度提升:", v)
end)
addSlider(page1, "移动速度", 16, 60, 16, function(v)
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)
addToggle(page1, "跳跃增强", "提高跳跃高度", false, function(v)
    print("跳跃增强:", v)
end)
addSlider(page1, "跳跃高度", 50, 200, 50, function(v)
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v end
    end
end)

addSection(page1, "操作")
addButton(page1, "传送至出生点", false, function()
    if LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(0, 5, 0) end
    end
end)
addButton(page1, "重置角色", true, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.Health = 0 end
end)

-- 设置页
addSection(page2, "界面")
addToggle(page2, "毛玻璃背景", "开启半透明模糊效果", false, function(v)
    Panel.BackgroundTransparency = v and 0.15 or 0
end)
addSlider(page2, "界面透明度", 0, 80, 0, function(v)
    Panel.BackgroundTransparency = v / 100
end)
addToggle(page2, "彩虹边框", "顶部光带循环变色", false, function(v)
    if v then
        RunService:BindToRenderStep("RainbowGlow", 1, function()
            local h = tick() * 0.1 % 1
            TopGlow.BackgroundColor3 = Color3.fromHSV(h, 0.8, 1)
        end)
    else
        RunService:UnbindFromRenderStep("RainbowGlow")
        TopGlow.BackgroundColor3 = Theme.Accent
    end
end)

addSection(page2, "通知")
addToggle(page2, "操作提示", "开关时弹出简短提示", true, function(v)
    print("操作提示:", v)
end)
addInfo(page2, "快捷键 RightShift 可随时显示 / 隐藏此面板")
addButton(page2, "保存配置", true, function()
    print("配置已保存")
end)

-- 激活第一个 Tab
TabPages["功能"].btn:FireEvent("MouseButton1Click")
-- 手动激活
ActiveTab = "功能"
tween(TabPages["功能"].btn, {BackgroundTransparency = 0, TextColor3 = Theme.Text}, 0.2)
TabPages["功能"].page.Visible = true

-- ══════════════════════════════════════════
--  拖拽
-- ══════════════════════════════════════════
do
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Panel.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ══════════════════════════════════════════
--  显示 / 隐藏动画  (RightShift)
-- ══════════════════════════════════════════
local visible = true

local function togglePanel()
    visible = not visible
    if visible then
        Panel.Visible = true
        Panel.Size = UDim2.new(0, 320, 0, 0)
        tween(Panel, {Size = UDim2.new(0, 320, 0, 480)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        tween(Panel, {Size = UDim2.new(0, 320, 0, 0)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.26, function() Panel.Visible = false end)
    end
end

CloseBtn.MouseButton1Click:Connect(togglePanel)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        togglePanel()
    end
end)

-- ══════════════════════════════════════════
--  入场动画
-- ══════════════════════════════════════════
Panel.Size = UDim2.new(0, 320, 0, 0)
Panel.Visible = true
task.defer(function()
    tween(Panel, {Size = UDim2.new(0, 320, 0, 480)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)
