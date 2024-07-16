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

include("skeleton/skeleton.lua")



function _init()
    
	--skeleton = load_example()
    skeleton = Skeleton:new(nil, nil, true)

    gui = init_necrodancer(skeleton)


	-- debug queue, used for printing messages
	debug = Q:new()
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