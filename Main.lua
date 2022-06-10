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
	local dragChanged
	local dragEnded
	local windowFocused
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

	menu.TopBar.Drag.MouseButton1Down:Connect(function(x, y)
		local dragStart = Vector3.new(x, y, 0)
		local menuStart = menu.Position
		dragChanged = UserInputService.InputChanged:Connect(function(inputObject, gameProcessed)
			windowFocused = UserInputService.WindowFocused:Connect(function()
				dragChanged:Disconnect()
				dragEnded:Disconnect()
				windowFocused:Disconnect()
			end)
			if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = inputObject.Position - dragStart
				menu.Position = UDim2.new(menuStart.X.Scale, menuStart.X.Offset + delta.X, menuStart.Y.Scale, menuStart.Y.Offset + delta.Y + 35)
			end
		end)
		
		dragEnded = UserInputService.InputEnded:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				dragChanged:Disconnect()
				dragEnded:Disconnect()
				windowFocused:Disconnect()
			end
		end)
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

local toggles = {}
toggles.__index = toggles
local booleans = {}

local Id = 0
local function generateId()
	Id += 1
	return Id
end

function objects:createToggle(name, callBack, default)
	local toggle = folder.Toggle:Clone()
	toggle.Parent = self.section.Holder
	toggle.Title.Text = name
	table.insert(colorable, toggle.Button.Border)
	table.insert(colorable, toggle.Button)
	local Id = generateId()
	booleans[Id] = default or false

	local function setColor()
		if booleans[Id] then
			toggle.Button.BackgroundColor3 = theme
		else
			toggle.Button.BackgroundColor3 = Color3.fromRGB(25,25,25)
		end
	end
	setColor()

	toggle.Button.MouseButton1Click:Connect(function()
		booleans[Id] = not booleans[Id]
		setColor()
		callBack(booleans[Id])
	end)

	self.updateSection()

	return setmetatable({
		toggle = toggle,
		Id = Id,
		callBack = callBack,
		setColor = setColor,
		updateSection = self.updateSection
	}, toggles)
end

function toggles:createBind(callBack)
	local bind = folder.KeyBind:Clone()
	bind.Parent = self.toggle
	self.binded = nil
	self.binding = false
	self.bindcallBack = callBack

	bind.Button.MouseButton1Click:Connect(function()
		bind.Button.TextLabel.Text = "[ ... ]"
		self.binding = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
			if not gameProcessed then
				local key = inputObject.KeyCode.Name
				if not table.find(keyBindBlacklist, key) then
					self.binded = key
					bind.Button.TextLabel.Text = "[ "..self.binded.." ]"
					if callBack then
						callBack(key)
					end
					self.binding:Disconnect()
					self.binding = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
						if not gameProcessed then
							if inputObject.KeyCode.Name == self.binded then
								booleans[self.Id] = not booleans[self.Id]
								self.setColor()
								self.callBack(booleans[self.Id])
							end
						end
					end)
				end
			end
		end)
	end)

	bind.Button.MouseButton2Click:Connect(function()
		if self.binding then
			bind.Button.TextLabel.Text = "[ None ]"
			if self.bindcallBack then
				self.bindcallBack(nil)
			end
			self.binding:Disconnect()
		end
	end)
end

function toggles:setBind(key)
	if key == nil then
		self.toggle.KeyBind.Button.TextLabel.Text = "[ None ]"
		self.binded = nil
	else
		self.binded = key
		self.toggle.KeyBind.Button.TextLabel.Text = "[ "..self.binded.." ]"
		if self.binding then
			self.binding:Disconnect()
		end
		self.binding = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
			if not gameProcessed then
				if inputObject.KeyCode.Name == self.binded then
					booleans[self.Id] = not booleans[self.Id]
					self.setColor()
					self.callBack(booleans[self.Id])
				end
			end
		end)
	end
end

function toggles:getBind()
	return self.binded
end

function toggles:setToggle(boolean)
	if boolean == true or boolean == false then
		booleans[self.Id] = boolean
		self.setColor()
		self.callBack(boolean)
	end
end

local function handleSlider(slider, range, default, precentage, callBack)
	local upper = range[2]
	local lower = range[1]
	local currentNumber = (default - lower) / (upper - lower)
	local dragging
	table.insert(colorable,	slider.Slider)
	table.insert(colorable,	slider.Border)

	local function AdjustSlider()
		slider.Slider.Size = UDim2.new(currentNumber, 0, 1, 0)
		if precentage then
			slider.TextLabel.Text = math.floor(currentNumber * 100).."% / 100%"
		else
			slider.TextLabel.Text = math.floor(currentNumber * (upper - lower) + lower).." / "..upper
		end
	end
	AdjustSlider()

	slider.MouseButton1Down:Connect(function(x)
		currentNumber = ((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) + .005
		AdjustSlider()
		callBack(math.floor(currentNumber * (upper - lower) + lower))
		dragging = UserInputService.InputChanged:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
				currentNumber = ((inputObject.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) + .005
				AdjustSlider()
				callBack(math.floor(currentNumber * (upper - lower) + lower))
			end
		end)
	end)

	slider.MouseLeave:Connect(function()
		if dragging then
			dragging:Disconnect()
		end
	end)

	slider.MouseButton1Up:Connect(function()
		if dragging then
			dragging:Disconnect()
		end
	end)
end

function toggles:createSlider(range, default, precentage, callBack)
	local slider = folder.ToggleSlider:Clone()
	self.toggle.Size = self.toggle.Size + UDim2.new(0, 0, 0, 20)
	slider.Parent = self.toggle
	handleSlider(slider, range, default, precentage, callBack)
	self.updateSection()
end

function objects:createSlider(name, range, default, precentage, callBack)
	local slider = folder.Slider:Clone()
	slider.Parent = self.section.Holder
	slider.Title.Text = name
	handleSlider(slider.Background, range, default, precentage, callBack)
	self.updateSection()
end

return UiLibrary
