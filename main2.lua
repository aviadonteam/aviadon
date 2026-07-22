local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- СТЕЙТ ВСЕГО ЧТО ЕСТЬ
local State = {
    speed = 16, jumpPower = 50, gravity = 196,
    noclip = false, fly = false, infJump = false,
    spinBot = false, invisible = false, godMode = false,
    rainbow = false, antiAfk = false,
    farmRunning = false, collectionRadius = 50,
    autoTool = false,
    espEnabled = false, espChams = false, espTracers = false,
    espBoxes = false, espNametags = false, espHealthBars = false,
    espDistance = false,
    espFillColor = Color3.fromRGB(255,100,100),
    espOutlineColor = Color3.fromRGB(255,255,255),
    espChamsColor = Color3.fromRGB(0,200,255),
    espTracerColor = Color3.fromRGB(255,255,0),
    espBoxColor = Color3.fromRGB(255,0,0),
    espFillTransp = 0.5,
    espOutlineTransp = 0,
    fullbright = false, noFog = false, xray = false,
    noTextures = false, antiLag = false,
    dayLock = false, nightLock = false,
    timeOfDay = 14, gravityVal = 196,
    clickTp = false
}

local Themes = {
    dark = {name="dark", main=Color3.fromRGB(20,20,25), secondary=Color3.fromRGB(30,30,38), accent=Color3.fromRGB(88,101,242), text=Color3.fromRGB(255,255,255), glass=0.55, glassSecondary=0.65},
    light = {name="light", main=Color3.fromRGB(230,235,245), secondary=Color3.fromRGB(255,255,255), accent=Color3.fromRGB(0,122,255), text=Color3.fromRGB(15,15,20), glass=0.35, glassSecondary=0.25},
    purple = {name="purple", main=Color3.fromRGB(25,15,40), secondary=Color3.fromRGB(45,25,65), accent=Color3.fromRGB(147,51,234), text=Color3.fromRGB(255,255,255), glass=0.55, glassSecondary=0.65},
    midnight = {name="midnight", main=Color3.fromRGB(10,18,35), secondary=Color3.fromRGB(20,32,55), accent=Color3.fromRGB(34,211,238), text=Color3.fromRGB(255,255,255), glass=0.55, glassSecondary=0.65},
    rose = {name="rose", main=Color3.fromRGB(35,15,20), secondary=Color3.fromRGB(55,25,35), accent=Color3.fromRGB(255,80,120), text=Color3.fromRGB(255,255,255), glass=0.55, glassSecondary=0.65},
    forest = {name="forest", main=Color3.fromRGB(15,30,20), secondary=Color3.fromRGB(25,45,30), accent=Color3.fromRGB(50,200,80), text=Color3.fromRGB(255,255,255), glass=0.55, glassSecondary=0.65},
    sunset = {name="sunset", main=Color3.fromRGB(35,20,10), secondary=Color3.fromRGB(55,32,15), accent=Color3.fromRGB(255,140,0), text=Color3.fromRGB(255,255,255), glass=0.55, glassSecondary=0.65},
    ice = {name="ice", main=Color3.fromRGB(15,25,40), secondary=Color3.fromRGB(25,40,60), accent=Color3.fromRGB(135,206,250), text=Color3.fromRGB(255,255,255), glass=0.45, glassSecondary=0.55},
}

local customThemes = {}
local T = Themes.dark
local allFrames, allLabels, allTabBtns, allAccentElements = {}, {}, {}, {}

local ESP_drawings = {}

local Configs = {}

-- СОХРАНЕНИЕ КОНФИГА В ФАЙЛ (ЧЕРЕЗ WRITEFILE)
local function SerializeColor(c)
    return {r = math.floor(c.R*255), g = math.floor(c.G*255), b = math.floor(c.B*255)}
end
local function DeserializeColor(t)
    return Color3.fromRGB(t.r, t.g, t.b)
end

local function SaveConfigToFile(name)
    local cfg = {
        speed = State.speed,
        jumpPower = State.jumpPower,
        gravity = State.gravity,
        noclip = State.noclip,
        infJump = State.infJump,
        godMode = State.godMode,
        espEnabled = State.espEnabled,
        espChams = State.espChams,
        espTracers = State.espTracers,
        espBoxes = State.espBoxes,
        espNametags = State.espNametags,
        espHealthBars = State.espHealthBars,
        espFillColor = SerializeColor(State.espFillColor),
        espOutlineColor = SerializeColor(State.espOutlineColor),
        espChamsColor = SerializeColor(State.espChamsColor),
        espTracerColor = SerializeColor(State.espTracerColor),
        espBoxColor = SerializeColor(State.espBoxColor),
        espFillTransp = State.espFillTransp,
        espOutlineTransp = State.espOutlineTransp,
        fullbright = State.fullbright,
        noFog = State.noFog,
        collectionRadius = State.collectionRadius,
        gravityVal = State.gravityVal,
        timeOfDay = State.timeOfDay,
        themeName = T.name or "dark"
    }
    Configs[name] = cfg
    local ok, err = pcall(function()
        writefile("aviadons_cfg_"..name..".json", HttpService:JSONEncode(cfg))
    end)
    return ok
end

local function LoadConfigFromFile(name)
    local cfg = Configs[name]
    if not cfg then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile("aviadons_cfg_"..name..".json"))
        end)
        if ok and data then cfg = data else return false end
    end

    State.speed = cfg.speed or 16
    State.jumpPower = cfg.jumpPower or 50
    State.gravity = cfg.gravity or 196
    State.collectionRadius = cfg.collectionRadius or 50
    State.gravityVal = cfg.gravityVal or 196
    State.timeOfDay = cfg.timeOfDay or 14
    State.espFillTransp = cfg.espFillTransp or 0.5
    State.espOutlineTransp = cfg.espOutlineTransp or 0

    if cfg.espFillColor then State.espFillColor = DeserializeColor(cfg.espFillColor) end
    if cfg.espOutlineColor then State.espOutlineColor = DeserializeColor(cfg.espOutlineColor) end
    if cfg.espChamsColor then State.espChamsColor = DeserializeColor(cfg.espChamsColor) end
    if cfg.espTracerColor then State.espTracerColor = DeserializeColor(cfg.espTracerColor) end
    if cfg.espBoxColor then State.espBoxColor = DeserializeColor(cfg.espBoxColor) end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = State.speed
        LocalPlayer.Character.Humanoid.JumpPower = State.jumpPower
    end
    Workspace.Gravity = State.gravityVal
    Lighting.ClockTime = State.timeOfDay

    if cfg.themeName and Themes[cfg.themeName] then
        T = Themes[cfg.themeName]
    end

    return true
end

local function SaveThemeToFile(name, theme)
    local data = {
        name = name,
        main = SerializeColor(theme.main),
        secondary = SerializeColor(theme.secondary),
        accent = SerializeColor(theme.accent),
        text = SerializeColor(theme.text),
        glass = theme.glass,
        glassSecondary = theme.glassSecondary
    }
    local ok, err = pcall(function()
        writefile("aviadons_theme_"..name..".json", HttpService:JSONEncode(data))
    end)
    return ok
end

local function LoadThemeFromFile(name)
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile("aviadons_theme_"..name..".json"))
    end)
    if ok and data then
        return {
            name = name,
            main = DeserializeColor(data.main),
            secondary = DeserializeColor(data.secondary),
            accent = DeserializeColor(data.accent),
            text = DeserializeColor(data.text),
            glass = data.glass or 0.55,
            glassSecondary = data.glassSecondary or 0.65
        }
    end
    return nil
end

-- GUI СОЗДАНИЕ
local Aviadons = Instance.new("ScreenGui")
Aviadons.Name = "Aviadons"
Aviadons.Parent = game:GetService("CoreGui")
Aviadons.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "main"
Main.Parent = Aviadons
Main.BackgroundColor3 = T.main
Main.BackgroundTransparency = T.glass
Main.Position = UDim2.new(0.28, 0, 0.15, 0)
Main.Size = UDim2.new(0, 720, 0, 520)
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

local HotkeyLabel = Instance.new("TextLabel", TopBar)
HotkeyLabel.Size = UDim2.new(0,200,1,0)
HotkeyLabel.Position = UDim2.new(0.5,-100,0,0)
HotkeyLabel.Font = Enum.Font.Gotham
HotkeyLabel.Text = "RCtrl to toggle"
HotkeyLabel.TextColor3 = Color3.fromRGB(150,150,160)
HotkeyLabel.TextSize = 12
HotkeyLabel.BackgroundTransparency = 1
HotkeyLabel.ZIndex = 3

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

-- ПЕРЕТАСКИВАНИЕ
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

-- ОБНОВЛЕНИЕ ТЕМЫ
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
    HotkeyLabel.TextColor3 = Color3.fromRGB(150,150,160)
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
    for _, el in pairs(allAccentElements) do
        if el and el.Parent then el.BackgroundColor3 = T.accent end
    end
end

-- СОЗДАНИЕ ВКЛАДОК
local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Parent = Pages
    Page.Size = UDim2.new(1,0,1,0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
    Page.CanvasSize = UDim2.new(0,0,10,0)
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

-- БАЗОВЫЕ КОМПОНЕНТЫ
local toggleRefs = {}

local function AddToggle(parent, text, initState, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,40)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    local fs = Instance.new("UIStroke", Frame)
    fs.Thickness = 1; fs.Color = Color3.fromRGB(255,255,255); fs.Transparency = 0.82
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
    DelBtn.Text = "×"; DelBtn.TextColor3 = Color3.fromRGB(255,255,255)
    DelBtn.Font = Enum.Font.GothamBold; DelBtn.TextSize = 13; DelBtn.ZIndex = 3
    Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(1, 0)
    DelBtn.MouseButton1Click:Connect(function() Frame:Destroy() end)

    local Switch = Instance.new("Frame", Frame)
    Switch.Size = UDim2.new(0,46,0,26)
    Switch.Position = UDim2.new(1,-54,0.5,-13)
    Switch.BackgroundColor3 = Color3.fromRGB(130,130,140)
    Switch.ZIndex = 3
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    local ss = Instance.new("UIStroke", Switch)
    ss.Thickness = 1; ss.Color = Color3.fromRGB(255,255,255); ss.Transparency = 0.7

    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0,20,0,20)
    Knob.Position = UDim2.new(0,3,0.5,-10)
    Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Knob.ZIndex = 4
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local CurState = initState or false
    local Btn = Instance.new("TextButton", Switch)
    Btn.Size = UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""; Btn.ZIndex = 4

    local function ApplyState(s)
        CurState = s
        TweenService:Create(Switch, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundColor3 = s and T.accent or Color3.fromRGB(130,130,140)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Position = s and UDim2.new(0,23,0.5,-10) or UDim2.new(0,3,0.5,-10)}):Play()
    end

    if initState then ApplyState(true) end

    Btn.MouseButton1Click:Connect(function()
        ApplyState(not CurState)
        callback(CurState)
    end)

    local ref = {setState = function(s) ApplyState(s); callback(s) end, getState = function() return CurState end}
    table.insert(toggleRefs, {text = text, ref = ref})
    return ref
end

local sliderRefs = {}

local function AddSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,56)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    local fs = Instance.new("UIStroke", Frame)
    fs.Thickness = 1; fs.Color = Color3.fromRGB(255,255,255); fs.Transparency = 0.82
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
    local initRel = math.clamp((default-min)/(max-min),0,1)
    SliderFill.Size = UDim2.new(initRel,0,1,0)
    SliderFill.BackgroundColor3 = T.accent
    SliderFill.ZIndex = 4
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", SliderBack)
    Knob.Size = UDim2.new(0,16,0,16)
    Knob.AnchorPoint = Vector2.new(0.5,0.5)
    Knob.Position = UDim2.new(initRel,0,0.5,0)
    Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Knob.ZIndex = 5
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local ds = false
    local curVal = default
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then ds = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then ds = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if ds and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((UserInputService:GetMouseLocation().X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            curVal = math.floor(min + (max-min) * rel)
            SliderFill.Size = UDim2.new(rel,0,1,0)
            Knob.Position = UDim2.new(rel,0,0.5,0)
            Label.Text = text .. ": " .. curVal
            callback(curVal)
        end
    end)

    local ref = {
        setValue = function(v)
            local rel = math.clamp((v-min)/(max-min),0,1)
            curVal = v
            SliderFill.Size = UDim2.new(rel,0,1,0)
            Knob.Position = UDim2.new(rel,0,0.5,0)
            Label.Text = text .. ": " .. v
            callback(v)
        end,
        getValue = function() return curVal end
    }
    table.insert(sliderRefs, {text = text, ref = ref})
    return ref
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
    bs.Thickness = 1; bs.Color = Color3.fromRGB(255,255,255); bs.Transparency = 0.78
    table.insert(allAccentElements, Btn)
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
        callback()
    end)
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

local function AddColorPicker(parent, text, getColor, setColor)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,50)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    local fs = Instance.new("UIStroke", Frame)
    fs.Thickness = 1; fs.Color = Color3.fromRGB(255,255,255); fs.Transparency = 0.82
    table.insert(allFrames, Frame)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.45,0,0,22)
    Label.Position = UDim2.new(0,12,0,7)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = T.text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 3
    table.insert(allLabels, Label)

    local Preview = Instance.new("Frame", Frame)
    Preview.Size = UDim2.new(0,22,0,22)
    Preview.Position = UDim2.new(0,12,1,-28)
    Preview.BackgroundColor3 = getColor()
    Preview.ZIndex = 4
    Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 4)

    local colors = {
        Color3.fromRGB(255,80,80), Color3.fromRGB(255,150,80),
        Color3.fromRGB(255,255,80), Color3.fromRGB(80,255,80),
        Color3.fromRGB(80,255,255), Color3.fromRGB(80,80,255),
        Color3.fromRGB(255,80,255), Color3.fromRGB(255,255,255),
        Color3.fromRGB(180,180,180), Color3.fromRGB(0,0,0)
    }

    local colorRow = Instance.new("Frame", Frame)
    colorRow.Size = UDim2.new(1,-50,0,22)
    colorRow.Position = UDim2.new(0,40,1,-28)
    colorRow.BackgroundTransparency = 1
    colorRow.ZIndex = 3
    local cl = Instance.new("UIListLayout", colorRow)
    cl.FillDirection = Enum.FillDirection.Horizontal
    cl.Padding = UDim.new(0, 4)

    for _, c in pairs(colors) do
        local Dot = Instance.new("TextButton", colorRow)
        Dot.Size = UDim2.new(0,18,0,18)
        Dot.BackgroundColor3 = c
        Dot.Text = ""; Dot.ZIndex = 4
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
        Dot.MouseButton1Click:Connect(function()
            setColor(c)
            Preview.BackgroundColor3 = c
        end)
    end
end

local function AddInputBox(parent, text, placeholder, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.97,0,0,70)
    Frame.BackgroundColor3 = T.secondary
    Frame.BackgroundTransparency = T.glassSecondary
    Frame.Parent = parent
    Frame.ZIndex = 2
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 9)
    local fs = Instance.new("UIStroke", Frame)
    fs.Thickness = 1; fs.Color = Color3.fromRGB(255,255,255); fs.Transparency = 0.82
    table.insert(allFrames, Frame)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1,-16,0,22)
    Lbl.Position = UDim2.new(0,12,0,5)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = T.text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 3
    table.insert(allLabels, Lbl)

    local Input = Instance.new("TextBox", Frame)
    Input.Size = UDim2.new(0.68,0,0,26)
    Input.Position = UDim2.new(0,10,0,36)
    Input.BackgroundColor3 = Color3.fromRGB(50,50,60)
    Input.BackgroundTransparency = 0.4
    Input.Text = ""
    Input.PlaceholderText = placeholder or "..."
    Input.TextColor3 = Color3.fromRGB(255,255,255)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 12
    Input.ZIndex = 3
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

    local ConfirmBtn = Instance.new("TextButton", Frame)
    ConfirmBtn.Size = UDim2.new(0.28,0,0,26)
    ConfirmBtn.Position = UDim2.new(0.7,0,0,36)
    ConfirmBtn.BackgroundColor3 = T.accent
    ConfirmBtn.BackgroundTransparency = 0.3
    ConfirmBtn.Text = "confirm"
    ConfirmBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ConfirmBtn.Font = Enum.Font.GothamBold
    ConfirmBtn.TextSize = 11
    ConfirmBtn.ZIndex = 3
    Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 6)
    table.insert(allAccentElements, ConfirmBtn)

    ConfirmBtn.MouseButton1Click:Connect(function()
        if Input.Text ~= "" then
            callback(Input.Text)
            Input.Text = ""
        end
    end)
    return Input
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
    table.insert(allAccentElements, AddBtn)
    AddBtn.MouseButton1Click:Connect(function()
        if Input.Text ~= "" then
            AddToggle(parent, Input.Text, false, function(v) print(Input.Text, v) end)
            Input.Text = ""
        end
    end)
end

-- ESP СИСТЕМА
local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character

            local hl = char:FindFirstChild("AviadonsHL")
            if State.espEnabled then
                if not hl then hl = Instance.new("Highlight", char); hl.Name = "AviadonsHL" end
                hl.FillColor = State.espFillColor
                hl.OutlineColor = State.espOutlineColor
                hl.FillTransparency = State.espFillTransp
                hl.OutlineTransparency = State.espOutlineTransp
            else
                if hl then hl:Destroy() end
            end

            local chams = char:FindFirstChild("AviadonsChams")
            if State.espChams then
                if not chams then
                    chams = Instance.new("Highlight", char)
                    chams.Name = "AviadonsChams"
                    chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                chams.FillColor = State.espChamsColor
                chams.OutlineColor = State.espChamsColor
                chams.FillTransparency = 0.3
                chams.OutlineTransparency = 0.5
            else
                if chams then chams:Destroy() end
            end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local nt = hrp:FindFirstChild("AviadonsNameTag")
                if State.espNametags then
                    if not nt then
                        local bg = Instance.new("BillboardGui", hrp)
                        bg.Name = "AviadonsNameTag"
                        bg.Size = UDim2.new(0,130,0,40)
                        bg.StudsOffset = Vector3.new(0,4,0)
                        bg.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel", bg)
                        lbl.Size = UDim2.new(1,0,0.6,0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = plr.DisplayName
                        lbl.TextColor3 = Color3.fromRGB(255,255,255)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 13
                        local sublbl = Instance.new("TextLabel", bg)
                        sublbl.Size = UDim2.new(1,0,0.4,0)
                        sublbl.Position = UDim2.new(0,0,0.6,0)
                        sublbl.BackgroundTransparency = 1
                        sublbl.Text = "@"..plr.Name
                        sublbl.TextColor3 = Color3.fromRGB(200,200,200)
                        sublbl.Font = Enum.Font.Gotham
                        sublbl.TextSize = 10
                    end
                else
                    if hrp:FindFirstChild("AviadonsNameTag") then hrp.AviadonsNameTag:Destroy() end
                end

                if State.espHealthBars then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum and not hrp:FindFirstChild("HealthBar") then
                        local hbg = Instance.new("BillboardGui", hrp)
                        hbg.Name = "HealthBar"
                        hbg.Size = UDim2.new(0,80,0,10)
                        hbg.StudsOffset = Vector3.new(0,2.5,0)
                        hbg.AlwaysOnTop = true
                        local bg = Instance.new("Frame", hbg)
                        bg.Size = UDim2.new(1,0,1,0)
                        bg.BackgroundColor3 = Color3.fromRGB(50,50,50)
                        Instance.new("UICorner", bg).CornerRadius = UDim.new(0,4)
                        local fill = Instance.new("Frame", bg)
                        fill.Name = "fill"
                        fill.Size = UDim2.new(hum.Health/hum.MaxHealth,0,1,0)
                        fill.BackgroundColor3 = Color3.fromRGB(0,200,80)
                        Instance.new("UICorner", fill).CornerRadius = UDim.new(0,4)
                        RunService.Heartbeat:Connect(function()
                            if hum and hum.Parent then
                                local pct = hum.Health/hum.MaxHealth
                                fill.Size = UDim2.new(pct,0,1,0)
                                fill.BackgroundColor3 = Color3.fromHSV(pct*0.33,1,1)
                            end
                        end)
                    end
                else
                    if hrp:FindFirstChild("HealthBar") then hrp.HealthBar:Destroy() end
                end

                if State.espDistance then
                    local dist = hrp:FindFirstChild("AviadonsDistance")
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not dist then
                        local dbg = Instance.new("BillboardGui", hrp)
                        dbg.Name = "AviadonsDistance"
                        dbg.Size = UDim2.new(0,80,0,20)
                        dbg.StudsOffset = Vector3.new(0,-2,0)
                        dbg.AlwaysOnTop = true
                        local dlbl = Instance.new("TextLabel", dbg)
                        dlbl.Name = "distlbl"
                        dlbl.Size = UDim2.new(1,0,1,0)
                        dlbl.BackgroundTransparency = 1
                        dlbl.TextColor3 = Color3.fromRGB(255,255,100)
                        dlbl.Font = Enum.Font.GothamBold
                        dlbl.TextSize = 11
                        RunService.Heartbeat:Connect(function()
                            if myHRP and myHRP.Parent and hrp and hrp.Parent then
                                local d = math.floor((hrp.Position - myHRP.Position).Magnitude)
                                dlbl.Text = d .. " studs"
                            end
                        end)
                    end
                else
                    if hrp:FindFirstChild("AviadonsDistance") then hrp.AviadonsDistance:Destroy() end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if State.espTracers or State.espBoxes then
        for _, d in pairs(ESP_drawings) do
            if d and d.Remove then pcall(function() d:Remove() end) end
        end
        ESP_drawings = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        if State.espTracers then
                            local ok, line = pcall(function() return Drawing.new("Line") end)
                            if ok then
                                line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y)
                                line.To = Vector2.new(pos.X, pos.Y)
                                line.Color = State.espTracerColor
                                line.Thickness = 1.5
                                line.Transparency = 1
                                line.Visible = true
                                table.insert(ESP_drawings, line)
                            end
                        end
                        if State.espBoxes then
                            local topPos = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position + Vector3.new(0,3.5,0))
                            local botPos = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position + Vector3.new(0,-3.5,0))
                            local height = math.abs(topPos.Y - botPos.Y)
                            local width = height * 0.5
                            local ok2, box = pcall(function() return Drawing.new("Square") end)
                            if ok2 then
                                box.Position = Vector2.new(pos.X - width/2, topPos.Y)
                                box.Size = Vector2.new(width, height)
                                box.Color = State.espBoxColor
                                box.Thickness = 1.5
                                box.Filled = false
                                box.Transparency = 1
                                box.Visible = true
                                table.insert(ESP_drawings, box)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- СОЗДАНИЕ ВКЛАДОК
local MainTab = CreateTab("movement")
local FarmTab = CreateTab("autofarm")
local TpTab = CreateTab("teleport")
local ESPTab = CreateTab("esp")
local VisualTab = CreateTab("visual")
local WorldTab = CreateTab("world")
local PlayerTab = CreateTab("player")
local ConfigTab = CreateTab("configs")
local ThemeTab = CreateTab("themes")
local CustomTab = CreateTab("custom")
local                                                                                                                                                                         = CreateTab("credits")

-- MOVEMENT
local speedRef = AddSlider(MainTab, "speed", 16, 500, 16, function(v)
    State.speed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

local jumpRef = AddSlider(MainTab, "jump power", 50, 500, 50, function(v)
    State.jumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

AddToggle(MainTab, "infinite jump", false, function(v)
    State.infJump = v
    UserInputService.JumpRequest:Connect(function()
        if State.infJump and LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

AddToggle(MainTab, "noclip", false, function(v)
    State.noclip = v
    RunService.Stepped:Connect(function()
        if State.noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

AddToggle(MainTab, "fly (e = up, q = down)", false, function(v)
    State.fly = v
    if v then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local BV = Instance.new("BodyVelocity", hrp)
            BV.Name = "FlyBV"
            BV.MaxForce = Vector3.new(1e9,1e9,1e9)
            BV.Velocity = Vector3.new(0,0,0)
            RunService.RenderStepped:Connect(function()
                if State.fly and BV and BV.Parent then
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

AddToggle(MainTab, "spin bot", false, function(v)
    State.spinBot = v
    RunService.Heartbeat:Connect(function()
        if State.spinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end)
end)

AddToggle(MainTab, "bhop", false, function(v)
    State.bhop = v
    RunService.Stepped:Connect(function()
        if State.bhop and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState("Jumping")
            end
        end
    end)
end)

AddSlider(MainTab, "walkspeed multiplier", 1, 10, 1, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = State.speed * v
    end
end)

-- AUTOFARM
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local coinsFolder = Workspace:FindFirstChild("coins")
local collectReq = ReplicatedStorage:FindFirstChild("CollectCoinRequest")

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
    local closest, closestDist = nil, State.collectionRadius
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

AddToggle(FarmTab, "auto coin farm", false, function(v)
    State.farmRunning = v
    if v then
        task.spawn(function()
            while State.farmRunning do processCoins(); task.wait(0.01) end
        end)
    end
end)

local radRef = AddSlider(FarmTab, "collection radius", 10, 200, 50, function(v)
    State.collectionRadius = v
end)

AddToggle(FarmTab, "auto collect nearby tools", false, function(v)
    State.autoTool = v
    task.spawn(function()
        while State.autoTool do
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

AddToggle(FarmTab, "rainbow character", false, function(v)
    State.rainbow = v
    RunService.Heartbeat:Connect(function()
        if State.rainbow and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                end
            end
        end
    end)
end)

-- TELEPORT
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
    repeat target = plrs[math.random(1,#plrs)] until target ~= LocalPlayer
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

AddButton(TpTab, "tp to highest point", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = CFrame.new(hrp.Position.X, 500, hrp.Position.Z)
    end
end)

AddToggle(TpTab, "click tp (ctrl + click)", false, function(v)
    State.clickTp = v
    if v then
        local mouse = LocalPlayer:GetMouse()
        mouse.Button1Down:Connect(function()
            if State.clickTp and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                LocalPlayer.Character:MoveTo(mouse.Hit.p)
            end
        end)
    end
end)

AddButton(TpTab, "tp to camera lookat", function()
    if LocalPlayer.Character then
        local cam = workspace.CurrentCamera
        local cf = cam.CFrame
        local target = cf.Position + cf.LookVector * 30
        LocalPlayer.Character:MoveTo(target)
    end
end)

-- ESP
AddLabel(ESPTab, "highlight esp", true)
AddToggle(ESPTab, "esp highlight", false, function(v) State.espEnabled = v; UpdateESP() end)
AddColorPicker(ESPTab, "fill color", function() return State.espFillColor end, function(c) State.espFillColor = c; UpdateESP() end)
AddColorPicker(ESPTab, "outline color", function() return State.espOutlineColor end, function(c) State.espOutlineColor = c; UpdateESP() end)
AddSlider(ESPTab, "fill transparency", 0, 10, 5, function(v) State.espFillTransp = v/10; UpdateESP() end)
AddSlider(ESPTab, "outline transparency", 0, 10, 0, function(v) State.espOutlineTransp = v/10; UpdateESP() end)

AddLabel(ESPTab, "chams", true)
AddToggle(ESPTab, "chams", false, function(v) State.espChams = v; UpdateESP() end)
AddColorPicker(ESPTab, "chams color", function() return State.espChamsColor end, function(c) State.espChamsColor = c; UpdateESP() end)

AddLabel(ESPTab, "tracers & boxes", true)
AddToggle(ESPTab, "tracers", false, function(v) State.espTracers = v end)
AddColorPicker(ESPTab, "tracer color", function() return State.espTracerColor end, function(c) State.espTracerColor = c end)
AddToggle(ESPTab, "esp boxes", false, function(v) State.espBoxes = v end)
AddColorPicker(ESPTab, "box color", function() return State.espBoxColor end, function(c) State.espBoxColor = c end)

AddLabel(ESPTab, "other esp", true)
AddToggle(ESPTab, "name tags", false, function(v) State.espNametags = v; UpdateESP() end)
AddToggle(ESPTab, "health bars", false, function(v) State.espHealthBars = v; UpdateESP() end)
AddToggle(ESPTab, "distance display", false, function(v) State.espDistance = v; UpdateESP() end)

-- VISUAL
AddToggle(VisualTab, "fullbright", false, function(v)
    State.fullbright = v
    Lighting.Brightness = v and 3 or 1
    Lighting.ClockTime = v and 14 or 12
    Lighting.GlobalShadows = not v
end)

AddToggle(VisualTab, "remove fog", false, function(v)
    State.noFog = v
    Lighting.FogEnd = v and 1e10 or 100000
end)

AddToggle(VisualTab, "x-ray", false, function(v)
    State.xray = v
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
            obj.Transparency = v and 0.75 or 0
        end
    end
end)

AddToggle(VisualTab, "remove textures", false, function(v)
    State.noTextures = v
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = v and 1 or 0 end
    end
end)

AddToggle(VisualTab, "anti-lag", false, function(v)
    State.antiLag = v
    if v then
        settings().Rendering.QualityLevel = 1
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = false
            end
        end
    end
end)

AddSlider(VisualTab, "field of view", 70, 120, 70, function(v)
    workspace.CurrentCamera.FieldOfView = v
end)

-- WORLD
local gravRef = AddSlider(WorldTab, "gravity", 0, 196, 196, function(v)
    State.gravityVal = v
    Workspace.Gravity = v
end)

local timeRef = AddSlider(WorldTab, "time of day", 0, 24, 14, function(v)
    State.timeOfDay = v
    Lighting.ClockTime = v
end)

AddToggle(WorldTab, "day lock", false, function(v)
    State.dayLock = v
    task.spawn(function()
        while State.dayLock do Lighting.ClockTime = 14; task.wait(0.1) end
    end)
end)

AddToggle(WorldTab, "night lock", false, function(v)
    State.nightLock = v
    task.spawn(function()
        while State.nightLock do Lighting.ClockTime = 0; task.wait(0.1) end
    end)
end)

AddToggle(WorldTab, "rain particles", false, function(v)
    local rain = Workspace:FindFirstChild("AviadonsRain")
    if v then
        if not rain then
            rain = Instance.new("Part", Workspace)
            rain.Name = "AviadonsRain"
            rain.Anchored = true
            rain.Size = Vector3.new(500,1,500)
            rain.Position = Vector3.new(0,200,0)
            rain.Transparency = 1
            rain.CanCollide = false
            local pe = Instance.new("ParticleEmitter", rain)
            pe.Rate = 500
            pe.Lifetime = NumberRange.new(3,5)
            pe.Speed = NumberRange.new(80,100)
            pe.SpreadAngle = Vector2.new(0,0)
            pe.Rotation = NumberRange.new(90,90)
            pe.Color = ColorSequence.new(Color3.fromRGB(180,220,255))
            pe.Size = NumberSequence.new(0.05)
            pe.Transparency = NumberSequence.new(0.7)
        end
    else
        if rain then rain:Destroy() end
    end
end)

AddToggle(WorldTab, "ambient dark mode", false, function(v)
    Lighting.Ambient = v and Color3.fromRGB(0,0,0) or Color3.fromRGB(70,70,70)
    Lighting.OutdoorAmbient = v and Color3.fromRGB(0,0,0) or Color3.fromRGB(127,127,127)
end)

-- PLAYER
AddToggle(PlayerTab, "invisible", false, function(v)
    State.invisible = v
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = v and 1 or 0
            end
        end
    end
end)

AddToggle(PlayerTab, "god mode", false, function(v)
    State.godMode = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = v and math.huge or 100
        LocalPlayer.Character.Humanoid.Health = v and math.huge or 100
    end
end)

AddToggle(PlayerTab, "anti-afk", false, function(v)
    State.antiAfk = v
    if v then
        local VU = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
        end)
    end
end)

AddButton(PlayerTab, "rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

AddButton(PlayerTab, "reset character", function()
    LocalPlayer.Character:BreakJoints()
end)

AddButton(PlayerTab, "copy game id", function()
    if setclipboard then setclipboard(tostring(game.PlaceId)) end
end)

AddButton(PlayerTab, "server hop", function()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if ok and data and data.data then
        for _, v in pairs(data.data) do
            if v.id ~= game.JobId then
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                end)
                break
            end
        end
    end
end)

AddSlider(PlayerTab, "character scale", 1, 5, 1, function(v)
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("SpecialMesh") then
                part.Scale = Vector3.new(v,v,v)
            end
        end
    end
end)

-- CONFIGS
AddLabel(ConfigTab, "configs", true)

AddInputBox(ConfigTab, "save config:", "config name...", function(name)
    local ok = SaveConfigToFile(name)
    print(ok and "saved: "..name or "save failed")
end)

AddInputBox(ConfigTab, "load config:", "config name...", function(name)
    local ok = LoadConfigFromFile(name)
    if ok then
        speedRef.setValue(State.speed)
        jumpRef.setValue(State.jumpPower)
        gravRef.setValue(State.gravityVal)
        timeRef.setValue(State.timeOfDay)
        radRef.setValue(State.collectionRadius)
        UpdateESP()
        UpdateTheme(T)
        print("loaded: "..name)
    else
        print("config not found: "..name)
    end
end)

AddButton(ConfigTab, "reset all settings", function()
    State.speed = 16; State.jumpPower = 50; State.gravityVal = 196; State.timeOfDay = 14
    State.espEnabled = false; State.espChams = false; State.espTracers = false
    State.espBoxes = false; State.espNametags = false; State.espHealthBars = false
    State.espDistance = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    Workspace.Gravity = 196
    Lighting.ClockTime = 14
    speedRef.setValue(16)
    jumpRef.setValue(50)
    gravRef.setValue(196)
    timeRef.setValue(14)
    radRef.setValue(50)
    UpdateESP()
    print("reset done")
end)

-- THEMES
AddLabel(ThemeTab, "preset themes", true)
AddButton(ThemeTab, "dark", function() UpdateTheme(Themes.dark) end)
AddButton(ThemeTab, "light", function() UpdateTheme(Themes.light) end)
AddButton(ThemeTab, "purple", function() UpdateTheme(Themes.purple) end)
AddButton(ThemeTab, "midnight", function() UpdateTheme(Themes.midnight) end)
AddButton(ThemeTab, "rose", function() UpdateTheme(Themes.rose) end)
AddButton(ThemeTab, "forest", function() UpdateTheme(Themes.forest) end)
AddButton(ThemeTab, "sunset", function() UpdateTheme(Themes.sunset) end)
AddButton(ThemeTab, "ice", function() UpdateTheme(Themes.ice) end)

AddLabel(ThemeTab, "custom theme builder", true)

local customThemeData = {
    main = Color3.fromRGB(20,20,25),
    secondary = Color3.fromRGB(30,30,38),
    accent = Color3.fromRGB(88,101,242),
    text = Color3.fromRGB(255,255,255),
    glass = 0.55,
    glassSecondary = 0.65
}

AddColorPicker(ThemeTab, "main color", function() return customThemeData.main end, function(c) customThemeData.main = c end)
AddColorPicker(ThemeTab, "secondary color", function() return customThemeData.secondary end, function(c) customThemeData.secondary = c end)
AddColorPicker(ThemeTab, "accent color", function() return customThemeData.accent end, function(c) customThemeData.accent = c end)
AddColorPicker(ThemeTab, "text color", function() return customThemeData.text end, function(c) customThemeData.text = c end)
AddSlider(ThemeTab, "main glass", 0, 10, 5, function(v) customThemeData.glass = v/10 end)
AddSlider(ThemeTab, "secondary glass", 0, 10, 6, function(v) customThemeData.glassSecondary = v/10 end)

AddButton(ThemeTab, "preview custom theme", function()
    local ct = {
        name = "custom",
        main = customThemeData.main,
        secondary = customThemeData.secondary,
        accent = customThemeData.accent,
        text = customThemeData.text,
        glass = customThemeData.glass,
        glassSecondary = customThemeData.glassSecondary
    }
    UpdateTheme(ct)
end)

AddInputBox(ThemeTab, "save custom theme:", "theme name...", function(name)
    local ct = {
        name = name,
        main = customThemeData.main,
        secondary = customThemeData.secondary,
        accent = customThemeData.accent,
        text = customThemeData.text,
        glass = customThemeData.glass,
        glassSecondary = customThemeData.glassSecondary
    }
    customThemes[name] = ct
    SaveThemeToFile(name, ct)
    print("theme saved: "..name)
end)

AddInputBox(ThemeTab, "load saved theme:", "theme name...", function(name)
    local ct = customThemes[name] or LoadThemeFromFile(name)
    if ct then
        if not ct.name then ct.name = name end
        customThemes[name] = ct
        UpdateTheme(ct)
        print("theme loaded: "..name)
    else
        print("theme not found: "..name)
    end
end)

-- CUSTOM
AddLabel(CustomTab, "custom toggles", true)
AddCustomToggle(CustomTab)

-- CREDITS
AddLabel(                                                                                                                                                                       , "special thanks", true)
AddLabel(                                                                                                                                                                       , "raknetskid")
AddLabel(                                                                                                                                                                       , "solinexx")
AddLabel(                                                                                                                                                                       , "ab1s")
AddLabel(                                                                                                                                                                       , "chasova")
AddLabel(                                                                                                                                                                       , "kvaz1mota")
AddLabel(                                                                                                                                                                       , "izkor")
AddLabel(                                                                                                                                                                       , "azure143")
AddLabel(                                                                                                                                                                       , "mike.jpg")
AddLabel(                                                                                                                                                                       , "kjja")
AddLabel(                                                                                                                                                                       , "swan")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

Pages.movement.Visible = true
