--[[
    describes a (re)animation for a skeleton

]]

Animation = {}
Animation.__index = Animation
Animation.__type = "animation"

function Animation:new()
    local a = {

    }

    -- keyframes

    setmetatable(a, Animation)
    return a
end