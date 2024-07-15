--[[
    moves main.lua responsabilities.

]]


-- includes finkchlib and lib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")

rm("/ram/cart/lib") -- makes sure at most one copy is present
mount("/ram/cart/lib", "/ram/lib")

include("necrodancer/necrodancer.lua")

include("finkchlib/log.lua")

include("lib/rspr.lua")
include("lib/vec.lua")
include("lib/queue.lua")

include("graveyard.lua")

function _init()
    
	
	skeleton = load_example()

    gui = init_necrodancer(skeleton)

	speed = 1

	f = 0
	r0 = 0

	-- debug queue, used for printing messages
	debug = Q:new()
end

function _update()
	-- tracks frames
	f += 1
	r0 = f / 60 / 8

    gui:update()

	--if (f % 30 == 0) skeleton:update()
	--skeleton:update()

	-- moves the skeleton around
	if (key("w")) pos.y -= speed
	if (key("a")) pos.x -= speed
	if (key("s")) pos.y += speed
	if (key("d")) pos.x += speed
end

function _draw()

	--cls()
    gui:draw()

    print(wwidth)
    print(wheight)

	--skeleton:draw(pos)
	
	-- draws a funny little rotating square
	rspr(1, {x=10 * 2 ^ 0.5, y=270 - 10 * 2 ^ 0.5}, r0)	


	-- displays colours
	for i = 0, 270 do
		pset(479, i, i // 8)
		if (i % 8 == 0) then
			print(i // 8, 460, i)
		end
	end

	debug:print()
end