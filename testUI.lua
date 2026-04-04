-- UI
print("脚本开始执行...")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- 创建GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleRageBotUI"
ScreenGui.ResetOnSpawn = false

-- 启动按钮
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 100, 0, 100)
OpenButton.Position = UDim2.new(0.5, -50, 0.5, -50)
OpenButton.AnchorPoint = Vector2.new(0.5, 0.5)
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
OpenButton.Text = "🎯\n点击打开"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 20
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextWrapped = true
OpenButton.Visible = true
OpenButton.Parent = ScreenGui

-- 圆角
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.2, 0)
Corner.Parent = OpenButton

-- 控制面板
local MainFrame = Instance.new("Frame")
MainFrame.Name = "ControlPanel"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- 按钮事件
OpenButton.MouseButton1Click:Connect(function()
    OpenButton.Visible = false
    MainFrame.Visible = true
    print("打开控制面板")
end)

-- 插入GUI
if syn and syn.protect_gui then
    print("使用syn.protect_gui")
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    print("使用gethui")
    ScreenGui.Parent = gethui()
else
    print("使用CoreGui")
    ScreenGui.Parent = CoreGui
end

print("✅ UI创建完成！应该能看到红色按钮")
print("点击按钮应该能打开灰色面板")

-- 测试功能
spawn(function()
    wait(2)
    if OpenButton and OpenButton.Parent then
        print("✅ UI存在且正常")
    else
        print("❌ UI已丢失")
    end
end)