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

    local skeleton = load_example_skeleton()

    return skeleton
end

function load_example_skeleton(necromancer)

    local core = Bone:new(
        "core",             -- aka hips
        Vec:new(0, -8),     -- points from hip to skull
        0,                  -- default depth
        Transform:new(),
        Vec:new(0, -12)     -- 12 units off the ground
    )

    local rleg = Bone:new(
        "right leg",
        Vec:new(0, 6),
        1,
        Transform:new(),
        Vec:new(-4, 9)
    )

    local rforeleg = Bone:new(
        "right foreleg",
        Vec:new(0, 6),
        2
    )
    rleg:add(rforeleg)
    core:add(rleg)


    local lleg = Bone:new(
        "left leg",
        Vec:new(0, 6),
        1,
        Transform:new(),
        Vec:new(4, 9)
    )

    local lforeleg = Bone:new(
        "left foreleg",
        Vec:new(0, 6),
        2
    )
    
    lleg:add(lforeleg)
    core:add(lleg)
    
    local necromancer = load_example_necromancer()

    local skeleton = Skeleton:new(core, necromancer, true)

    return skeleton
end

function load_example_pose()
    local pose = {}

    pose["right leg"] = -0.12
    pose["right foreleg"] = 0.12

    return pose
end

function load_example_animation()

    local keyframes = {}

    local t1 = {}
    local t2 = {}

    t1["right leg"] = 0
    t2["right leg"] = 0.125

    add(keyframes, Keyframe:new(
        60,
        t1
    ))

    add(keyframes, Keyframe:new(
        60,
        t2
    ))

    return Animation:new(
        keyframes
    )
end

function load_example_necromancer()
    local animation = load_example_animation()
    local necromancer = Necromancer:new(animation)

    return necromancer
end