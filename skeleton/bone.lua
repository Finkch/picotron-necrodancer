--[[
    a class for a bone/joint in a skeleton

]]

Bone = {}
Bone.__index = Bone
Bone.__type = "bone"

function Bone:new(name, transform)
    local b = {
        name = name,
        children = {},
        transform = transform -- current position, relative to model default
    }

    -- skin?

    setmetatable(b, Bone)
    return b
end