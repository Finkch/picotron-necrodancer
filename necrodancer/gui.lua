--[[
    handles the gui for the necrodancer
]]

Gui = {}
Gui.__index = Gui
Gui.__type = "gui"

function Gui:new(name, resizable, width, height, minwidth, minheight, cls)
    local g = {
        name = name,
        resizable = resizable,

        width = width,          -- window dimensions
        height = height,

        minwidth = minwidth,    -- minimum dimensions
        minheight = minheight,

        cls = cls               -- colour to clear with (aka background colour)
    }

    setmetatable(g, Gui)
    g:create()
    return g
end

function Gui:create()
    window({
		width = self.width,
		height = self.height,
		resizeable = self.resizable,
		title = self.name
	})
end

function Gui:update()

    -- ensures current dimensions are not too small
    self.width = get_display():width()
    self.height = get_display():height()

    if (self.width < self.minwidth) self.width = self.minwidth
    if (self.height < self.minheight) self.height = self.minheight

    window({
        width = self.width,
        height = self.height
    })

end

function Gui:draw()
    cls(self.cls)
end