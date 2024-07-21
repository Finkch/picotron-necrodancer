--[[pod_format="raw",created="2024-07-06 20:07:26",modified="2024-07-07 02:28:31",revision=599]]


-- a simple queue-like class

include("lib/tstr.lua")

Q = {}
Q.__index = Q

function Q:new(max)
    max = max or 64
    local q = {
        data = {},
        max = max
    }

    setmetatable(q, Q)
    return q
end

function Q:add(datum)
    if (self:full()) return -- don't add if full

    self[#self + 1] = datum
end


function Q:clear()
    self.data = {}
end

function Q:print(x, y, col) -- also clears self!
    col = col or 5
    x = x or 0
    y = y or 0
    print(tostr(self), x, y, col)
    self:clear()
end

function Q:printh()
    printh(tostr(self))
    self:clear()
end

-- metamethods
function Q:__tostring()
    local str = ""
    
    for i = 1, #self do
        str ..= tstr(self[i]) .. "\n"
    end

    return str
end

function Q:__index(key)
    -- looks in data
    if (type(key) == "number") return self.data[key]

    -- makes sure not to override metatable of Q
    return Q[key]
end

function Q:__newindex(key, value)
    if (type(key) == "number") then
        self.data[key] = value
    else
        rawset(self, key, value)
    end
end

-- size
function Q:__len()
    return #self.data
end

function Q:empty()
    return #self == 0
end

function Q:full()
    return #self == self.max
end