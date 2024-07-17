--[[pod_format="raw",created="2024-07-15 19:38:57",modified="2024-07-15 19:39:08",revision=4]]
--[[
    An editor to make and animate skeletons.

]]

include("necrodancer/gui.lua")
include("necrodancer/container.lua")
include("necrodancer/brain.lua")

include("lib/vec.lua")

include("skeleton/bone.lua")
include("skeleton/transform.lua")

include("finkchlib/log.lua")

-- returns the window
function init_necrodancer(skeleton)

    local padding = 4


    -- application window to make a skeleton
    local gui = Gui:new("necrodancer", false, 245, 245, 180, 180, 6)


    -- adds some data to the gui
    gui.data["skeleton"] = skeleton
    gui.data["current"] = skeleton.core
    gui.data["max"] = 1
    gui.data["count"] = 1
    gui.data["i"] = 0




    --[[
        creates containers
    
    ]]

    -- container that holds the skeleton
    local grave = Container:new(3, padding, 128, 128, 0, skeleton)
    gui:attach(grave)



    -- add and remove bones, plus label that says "current bone"
    local rmbone = Button:new(grave:right(padding), grave:top(), 6, 4)
    gui:attach(rmbone)
    rmbone.active = false

    local curbone = Label:new(rmbone:right(padding), rmbone:top(), 0, "Current Bone", 7)
    gui:attach(curbone)

    local addbone = Button:new(curbone:right(padding), curbone:top(), 6, 3)
    gui:attach(addbone)


    
    -- next and previous, plus label that says the $current_bone
    local prev = Button:new(rmbone:left(), rmbone:bottom(padding), 6, 6)
    gui:attach(prev)
    prev.active = false

    local curread = Label:new(prev:right(padding), prev:top(), 0, "0", 8, curbone:right() - curbone:left())
    gui:attach(curread)

    local next = Button:new(curread:right(padding), curread:top(), 6, 5)
    gui:attach(next)
    next.active = false



    -- labels for the sliders
    local length = Label:new(grave:left(), grave:bottom(padding), 0, " Length ", 7)
    gui:attach(length)

    local rotation = Label:new(length:right(padding), length:top(), 0, "Rotation", 7)
    gui:attach(rotation)

    local offsetx = Label:new(rotation:right(padding), rotation:top(), 0, "Offset x", 7)
    gui:attach(offsetx)

    local offsety = Label:new(offsetx:right(padding), offsetx:top(), 0, "Offset y", 7)
    gui:attach(offsety)



    --  sliders for the bones
    local length_slider = Slider:new(length:middle_horizontal(), length:bottom(2 * padding), 49, true, 1, 25, 0.33)
    gui:attach(length_slider)

    local rotation_slider = Slider:new(rotation:middle_horizontal(), length_slider:top(), 49, true, 0, 1, 0)
    gui:attach(rotation_slider)

    local offsetx_slider = Slider:new(offsetx:middle_horizontal(), rotation_slider:top(), 49, true, -25, 25, 0)
    gui:attach(offsetx_slider)

    local offsety_slider = Slider:new(offsety:middle_horizontal(), offsetx_slider:top(), 49, true, -25, 25, 0)
    gui:attach(offsety_slider)



    -- readouts for the sliders
    local length_readout = Label:new(length:left(), length_slider:bottom(2 * padding), 0, tostr(flr(length_slider:get())), 8, 44)
    gui:attach(length_readout)

    local rotation_readout = Label:new(rotation:left(), rotation_slider:bottom(2 * padding), 0, tostr(flr(rotation_slider:get())), 8, 44)
    gui:attach(rotation_readout)

    local offsetx_readout = Label:new(offsetx:left(), offsetx_slider:bottom(2 * padding), 0, tostr(flr(offsetx_slider:get())), 8, 44)
    gui:attach(offsetx_readout)
    
    local offsety_readout = Label:new(offsety:left(), offsety_slider:bottom(2 * padding), 0, tostr(flr(offsety_slider:get())), 8, 44)
    gui:attach(offsety_readout)



    -- import/export buttons
    local import = Button:new(offsety_readout:right(1.5 * padding), offsety_slider:bottom(-5), 6, "Import", 5)
    gui:attach(import)

    local export = Button:new(import:left(), import:bottom(padding), 6, "Export", 5)
    gui:attach(export)






    --[[
        creates brains

    ]] 
    
    -- connects slider readouts to sliders
    local length_brain = LabelBrain:new(length_readout, length_slider)
    gui:attach(length_brain)
    
    local rotation_brain = LabelBrain:new(rotation_readout, rotation_slider, 2)
    gui:attach(rotation_brain)

    local offsetx_brain = LabelBrain:new(offsetx_readout, offsetx_slider, 1)
    gui:attach(offsetx_brain)

    local offsety_brain = LabelBrain:new(offsety_readout, offsety_slider, 1)
    gui:attach(offsety_brain)



    -- connects bone to sliders
    length_slider.when_clicked = function(self, gui)
        gui.data.current.bone = gui.data.current.bone:normal() * self:get()
    end

    length_slider.when_not_clicked = function(self, gui)
        self:put(gui.data.current.bone:mag())
    end


    rotation_slider.when_clicked = function(self, gui)
        gui.data.current:rotate(gui.data.current.bone:dir() - self:get())
    end

    rotation_slider.when_not_clicked = function(self, gui)
        self:put(gui.data.current.bone:dir())
    end


    offsetx_slider.when_clicked = function(self, gui)
        local v = self:get()
        if (abs(v) < 1) v = 0
        gui.data.current.joint = Vec:new(v, gui.data.current.joint.y)
    end

    offsetx_slider.when_not_clicked = function(self, gui)
        self:put(gui.data.current.joint.x)
    end


    offsety_slider.when_clicked = function(self, gui)
        local v = self:get()
        if (abs(v) < 1) v = 0
        gui.data.current.joint = Vec:new(gui.data.current.joint.x, v)
    end

    offsety_slider.when_not_clicked = function(self, gui)
        self:put(gui.data.current.joint.y)
    end





    -- current bone readout
    local bone_readout = Brain:new(curread)
    bone_readout.update = function(self, gui)
        self.target.image = gui.data.current.name
    end
    gui:attach(bone_readout)





    -- previous and next bones
    local prev_brain = Brain:new()
    prev_brain.update = function(self, gui)
        local i = 0
        for _, bone in pairs(gui.data.skeleton.bones) do
            if ((i - 1) % gui.data.count == gui.data.i) then
                gui.data.i = i
                gui.data.current = bone
                return
            end
            i += 1
        end
    end
    prev.contents = prev_brain

    prev.update_active = function(self, gui)
        self.active = gui.data.count > 1
    end


    local next_brain = Brain:new()
    next_brain.update = function(self, gui)
        local i = 0
        for _, bone in pairs(gui.data.skeleton.bones) do
            if ((i + 1) % gui.data.count == gui.data.i) then
                gui.data.i = i
                gui.data.current = bone
                log("brains.txt", "i:\t" .. i .. " / " .. gui.data.i .. "\ncurrent:\t" .. bone.name, {"-a"})
                return
            end
            i += 1
        end
    end
    next.contents = next_brain

    next.update_active = function(self, gui)
        self.active = gui.data.count > 1
    end





    -- adding bones
    local addbone_brain = Brain:new(skeleton)
    addbone_brain.update = function(self, gui)
        local current = gui.data.current

        local bone = Bone:new(
            tostr(gui.data.max),
            current.bone:copy(),
            current.z,
            nil,
            current.transform:copy()
        )

        gui.data.skeleton:add(bone, current)
        gui.data.current = bone
        gui.data.count += 1
        gui.data.max += 1
    end
    addbone.contents = addbone_brain


    -- removing bones
    local rmbone_brain = Brain:new(skeleton)
    rmbone_brain.update = function(self, gui)
        local current = gui.data.current

        gui.data.skeleton:remove(current)
        gui.data.current = gui.data.skeleton.core
        gui.data.i = 0

        -- finds max and count
        gui.data.count = 0
        gui.data.max = 1
        for _, bone in pairs(gui.data.skeleton.bones) do

            gui.data.count += 1

            -- plus 1 in the max to set it to the next bone.
            -- we need to convert it from string to number anyways.
            if (bone.name != "core") gui.data.max = max(bone.name + 1, gui.data.max)
        end
    end
    rmbone.contents = rmbone_brain

    rmbone.update_active = function(self, gui)
        self.active = gui.data.current.name != "core"
    end



    return gui
end