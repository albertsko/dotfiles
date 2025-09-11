hs = hs

-- Hyper
local hyperKey = "f18"
local hyperMods = { "shift", "ctrl", "alt", "cmd" }
local hyperUsedAsMod = false

local hyperModal = hs.hotkey.modal.new()

local hyperKeyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(e)
    if e:getType() == hs.eventtap.event.types.keyDown then
        hyperUsedAsMod = true
    end

    local flags = e:getFlags()
    for _, mod in ipairs(hyperMods) do
        flags[mod] = true
    end
    e:setFlags(flags)

    return false
end)

function hyperModal:entered()
    hyperUsedAsMod = false
    hyperKeyTap:start()
end

function hyperModal:exited()
    hyperKeyTap:stop()
    if not hyperUsedAsMod then
        hs.eventtap.keyStrokes("$")
    end
end

hs.hotkey.bind({}, hyperKey,
    function() hyperModal:enter() end,
    function() hyperModal:exit() end
)

-- Binds
hs.hotkey.bind(hyperMods, "space", function()
    hs.application.launchOrFocus("Obsidian")
end)

hs.hotkey.bind(hyperMods, "`", function()
    hs.application.launchOrFocus("Ghostty")
end)

hs.hotkey.bind(hyperMods, "z", function()
    hs.application.launchOrFocus("Zen")
end)
