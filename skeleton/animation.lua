--[[
    describes a (re)animation for a skeleton

]]

Animation = {}
Animation.__index = Animation
Animation.__type = "animation"

function Animation:new(keyframes)
    local a = {
        keyframes = keyframes,  -- an ordered list of all keyframes in the animation
        
    }

    -- keyframes

    setmetatable(a, Animation)
    return a
end