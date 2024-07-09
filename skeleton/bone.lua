--[[
    a class for a bone/joint in a skeleton

]]

Bone = {}
Bone.__index = Bone
Bone.__type = "bone"

function Bone:new(name, transform)
    local b = {
        name = name,
        children = {},
        transform = transform -- current position, relative to model default
    }

    -- skin?

    setmetatable(b, Bone)
    return b
end

-- adds child
function Bone:add(child)
    add(self.children, child)
end

 
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