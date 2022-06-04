local UiLibrary = {}
UiLibrary.__index = UiLibrary

function UiLibrary.init(name)
    local folder = game:GetObjects("rbxassetid://9820680667")[1]
	local screenGui = folder.ScreenGui:Clone()
	local menu = screenGui.Menu
	menu.TopBar.Title.Text = name
	local colorable = {}
	table.insert(colorable, menu.Border)
	table.insert(colorable, menu.Tabs.Border)
	table.insert(colorable, menu.Body.Border)

	if syn then
		syn.protect_gui(screenGui)
		screenGui.Parent = CoreGui
	elseif gethui then
		screenGui.Parent = gethui()
	else
		screenGui.Parent = CoreGui
	end

	menu.TopBar.Destroy.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	return setmetatable({
		folder = folder,
		screenGui = screenGui,
		windows = {},
        colorable = colorable,
		selected = selected
	}, UiLibrary)
end

function UiLibrary:CreateTab(image)
    local tab = self.folder.Tab:Clone()
	tab.Parent = self.screenGui.Menu.Tabs.Tab
	tab.Tab.Image = image
	self.windows[tab] = self.folder.Window:Clone()
	self.windows[tab].Parent = self.screenGui.Body

	if not self.selected then
		selected = tab
	end

	tab.Tab.MouseButton1Click:Connect(function()
		print("a")
	end)
end

return UiLibrary
