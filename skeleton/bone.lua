--[[
    a class for a bone/joint in a skeleton

]]

Bone = {}
Bone.__index = Bone
Bone.__type = "bone"

function Bone:new(name, bone, transform, z)
    z = z or 1
    local b = {
        name = name,
        bone = bone,            -- vector that represents the bone itself; length and orientation
        children = {},
        transform = transform,  -- current position, relative to model default
        z = z,                  -- depth, used to determine draw order
        skelton = nil           -- tracks owner
    }

    -- skin?

    setmetatable(b, Bone)
    return b
end

-- draws the bone
function Bone:draw(offset)
    local s, e = self:span(offset)

    -- for now, just draws a red line and a circle
    if (self.skeleton.debug) then
        line(s.x, s.y, e.x, e.y, 18)
        circfill(s.x, s.y, 1, 2)
    end
end


-- adds child
function Bone:add(child)
    add(self.children, child)
end

-- gets the tip of the bone
function Bone:tip()
    return self.transform * self.bone
end

-- gets the two points for the bone's span
function Bone:span(offset) -- not sure about the how of this one yet
    offset = offset or {x = 0, y = 0}
    return self.transform.pos + offset, self:tip() + offset
end

-- applies a pose to this bone and to all of its children
function Bone:dance(pose, parenttip)
    -- yeah this one will be tough, chief

    local ownpose = pose[self.name]

    if (parenttip) then
        local n = ownpose * parenttip
        ownpose = Transform:new(
            n,
            n:dir()
        )
    end

    self.transform = ownpose    -- need to first multiply current transform by ownpose?

    for child in all(self.children) do
        child:dance(pose, self:tip())
    end
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

    return str
end