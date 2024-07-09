--[[
    represents a keyframe in an animation

    i can't think of a clever name for this one

]]

Keyframe = {}
Keyframe.__index = Keyframe
Keyframe.__type = "keyframe"

function Keyframe:new(frame, transforms)
    local k = {
        frame = frame,          -- time, in frames, at which to play this frame
        transforms = transforms -- a list of transforms for all joints (from base model to reach this pose)
    }

    setmetatable(k, Keyframe)
    return k
end