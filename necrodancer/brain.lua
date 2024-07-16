--[[
    functions and classes to connect gui elements

]]



--[[
    labelbrains grab data from a slider (or from anything with a :get())
    and push it into the label's readout

]]
    
LabelBrain = {}
LabelBrain.__index = LabelBrain
LabelBrain.__type = "labelbrain"

function LabelBrain:new(source, target)
    local lb = {
        source = source,
        target = target
    }

    setmetatable(lb, LabelBrain)
    return lb
end

function LabelBrain:update()
    local datum = self.source:get()

    if (type(datum) == "number") datum = tostr(flr(rnd(datum)))

    self.target.content = datum
end