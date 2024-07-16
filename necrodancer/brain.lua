--[[
    functions and classes to connect gui elements

]]



--[[
    generic brain

]]

Brain = {}
Brain.__index = Brain
Brain.__type = "brain"
Brain.__parenttype = "brain"

function Brain:new(target)
    local b = {
        target = target
    }

    setmetatable(b, Brain)
    return b
end

-- empty update functions. Must be overridden.
function Brain:update(gui) end




--[[
    labelbrains grab data from a slider (or from anything with a :get())
    and push it into the label's readout

]]

LabelBrain = {}
LabelBrain.__index = LabelBrain
LabelBrain.__type = "labelbrain"
setmetatable(LabelBrain, Brain)

function LabelBrain:new(target, source)
    local lb = Brain:new(target)
    lb.source = source

    setmetatable(lb, LabelBrain)
    return lb
end

function LabelBrain:update(gui)
    local datum = self.source:get()

    if (type(datum) == "number") datum = tostr(flr(datum))

    self.target.contents = datum
end