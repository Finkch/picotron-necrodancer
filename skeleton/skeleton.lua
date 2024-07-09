--[[
    a class for the heirarchy of bones and their skins.

    hm, i would have expected the joint/bone to hold the skin information...

]]

Skeleton = {}
Skeleton.__index = Skeleton
Skeleton.__type = "skeleton"

function Skeleton:new(core)
    local s = {
        core = core,
        bones = {}
    }

    -- skin map

    setmetatable(s, Skeleton)
    return s
end


-- draws the skeleton
function Skeleton:draw(offset)
    offset = offset or {x = 0, y = 0} -- converts model coordinates to world coordinates
    for bone in all(self.bones) do
        bone:draw(offset)
    end
end


-- sets the list of bones, recursing down children
function Skeleton:findbones()
    self.bones[self.core.name] = self.core
    self:_findbones(self.core) 
end

function Skeleton:_findbones(current_bone)
    for name, bone in pairs(current_bone.children) do
        self.bones[name] = bone
    end
end