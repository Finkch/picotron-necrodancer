--[[
    represents a bone's transform relative to its parent bone

]]

Transform = {}
Transform.__index = Transform
Transform.__type = Transform

function Transform:new()
    local t = {

    }

    -- position
    
    -- rotation

    setmetatable(t, Transform)
    return t
end