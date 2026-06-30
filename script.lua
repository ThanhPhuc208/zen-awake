-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Ultimate Overwrite Boombox V8 (Thuật Toán Kích Hoạt Xuyên Bảo Mật Map) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- HỆ THỐNG ÂM THANH KÉP BASS ĐẬP ẤM
local SoundGroup = Instance.new("SoundGroup", SoundService)
SoundGroup.Name = "ThanhPhucAudioGroup"
SoundGroup.Volume = 1.8

local EQ = Instance.new("EqualizerSoundEffect", SoundGroup)
EQ.LowGain = 8.5
EQ.MidGain = 0
EQ.HighGain = -4

local Sound1 = Instance.new("Sound", LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace)
Sound1.Name = "Channel_Left"
Sound1.Looped = true
Sound1.SoundGroup = SoundGroup

local Sound2 = Instance.new("Sound", Sound1.Parent)
Sound2.Name = "Channel_Right"
Sound2.Looped = true
Sound2.SoundGroup = SoundGroup

local BoomboxPart = nil
local LedOutline = nil
local NameLabel = nil
local IsPlayingMusic = false
local VisualConnection = nil

local function DestroyOldBoombox()
    if VisualConnection then VisualConnection:Disconnect() VisualConnection = nil end
    if BoomboxPart and BoomboxPart:IsA("Part") then pcall(function() BoomboxPart:Destroy() end) end
    BoomboxPart = nil
end

local function CreateCustomBoombox()
    DestroyOldBoombox()
    
    local character = LocalPlayer.Character
    if not character then return end
    
    -- THUẬT TOÁN XUYÊN BẢO MẬT: Tìm một Phụ kiện (Handle) có sẵn trên người để "chiếm quyền" làm loa
    local targetPart = nil
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Accessory") and child:FindFirstChild("Handle") then
            targetPart = child.Handle
            -- Biến hình phụ kiện này thành khối loa màu đen
            targetPart.Color = Color3.fromRGB(10, 10, 10)
            targetPart.Material = Enum.Material.SmoothPlastic
            -- Xóa các lưới mesh cũ nếu có để nó biến thành khối vuông
            local mesh = targetPart:FindFirstChildOfClass("SpecialMesh") or targetPart:FindFirstChildOfClass("Mesh")
            if mesh then mesh:Destroy() end
            break
        end
    end
    
    -- Nếu không có phụ kiện, bắt buộc phải dùng thuật toán tạo Part đính trực tiếp vào Camera Client
    if not targetPart then
        BoomboxPart = Instance.new("Part")
        BoomboxPart.Name = "ThanhPhucClientLoa"
        BoomboxPart.Size = Vector3.new(2.4, 2.4, 1.6)
        BoomboxPart.Color = Color3.fromRGB(10, 10, 10)
        BoomboxPart.Material = Enum.Material.SmoothPlastic
        BoomboxPart.CanCollide = false
        BoomboxPart.Anchored = true
        BoomboxPart.Parent = workspace.CurrentCamera -- Ép hiển thị trực tiếp lên Camera của bạn!
        targetPart = BoomboxPart
    end
    
    -- 2. Viền LED Cầu Vồng Đậm (Đồng bộ màu Menu)
    LedOutline = Instance.new("SelectionBox")
    LedOutline.Name = "Premium_Outline"
    LedOutline.Adornee = targetPart
    LedOutline.LineThickness = 0.08
    LedOutline.SurfaceTransparency = 1
    LedOutline.Parent = targetPart
    
    -- 3. IN NHÃN HIỆU GỌN GÀNG KHÔNG RỜI CHỮ
    local SurfaceGui = Instance.new("SurfaceGui")
    SurfaceGui.Name = "BrandDisplay"
    SurfaceGui.Face = Enum.NormalId.Back
    SurfaceGui.CanvasSize = Vector2.new(500, 250)
    SurfaceGui.AlwaysOnTop = true -- Bật cái này để chắc chắn bạn nhìn thấy chữ xuyên qua mọi thứ
    SurfaceGui.Parent = targetPart
    
    local CenterFrame = Instance.new("Frame")
    CenterFrame.Size = UDim2.new(0.85, 0, 0.6, 0)
    CenterFrame.Position = UDim2.new(0.075, 0, 0.2, 0)
    CenterFrame.BackgroundTransparency = 1
    CenterFrame.Parent = SurfaceGui
    
    NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = "Thanh Phuc"
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextScaled = true
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.Parent = CenterFrame

    -- VÒNG LẶP ĐỒNG BỘ HIỆU ỨNG CẦU VỒNG ĐẬP BASS
    local hue = 0
    local baseSize = Vector3.new(2.4, 2.4, 1.6)
    local clock = 0
    
    VisualConnection = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        
        if not root then return end
        
        -- Nếu là Part tự tạo, khóa vị trí sau lưng liên tục
        if BoomboxPart and BoomboxPart.Parent then
            BoomboxPart.CFrame = root.CFrame * CFrame.new(0, 0.4, 1.1)
        end
        
        clock = clock + 1
        local intensity = math.abs(math.sin(clock * 0.22)) * 0.4 + (math.cos(clock * 0.08) * 0.2)
        intensity = math.clamp(intensity, 0, 0.9)
        
        -- MÀU CẦU VỒNG ĐẬM (Tone bảo hòa cao như Menu)
        hue = (hue + 0.7) % 360
        local darkRainbowColor = Color3.fromHSV(hue / 360, 1, 0.6) 
        
        LedOutline.Color3 = darkRainbowColor
        NameLabel.TextColor3 = darkRainbowColor
        
        -- Hiệu ứng co giãn kích thước loa
        if BoomboxPart then
            BoomboxPart.Size = baseSize * (1 + (intensity * 0.06))
        else
            targetPart.Size = baseSize * (1 + (intensity * 0.06))
        end
    end)
end

Players.LocalPlayer.CharacterAdded:Connect(function()
    if IsPlayingMusic then task.wait(0.6) CreateCustomBoombox() end
end)

-- GIAO DIỆN ĐỒNG BỘ STYLE MENU 
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
Title.Text = "🎵 THANH PHÚC HOÀN HẢO V8"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
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
        Sound2.SoundId = assetURI
        Sound1:Play()
        Sound2:Play()
        IsPlayingMusic = true
        CreateCustomBoombox()
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID lỗi!"
    end
end)
