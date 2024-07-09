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
        frame = 0               -- frame/time
    }

    setmetatable(n, Necromancer)
    return n
end