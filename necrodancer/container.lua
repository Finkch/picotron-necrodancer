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
    if (self.contents and self.contents.draw) self.contents:draw()
end


--[[
    a label is a container whose contents are not updated.
    

]]

Label = {}
Label.__index = Label
Label.__type = "label"
setmetatable(Label, Container)

function Label:new(x, y, cls, contents, colour, width, height)

    -- gets the width and height
    local w, h = -1, -1
    local istext = nil                  -- whether contents is text or a sprite

    if (type(contents) == "string") then
        w, h = print(contents, 0, -20) + 4, 13
        istext = true 

    elseif (type(contents) == "number") then
        contents = get_spr(contents)    -- updates contents to be the sprite
        w, h = contents:width() + 3, contents:height() + 3
        istext = false
    end

    -- overrides width and height
    if (width)  w = width
    if (height) h = height


    local l = Container:new(x, y, w, h, cls, contents)
    l.istext = istext
    l.padding = 2
    l.colour = colour

    setmetatable(l, Label)
    return l
end

-- overrides Container update; does not update!
function Label:update_contents(gui) end

function Label:draw(gui)

    Container.draw(self)

    -- moves camera to topleft of container
    self:focus()

    -- draws button image
    if (self.istext) then
        print(self.contents, 3, 3, self.colour)
    else
        spr(self.contents, 2, 2)
    end
end




--[[
    a button is a contentless container that can be pressed

]]

Button = {}
Button.__index = Button
Button.__type = "button"
setmetatable(Button, Label)

function Button:new(x, y, cls, contents, colour, width, height)

    local b = Label:new(x, y, cls, contents, colour, width, height)
    b.active = true

    setmetatable(b, Button)
    return b
end

-- overrides Container:update()
function Button:update(gui)
    if (self.active) then
        self:update_status(gui)
        self:update_contents(gui)
    else
        self.hovering = false
        self.clicking = false
        self.holding =  false
        self.clicked =  false
    end
end

function Button:update_contents(gui)
    if (self.clicking and self.contents and self.contents.update) self.contents:update() 
end


function Button:draw(gui)

    -- greys out button when its not active
    if (not self.active) then
        pal(5, 0)
        pal(6, 5)
    end


    -- swaps colours to make it look asif button is rising from window
    if (not self.clicked and self.active) then
        pal(5, 7)
        pal(7, 5)
    end

    -- draws regular container
    Label.draw(self)

    -- two width border (other layer is from container draw)
    self:focus()
    line(0, 0, 0, self.height, 5)
    line(0, 0, self.width, 0, 5)

    line(self.width, self.height, 0, self.height, 7)
    line(self.width, self.height, self.width, 0, 7)

    -- adds mid-tone grey to two corners
    line(self.width + 1, -1, self.width, 0, 6)
    line(-1, self.height + 1, 0, self.height, 6)
    

    -- reset palette
    pal()
end




--[[
    a slider is like a button to adjust values

]]

Slider = {}
Slider.__index = Slider
Slider.__type = "slider"
setmetatable(Slider, Container)

function Slider:new(x, y, length, vertical, minimum, maximum, current, colour)
    
    local w, h = -1, -1
    if (vertical) then
        w = 3
        h = length
    else
        w = length
        h = 3
    end

    local s = Container:new(x, y, w, h, 0, nil)
    s.minimum = minimum
    s.max = maximum
    s.current = current
    s.vertical = vertical
    s.colour = colour

    setmetatable(s, Slider)
    return s
end

function Slider:draw(gui)
    Container.draw(self)

    self:focus()

    local x, y = -1, -1
    if (self.vertical) then
        x = 1
        y = self:bottom() - (self.current * self.length)
    else
        x = self:left() + (self.current * self.length)
        y = 1
    end

    -- draws a circle at the current position
    circfill(x, y, 2, self.colour)
end