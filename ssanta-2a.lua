-- title:   1SSANTA.EXE
-- author:  verysoftwares
-- desc:    for Secret Santa Jam
-- site:    https://verysoftwares.itch.io
-- license: MIT
-- script:  lua

t=0
x=96
y=24
santax=1
santay=4
santadx=1

function music1()
		if t%49%24==7 and t%6~=0 then
				sfx(1,12*4+t//6%12-t//2%16,20,0)
		end
		if t%49==7 then
				sfx(1,12*3+t//6%12-t//2%16,60,1)
		end
end
function music2()
		tt=tt or 0
		if (tt<18*8*4 and tt%18==0) or (tt>=18*8*4 and tt%12==0) then
				sfx(1,12*4-tt//6%12+tt//2%16-tt//3%9,20,0)
		end
		if tt==18*8*9+18*2-1 then tt=-1 end
		tt=tt+1
end

lanes={
		{},
		{},
		{},
		{},
}
for i=1,4 do
		for j=0,240/i-1,8 do
				local sp=83
				if math.random()<0.15 then sp=86
				elseif math.random()<0.15 then sp=81 end
				table.insert(lanes[i],sp)
		end
end
pack={}
for i=87,89 do
		pack[i]=4
end

maxtimer=32
timer=maxtimer

function TIC()
		music2()

		santa_input()
		advance_timer()

		render_background()
		render_foreground()

		t=t+1
end

function santa_input()
		if btnp(0) and santay>1 and pack[89]>0 then
				local prevx=santax 
				santax=math.min(math.max(math.floor(santax*(santay/(santay-1))+0.5*santadx+(-1+1-timer/maxtimer)*santadx),1),#lanes[santay-1]); 
				santay=santay-1; 
				timer=maxtimer; hilightx=nil; hilighty=nil 
				local step=lanes[santay][santax]
				if step==81 or step==86 then
						hilightx=santax; hilighty=santay
						santax=prevx; santay=santay+1
				elseif step>=87 and step<=89 then
						pack[step]=pack[step]+1
						--if step==88 then pack[step]=pack[step]+1 end
						lanes[santay][santax]=83
						pack[89]=pack[89]-1
						if pack[89]<0 then pack[89]=0 end
				else
						pack[89]=pack[89]-1
						if pack[89]<0 then pack[89]=0 end
				end
		end
		if btnp(1) and santay<4 and pack[89]>0 then 
				local prevx=santax
				santax=math.min(math.max(math.floor(santax*(santay/(santay+1))+0.5+(-0.5+1-timer/maxtimer)*santadx),1),#lanes[santay+1]); 
				santay=santay+1; 
				timer=maxtimer; hilightx=nil; hilighty=nil 
				local step=lanes[santay][santax]
				if step==81 or step==86 then
						hilightx=santax; hilighty=santay
						santax=prevx; santay=santay-1
				elseif step>=87 and step<=89 then
						pack[step]=pack[step]+1
						--if step==88 then pack[step]=pack[step]+1 end
						lanes[santay][santax]=83
						pack[89]=pack[89]-1
						if pack[89]<0 then pack[89]=0 end
				else
						pack[89]=pack[89]-1
						if pack[89]<0 then pack[89]=0 end
				end
		end
		-- throw with Z
		if btnp(4) and gift and pack[88]>0 then
				giftshotx=santax; giftshoty=santay; giftshotdx=santadx
				gift=gift-1
				if gift<=0 then gift=nil end
				timer=maxtimer
				pack[88]=pack[88]-1
				if pack[88]<0 then pack[88]=0 end
		end
		-- turn with X or arrows
		if (btnp(5) or (santadx>0 and btnp(2)) or (santadx<0 and btnp(3))) and pack[87]>0 then
				santadx=-santadx
				timer=maxtimer
				pack[87]=pack[87]-1
				if pack[87]<0 then pack[87]=0 end
		end
end

function advance_timer()
		timer=timer-1

		if timer==0 then local prevx=santax; santax=santax+santadx; local border=false
				if santax>=240/8/santay+1 then santax=1; border=true end
				if santax<1 then santax=#lanes[santay]; border=true end
				local step=lanes[santay][santax]
				if step==86 then 
						if not gift and pack[88]>0 then gift=1; lanes[santay][santax]=83; pack[88]=pack[88]-1; if pack[88]<0 then pack[88]=0 end
						else hilightx=santax; hilighty=santay end
						santax=prevx
				elseif step==81 then
						hilightx=santax; hilighty=santay
						santax=prevx
				elseif step>=87 and step<=89 then
						pack[step]=pack[step]+1
						--if step==88 then pack[step]=pack[step]+1 end
						lanes[santay][santax]=83
				end
				if border and santax~=prevx then if gift then gift=gift-1; if gift<=0 then gift=nil end end end
				timer=maxtimer 
		end

		if giftshotx then
				if t%6==0 then giftshotx=giftshotx+giftshotdx; 
				if giftshotx>#lanes[giftshoty] then giftshotx=1--giftshotx=nil; giftshoty=nil
				elseif giftshotx<1 then giftshotx=#lanes[giftshoty] end
				if lanes[giftshoty][giftshotx]~=83 and lanes[giftshoty][giftshotx]~=0 then lanes[giftshoty][giftshotx]=83; giftshotx=nil; giftshoty=nil 
				elseif lanes[giftshoty][giftshotx]==83 or lanes[giftshoty][giftshotx]==0 then 
						local rng=math.random(1,10)
						local item=0
						if rng>=7 then item=88
						elseif rng>=4 then item=89
						elseif rng>=2 then item=87
						else item=86 end
						lanes[giftshoty][giftshotx]=item
				end
				end
		end

		if timer<8 then hilightx=nil; hilighty=nil end
end

function render_background()
		cls(0)

		for i=1,4 do
				local ly
				if i==1 then ly=136/2-4 end
				if i==2 then ly=136/2-4+8-2 end
				if i==3 then ly=136/2-4+8+16-4-4 end
				if i==4 then ly=136/2-4+8+16+24-8-4 end
				for j,v in ipairs(lanes[i]) do
						local offx=0--t*(i*0.25)%(8*i)
						local flip=0
						local sp=v
						-- preview back tile
						if i==santay-1 and j==math.min(math.max(math.floor(santax*(santay/(santay-1))+0.5*santadx+(-1+1-timer/maxtimer)*santadx),1),#lanes[santay-1]) then
								--rect((j-1)*(8*i)+offx,ly,i*8,i*8,4)
						end
						-- preview front tile
						if i==santay+1 and j==math.min(math.max(math.floor(santax*(santay/(santay+1))+0.5+(-0.5+1-timer/maxtimer)*santadx),1),#lanes[santay+1]) then
								--rect((j-1)*(8*i)+offx,ly,i*8,i*8,5)
						end
						if santay==i and j==santax then 
								if v==86 and not gift then lanes[i][j]=83; gift=1 end
								sp=97 
								if gift then
								sp=113
								spr(86,(j-1)*(8*i)+offx-i,ly-8*i,0,i)
								end
						end
						if giftshoty==i and giftshotx==j then sp=86 end
						if (sp==97 or sp==113) and santadx<0 then flip=1 end
						if hilightx==j and hilighty==i then for i=0,15 do pal(i,2) end end
						spr(sp,(j-1)*(8*i)+offx,ly,0,i,flip)
						pal()
				end
		end
end

function render_foreground()
		-- clouds
		for i=240,-8,-8 do
				if not (i>2 and i<60-16) then spr(84,i+(t*0.125)%8,136/2-4-8-8,0) end
				if i<120+16 then
				if not (i>2 and i<60-16) then spr(84,i*2+(t*0.25)%16,136/2-4-8-2-8-8,0,2) end
				end
				if i<80+24 then
				if not (i>2 and i<60-16) then spr(84,i*3+(t*0.5)%24,136/2-4-8-16-4-16,0,3) end
				end
				if i<60+32 then
				if not (i>2 and i<60-16) then spr(84,i*4+(t)%32,136/2-4-8-16-24-8-4,0,4) end
				end
		end

		-- item icons
		for i=0,3-1 do
		rectb(240/2+40+i*12-1,0,10,16,12)
		spr(87+i,240/2+40+i*12,1,0)
		local col=12
		if pack[87+i]<=0 then col=2 end
		print(math.min(pack[87+i],9),240/2+40+i*12+1+1,16-1-6+1,col)
		end

		print('Secret',32+32+16,6,11,false,3,true)
		print('Santa 2023',32+32+16-32+8+8,6+16,11,false,2,true)
		print('by Leonard S.',32+32+16-32+8-16+2,6+16+16,12,false,1,true)
end

function SCN(i)
		--poke(0x3FC0+11*3,0x73)
		--poke(0x3FC0+11*3+1,0xFA)
		--poke(0x3FC0+11*3+2,0xF7)
		poke(0x3FC0+11*3,0xA4+(i*8+t)%64)
		poke(0x3FC0+11*3+1,0x24+(i*12+t)%164)
		poke(0x3FC0+11*3+2,0x24+(i*6+t)%64)
end

-- basic AABB collision.
		function AABB(x1,y1,w1,h1, x2,y2,w2,h2)
				return (x1 < x2 + w2 and
												x1 + w1 > x2 and
												y1 < y2 + h2 and
												y1 + h1 > y2)
		end

-- palette swapping by BORB
		function pal(c0,c1)
		  if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i) end
		  else poke4(0x3FF0*2+c0,c1) end
		end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 070:000000000660066006c66c6006666660ccc66ccdccc66ccdccc66ccdddd77ddd
-- 071:000000000990099009c99c9009999990ccc99ccdccc99ccdccc99ccdddd88ddd
-- 081:0666666544466660a4a666604446660055666550566665505666655006666000
-- 082:0666666544466550a4a665504446655055666500566660005666600006666000
-- 083:000ffff00ffffff00ffffff0dffff888ddeee888ddeee88800eeeee000eeee00
-- 084:000cccc000cccccc0ccccccccccccccccccddccccccddccc0ccddd0000000000
-- 085:000cc000022cc220cc2222ccc22cc22cc2cccc2cc2cccc2c02cccc20000cc000
-- 086:000000000220022002c22c2002222220ccc22ccdccc22ccdccc22ccdddd11ddd
-- 087:000000000000ddd0000012100000ded000dd12100deeeed00122221000dddd00
-- 088:12c2000022122000cc0cc1000c00220000002c1000000c21000000220000000c
-- 089:000cc00000666500076556700056670006666560576556750051170000011000
-- 097:c22222200222244402222e4e002224440cc222cc0cc2222c0cc2222c00022220
-- 098:0d0000d0d00cc00dd0cccc0ddccccccdd00cc00dd00cc00dd00cc00d0d0000d0
-- 099:000ffff00ffffff00ffffff0dffff888ddeee888ddeee88800eeeee000eeee00
-- 100:0002222002222220022222205222288855666888556668880066666000666600
-- 101:0001111001111110011111106111177766ddd77766ddd77700ddddd000dddd00
-- 102:0000000000000000000cc00000cccc000cccccc0000cc000000cc000000cc000
-- 103:00000000000cc00000cccc000cccccc0000cc000000cc000000cc00000000000
-- 104:000cc00000cccc000cccccc0000cc000000cc000000cc0000000000000000000
-- 113:c22222200cc224440cc22e4e0cc2244400c222cc0002222c0002222c00022220
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- 001:010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100000000000000
-- </SFX>

-- <PATTERNS>
-- 000:857218000000000000000000000000000000000000000000837218000000000000000000000000000000000000000000657218000000000000000000000000000000000000000000637218000000000000000000000000000000000000000000457218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000047200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:800018000000d00018000000400018000000800018000000d00018000000400018000000d00016000000800018000000800018000000d00018000000400018000000800018000000d00018000000400018000000d00016000000800018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:100000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c485d4869b13e7def7d91ffcdc2a7f0be38b7be25719929596f3b85c941c6f673faf7d6f4f475b0c2446c86143c57
-- </PALETTE>

