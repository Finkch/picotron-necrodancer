--[[
    (re)animates movement between keyframes.

    i really should have more serious names.

]]

Necromancer = {}
Necromancer.__index = Necromancer
Necromancer.__type = "necromancer"

function Necromancer:new()
    local n = {

    }

    -- animation to play

    -- frame

    setmetatable(n, Necromancer)
    return n
end