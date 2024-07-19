--[[
    moves main.lua responsabilities.

]]


-- includes finkchlib and lib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")

rm("/ram/cart/lib") -- makes sure at most one copy is present
mount("/ram/cart/lib", "/ram/lib")


include("lib/queue.lua")
include("lib/logger.lua")

include("necrodancer/necrodancer.lua")

function _init()

    -- debug queue, used for printing messages
	debug = Q:new()

    -- logger to log when printing isn't enough
    logger = Logger:new("appdata/logs", "log.txt")

    gui = init_necrodancer()
end

function _update()
    gui:update()
end

function _draw()

    debug:add(tostr(gui.data.skeleton.necromancer.current))

    gui:draw()

    -- debug printout
    camera()
end