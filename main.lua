--[[pod_format="raw",created="2024-07-09 17:25:38",modified="2024-07-09 18:40:38",revision=71]]

-- includes finkchlib and lib
rm("/ram/cart/finkchlib") -- makes sure at most one copy is present
mount("/ram/cart/finkchlib", "/ram/finkchlib")

rm("/ram/cart/lib") -- makes sure at most one copy is present
mount("/ram/cart/lib", "/ram/lib")

include("lib/rspr.lua")
include("lib/vec.lua")
include("lib/queue.lua")

include("graveyard.lua")

function _init()
	
	skeleton = load_example()

	pos = Vec:new(240, 135)

	speed = 1


	f = 0
	r0 = 0


	-- debug queue, used for printing messages
	debug = Q:new()
end

function _update()
	f += 1
	r0 = f / 60 / 8

	if (key("w")) pos.y -= speed
	if (key("a")) pos.x -= speed
	if (key("s")) pos.y += speed
	if (key("d")) pos.x += speed
end

function _draw()
	cls()

	debug:add(tostr(core))

	skeleton:draw(pos)
	for bone in all(skeleton.bones) do
		debug:add(tostr(bone))
	end
	
	-- draws a funny little rotating square
	rspr(1, {x=10 * 2 ^ 0.5, y=270 - 10 * 2 ^ 0.5}, r0)	


	-- displays colours
	for i = 0, 270 do
		pset(479, i, i // 8)
		if (i % 8 == 0) then
			print(i // 8, 460, i)
		end
	end

	debug:print(0, 0, 6)
end