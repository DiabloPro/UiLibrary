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
    <pre lang="lua"> 
local toggle = section:createToggle(name, function(boolean)<br>
</br>
end, default) -- if default is left nil boolean will automatically start as false
    </pre>
  </summary>
    <pre lang="lua">
toggle:createSlider(name, range, default, precentage, function(value)
<br></br>
end) -- creates slider under the toggle
<br></br>
toggle:createBind(function(bind)
<br></br>
end) -- lets you keybind the toggle, function is optional and fires when bind is changed
<br></br>
toggle:setToggle(boolean) -- fires CallBack
<br></br>
toggle:setBind(key) -- must be a keycode name does not fire createBind callback can also be left as nil for no key
<br></br>
toggle:getBind() -- returns nil if no bind
<br></br>
Library:setKeybindBlacklist(blacklist) -- blacklist should be a table like {"W","A","S","D"} (global)
<br></br>
Library:addKeybindBlacklist(keys) -- should also be a table adds values to blacklist
<br></br>
Library:removeKeybindBlacklist(keys) -- same as previous
  </pre>
</details>

```Lua
local slider = section:createSlider(name, range, default, precentage, function(value)

end) --[[ range is the range of numbers you want it 
should look like {0, 100} lowest first, highest last. Precentage should be true or false ]]--
```

## Images
