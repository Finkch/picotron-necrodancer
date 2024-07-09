--[[pod_format="raw",created="2024-07-09 17:25:38",modified="2024-07-09 18:40:38",revision=71]]

-- includes finkclib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")


include("lib/rspr.lua")

function _init()
	r0 = 0
end

function _update()
	r0 += 1 / 60 / 8
end

function _draw()
	cls()

	
	-- draws a funny little rotating square
	rspr(1, {x=480 - 10 * 2 ^ 0.5, y=10 * 2 ^ 0.5}, r0)	
end