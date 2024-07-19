--[[pod_format="raw",created="2024-07-10 03:03:19",modified="2024-07-10 03:03:19",revision=0]]
--[[
    describes a (re)animation for a skeleton

]]

include("skeleton/keyframe.lua")

include("finkchlib/tstr.lua")

Animation = {}
Animation.__index = Animation
Animation.__type = "animation"

function Animation:new(name, keyframes)

    if (not keyframes) keyframes = {Keyframe:new()}

    local a = {
        name = name,
        keyframes = keyframes,  -- an ordered list of all keyframes in the animation
        duration = nil   
    }

    setmetatable(a, Animation)
    a:findduration()            -- gets total duration of animation and sets timestamps for keyframes
    return a
end

-- finds the total duration of the animation
function Animation:findduration()
    if (#self.keyframes == 0) then
        self.duration = 0
        return
    end

    local duration = 0
    local initial_duration = self.keyframes[1].duration
    for keyframe in all(self.keyframes) do
        duration += keyframe.duration   -- adds duration to tally
        keyframe.frame = duration - initial_duration       -- sets the timestamp
    end
    self.duration = duration
end


-- adds a bone to all keyframes.
-- shouldn't be used at runtime, but to build skeletons while
-- seeing the output.
function Animation:addbone(bone)
    for keyframe in all(self.keyframes) do
        keyframe:addbone(bone)
    end
end


-- adds a keyframe to the animation
function Animation:addkeyframe(skeleton, index)

    -- creates a keyframe and adds each bone in the skeleton
    local keyframe = Keyframe:new()
    for _, bone in pairs(skeleton.bones) do

        -- tries to use previous keyframe's positions.
        -- if no previous keyframe, use empty pose.
        local transforms = {}
        if (index > 1) transforms = self.keyframes[index - 1]

        keyframe:addbone(bone, transforms[bone])
    end

    -- if index is not supplied, defaults to end of the list
    add(self.keyframes, keyframe, index)

    -- recalculates the duration of the animation
    self:findduration()
end



-- metamethods
function Animation:__tostring()
    local str = self.name .. " (Animation, " .. self.duration .. ")"

    local strs = {}
    for i = 1, #self.keyframes do
        strs[tostr(i)] = self.keyframes[i]
    end

    return str .. tstr(strs)
end