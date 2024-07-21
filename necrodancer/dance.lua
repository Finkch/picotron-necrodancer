--[[
    moves main.lua responsabilities.

]]


-- includes finkchlib and lib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")

rm("/ram/cart/lib") -- makes sure at most one copy is present
mount("/ram/cart/lib", "/ram/lib")


include("necrodancer/necrodancer.lua")

function _init()
    gui = necrodancer(false)
end

function _update()
    gui:update()
end

function _draw()
    gui:draw()
end