--[[pod_format="raw",created="2024-07-09 18:04:09",modified="2024-07-09 18:20:10",revision=65]]
--[[
	rotates a sprite, using the magic of quads and texture maps.
	
	code is fletch_pico's:
	https://www.lexaloffle.com/bbs/?tid=141540
	
	i made a few modifications to allow arbitrary centres of rotation.
	also takes vecs as input.
	
]]

-- rspr.lua
function rspr(sprite, pos, r, centre, scale)

	if (not pos) error("cannot rotate sprite without a position")
	if (not sprite) error("cannot rotate sprite without a sprite number")

	-- default values
	scale = scale or {x = 1, y = 1} -- 1,1 is no scaling
	sx = scale.x
	sy = scale.y
	
	local rot = r or 0 -- amount of rotation; r periodic on [0,1)
	
	local tex = get_spr(sprite) -- gets sprite
	
	local dx, dy = tex:width() * sx, tex:height() * sy
	
	centre = centre or {x = (dx - 1) / 2, y = (dy - 1) / 2} -- defaults to centre of sprite
	local ox = centre.x
	local oy = centre.y
	
	-- the quad to represent the sprite
	quad = {
		{x=0, y=0, u=0, v=0}, -- subtract arbitrarly small amounts to prevent artifacting
		{x=dx, y=0, u=tex:width()-0.001, v=0},
		{x=dx, y=dy, u=tex:width()-0.001, v=tex:height()-0.001},
		{x=0, y=dy, u=0, v=tex:height()-0.001},
	}
	
	-- precomputes elements of rotation matrix
	local c,s = cos(r), -sin(r)
	
	-- applies the rotation matrix
	for _,v in pairs(quad) do
		local x,y = v.x - ox, v.y - oy
		v.x = c * x - s * y
		v.y = s * x + c * y   
	end
	
	-- does the rest of the magic
	tquad(quad, tex, pos.x, pos.y)
end

function tquad(coords,tex,dx,dy)
    local screen_max = get_display():height()-1
    local p0,spans = coords[#coords],{}
    local x0,y0,u0,v0=p0.x+dx,p0.y+dy,p0.u,p0.v
    for i=1,#coords do
        local p1 = coords[i]
        local x1,y1,u1,v1=p1.x+dx,p1.y+dy,p1.u,p1.v
        local _x1,_y1,_u1,_v1=x1,y1,u1,v1
        if(y0>y1) x0,y0,x1,y1,u0,v0,u1,v1=x1,y1,x0,y0,u1,v1,u0,v0
        local dy=y1-y0
        local dx,du,dv=(x1-x0)/dy,(u1-u0)/dy,(v1-v0)/dy
        if(y0<0) x0-=y0*dx u0-=y0*du v0-=y0*dv y0=0
        local cy0=ceil(y0)
        local sy=cy0-y0
        x0+=sy*dx
        u0+=sy*du
        v0+=sy*dv
        for y=cy0,min(ceil(y1)-1,screen_max) do
            local span=spans[y]
            if span then tline3d(tex,span.x,y,x0,y,span.u,span.v,u0,v0)
            else spans[y]={x=x0,u=u0,v=v0} end
            x0+=dx
            u0+=du
            v0+=dv
        end
        x0,y0,u0,v0=_x1,_y1,_u1,_v1
    end
end