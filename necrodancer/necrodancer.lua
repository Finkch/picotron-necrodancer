--[[pod_format="raw",created="2024-07-15 19:38:57",modified="2024-07-15 19:39:08",revision=4]]
--[[
    An editor to make and animate skeletons.

]]

include("necrodancer/gui.lua")
include("necrodancer/container.lua")

-- returns the window
function init_necrodancer(skeleton)

    local padding = 4


    -- application window to make a skeleton
    local gui = Gui:new("necrodancer", false, 245, 245, 180, 180, 6)



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

    local offsetx_slider = Slider:new(offsetx:middle_horizontal(), rotation_slider:top(), 49, true, 0, 25, 0)
    gui:attach(offsetx_slider)

    local offsety_slider = Slider:new(offsety:middle_horizontal(), offsetx_slider:top(), 49, true, 0, 25, 0)
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


    return gui
end