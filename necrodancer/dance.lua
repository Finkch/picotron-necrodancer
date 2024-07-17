--[[
    moves main.lua responsabilities.

]]


-- includes finkchlib and lib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")

rm("/ram/cart/lib") -- makes sure at most one copy is present
mount("/ram/cart/lib", "/ram/lib")


include("lib/queue.lua")

include("necrodancer/necrodancer.lua")

function _init()

    -- debug queue, used for printing messages
	debug = Q:new()

    gui = init_necrodancer()
end

function _update()
    gui:update()
end

function _draw()

    gui:draw()

    -- debug printout
    camera()
	debug:print(2, 2, 8)
end