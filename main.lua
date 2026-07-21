local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Themes = {
    dark = {main = Color3.fromRGB(20,20,25), secondary = Color3.fromRGB(30,30,38), accent = Color3.fromRGB(88,101,242), text = Color3.fromRGB(255,255,255), glass = 0.55, glassSecondary = 0.65},
    light = {main = Color3.fromRGB(230,235,245), secondary = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(0,122,255), text = Color3.fromRGB(15,15,20), glass = 0.35, glassSecondary = 0.25},
    purple = {main = Color3.fromRGB(25,15,40), secondary = Color3.fromRGB(45,25,65), accent = Color3.fromRGB(147,51,234), text = Color3.fromRGB(255,255,255), glass = 0.55, glassSecondary = 0.65},
    midnight = {main = Color3.fromRGB(10,18,35), secondary = Color3.fromRGB(20,32,55), accent = Color3.fromRGB(34,211,238), text = Color3.fromRGB(255,255,255), glass = 0.55, glassSecondary = 0.65}
}
local T = Themes.dark

local allFrames, allLabels, allTabBtns = {}, {}, {}

local ESP = {
    enabled = false,
    boxes = false,
    tracers = false,
    chams = false,
    glow = false,
    nametags = false,
    fillColor = Color3.fromRGB(255,100,100),
    outlineColor = Color3.fromRGB(255,255,255),
    fillTransparency = 0.5,
    outlineTransparency = 0,
    chamsColor = Color3.fromRGB(0,200,255),
    glowColor = Color3.fromRGB(255,100,100),
    boxColor = Color3.fromRGB(255,0,0),
    tracerColor = Color3.fromRGB(255,255,0),
    drawings = {}
}

local Configs = {
    default = {speed = 16, jumpPower = 50, gravity = 196, noclip = false, fly = false, infJump = false, espEnabled = false, fullbright = false, antiAfk = false}
}
local currentConfig = "default"

local Aviadons = Instance.new("ScreenGui")
Aviadons.Name = "Aviadons"
Aviadons.Parent = game:GetService("CoreGui")
Aviadons.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "main"
Main.Parent = Aviadons
Main.BackgroundColor3 = T.main
Main.BackgroundTransparency = T.glass
Main.Position = UDim2.new(0.28, 0, 0.18, 0)
Main.Size = UDim2.new(0, 700, 0, 500)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(255,255,255)
MainStroke.Transparency = 0.72

local Blur2 = Instance.new("Frame", Main)
Blur2.BackgroundColor3 = T.main
Blur2.BackgroundTransparency = 0.92
Blur2.Size = UDim2.new(1,0,1,0)
Blur2.BorderSizePixel = 0
Blur2.ZIndex = 0
Instance.new("UICorner", Blur2).CornerRadius = UDim.new(0, 16)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1,0,0,46)
TopBar.BackgroundColor3 = T.secondary
TopBar.BackgroundTransparency = T.glassSecondary
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 2
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)

local TopFix = Instance.new("Frame", TopBar)
TopFix.Size = UDim2.new(1,0,0,16)
TopFix.Position = UDim2.new(0,0,1,-16)
TopFix.BackgroundColor3 = T.secondary
TopFix.BackgroundTransparency = T.glassSecondary
TopFix.BorderSizePixel = 0

local TopStroke = Instance.new("UIStroke", TopBar)
TopStroke.Thickness = 1
TopStroke.Color = Color3.fromRGB(255,255,255)
TopStroke.Transparency = 0.8

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0,200,1,0)
Title.Position = UDim2.new(0,16,0,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "aviadons"
Title.TextColor3 = T.text
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.ZIndex = 3

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0,28,0,28)
CloseBtn.Position = UDim2.new(1,-38,0.5,-14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,53,69)
CloseBtn.BackgroundTransparency = 0.25
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.ZIndex = 3
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,155,1,-60)
Sidebar.Position = UDim2.new(0,10,0,52)
Sidebar.BackgroundColor3 = T.secondary
Sidebar.BackgroundTransparency = T.glassSecondary
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
local SideStroke = Instance.new("UIStroke", Sidebar)
SideStroke.Thickness = 1
SideStroke.Color = Color3.fromRGB(255,255,255)
SideStroke.Transparency = 0.8

local SideScroll = Instance.new("ScrollingFrame", Sidebar)
SideScroll.Size = UDim2.new(1,0,1,-10)
SideScroll.Position = UDim2.new(0,0,0,8)
SideScroll.BackgroundTransparency = 1
SideScroll.ScrollBarThickness = 0
SideScroll.CanvasSize = UDim2.new(0,0,3,0)
SideScroll.ZIndex = 2
local SideList = Instance.new("UIListLayout", SideScroll)
SideList.Padding = UDim.new(0, 5)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local SidePad = Instance.new("UIPadding", SideScroll)
SidePad.PaddingLeft = UDim.new(0, 6)
SidePad.PaddingRight = UDim.new(0, 6)

local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0,175,0,52)
Container.Size = UDim2.new(1,-185,1,-62)
Container.BackgroundTransparency = 1
Container.ZIndex = 2

local Pages = Instance.new("Folder", Container)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)

local function UpdateTheme(theme)
    T = theme
    Main.BackgroundColor3 = T.main
    Main.BackgroundTransparency = T.glass
    Blur2.BackgroundColor3 = T.main
    TopBar.BackgroundColor3 = T.secondary
    TopBar.BackgroundTransparency = T.glassSecondary
    TopFix.BackgroundColor3 = T.secondary
    TopFix.BackgroundTransparency = T.glassSecondary
    Sidebar.BackgroundColor3 = T.secondary
    Sidebar.BackgroundTransparency = T.glassSecondary
    Title.TextColor3 = T.text
    for _, f in pairs(allFrames) do
        if f and f.Parent then
            f.BackgroundColor3 = T.secondary
            f.BackgroundTransparency = T.glassSecondary
        end
    end
    for _, l in pairs(allLabels) do
        if l and l.Parent then l.TextColor3 = T.text end
    end
    for _, btn in pairs(allTabBtns) do
        if btn and btn.Parent then btn.TextColor3 = T.text end
    end
end

local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Parent = Pages
    Page.Size = UDim2.new(1,0,1,0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
    Page.CanvasSize = UDim2.new(0,0,8,0)
    Page.BorderSizePixel = 0
    Page.ZIndex = 2
    local pl = Instance.new("UIListLayout", Page)
    pl.Padding = UDim.new(0, 7)
    pl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local pad = Instance.new("UIPadding", Page)
    pad.PaddingTop = UDim.new(0, 4)

    local TabBtn = Instance.new("TextButton", SideScroll)
    TabBtn.Size = UDim2.new(1,0,0,36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    TabBtn.BackgroundTransparency = 0.9
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Text = name
    TabBtn.TextColor3 = T.text
    TabBtn.TextSize = 13
    TabBtn.ZIndex = 3
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    local ts = Instance.new("UIStroke", TabBtn)
    ts.Thickness = 1
    ts.Color = Color3.fromRGB(255,255,255)
    ts.Transparency = 0.85
    table.insert(allTabBtns, TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
        Page.Visible = true
        for _, btn in pairs(SideScroll:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.9}):Play()
            end
        end
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.accent, BackgroundTransparency = 0.25}):Play()
    end)
    return Page
end

local function AddToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,40)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    local fs = Instance.new("UIStroke", Frame)
    fs.Thickness = 1
    fs.Color = Color3.fromRGB(255,255,255)
    fs.Transparency = 0.82
    table.insert(allFrames, Frame)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1,-68,1,0)
    Label.Position = UDim2.new(0,12,0,0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = T.text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 3
    table.insert(allLabels, Label)

    local DelBtn = Instance.new("TextButton", Frame)
    DelBtn.Size = UDim2.new(0,20,0,20)
    DelBtn.Position = UDim2.new(0,-26,0.5,-10)
    DelBtn.BackgroundColor3 = Color3.fromRGB(220,53,69)
    DelBtn.BackgroundTransparency = 0.3
    DelBtn.Text = "×"
    DelBtn.TextColor3 = Color3.fromRGB(255,255,255)
    DelBtn.Font = Enum.Font.GothamBold
    DelBtn.TextSize = 13
    DelBtn.ZIndex = 3
    Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(1, 0)
    DelBtn.MouseButton1Click:Connect(function() Frame:Destroy() end)

    local Switch = Instance.new("Frame", Frame)
    Switch.Size = UDim2.new(0,46,0,26)
    Switch.Position = UDim2.new(1,-54,0.5,-13)
    Switch.BackgroundColor3 = Color3.fromRGB(130,130,140)
    Switch.ZIndex = 3
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    local ss = Instance.new("UIStroke", Switch)
    ss.Thickness = 1
    ss.Color = Color3.fromRGB(255,255,255)
    ss.Transparency = 0.7

    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0,20,0,20)
    Knob.Position = UDim2.new(0,3,0.5,-10)
    Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Knob.ZIndex = 4
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local State = false
    local Btn = Instance.new("TextButton", Switch)
    Btn.Size = UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.ZIndex = 4

    Btn.MouseButton1Click:Connect(function()
        State = not State
        callback(State)
        TweenService:Create(Switch, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundColor3 = State and T.accent or Color3.fromRGB(130,130,140)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Position = State and UDim2.new(0,23,0.5,-10) or UDim2.new(0,3,0.5,-10)}):Play()
    end)
    return {setState = function(s) State = s; callback(s);
        TweenService:Create(Switch, TweenInfo.new(0.22), {BackgroundColor3 = s and T.accent or Color3.fromRGB(130,130,140)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.22), {Position = s and UDim2.new(0,23,0.5,-10) or UDim2.new(0,3,0.5,-10)}):Play()
    end}
end

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,56)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    local fs = Instance.new("UIStroke", Frame)
    fs.Thickness = 1
    fs.Color = Color3.fromRGB(255,255,255)
    fs.Transparency = 0.82
    table.insert(allFrames, Frame)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1,-16,0,22)
    Label.Position = UDim2.new(0,12,0,7)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = T.text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 3
    table.insert(allLabels, Label)

    local SliderBack = Instance.new("Frame", Frame)
    SliderBack.Size = UDim2.new(1,-24,0,8)
    SliderBack.Position = UDim2.new(0,12,1,-18)
    SliderBack.BackgroundColor3 = Color3.fromRGB(100,100,110)
    SliderBack.BackgroundTransparency = 0.5
    SliderBack.ZIndex = 3
    Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame", SliderBack)
    SliderFill.Size = UDim2.new(math.clamp((default-min)/(max-min),0,1),0,1,0)
    SliderFill.BackgroundColor3 = T.accent
    SliderFill.ZIndex = 4
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", SliderBack)
    Knob.Size = UDim2.new(0,16,0,16)
    Knob.AnchorPoint = Vector2.new(0.5,0.5)
    Knob.Position = UDim2.new(math.clamp((default-min)/(max-min),0,1),0,0.5,0)
    Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Knob.ZIndex = 5
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local ds = false
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then ds = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then ds = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if ds and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((UserInputService:GetMouseLocation().X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max-min) * rel)
            SliderFill.Size = UDim2.new(rel,0,1,0)
            Knob.Position = UDim2.new(rel,0,0.5,0)
            Label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    return {setValue = function(v)
        local rel = math.clamp((v-min)/(max-min),0,1)
        SliderFill.Size = UDim2.new(rel,0,1,0)
        Knob.Position = UDim2.new(rel,0,0.5,0)
        Label.Text = text .. ": " .. v
        callback(v)
    end}
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.97,0,0,40)
    Btn.BackgroundColor3 = T.accent
    Btn.BackgroundTransparency = 0.3
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.TextSize = 13
    Btn.Parent = parent
    Btn.ZIndex = 2
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 9)
    local bs = Instance.new("UIStroke", Btn)
    bs.Thickness = 1
    bs.Color = Color3.fromRGB(255,255,255)
    bs.Transparency = 0.78
    Btn.MouseButton1Click:Connect(callback)
end

local function AddLabel(parent, text, isHeader)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0.97,0,0, isHeader and 36 or 32)
    Lbl.BackgroundColor3 = T.secondary
    Lbl.BackgroundTransparency = T.glassSecondary
    Lbl.Font = isHeader and Enum.Font.GothamBold or Enum.Font.Gotham
    Lbl.Text = text
    Lbl.TextColor3 = isHeader and T.accent or T.text
    Lbl.TextSize = isHeader and 15 or 13
    Lbl.Parent = parent
    Lbl.ZIndex = 2
    Instance.new("UICorner", Lbl).CornerRadius = UDim.new(0, 8)
    table.insert(allFrames, Lbl)
    table.insert(allLabels, Lbl)
end

local function AddColorPicker(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,44)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    local fs = Instance.new("UIStroke", Frame)
    fs.Thickness = 1
    fs.Color = Color3.fromRGB(255,255,255)
    fs.Transparency = 0.82
    table.insert(allFrames, Frame)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1,-80,1,0)
    Label.Position = UDim2.new(0,12,0,0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = T.text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 3
    table.insert(allLabels, Label)

    local colors = {
        Color3.fromRGB(255,100,100),
        Color3.fromRGB(100,255,100),
        Color3.fromRGB(100,100,255),
        Color3.fromRGB(255,255,100),
        Color3.fromRGB(255,100,255),
        Color3.fromRGB(100,255,255),
        Color3.fromRGB(255,255,255),
        Color3.fromRGB(255,165,0)
    }

    local colorRow = Instance.new("Frame", Frame)
    colorRow.Size = UDim2.new(0,200,0,28)
    colorRow.Position = UDim2.new(1,-210,0.5,-14)
    colorRow.BackgroundTransparency = 1
    colorRow.ZIndex = 3
    local cl = Instance.new("UIListLayout", colorRow)
    cl.FillDirection = Enum.FillDirection.Horizontal
    cl.Padding = UDim.new(0, 4)

    for _, c in pairs(colors) do
        local Dot = Instance.new("TextButton", colorRow)
        Dot.Size = UDim2.new(0,20,0,20)
        Dot.BackgroundColor3 = c
        Dot.Text = ""
        Dot.ZIndex = 4
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
        Dot.MouseButton1Click:Connect(function() callback(c) end)
    end
end

local function AddCustomToggle(parent)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,76)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    Instance.new("UIStroke", Frame).Thickness = 1
    table.insert(allFrames, Frame)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1,-16,0,22)
    Lbl.Position = UDim2.new(0,12,0,6)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = "add custom toggle:"
    Lbl.TextColor3 = T.text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 3
    table.insert(allLabels, Lbl)

    local Input = Instance.new("TextBox", Frame)
    Input.Size = UDim2.new(0.65,0,0,26)
    Input.Position = UDim2.new(0,10,0,40)
    Input.BackgroundColor3 = Color3.fromRGB(50,50,60)
    Input.BackgroundTransparency = 0.5
    Input.Text = ""
    Input.PlaceholderText = "name..."
    Input.TextColor3 = Color3.fromRGB(255,255,255)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 12
    Input.ZIndex = 3
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

    local AddBtn = Instance.new("TextButton", Frame)
    AddBtn.Size = UDim2.new(0.28,0,0,26)
    AddBtn.Position = UDim2.new(0.7,0,0,40)
    AddBtn.BackgroundColor3 = T.accent
    AddBtn.BackgroundTransparency = 0.3
    AddBtn.Text = "add"
    AddBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AddBtn.Font = Enum.Font.GothamBold
    AddBtn.TextSize = 12
    AddBtn.ZIndex = 3
    Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)
    AddBtn.MouseButton1Click:Connect(function()
        if Input.Text ~= "" then
            AddToggle(parent, Input.Text, function(v) print(Input.Text, v) end)
            Input.Text = ""
        end
    end)
end

local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character

            local hl = char:FindFirstChild("AviadonsHL")
            if ESP.enabled then
                if not hl then
                    hl = Instance.new("Highlight", char)
                    hl.Name = "AviadonsHL"
                end
                hl.FillColor = ESP.fillColor
                hl.OutlineColor = ESP.outlineColor
                hl.FillTransparency = ESP.fillTransparency
                hl.OutlineTransparency = ESP.outlineTransparency
            else
                if hl then hl:Destroy() end
            end

            local chams = char:FindFirstChild("AviadonsChams")
            if ESP.chams then
                if not chams then
                    chams = Instance.new("Highlight", char)
                    chams.Name = "AviadonsChams"
                    chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                chams.FillColor = ESP.chamsColor
                chams.OutlineColor = ESP.chamsColor
                chams.FillTransparency = 0.3
                chams.OutlineTransparency = 0.5
            else
                if chams then chams:Destroy() end
            end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local nt = hrp:FindFirstChild("AviadonsNameTag")
                if ESP.nametags then
                    if not nt then
                        local bg = Instance.new("BillboardGui", hrp)
                        bg.Name = "AviadonsNameTag"
                        bg.Size = UDim2.new(0,120,0,35)
                        bg.StudsOffset = Vector3.new(0,3.5,0)
                        bg.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel", bg)
                        lbl.Size = UDim2.new(1,0,1,0)
                        lbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
                        lbl.BackgroundTransparency = 0.5
                        lbl.Text = plr.DisplayName
                        lbl.TextColor3 = Color3.fromRGB(255,255,255)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 13
                        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
                    end
                else
                    if hrp:FindFirstChild("AviadonsNameTag") then hrp.AviadonsNameTag:Destroy() end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if ESP.tracers or ESP.boxes then
        for _, d in pairs(ESP.drawings) do
            if d and d.Remove then d:Remove() end
        end
        ESP.drawings = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        if ESP.tracers then
                            local line = Drawing.new("Line")
                            line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                            line.To = Vector2.new(pos.X, pos.Y)
                            line.Color = ESP.tracerColor
                            line.Thickness = 1.5
                            line.Transparency = 1
                            line.Visible = true
                            table.insert(ESP.drawings, line)
                        end
                        if ESP.boxes then
                            local topPos = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3.5, 0))
                            local botPos = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position + Vector3.new(0, -3.5, 0))
                            local height = math.abs(topPos.Y - botPos.Y)
                            local width = height * 0.5
                            local box = Drawing.new("Square")
                            box.Position = Vector2.new(pos.X - width/2, topPos.Y)
                            box.Size = Vector2.new(width, height)
                            box.Color = ESP.boxColor
                            box.Thickness = 1.5
                            box.Filled = false
                            box.Transparency = 1
                            box.Visible = true
                            table.insert(ESP.drawings, box)
                        end
                    end
                end
            end
        end
    end
end)

local MainTab = CreateTab("movement")
local FarmTab = CreateTab("autofarm")
local TpTab = CreateTab("teleport")
local ESPTab = CreateTab("esp")
local VisualTab = CreateTab("visual")
local WorldTab = CreateTab("world")
local ConfigTab = CreateTab("configs")
local SettingsTab = CreateTab("settings")
local CustomTab = CreateTab("custom")
local CreditsTab = CreateTab("credits")

local speedSlider = AddSlider(MainTab, "speed", 16, 500, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

local jumpSlider = AddSlider(MainTab, "jump power", 50, 500, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

local infJumpToggle = AddToggle(MainTab, "infinite jump", function(v)
    _G.InfJump = v
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump and LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

local noclipToggle = AddToggle(MainTab, "noclip", function(v)
    _G.NoClip = v
    RunService.Stepped:Connect(function()
        if _G.NoClip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

AddToggle(MainTab, "fly (e = up, q = down)", function(v)
    _G.Fly = v
    if v then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local BV = Instance.new("BodyVelocity", hrp)
            BV.Name = "FlyBV"
            BV.MaxForce = Vector3.new(1e9,1e9,1e9)
            BV.Velocity = Vector3.new(0,0,0)
            RunService.RenderStepped:Connect(function()
                if _G.Fly and BV and BV.Parent then
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then BV.Velocity = Vector3.new(0,50,0)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then BV.Velocity = Vector3.new(0,-50,0)
                    else BV.Velocity = Vector3.new(0,0,0) end
                end
            end)
        end
    else
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
    end
end)

AddToggle(MainTab, "spin bot", function(v)
    _G.Spin = v
    RunService.Heartbeat:Connect(function()
        if _G.Spin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end)
end)

AddToggle(MainTab, "invisible", function(v)
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = v and 1 or 0
            end
        end
    end
end)

AddToggle(MainTab, "god mode", function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = v and math.huge or 100
        LocalPlayer.Character.Humanoid.Health = v and math.huge or 100
    end
end)

AddToggle(MainTab, "anti-afk", function(v)
    if v then
        local VU = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
        end)
    end
end)

AddToggle(MainTab, "rainbow character", function(v)
    _G.Rainbow = v
    RunService.Heartbeat:Connect(function()
        if _G.Rainbow and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                end
            end
        end
    end)
end)

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local coinsFolder = Workspace:FindFirstChild("coins")
local collectReq = ReplicatedStorage:FindFirstChild("CollectCoinRequest")
local running = false
local collectionRadius = 50

local function getCoinPositions()
    if not coinsFolder then return {} end
    local positions = {}
    for _, coin in ipairs(coinsFolder:GetChildren()) do
        if coin:IsA("Model") and not coin:GetAttribute("Collected") then
            local primaryPart = coin.PrimaryPart or coin:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                table.insert(positions, {coin = coin, position = primaryPart.Position})
            end
        end
    end
    return positions
end

local function processCoins()
    if not character or not humanoidRootPart then
        character = LocalPlayer.Character
        if character then humanoidRootPart = character:FindFirstChild("HumanoidRootPart") end
        return
    end
    local closest, closestDist = nil, collectionRadius
    for _, data in ipairs(getCoinPositions()) do
        local dist = (data.position - humanoidRootPart.Position).Magnitude
        if dist < closestDist then closestDist = dist; closest = data end
    end
    if closest then
        if closestDist > 8 then
            local dir = (closest.position - humanoidRootPart.Position).Unit
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + dir * 16)
        elseif collectReq then
            collectReq:FireServer(closest.coin)
        end
    end
    for _, data in ipairs(getCoinPositions()) do
        if (data.position - humanoidRootPart.Position).Magnitude < 8 and collectReq then
            collectReq:FireServer(data.coin)
        end
    end
end

AddToggle(FarmTab, "auto coin farm", function(v)
    running = v
    if running then
        task.spawn(function()
            while running do processCoins(); task.wait(0.05) end
        end)
    end
end)

AddSlider(FarmTab, "collection radius", 10, 200, 50, function(v)
    collectionRadius = v
end)

AddToggle(FarmTab, "auto collect nearby tools", function(v)
    _G.AutoTool = v
    task.spawn(function()
        while _G.AutoTool do
            for _, item in pairs(Workspace:GetChildren()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    LocalPlayer.Character:MoveTo(item.Handle.Position)
                    task.wait(0.3)
                end
            end
            task.wait(1)
        end
    end)
end)

AddButton(TpTab, "tp all players to me", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

AddButton(TpTab, "tp to random player", function()
    local plrs = Players:GetPlayers()
    if #plrs < 2 then return end
    local target
    repeat target = plrs[math.random(1, #plrs)] until target ~= LocalPlayer
    if target.Character then LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position) end
end)

AddButton(TpTab, "tp to spawn", function()
    LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
end)

AddButton(TpTab, "save position", function()
    _G.SavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
end)

AddButton(TpTab, "load position", function()
    if _G.SavedPos then LocalPlayer.Character.HumanoidRootPart.CFrame = _G.SavedPos end
end)

AddToggle(TpTab, "click tp (ctrl + click)", function(v)
    if v then
        local mouse = LocalPlayer:GetMouse()
        mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                LocalPlayer.Character:MoveTo(mouse.Hit.p)
            end
        end)
    end
end)

AddButton(TpTab, "tp to highest point", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = CFrame.new(hrp.Position.X, 500, hrp.Position.Z)
    end
end)

AddLabel(ESPTab, "esp highlight", true)

AddToggle(ESPTab, "esp highlight", function(v)
    ESP.enabled = v
    UpdateESP()
end)

AddColorPicker(ESPTab, "fill color", ESP.fillColor, function(c)
    ESP.fillColor = c
    UpdateESP()
end)

AddColorPicker(ESPTab, "outline color", ESP.outlineColor, function(c)
    ESP.outlineColor = c
    UpdateESP()
end)

AddSlider(ESPTab, "fill transparency", 0, 10, 5, function(v)
    ESP.fillTransparency = v / 10
    UpdateESP()
end)

AddSlider(ESPTab, "outline transparency", 0, 10, 0, function(v)
    ESP.outlineTransparency = v / 10
    UpdateESP()
end)

AddLabel(ESPTab, "chams", true)

AddToggle(ESPTab, "chams (always on top)", function(v)
    ESP.chams = v
    UpdateESP()
end)

AddColorPicker(ESPTab, "chams color", ESP.chamsColor, function(c)
    ESP.chamsColor = c
    UpdateESP()
end)

AddLabel(ESPTab, "tracers & boxes", true)

AddToggle(ESPTab, "tracers", function(v)
    ESP.tracers = v
    if not v then
        for _, d in pairs(ESP.drawings) do if d and d.Remove then d:Remove() end end
        ESP.drawings = {}
    end
end)

AddColorPicker(ESPTab, "tracer color", ESP.tracerColor, function(c)
    ESP.tracerColor = c
end)

AddToggle(ESPTab, "esp boxes", function(v)
    ESP.boxes = v
    if not v then
        for _, d in pairs(ESP.drawings) do if d and d.Remove then d:Remove() end end
        ESP.drawings = {}
    end
end)

AddColorPicker(ESPTab, "box color", ESP.boxColor, function(c)
    ESP.boxColor = c
end)

AddLabel(ESPTab, "name tags", true)

AddToggle(ESPTab, "name tags", function(v)
    ESP.nametags = v
    UpdateESP()
end)

AddToggle(VisualTab, "fullbright", function(v)
    Lighting.Brightness = v and 3 or 1
    Lighting.ClockTime = v and 14 or 12
    Lighting.GlobalShadows = not v
end)

AddToggle(VisualTab, "remove fog", function(v)
    Lighting.FogEnd = v and 1e10 or 100000
end)

AddToggle(VisualTab, "x-ray", function(v)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
            obj.Transparency = v and 0.75 or 0
        end
    end
end)

AddToggle(VisualTab, "remove textures", function(v)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = v and 1 or 0 end
    end
end)

local gravSlider = AddSlider(WorldTab, "gravity", 0, 196, 196, function(v)
    Workspace.Gravity = v
end)

AddSlider(WorldTab, "time of day", 0, 24, 14, function(v)
    Lighting.ClockTime = v
end)

AddToggle(WorldTab, "day lock", function(v)
    _G.DayLock = v
    task.spawn(function()
        while _G.DayLock do Lighting.ClockTime = 14; task.wait(0.1) end
    end)
end)

AddToggle(WorldTab, "night lock", function(v)
    _G.NightLock = v
    task.spawn(function()
        while _G.NightLock do Lighting.ClockTime = 0; task.wait(0.1) end
    end)
end)

AddToggle(WorldTab, "anti-lag", function(v)
    if v then
        settings().Rendering.QualityLevel = 1
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = false
            end
        end
    end
end)

AddLabel(ConfigTab, "configs", true)

local function SaveConfig(name)
    Configs[name] = {
        espEnabled = ESP.enabled,
        espChams = ESP.chams,
        espTracers = ESP.tracers,
        espBoxes = ESP.boxes,
        espNametags = ESP.nametags,
        fillColor = {ESP.fillColor.R, ESP.fillColor.G, ESP.fillColor.B},
        outlineColor = {ESP.outlineColor.R, ESP.outlineColor.G, ESP.outlineColor.B},
        chamsColor = {ESP.chamsColor.R, ESP.chamsColor.G, ESP.chamsColor.B},
        tracerColor = {ESP.tracerColor.R, ESP.tracerColor.G, ESP.tracerColor.B},
        boxColor = {ESP.boxColor.R, ESP.boxColor.G, ESP.boxColor.B},
        collectionRadius = collectionRadius,
        gravity = Workspace.Gravity
    }
end

local function LoadConfig(name)
    if not Configs[name] then return end
    local cfg = Configs[name]
    if cfg.fillColor then ESP.fillColor = Color3.new(cfg.fillColor[1], cfg.fillColor[2], cfg.fillColor[3]) end
    if cfg.outlineColor then ESP.outlineColor = Color3.new(cfg.outlineColor[1], cfg.outlineColor[2], cfg.outlineColor[3]) end
    if cfg.chamsColor then ESP.chamsColor = Color3.new(cfg.chamsColor[1], cfg.chamsColor[2], cfg.chamsColor[3]) end
    if cfg.tracerColor then ESP.tracerColor = Color3.new(cfg.tracerColor[1], cfg.tracerColor[2], cfg.tracerColor[3]) end
    if cfg.boxColor then ESP.boxColor = Color3.new(cfg.boxColor[1], cfg.boxColor[2], cfg.boxColor[3]) end
    if cfg.collectionRadius then collectionRadius = cfg.collectionRadius end
    if cfg.gravity then Workspace.Gravity = cfg.gravity end
    UpdateESP()
end

local configInput = Instance.new("Frame")
configInput.Size = UDim2.new(0.97,0,0,76)
configInput.BackgroundColor3 = T.secondary
configInput.BackgroundTransparency = T.glassSecondary
configInput.Parent = ConfigTab
configInput.ZIndex = 2
Instance.new("UICorner", configInput).CornerRadius = UDim.new(0, 9)
Instance.new("UIStroke", configInput).Thickness = 1
table.insert(allFrames, configInput)

local cfgNameLbl = Instance.new("TextLabel", configInput)
cfgNameLbl.Size = UDim2.new(1,-16,0,22)
cfgNameLbl.Position = UDim2.new(0,12,0,6)
cfgNameLbl.BackgroundTransparency = 1
cfgNameLbl.Text = "config name:"
cfgNameLbl.TextColor3 = T.text
cfgNameLbl.Font = Enum.Font.Gotham
cfgNameLbl.TextSize = 12
cfgNameLbl.TextXAlignment = Enum.TextXAlignment.Left
cfgNameLbl.ZIndex = 3
table.insert(allLabels, cfgNameLbl)

local cfgInput = Instance.new("TextBox", configInput)
cfgInput.Size = UDim2.new(0.6,0,0,26)
cfgInput.Position = UDim2.new(0,10,0,40)
cfgInput.BackgroundColor3 = Color3.fromRGB(50,50,60)
cfgInput.BackgroundTransparency = 0.5
cfgInput.Text = ""
cfgInput.PlaceholderText = "config name..."
cfgInput.TextColor3 = Color3.fromRGB(255,255,255)
cfgInput.Font = Enum.Font.Gotham
cfgInput.TextSize = 12
cfgInput.ZIndex = 3
Instance.new("UICorner", cfgInput).CornerRadius = UDim.new(0, 6)

local saveBtn = Instance.new("TextButton", configInput)
saveBtn.Size = UDim2.new(0.17,0,0,26)
saveBtn.Position = UDim2.new(0.65,0,0,40)
saveBtn.BackgroundColor3 = T.accent
saveBtn.BackgroundTransparency = 0.3
saveBtn.Text = "save"
saveBtn.TextColor3 = Color3.fromRGB(255,255,255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 11
saveBtn.ZIndex = 3
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)
saveBtn.MouseButton1Click:Connect(function()
    if cfgInput.Text ~= "" then SaveConfig(cfgInput.Text) end
end)

local loadBtn = Instance.new("TextButton", configInput)
loadBtn.Size = UDim2.new(0.17,0,0,26)
loadBtn.Position = UDim2.new(0.83,0,0,40)
loadBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
loadBtn.BackgroundTransparency = 0.3
loadBtn.Text = "load"
loadBtn.TextColor3 = Color3.fromRGB(255,255,255)
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 11
loadBtn.ZIndex = 3
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)
loadBtn.MouseButton1Click:Connect(function()
    if cfgInput.Text ~= "" then LoadConfig(cfgInput.Text) end
end)

AddButton(ConfigTab, "reset config", function()
    Workspace.Gravity = 196
    ESP.enabled = false; ESP.chams = false; ESP.tracers = false; ESP.boxes = false; ESP.nametags = false
    UpdateESP()
end)

AddButton(SettingsTab, "dark theme", function() UpdateTheme(Themes.dark) end)
AddButton(SettingsTab, "light theme", function() UpdateTheme(Themes.light) end)
AddButton(SettingsTab, "purple theme", function() UpdateTheme(Themes.purple) end)
AddButton(SettingsTab, "midnight theme", function() UpdateTheme(Themes.midnight) end)

AddButton(SettingsTab, "rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

AddButton(SettingsTab, "reset character", function()
    LocalPlayer.Character:BreakJoints()
end)

AddButton(SettingsTab, "copy game id", function()
    if setclipboard then setclipboard(tostring(game.PlaceId)) end
end)

AddCustomToggle(CustomTab)

AddLabel(CreditsTab, "special thanks", true)
AddLabel(CreditsTab, "raknetskid")
AddLabel(CreditsTab, "solinexx")
AddLabel(CreditsTab, "ab1s")
AddLabel(CreditsTab, "chasova")
AddLabel(CreditsTab, "kvaz1mota")
AddLabel(CreditsTab, "izkor")
AddLabel(CreditsTab, "azure143")
AddLabel(CreditsTab, "mike.jpg")
AddLabel(CreditsTab, "kjja")
AddLabel(CreditsTab, "swan")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

Pages.movement.Visible = true
