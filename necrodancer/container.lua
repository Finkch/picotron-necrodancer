--[[
    a thing within a gui.
    very verbose, me.

]]

Container = {}
Container.__index = Container
Container.__type = "container"

function Container:new(x, y, width, height, padding, cls, contents)
    local c = {
        x = x,              -- position within gui
        y = y,

        width = width,      -- size of container
        height = height,

        padding = padding,  -- distance to other contianers
        
        cls = cls,          -- colours to draw
        border = border,

        contents = contents,-- a draw function to call to draw its contents

        allignment = "left"
    }

    setmetatable(c, Container)
    return c
end

-- updates contents
function Container:update()
    if (self.contents) self.contents:update()
end

-- draws container & contents
function Container:draw()

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