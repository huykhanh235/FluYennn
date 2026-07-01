--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║              FLUYEN HUD MENU - COMPLETE EDITION              ║
    ║    Toggle: 3-finger tap x 3 times | Draggable | Themeable    ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

-- ═══════════════════════════════════════════════════════════════
--  CONFIGURATION
-- ═══════════════════════════════════════════════════════════════
local SCRIPT_NAME = "FLUYEN"
local SCRIPT_VERSION = "v3.0.0"
local CREDITS = "FLUYEN Team"

local REQUIRED_FINGERS = 3
local REQUIRED_TAPS = 3
local TAP_WINDOW = 1.2

local tapCount = 0
local lastTapTime = 0

-- ═══════════════════════════════════════════════════════════════
--  STATE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════
local States = {
    -- Visual
    ESP = false,
    BoxESP = false,
    NameESP = false,
    HealthESP = false,
    DistanceESP = false,
    Tracers = false,
    Chams = false,
    FullBright = false,

    -- Combat
    Aim = false,
    SilentAim = false,
    AimFOV = false,
    AimPrediction = false,
    TriggerBot = false,
    HitboxExpander = false,

    -- Movement
    Speed = false,
    Fly = false,
    Noclip = false,
    JumpPower = false,
    InfiniteJump = false,
    Teleport = false,
    ClickTeleport = false,
    Sprint = false,
    AntiVoid = false,

    -- Utility
    AntiAFK = false,
    FreezeTime = false,
    FPSBooster = false,

    -- Fun
    Spin = false,
    Float = false,
    Bang = false,
    Fling = false,
    OrbitPlayer = false,
    Invisible = false,

    -- Settings
    DraggableGUI = true,
    MinimizeButton = true,
    Notifications = true,
    AutoLoadSettings = false,
}

local Values = {
    SpeedValue = 50,
    JumpPowerValue = 100,
    FlySpeed = 50,
    AimFOVValue = 100,
    AimSmoothness = 0.1,
    HitboxSize = 5,
    ESPMaxDistance = 1000,
    FullBrightValue = 2,
    SpinSpeed = 50,
    FloatHeight = 5,
    OrbitRadius = 10,
    OrbitSpeed = 50,
    SprintSpeed = 70,
    TeleportKey = "T",
    ToggleKey = "Insert",
}

local Themes = {
    Dark = {
        bg = Color3.fromRGB(18, 18, 22),
        titleBar = Color3.fromRGB(26, 26, 32),
        tabContainer = Color3.fromRGB(22, 22, 27),
        tabBtn = Color3.fromRGB(30, 30, 36),
        tabBtnActive = Color3.fromRGB(70, 110, 255),
        text = Color3.fromRGB(240, 240, 245),
        textDim = Color3.fromRGB(180, 180, 190),
        stroke = Color3.fromRGB(70, 70, 90),
        toggleOff = Color3.fromRGB(50, 50, 58),
        toggleOn = Color3.fromRGB(70, 110, 255),
        accent = Color3.fromRGB(70, 110, 255),
        rowBg = Color3.fromRGB(24, 24, 30),
        inputBg = Color3.fromRGB(35, 35, 42),
        scrollBar = Color3.fromRGB(70, 70, 90),
    },
    Light = {
        bg = Color3.fromRGB(245, 245, 250),
        titleBar = Color3.fromRGB(230, 230, 240),
        tabContainer = Color3.fromRGB(235, 235, 242),
        tabBtn = Color3.fromRGB(220, 220, 228),
        tabBtnActive = Color3.fromRGB(70, 110, 255),
        text = Color3.fromRGB(30, 30, 40),
        textDim = Color3.fromRGB(80, 80, 90),
        stroke = Color3.fromRGB(180, 180, 195),
        toggleOff = Color3.fromRGB(180, 180, 190),
        toggleOn = Color3.fromRGB(70, 110, 255),
        accent = Color3.fromRGB(70, 110, 255),
        rowBg = Color3.fromRGB(235, 235, 242),
        inputBg = Color3.fromRGB(220, 220, 228),
        scrollBar = Color3.fromRGB(180, 180, 195),
    },
    SkyBlue = {
        bg = Color3.fromRGB(15, 25, 40),
        titleBar = Color3.fromRGB(20, 35, 55),
        tabContainer = Color3.fromRGB(18, 30, 48),
        tabBtn = Color3.fromRGB(25, 40, 65),
        tabBtnActive = Color3.fromRGB(0, 170, 255),
        text = Color3.fromRGB(220, 240, 255),
        textDim = Color3.fromRGB(150, 180, 210),
        stroke = Color3.fromRGB(0, 120, 200),
        toggleOff = Color3.fromRGB(40, 60, 90),
        toggleOn = Color3.fromRGB(0, 170, 255),
        accent = Color3.fromRGB(0, 170, 255),
        rowBg = Color3.fromRGB(20, 35, 55),
        inputBg = Color3.fromRGB(30, 50, 80),
        scrollBar = Color3.fromRGB(0, 120, 200),
    },
    Galaxy = {
        bg = Color3.fromRGB(20, 10, 35),
        titleBar = Color3.fromRGB(30, 15, 50),
        tabContainer = Color3.fromRGB(25, 12, 42),
        tabBtn = Color3.fromRGB(35, 18, 58),
        tabBtnActive = Color3.fromRGB(180, 80, 255),
        text = Color3.fromRGB(240, 220, 255),
        textDim = Color3.fromRGB(180, 150, 210),
        stroke = Color3.fromRGB(140, 60, 220),
        toggleOff = Color3.fromRGB(50, 30, 75),
        toggleOn = Color3.fromRGB(180, 80, 255),
        accent = Color3.fromRGB(180, 80, 255),
        rowBg = Color3.fromRGB(30, 15, 50),
        inputBg = Color3.fromRGB(45, 22, 72),
        scrollBar = Color3.fromRGB(140, 60, 220),
    },
}

local Languages = {
    English = {
        Home = "Home", Visual = "Visual", Combat = "Combat",
        Movement = "Movement", Utility = "Utility", Server = "Server",
        Fun = "Fun", Settings = "Settings", Theme = "Theme",
        Language = "Language", GUI = "GUI",
        ScriptName = "Script Name", Version = "Version",
        Username = "Username", Executor = "Executor",
        Credits = "Credits", Changelog = "Changelog",
        ESP = "ESP", BoxESP = "Box ESP", NameESP = "Name ESP",
        HealthESP = "Health ESP", DistanceESP = "Distance ESP",
        Tracers = "Tracers", ChamsXRay = "Chams / X-Ray",
        FullBright = "Full Bright",
        Aim = "Aim", SilentAim = "Silent Aim", AimFOV = "Aim FOV",
        AimPrediction = "Aim Prediction", TriggerBot = "Trigger Bot",
        HitboxExpander = "Hitbox Expander",
        Speed = "Speed", Fly = "Fly", Noclip = "Noclip",
        JumpPower = "Jump Power", InfiniteJump = "Infinite Jump",
        Teleport = "Teleport", ClickTeleport = "Click Teleport",
        Sprint = "Sprint", AntiVoid = "Anti Void",
        AntiAFK = "Anti AFK", FreezeTime = "Freeze Time",
        FPSBooster = "FPS Booster",
        RejoinServer = "Rejoin Server", ServerHop = "Server Hop",
        JoinSmallServer = "Join Small Server", PlayerList = "Player List",
        SpectatePlayer = "Spectate Player",
        Spin = "Spin", Float = "Float", Bang = "Bang",
        Fling = "Fling", OrbitPlayer = "Orbit Player",
        Invisible = "Invisible",
        Dark = "Dark", Light = "Light", SkyBlue = "Sky Blue",
        Galaxy = "Galaxy",
        SaveSettings = "Save Settings", AutoLoadSettings = "Auto Load Settings",
        ResetSettings = "Reset Settings", MinimizeButton = "Minimize Button",
        DraggableGUI = "Draggable GUI", ToggleKeybind = "Toggle Keybind",
        Notifications = "Notifications",
    },
    ["Tiếng Việt"] = {
        Home = "Trang chủ", Visual = "Hình ảnh", Combat = "Chiến đấu",
        Movement = "Di chuyển", Utility = "Tiện ích", Server = "Máy chủ",
        Fun = "Vui nhộn", Settings = "Cài đặt", Theme = "Giao diện",
        Language = "Ngôn ngữ", GUI = "Giao diện",
        ScriptName = "Tên Script", Version = "Phiên bản",
        Username = "Tên người dùng", Executor = "Executor",
        Credits = "Tín dụng", Changelog = "Nhật ký thay đổi",
        ESP = "ESP", BoxESP = "Box ESP", NameESP = "Tên ESP",
        HealthESP = "Máu ESP", DistanceESP = "Khoảng cách ESP",
        Tracers = "Đường dẫn", ChamsXRay = "Chams / X-Ray",
        FullBright = "Sáng tối đa",
        Aim = "Ngắm", SilentAim = "Ngắm âm thầm", AimFOV = "FOV Ngắm",
        AimPrediction = "Dự đoán Ngắm", TriggerBot = "Trigger Bot",
        HitboxExpander = "Mở rộng Hitbox",
        Speed = "Tốc độ", Fly = "Bay", Noclip = "Xuyên tường",
        JumpPower = "Lực nhảy", InfiniteJump = "Nhảy vô hạn",
        Teleport = "Dịch chuyển", ClickTeleport = "Click Dịch chuyển",
        Sprint = "Chạy nhanh", AntiVoid = "Chống Hố",
        AntiAFK = "Chống AFK", FreezeTime = "Đóng băng thời gian",
        FPSBooster = "Tăng FPS",
        RejoinServer = "Vào lại Server", ServerHop = "Chuyển Server",
        JoinSmallServer = "Vào Server nhỏ", PlayerList = "Danh sách người chơi",
        SpectatePlayer = "Theo dõi người chơi",
        Spin = "Xoay", Float = "Nổi", Bang = "Bang",
        Fling = "Ném", OrbitPlayer = "Quay quanh người chơi",
        Invisible = "Tàng hình",
        Dark = "Tối", Light = "Sáng", SkyBlue = "Xanh da trời",
        Galaxy = "Galaxy",
        SaveSettings = "Lưu cài đặt", AutoLoadSettings = "Tự động tải cài đặt",
        ResetSettings = "Đặt lại cài đặt", MinimizeButton = "Nút thu nhỏ",
        DraggableGUI = "Kéo thả GUI", ToggleKeybind = "Phím bật/tắt",
        Notifications = "Thông báo",
    },
    ["Español"] = {
        Home = "Inicio", Visual = "Visual", Combat = "Combate",
        Movement = "Movimiento", Utility = "Utilidad", Server = "Servidor",
        Fun = "Diversión", Settings = "Ajustes", Theme = "Tema",
        Language = "Idioma", GUI = "GUI",
        ScriptName = "Nombre Script", Version = "Versión",
        Username = "Usuario", Executor = "Executor",
        Credits = "Créditos", Changelog = "Registro",
        ESP = "ESP", BoxESP = "Box ESP", NameESP = "Nombre ESP",
        HealthESP = "Salud ESP", DistanceESP = "Distancia ESP",
        Tracers = "Trazadores", ChamsXRay = "Chams / X-Ray",
        FullBright = "Brillo Total",
        Aim = "Apuntar", SilentAim = "Apuntar Silencioso", AimFOV = "FOV Apuntar",
        AimPrediction = "Predicción", TriggerBot = "Trigger Bot",
        HitboxExpander = "Ampliar Hitbox",
        Speed = "Velocidad", Fly = "Volar", Noclip = "Noclip",
        JumpPower = "Salto", InfiniteJump = "Salto Infinito",
        Teleport = "Teletransporte", ClickTeleport = "Click Teletransporte",
        Sprint = "Sprint", AntiVoid = "Anti Vacío",
        AntiAFK = "Anti AFK", FreezeTime = "Congelar Tiempo",
        FPSBooster = "Mejorar FPS",
        RejoinServer = "Reunir Servidor", ServerHop = "Cambiar Servidor",
        JoinSmallServer = "Servidor Pequeño", PlayerList = "Lista Jugadores",
        SpectatePlayer = "Espectar Jugador",
        Spin = "Girar", Float = "Flotar", Bang = "Bang",
        Fling = "Lanzar", OrbitPlayer = "Orbitar Jugador",
        Invisible = "Invisible",
        Dark = "Oscuro", Light = "Claro", SkyBlue = "Azul Cielo",
        Galaxy = "Galaxia",
        SaveSettings = "Guardar", AutoLoadSettings = "Auto Cargar",
        ResetSettings = "Restablecer", MinimizeButton = "Minimizar",
        DraggableGUI = "Arrastrable", ToggleKeybind = "Tecla Alternar",
        Notifications = "Notificaciones",
    },
    ["Português"] = {
        Home = "Início", Visual = "Visual", Combat = "Combate",
        Movement = "Movimento", Utility = "Utilidade", Server = "Servidor",
        Fun = "Diversão", Settings = "Configurações", Theme = "Tema",
        Language = "Idioma", GUI = "GUI",
        ScriptName = "Nome Script", Version = "Versão",
        Username = "Usuário", Executor = "Executor",
        Credits = "Créditos", Changelog = "Registro",
        ESP = "ESP", BoxESP = "Box ESP", NameESP = "Nome ESP",
        HealthESP = "Vida ESP", DistanceESP = "Distância ESP",
        Tracers = "Traçadores", ChamsXRay = "Chams / X-Ray",
        FullBright = "Brilho Total",
        Aim = "Mira", SilentAim = "Mira Silenciosa", AimFOV = "FOV Mira",
        AimPrediction = "Previsão", TriggerBot = "Trigger Bot",
        HitboxExpander = "Expandir Hitbox",
        Speed = "Velocidade", Fly = "Voar", Noclip = "Noclip",
        JumpPower = "Pulo", InfiniteJump = "Pulo Infinito",
        Teleport = "Teleporte", ClickTeleport = "Click Teleporte",
        Sprint = "Sprint", AntiVoid = "Anti Vazio",
        AntiAFK = "Anti AFK", FreezeTime = "Congelar Tempo",
        FPSBooster = "Aumentar FPS",
        RejoinServer = "Reentrar", ServerHop = "Trocar Servidor",
        JoinSmallServer = "Servidor Pequeno", PlayerList = "Lista Jogadores",
        SpectatePlayer = "Espectar Jogador",
        Spin = "Girar", Float = "Flutuar", Bang = "Bang",
        Fling = "Arremessar", OrbitPlayer = "Orbitar Jogador",
        Invisible = "Invisível",
        Dark = "Escuro", Light = "Claro", SkyBlue = "Azul Céu",
        Galaxy = "Galáxia",
        SaveSettings = "Salvar", AutoLoadSettings = "Auto Carregar",
        ResetSettings = "Redefinir", MinimizeButton = "Minimizar",
        DraggableGUI = "Arrastável", ToggleKeybind = "Tecla Alternar",
        Notifications = "Notificações",
    },
    ["Русский"] = {
        Home = "Главная", Visual = "Визуал", Combat = "Бой",
        Movement = "Движение", Utility = "Утилиты", Server = "Сервер",
        Fun = "Веселье", Settings = "Настройки", Theme = "Тема",
        Language = "Язык", GUI = "GUI",
        ScriptName = "Название", Version = "Версия",
        Username = "Имя", Executor = "Экзекьютор",
        Credits = "Авторы", Changelog = "Изменения",
        ESP = "ESP", BoxESP = "Box ESP", NameESP = "Имя ESP",
        HealthESP = "Здоровье ESP", DistanceESP = "Дистанция ESP",
        Tracers = "Трассеры", ChamsXRay = "Chams / X-Ray",
        FullBright = "Полный свет",
        Aim = "Прицел", SilentAim = "Тихий прицел", AimFOV = "FOV Прицел",
        AimPrediction = "Предсказание", TriggerBot = "Trigger Bot",
        HitboxExpander = "Расширить хитбокс",
        Speed = "Скорость", Fly = "Полёт", Noclip = "Ноклип",
        JumpPower = "Прыжок", InfiniteJump = "Бесконечный прыжок",
        Teleport = "Телепорт", ClickTeleport = "Клик Телепорт",
        Sprint = "Спринт", AntiVoid = "Анти Пустота",
        AntiAFK = "Анти АФК", FreezeTime = "Заморозка",
        FPSBooster = "FPS Бустер",
        RejoinServer = "Перезайти", ServerHop = "Сменить сервер",
        JoinSmallServer = "Малый сервер", PlayerList = "Список игроков",
        SpectatePlayer = "Наблюдать",
        Spin = "Крутиться", Float = "Парить", Bang = "Bang",
        Fling = "Швырнуть", OrbitPlayer = "Орбита",
        Invisible = "Невидимость",
        Dark = "Тёмная", Light = "Светлая", SkyBlue = "Небесная",
        Galaxy = "Галактика",
        SaveSettings = "Сохранить", AutoLoadSettings = "Авто загрузка",
        ResetSettings = "Сброс", MinimizeButton = "Свернуть",
        DraggableGUI = "Перетаскивание", ToggleKeybind = "Клавиша",
        Notifications = "Уведомления",
    },
}

local currentLang = "English"
local currentTheme = "Dark"

local function T(key)
    return Languages[currentLang] and Languages[currentLang][key] or Languages["English"][key] or key
end

local function getTheme()
    return Themes[currentTheme] or Themes["Dark"]
end


-- ═══════════════════════════════════════════════════════════════
--  NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════
local function notify(title, content, duration)
    if not States.Notifications then return end
    duration = duration or 3

    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "FLUYEN_Notification"
    notifGui.ResetOnSpawn = false
    notifGui.DisplayOrder = 999
    notifGui.Parent = playerGui

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 280, 0, 70)
    notifFrame.Position = UDim2.new(1, -300, 0, -80)
    notifFrame.BackgroundColor3 = getTheme().bg
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notifFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = getTheme().accent
    stroke.Thickness = 1.5
    stroke.Parent = notifFrame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = getTheme().accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notifFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 14, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = getTheme().text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -20, 0, 30)
    contentLabel.Position = UDim2.new(0, 14, 0, 30)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextSize = 12
    contentLabel.TextColor3 = getTheme().textDim
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = notifFrame

    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -300, 0, 20)
    }):Play()

    task.delay(duration, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20)
        }):Play()
        task.wait(0.3)
        notifGui:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
--  MAIN GUI CREATION
-- ═══════════════════════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FLUYEN_HudMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 100
screenGui.Parent = playerGui

-- Backdrop
local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0
backdrop.Visible = false
backdrop.ZIndex = 1
backdrop.Parent = screenGui

local backdropClose = Instance.new("TextButton")
backdropClose.Size = UDim2.new(1, 0, 1, 0)
backdropClose.BackgroundTransparency = 1
backdropClose.Text = ""
backdropClose.ZIndex = 1
backdropClose.Parent = backdrop

-- Main Frame
local MENU_WIDTH, MENU_HEIGHT = 640, 420

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = getTheme().bg
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = getTheme().stroke
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

local uiScale = Instance.new("UIScale")
uiScale.Scale = 0
uiScale.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = getTheme().titleBar
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = getTheme().titleBar
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = SCRIPT_NAME .. " " .. SCRIPT_VERSION
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = getTheme().text
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -72, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Draggable
local isDragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and States.DraggableGUI and
        (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  TAB SYSTEM
-- ═══════════════════════════════════════════════════════════════
local TAB_WIDTH = 150
local tabList = {"Home", "Visual", "Combat", "Movement", "Utility", "Server", "Fun", "Settings"}
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, TAB_WIDTH, 1, -44)
tabContainer.Position = UDim2.new(0, 0, 0, 44)
tabContainer.BackgroundColor3 = getTheme().tabContainer
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 8)
tabPadding.PaddingLeft = UDim.new(0, 6)
tabPadding.PaddingRight = UDim.new(0, 6)
tabPadding.Parent = tabContainer

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -TAB_WIDTH, 1, -44)
contentArea.Position = UDim2.new(0, TAB_WIDTH, 0, 44)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local pages = {}
local tabButtons = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = getTheme().scrollBar
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = page

    pages[name] = page
    return page
end

local function selectTab(name)
    for pageName, page in pairs(pages) do
        page.Visible = (pageName == name)
    end
    for btnName, btn in pairs(tabButtons) do
        local active = (btnName == name)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = active and getTheme().tabBtnActive or getTheme().tabBtn
        }):Play()
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or getTheme().text
    end
end

for i, name in ipairs(tabList) do
    createPage(name)

    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = getTheme().tabBtn
    btn.AutoButtonColor = false
    btn.Text = T(name)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = getTheme().text
    btn.LayoutOrder = i
    btn.Parent = tabContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    tabButtons[name] = btn
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end

selectTab("Home")


-- ═══════════════════════════════════════════════════════════════
--  UI COMPONENTS
-- ═══════════════════════════════════════════════════════════════

-- Section Header
local function addSection(page, text)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, 0, 0, 22)
    section.BackgroundTransparency = 1
    section.Text = text
    section.Font = Enum.Font.GothamBold
    section.TextSize = 14
    section.TextColor3 = getTheme().accent
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.LayoutOrder = #page:GetChildren() * 10
    section.Parent = page
    return section
end

-- Toggle Row
local function addToggle(page, label, key, defaultOn, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = getTheme().rowBg
    row.BorderSizePixel = 0
    row.LayoutOrder = #page:GetChildren() * 10 + 1
    row.Parent = page

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -70, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 13
    labelText.TextColor3 = getTheme().text
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = row

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 46, 0, 24)
    toggleBg.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBg.BackgroundColor3 = getTheme().toggleOff
    toggleBg.Parent = row

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleBg

    local state = States[key] or defaultOn or false
    States[key] = state

    local function applyState(animated)
        local knobGoal = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local bgGoal = state and getTheme().toggleOn or getTheme().toggleOff
        if animated then
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = knobGoal}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = bgGoal}):Play()
        else
            knob.Position = knobGoal
            toggleBg.BackgroundColor3 = bgGoal
        end
    end

    applyState(false)

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        States[key] = state
        applyState(true)
        if callback then callback(state) end
    end)

    return row
end

-- Slider Row
local function addSlider(page, label, key, min, max, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = getTheme().rowBg
    row.BorderSizePixel = 0
    row.LayoutOrder = #page:GetChildren() * 10 + 1
    row.Parent = page

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -70, 0, 20)
    labelText.Position = UDim2.new(0, 12, 0, 4)
    labelText.BackgroundTransparency = 1
    labelText.Text = label .. ": " .. (Values[key] or default)
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 12
    labelText.TextColor3 = getTheme().text
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 0, 30)
    track.BackgroundColor3 = getTheme().toggleOff
    track.BorderSizePixel = 0
    track.Parent = row

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = getTheme().accent
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + pos * (max - min))
        Values[key] = value
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -7, 0.5, -7)
        labelText.Text = label .. ": " .. value
        if callback then callback(value) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return row
end

-- Button Row
local function addButton(page, label, callback)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = getTheme().accent
    row.AutoButtonColor = false
    row.Text = label
    row.Font = Enum.Font.GothamBold
    row.TextSize = 13
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.LayoutOrder = #page:GetChildren() * 10 + 1
    row.Parent = page

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    row.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = getTheme().tabBtnActive}):Play()
    end)

    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = getTheme().accent}):Play()
    end)

    return row
end

-- Info Row (non-interactive)
local function addInfoRow(page, label, value)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = getTheme().rowBg
    row.BorderSizePixel = 0
    row.LayoutOrder = #page:GetChildren() * 10 + 1
    row.Parent = page

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.4, 0, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 12
    labelText.TextColor3 = getTheme().textDim
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = row

    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(0.6, -12, 1, 0)
    valueText.Position = UDim2.new(0.4, 0, 0, 0)
    valueText.BackgroundTransparency = 1
    valueText.Text = value
    valueText.Font = Enum.Font.GothamBold
    valueText.TextSize = 12
    valueText.TextColor3 = getTheme().text
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = row

    return row, valueText
end

-- Dropdown Row
local function addDropdown(page, label, options, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = getTheme().rowBg
    row.BorderSizePixel = 0
    row.LayoutOrder = #page:GetChildren() * 10 + 1
    row.Parent = page

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.4, 0, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 12
    labelText.TextColor3 = getTheme().text
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = row

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.55, -12, 0, 28)
    dropdownBtn.Position = UDim2.new(0.45, 0, 0.5, -14)
    dropdownBtn.BackgroundColor3 = getTheme().inputBg
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Text = default
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 12
    dropdownBtn.TextColor3 = getTheme().text
    dropdownBtn.Parent = row

    local ddCorner = Instance.new("UICorner")
    ddCorner.CornerRadius = UDim.new(0, 6)
    ddCorner.Parent = dropdownBtn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 10
    arrow.TextColor3 = getTheme().textDim
    arrow.Parent = dropdownBtn

    local dropdownOpen = false
    local dropdownFrame = nil

    dropdownBtn.MouseButton1Click:Connect(function()
        if dropdownOpen then
            if dropdownFrame then dropdownFrame:Destroy() end
            dropdownOpen = false
            return
        end

        dropdownOpen = true
        dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 28, 140))
        dropdownFrame.Position = UDim2.new(0, 0, 1, 4)
        dropdownFrame.BackgroundColor3 = getTheme().inputBg
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ZIndex = 10
        dropdownFrame.Parent = dropdownBtn

        local dfCorner = Instance.new("UICorner")
        dfCorner.CornerRadius = UDim.new(0, 6)
        dfCorner.Parent = dropdownFrame

        local dfLayout = Instance.new("UIListLayout")
        dfLayout.SortOrder = Enum.SortOrder.LayoutOrder
        dfLayout.Parent = dropdownFrame

        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundColor3 = getTheme().inputBg
            optBtn.AutoButtonColor = false
            optBtn.Text = opt
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 12
            optBtn.TextColor3 = getTheme().text
            optBtn.LayoutOrder = i
            optBtn.ZIndex = 11
            optBtn.Parent = dropdownFrame

            optBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = opt
                if dropdownFrame then dropdownFrame:Destroy() end
                dropdownOpen = false
                if callback then callback(opt) end
            end)

            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = getTheme().tabBtnActive
            end)
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = getTheme().inputBg
            end)
        end
    end)

    return row
end


-- ═══════════════════════════════════════════════════════════════
--  HOME TAB
-- ═══════════════════════════════════════════════════════════════
addSection(pages["Home"], T("Home"))
addInfoRow(pages["Home"], T("ScriptName"), SCRIPT_NAME)
addInfoRow(pages["Home"], T("Version"), SCRIPT_VERSION)
addInfoRow(pages["Home"], T("Username"), player.Name)

local executorName = "Unknown"
local success, result = pcall(function()
    return identifyexecutor and identifyexecutor() or (syn and "Synapse X") or (fluxus and "Fluxus") or (krnl and "KRNL") or "Unknown"
end)
if success then executorName = result end
addInfoRow(pages["Home"], T("Executor"), executorName)
addInfoRow(pages["Home"], T("Credits"), CREDITS)

addSection(pages["Home"], T("Changelog"))
local changelogText = Instance.new("TextLabel")
changelogText.Size = UDim2.new(1, 0, 0, 80)
changelogText.BackgroundTransparency = 1
changelogText.Text = "• v3.0.0 - Full HUD Menu Release\n• v2.5.0 - Added Combat Features\n• v2.0.0 - Added ESP System\n• v1.0.0 - Initial Release"
changelogText.Font = Enum.Font.Gotham
changelogText.TextSize = 12
changelogText.TextColor3 = getTheme().textDim
changelogText.TextXAlignment = Enum.TextXAlignment.Left
changelogText.TextYAlignment = Enum.TextYAlignment.Top
changelogText.TextWrapped = true
changelogText.LayoutOrder = #pages["Home"]:GetChildren() * 10 + 1
changelogText.Parent = pages["Home"]

-- ═══════════════════════════════════════════════════════════════
--  VISUAL TAB - ESP SYSTEM
-- ═══════════════════════════════════════════════════════════════
local ESPObjects = {}
local ESPConnections = {}

local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if ESPObjects[targetPlayer] then return end

    local espData = {
        box = {},
        name = nil,
        healthBar = nil,
        healthFill = nil,
        healthText = nil,
        distance = nil,
        tracer = nil,
        highlight = nil,
        skeleton = {},
    }

    -- Box ESP (4 lines)
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Thickness = 1
        espData.box[i] = line
    end

    -- Name ESP
    espData.name = Drawing.new("Text")
    espData.name.Visible = false
    espData.name.Center = true
    espData.name.Size = 14
    espData.name.Color = Color3.fromRGB(255, 255, 255)
    espData.name.Font = 2
    espData.name.Outline = true

    -- Health Bar
    espData.healthBar = Drawing.new("Square")
    espData.healthBar.Visible = false
    espData.healthBar.Filled = false
    espData.healthBar.Color = Color3.fromRGB(0, 0, 0)
    espData.healthBar.Thickness = 1

    espData.healthFill = Drawing.new("Square")
    espData.healthFill.Visible = false
    espData.healthFill.Filled = true
    espData.healthFill.Color = Color3.fromRGB(0, 255, 0)

    espData.healthText = Drawing.new("Text")
    espData.healthText.Visible = false
    espData.healthText.Center = true
    espData.healthText.Size = 12
    espData.healthText.Color = Color3.fromRGB(255, 255, 255)
    espData.healthText.Font = 2
    espData.healthText.Outline = true

    -- Distance
    espData.distance = Drawing.new("Text")
    espData.distance.Visible = false
    espData.distance.Center = true
    espData.distance.Size = 12
    espData.distance.Color = Color3.fromRGB(200, 200, 200)
    espData.distance.Font = 2
    espData.distance.Outline = true

    -- Tracer
    espData.tracer = Drawing.new("Line")
    espData.tracer.Visible = false
    espData.tracer.Color = Color3.fromRGB(255, 0, 0)
    espData.tracer.Thickness = 1

    -- Chams
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    espData.highlight = highlight

    ESPObjects[targetPlayer] = espData
end

local function removeESPForPlayer(targetPlayer)
    local espData = ESPObjects[targetPlayer]
    if not espData then return end

    for _, line in pairs(espData.box) do line:Remove() end
    if espData.name then espData.name:Remove() end
    if espData.healthBar then espData.healthBar:Remove() end
    if espData.healthFill then espData.healthFill:Remove() end
    if espData.healthText then espData.healthText:Remove() end
    if espData.distance then espData.distance:Remove() end
    if espData.tracer then espData.tracer:Remove() end
    if espData.highlight then espData.highlight:Destroy() end
    for _, line in pairs(espData.skeleton) do line:Remove() end

    ESPObjects[targetPlayer] = nil
end

local function updateESP()
    if not States.ESP then
        for _, espData in pairs(ESPObjects) do
            for _, line in pairs(espData.box) do line.Visible = false end
            if espData.name then espData.name.Visible = false end
            if espData.healthBar then espData.healthBar.Visible = false end
            if espData.healthFill then espData.healthFill.Visible = false end
            if espData.healthText then espData.healthText.Visible = false end
            if espData.distance then espData.distance.Visible = false end
            if espData.tracer then espData.tracer.Visible = false end
            if espData.highlight then espData.highlight.Enabled = false end
        end
        return
    end

    for targetPlayer, espData in pairs(ESPObjects) do
        local character = targetPlayer.Character
        if not character then
            for _, line in pairs(espData.box) do line.Visible = false end
            if espData.name then espData.name.Visible = false end
            if espData.healthBar then espData.healthBar.Visible = false end
            if espData.healthFill then espData.healthFill.Visible = false end
            if espData.healthText then espData.healthText.Visible = false end
            if espData.distance then espData.distance.Visible = false end
            if espData.tracer then espData.tracer.Visible = false end
            if espData.highlight then espData.highlight.Enabled = false end
            continue
        end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")

        if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
            for _, line in pairs(espData.box) do line.Visible = false end
            if espData.name then espData.name.Visible = false end
            if espData.healthBar then espData.healthBar.Visible = false end
            if espData.healthFill then espData.healthFill.Visible = false end
            if espData.healthText then espData.healthText.Visible = false end
            if espData.distance then espData.distance.Visible = false end
            if espData.tracer then espData.tracer.Visible = false end
            if espData.highlight then espData.highlight.Enabled = false end
            continue
        end

        local pos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
        local distance = (humanoidRootPart.Position - camera.CFrame.Position).Magnitude

        if not onScreen or distance > Values.ESPMaxDistance then
            for _, line in pairs(espData.box) do line.Visible = false end
            if espData.name then espData.name.Visible = false end
            if espData.healthBar then espData.healthBar.Visible = false end
            if espData.healthFill then espData.healthFill.Visible = false end
            if espData.healthText then espData.healthText.Visible = false end
            if espData.distance then espData.distance.Visible = false end
            if espData.tracer then espData.tracer.Visible = false end
            if espData.highlight then espData.highlight.Enabled = false end
            continue
        end

        local size = character:GetExtentsSize()
        local topPos = camera:WorldToViewportPoint((humanoidRootPart.CFrame * CFrame.new(0, size.Y/2, 0)).Position)
        local bottomPos = camera:WorldToViewportPoint((humanoidRootPart.CFrame * CFrame.new(0, -size.Y/2, 0)).Position)

        local boxHeight = bottomPos.Y - topPos.Y
        local boxWidth = boxHeight * 0.6
        local boxTopLeft = Vector2.new(topPos.X - boxWidth/2, topPos.Y)
        local boxBottomRight = Vector2.new(topPos.X + boxWidth/2, bottomPos.Y)

        -- Box ESP
        if States.BoxESP then
            espData.box[1].From = boxTopLeft
            espData.box[1].To = Vector2.new(boxBottomRight.X, boxTopLeft.Y)
            espData.box[1].Visible = true

            espData.box[2].From = Vector2.new(boxBottomRight.X, boxTopLeft.Y)
            espData.box[2].To = boxBottomRight
            espData.box[2].Visible = true

            espData.box[3].From = boxBottomRight
            espData.box[3].To = Vector2.new(boxTopLeft.X, boxBottomRight.Y)
            espData.box[3].Visible = true

            espData.box[4].From = Vector2.new(boxTopLeft.X, boxBottomRight.Y)
            espData.box[4].To = boxTopLeft
            espData.box[4].Visible = true
        else
            for _, line in pairs(espData.box) do line.Visible = false end
        end

        -- Name ESP
        if States.NameESP then
            espData.name.Text = targetPlayer.DisplayName
            espData.name.Position = Vector2.new(topPos.X, boxTopLeft.Y - 18)
            espData.name.Visible = true
        else
            espData.name.Visible = false
        end

        -- Health ESP
        if States.HealthESP then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barHeight = boxHeight * 0.8
            local barWidth = 4
            local barX = boxTopLeft.X - barWidth - 4
            local barY = boxTopLeft.Y + (boxHeight - barHeight) / 2

            espData.healthBar.Size = Vector2.new(barWidth, barHeight)
            espData.healthBar.Position = Vector2.new(barX, barY)
            espData.healthBar.Visible = true

            espData.healthFill.Size = Vector2.new(barWidth - 2, barHeight * healthPercent - 2)
            espData.healthFill.Position = Vector2.new(barX + 1, barY + barHeight * (1 - healthPercent) + 1)
            espData.healthFill.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
            espData.healthFill.Visible = true

            espData.healthText.Text = math.floor(humanoid.Health) .. " HP"
            espData.healthText.Position = Vector2.new(barX - 25, barY + barHeight/2)
            espData.healthText.Visible = true
        else
            espData.healthBar.Visible = false
            espData.healthFill.Visible = false
            espData.healthText.Visible = false
        end

        -- Distance ESP
        if States.DistanceESP then
            espData.distance.Text = math.floor(distance) .. " studs"
            espData.distance.Position = Vector2.new(topPos.X, boxBottomRight.Y + 4)
            espData.distance.Visible = true
        else
            espData.distance.Visible = false
        end

        -- Tracers
        if States.Tracers then
            espData.tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
            espData.tracer.To = Vector2.new(pos.X, pos.Y)
            espData.tracer.Visible = true
        else
            espData.tracer.Visible = false
        end

        -- Chams
        if States.Chams then
            espData.highlight.Parent = character
            espData.highlight.Enabled = true
        else
            espData.highlight.Enabled = false
        end
    end
end

-- ESP Event connections
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then createESPForPlayer(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= player then createESPForPlayer(p) end
end)

Players.PlayerRemoving:Connect(function(p)
    removeESPForPlayer(p)
end)

table.insert(ESPConnections, RunService.RenderStepped:Connect(updateESP))

-- Full Bright
local originalBrightness = Lighting.Brightness
local originalGlobalShadows = Lighting.GlobalShadows
local fullBrightConnection = nil

-- Visual Tab UI
addSection(pages["Visual"], T("Visual"))
addToggle(pages["Visual"], T("ESP"), "ESP", false, function(state)
    if state then notify("ESP", "ESP Enabled", 2) else notify("ESP", "ESP Disabled", 2) end
end)
addToggle(pages["Visual"], T("BoxESP"), "BoxESP", false)
addToggle(pages["Visual"], T("NameESP"), "NameESP", false)
addToggle(pages["Visual"], T("HealthESP"), "HealthESP", false)
addToggle(pages["Visual"], T("DistanceESP"), "DistanceESP", false)
addToggle(pages["Visual"], T("Tracers"), "Tracers", false)
addToggle(pages["Visual"], T("ChamsXRay"), "Chams", false)
addSlider(pages["Visual"], "ESP Max Distance", "ESPMaxDistance", 100, 5000, 1000)

addToggle(pages["Visual"], T("FullBright"), "FullBright", false, function(state)
    if state then
        originalBrightness = Lighting.Brightness
        originalGlobalShadows = Lighting.GlobalShadows
        Lighting.Brightness = Values.FullBrightValue
        Lighting.GlobalShadows = false
        fullBrightConnection = RunService.RenderStepped:Connect(function()
            Lighting.Brightness = Values.FullBrightValue
            Lighting.GlobalShadows = false
        end)
        notify("Full Bright", "Enabled", 2)
    else
        Lighting.Brightness = originalBrightness
        Lighting.GlobalShadows = originalGlobalShadows
        if fullBrightConnection then fullBrightConnection:Disconnect() end
        notify("Full Bright", "Disabled", 2)
    end
end)


-- ═══════════════════════════════════════════════════════════════
--  COMBAT TAB
-- ═══════════════════════════════════════════════════════════════
local aimConnection = nil
local silentAimConnection = nil
local triggerBotConnection = nil
local fovCircle = nil

local function getClosestPlayer()
    local closest = nil
    local closestDist = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p == player then continue end
        if not p.Character then continue end
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        local hum = p.Character:FindFirstChild("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then continue end

        local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
        if dist < closestDist and dist <= Values.AimFOVValue then
            closestDist = dist
            closest = p
        end
    end

    return closest
end

-- FOV Circle
local function updateFOVCircle()
    if not fovCircle then
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = false
        fovCircle.Thickness = 1
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Filled = false
        fovCircle.NumSides = 64
    end

    if States.AimFOV then
        fovCircle.Radius = Values.AimFOVValue
        fovCircle.Position = UserInputService:GetMouseLocation()
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end
end

-- Aimbot
local function startAim()
    if aimConnection then aimConnection:Disconnect() end
    aimConnection = RunService.RenderStepped:Connect(function()
        if not States.Aim then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            if States.AimPrediction then
                local velocity = target.Character.HumanoidRootPart.Velocity
                targetPos = targetPos + (velocity * Values.AimSmoothness)
            end
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
        end
    end)
end

-- Silent Aim
local function startSilentAim()
    -- Silent aim modifies bullet trajectory (game-specific implementation)
    -- This is a universal placeholder that works with most shooters
    if silentAimConnection then silentAimConnection:Disconnect() end
    silentAimConnection = RunService.RenderStepped:Connect(function()
        if not States.SilentAim then return end

        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            _G.SilentAimTarget = target.Character.Head
        else
            _G.SilentAimTarget = nil
        end
    end)
end

-- Trigger Bot
local function startTriggerBot()
    if triggerBotConnection then triggerBotConnection:Disconnect() end
    triggerBotConnection = RunService.RenderStepped:Connect(function()
        if not States.TriggerBot then return end

        local mousePos = UserInputService:GetMouseLocation()
        for _, p in ipairs(Players:GetPlayers()) do
            if p == player then continue end
            if not p.Character then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChild("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then continue end

            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if not onScreen then continue end

            if (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude < 20 then
                mouse1click()
                task.wait(0.1)
            end
        end
    end)
end

-- Hitbox Expander
local hitboxExpanded = {}
local function expandHitboxes(state)
    if state then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == player then continue end
            if not p.Character then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not hitboxExpanded[p] then
                hitboxExpanded[p] = hrp.Size
                hrp.Size = Vector3.new(Values.HitboxSize, Values.HitboxSize, Values.HitboxSize)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            end
        end
    else
        for p, originalSize in pairs(hitboxExpanded) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = originalSize
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
        hitboxExpanded = {}
    end
end

-- Combat Tab UI
addSection(pages["Combat"], T("Combat"))
addToggle(pages["Combat"], T("Aim"), "Aim", false, function(state)
    if state then startAim() notify("Aim", "Aimbot Enabled - Hold RMB", 2)
    else if aimConnection then aimConnection:Disconnect() end notify("Aim", "Aimbot Disabled", 2) end
end)

addToggle(pages["Combat"], T("SilentAim"), "SilentAim", false, function(state)
    if state then startSilentAim() notify("Silent Aim", "Enabled", 2)
    else if silentAimConnection then silentAimConnection:Disconnect() end _G.SilentAimTarget = nil notify("Silent Aim", "Disabled", 2) end
end)

addToggle(pages["Combat"], T("AimFOV"), "AimFOV", false, function(state)
    if state then notify("Aim FOV", "FOV Circle Enabled", 2)
    else if fovCircle then fovCircle.Visible = false end notify("Aim FOV", "Disabled", 2) end
end)

addSlider(pages["Combat"], "Aim FOV Size", "AimFOVValue", 50, 500, 100, function(val)
    if fovCircle then fovCircle.Radius = val end
end)

addSlider(pages["Combat"], "Aim Smoothness", "AimSmoothness", 0, 1, 0.1)

addToggle(pages["Combat"], T("AimPrediction"), "AimPrediction", false)

addToggle(pages["Combat"], T("TriggerBot"), "TriggerBot", false, function(state)
    if state then startTriggerBot() notify("Trigger Bot", "Enabled", 2)
    else if triggerBotConnection then triggerBotConnection:Disconnect() end notify("Trigger Bot", "Disabled", 2) end
end)

addToggle(pages["Combat"], T("HitboxExpander"), "HitboxExpander", false, function(state)
    expandHitboxes(state)
    if state then notify("Hitbox", "Expanded to " .. Values.HitboxSize, 2)
    else notify("Hitbox", "Reset", 2) end
end)

addSlider(pages["Combat"], "Hitbox Size", "HitboxSize", 2, 20, 5, function(val)
    if States.HitboxExpander then expandHitboxes(true) end
end)

-- ═══════════════════════════════════════════════════════════════
--  MOVEMENT TAB
-- ═══════════════════════════════════════════════════════════════
local flyConnection = nil
local noclipConnection = nil
local speedConnection = nil
local jumpConnection = nil
local sprintConnection = nil
local antiVoidConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

-- Speed
local function startSpeed()
    if speedConnection then speedConnection:Disconnect() end
    speedConnection = RunService.RenderStepped:Connect(function()
        if not States.Speed then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            hum.WalkSpeed = Values.SpeedValue
        else
            hum.WalkSpeed = 16
        end
    end)
end

-- Fly
local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 10000
    flyBodyGyro.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not States.Fly then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local velocity = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity = velocity - Vector3.new(0, 1, 0) end

        if flyBodyVelocity then
            flyBodyVelocity.Velocity = velocity.Unit * Values.FlySpeed
        end
        if flyBodyGyro then
            flyBodyGyro.CFrame = camera.CFrame
        end
    end)
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect() end
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    flyBodyVelocity = nil
    flyBodyGyro = nil
end

-- Noclip
local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(function()
        if not States.Noclip then return end
        local char = player.Character
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

-- Infinite Jump
local function startInfiniteJump()
    if jumpConnection then jumpConnection:Disconnect() end
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if not States.InfiniteJump then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- Sprint
local function startSprint()
    if sprintConnection then sprintConnection:Disconnect() end
    sprintConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not States.Sprint then return end
        if input.KeyCode == Enum.KeyCode.LeftShift then
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = Values.SprintSpeed end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
    end)
end

-- Anti Void
local function startAntiVoid()
    if antiVoidConnection then antiVoidConnection:Disconnect() end
    antiVoidConnection = RunService.RenderStepped:Connect(function()
        if not States.AntiVoid then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 10, hrp.Position.Z)
            notify("Anti Void", "Teleported back up!", 2)
        end
    end)
end

-- Click Teleport
local clickTeleportConnection = nil
local function startClickTeleport()
    if clickTeleportConnection then clickTeleportConnection:Disconnect() end
    clickTeleportConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not States.ClickTeleport then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local ray = camera:ViewportPointToRay(mouse.X, mouse.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
            if result then
                hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                notify("Click Teleport", "Teleported!", 2)
            end
        end
    end)
end

-- Movement Tab UI
addSection(pages["Movement"], T("Movement"))

addToggle(pages["Movement"], T("Speed"), "Speed", false, function(state)
    if state then startSpeed() notify("Speed", "Speed set to " .. Values.SpeedValue, 2)
    else if speedConnection then speedConnection:Disconnect() end
        local char = player.Character
        if char then local hum = char:FindFirstChild("Humanoid") if hum then hum.WalkSpeed = 16 end end
        notify("Speed", "Disabled", 2)
    end
end)
addSlider(pages["Movement"], "Speed Value", "SpeedValue", 16, 200, 50)

addToggle(pages["Movement"], T("Fly"), "Fly", false, function(state)
    if state then startFly() notify("Fly", "Fly Enabled - WASD to move, Space/Shift up/down", 3)
    else stopFly() notify("Fly", "Disabled", 2) end
end)
addSlider(pages["Movement"], "Fly Speed", "FlySpeed", 10, 200, 50)

addToggle(pages["Movement"], T("Noclip"), "Noclip", false, function(state)
    if state then startNoclip() notify("Noclip", "Enabled", 2)
    else if noclipConnection then noclipConnection:Disconnect() end
        local char = player.Character
        if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
        notify("Noclip", "Disabled", 2)
    end
end)

addToggle(pages["Movement"], T("JumpPower"), "JumpPower", false, function(state)
    local char = player.Character
    if char then local hum = char:FindFirstChild("Humanoid") if hum then hum.JumpPower = state and Values.JumpPowerValue or 50 end end
    notify("Jump Power", state and "Set to " .. Values.JumpPowerValue or "Reset", 2)
end)
addSlider(pages["Movement"], "Jump Power Value", "JumpPowerValue", 50, 300, 100, function(val)
    if States.JumpPower then
        local char = player.Character
        if char then local hum = char:FindFirstChild("Humanoid") if hum then hum.JumpPower = val end end
    end
end)

addToggle(pages["Movement"], T("InfiniteJump"), "InfiniteJump", false, function(state)
    if state then startInfiniteJump() notify("Infinite Jump", "Enabled", 2)
    else if jumpConnection then jumpConnection:Disconnect() end notify("Infinite Jump", "Disabled", 2) end
end)

addToggle(pages["Movement"], T("Teleport"), "Teleport", false, function(state)
    if state then
        notify("Teleport", "Click anywhere to teleport!", 3)
        mouse.KeyDown:Connect(function(key)
            if key == Values.TeleportKey:lower() and States.Teleport then
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                        notify("Teleport", "Teleported!", 2)
                    end
                end
            end
        end)
    end
end)

addToggle(pages["Movement"], T("ClickTeleport"), "ClickTeleport", false, function(state)
    if state then startClickTeleport() notify("Click Teleport", "Enabled - Click to teleport", 2)
    else if clickTeleportConnection then clickTeleportConnection:Disconnect() end notify("Click Teleport", "Disabled", 2) end
end)

addToggle(pages["Movement"], T("Sprint"), "Sprint", false, function(state)
    if state then startSprint() notify("Sprint", "Hold Shift to sprint at " .. Values.SprintSpeed, 2)
    else if sprintConnection then sprintConnection:Disconnect() end notify("Sprint", "Disabled", 2) end
end)
addSlider(pages["Movement"], "Sprint Speed", "SprintSpeed", 30, 150, 70)

addToggle(pages["Movement"], T("AntiVoid"), "AntiVoid", false, function(state)
    if state then startAntiVoid() notify("Anti Void", "Enabled", 2)
    else if antiVoidConnection then antiVoidConnection:Disconnect() end notify("Anti Void", "Disabled", 2) end
end)


-- ═══════════════════════════════════════════════════════════════
--  UTILITY TAB
-- ═══════════════════════════════════════════════════════════════
local antiAFKConnection = nil
local antiAFKLastMove = tick()

local function startAntiAFK()
    if antiAFKConnection then antiAFKConnection:Disconnect() end
    antiAFKConnection = RunService.RenderStepped:Connect(function()
        if not States.AntiAFK then return end
        if tick() - antiAFKLastMove > 120 then
            antiAFKLastMove = tick()
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum:Move(Vector3.new(0.1, 0, 0), true)
                    task.wait(0.1)
                    hum:Move(Vector3.new(-0.1, 0, 0), true)
                end
            end
        end
    end)

    UserInputService.InputBegan:Connect(function()
        antiAFKLastMove = tick()
    end)
end

-- Freeze Time (Slows down game)
local originalTimeScale = 1
local freezeTimeConnection = nil

local function startFreezeTime()
    if freezeTimeConnection then freezeTimeConnection:Disconnect() end
    freezeTimeConnection = RunService.RenderStepped:Connect(function()
        if not States.FreezeTime then return end
        -- This attempts to slow down physics (may not work in all games)
        local success = pcall(function()
            game:GetService("RunService").Heartbeat:Wait(0.05)
        end)
    end)
end

-- FPS Booster
local fpsBoosted = false
local function boostFPS(state)
    if state and not fpsBoosted then
        fpsBoosted = true
        -- Lower graphics settings
        local success = pcall(function()
            settings().Rendering.QualityLevel = 1
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
                if v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then
                    v.Enabled = false
                end
            end
        end)
        if success then notify("FPS Booster", "Graphics optimized!", 2) end
    elseif not state and fpsBoosted then
        fpsBoosted = false
        notify("FPS Booster", "Reset (restart game to restore)", 2)
    end
end

-- Utility Tab UI
addSection(pages["Utility"], T("Utility"))

addToggle(pages["Utility"], T("AntiAFK"), "AntiAFK", false, function(state)
    if state then startAntiAFK() notify("Anti AFK", "Enabled - Will move every 2 min", 2)
    else if antiAFKConnection then antiAFKConnection:Disconnect() end notify("Anti AFK", "Disabled", 2) end
end)

addToggle(pages["Utility"], T("FreezeTime"), "FreezeTime", false, function(state)
    if state then startFreezeTime() notify("Freeze Time", "Enabled (experimental)", 2)
    else if freezeTimeConnection then freezeTimeConnection:Disconnect() end notify("Freeze Time", "Disabled", 2) end
end)

addToggle(pages["Utility"], T("FPSBooster"), "FPSBooster", false, function(state)
    boostFPS(state)
end)

-- ═══════════════════════════════════════════════════════════════
--  SERVER TAB
-- ═══════════════════════════════════════════════════════════════
addSection(pages["Server"], T("Server"))

addButton(pages["Server"], T("RejoinServer"), function()
    notify("Server", "Rejoining...", 2)
    TeleportService:Teleport(game.PlaceId, player)
end)

addButton(pages["Server"], T("ServerHop"), function()
    notify("Server", "Finding new server...", 2)
    local success, result = pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if servers and servers.data then
            for _, server in ipairs(servers.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                    return
                end
            end
        end
    end)
    if not success then notify("Server Hop", "Failed - try again", 3) end
end)

addButton(pages["Server"], T("JoinSmallServer"), function()
    notify("Server", "Finding small server...", 2)
    local success, result = pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if servers and servers.data then
            local smallest = nil
            for _, server in ipairs(servers.data) do
                if server.id ~= game.JobId then
                    if not smallest or server.playing < smallest.playing then
                        smallest = server
                    end
                end
            end
            if smallest then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, smallest.id, player)
            end
        end
    end)
    if not success then notify("Join Small Server", "Failed", 3) end
end)

-- Player List
addSection(pages["Server"], T("PlayerList"))
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, 0, 0, 120)
playerListFrame.BackgroundColor3 = getTheme().rowBg
playerListFrame.BorderSizePixel = 0
playerListFrame.LayoutOrder = #pages["Server"]:GetChildren() * 10 + 1
playerListFrame.Parent = pages["Server"]

local plCorner = Instance.new("UICorner")
plCorner.CornerRadius = UDim.new(0, 8)
plCorner.Parent = playerListFrame

local plScrolling = Instance.new("ScrollingFrame")
plScrolling.Size = UDim2.new(1, -8, 1, -8)
plScrolling.Position = UDim2.new(0, 4, 0, 4)
plScrolling.BackgroundTransparency = 1
plScrolling.BorderSizePixel = 0
plScrolling.ScrollBarThickness = 3
plScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
plScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
plScrolling.Parent = playerListFrame

local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 2)
plLayout.SortOrder = Enum.SortOrder.LayoutOrder
plLayout.Parent = plScrolling

local function updatePlayerList()
    for _, child in pairs(plScrolling:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 24)
        btn.BackgroundColor3 = getTheme().inputBg
        btn.AutoButtonColor = false
        btn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextColor3 = getTheme().text
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = p.UserId
        btn.Parent = plScrolling

        local btnPad = Instance.new("UIPadding")
        btnPad.PaddingLeft = UDim.new(0, 8)
        btnPad.Parent = btn

        btn.MouseButton1Click:Connect(function()
            notify("Player", "Selected: " .. p.DisplayName, 2)
            _G.SelectedPlayer = p
        end)
    end
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Spectate Player
addSection(pages["Server"], T("SpectatePlayer"))
addButton(pages["Server"], "Spectate Selected Player", function()
    if _G.SelectedPlayer and _G.SelectedPlayer.Character then
        camera.CameraSubject = _G.SelectedPlayer.Character:FindFirstChild("Humanoid") or _G.SelectedPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        notify("Spectate", "Now spectating " .. _G.SelectedPlayer.DisplayName, 2)
    else
        notify("Spectate", "No player selected!", 2)
    end
end)

addButton(pages["Server"], "Stop Spectating", function()
    local char = player.Character
    if char then
        camera.CameraSubject = char:FindFirstChild("Humanoid") or char:FindFirstChildWhichIsA("Humanoid")
        notify("Spectate", "Stopped spectating", 2)
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  FUN TAB
-- ═══════════════════════════════════════════════════════════════
local spinConnection = nil
local floatConnection = nil
local bangConnection = nil
local flingConnection = nil
local orbitConnection = nil
local invisibleConnection = nil

addSection(pages["Fun"], T("Fun"))

addToggle(pages["Fun"], T("Spin"), "Spin", false, function(state)
    if state then
        if spinConnection then spinConnection:Disconnect() end
        spinConnection = RunService.RenderStepped:Connect(function()
            if not States.Spin then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Values.SpinSpeed * 0.1), 0)
            end
        end)
        notify("Spin", "Spinning!", 2)
    else
        if spinConnection then spinConnection:Disconnect() end
        notify("Spin", "Stopped", 2)
    end
end)
addSlider(pages["Fun"], "Spin Speed", "SpinSpeed", 10, 200, 50)

addToggle(pages["Fun"], T("Float"), "Float", false, function(state)
    if state then
        if floatConnection then floatConnection:Disconnect() end
        floatConnection = RunService.RenderStepped:Connect(function()
            if not States.Float then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y + math.sin(tick() * 2) * 0.5, hrp.Position.Z)
            end
        end)
        notify("Float", "Floating!", 2)
    else
        if floatConnection then floatConnection:Disconnect() end
        notify("Float", "Stopped", 2)
    end
end)

addToggle(pages["Fun"], T("Bang"), "Bang", false, function(state)
    if state then
        if bangConnection then bangConnection:Disconnect() end
        bangConnection = RunService.RenderStepped:Connect(function()
            if not States.Bang then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.new(0, math.sin(tick() * 10) * 0.3, 0)
            end
        end)
        notify("Bang", "Banging!", 2)
    else
        if bangConnection then bangConnection:Disconnect() end
        notify("Bang", "Stopped", 2)
    end
end)

addToggle(pages["Fun"], T("Fling"), "Fling", false, function(state)
    if state then
        if flingConnection then flingConnection:Disconnect() end
        flingConnection = RunService.RenderStepped:Connect(function()
            if not States.Fling then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(math.random(-500, 500), math.random(0, 500), math.random(-500, 500))
            end
        end)
        notify("Fling", "Flinging!", 2)
    else
        if flingConnection then flingConnection:Disconnect() end
        local char = player.Character
        if char then local hrp = char:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end end
        notify("Fling", "Stopped", 2)
    end
end)

addToggle(pages["Fun"], T("OrbitPlayer"), "OrbitPlayer", false, function(state)
    if state then
        if not _G.SelectedPlayer then
            notify("Orbit", "Select a player first!", 2)
            States.OrbitPlayer = false
            return
        end
        if orbitConnection then orbitConnection:Disconnect() end
        local angle = 0
        orbitConnection = RunService.RenderStepped:Connect(function()
            if not States.OrbitPlayer then return end
            local char = player.Character
            local targetChar = _G.SelectedPlayer and _G.SelectedPlayer.Character
            if not char or not targetChar then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
            if not hrp or not targetHrp then return end

            angle = angle + math.rad(Values.OrbitSpeed * 0.05)
            local offset = Vector3.new(math.cos(angle) * Values.OrbitRadius, 0, math.sin(angle) * Values.OrbitRadius)
            hrp.CFrame = CFrame.new(targetHrp.Position + offset, targetHrp.Position)
        end)
        notify("Orbit", "Orbiting " .. _G.SelectedPlayer.DisplayName, 2)
    else
        if orbitConnection then orbitConnection:Disconnect() end
        notify("Orbit", "Stopped", 2)
    end
end)
addSlider(pages["Fun"], "Orbit Radius", "OrbitRadius", 5, 50, 10)
addSlider(pages["Fun"], "Orbit Speed", "OrbitSpeed", 10, 200, 50)

addToggle(pages["Fun"], T("Invisible"), "Invisible", false, function(state)
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = state and 1 or 0
        end
        if part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = state and 1 or 0
        end
    end
    notify("Invisible", state and "You are invisible!" or "Visible again", 2)
end)


-- ═══════════════════════════════════════════════════════════════
--  SETTINGS TAB (Theme, Language, GUI)
-- ═══════════════════════════════════════════════════════════════
addSection(pages["Settings"], T("Theme"))

addDropdown(pages["Settings"], "Select Theme", {"Dark", "Light", "Sky Blue", "Galaxy"}, currentTheme, function(selected)
    currentTheme = selected
    local theme = getTheme()

    mainFrame.BackgroundColor3 = theme.bg
    titleBar.BackgroundColor3 = theme.titleBar
    titleFix.BackgroundColor3 = theme.titleBar
    tabContainer.BackgroundColor3 = theme.tabContainer
    mainStroke.Color = theme.stroke

    for _, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = theme.tabBtn
        btn.TextColor3 = theme.text
    end

    -- Update all existing UI elements
    for _, page in pairs(pages) do
        for _, child in pairs(page:GetChildren()) do
            if child:IsA("Frame") and child.BackgroundColor3 ~= Color3.fromRGB(0,0,0) then
                if child.Name:find("Row") or child.BackgroundTransparency == 0 then
                    child.BackgroundColor3 = theme.rowBg
                end
            end
            if child:IsA("TextLabel") then
                if child.TextColor3.R > 0.5 then
                    child.TextColor3 = theme.text
                else
                    child.TextColor3 = theme.textDim
                end
            end
        end
    end

    notify("Theme", "Changed to " .. selected, 2)
end)

addSection(pages["Settings"], T("Language"))

addDropdown(pages["Settings"], "Select Language", {"English", "Tiếng Việt", "Español", "Português", "Русский"}, currentLang, function(selected)
    currentLang = selected

    -- Update tab buttons
    for name, btn in pairs(tabButtons) do
        btn.Text = T(name)
    end

    -- Update page headers (first child is usually the section header)
    for name, page in pairs(pages) do
        for _, child in pairs(page:GetChildren()) do
            if child:IsA("TextLabel") and child.LayoutOrder == 0 then
                child.Text = T(name)
            end
        end
    end

    notify("Language", "Changed to " .. selected, 2)
end)

addSection(pages["Settings"], T("GUI"))

-- Save Settings
addButton(pages["Settings"], T("SaveSettings"), function()
    local settings = {
        states = {},
        values = Values,
        theme = currentTheme,
        language = currentLang,
    }
    for k, v in pairs(States) do
        if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
            settings.states[k] = v
        end
    end

    local success = pcall(function()
        writefile("FLUYEN_settings.json", HttpService:JSONEncode(settings))
    end)

    if success then
        notify("Save Settings", "Settings saved successfully!", 2)
    else
        notify("Save Settings", "Failed to save settings", 2)
    end
end)

-- Auto Load Settings
addToggle(pages["Settings"], T("AutoLoadSettings"), "AutoLoadSettings", false, function(state)
    if state then
        notify("Auto Load", "Settings will auto-load on startup", 2)
    end
end)

-- Reset Settings
addButton(pages["Settings"], T("ResetSettings"), function()
    for k, v in pairs(States) do
        if type(v) == "boolean" then
            States[k] = false
        end
    end
    Values.SpeedValue = 50
    Values.JumpPowerValue = 100
    Values.FlySpeed = 50
    Values.AimFOVValue = 100
    Values.HitboxSize = 5

    notify("Reset", "All settings reset!", 2)
end)

-- Minimize Button
addToggle(pages["Settings"], T("MinimizeButton"), "MinimizeButton", true)

-- Draggable GUI
addToggle(pages["Settings"], T("DraggableGUI"), "DraggableGUI", true)

-- Toggle Keybind
addInfoRow(pages["Settings"], T("ToggleKeybind"), "3-Finger Tap x3")

-- Notifications
addToggle(pages["Settings"], T("Notifications"), "Notifications", true)

-- ═══════════════════════════════════════════════════════════════
--  MINIMIZE BUTTON (Floating)
-- ═══════════════════════════════════════════════════════════════
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MinimizeBtn"
miniBtn.Size = UDim2.new(0, 40, 0, 40)
miniBtn.Position = UDim2.new(0, 20, 0, 20)
miniBtn.BackgroundColor3 = getTheme().accent
miniBtn.Text = "F"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 18
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.AutoButtonColor = false
miniBtn.Visible = false
miniBtn.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = miniBtn

miniBtn.MouseButton1Click:Connect(function()
    toggleMenu()
end)

-- ═══════════════════════════════════════════════════════════════
--  OPEN / CLOSE ANIMATIONS
-- ═══════════════════════════════════════════════════════════════
local isOpen = false
local isAnimating = false

local OPEN_INFO  = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local CLOSE_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local FADE_INFO  = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local function openMenu()
    if isOpen or isAnimating then return end
    isAnimating = true
    isOpen = true

    uiScale.Scale = 0
    mainFrame.Visible = true
    backdrop.Visible = true
    backdrop.BackgroundTransparency = 1
    miniBtn.Visible = false

    TweenService:Create(uiScale, OPEN_INFO, {Scale = 1}):Play()
    TweenService:Create(backdrop, FADE_INFO, {BackgroundTransparency = 0.45}):Play()

    task.delay(OPEN_INFO.Time, function() isAnimating = false end)
end

local function closeMenu()
    if not isOpen or isAnimating then return end
    isAnimating = true
    isOpen = false

    local tween = TweenService:Create(uiScale, CLOSE_INFO, {Scale = 0})
    TweenService:Create(backdrop, CLOSE_INFO, {BackgroundTransparency = 1}):Play()
    tween:Play()
    tween.Completed:Connect(function()
        mainFrame.Visible = false
        backdrop.Visible = false
        isAnimating = false
        if States.MinimizeButton then
            miniBtn.Visible = true
        end
    end)
end

local function toggleMenu()
    if isOpen then closeMenu() else openMenu() end
end

backdropClose.MouseButton1Click:Connect(closeMenu)
closeBtn.MouseButton1Click:Connect(closeMenu)
minimizeBtn.MouseButton1Click:Connect(closeMenu)

-- ═══════════════════════════════════════════════════════════════
--  GESTURE: 3 FINGERS x 3 TAPS
-- ═══════════════════════════════════════════════════════════════
local activeTouches = {}
local activeCount = 0
local reachedRequired = false

local function onGestureTap()
    local now = os.clock()

    if now - lastTapTime > TAP_WINDOW then
        tapCount = 0
    end

    tapCount += 1
    lastTapTime = now

    if tapCount >= REQUIRED_TAPS then
        tapCount = 0
        toggleMenu()
    end
end

UserInputService.TouchStarted:Connect(function(touch, gameProcessedEvent)
    if gameProcessedEvent then return end

    activeTouches[touch] = true
    activeCount += 1

    if activeCount == REQUIRED_FINGERS and not reachedRequired then
        reachedRequired = true
        onGestureTap()
    end
end)

UserInputService.TouchEnded:Connect(function(touch, _gameProcessedEvent)
    if activeTouches[touch] then
        activeTouches[touch] = nil
        activeCount = math.max(0, activeCount - 1)
    end

    if activeCount < REQUIRED_FINGERS then
        reachedRequired = false
    end
end)

-- Keyboard toggle (Insert key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleMenu()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  AUTO LOAD SETTINGS
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(2)
    local success, data = pcall(function()
        return readfile("FLUYEN_settings.json")
    end)

    if success and data then
        local settings = HttpService:JSONDecode(data)
        if settings then
            if settings.theme then currentTheme = settings.theme end
            if settings.language then currentLang = settings.language end
            if settings.values then
                for k, v in pairs(settings.values) do
                    Values[k] = v
                end
            end
            if States.AutoLoadSettings and settings.states then
                for k, v in pairs(settings.states) do
                    States[k] = v
                end
            end
            notify("Auto Load", "Settings loaded!", 2)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  UPDATE FOV CIRCLE
-- ═══════════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    if fovCircle then
        updateFOVCircle()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  INITIAL NOTIFICATION
-- ═══════════════════════════════════════════════════════════════
task.wait(1)
notify(SCRIPT_NAME, SCRIPT_VERSION .. " loaded! Tap 3 fingers x3 to open", 4)
