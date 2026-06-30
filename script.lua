-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Ultimate Custom Boombox 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- HỆ THỐNG ÂM THANH KÉP BASS ĐẬP ẤM
local SoundGroup = Instance.new("SoundGroup", SoundService)
SoundGroup.Name = "ThanhPhucAudioGroup"
SoundGroup.Volume = 2

local EQ = Instance.new("EqualizerSoundEffect", SoundGroup)
EQ.LowGain = 9
EQ.MidGain = 1
EQ.HighGain = -3

local Sound1 = Instance.new("Sound", workspace)
Sound1.Name = "TP_Channel_Left"
Sound1.Looped = true
Sound1.SoundGroup = SoundGroup

local BoomboxPart = nil
local LedOutline = nil
local TagGui = nil
local NameLabel = nil
local IsPlayingMusic = false
local VisualConnection = nil

local function DestroyOldBoombox()
    if VisualConnection then VisualConnection:Disconnect() VisualConnection = nil end
    if BoomboxPart then pcall(function() BoomboxPart:Destroy() end) end
    if TagGui then pcall(function() TagGui:Destroy() end) end
    BoomboxPart = nil
    TagGui = nil
end

local function CreateCustomBoombox()
    DestroyOldBoombox()
    
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not root then return end
    
    -- 1. TẠO KHỐI LOA MÀU ĐEN ĐẶC CHUẨN XÁC
    BoomboxPart = Instance.new("Part")
    BoomboxPart.Name = "ThanhPhuc_BackBoombox"
    BoomboxPart.Size = Vector3.new(2.4, 1.4, 0.8) 
    BoomboxPart.Color = Color3.fromRGB(15, 15, 15) -- Màu đen đặc hoàn toàn
    BoomboxPart.Material = Enum.Material.SmoothPlastic
    BoomboxPart.CanCollide = false
    BoomboxPart.Anchored = true
    BoomboxPart.Parent = character
    
    -- 2. Viền LED Cầu Vồng Bao Quanh Khối Đen
    LedOutline = Instance.new("SelectionBox")
    LedOutline.Name = "Boombox_LED"
    LedOutline.Adornee = BoomboxPart
    LedOutline.LineThickness = 0.06
    LedOutline.SurfaceTransparency = 1
    LedOutline.Parent = BoomboxPart
    
    -- 3. BẢNG TÊN TRÊN ĐỈNH LOA (Không sợ bị khối đen lấp mất chữ)
    TagGui = Instance.new("BillboardGui")
    TagGui.Name = "ThanhPhucTextTag"
    TagGui.Adornee = BoomboxPart
    TagGui.Size = UDim2.new(0, 200, 0, 50)
    TagGui.StudsOffset = Vector3.new(0, 1.1, 0) -- Đẩy chữ lên phía trên đỉnh loa hẳn để lộ rõ chữ
    TagGui.AlwaysOnTop = true -- Xuyên thấu giúp chữ luôn hiện trên cùng
    TagGui.Parent = BoomboxPart
    
    NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Thanh Phuc"
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextScaled = true
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    
    -- Tạo bóng mờ cho chữ dễ đọc hơn trên nền sáng
    local UIStrokeText = Instance.new("UIStroke", NameLabel)
    UIStrokeText.Thickness = 1.5
    UIStrokeText.Color = Color3.fromRGB(0, 0, 0)
    
    NameLabel.Parent = TagGui

    -- VÒNG LẶP ĐỒNG BỘ ĐẬP THEO PHÁT ÂM THANH REALTIME
    local hue = 0
    local baseSize = Vector3.new(2.4, 1.4, 0.8)
    
    VisualConnection = RunService.RenderStepped:Connect(function()
        if not character or not character:Parent() or not root:Parent() then 
            DestroyOldBoombox()
            return 
        end
        
        -- Cập nhật vị trí loa khóa chắc chắn ở sau lưng
        BoomboxPart.CFrame = root.CFrame * CFrame.new(0, 0.4, 0.7)
        
        -- Nhịp điệu đập dựa trên PlaybackLoudness thực tế
        local loudness = Sound1.PlaybackLoudness
        local intensity = math.clamp(loudness / 280, 0, 1) 
        
        -- Chạy hiệu ứng màu cầu vồng chớp sáng lung linh cho cả Viền và Chữ
        hue = (hue + 1.2) % 360
        local rainbowColor = Color3.fromHSV(hue / 360, 0.9, 0.6 + (intensity * 0.4)) 
        
        LedOutline.Color3 = rainbowColor
        NameLabel.TextColor3 = rainbowColor
        
        -- Khối loa đen co giãn nảy mạnh vừa phải theo nhịp bass
        local scaleFactor = 1 + (intensity * 0.1) 
        BoomboxPart.Size = baseSize * scaleFactor
    end)
end

Players.LocalPlayer.CharacterAdded:Connect(function()
    if IsPlayingMusic then 
        task.wait(0.8) 
        CreateCustomBoombox() 
    end
end)

-- GIAO DIỆN STYLE MENU ĐỒNG BỘ
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 230)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Draggable = true
MainFrame.Active = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
coroutine.wrap(function()
    local h = 0
    while task.wait() do h = (h + 1) % 360 UIStroke.Color = Color3.fromHSV(h/360, 1, 0.8) end
end)()

local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
HideBtn.Text = "×"
HideBtn.TextColor3 = Color3.new(1, 1, 1)
HideBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", HideBtn)
HideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 15, 0.5, 0)
OpenBtn.Text = "TP 🎵"
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 16
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenBtn.Draggable = true
OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 15)
local ButtonStroke = Instance.new("UIStroke", OpenBtn)
ButtonStroke.Thickness = 2
coroutine.wrap(function()
    local h = 0
    while task.wait() do h = (h + 1.5) % 360 ButtonStroke.Color = Color3.fromHSV(h/360, 1, 0.8) end
end)()
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Text = "🎵 THANH PHÚC"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.25, 0)
InputBox.PlaceholderText = "Nhập ID nhạc..."
InputBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox)

local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.9, 0, 0, 45)
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "ÉP HIỆN THỊ BOOMBOX"
PlayBtn.Font = Enum.Font.SourceSansBold
PlayBtn.TextSize = 15
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Instance.new("UICorner", PlayBtn)

PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        local assetURI = "rbxassetid://" .. cleanID
        Sound1.SoundId = assetURI
        Sound1:Play()
        IsPlayingMusic = true
        CreateCustomBoombox()
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID lỗi!"
    end
end)
