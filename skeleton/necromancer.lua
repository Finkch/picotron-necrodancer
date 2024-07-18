--[[
    (re)animates movement between keyframes.

    i really should have more serious names. maybe necrodancer?

]]

include("skeleton/animation.lua")

Necromancer = {}
Necromancer.__index = Necromancer
Necromancer.__type = "necromancer"

function Necromancer:new(animations)

    if (not animations) then
        animations = {}
        animations["idle"] = Animation:new()
    end

    local n = {
        animations = animations,
        current = animations["idle"],   -- current animation
        previous = nil,                 -- previous animation
        interpolator = nil,             -- function used to interpolate between poses
        frame = 0                       -- frame/time
    }

    setmetatable(n, Necromancer)
    return n
end


-- sets new animation
function Necromancer:set(animation)
    self.previous = self.current    -- we'll want to keep transforms of last animation, not whole animation
    self.current = self.animations[animation]
    self.frame = 0
end

-- updates frame count
function Necromancer:update()
    self.frame += 1
    if (self.frame >= self.current.duration) self.frame = 0 -- loops

    -- gets frames and progress
    local k1, k2 = self:findkeyframes()
    local progress = self:progress(k1, k2)

    -- finds the pose
    return self:interpolate(k1, k2, progress)
end


-- figures out which pair of keyframes to use
function Necromancer:findkeyframes()
    local keyframes = self.current.keyframes
    local k1, k2 = keyframes[1], keyframes[1]   -- need to initialise for comparisons

    for i = 2, #keyframes do
        k2 = keyframes[i]

        if (k2.frame > self.frame) return k1, k2
        if (self.frame >= k2.frame and i == #keyframes) return k2, keyframes[1] -- allows k(-1) -> k(1)

        k1 = keyframes[i]
    end

    return k1, k2
end

-- finds the progress [0, 1) between the pair of keyframes
function Necromancer:progress(k1, k2) -- er, we don't need to pass k2
    return (self.frame - k1.frame) / k1.duration
end

function Necromancer:interpolate(k1, k2, progress)
    if (self.interpolator) return self:interpolator(k1, k2, progress, self)

    -- gets linear interpolation, if provided no other interpolator
    local transforms = {}

    for bone, _ in pairs(k1.transforms) do
        transforms[bone] = (k1.transforms[bone] * (1 - progress) + k2.transforms[bone] * progress) / 2
    end

    return transforms
end