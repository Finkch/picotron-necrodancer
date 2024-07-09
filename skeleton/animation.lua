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



-- metamethods
function Animation:__index(frame)   -- returns the two animations nearest to the frame
    if (type(frame) != "number") return self[frame] -- doesn't override metatable
    
    for i = 1, #self.keyframes do
        if (frame >= self.keyframes[i].frame) then
            local k1 = self.keyframes[i]                            -- current key frame
            local k2 = self.keyframes[(i + 1) % self.keyframes]     -- gets next keyframe
            local progress = (f - k1.frame) / (k2.frame - k1.frame) -- progress to next frame
            return k1, k2, progress                                 -- returns both frames and progress
        end
    end
end