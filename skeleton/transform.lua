--[[
    represents a bone's transform relative to its parent bone

]]

Transform = {}
Transform.__index = Transform
Transform.__type = Transform

function Transform:new(pos, rot)
    pos = pos or {x = 0, y = 0}
    rot = rot or 0
    local t = {
        pos = pos,
        rot = rot
    }

    setmetatable(t, Transform)
    return t
end


function Transform:copy()
    return Transform:new(
        self.pos:copy(),
        self.rot
    )
end


-- transforms a vector
function Transform:__mul(other)
    if (other.__type == "vec") then
        return other:rotate(self.rot) + self.pos

    elseif (type(other) == "number") then
        return Transform:new(
            self.pos * other,
            self.rot * other
        )

    else
        error("cannot multiply transform with type \"" .. type(other) .. "\" (" .. tostr(other.__type) .. ")")
    end
end


-- metamethods
function Transform:__tostring()
    return tostr(self.pos) .. " @ " .. self.rot
end