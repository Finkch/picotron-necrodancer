--[[pod_format="raw",created="2024-07-09 17:25:38",modified="2024-07-09 18:40:38",revision=71]]

-- includes finkchlib and lib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")

rm("/ram/cart/lib") -- makes sure at most one copy is present
mount("/ram/cart/lib", "/ram/lib")

include("lib/rspr.lua")
include("lib/vec.lua")

include("graveyard.lua")

function _init()
	
	player = load_example()

	pos = Vec:new(240, 135)


	f = 0
	r0 = 0
end

function _update()
	f += 1
	r0 = f / 60 / 8
end

function _draw()
	cls()

	player:draw(pos)

	
	-- draws a funny little rotating square
	rspr(1, {x=480 - 10 * 2 ^ 0.5, y=10 * 2 ^ 0.5}, r0)	
end