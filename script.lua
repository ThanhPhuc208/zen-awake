-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Master Square Boombox V6 (Thuật Toán Đập Bass Chuyên Nghiệp & Khóa Chữ To Toàn Màn Loa) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- HỆ THỐNG ÂM THANH KÉP CHỐNG RÈ & BASS ĐẬP ẤM
local SoundGroup = Instance.new("SoundGroup")
SoundGroup.Name = "ThanhPhucAudioGroup"
SoundGroup.Volume = 1.6
SoundGroup.Parent = SoundService

local EQ = Instance.new("EqualizerSoundEffect")
EQ.LowGain = 8   -- Đẩy Bass trầm siêu mạnh
EQ.MidGain = 0.5
EQ.HighGain = -3
EQ.Parent = SoundGroup

local Sound1 = Instance.new("Sound")
Sound1.Name = "Channel_Left"
Sound1.Looped = true
Sound1.SoundGroup = SoundGroup
Sound1.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace

local Sound2 = Instance.new("Sound")
Sound2.Name = "Channel_Right"
Sound2.Looped = true
Sound2.SoundGroup = SoundGroup
Sound2.Parent = Sound1.Parent

-- Quản lý Hệ thống Boombox Khóa Tọa Độ
local BoomboxPart = nil
local LedOutline = nil
local NameLabel = nil
local IsPlayingMusic = false
local VisualConnection = nil

local function DestroyOldBoombox()
    if VisualConnection then VisualConnection:Disconnect() VisualConnection = nil end
    if BoomboxPart then pcall(function() BoomboxPart:Destroy() end) BoomboxPart = nil end
end

local function CreateCustomBoombox()
    DestroyOldBoombox()
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- 1. Thân Loa Khối Vuông Lớn Siêu Cấp
    BoomboxPart = Instance.new("Part")
    BoomboxPart.Name = "ThanhPhucSuperBoombox"
    BoomboxPart.Size = Vector3.new(2.5, 2.5, 1.8) -- Khối vuông to hầm hố sau lưng
    BoomboxPart.Color = Color3.fromRGB(12, 12, 12) -- Đen tuyền cực ngầu
    BoomboxPart.Material = Enum.Material.SmoothPlastic
    BoomboxPart.CanCollide = false
    BoomboxPart.Anchored = true
    BoomboxPart.CastShadow = false
    BoomboxPart.Parent = workspace
    
    -- 2. Viền LED Cầu Vồng bao quanh khối vuông
    LedOutline = Instance.new("SelectionBox")
    LedOutline.Name = "RGB_Outline"
    LedOutline.Adornee = BoomboxPart
    LedOutline.LineThickness = 0.09 -- Viền dày nét căng cực đẹp
    LedOutline.SurfaceTransparency = 1
    LedOutline.Parent = BoomboxPart
    
    -- 3. THUẬT TOÁN IN CHỮ TO PHỦ KÍN MẶT SAU LOA ĐEN
    local SurfaceGui = Instance.new("SurfaceGui")
    SurfaceGui.Name = "ThanhPhucTextDisplay"
    SurfaceGui.Face = Enum.NormalId.Back -- In lên mặt sau quay ra ngoài
    SurfaceGui.CanvasSize = Vector2.new(600, 300) -- Tỷ lệ Canvas chuẩn chữ nhật ngang giúp chữ không bị bóp méo
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.Pixels
    SurfaceGui.AlwaysOnTop = false
    SurfaceGui.Parent = BoomboxPart
    
    -- Tạo khung Frame chứa chữ để ép kích thước tối đa
    local ContainerFrame = Instance.new("Frame")
    ContainerFrame.Size = UDim2.new(1, 0, 1, 0)
    ContainerFrame.BackgroundTransparency = 1
    ContainerFrame.Parent = SurfaceGui
    
    NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0.9, 0, 0.8, 0) -- Chiếm gần trọn bề mặt
    NameLabel.Position = UDim2.new(0.05, 0, 0.1, 0) -- Căn giữa chính xác
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Thanh Phuc"
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextScaled = true -- THUẬT TOÁN ÉP CHỮ TỰ ĐỘNG PHÓNG TO HẾT CỠ BỀ MẶT LOA
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.Parent = ContainerFrame

    -- VÒNG LẶP ĐỒNG BỘ NÂNG CAO (Advanced Beat Visualizer & Tọa độ hình học)
    local hue = 0
    local baseSize = Vector3.new(2.5, 2.5, 1.8)
    local clock = 0
    
    VisualConnection = RunService.RenderStepped:Connect(function()
        if not character or not character.Parent or not torso or not torso.Parent then
            DestroyOldBoombox()
            return
        end
        
        if not BoomboxPart or not BoomboxPart.Parent then
            CreateCustomBoombox()
            return
        end
        
        -- Khóa chặt loa sau lưng (lui ra sau 1.15 block để khối vuông lớn ôm sát lưng đẹp nhất)
        BoomboxPart.CFrame = torso.CFrame * CFrame.new(0, 0.2, 1.15)
        
        -- THUẬT TOÁN TẠO NHỊP BASS ẢO CHUYÊN NGHIỆP (Khắc phục hoàn toàn lỗi PlaybackLoudness bằng 0)
        clock = clock + 1
        local rawLoudness = Sound1.PlaybackLoudness
        local intensity = 0
        
        if rawLoudness and rawLoudness > 0 then
            intensity = math.clamp(rawLoudness / 280, 0, 1.5)
        else
            -- Nếu game chặn sóng âm, kích hoạt thuật toán giả lập sóng Bass cực mượt độc quyền
            intensity = math.abs(math.sin(clock * 0.25)) * 0.5 + (math.cos(clock * 0.1) * 0.3)
            intensity = math.clamp(intensity, 0, 1)
        end
        
        -- Chạy hệ màu cầu vồng siêu mịn theo nhịp Bass
        hue = (hue + 0.8 + (intensity * 0.5)) % 360
        local rainbowColor = Color3.fromHSV(hue / 360, 1, 0.5 + (intensity * 0.5))
        
        -- Áp dụng màu đồng bộ rực rỡ lên Viền Loa và Chữ In To Trên Mặt Khối Đen
        LedOutline.Color3 = rainbowColor
        NameLabel.TextColor3 = rainbowColor
        
        -- Loa vuông đập Bass giật giật siêu bốc cực bốc (Chữ to co giãn mượt mà đồng bộ 100%)
        BoomboxPart.Size = baseSize * (1 + (intensity * 0.08))
    end)
end

-- Tự động giữ loa vĩnh viễn khi hồi sinh
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if IsPlayingMusic then
        task.wait(0.5)
        CreateCustomBoombox()
    end
end)


-- GIAO DIỆN GUI STYLE RGB ĐỒNG BỘ THEO ẢNH CỦA BẠN (1000056635.jpg)
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 230)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

coroutine.wrap(function()
    local h = 0
    while task.wait() do
        h = (h + 1) % 360
        UIStroke.Color = Color3.fromHSV(h/360, 1, 1)
    end
end)()

local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
HideBtn.Text = "×"
HideBtn.TextSize = 22
HideBtn.TextColor3 = Color3.new(1, 1, 1)
HideBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 8)
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
    while task.wait() do
        h = (h + 1.5) % 360
        ButtonStroke.Color = Color3.fromHSV(h/360, 1, 1)
    end
end)()
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Text = "🎵 THANH PHÚC PREMIUM"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.25, 0)
InputBox.PlaceholderText = "Nhập ID nhạc..."
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 16
InputBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)

local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.9, 0, 0, 45)
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "PHÁT AUDIO KÉP"
PlayBtn.Font = Enum.Font.SourceSansBold
PlayBtn.TextSize = 16
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 175, 85)
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 8)

PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        local assetURI = "rbxassetid://" .. cleanID
        
        Sound1.SoundId = assetURI
        Sound2.SoundId = assetURI
        
        Sound1:Play()
        Sound2:Play()
        
        IsPlayingMusic = true
        CreateCustomBoombox()
        print("Thanh Phuc Master Boombox V6 đã kích hoạt chuyên nghiệp!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

