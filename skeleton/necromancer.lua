--[[
    (re)animates movement between keyframes.

    i really should have more serious names. maybe necrodancer?

]]

Necromancer = {}
Necromancer.__index = Necromancer
Necromancer.__type = "necromancer"

function Necromancer:new(animation, skeleton)
    local n = {
        current = animation,    -- current animation
        previous = nil,         -- previous animation
        skeleton = skeleton,    
        interpolator = nil,     -- function used to interpolate between poses
        frame = 0               -- frame/time
    }

    setmetatable(n, Necromancer)
    return n
end


-- sets new animation
function Necromancer:set(animation)
    self.previous = self.current    -- we'll want to keep transforms of last animation, not whole animation
    self.current = animation
    self.frame = 0
end

-- updates frame count
function Necromancer:update()
    self.frame += 1
    if (self.frame >= self.current.duration) self.frame = 0 -- loops

    -- gets frames and progress
    local k1, k2, progress = self.current[self.frame]

    -- finds the pose
    local pose = self:interpolate(k1, k2, progress)

    -- applies the pose
    self.skeleton:dance(pose)
end

function Necromancer:interpolate(k1, k2, progress)
    if (self.interpolator) return self:interpolator(k1, k2, progress, self)

    -- gets linear interpolation, if provided no other interpolator
    local transforms = {}
    
    for bone, _ in pairs(k1.transforms) do
        transform[bone] = Transform:new(
            (k1.transforms[bone].pos + k2.transforms[bone].pos) / 2,
            (k1.transforms[bone].rot + k2.transforms[bone].rot) / 2
        )
    end

    return transforms
end