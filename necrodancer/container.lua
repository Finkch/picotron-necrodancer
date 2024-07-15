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

        padding = 2,        -- size of border

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


-- returns coordinates
function Container:top(padding)
    padding = padding or 0
    if (padding > 0) padding -= self.padding
    return self.y - padding
end

function Container:right(padding)
    padding = padding or 0
    if (padding > 0) padding += self.padding
    return self.x + self.width + padding
end

function Container:bottom(padding)
    padding = padding or 0
    if (padding > 0) padding += self.padding
    return self.y + self.height + padding
end

function Container:left(padding)
    padding = padding or 0
    if (padding > 0) padding -= self.padding
    return self.x - padding
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
    --if (type(text) == "string") local w, h = print(text, 0, -20) + 4, 13
    local w, h, s = -1, -1, -1
    local istext = nil
    if (type(text) == "string") then
        w, h = print(text, 0, -20) + 4, 13
        istext = true
    elseif (type(text) == "number") then
        s = get_spr(text)
        w, h = s:width() + 3, s:height() + 3
        istext = false
    end

    local b = Container:new(x, y, w, h, cls, contents)
    b.text = text
    b.istext = istext
    b.padding = 3

    setmetatable(b, Button)
    return b
end

-- overrides Container:update_contents()
function Button:update_contents(gui)
    if (self.clicking and self.contents) self.contents:update() 
end


function Button:draw(gui)
    
    -- swaps colours to make it look asif button is rising from window
    if (not self.clicked) then
        pal(5, 7)
        pal(7, 5)
    end

    -- draws regular container
    Container.draw(self)

    -- two width border (other layer is from container draw)
    self:focus()
    line(0, 0, 0, self.height, 5)
    line(0, 0, self.width, 0, 5)

    line(self.width, self.height, 0, self.height, 7)
    line(self.width, self.height, self.width, 0, 7)

    -- adds mid-tone grey to two corners
    line(self.width + 1, -1, self.width, 0, 6)
    line(-1, self.height + 1, 0, self.height, 6)

    -- draws button image
    if (self.istext) then
        print(self.text, 3, 3, 5)
    else
        spr(self.text, 2, 2)
    end

    -- reset palette
    pal()
end