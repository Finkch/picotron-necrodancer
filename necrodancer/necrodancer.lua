--[[pod_format="raw",created="2024-07-15 19:38:57",modified="2024-07-15 19:39:08",revision=4]]
--[[
    An editor to make and animate skeletons.

]]

include("necrodancer/gui.lua")
include("necrodancer/container.lua")
include("necrodancer/brain.lua")

include("lib/vec.lua")

include("skeleton/skeleton.lua")
include("skeleton/bone.lua")
include("skeleton/transform.lua")
include("skeleton/animation.lua")
include("skeleton/keyframe.lua")

include("finkchlib/log.lua")

-- returns the window
function init_necrodancer(skeleton)

    local padding = 4


    -- application window to make a skeleton
    --local gui = Gui:new("necrodancer", false, 300, 245, 180, 180, 6)
    local gui = Gui:new("necrodancer", false, 480, 245, 180, 180, 6)



    -- creates a debug window in which we can print stuff
    local w = 179
    local printout = Container:new(480 - w, padding, w - padding, 238 - padding, 0, nil)
    gui:attach(printout)

    printout.draw_extra = function(self, gui)
        self:focus()
        debug:print(4, 4, 8)
    end



    --[[ 
        adds some data to the gui

    ]]

    gui.data["mode"] = "skeleton"
    gui.data["time"] = 0
    gui.data.paused = false


    -- skeleton data
    local skeleton = Skeleton:new(nil, nil, true)
    skeleton.necromancer.paused = true
    gui.data["skeleton"] = skeleton
    gui.data["necromancer"] = skeleton.necromancer
    gui.data["current"] = skeleton.core
    gui.data["max"] = 1
    gui.data["count"] = 1
    gui.data["i"] = 0


    -- animation data
    local animation = Animation:new("current")
    skeleton.necromancer.animations["current"] = animation
    gui.data["animation"] = animation
    gui.data["currentkf"] = animation.keyframes[1]
    gui.data["countkf"] = 1
    gui.data["ikf"] = 1




    --[[
        creates containers
    
    ]]

    -- container that holds the skeleton
    local grave = Container:new(padding, padding, 128, 128, 0, skeleton)
    gui:attach(grave)

    -- links the current animation to the skeleton
    grave.update_extra = function(self, gui)
        if (gui.data.mode == "skeleton") then
            gui.data.skeleton.necromancer:set("empty")
            gui.data.time = 0

        elseif (gui.data.paused) then

            -- creates new animation with one keyframe being currentkf
            gui.data.skeleton.necromancer.animations[tostr(gui.data.ikf)] = Animation:new({gui.data.currentkf})

            -- set animation to the keyframe
            gui.data.skeleton.necromancer:set(tostr(gui.data.ikf))

            -- resets time to allow playing to start again
            gui.data.time = 0

        else
            -- sets animation to the actual animation
            if (gui.data.time == 0) gui.data.skeleton.necromancer:set("current")

            gui.data.time += 1
        end
    end

    -- adds a function to grave to highlight current bone
    grave.draw_extra = function(self, gui)
        local s, e = gui.data.current:span(offset)

        line(s.x, s.y, e.x, e.y, 17)
        circfill(s.x, s.y, 1, 19)
    end





    -- mode toggle
    local skeleton_mode = Button:new(grave:right(padding + 3), grave:top(), 6, "Skeleton", 5)
    skeleton_mode.mode = "animation"
    gui:attach(skeleton_mode)

    local animation_mode = Button:new(skeleton_mode:right(2 * padding + 1), skeleton_mode:top(), 6, "Animation", 5)
    animation_mode.mode = "skeleton"
    gui:attach(animation_mode)


    skeleton_mode.update_active = function(self, gui)
        self.active = true
        if (self.clicked) then
            gui.data.mode = "skeleton"
            gui.data.necromancer.paused = true
        end
    end

    animation_mode.update_active = function(self, gui)
        self.active = true
        if (self.clicked) gui.data.mode = "animation"
    end



    -- add and remove bones, plus label that says "current bone"
    local rmbone = Button:new(skeleton_mode:left(), skeleton_mode:bottom(2 * padding), 6, 4)
    rmbone.mode = "skeleton"
    gui:attach(rmbone)

    local curbone = Label:new(rmbone:right(padding), rmbone:top(), 0, "Current Bone", 7)
    gui:attach(curbone)

    local addbone = Button:new(curbone:right(padding), curbone:top(), 6, 3)
    addbone.mode = "skeleton"
    gui:attach(addbone)


    
    -- next and previous, plus label that says the $current_bone
    local prev = Button:new(rmbone:left(), rmbone:bottom(padding), 6, 6)
    gui:attach(prev)

    local curread = Label:new(prev:right(padding), prev:top(), 0, "0", 8, curbone:right() - curbone:left())
    gui:attach(curread)

    local next = Button:new(curread:right(padding), curread:top(), 6, 5)
    gui:attach(next)



    -- labels for the sliders
    local length = Label:new(grave:left(), grave:bottom(padding + 1), 0, " Length ", 7)
    length.mode = "skeleton"
    gui:attach(length)

    local rotation = Label:new(length:right(padding), length:top(), 0, "Rotation", 7)
    gui:attach(rotation)

    local offsetx = Label:new(rotation:right(padding), rotation:top(), 0, "Offset x", 7)
    gui:attach(offsetx)

    local offsety = Label:new(offsetx:right(padding), offsetx:top(), 0, "Offset y", 7)
    gui:attach(offsety)

    local duration = Label:new(offsety:right(padding), offsety:top(), 0, "Duration", 7)
    duration.mode = "animation"
    gui:attach(duration)

    local frame = Label:new(duration:right(padding), duration:top(), 0, " Frame ", 7, duration:right() - duration:left())
    frame.mode = "animation"
    frame.update_active = function(self, gui)
        self.active = gui.data.necromancer.paused
    end
    gui:attach(frame)




    --  sliders for the bones 
    local length_slider = Slider:new(length:middle_horizontal(), length:bottom(2 * padding), 49, true, 1, 25, 1)
    length_slider.mode = "skeleton"
    gui:attach(length_slider)

    local rotation_slider = Slider:new(rotation:middle_horizontal(), length_slider:top(), 49, true, -1, 1, 0.01)
    gui:attach(rotation_slider)

    local offsetx_slider = Slider:new(offsetx:middle_horizontal(), rotation_slider:top(), 49, true, -25, 25, 1)
    gui:attach(offsetx_slider)

    local offsety_slider = Slider:new(offsety:middle_horizontal(), offsetx_slider:top(), 49, true, -25, 25, 1)
    gui:attach(offsety_slider)

    local duration_slider = Slider:new(duration:middle_horizontal(), offsety_slider:top(), 49, true, 2, 120, 1)
    duration_slider.mode = "animation"
    gui:attach(duration_slider)

    local frame_slider = Slider:new(frame:middle_horizontal(), duration_slider:top(), 49, true, 0, 1, 1)
    frame_slider.mode = "animation"
    frame_slider.update_active = function(self, gui)
        self.active = gui.data.necromancer.paused

        if (not self.active) self:put(gui.data.currentkf.frame)
    end
    gui:attach(frame_slider)

    -- attatches a few sliders so, together, they can make transforms
    rotation_slider.offsetx_slider = offsetx_slider
    rotation_slider.offsety_slider = offsety_slider

    offsetx_slider.rotation_slider = rotation_slider
    offsetx_slider.offsety_slider = offsety_slider

    offsety_slider.rotation_slider = rotation_slider
    offsety_slider.offsetx_slider = offsetx_slider




    -- readouts for the sliders
    local length_readout = Label:new(length:left(), length_slider:bottom(2 * padding), 0, tostr(flr(length_slider:get())), 8, length:right() - length:left())
    length_readout.mode = "skeleton"
    gui:attach(length_readout)

    local rotation_readout = Label:new(length_readout:right(padding), length_readout:top(), 0, tostr(flr(rotation_slider:get())), 8, rotation:right() - rotation:left())
    gui:attach(rotation_readout)

    local offsetx_readout = Label:new(rotation_readout:right(padding), rotation_readout:top(), 0, tostr(flr(offsetx_slider:get())), 8, offsetx:right() - offsetx:left())
    gui:attach(offsetx_readout)
    
    local offsety_readout = Label:new(offsetx_readout:right(padding), offsetx_readout:top(), 0, tostr(flr(offsety_slider:get())), 8, offsety:right() - offsety:left())
    gui:attach(offsety_readout)

    local duration_readout = Label:new(offsety_readout:right(padding), offsety_readout:top(), 0, tostr(flr(duration_slider:get())), 8, duration:right() - duration:left())
    duration_readout.mode = "animation"
    gui:attach(duration_readout)

    local frame_readout = Label:new(duration_readout:right(padding), duration_readout:top(), 0, "0", 8, frame:right() - frame:left())
    frame_readout.mode = "animation"
    gui:attach(frame_readout)





    --[[
        creates brains

    ]] 
    
    -- connects slider readouts to sliders
    local length_brain = LabelBrain:new(length_readout, length_slider)
    gui:attach(length_brain)
    
    local rotation_brain = LabelBrain:new(rotation_readout, rotation_slider, 2)
    gui:attach(rotation_brain)

    local offsetx_brain = LabelBrain:new(offsetx_readout, offsetx_slider)
    gui:attach(offsetx_brain)

    local offsety_brain = LabelBrain:new(offsety_readout, offsety_slider)
    gui:attach(offsety_brain)

    local duration_brain = LabelBrain:new(duration_readout, duration_slider)
    gui:attach(duration_brain)

    local frame_brain = LabelBrain:new(frame_readout, gui.data.necromancer)
    frame_brain.get = function(self, gui) -- custom get to link it to the necromancer
        local frame = self.source.frame
        if (frame < gui.data.currentkf.frame and self.source.paused) frame = gui.data.currentkf.frame
        return frame
    end
    gui:attach(frame_brain)



    -- connects bone/duration to sliders
    length_slider.when_clicked = function(self, gui)
        gui.data.current.bone = gui.data.current.bone:normal() * self:get()
    end

    length_slider.when_not_clicked = function(self, gui)
        self:put(gui.data.current.bone:mag())
    end


    rotation_slider.when_clicked = function(self, gui)
        if (gui.data.mode == "skeleton") then
            gui.data.current:rotate(gui.data.current.bone:dir() - self:get())
        else
            gui.data.currentkf:addbone(gui.data.current, Transform:new(
                    Vec:new(self.offsetx_slider:get(), self.offsety_slider:get()), 
                    self:get()
                )
            )
        end
    end

    rotation_slider.when_not_clicked = function(self, gui)
        -- add arbitrarily small amount to fix rounding error
        if (gui.data.mode == "skeleton") then
            self:put(gui.data.current.bone:dir() + 0.0001)
        else
            self:put(gui.data.currentkf:get(gui.data.current).rot + 0.0001)
        end
    end


    offsetx_slider.when_clicked = function(self, gui)
        if (gui.data.mode == "skeleton") then
            gui.data.current.joint = Vec:new(self:get(), gui.data.current.joint.y)
        else
            gui.data.currentkf:addbone(gui.data.current, Transform:new(
                    Vec:new(self:get(), self.offsety_slider:get()), 
                    self.rotation_slider:get()
                )
            )
        end
    end

    offsetx_slider.when_not_clicked = function(self, gui)
        if (gui.data.mode == "skeleton") then
            self:put(gui.data.current.joint.x)
        else
            self:put(gui.data.currentkf:get(gui.data.current).pos.x)
        end
    end


    offsety_slider.when_clicked = function(self, gui)
        if (gui.data.mode == "skeleton") then
            gui.data.current.joint = Vec:new(gui.data.current.joint.x, self:get())
        else
            gui.data.currentkf:addbone(gui.data.current, Transform:new(
                    Vec:new(self.offsetx_slider:get(), self:get()), 
                    self.rotation_slider:get()
                )
            )
        end
    end

    offsety_slider.when_not_clicked = function(self, gui)
        if (gui.data.mode == "skeleton") then
            self:put(gui.data.current.joint.y)
        else
            self:put(gui.data.currentkf:get(gui.data.current).pos.y)
        end
    end


    duration_slider.when_clicked = function(self, gui)
        gui.data.currentkf.duration = self:get()

        -- updates animation's duration
        gui.data.animation:findduration()
    end

    duration_slider.when_not_clicked = function(self, gui)
        if (gui.data.ikf == 0) then
            self:put(0)
        else
            self:put(gui.data.currentkf.duration)
        end
    end


    frame_slider.when_clicked = function(self, gui)
        gui.data.necromancer.frame = self:get()
    end

    frame_slider.when_not_clicked = function(self, gui)
        if (not gui.data.necromancer.paused) then
            self:put(gui.data.currentkf.frame)
        else
            local frame = gui.data.necromancer.frame
            if (gui.data.necromancer.frame < gui.data.currentkf.frame) frame = gui.data.currentkf.frame
            if (gui.data.necromancer.paused) gui.data.necromancer.frame = frame

            -- updates the range of the slider!
            self.minimum = gui.data.currentkf.frame
            self.maximum = self.minimum + gui.data.currentkf.duration - 1

            self:put(frame)
        end
    end




    -- clicking on sliders' labels will step slider by small amount
    -- starts by linking slider to labels
    length.slider = length_slider
    length_readout.slider = length_slider

    rotation.slider = rotation_slider
    rotation_readout.slider = rotation_slider

    offsetx.slider = offsetx_slider
    offsetx_readout.slider = offsetx_slider

    offsety.slider = offsety_slider
    offsety_readout.slider = offsety_slider

    duration.slider = duration_slider
    duration_readout.slider = duration_slider

    frame.slider = frame_slider
    frame_readout.slider = frame_slider


    -- gives each a when-clicked
    length.when_clicked = function(self, gui)
        self.slider:stepup(gui)
    end

    length_readout.when_clicked = function(self, gui)
        self.slider:stepdown(gui)
    end

    
    rotation.when_clicked = function(self, gui)
        self.slider:stepup(gui)
    end

    rotation_readout.when_clicked = function(self, gui)
        self.slider:stepdown(gui)
    end


    offsetx.when_clicked = function(self, gui)
        self.slider:stepup(gui)
    end

    offsetx_readout.when_clicked = function(self, gui)
        self.slider:stepdown(gui)
    end


    offsety.when_clicked = function(self, gui)
        self.slider:stepup(gui)
    end

    offsety_readout.when_clicked = function(self, gui)
        self.slider:stepdown(gui)
    end

    duration.when_clicked = function(self, gui)
        self.slider:stepup(gui)
    end

    duration_readout.when_clicked = function(self, gui)
        self.slider:stepdown(gui)
    end

    frame.when_clicked = function(self, gui)
        self.slider:stepup(gui)
    end

    frame_readout.when_clicked = function(self, gui)
        self.slider:stepdown(gui)
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

        -- adds the bone to the necromancer, setting default positions
        gui.data.skeleton.necromancer:addbone(bone)
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

    




    --[[
        animation buttons

    ]]

    -- add and remove keyframe
    local rmkf = Button:new(prev:left(), prev:bottom(2 * padding), 6, 4)
    rmkf.mode = "animation"
    gui:attach(rmkf)

    local curkf = Label:new(rmkf:right(padding), rmkf:top(), 0, " Key Frame", 7, curbone:right() - curbone:left())
    curkf.mode = "animation"
    gui:attach(curkf)

    local addkf = Button:new(curkf:right(padding), curkf:top(), 6, 3)
    addkf.mode = "animation"
    gui:attach(addkf)


    
    -- next and previous, plus label that says the $current_bone
    local prevkf = Button:new(rmkf:left(), rmkf:bottom(padding), 6, 6)
    prevkf.mode = "animation"
    gui:attach(prevkf)

    local curreadkf = Label:new(prevkf:right(padding), prevkf:top(), 0, "n/a", 8, curkf:right() - curkf:left())
    curreadkf.mode = "animation"
    gui:attach(curreadkf)

    local nextkf = Button:new(curreadkf:right(padding), curreadkf:top(), 6, 5)
    nextkf.mode = "animation"
    gui:attach(nextkf)


    -- next/prev keyframe
    local prevkf_brain = Brain:new(nil)
    prevkf_brain.update = function(self, gui)
        gui.data.ikf = (gui.data.ikf - 2) % gui.data.countkf + 1
        gui.data.currentkf = gui.data.animation.keyframes[gui.data.ikf]

        -- updates necromancer's frame
        if (gui.data.necromancer.paused) gui.data.necromancer.frame = gui.data.currentkf.frame
    end
    prevkf.contents = prevkf_brain

    prevkf.update_active = function(self, gui)
        self.active = gui.data.countkf > 1
    end


    local nextkf_brain = Brain:new(nil)
    nextkf_brain.update = function(self, gui)
        gui.data.ikf = gui.data.ikf % gui.data.countkf + 1
        gui.data.currentkf = gui.data.animation.keyframes[gui.data.ikf]

                -- updates necromancer's frame
                if (gui.data.necromancer.paused) gui.data.necromancer.frame = gui.data.currentkf.frame
    end
    nextkf.contents = nextkf_brain

    nextkf.update_active = function(self, gui)
        self.active = gui.data.countkf > 1
    end


    
    -- button activation logic
    rmkf.update_active = function(self, gui)
        self.active = gui.data.countkf > 1
    end



    -- current kf readout
    local kf_readout = Brain:new(curreadkf)
    kf_readout.update = function(self, gui)
        self.target.image = gui.data.ikf
    end
    gui:attach(kf_readout)


    

    -- add/remove kf
    local rmkf_brain = Brain:new(nil)
    rmkf_brain.update = function(self, gui)
        del(gui.data.animation.keyframes, gui.data.currentkf)
        gui.data.countkf -= 1
        gui.data.ikf = gui.data.ikf % gui.data.countkf + 1
        gui.data.currentkf = gui.data.animation.keyframes[gui.data.ikf]
        gui.data.animation:findduration()
    end
    rmkf.contents = rmkf_brain

    local addkf_brain = Brain:new(nil)
    addkf_brain.update = function(self, gui)
        gui.data.ikf += 1
        gui.data.animation:addkeyframe(gui.data.skeleton, gui.data.ikf)
        gui.data.countkf += 1
        gui.data.currentkf = gui.data.animation.keyframes[gui.data.ikf]

        -- updates necromancer
        if (gui.data.necromancer.paused) gui.data.necromancer.frame = gui.data.currentkf.frame
    end
    addkf.contents = addkf_brain



    
    
    --[[
        play/pause buttons

    ]]

    local pause = Button:new(prevkf:left(), prevkf:bottom(2 * padding), 6, 10, 5)
    pause.mode = "animation"
    pause.active = false
    gui:attach(pause)

    local play = Button:new(pause:right(padding), pause:top(), 6, 11, 5)
    play.mode = "animation"
    play.active = true
    gui:attach(play)

    play.other = pause
    pause.other = play

    pause.update_active = function(self, gui)
        if (self.clicked) then
            self.active = false
            self.other.active = true
        end
    end

    play.update_active = function(self, gui)

        -- activates this button after switching modes
        self.active = not self.other.active

        if (self.clicked) then
            self.active = false
            self.other.active = true
        end
    end

    pause_brain = Brain:new(gui.data.skeleton.necromancer)
    pause_brain.update = function(self, gui)
        self.target.paused = true
        self.target.frame = gui.data.currentkf.frame
    end
    pause.contents = pause_brain


    play_brain = Brain:new(gui.data.skeleton.necromancer)
    play_brain.update = function(self, gui)
        self.target.paused = false
        self.target.frame = gui.data.currentkf.frame
    end
    play.contents = play_brain





    --[[
        save/load buttons

    ]]

    local load = Button:new(play:right(4 * padding - 1), play:top(), 6, "Load", 5)
    gui:attach(load)

    local save = Button:new(load:right(padding), load:top(), 6, "Save", 5)
    gui:attach(save)



    return gui
end