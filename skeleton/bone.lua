--[[
    a class for a bone/joint in a skeleton

]]

Bone = {}
Bone.__index = Bone
Bone.__type = "bone"

function Bone:new()
    local b  ={

    }

    -- id

    -- children array

    -- current transform (to model default)

    -- skin?

    setmetatable(b, Bone)
    return b
end