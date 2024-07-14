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

        cls = cls,              -- colour to clear with (aka background colour)

        containers = {}         -- array of containers attatched
    }

    setmetatable(g, Gui)
    g:create()
    return g
end

-- creates a window
function Gui:create()
    window({
		width = self.width,
		height = self.height,
		resizeable = self.resizable,
		title = self.name
	})
end

-- attatches a container
function Gui:attach(container)
    add(self.containers, container)
end

-- updates dimensions
function Gui:update()

    -- ensures current dimensions are not too small
    self.width = max(get_display():width(), self.minwidth)
    self.height = max(get_display():height(), self.minheight)

    window({
        width = self.width,
        height = self.height
    })

end

-- draws
function Gui:draw()
    cls(self.cls)
    for container in all(self.containers) do
        container:draw()
    end
end