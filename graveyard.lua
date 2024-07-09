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
        Vec:new(0, -8), -- points from hip to skull
        Transform:new(
            Vec:new(0, -12),    -- hips are 12 units above the ground
            0                   -- no rotation
        ),
        0               -- default depth
    )

    local rleg = Bone:new(
        "right leg",
        Vec:new(0, 6),
        Transform:new(
            core.transform.pos + Vec:new(-3, 1),
            0
        ),
        1
    )

    local rforeleg = Bone:new(
        "right foreleg",
        Vec:new(0, 6),
        Transform:new(
            rleg:tip() + Vec:new(0, 1),
            0
        ),
        2
    )

    local lleg = Bone:new(
        "left leg",
        Vec:new(0, 6),
        Transform:new(
            core.transform.pos + Vec:new(3, 1),
            0.05
        ),
        1
    )

    local lforeleg = Bone:new(
        "left foreleg",
        Vec:new(0, 6),
        Transform:new(
            lleg:tip() + Vec:new(0, 1),
            0
        ),
        2
    )

    rleg:add(rforeleg)
    lleg:add(lforeleg)
    core:add(rleg)
    core:add(lleg)

    local skeleton = Skeleton:new(core, true)

    return skeleton
end