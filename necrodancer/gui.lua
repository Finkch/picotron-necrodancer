--[[
    handles the gui for the necrodancer
]]

Gui = {}
Gui.__index = Gui
Gui.__type = "gui"

function Gui:new()
    local g = {
        name = "necrodancer",
        resizable = true,

        width = 200,       -- window dimensions
        height = 200,

        widthmin = 180,    -- minimum dimensions
        heightmin = 150,
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

    if (self.width < self.widthmin) self.width = self.widthmin
    if (self.height < self.heightmin) self.height = self.heightmin

    window({
        width = self.width,
        height = self.height
    })

end

function Gui:draw()
    cls()
end