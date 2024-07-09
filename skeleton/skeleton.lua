--[[
    a class for the heirarchy of bones and their skins.

    hm, i would have expected the joint/bone to hold the skin information...

]]

Skeleton = {}
Skeleton.__index = Skeleton
Skeleton.__type = "skeleton"

function Skeleton:new(core, debug)
    debug = debug or false
    local s = {
        core = core,
        bones = {},
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


-- sets the list of bones, recursing down children
-- also gives the bones a reference to their owner
function Skeleton:findbones()
    self.bones[self.core.name] = self.core
    self.core.skeleton = self
    self:_findbones(self.core) 
end

function Skeleton:_findbones(current_bone)
    for name, bone in pairs(current_bone.children) do
        self.bones[name] = bone
        bone.skeleton = self
    end
end