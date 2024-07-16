--[[
    a class for the heirarchy of bones and their skins.

    hm, i would have expected the joint/bone to hold the skin information...

]]

include("skeleton/transform.lua")
include("skeleton/bone.lua")

Skeleton = {}
Skeleton.__index = Skeleton
Skeleton.__type = "skeleton"

function Skeleton:new(core, necromancer, debug)
    if (not core) core = Bone:new(
        "core",
        Vec:new(0, -4),     -- points from hips to skull
        0,                  -- default depth
        Vec:new(0, -8)      -- starts off the ground
    )

    debug = debug or false
    local s = {
        core = core,
        bones = {},
        necromancer = necromancer,
        debug = debug       -- shows skeleton as coloured lines
    }

    -- skin map

    setmetatable(s, Skeleton)
    s:findbones() -- updates bones
    return s
end


-- draws the skeleton
function Skeleton:draw(offset)
    offset = offset or {x = 0, y = 0} -- converts model coordinates to world coordinates
    for _, bone in pairs(self.bones) do
        bone:draw(offset)
    end

    -- draws origin
    if (self.debug) circfill(offset.x, offset.y, 1, 8)
end

-- updates skeleton
function Skeleton:update()
    local pose = self.necromancer:update()
    self:dance(pose)
end


-- sets the list of bones, recursing down children
-- also gives the bones a reference to their owner
function Skeleton:findbones()
    self.bones[self.core.name] = self.core
    self.core.skeleton = self
    self:_findbones(self.core)
end

function Skeleton:_findbones(current_bone)
    local tip = current_bone:tip()
    for bone in all(current_bone.children) do
        self.bones[bone.name] = bone
        bone.skeleton = self
        bone.transform.pos += tip   -- attatches bone

        self:_findbones(bone)       -- recurses, finding bones of current's children
    end
end

-- applies a pose to the skeleton
function Skeleton:dance(pose)   -- pose is a table of joint transforms
    self.core:dance(    -- applies to core; will cascade down from there
        pose
    )
end
