--[[
    handles the gui for the necrodancer
]]

include("lib/kbm.lua")

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

        containers = {},        -- array of containers attatched
        kbm = KBM:new({"lmb"})
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

    -- updates keyboard and mouse
    self.kbm:update()

    -- ensures current dimensions are not too small
    self.width = max(get_display():width(), self.minwidth)
    self.height = max(get_display():height(), self.minheight)

    window({
        width = self.width,
        height = self.height
    })

    -- updates containers, for those that need it
    for container in all(self.containers) do
        if (container.update) container:update(self)
    end

end

-- draws
function Gui:draw()
    camera() -- resets camera
    cls(self.cls)
    for container in all(self.containers) do
        container:draw(self)
    end
end