-- title:   1SSANTA.EXE
-- author:  verysoftwares
-- desc:    for Secret Santa Jam
-- site:    https://verysoftwares.itch.io
-- license: MIT
-- script:  lua

SP_ELFL=81
SP_ELFR=SP_ELFL-16
SP_SANTA=97
SP_SANTAGIFT=SP_SANTA+16
SP_EMPTY=83
SP_GIFT=86
SP_SOCK=87
SP_CANE=88
SP_TREE=89
SP_CLOUD=84
SP_CROSS=72

t=0
x=96
y=24
santax=1
santay=4
santadx=1
santas=3

lanes={
  {},
  {},
  {},
  {},
}
for i=1,4 do
  for j=0,240/i-1,8 do
    local sp=SP_EMPTY
    if math.random()<0.15 then sp=SP_GIFT
    elseif math.random()<0.15 then sp=SP_ELFL-math.random(0,1)*16 end
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

  --if not elf_cor then
  t=t+1
  --end
end

function santa_input()
  -- up to go further into the parallax
  if btnp(0) and santay>1 then
    if pack[SP_TREE]>0 then
      santa_parallax(-1)
    else
      table.insert(labels,{x=santax,y=santay,id=SP_TREE,count=0,t=t})
    end
  end
  -- down to get closer in the parallax
  if btnp(1) and santay<4 then 
    if pack[SP_TREE]>0 then
      santa_parallax(1)
    else
      table.insert(labels,{x=santax,y=santay,id=SP_TREE,count=0,t=t})
    end
  end
  -- throw with Z
  if btnp(4) and gift then
    if pack[SP_CANE]>0 then
      giftshotx=santax; giftshoty=santay; giftshotdx=santadx
      gift=gift-1
      if gift<=0 then gift=nil end
      timer=maxtimer
      add_pack(SP_CANE,-1)
    else
      table.insert(labels,{x=santax,y=santay,id=SP_CANE,count=0,t=t})
    end
  end
  -- turn with X or arrows
  if (btnp(5) or (santadx>0 and btnp(2)) or (santadx<0 and btnp(3))) then
    if pack[SP_SOCK]>0 then
      santadx=-santadx
      timer=maxtimer
      add_pack(SP_SOCK,-1)
    else
      table.insert(labels,{x=santax,y=santay,id=SP_SOCK,count=0,t=t})
    end
  end
end

function santa_parallax(dir)
  local prevx=santax 
  santax=parallax_shift(dir,santax,santay,santadx)
  santay=santay+dir; 
  timer=maxtimer; hilightx=nil; hilighty=nil 
  local step=lanes[santay][santax]
  if step==SP_ELFL or step==SP_ELFL or step==SP_GIFT then
    hilightx=santax; hilighty=santay
    santax=prevx; santay=santay-dir
  elseif step>=SP_SOCK and step<=SP_TREE then
    add_pack(step,1)
    lanes[santay][santax]=SP_EMPTY
    add_pack(SP_TREE,-1)
  else
    add_pack(SP_TREE,-1)
  end
end

function parallax_shift(dir,sx,sy,sdx)
  -- returns the x position
  -- on the new parallax lane
  if dir==1 then
  return math.min(math.max(math.floor(sx*(sy/(sy+1))+0.5+(-0.5+1-timer/maxtimer)*sdx),1),#lanes[sy+1])
  end
  if dir==-1 then
  return math.min(math.max(math.floor(sx*(sy/(sy-1))+0.5*sdx+(-1+1-timer/maxtimer)*sdx),1),#lanes[sy-1])
  end
end

--t2=0
function advance_timer()
  timer=timer-1

  if timer<=0 then
    --if timer==0 then elf_cor=elf_advance() end
    --timer=0
    --if t2%8==0 and not coroutine.resume(elf_cor) then
    --timer=maxtimer 
    --santa_advance()
    --elf_cor=nil
    --end
    santa_advance()
    elf_cor=elf_advance()
    while coroutine.resume(elf_cor) do end
    timer=maxtimer
    elf_cor=nil
  end

  if giftshotx and t%6==0 then
    gift_advance()
  end

  if timer<8 then hilightx=nil; hilighty=nil end
  
  --t2=t2+1
end

function santa_advance()
  local prevx=santax; santax=santax+santadx; local border=false
  if santax>=240/8/santay+1 then santax=1; border=true end
  if santax<1 then santax=#lanes[santay]; border=true end
  local step=lanes[santay][santax]
  if step==SP_GIFT then 
    if not gift and pack[SP_CANE]>0 then gift=1; lanes[santay][santax]=SP_EMPTY; santax=prevx; add_pack(SP_CANE,-1)
    else hilightx=santax; hilighty=santay; santax=prevx; if not gift and pack[SP_CANE]<=0 then table.insert(labels,{x=santax,y=santay,id=SP_CANE,count=0,t=t}) end end
  elseif step==SP_ELFL or step==SP_ELFR then
    hilightx=santax; hilighty=santay
    santax=prevx
  elseif step>=SP_SOCK and step<=SP_TREE then
    add_pack(step,1)
    lanes[santay][santax]=SP_EMPTY
  end
  if border and santax~=prevx then if gift then gift=gift-1; if gift<=0 then gift=nil; table.insert(labels,{x=santax,y=santay,id=SP_GIFT,count=0,t=t}) end end end
end

function elf_advance()
  return coroutine.create(function()
  local old_lanes={{},{},{},{}}
  for i=1,4 do
    for j,v in ipairs(lanes[i]) do
      if i==santay and j==santax then old_lanes[i][j]=97 
      else old_lanes[i][j]=v end
    end
  end
  -- old_lanes is now read-only
  for i=1,4 do
    for j=#lanes[i],1,-1 do
      local v=old_lanes[i][j]
      if v==SP_ELFL or v==SP_ELFR then
      local coll,colli
      local dx
      if v==SP_ELFL then
        dx=-1
        if j+dx<1 then
        colli=#old_lanes[i]
        else 
        colli=j+dx
        end
      elseif v==SP_ELFR then 
        dx=1
        if j+dx>#old_lanes[i] then
        colli=1
        else
        colli=j+dx 
        end
      end
      coll=old_lanes[i][colli] 
      
      if coll==SP_EMPTY and lanes[i][colli]==SP_EMPTY then
        -- you're good to walk forward!
        lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
        coroutine.yield()
      else
        -- collision with a solid object.
        -- time to try dodging
        local intent=math.random(0,2)
        local px
        if intent==0 then
          -- move further
          if i>1 then
          px=parallax_shift(-1,j,i,dx)
          if old_lanes[i-1][px]==SP_EMPTY and lanes[i-1][px]==SP_EMPTY then lanes[i][j]=SP_EMPTY; lanes[i-1][px]=v; coroutine.yield() end
          end
        elseif intent==1 then
          -- move closer
          if i<4 then
          px=parallax_shift(1,j,i,dx)
          if old_lanes[i+1][px]==SP_EMPTY and lanes[i+1][px]==SP_EMPTY then lanes[i][j]=SP_EMPTY; lanes[i+1][px]=v; coroutine.yield() end
          end
        elseif intent==2 then
          -- turn around
          if v==SP_ELFL then
          lanes[i][j]=SP_ELFR
          elseif v==SP_ELFR then
          lanes[i][j]=SP_ELFL
          end
          coroutine.yield()
        end
      end
      end
    end
  end
  end)
end

function elf_count()
  local out=0
  for i=1,4 do
    for j,v in ipairs(lanes[i]) do
      if v==SP_ELFL or v==SP_ELFR then out=out+1 end
    end
  end
  return out
end

function gift_count()
  local out=0
  for i=1,4 do
    for j,v in ipairs(lanes[i]) do
      if v==SP_GIFT then out=out+1 end
    end
  end
  if gift then out=out+gift end
  if giftshotx then out=out+1 end
  return out
end

function gift_advance()
  giftshotx=giftshotx+giftshotdx; 
  if giftshotx>#lanes[giftshoty] then giftshotx=1--giftshotx=nil; giftshoty=nil
  elseif giftshotx<1 then giftshotx=#lanes[giftshoty] end
  local step=lanes[giftshoty][giftshotx]
  if step~=SP_EMPTY then 
    local elf= (step==SP_ELFL) or (step==SP_ELFR)
    local hit=false
    if elf then
      hit= (step==SP_ELFL and giftshotdx>0) or (step==SP_ELFR and giftshotdx<0)
    end
    if elf and hit then
      spawn_item(giftshotx,giftshoty)
      table.insert(labels,{x=giftshotx,y=giftshoty,id=step,count=0,t=t})
    end
    if (not elf) then
      lanes[giftshoty][giftshotx]=SP_EMPTY; 
    end
    if (not elf) or (not hit) then
    table.insert(labels,{x=giftshotx,y=giftshoty,id=SP_GIFT,count=0,t=t})
    giftshotx=nil; giftshoty=nil; giftshotdx=nil
    end
  elseif step==SP_EMPTY then 
    spawn_item(giftshotx,giftshoty)
  end
end

function spawn_item(sx,sy)
  local rng=math.random(1,10)
  local item=0
  if rng>=7 then item=88
  elseif rng>=4 then item=89
  elseif rng>=2 then item=87
  else item=86 end
  lanes[sy][sx]=item
end

labels={}
function add_pack(i,n)
  pack[i]=pack[i]+n
  if n>0 then
    --if i==SP_CANE then pack[i]=pack[i]+1 end
    if pack[i]>15 then pack[i]=15 end
  end
  if n<0 then
    if pack[i]<0 then pack[i]=0 end
    table.insert(labels,{x=santax,y=santay,id=i,count=pack[i],t=t})
  end
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
      if v==SP_EMPTY then
      spr(v,(j-1)*(8*i),ly,0,i)
      end
    end
    for j,v in ipairs(lanes[i]) do
      if v~=SP_EMPTY or (i==santay and j==santax) then
      local offx=0--t*(i*0.25)%(8*i)
      local flip=0
      local sp=v
      -- preview back tile
      if i==santay-1 and j==parallax_shift(-1,santax,santay,santadx) then
        --rect((j-1)*(8*i)+offx,ly,i*8,i*8,4)
      end
      -- preview front tile
      if i==santay+1 and j==parallax_shift(1,santax,santay,santadx) then
        --rect((j-1)*(8*i)+offx,ly,i*8,i*8,5)
      end
      if i==santay and j==santax then 
        if v==SP_GIFT and not gift then lanes[i][j]=SP_EMPTY; gift=1 end
        sp=SP_SANTA 
        if gift then
        sp=SP_SANTAGIFT
        for i=0,15 do pal(i,0) end
        spr(SP_GIFT,(j-1)*(8*i)+offx-i+i,ly-8*i-i,0,i)
        spr(SP_GIFT,(j-1)*(8*i)+offx-i-i,ly-8*i-i,0,i)
        spr(SP_GIFT,(j-1)*(8*i)+offx-i,ly-8*i-i+i,0,i)
        spr(SP_GIFT,(j-1)*(8*i)+offx-i,ly-8*i-i-i,0,i)
        pal()
        spr(SP_GIFT,(j-1)*(8*i)+offx-i,ly-8*i-i,0,i)
        end
      end
      if giftshoty==i and giftshotx==j then sp=SP_GIFT end
      if (sp==SP_SANTA or sp==SP_SANTAGIFT) and santadx<0 then flip=1 end
      if sp~=SP_EMPTY then
      for i=0,15 do pal(i,0) end
      spr(sp,(j-1)*(8*i)+offx+i,ly,0,i,flip)
      spr(sp,(j-1)*(8*i)+offx-i,ly,0,i,flip)
      spr(sp,(j-1)*(8*i)+offx,ly+i,0,i,flip)
      spr(sp,(j-1)*(8*i)+offx,ly-i,0,i,flip)
      pal()
      end
      if hilightx==j and hilighty==i and v~=SP_EMPTY then for i=0,15 do pal(i,2) end end
      spr(sp,(j-1)*(8*i)+offx,ly,0,i,flip)
      pal()
      end
    end
  end
end

function render_foreground()
  --line(0,56+2,240,56+2,8)
  --line(0,56+1+2,240,56+1+2,9)
  --line(0,56+1+4-1,240,56+1+4-1,8)

  -- item icons
  local offx=4
  local offy=1
  local xdist=18
  rect(0,0,64+offx,10,2)
  rect(64+6*xdist+offx-1,0,64+offx,10,7)
  for i,v in ipairs({SP_SANTA,SP_ELFR,SP_GIFT,SP_SOCK,SP_CANE,SP_TREE}) do
  rectb(64+(i-1)*xdist+offx-1,0,18,10,2+i-1)
  spr(v,64+(i-1)*xdist+offx,0+offy,0)
  local count=0
  if v==SP_SANTA then count=santas end
  if v==SP_ELFR then count=elf_count() end
  if v==SP_GIFT then count=gift_count() end
  if v>=SP_SOCK and v<=SP_TREE then count=pack[v] end
  print(string.format('%x',math.min(count,15)),64+(i-1)*xdist+offx+10,1+offy,2+i-1)
  end

  -- clouds
  for i=240,-8,-8 do
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i+(t*0.125)%8,136/2-4-8-8,0) end
    if i<120+16 then
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i*2+(t*0.25)%16,136/2-4-8-2-8-8,0,2) end
    end
    if i<80+24 then
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i*3+(t*0.5)%24,136/2-4-8-16-4-16,0,3) end
    end
    if i<60+32 then
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i*4+(t)%32,136/2-4-8-16-24-8-4,0,4) end
    end
  end
  
  for i=#labels,1,-1 do
    local l=labels[i]
    local ly
    local offx=0
    if l.y==4 and l.x==8 then offx=-16 end
    if l.y==1 then ly=136/2-4 end
    if l.y==2 then ly=136/2-4+8-2 end
    if l.y==3 then ly=136/2-4+8+16-4-4 end
    if l.y==4 then ly=136/2-4+8+16+24-8-4 end
    for i=0,15 do pal(i,0) end
    spr(l.id,(l.x-1)*(8*l.y)+offx+l.y,ly-(t-l.t)*0.2*l.y,0,l.y)
    spr(l.id,(l.x-1)*(8*l.y)+offx-l.y,ly-(t-l.t)*0.2*l.y,0,l.y)
    spr(l.id,(l.x-1)*(8*l.y)+offx,ly-(t-l.t)*0.2*l.y+l.y,0,l.y)
    spr(l.id,(l.x-1)*(8*l.y)+offx,ly-(t-l.t)*0.2*l.y-l.y,0,l.y)
    pal()
    spr(l.id,(l.x-1)*(8*l.y)+offx,ly-(t-l.t)*0.2*l.y,0,l.y)
    if l.count==0 and (t-l.t)%20<10 then
      for i=0,15 do pal(i,0) end
      spr(SP_CROSS,(l.x-1)*(8*l.y)+offx+l.y,ly-(t-l.t)*0.2*l.y,0,l.y)
      spr(SP_CROSS,(l.x-1)*(8*l.y)+offx-l.y,ly-(t-l.t)*0.2*l.y,0,l.y)
      spr(SP_CROSS,(l.x-1)*(8*l.y)+offx,ly-(t-l.t)*0.2*l.y+l.y,0,l.y)
      spr(SP_CROSS,(l.x-1)*(8*l.y)+offx,ly-(t-l.t)*0.2*l.y-l.y,0,l.y)
      pal()
      spr(SP_CROSS,(l.x-1)*(8*l.y)+offx,ly-(t-l.t)*0.2*l.y,0,l.y)
    end
    if t-l.t>=80-1 then table.remove(labels,i) end
  end

  local offx=4
  local offy=5
  print('Secret',32+32+16+offx,6+offy,11,false,3,true)
  print('Santa 2023',32+32+16-32+8+8+offx,6+16+offy,11,false,2,true)
  print('2023',32+32+16-32+8+8+46-2+offx,6+16+offy,12,false,2,true)
  print('by Leonard S.',32+32+16-32+8-16+2+offx,6+16+16,12,false,1,true)
end

function SCN(i)
  poke(0x3FC0+11*3,0xA4+(i*8+t)%64)
  poke(0x3FC0+11*3+1,0x24+(i*12+t)%164)
  poke(0x3FC0+11*3+2,0x24+(i*6+t)%64)
end

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
  if tt%36==0 then
    sfx(1,12*4-tt//6%12+tt//2%16-tt//3%9,36,1)
  end
  if tt==18*8*9+18*2-1 then tt=-1 end
  tt=tt+1
end

-- palette swapping by borbware
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
-- 065:566666600666644406666a4a0066644405566655055666650556666500066660
-- 066:566666600556644405566a4a0556644400566655000666650006666500066660
-- 070:000000000660066006c66c6006666660ccc66ccdccc66ccdccc66ccdddd77ddd
-- 071:000000000990099009c99c9009999990ccc99ccdccc99ccdccc99ccdddd88ddd
-- 072:0200002222200222022202200022200000022200022022202220022222000020
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

-- <SCREEN>
-- 000:222222222222222222222222222222222222222222222222222222222222222222222222222222222222233333333333333333344444444444444444455555555555555555566666666666666666677777777777777777777777777777777777777777777777777777777777777777777777777777777777
-- 001:22222222222222222222222222222222222222222222222222222222222222222222c2222220000000002356666660000000003400000000000000004500000000000000005612c200000000000067000cc00000000000777777777777777777777777777777777777777777777777777777777777777777
-- 002:222222222222222222222222222222222222222222222222222222222222222222220222244400ccccc02306666444000ccc003402200220000ccc00450000ddd00000cc0056221220000000cc0067006665000000cc00777777777777777777777777777777777777777777777777777777777777777777
-- 003:2222222222222222222222222222222222222222222222222222222222222222222202222e4e00000cc02306666a4a00cc00003402c22c2000cc00c04500001210000ccc0056cc0cc100000ccc006707655670000ccc00777777777777777777777777777777777777777777777777777777777777777777
-- 004:222222222cccccccccccccccc2222222222222222cccccccccccccccc22222222222002224440000cc00230066644400cccc003402222220000ccc00450000ded000cc0c00560c00220000cc0c00670056670000cc0c0077777777777777777777777777777777777777777777777777777777777ccccccc
-- 005:222222222cccccccccccccccc2222222222222222cccccccccccccccc222222222220cc222cc00c00cc0230556665500cc00c034ccc22ccd00cc00c04500dd121000ccccc05600002c1000ccccc0670666656000ccccc077777777777777777777777777777777777777777777777777777777777ccccccc
-- 006:222222222cccccccccccccccc2222222222222222cccccccccccccccc222222222220cc2222c000ccc002305566665000ccc0034ccc22ccd000ccc00450deeeed000000c005600000c2100000c00675765567500000c0077777777777777777777777777777777777777777777777777777777777ccccccc
-- 007:222222222cccccccccccccccc2222222222222222cccccccccccccccc222222222220cc2222c0000000023055666650000000034ccc22ccd0000000045012222100000000056000000220000000067005117000000000077777777777777777777777777777777777777777777777777777777777ccccccc
-- 008:22222cccccccccccccccccccccccc22222222cccccccccccccccccccccccc2222222000222200000000023000666600000000034ddd11ddd000000004500dddd0000000000560000000c000000006700011000000000007777777777777777777777777777777777777777777777777777777ccccccccccc
-- 009:22222cccccccccccccccccccccccc22222222cccccccccccccccccccccccc222222222222222222222222333333333333333333444444444444444444555555555555555555666666666666666666777777777777777777777777777777777777777777777777777777777777777777777777ccccccccccc
-- 010:00000cccccccccccccccccccccccc00000000cccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccc
-- 011:00000cccccccccccccccccccccccc00000000cccccccccccccccccccccccc00000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccc
-- 012:0cccccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccc
-- 013:0cccccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccc
-- 014:0cccccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccc
-- 015:0cccccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccc
-- 016:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccc
-- 017:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb00000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccc
-- 018:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb00000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccc
-- 019:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb00000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccc
-- 020:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb000000000cccccccccccc000000000000cccccccccccc000000000000cccccccccccc00ccccccccccccddddddd
-- 021:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb000000000cccccccccccc000000000000cccccccccccc000000000000cccccccccccc00ccccccccccccddddddd
-- 022:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb000000000cccccccccccc000000000000cccccccccccc000000000000cccccccccccc00ccccccccccccddddddd
-- 023:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb000cccccccccccccccccc000000cccccccccccccccccc000000cccccccccccccccccccccccccccccddddddd
-- 024:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb000cccccccccccccccccc000000cccccccccccccccccc000000cccccccccccccccccccccccccccccddddddd
-- 025:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb000cccccccccccccccccc000000cccccccccccccccccc000000cccccccccccccccccccccccccccccddddddd
-- 026:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000ccccccccccccccccccccccccccccccccddddddd
-- 027:cccccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000bbbb00000000000000000000bb0000000000000000cccc000000cccc00cccc0000cccc0000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000ccccccccccccccccccccccccccccccccddddddd
-- 028:cccccccccddddddddddddccccccccc000ccccccccdddddddddddd00000000000000000bbbb00000000000000000000bb0000000000000000cccc000000cccc00cccc0000cccc0000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000ccccccccccccccccccccc000ccccccccddddddd
-- 029:cccccccccddddddddddddccccccccc000ccccccccdddddddddddd000000000000000bb000000bbbb0000bbbb0000bbbbbb00bbbb000000000000cc00cc00cc000000cc000000cc00000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddd
-- 030:cccccccccddddddddddddccccccccc000ccccccccdddddddddddd000000000000000bb000000bbbb0000bbbb0000bbbbbb00bbbb000000000000cc00cc00cc000000cc000000cc00000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddd
-- 031:cccccccccddddddddddddccccccccc000ccccccccdddddddddddd00000000000000000bb000000bbbb00bb00bb0000bb000000bbbb00000000cc0000cc00cc0000cc000000cc0000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddd
-- 032:cccccccccccccccddddddccccccccc0000000000000000000000000000000000000000bb000000bbbb00bb00bb0000bb000000bbbb00000000cc0000cc00cc0000cc000000cc0000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccc
-- 033:cccccccccccccccddddddccccccccc000000000000000000000000000000000000000000bb00bb00bb00bb00bb0000bb0000bb00bb000000cc000000cc00cc00cc0000000000cc00000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccc
-- 034:cccccccccccccccddddddccccccccc000000000000000000000000000000000000000000bb00bb00bb00bb00bb0000bb0000bb00bb000000cc000000cc00cc00cc0000000000cc00000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccc
-- 035:cccccccccccccccddddddccccccccc00000000000000000000000000000000000000bbbb0000bbbbbb00bb00bb000000bb00bbbbbb000000cccccc00cccc0000cccccc00cccc0000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccc
-- 036:cccccccccccccccddddddccccccccc00000000000000000000000000000000000000bbbb0000bbbbbb00bb00bb000000bb00bbbbbb000000cccccc00cccc0000cccccc00cccc0000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccc
-- 037:cccccccccccccccddddddccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccc
-- 038:d00000cccccccccdddddddddccccc00000000000000000c000000000c0000000000000000000000000c0000cc0000000000000000000000000000cccccccc00000000cccccccc00000000ccccccccccdddddddddccccc0000ccccccddddddddd00000ccccccccccdddddddddccccc0000ccccccddddddddd
-- 039:d00000cccccccccdddddddddccccc00000000000000000cc00c0c000c0000cc00c00cc00cc00c0c00cc000c000000000000000000000000000000cccccccc00000000cccccccc00000000ccccccccccdddddddddccccc0000ccccccddddddddd00000ccccccccccdddddddddccccc0000ccccccddddddddd
-- 040:d000ccccccccccccddddddddccccccc000000000000000c0c0c0c000c000c0c0c0c0c0c00cc0cc00c0c0000c000000000000000000000000000cccccccccccc0000cccccccccccc0000ccccccccccccdddddddddccccccc00ccccccddddddddd000ccccccccccccdddddddddccccccc00ccccccddddddddd
-- 041:0000cccccccccccc000cccccccccccc000000000000000c0c00cc000c000cc00c0c0c0c0c0c0c000c0c00000c00000000000000000000000000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0
-- 042:00cccccccccccccc0cccccccccccccc000000000000000cc0000c000ccc00cc00c00c0c0ccc0c0000cc000cc00c0000000000000000000000cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc0
-- 043:00cccccccccccccc0cccccccccccccc00000000000000000000c0000000000000000000000000000000000000000000000000000000000000cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc0
-- 044:ccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 045:ccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 046:ccccccddddcccccccccccddddcccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccc
-- 047:ccccccddddcccccccccccddddcccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccc
-- 048:ccccccddddcccccccccccddddcccccc000000000000000000000000000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccc
-- 049:ccccccddddcccccccccccddddcccccc00000000000000000000000000cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00ccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccc
-- 050:0cccccddddddccc00ccccdddddd00000000000000000000000000000ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0cccccddddddcccc0cccccddddddcccc0cccccddddddcccc0cccccddddddcccc0cccccddddddcccc0cccccddddddcccc0cccccddddddcccc0cccccddddddcccc0
-- 051:ccccccddddddccc00ccccdddddd0000000000000000000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccc
-- 052:cccddcccccddccc0000000000000000000000000000000000000000cccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddcccc
-- 053:cccddcccccddccc0000000000000000000000000000000000000000cccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddcccc
-- 054:0ccddd00ccddd0000000000000000000000000000000000000000000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000
-- 064:000ffff0000ffff0000ffff00000000000000000000ffff00000000000000000000ffff006666665000ffff0000ffff0000ffff006666665000ffff0000ffff0000ffff0000ffff000000000000ffff000000000000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff056666660000ffff0
-- 065:0ffffff00ffffff00ffffff002200220000000000ffffff000000000022002200ffffff0444666600ffffff00ffffff00ffffff0444666600ffffff00ffffff00ffffff00ffffff0022002200ffffff0022002200ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff0066664440ffffff0
-- 066:0ffffff00ffffff00ffffff002c22c20000000000ffffff00000000002c22c200ffffff0a4a666600ffffff00ffffff00ffffff0a4a666600ffffff00ffffff00ffffff00ffffff002c22c200ffffff002c22c200ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff006666a4a0ffffff0
-- 067:dffff888dffff888dffff8880222222000000000dffff8880000000002222220dffff88044466600dffff888dffff888dffff88044466600dffff888dffff888dffff888dffff88802222220dffff88802222220dffff888dffff888dffff888dffff888dffff888dffff888dffff888006664440ffff888
-- 068:ddeee888ddeee888ddeee880ccc2000022222222000000002222222200002ccd0deee88055666550ddeee888ddeee888ddeee88055666550dd00000000000000ddeee888ddeee880ccc22ccd0deee880ccc22ccd0deee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888055666550deee888
-- 069:ddeee888ddeee888ddeee880ccc2000022222222000000002222222200002ccd0deee88056666550ddeee888ddeee888ddeee88056666550dd00000000000000ddeee888ddeee880ccc22ccd0deee880ccc22ccd0deee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888055666650deee888
-- 070:00eeeeffffffffe000eeeeffffff00002222222200000000222222220000ffcd00eeeeffffffff50000000e0000000e000eeeeffffffff50006666666666665500eeeeffffffffe0ccc22cffffffffe0ccc22cffffffffe000eeeeffffffffe000eeeeffffffffe000eeeeffffffffe005000065000000e0
-- 071:00eeeeffffffff0000eeeeffffff00002222222200000000222222220000ffdd00eeeeffffffff00000000000000000000eeeeffffffff00006666666666665500eeeeffffffff00ddd11dffffffff00ddd11dffffffff0000eeeeffffffff0000eeeeffffffff0000eeeeffffffff000000006000000000
-- 072:00ffffffffffff0000ffffffffff00002222cccc22222222cccc22220000ff0000ffffffffffff00002222000022220000ffffffffffff00444444666666660000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff000022220000222200
-- 073:00ffffffffffff0000ffffffffff00002222cccc22222222cccc22220000ff0000ffffffffffff00002222000022220000ffffffffffff00444444666666660000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff000022220000222200
-- 074:00ffffffffffff0000ffffffffff00002222cccc22222222cccc22220000ff0000ffffffffffff000022cc2222cc220000ffffffffffff00aa44aa666666660000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff000022cc2222cc2200
-- 075:00ffffffffffff0000ffffffffff00002222cccc22222222cccc22220000ff0000ffffffffffff000022cc2222cc220000ffffffffffff00aa44aa666666660000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff000022cc2222cc2200
-- 076:ddffffffff888888ddffffffff88000022222222222222222222222200008888ddffffffff8888880022222222222200ddffffffff8888004444446666660000ddffffffff888888ddffffffff888888ddffffffff888888ddffffffff888888ddffffffff888888ddffffffff8888880022222222222200
-- 077:ddffffffff888888ddffffffff88000022222222222222222222222200008888ddffffffff8888880022222222222200ddffffffff8888004444446666660000ddffffffff888888000000000000000000000fffff888888ddffffffff888888ddffffffff888888ddffffffff8888880022222222222200
-- 078:ddddeeeeee888888ddddeeeeee88000022222222222222222222222200008888ddddeeeeee888800cccccc2222ccccdd00ddeeeeee8888005555666666555500ddddeeeeee888888000000000000000000000eeeee888888ddddeeeeee888888ddddeeeeee888888ddddeeeeee888800cccccc2222ccccdd
-- 079:ddddeeeeee888888ddddeeeeee88000022222222222222222222222200008888ddddeeeeee888800cccccc2222ccccdd00ddeeeeee8888005555666666555500ddddeeeeee888888000000000000000000000eeeee888888ddddeeeeee888888ddddeeeeee888888ddddeeeeee888800cccccc2222ccccdd
-- 080:ddddeeeeeffffffffffffeee0000cccccccccccc22222222ccccccccdddd0000fffffeeeee888800cffffffffffffcdd00ddeeeeeffffffffffff66666555500dffffffffffff000555666666666666666666000ee888888dffffffffffff888ddddeeeeeffffffffffffeeeee888800cffffffffffffcdd
-- 081:ddddeeeeeffffffffffffeee0000cccccccccccc22222222ccccccccdddd0000fffffeeeee888800cffffffffffffcdd00ddeeeeeffffffffffff66666555500dffffffffffff000555666666666666666666000ee888888dffffffffffff888ddddeeeeeffffffffffffeeeee888800cffffffffffffcdd
-- 082:0000eeeeeffffffffffffeee0000cccccccccccc22222222ccccccccdddd0000fffffeeeeeeeee00cffffffffffffcdd0000eeeeeffffffffffff666665555000ffffffffffff000555666666666666666666000eeeeee000ffffffffffffe000000eeeeeffffffffffffeeeeeeeee00cffffffffffffcdd
-- 083:000ffffffffffffffffffeee0000cccccccccccc22222222ccccccccdddd0000fffffeeeeeeffffffffffffffffffcdd000ffffffffffffffffff666665ffffffffffffffffffe00000666666666666444444444000ffffffffffffffffffe00000ffffffffffffffffffeeeeeeffffffffffffffffffcdd
-- 084:000ffffffffffffffffffeee0000cccccccccccc22222222ccccccccdddd0000fffffeeeeeeffffffffffffffffffddd000ffffffffffffffffff666660ffffffffffffffffff000000666666666666444444444000ffffffffffffffffff000000ffffffffffffffffffeeeeeeffffffffffffffffffddd
-- 085:000ffffffffffffffffffeee0000cccccccccccc22222222ccccccccdddd0000fffffeeeeeeffffffffffffffffffddd000ffffffffffffffffff666660ffffffffffffffffff000000666666666666444444444000ffffffffffffffffff000000ffffffffffffffffffeeeeeeffffffffffffffffffddd
-- 086:000ffffffffffffffffff0000000cccccccccccc22222222ccccccccdddd0000fffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000666666666666aaa444aaa000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000
-- 087:000ffffffffffffffffff0000000cccccccccccc22222222ccccccccdddd0000fffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000666666666666aaa444aaa000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000
-- 088:000ffffffffffffffffff0000000cccccccccccc22222222ccccccccdddd0000fffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000666666666666aaa444aaa000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000
-- 089:dddffffffffffff8888888880000cccccccccccc22222222ccccccccdddd000088888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888000000666666666444444444000ffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888
-- 090:dddffffffffffff8888888880000cccccccccccc22222222ccccccccdddd000088888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888000000666666666444444444000ffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888
-- 091:dddffffffffffff8888888880000cccccccccccc22222222ccccccccdddd000088888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888000000666666666444444444000ffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888
-- 092:ddddddeeeeeeeee8888888880000dddddddddddd11111111dddddddddddd000088888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666555555000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 093:ddddddeeeeeeeee8888888880000dddddddddddd11111111dddddddddddd000088888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666555555000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 094:ddddddeeeeeeeee8888888880000dddddddddddd11111111dddddddddddd000088888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666555555000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 095:ddddddeeeeeeeee8888888880000dddddddddddd11111111dddddddddddd000088888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666666555000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 096:ddddddeeeeeeeee888888888dddd00000000000000000000000000000000eee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666666555000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 097:ddddddeeeeeeeee888888888dddd00000000000000000000000000000000eee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666666555000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 098:000000eeeeeeeeeeeeeee000000000000000000000000000000000000000eeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000555555666666666666555000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000
-- 099:000000eeeeeeeeeeeeeee000000000000000000000000000000000000000eeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000555555666666666666555000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000
-- 100:000000eeeeeeffffffffffffffff0000cccc2222222222222222222222220000eeeee0000000ffffffffffffffffe000000000eeeeeeffffffffffffffff00eeeeeeeeeeeeeeffffffffffffffff6666666665550000ffffffffffffffffe000000000000000eeeeeeee0000000000eeeeeeeeeeeeeeffff
-- 101:000000eeeeeeffffffffffffffff0000cccc2222222222222222222222220000ee0000000000ffffffffffffffff0000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff6666666660000000ffffffffffffffff0000000000000000eeeeee000000000000eeeeeeeeeeee00ffff
-- 102:000000eeeeeeffffffffffffffff0000cccc2222222222222222222222220000ee0000000000ffffffffffffffff0000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff6666666660000000ffffffffffffffff0000000000000000eeeeee000000000000eeeeeeeeeeee00ffff
-- 103:000000eeeeeeffffffffffffffff0000cccc2222222222222222222222220000ee0000000000ffffffffffffffff0000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff6666666660000000ffffffffffffffff0000000000000000eeeeee000000000000eeeeeeeeeeee00ffff
-- 104:0000ffffffffffffffffffffffff00000000cccccccc222222224444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffff
-- 105:0000ffffffffffffffffffffffff00000000cccccccc222222224444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffff
-- 106:0000ffffffffffffffffffffffff00000000cccccccc222222224444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffff
-- 107:0000ffffffffffffffffffffffff00000000cccccccc222222224444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffff
-- 108:0000ffffffffffffffffffffffff00000000cccccccc22222222eeee4444eeee0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffff
-- 109:0000ffffffffffffffffffffffff00000000cccccccc22222222eeee4444eeee0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffff
-- 110:0000ffffffffffffffffffffffff00000000cccccccc22222222eeee4444eeee0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffff
-- 111:0000ffffffffffffffffffffffff00000000cccccccc22222222eeee4444eeee0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffff
-- 112:ddddffffffffffffffff8888888888880000cccccccc222222224444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffff
-- 113:ddddffffffffffffffff8888888888880000cccccccc222222224444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffff
-- 114:ddddffffffffffffffff8888888888880000cccccccc222222224444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffff
-- 115:ddddffffffffffffffff8888888888880000cccccccc222222224444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffff
-- 116:ddddddddeeeeeeeeeeee888888888888dddd0000cccc222222222222cccccccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 117:ddddddddeeeeeeeeeeee888888888888dddd0000cccc222222222222cccccccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 118:ddddddddeeeeeeeeeeee888888888888dddd0000cccc222222222222cccccccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 119:ddddddddeeeeeeeeeeee888888888888dddd0000cccc222222222222cccccccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 120:ddddddddeeeeeeeeeeee888888888888dddddddd00002222222222222222cccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 121:ddddddddeeeeeeeeeeee888888888888dddddddd00002222222222222222cccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 122:ddddddddeeeeeeeeeeee888888888888dddddddd00002222222222222222cccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 123:ddddddddeeeeeeeeeeee888888888888dddddddd00002222222222222222cccc0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeee
-- 124:00000000eeeeeeeeeeeeeeeeeeee00000000000000002222222222222222cccc00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeee
-- 125:00000000eeeeeeeeeeeeeeeeeeee00000000000000002222222222222222cccc00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeee
-- 126:00000000eeeeeeeeeeeeeeeeeeee00000000000000002222222222222222cccc00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeee
-- 127:00000000eeeeeeeeeeeeeeeeeeee00000000000000002222222222222222cccc00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeee
-- 128:00000000eeeeeeeeeeeeeeee000000000000000000002222222222222222000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeee
-- 129:00000000eeeeeeeeeeeeeeee000000000000000000002222222222222222000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeee
-- 130:00000000eeeeeeeeeeeeeeee000000000000000000002222222222222222000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeee
-- 131:00000000eeeeeeeeeeeeeeee000000000000000000002222222222222222000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeee
-- </SCREEN>

-- <PALETTE>
-- 000:1a1c485d4869b13e7def7d91ffcdc2a7f0be38b7be25719929596f3b85c941c6f673faf7d6f4f475b0c2446c86143c57
-- </PALETTE>

