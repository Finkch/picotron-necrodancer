--[[pod_format="raw",created="2024-07-09 17:25:38",modified="2024-07-15 18:02:22",revision=277]]

-- includes finkchlib and lib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")

rm("/ram/cart/lib") -- makes sure at most one copy is present
mount("/ram/cart/lib", "/ram/lib")


include("necrodancer.lua")

function _init()
    gui = necrodancer(false)
end

function _update()
    gui:update()
end

function _draw()
    gui:draw()
end