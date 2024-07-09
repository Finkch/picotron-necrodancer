--[[
    a place to find skeletons.

    what i mean is you load skeleton and animation data from here.

]]

include("lib/vec.lua")

include("skeleton/skeleton.lua")
include("skeleton/bone.lua")
include("skeleton/necromancer.lua")
include("skeleton/animation.lua")
include("skeleton/keyframe.lua")
include("skeleton/transform.lua")

function load_example()

    local core = Bone:new(
        "core",         -- aka hips
        Vec:new(0, -4), -- points from hip to skull
        Transform:new(
            Vec:new(0, -12),    -- hips are 12 units above the ground
            0                   -- no rotation
        ),
        0               -- default depth
    )



    local skeleton = Skeleton:new(core, true)

    return skeleton
end