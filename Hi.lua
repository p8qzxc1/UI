-- ModernUILib.lua
local ModernUILib = {}
ModernUILib.__index = ModernUILib

local function roundify(obj, radius)
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, radius)
    uicorner.Parent = obj
end

local colors = {
    bg = Color3.fromRGB(18, 18, 18),
    panel = Color3.fromRGB(24, 24, 24),
    accent = Color3.fromRGB(0, 170, 255),
    border = Color3.fromRGB(40, 40, 40),
    text = Color3.fromRGB(200, 200, 200),
    textAccent = Color3.fromRGB(255,255,255),
    toggleOn = Color3.fromRGB(0, 170, 255),
    toggleOff = Color3.fromRGB(18, 18, 18),
    slider = Color3.fromRGB(0, 170, 255),
    sliderBg = Color3.fromRGB(40, 40, 40),
    dropdown = Color3.fromRGB(24, 24, 24),
}

function ModernUILib.new(title, tabs)
    local self = setmetatable({}, ModernUILib)
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "ModernTabUI"
    self.Gui.IgnoreGuiInset = true
    self.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 540, 0, 420)
    self.Main.Position = UDim2.new(0.5, -270, 0.5, -210)
    self.Main.BackgroundColor3 = colors.bg
    self.Main.BorderSizePixel = 0
    self.Main.Parent = self.Gui
    roundify(self.Main, 8)

    -- TopBar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 36)
    self.TopBar.BackgroundColor3 = colors.panel
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.Main
    roundify(self.TopBar, 8)

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 100, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = colors.textAccent
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TopBar

    -- Tabs
    self.Tabs = {}
    self.TabButtons = {}
    self.TabContents = {}
    self.SelectedTab = tabs[1]

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 90, 1, 0)
        btn.Position = UDim2.new(0, 100 + (i-1)*90, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = tabName
        btn.TextColor3 = (tabName == self.SelectedTab) and colors.accent or colors.text
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.BorderSizePixel = 0
        btn.Parent = self.TopBar
        self.TabButtons[tabName] = btn

        local content = Instance.new("Frame")
        content.Name = tabName .. "Content"
        content.Size = UDim2.new(1, 0, 1, -46)
        content.Position = UDim2.new(0, 0, 0, 46)
        content.BackgroundTransparency = 1
        content.Visible = (tabName == self.SelectedTab)
        content.Parent = self.Main
        self.TabContents[tabName] = content

        btn.MouseButton1Click:Connect(function()
            self:SwitchTab(tabName)
        end)
    end

    return self
end

function ModernUILib:SwitchTab(tabName)
    for name, content in pairs(self.TabContents) do
        content.Visible = (name == tabName)
        self.TabButtons[name].TextColor3 = (name == tabName) and colors.accent or colors.text
    end
    self.SelectedTab = tabName
end

function ModernUILib:AddSection(tab, name, width, x)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0, width or 260, 1, -16)
    section.Position = UDim2.new(0, x or 10, 0, 8)
    section.BackgroundColor3 = colors.panel
    section.BorderSizePixel = 0
    section.Parent = self.TabContents[tab]
    roundify(section, 6)
    return section
end

function ModernUILib:AddLabel(parent, text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 22)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = colors.text
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

function ModernUILib:AddToggle(parent, text, y, callback)
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 18, 0, 18)
    cb.Position = UDim2.new(0, 10, 0, y)
    cb.BackgroundColor3 = colors.toggleOff
    cb.BorderColor3 = colors.border
    cb.Text = ""
    cb.Parent = parent
    roundify(cb, 4)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -30, 1, 0)
    lbl.Position = UDim2.new(0, 28, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = colors.text
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cb

    local checked = false
    cb.MouseButton1Click:Connect(function()
        checked = not checked
        cb.BackgroundColor3 = checked and colors.toggleOn or colors.toggleOff
        if callback then callback(checked) end
    end)
    return cb
end

function ModernUILib:AddTextbox(parent, text, y, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 22)
    box.Position = UDim2.new(0, 10, 0, y)
    box.BackgroundColor3 = colors.bg
    box.BorderColor3 = colors.border
    box.Text = text
    box.TextColor3 = colors.text
    box.Font = Enum.Font.SourceSans
    box.TextSize = 16
    box.ClearTextOnFocus = false
    box.Parent = parent
    roundify(box, 4)
    box.FocusLost:Connect(function(enter)
        if enter and callback then callback(box.Text) end
    end)
    return box
end

function ModernUILib:AddSlider(parent, text, y, min, max, default, callback)
    local lbl = self:AddLabel(parent, text, y)
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, y+24)
    sliderBg.BackgroundColor3 = colors.sliderBg
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = parent
    roundify(sliderBg, 4)

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    slider.Position = UDim2.new(0, 0, 0, 0)
    slider.BackgroundColor3 = colors.slider
    slider.BorderSizePixel = 0
    slider.Parent = sliderBg
    roundify(slider, 4)

    local dragging = false
    local value = default

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            rel = math.clamp(rel, 0, 1)
            slider.Size = UDim2.new(rel, 0, 1, 0)
            value = math.floor((min + (max-min)*rel) * 100) / 100
            if callback then callback(value) end
        end
    end)
    return slider
end

function ModernUILib:AddDropdown(parent, text, y, options, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 22)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = colors.dropdown
    btn.BorderColor3 = colors.border
    btn.Text = text
    btn.TextColor3 = colors.text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = parent
    roundify(btn, 4)

    local open = false
    local dropdownFrame

    btn.MouseButton1Click:Connect(function()
        if open then
            if dropdownFrame then dropdownFrame:Destroy() end
            open = false
        else
            dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, #options*22)
            dropdownFrame.Position = UDim2.new(0, btn.Position.X.Offset, 0, btn.Position.Y.Offset+24)
            dropdownFrame.BackgroundColor3 = colors.dropdown
            dropdownFrame.BorderColor3 = colors.border
            dropdownFrame.Parent = parent
            roundify(dropdownFrame, 4)
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 22)
                optBtn.Position = UDim2.new(0, 0, 0, (i-1)*22)
                optBtn.BackgroundTransparency = 1
                optBtn.Text = opt
                optBtn.TextColor3 = colors.text
                optBtn.Font = Enum.Font.SourceSans
                optBtn.TextSize = 16
                optBtn.Parent = dropdownFrame
                optBtn.MouseButton1Click:Connect(function()
                    btn.Text = opt
                    if callback then callback(opt) end
                    dropdownFrame:Destroy()
                    open = false
                end)
            end
            open = true
        end
    end)
    return btn
end

function ModernUILib:AddMannequin(parent, y, onSelect)
    local mannequinFrame = Instance.new("Frame")
    mannequinFrame.Size = UDim2.new(1, -20, 0, 160)
    mannequinFrame.Position = UDim2.new(0, 10, 0, y)
    mannequinFrame.BackgroundColor3 = colors.bg
    mannequinFrame.BorderColor3 = colors.border
    mannequinFrame.Parent = parent
    roundify(mannequinFrame, 6)

    local parts = {
        {name = "Head", x=50, y=10, w=40, h=40, color=Color3.fromRGB(180,170,175)},
        {name = "Torso", x=40, y=50, w=60, h=60},
        {name = "LeftArm", x=20, y=50, w=20, h=60},
        {name = "RightArm", x=100, y=50, w=20, h=60},
        {name = "LeftLeg", x=50, y=110, w=20, h=40},
        {name = "RightLeg", x=70, y=110, w=20, h=40},
    }
    local selected
    for _, part in ipairs(parts) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, part.w, 0, part.h)
        btn.Position = UDim2.new(0, part.x, 0, part.y)
        btn.BackgroundColor3 = part.color or Color3.fromRGB(60,60,60)
        btn.BackgroundTransparency = 0.7
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = mannequinFrame
        roundify(btn, 2)
        btn.MouseButton1Click:Connect(function()
            for _, c in ipairs(mannequinFrame:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3 = c == btn and colors.accent or (part.color or Color3.fromRGB(60,60,60))
                end
            end
            selected = part.name
            if onSelect then onSelect(part.name) end
        end)
    end
    return mannequinFrame
end

return ModernUILib
