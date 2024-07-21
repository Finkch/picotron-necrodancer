--[[
    imports/exports skeleton from/to pod

]]

include("lib/tstr.lua")
include("lib/vec.lua")

include("skeleton/skeleton.lua")
include("skeleton/bone.lua")
include("skeleton/necromancer.lua")
include("skeleton/animation.lua")
include("skeleton/keyframe.lua")
include("skeleton/transform.lua")



function export(skeleton)

    -- dissects the skeleton into a table
    local tbl = skeleton:pod()

    -- transforms into a compressed pod
    return pod(tbl)
end


function import(skeleton)

    local tbl = unpod(skeleton)

    log("imp.txt", tstr(skeleton))

    local core = getbones(tbl.core)

    local necromancer = getnecromancer(tbl.necromancer)

    local skeleton = Skeleton:new(core, necromancer)
    log("imp.txt", tostr(skeleton), {"-a"})


    return skeleton
end
