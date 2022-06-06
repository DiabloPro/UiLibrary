## Info
UiLibrary based off Octohook and Hydroxide
##### Disclaimer
This is incomplete
## Script
##### Loadstring
```Lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DiabloPro/UiLibrary/main/Main.lua"))()
```
##### Documentation
```Lua
local screenGUI = Library.init(name) -- Creates the GUI
```
<details>
<Lua>
a
</Lua>
</details>
local tab = screenGUI:createTab(image) -- Image should be 28x28 pixels

local section = tab:createSection(name)

local button = section:createButton(name, function()

end)

local toggle = section:createToggle(name, keybindable, function(boolean)

end, default) -- if default is left nil boolean will automatically start as false

Library:setKeybindBlacklist(blacklist) -- blacklist should be a table like {"W","A","S","D"}

Library:addKeybindBlacklist(keys) -- should also be a table adds values to blacklist

Library:removeKeybindBlacklist(keys) -- same as previous

local slider = section:createSlider(name, range, default, precentage, function(value)

end) --[[ range is the range of numbers you want it 
should look like {0, 100} lowest first, highest last. Precentage should be true or false ]]--
```

## Images
