--[[pod_format="raw",created="2024-07-09 17:25:38",modified="2024-07-15 18:02:22",revision=277]]

include("necrodancer.lua")

function _init()
    gui = necrodancer(true)
end

function _update()

    if (gui.data.reload) then
        local skeleton = gui.data.skeleton
        local debug_mode = gui.data.debug_mode
        gui = necrodancer(debug_mode, skeleton)
    end

    gui:update()
end

function _draw()
    gui:draw()
end