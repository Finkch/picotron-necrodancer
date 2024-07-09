--[[
    a class for a bone/joint in a skeleton

]]

Bone = {}
Bone.__index = Bone
Bone.__type = "bone"

function Bone:new(name, bone, transform)
    local b = {
        name = name,
        bone = bone,            -- vector that represents the bone itself; length and orientation
        children = {},
        transform = transform   -- current position, relative to model default
    }

    -- skin?

    setmetatable(b, Bone)
    return b
end

-- adds child
function Bone:add(child)
    add(self.children, child)
end

-- gets the two points for the bone's span
function Bone:span() -- not sure about the how of this one yet
    return self.transform, self.bone * self.transform

 
--[[
    metamethods
]]

function Bone:__tostring()
    local str = self.__type .. ": " .. self.name .. "\n-> children:\t"

    -- lists children
    for i = 1, #self.children do
        str ..= self.children[i].name
        
        if (i != #self.children) str ..= ", "
        
    end
    if (#self.children == 0) str ..= "nil"

    -- shows transform
    str ..= "\n-> " .. tostr(self.transform)

    return tostr
end