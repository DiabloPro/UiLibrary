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

local tab = screenGUI:createTab(image) -- Image should be 28x28 pixels

local section = tab:createSection(name)

local button = section:createButton(name, function()

end)


```
<details>
  <summary>Toggle
    <pre> 
local toggle = section:createToggle(name, function(boolean)
<p></p>
end, default) -- if default is left nil boolean will automatically start as false
    </pre>
  </summary>
    <pre lang="lua">
toggle:createSlider(name, range, default, precentage, function(value)

end) -- creates slider under the toggle
<br></br>
toggle:createBind() -- lets you keybind the toggle
<p></p>
toggle:setBind()
<p></p>
toggle:getBind() -- returns nil if no bind
<p></p>
Library:setKeybindBlacklist(blacklist) -- blacklist should be a table like {"W","A","S","D"} (global)
<p></p>
Library:addKeybindBlacklist(keys) -- should also be a table adds values to blacklist
<p></p>
Library:removeKeybindBlacklist(keys) -- same as previous
  </pre>
</details>


```Lua
local slider = section:createSlider(name, range, default, precentage, function(value)

end) --[[ range is the range of numbers you want it 
should look like {0, 100} lowest first, highest last. Precentage should be true or false ]]--
```

## Images
