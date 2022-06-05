## Info
UiLibrary based off Octohook and Hydroxide

## Script
##### Loadstring
```Lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DiabloPro/UiLibrary/main/Main.lua"))()
```

##### Documentation
```Lua
local screenGUI = Library.init(name) -- Creates the GUI

local tab = screenGUI:createTab(image) -- Image should be 28x28 pixels

local section = tab:createSection(name)

local button = section:createButton(name, function()

end)

local toggle = section:createToggle(name, keybindable, function(boolean)

end, default) -- if default is left nil boolean will automatically start as false

```

## Images
