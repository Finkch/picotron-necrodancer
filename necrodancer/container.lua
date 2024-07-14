--[[
    a thing within a gui.
    very verbose, me.

]]

Container = {}
Container.__index = Container
Container.__type = "container"

function Container:new(x, y, width, height, padding, cls, border, contents)
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

function Container:update()
    if (self.contents) self.contents:update()
end

function Container:draw()


    local minx, miny = self.x, self.y
    local maxx, maxy = self.x + self.width, self.y + self.height

    print(minx .. ", " ..  miny, minx + 50, miny+50, 8)

    rectfill(minx, miny, maxx, maxy, self.cls)
    rect(minx - 1, miny - 1, maxx + 1, maxy + 1, self.border)

    -- centres container contents
    camera(-(2 * self.x + self.width) / 2, -(2 * self.y + self.height) / 2)
    if (self.contents) self.contents:draw()
end