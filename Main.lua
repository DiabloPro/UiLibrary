local UiLibrary = {}
UiLibrary.__index = UiLibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local folder = game:GetObjects("rbxassetid://9820680667")[1]
local colorable = {}
local theme = Color3.fromRGB(255,255,255)
local selected
local keyBindBlacklist = {
	"W",
	"A",
	"S",
	"D",
	"I",
	"O",
	"Slash",
	"Tab",
	"Backspace",
	"Escape",
	"Space",
	"Delete",
	"Unknown",
	"Backquote"
}

function UiLibrary.init(name)
	local screenGUI = folder.ScreenGui:Clone()
	local menu = screenGUI.Menu
	menu.TopBar.Title.Text = name
	table.insert(colorable, menu.Border)
	table.insert(colorable, menu.Tabs.Border)
	table.insert(colorable, menu.Body.Border)

	if syn then
		syn.protect_gui(screenGUI)
		screenGUI.Parent = game.CoreGui
	elseif gethui then
		screenGUI.Parent = gethui()
	else
		screenGUI.Parent = game.CoreGui
	end

	menu.TopBar.DestroyButton.MouseButton1Click:Connect(function()
		screenGUI:Destroy()
	end)

	return setmetatable({
		screenGUI = screenGUI
	}, UiLibrary)
end

function UiLibrary:setKeybindBlacklist(blacklist)
	local newBlacklist = {}
	for i,v in pairs(blacklist) do
		table.insert(newBlacklist, string.upper(v))
	end
	keyBindBlacklist = newBlacklist
end

function UiLibrary:addKeybindBlacklist(blacklist)
	for i,v in pairs(blacklist) do
		table.insert(keyBindBlacklist, string.upper(v))
	end
end

function UiLibrary:removeKeybindBlacklist(blacklist)
	for i,v in pairs(blacklist) do
		local key = table.find(keyBindBlacklist, string.upper(v))
		if key then
			table.remove(keyBindBlacklist, key)
		end
	end
end

local tabs = {}
tabs.__index = tabs

function UiLibrary:createTab(image)
    local tab = folder.Tab:Clone()
	tab.Parent = self.screenGUI.Menu.Tabs.Tab
	tab.Tab.Image = image
	local window = folder.Window:Clone()
	window.Parent = self.screenGUI.Menu.Body

	if not selected then
		selected = tab
		tab.Tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		window.Visible = true
	end

	tab.Tab.MouseButton1Click:Connect(function()
		for i,v in pairs(self.screenGUI.Menu.Tabs.Tab:GetChildren()) do
			if v:IsA("Frame") then
				v.Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			end
		end
		for i,v in pairs(self.screenGUI.Menu.Body:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				v.Visible = false
			end
		end
		selected = tab
		tab.Tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		window.Visible = true
	end)

	tab.Tab.MouseEnter:Connect(function()
		local tweenInfo = TweenInfo.new(.3)

		local tween = TweenService:Create(tab.Tab, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
		tween:Play()
	end)

	tab.Tab.MouseLeave:Connect(function()
		if selected ~= tab then
			local tweenInfo = TweenInfo.new(.3)

			local tween = TweenService:Create(tab.Tab, tweenInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
			tween:Play()
		end
	end)

	return setmetatable({
		window = window,
		getLongestSide = function(largest)
			if window.Left.ListLayout.AbsoluteContentSize.Y <= window.Right.ListLayout.AbsoluteContentSize.Y then
				if largest then
					return window.Right
				else
					return window.Left
				end
			else
				if largest then
					return window.Left
				else
					return window.Right
				end
			end
		end,
	}, tabs)
end

local objects = {}
objects.__index = objects

function tabs:createSection(name)
	local section = folder.Section:Clone()
	section.Parent = self.getLongestSide(false)
	section.Title.Frame.TextLabel.Text = name
	section.Title.Size = UDim2.new(0, section.Title.Frame.TextLabel.TextBounds.X + 6, 0, 20)
	return setmetatable({
		section = section,
		updateSection = function()
			section.Size = UDim2.new(1,0, 0, section.Holder.ListLayout.AbsoluteContentSize.Y + 26)
			self.window.CanvasSize = UDim2.new(1, 0, 0, self.getLongestSide(true).ListLayout.AbsoluteContentSize.Y + 23)
		end
	}, objects)
end

function objects:createButton(name, callBack)
	local button = folder.Button:Clone()
	button.Parent = self.section.Holder
	button.Title.Text = name
	table.insert(colorable, button.Border)
	table.insert(colorable, button)

	button.MouseButton1Down:Connect(function()
		button.BackgroundColor3 = theme
	end)

	button.MouseButton1Up:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(25,25,25)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(25,25,25)
	end)

	button.MouseButton1Click:Connect(function()
		callBack()
	end)

	self.updateSection()
end

function objects:createToggle(name, keybindable, callBack, default)
	local toggle = folder.Toggle:Clone()
	toggle.Parent = self.section.Holder
	toggle.Title.Text = name
	local bool = default or false
	table.insert(colorable, toggle.Button.Border)
	table.insert(colorable, toggle.Button)

	local function setColor()
		if bool then
			toggle.Button.BackgroundColor3 = theme
		else
			toggle.Button.BackgroundColor3 = Color3.fromRGB(25,25,25)
		end
	end
	setColor()

	toggle.Button.MouseButton1Click:Connect(function()
		bool = not bool
		setColor()
		callBack(bool)
	end)

	if keybindable then
		local binded
		local binding = false

		toggle.KeyBind.Button.MouseButton1Click:Connect(function()
			toggle.KeyBind.Button.TextLabel.Text = "[ ... ]"
			binding = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
				if not gameProcessed then
					local key = inputObject.KeyCode.Name
					if not table.find(keyBindBlacklist, key) then
						binded = key
						toggle.KeyBind.Button.TextLabel.Text = "[ "..key.." ]"
						binding:Disconnect()
						binding = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
							if not gameProcessed then
								if inputObject.KeyCode.Name == binded then
									bool = not bool
									setColor()
									callBack(bool)
								end
							end
						end)
					end
				end
			end)
			
		end)

		toggle.KeyBind.Button.MouseButton2Click:Connect(function()
			if binding then
				toggle.KeyBind.Button.TextLabel.Text = "[ None ]"
				binding:Disconnect()
			end
		end)
	else
		toggle.KeyBind:Destroy()
	end
	self.updateSection()
end

function objects:createSlider(name, range, default, precentage, callBack)
	local slider = folder.Slider:Clone()
	slider.Parent = self.section.Holder
	slider.Title.Text = name
	local upper = range[2]
	local lower = range[1]
	local currentNumber = (default - lower) / (upper - lower)
	local dragging
	table.insert(colorable,	slider.Background)
	table.insert(colorable,	slider.Background.Border)

	local function AdjustSlider()
		slider.Background.Slider.Size = UDim2.new(currentNumber, 0, 1, 0)
		if precentage then
			slider.Background.TextLabel.Text = math.floor(currentNumber * 100).."% / 100%"
		else
			slider.Background.TextLabel.Text = math.floor(currentNumber * (upper - lower) + lower).." / "..upper
		end
	end
	AdjustSlider()

	slider.Background.MouseButton1Down:Connect(function()
		dragging = UserInputService.InputChanged:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				currentNumber = ((inputObject.Position.X - slider.Background.AbsolutePosition.X) / slider.Background.AbsoluteSize.X) + .005
				AdjustSlider()
				callBack(math.floor(currentNumber * (upper - lower) + lower))
			end
		end)
	end)

	slider.Background.MouseLeave:Connect(function()
		if dragging then
			dragging:Disconnect()
		end
	end)

	slider.Background.MouseButton1Up:Connect(function()
		if dragging then
			dragging:Disconnect()
		end
	end)
	self.updateSection()
end
return UiLibrary
