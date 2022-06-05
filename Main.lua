local UiLibrary = {}
UiLibrary.__index = UiLibrary

local folder = game:GetObjects("rbxassetid://9820680667")[1]
local colorable = {}
local theme = Color3.fromRGB(255,255,255)
local selected

function UiLibrary.init(name)
	local screenGUI = folder.ScreenGui:Clone()
	local menu = screenGUI.Menu
	menu.TopBar.Title.Text = name
	table.insert(colorable, menu.Border)
	table.insert(colorable, menu.Tabs.Border)
	table.insert(colorable, menu.Body.Border)

	if syn then
		syn.protect_gui(screenGUI)
		screenGUI.Parent = CoreGui
	elseif gethui then
		screenGUI.Parent = gethui()
	else
		screenGUI.Parent = CoreGui
	end

	menu.TopBar.DestroyButton.MouseButton1Click:Connect(function()
		screenGUI:Destroy()
	end)

	return setmetatable({
		screenGUI = screenGUI,
		selected = selected
	}, UiLibrary)
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
		selected.Visible = true
	end

	tab.Tab.MouseButton1Click:Connect(function()
		selected.Visible = false
		selected = tab
		selected.Visible = true
	end)

	return setmetatable({
		window = window,
		getLongestSide = function()
			if window.Left.ListLayout.AbsoluteContentSize.Y >= window.Right.ListLayout.AbsoluteContentSize.Y then
				return window.Left
			else
				return window.Right
			end
		end
	}, tabs)
end

local objects = {}
objects.__index = objects

function tabs:createSection(name)
	local section = folder.Section:Clone()
	section.Parent = self.getLongestSide()
	section.Title.Frame.TextLabel.Text = name
	section.Title.Size = UDim2.new(0, section.Title.Frame.TextLabel.TextBounds.X, 0, 20) --[[[complete it]]--
	return setmetatable({
		section = section,
	}, objects)
end

function objects:createButton(name, callBack)
	local button = folder.Button:Clone()
	button.Parent = self.section
	button.Title.Text = name

	button.MouseButton1Down:Connect(function()
		button.BackgroundColor3 = theme
	end)

	button.MouseButton1Up:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(25,25,25)
	end)

	Button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(25,25,25)
	end)

	button.MouseButton1Click:Connect(function()
		callBack()
	end)
end

function objects:createToggle(name, keybindable, callBack)

end

return UiLibrary
