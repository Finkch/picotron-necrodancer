--[[
    a thing within a gui.
    very verbose, me.

]]

Container = {}
Container.__index = Container
Container.__type = "container"

function Container:new(x, y, width, height, cls, contents)
    local c = {
        x = x,              -- position within gui
        y = y,

        width = width,      -- size of container
        height = height,
        
        cls = cls,          -- colours to draw
        border = border,

        contents = contents,-- a draw function to call to draw its contents

        hovering = false,   -- whether or not the mouse is over this container
        clicking = false,   -- whether or not the mouse has clicked this container
        holding  = false,   -- whether or not the mouse is being held down on this container
        clicked  = false,   -- used for state (true on click until no longer holding)
    }

    setmetatable(c, Container)
    return c
end

-- determines whether the mouse is above the container
function Container:hover(gui)
    local pos = gui.kbm.pos
    return (
        pos.x > self.x and
        pos.y > self.y and
        pos.x < self.x + self.width and
        pos.y < self.y + self.height
    )
end

-- whether the container has been clicked (mouse down first frame)
function Container:click(gui)
    return self:hover(gui) and gui.kbm:pressed("lmb")
end

-- whether the container has been clicked (mouse down all frames)
function Container:hold(gui)
    return self:hover(gui) and gui.kbm:down("lmb") > 0
end


-- updates
function Container:update(gui)
    self:update_status(gui)
    self:update_contents(gui)
end

function Container:update_status(gui)   -- mouse status
    self.hovering = self:hover(gui)
    self.clicking = self:click(gui)
    self.holding = self:hold(gui)

    if (self.clicking) self.clicked = true
    if (not self.holding) self.clicked = false
end

function Container:update_contents(gui)          -- updates content
    if (self.contents) self.contents:update()
end

-- draws container & contents
function Container:draw(gui)

    -- gets values for easy reference
    local minx, miny = self.x, self.y
    local maxx, maxy = self.x + self.width, self.y + self.height
    
    -- clears the screen
    rectfill(minx, miny, maxx, maxy, self.cls)
    
    -- draws the border
    line(minx - 1, miny - 1, minx - 1, maxy + 1, 5)
    line(minx - 1, miny - 1, maxx, miny - 1, 5)

    line(maxx + 1, maxy + 1, minx, maxy + 1, 7)
    line(maxx + 1, maxy + 1, maxx + 1, miny - 1, 7)


    -- centres container contents
    camera(-(2 * self.x + self.width) / 2, -(2 * self.y + self.height) / 2)
    if (self.contents) self.contents:draw()
end


--[[
    a button is a contentless container that can be pressed

]]

Button = {}
Button.__index = Button
Button.__type = "button"
setmetatable(Button, Container)

function Button:new(x, y, width, height, cls, contents)
    local b = Container:new(x, y, width, height, cls, contents)

    setmetatable(b, Button)
    return b
end

-- overrides Container:update_contents()
function Button:update_contents(gui)
    if (self.clicking and self.contents) self.contents:update() 
end


function Button:draw(gui)
end