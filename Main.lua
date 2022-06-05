local UiLibrary = {}
UiLibrary.__index = UiLibrary

function UiLibrary.init(name)
    local folder = game:GetObjects("rbxassetid://9820680667")[1]
	local screenGUI = folder.ScreenGui:Clone()
	local menu = screenGUI.Menu
	menu.TopBar.Title.Text = name
	local colorable = {}
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
		folder = folder,
		screenGUI = screenGUI,
        colorable = colorable,
		selected = selected
	}, UiLibrary)
end

local tab = {}
tab.__index = tab

function UiLibrary:createTab(image)
    local tab = self.folder.Tab:Clone()
	tab.Parent = self.screenGUI.Menu.Tabs.Tab
	tab.Tab.Image = image
	local window = self.folder.Window:Clone()
	window.Parent = self.screenGUI.Body

	if not self.selected then
		selected = tab
		selected.Visible = true
	end

	tab.Tab.MouseButton1Click:Connect(function()
		selected.Visible = false
		selected = tab
		selected.Visbile = true
	end)
	return setmetatable({
		window = window,
		getLongestSide = function()
			if self.window.Left.ListLayout.AbsoluteContentSize.Y >= self.window.Right.ListLayout.AbsoluteContentSize.Y then
				return self.window.Left
			else
				return self.window.Right
			end
		end
	}, tab)
end

local objects = {}
objects.__index = objects

function tab:createSection(name)
	local section = self.folder.Section:Clone()
	section.Parent = self.getLongestSide()
	section.Title.Frame.TextLabel.Text = name
	section.Title.Size.X.Offset = section.Title.Frame.TextLabel.TextBounds.X
	return setmetatable({
		section = section
	}, objects)
end

return UiLibrary
