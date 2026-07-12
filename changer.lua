--// Standalone Font Changer with Custom Title & Credit — FIXED VERSION by Gemini for ren
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local settings = {
	SelectedFont = "Gotham"
}

local rawFontChoices = {
	{"Gotham", "Gotham"}, {"Gotham Bold", "GothamBold"}, {"Gotham Black", "GothamBlack"},
	{"Gotham Semibold", "GothamSemibold"}, {"Source Sans", "SourceSans"}, {"Source Sans Bold", "SourceSansBold"},
	{"Arial", "Arial"}, {"Arial Bold", "ArialBold"}, {"Code", "Code"}, {"Fantasy", "Fantasy"},
	{"Cartoon", "Cartoon"}, {"SciFi", "SciFi"}, {"Arcade", "Arcade"}, {"Roboto", "Roboto"},
	{"Ubuntu", "Ubuntu"}, {"Oswald", "Oswald"}, {"Bangers", "Bangers"}, {"Creepster", "Creepster"},
	{"Fortnite Style", "Bangers"}, {"⭐ Star Font", "LuckiestGuy"}, {"Star Bold", "FredokaOne"},
	{"Star Clean", "GothamBlack"}, {"Battle Royale", "LuckiestGuy"}, {"Sweaty Bold", "GothamBlack"},
	{"Tryhard", "Sarpanch"}, {"Cyber", "SciFi"}, {"Cyber Bold", "Michroma"},
	{"Pixel", "Code"}, {"Hacker", "Code"}, {"Anime", "FredokaOne"},
	{"Graffiti", "PermanentMarker"}, {"Nano Clean", "Gotham"}, {"Rivals", "Sarpanch"}
}

local fontChoices = {}
local fontLookup = {}

for _, info in ipairs(rawFontChoices) do
	local displayName = info[1]
	local enumName = info[2]
	local ok, enumFont = pcall(function() return Enum.Font[enumName] end)
	if ok and enumFont then
		table.insert(fontChoices, {Name = displayName, Font = enumFont})
		fontLookup[displayName] = enumFont
	end
end

local function currentFont()
	return fontLookup[settings.SelectedFont] or Enum.Font.Gotham
end

local function isLittleSystemTitle(obj)
	if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return false end
	local txt = string.lower(tostring(obj.Text or ""))
	txt = string.gsub(txt, "%s+", " ")
	local objName = string.lower(tostring(obj.Name or ""))

	local blockedText = { ["..."] = true, ["add friend"] = true, ["friend request"] = true, ["requests"] = true }
	if blockedText[txt] then return true end

	local blockedWords = { "topbar", "coregui", "friend", "request", "menu" }
	for _, word in ipairs(blockedWords) do
		if string.find(txt, word, 1, true) or string.find(objName, word, 1, true) then return true end
	end

	if obj.AbsoluteSize.X <= 120 and obj.AbsoluteSize.Y <= 45 and obj:IsA("TextButton") then return true end
	return false
end

local function applyFontToObject(obj, font)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		if isLittleSystemTitle(obj) then return end
		pcall(function() obj.Font = font end)
	end
end

local function applyFontContainer(container, font)
	if not container then return end
	pcall(function()
		for _, obj in ipairs(container:GetDescendants()) do
			applyFontToObject(obj, font)
		end
	end)
end

local function applyGameFont(fontName)
	settings.SelectedFont = fontName or settings.SelectedFont or "Gotham"
	local font = currentFont()
	applyFontContainer(pg, font)
end

pg.DescendantAdded:Connect(function(obj)
	task.defer(function() applyFontToObject(obj, currentFont()) end)
end)

-- ==========================================
-- UI 核心
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "RenFontSystem"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

-- ==========================================
-- made by ren 啟動小動畫
-- ==========================================
local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundTransparency = 1
introFrame.Parent = gui

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(0, 400, 0, 60)
introText.Position = UDim2.new(0.5, -200, 0.5, -10)
introText.BackgroundTransparency = 1
introText.Text = "made by ren"
introText.TextColor3 = Color3.fromRGB(0, 210, 255)
introText.Font = Enum.Font.GothamBold
introText.TextSize = 36
introText.TextTransparency = 1
introText.Parent = introFrame

-- ==========================================
-- 主選單視窗 與 Menu 按鈕
-- ==========================================
local menuBtn = Instance.new("TextButton")
menuBtn.Size = UDim2.new(0, 80, 0, 30)
menuBtn.Position = UDim2.new(0.5, -40, 0, 15)
menuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
menuBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
menuBtn.Font = Enum.Font.GothamBold
menuBtn.Text = "Menu"
menuBtn.TextSize = 13
menuBtn.Visible = false
menuBtn.Parent = gui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = menuBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 330)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -165)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- 標題欄位區塊
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 48)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

-- 主要標題：Font Changer
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 22)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Font Changer"
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = topBar

-- 副標題：TT:n1ghtmare_delta
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 14)
subtitle.Position = UDim2.new(0, 0, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.Text = "TT:n1ghtmare_delta"
subtitle.TextColor3 = Color3.fromRGB(240, 240, 245)
subtitle.TextTransparency = 0.5
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.Parent = topBar

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -12, 1, -58)
scroll.Position = UDim2.new(0, 6, 0, 52)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
scroll.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scroll

-- 修正這裡的 ipairs 錯字
for _, fontInfo in ipairs(fontChoices) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	btn.TextColor3 = Color3.fromRGB(230, 230, 235)
	btn.Font = fontInfo.Font
	btn.Text = fontInfo.Name
	btn.TextSize = 13
	btn.Parent = scroll
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 4)
	c.Parent = btn

	btn.MouseButton1Click:Connect(function()
		applyGameFont(fontInfo.Name)
	end)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

-- ==========================================
-- Menu 按鈕拖曳與點擊防誤觸邏輯
-- ==========================================
local menuDragging, menuDragInput, menuDragStart, menuStartPos
local menuHasDragged = false

menuBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		menuDragging = true
		menuHasDragged = false
		menuDragStart = input.Position
		menuStartPos = menuBtn.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				menuDragging = false
			end
		end)
	end
end)

menuBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		menuDragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if menuDragging and input == menuDragInput then
		local delta = input.Position - menuDragStart
		if delta.Magnitude > 3 then
			menuHasDragged = true
			menuBtn.Position = UDim2.new(
				menuStartPos.X.Scale, 
				menuStartPos.X.Offset + delta.X, 
				menuStartPos.Y.Scale, 
				menuStartPos.Y.Offset + delta.Y
			)
		end
	end
end)

menuBtn.MouseButton1Click:Connect(function()
	if menuHasDragged then return end
	mainFrame.Visible = not mainFrame.Visible
end)

-- ==========================================
-- 視窗頂部拖曳邏輯
-- ==========================================
local winDragging, winDragInput, winDragStart, winStartPos

topBar.InputBegan:Connect(function(input)
	if mainFrame.Visible and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		winDragging = true
		winDragStart = input.Position
		winStartPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				winDragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if mainFrame.Visible and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		winDragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if winDragging and input == winDragInput and mainFrame.Visible then
		local delta = input.Position - winDragStart
		mainFrame.Position = UDim2.new(
			winStartPos.X.Scale, 
			winStartPos.X.Offset + delta.X, 
			winStartPos.Y.Scale, 
			winStartPos.Y.Offset + delta.Y
		)
	end
end)

-- ==========================================
-- 啟動流動畫控制
-- ==========================================
task.spawn(function()
	-- 淡入上浮
	local tweenInfoIn = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local fadeIn = TweenService:Create(introText, tweenInfoIn, {
		TextTransparency = 0,
		Position = UDim2.new(0.5, -200, 0.5, -30)
	})
	fadeIn:Play()
	fadeIn.Completed:Wait()
	
	task.wait(1.5)
	
	-- 淡出上浮
	local tweenInfoOut = TweenInfo.new(1.0, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	local fadeOut = TweenService:Create(introText, tweenInfoOut, {
		TextTransparency = 1,
		Position = UDim2.new(0.5, -200, 0.5, -50)
	})
	fadeOut:Play()
	fadeOut.Completed:Wait()
	
	introFrame:Destroy()
	
	-- 顯示選單與載入字體
	menuBtn.Visible = true
	mainFrame.Visible = true
	applyGameFont(settings.SelectedFont)
end)
