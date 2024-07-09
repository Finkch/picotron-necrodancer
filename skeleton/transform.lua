--[[
    represents a bone's transform relative to its parent bone

]]

Transform = {}
Transform.__index = Transform
Transform.__type = Transform

function Transform:new(pos, rot)
    rot = rot or 0
    local t = {
        pos = pos,
        rot = rot
    }

    setmetatable(t, Transform)
    return t
end


-- transforms a vector
function Transform:__mul(vec)
    return vec:rotate(self.rot) + self.pos
end