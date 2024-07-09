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


-- metamethods
function Q:__index(key) -- returns transform without overriding metamethods
    local datum = self.transforms[key]

    -- if we didn't find the item, it likely means it shoud look in the metatable
    if (not datum) return self[key]
    return datum
end