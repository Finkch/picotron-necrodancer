--[[
    (re)animates movement between keyframes.

    i really should have more serious names.

]]

Necromancer = {}
Necromancer.__index = Necromancer
Necromancer.__type = "necromancer"

function Necromancer:new(animation)
    local n = {
        current = animation,    -- current animation
        previous = nil          -- previous animation
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
end