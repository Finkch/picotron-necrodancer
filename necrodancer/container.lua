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


-- moves the camera to the container
function Container:focus(style)
    if (not style) style = "tl"

    if (style == "tl") then
        camera(-self.x, -self.y)
    elseif (style == "c") then
        camera(-(2 * self.x + self.width) / 2, -(2 * self.y + self.height) / 2)
    end
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

    -- moves camera
    self:focus("tl")
    
    -- clears the screen
    rectfill(0, 0, self.width, self.height, self.cls)
        
    -- draws the border
    line(-1, -1, -1, self.height + 1, 5)
    line(-1, -1, self.width, -1, 5)

    line(self.width + 1, self.height + 1, 0, self.height + 1, 7)
    line(self.width + 1, self.height + 1, self.width + 1, -1, 7)



    -- centres container contents
    self:focus("c")
    if (self.contents) self.contents:draw()
end


--[[
    a button is a contentless container that can be pressed

]]

Button = {}
Button.__index = Button
Button.__type = "button"
setmetatable(Button, Container)

function Button:new(x, y, text, cls, contents)

    -- prints offscreen to find the pixel width
    local w = print(text, 0, -20)

    local b = Container:new(x, y, w + 6, 14, cls, contents)
    b.text = text

    setmetatable(b, Button)
    return b
end

-- overrides Container:update_contents()
function Button:update_contents(gui)
    if (self.clicking and self.contents) self.contents:update() 
end


function Button:draw(gui)
    Container.draw(self)
    self:focus()
    print(self.text, 0, 0, 1)
end