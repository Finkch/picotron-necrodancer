--[[
    a class for the heirarchy of bones and their skins.

    hm, i would have expected the joint/bone to hold the skin information...

]]

Skeleton = {}
Skeleton.__index = Skeleton
Skeleton.__type = "skeleton"

function Skeleton:new(root)
    local s = {
        root = root,
        bones = {}
    }

    -- skin map

    setmetatable(s, Skeleton)
    return s
end

-- sets the list of bones, recursing down children
function Skeleton:findbones()
    self.bones[self.root.name] = self.root
    self:_findbones(self.root) 
end

function Skeleton:_findbones(current_bone)
    for name, bone in pairs(current_bone.children) do
        self.bones[name] = bone
    end
end