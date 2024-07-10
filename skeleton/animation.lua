--[[pod_format="raw",created="2024-07-10 03:03:19",modified="2024-07-10 03:03:19",revision=0]]
--[[
    describes a (re)animation for a skeleton

]]

Animation = {}
Animation.__index = Animation
Animation.__type = "animation"

function Animation:new(keyframes)
    local a = {
        keyframes = keyframes,  -- an ordered list of all keyframes in the animation
        duration = nil   
    }

    setmetatable(a, Animation)
    a:findduration()            -- gets total duration of animation and sets timestamps for keyframes
    return a
end

-- finds the total duration of the animation
function Animation:findduration()
    local duration = 0
    local initial_duration = self.keyframes[1].duration
    for keyframe in all(self.keyframes) do
        duration += keyframe.duration   -- adds duration to tally
        keyframe.frame = duration - initial_duration       -- sets the timestamp
    end
    self.duration = duration
end


-- metamethods
function Animation:get(frame)   -- returns the two animations nearest to the frame
    for i = 1, #self.keyframes do
        if (frame >= self.keyframes[i].frame) then
            local k1 = self.keyframes[i]                            -- current key frame
            local k2 = self.keyframes[i % #self.keyframes + 1]      -- gets next keyframe
            local progress = (f - k1.frame) / (k2.frame - k1.frame) -- progress to next frame
            return k1, k2, progress                                 -- returns both frames and progress
        end
    end
end