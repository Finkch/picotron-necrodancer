--[[
    represents a keyframe in an animation

    i can't think of a clever name for this one

]]

Keyframe = {}
Keyframe.__index = Keyframe
Keyframe.__type = "keyframe"

function Keyframe:new()
    local k = {

    }

    -- joint trasnform (relative to parent)

    -- timestamp of pose in animation

    setmetatable(k, Keyframe)
    return k
end