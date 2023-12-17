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
for i=SP_SOCK,SP_TREE do
  pack[i]=4
end

maxtimer=36
timer=maxtimer

function ssanta()
  music2()

  santa_input()
  advance_timer()
  
  render_background()
  render_foreground()

  --if not elf_cor then
  t=t+1
  --end
end

TIC=ssanta
cls(0)

function santa_input()
  if not loaded then return end
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
  if not loaded then return end
		
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
  
  if fail and t-fail==80 then
    santas=santas-1
    if santas>0 then
      santax=1; santay=4; santadx=1; gift=nil
      for i=SP_SOCK,SP_TREE do pack[i]=4 end
      fail=nil
    else 
      TIC=infotext('Game over')
    end
  end
  
  if pmem(0)==0 and loaded and not info0 then
    TIC=infotext('Merry Xmas! Press Z to advance these hints.')
    --pmem(0,1)
    info0=true
  elseif info0 and pmem(2)==0 and not info2 then
    TIC=infotext('While Santa moves, help him with arrow keys.')
    info2=true
  end
  
  --t2=t2+1
end

t3=0
function infotext(msg)
  return function() 
    music2()
    
    local tw=print(msg,0,-6)
    print(msg,240/2-tw/2,136/2-3-8,2+t3*0.06%6)
    t3=t3+1

    -- originally I redrew Santa here,
    -- but he overlapped with SP_EMPTYs,
    -- and only the gift can overlap infotext anyway.
    if msg~='Game over' then santa_gift_draw() end

    label_draw()

    if btnp(4) then 
      TIC=ssanta
      if msg=='Game over' then reset() end 
    end
  end
end

function santa_gift_draw()
  if not gift then return end
  local ly
  if santay==1 then ly=136/2-4 end
  if santay==2 then ly=136/2-4+8-2 end
  if santay==3 then ly=136/2-4+8+16-4-4 end
  if santay==4 then ly=136/2-4+8+16+24-8-4 end
  local offx=0
  local j,i=santax,santay
  for i=0,15 do pal(i,0) end
  spr(SP_GIFT,(j-1)*(8*i)+offx-i+i,ly-8*i-i,0,i)
  spr(SP_GIFT,(j-1)*(8*i)+offx-i-i,ly-8*i-i,0,i)
  spr(SP_GIFT,(j-1)*(8*i)+offx-i,ly-8*i-i+i,0,i)
  spr(SP_GIFT,(j-1)*(8*i)+offx-i,ly-8*i-i-i,0,i)
  pal()
  spr(SP_GIFT,(j-1)*(8*i)+offx-i,ly-8*i-i,0,i)
end

function santa_advance()
  if fail then return end
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
      
      if coll==SP_SANTA and not fail then
        fail=t
        if pmem(1)==0 and not info1 then
          TIC=infotext('Don\'t let the elves catch you!')
          info1=true
        end
        table.insert(labels,{x=colli,y=i,id=SP_SANTA,count=0,t=t})
      elseif coll==SP_EMPTY and lanes[i][colli]==SP_EMPTY then
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
    if not elf then
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
  local bg_cor=coroutine.create(function()
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
      coroutine.yield()
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
      if not fail and i==santay and j==santax then 
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
      coroutine.yield()
      end
    end
  end
  end)
  local i=0
  while i<t//2 do
    if not coroutine.resume(bg_cor) then
      --loaded=true
      break
    end
    i=i+1
  end
end

function render_foreground()
  local fg_cor=coroutine.create(function()
  --line(0,56+2,240,56+2,8)
  --line(0,56+1+2,240,56+1+2,9)
  --line(0,56+1+4-1,240,56+1+4-1,8)

  -- item icons
  local offx=4
  local offy=1
  local xdist=18
  for i,v in ipairs({SP_SANTA,SP_ELFR,SP_GIFT,SP_SOCK,SP_CANE,SP_TREE}) do
  if i==1 then rect(0,0,64+offx,10,2) end
  if i==6 then rect(64+6*xdist+offx-1,0,64+offx,10,7) end
  rectb(64+(i-1)*xdist+offx-1,0,18,10,2+i-1)
  spr(v,64+(i-1)*xdist+offx,0+offy,0)
  coroutine.yield()
  local count=0
  if v==SP_SANTA then count=santas end
  if v==SP_ELFR then count=elf_count() end
  if v==SP_GIFT then count=gift_count() end
  if v>=SP_SOCK and v<=SP_TREE then count=pack[v] end
  print(string.format('%x',math.min(count,15)),64+(i-1)*xdist+offx+10,1+offy,2+i-1)
  coroutine.yield()
  end

  -- clouds
  for i=240,-8,-8 do
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i+(t*0.125)%8,136/2-4-8-8,0); coroutine.yield() end
    if i<120+16 then
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i*2+(t*0.25)%16,136/2-4-8-2-8-8,0,2); coroutine.yield() end
    end
    if i<80+24 then
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i*3+(t*0.5)%24,136/2-4-8-16-4-16,0,3); coroutine.yield() end
    end
    if i<60+32 then
    if not (i>2 and i<60-16) then spr(SP_CLOUD,i*4+(t)%32,136/2-4-8-16-24-8-4,0,4); coroutine.yield() end
    end
  end
  
  local offx=2
  local offy=5
  print('Secret',32+32+16+offx,6+offy,11,false,3,true)
  coroutine.yield()
  print('Santa',32+32+16-32+8+8+offx,6+16+offy,11,false,2,true)
  coroutine.yield()
  print('2023',32+32+16-32+8+8+46-2+offx,6+16+offy,12,false,2,true)
  coroutine.yield()
  print('by Leonard S.',32+32+16-32+8-16+2+offx,6+16+16,12,false,1,true)
  coroutine.yield()
  
  label_draw()
  for i=#labels,1,-1 do
    local l=labels[i]
    if t-l.t>=80-1 then table.remove(labels,i) end
  end
  end)
  local i=0
  while i<t//2 do
    if not coroutine.resume(fg_cor) then
      loaded=true
      break
    end
    i=i+1
  end
end

function label_draw()
  for i=1,#labels do
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
  end
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
  rt=rt or 0
  if (rt==0 and tt%18==0) or (tt<18*8*4 and tt%18==0) or (rt==1 and tt>=18*8*4 and tt%12==0) then
    sfx(1,12*4-tt//6%12+tt//2%16-tt//3%9,20,0)
  end
  if tt%36==0 then
    sfx(1,12*4-tt//6%12+tt//2%16-tt//3%9,36,1)
  end
  if tt==18*8*4+18*4-1 and rt==0 then tt=-1; rt=rt+1 end
  if tt==18*8*9+18*4-1 then tt=-1; rt=0 end
  tt=tt+1
end

function music3()
  if t%4==0 and t<4*4*8-4*2 then
    sfx(1,12*3+t%15,6,0)
  end
  if t%6==0 and t>=4*4*8-4*2 then
    sfx(1,12*3+t%15*2,6,0)
  end
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
-- 002:222222222222222222222222222222222222222222222222222222222222222222220222244400222220230666644400333330340220022000044400450000ddd000005500562212200000666660670066650000777770777777777777777777777777777777777777777777777777777777777777777777
-- 003:2222222222222222222222222222222222222222222222222222222222222222222202222e4e000002202306666a4a000003303402c22c200044004045000012100005550056cc0cc10000000660670765567000770000777777777777777777777777777777777777777777777777777777777777777777
-- 004:222222cccccccccccccccc2222222222222222cccccccccccccccc222222222222220022244400002200230066644400003300340222222000044400450000ded000550500560c0022000000660067005667000077770077777777777777777777777777777777777777777777777777777777cccccccccc
-- 005:222222cccccccccccccccc2222222222222222cccccccccccccccc222222222222220cc222cc0020022023055666550003300034ccc22ccd004400404500dd1210005555505600002c100060066067066665600000077077777777777777777777777777777777777777777777777777777777cccccccccc
-- 006:222222cccccccccccccccc2222222222222222cccccccccccccccc222222222222220cc2222c0002220023055666650033000034ccc22ccd00044400450deeeed0000005005600000c210006660067576556750077770077777777777777777777777777777777777777777777777777777777cccccccccc
-- 007:222222cccccccccccccccc2222222222222222cccccccccccccccc222222222222220cc2222c0000000023055666650000000034ccc22ccd0000000045012222100000000056000000220000000067005117000000000077777777777777777777777777777777777777777777777777777777cccccccccc
-- 008:22cccccccccccccccccccccccc22222222cccccccccccccccccccccccc2222222222000222200000000023000666600000000034ddd11ddd000000004500dddd0000000000560000000c000000006700011000000000007777777777777777777777777777777777777777777777777777cccccccccccccc
-- 009:22cccccccccccccccccccccccc22222222cccccccccccccccccccccccc222222222222222222222222222333333333333333333444444444444444444555555555555555555666666666666666666777777777777777777777777777777777777777777777777777777777777777777777cccccccccccccc
-- 010:00cccccccccccccccccccccccc00000000cccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccc
-- 011:00cccccccccccccccccccccccc00000000cccccccccccccccccccccccc00000000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccc
-- 012:cccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccc
-- 013:cccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccc
-- 014:cccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccc
-- 015:cccccccccccccccccccccccccc0000cccccccccccccccccccccccccccc00000000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccc
-- 016:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccc
-- 017:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb00000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccc
-- 018:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb00000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccc
-- 019:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb00000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccc
-- 020:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb00000000cccccccccccc000000000000cccccccccccc000000000000ccccccccccccccccccccccccddddddddcc
-- 021:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb00000000cccccccccccc000000000000cccccccccccc000000000000ccccccccccccccccccccccccddddddddcc
-- 022:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb00000000cccccccccccc000000000000cccccccccccc000000000000ccccccccccccccccccccccccddddddddcc
-- 023:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb00cccccccccccccccccc000000cccccccccccccccccc000000cccccccccccccccccccccccccccddddddddcc
-- 024:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb00cccccccccccccccccc000000cccccccccccccccccc000000cccccccccccccccccccccccccccddddddddcc
-- 025:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb00cccccccccccccccccc000000cccccccccccccccccc000000cccccccccccccccccccccccccccddddddddcc
-- 026:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000ccccccccccccccccccccccccccccccddddddddcc
-- 027:ccccccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000000bbbb00000000000000000000bb0000000000000000cccc000000cccc00cccc0000cccc000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000ccccccccccccccccccccccccccccccddddddddcc
-- 028:ccccccddddddddddddccccccccccc0ccccccccdddddddddddd00000000000000000000bbbb00000000000000000000bb0000000000000000cccc000000cccc00cccc0000cccc000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000ccccccccccccccccccccc0ccccccccdddddddddd
-- 029:ccccccddddddddddddccccccccccc0ccccccccdddddddddddd000000000000000000bb000000bbbb0000bbbb0000bbbbbb00bbbb000000000000cc00cc00cc000000cc000000cc0000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddddd
-- 030:ccccccddddddddddddccccccccccc0ccccccccdddddddddddd000000000000000000bb000000bbbb0000bbbb0000bbbbbb00bbbb000000000000cc00cc00cc000000cc000000cc0000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddddd
-- 031:ccccccddddddddddddccccccccccc0ccccccccdddddddddddd00000000000000000000bb000000bbbb00bb00bb0000bb000000bbbb00000000cc0000cc00cc0000cc000000cc000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddddd
-- 032:ccccccccccccccddddddccccccccc00000000000000000000000000000000000000000bb000000bbbb00bb00bb0000bb000000bbbb00000000cc0000cc00cc0000cc000000cc000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccc
-- 033:ccccccccccccccddddddccccccccc0000000000000000000000000000000000000000000bb00bb00bb00bb00bb0000bb0000bb00bb000000cc000000cc00cc00cc0000000000cc0000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccc
-- 034:ccccccccccccccddddddccccccccc0000000000000000000000000000000000000000000bb00bb00bb00bb00bb0000bb0000bb00bb000000cc000000cc00cc00cc0000000000cc0000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccc
-- 035:ccccccccccccccddddddccccccccc000000000000000000000000000000000000000bbbb0000bbbbbb00bb00bb000000bb00bbbbbb000000cccccc00cccc0000cccccc00cccc000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccc
-- 036:ccccccccccccccddddddccccccccc000000000000000000000000000000000000000bbbb0000bbbbbb00bb00bb000000bb00bbbbbb000000cccccc00cccc0000cccccc00cccc000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccc
-- 037:ccccccccccccccddddddccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccc
-- 038:00000cccccccccdddddddddccccc000000000000000000c000000000c0000000000000000000000000c0000cc000000000000000000000000000cccccccc00000000cccccccc00000000ccccccccccdddddddddccccc0000ccccccddddddddd00000ccccccccccdddddddddccccc0000ccccccddddddddd0
-- 039:00000cccccccccdddddddddccccc000000000000000000cc00c0c000c0000cc00c00cc00cc00c0c00cc000c00000000000000000000000000000cccccccc00000000cccccccc00000000ccccccccccdddddddddccccc0000ccccccddddddddd00000ccccccccccdddddddddccccc0000ccccccddddddddd0
-- 040:000ccccccccccccddddddddccccccc0000000000000000c0c0c0c000c000c0c0c0c0c0c00cc0cc00c0c0000c00000000000000000000000000cccccccccccc0000cccccccccccc0000ccccccccccccdddddddddccccccc00ccccccddddddddd000ccccccccccccdddddddddccccccc00ccccccddddddddd0
-- 041:000cccccccccccc000cccccccccccc0000000000000000c0c00cc000c000cc00c0c0c0c0c0c0c000c0c00000c0000000000000000000000000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc00
-- 042:0cccccccccccccc0cccccccccccccc0000000000000000cc0000c000ccc00cc00c00c0c0ccc0c0000cc000cc00c000000000000000000000cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00
-- 043:0cccccccccccccc0cccccccccccccc000000000000000000000c000000000000000000000000000000000000000000000000000000000000cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00
-- 044:cccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 045:cccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 046:cccccddddcccccccccccddddcccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddcccccccc
-- 047:cccccddddcccccccccccddddcccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddcccccccc
-- 048:cccccddddcccccccccccddddcccccc0000000000000000000000000000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000ccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddcccccccc
-- 049:cccccddddcccccccccccddddcccccc000000000000000000000000000cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00cccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddcccccccc
-- 050:0ccccddddddcccc0ccccdddddd000000000000000000000000000000ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0ccccddddddccccc0ccccddddddccccc0ccccddddddccccc0ccccddddddccccc0ccccddddddccccc0ccccddddddccccc0ccccddddddccccc0ccccddddddccccc0
-- 051:cccccddddddcccc0ccccdddddd00000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddcccccc
-- 052:cccddcccccddccc0000000000000000000000000000000000000000cccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddcccc
-- 053:cccddcccccddccc0000000000000000000000000000000000000000cccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddcccc
-- 054:0ccddd00ccddd0000000000000000000000000000000000000000000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000
-- 056:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222222000000222222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222222000000222222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222222000000222222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222ccc222222ccc222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222ccc222222ccc222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222ccc222222ccc222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 062:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 063:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:000ffff0000ffff0000ffff006666665000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff000000000000ffff0000ffff056666000222222222222222222000ff0000ffff056666660000ffff05666666000000000000ffff00000000000000000000ffff0
-- 065:0ffffff00ffffff00ffffff0444666600ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff0022002200ffffff00ffffff006000ccccccccc222222ccccccddd0000ffffff0066664440ffffff006666444022002200ffffff002200220022002200ffffff0
-- 066:0ffffff00ffffff00ffffff0a4a666600ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff002c22c200ffffff00ffffff006000ccccccccc222222ccccccddd0000ffffff006666a4a0ffffff006666a4a02c22c200ffffff002c22c2002c22c200ffffff0
-- 067:dffff888dffff888dffff88044466600dffff888dffff888dffff888dffff888dffff888dffff888dffff888dffff888dffff888dffff88802222220dffff888dffff88800000ccccccccc222222ccccccddd000dffff888006664440ffff8880066644402222220dffff8880222222002222220dffff888
-- 068:0000000000000088ddeee88055666550ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee880ccc22ccd0deee8880000000000000ccccccccc222222ccccccddd000ddeee888055666550deee88805566650ccc22ccd0deee880ccc22cc0ccc22ccd0deee888
-- 069:0000000000000088ddeee88056666550ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee888ddeee880ccc22ccd0deee8880000000000000ccccccccc222222ccccccddd000ddeee888055666650deee88805566660ccc22ccd0deee880ccc22cc0ccc22ccd0deee888
-- 070:5566666666666600000000e05600005000eeeeffffffffe000eeeeffffffffe000eeeeffffffffe0000000e0000000e000eeeeffffffffe0ccc22cffffffff005566666666000ccccccccc222222ccccccddd000ffffffe0055666ffffffffe0055666ffffffffcd00eeeeffffffffc0ccc22cffffffffe0
-- 071:5566666666666600000000000600000000eeeeffffffff0000eeeeffffffff0000eeeeffffffff00000000000000000000eeeeffffffff00ddd11dffffffff005566666666000ccccccccc222222ccccccddd000ffffff00000666ffffffff00000666ffffffffdd00eeeeffffffffd0ddd11dffffffff00
-- 072:0066666666444444002222000022220000ffffffffffff0000ffffffffffff0000ffffffffffff00002222000022220000ffffffffffff0000ffffffffffff000066666666000ccccccccc222222ccccccddd000ffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff00
-- 073:0066666666444444002222000022220000ffffffffffff0000ffffffffffff0000ffffffffffff00002222000022220000ffffffffffff0000ffffffffffff000066666666000ccccccccc222222ccccccddd000ffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff00
-- 074:0066666666aa44aa0022cc2222cc220000ffffffffffff0000ffffffffffff0000ffffffffffff000022cc2222cc220000ffffffffffff0000ffffffffffff000066666666000ddddddddd111111ddddddddd000ffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff00
-- 075:0066666666aa44aa0022cc2222cc220000ffffffffffff0000ffffffffffff0000ffffffffffff000022cc2222cc220000ffffffffffff0000ffffffffffff000066666666000ddddddddd111111ddddddddd000ffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff00
-- 076:00006666664444440022222222222200ddffffffff888888ddffffffff888888ddffffffff8888880022222222222200ddffffffff888888ddffffffff8888880000666666000ddddddddd111111ddddddddd000ff888888ddffffffff888888ddffffffff888888ddffffffff888888ddffffffff888888
-- 077:00006666664444440022222222222200ddffffffff888888ddffffffff888888ddffffffff8888880022222222222200ddffffffff888888ddffffffff8888880000666666444000000000000000000000000fffff888888ddffffffff888888ddffffffff888888ddffffffff888888ddffffffff888888
-- 078:0055556666665500cccccc2222ccccdd00ddeeeeee888888ddddeeeeee888888ddddeeeeee888800cccccc2222ccccdd00ddeeeeee888888ddddeeeeee8888880055556666665000000000000000000000000eeeee888888ddddeeeeee888888ddddeeeeee888888ddddeeeeee888888ddddeeeeee888888
-- 079:0055556666665500cccccc2222ccccdd00ddeeeeee888888ddddeeeeee888888ddddeeeeee888800cccccc2222ccccdd00ddeeeeee888888ddddeeeeee8888880055556666665000000000000000000000000eeeee888888ddddeeeeee888888ddddeeeeee888888ddddeeeeee888888ddddeeeeee888888
-- 080:005555666ffffffffffffc2222ccccdd0ffffffffffff888ddddeeeeeffffffffffffeeeee888800cffffffffffffcdd00ddeeeeeffffffffffffeeeee8888880ffffffffffff000ccc222222222222222222000ee888888dffffffffffff888ddd000000e88888000000eeeee888888dffffffffffff888
-- 081:005555666ffffffffffffc2222ccccdd0ffffffffffff888ddddeeeeeffffffffffffeeeee888800cffffffffffffcdd00ddeeeeeffffffffffffeeeee8888880ffffffffffff000ccc222222222222222222000ee888888dffffffffffff888ddd000000e88888000000eeeee888888dffffffffffff888
-- 082:005555666ffffffffffffc2222ccccdd0ffffffffffffe000000eeeeeffffffffffffeeeeeeeee00cffffffffffffcdd0000eeeeeffffffffffffeeeeeeeee000ffffffffffff000ccc222222222222222222000eeeeee000ffffffffffffe00000000000eeeee0000000eeeeeeeee000ffffffffffffe00
-- 083:005ffffffffffffffffffc2222cffffffffffffffffffe00000ffffffffffffffffffeeeeeeffffffffffffffffffcdd000ffffffffffffffffffeeeeeeffffffffffffffffff655000cccccc222222444444444000ffffffffffffffffffe00000222222000000222222000eeeffffffffffffffffffe00
-- 084:000ffffffffffffffffffd1111dffffffffffffffffff000000ffffffffffffffffffeeeeeeffffffffffffffffffddd000ffffffffffffffffffeeeeeeffffffffffffffffff600000cccccc222222444444444000ffffffffffffffffff000000222222000000222222000eeeffffffffffffffffff000
-- 085:000ffffffffffffffffffd1111dffffffffffffffffff000000ffffffffffffffffffeeeeeeffffffffffffffffffddd000ffffffffffffffffffeeeeeeffffffffffffffffff600000cccccc222222444444444000ffffffffffffffffff000000222222000000222222000eeeffffffffffffffffff000
-- 086:000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000cccccc222222eee444eee000ffffffffffffffffff000000222ccc222222ccc222000000ffffffffffffffffff000
-- 087:000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000cccccc222222eee444eee000ffffffffffffffffff000000222ccc222222ccc222000000ffffffffffffffffff000
-- 088:000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000000cccccc222222eee444eee000ffffffffffffffffff000000222ccc222222ccc222000000ffffffffffffffffff000
-- 089:dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888000cccccc222222444444444000ffffffffffff888888888000222222222222222222000dddffffffffffff888888888
-- 090:dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888000cccccc222222444444444000ffffffffffff888888888000222222222222222222000dddffffffffffff888888888
-- 091:dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888000cccccc222222444444444000ffffffffffff888888888000222222222222222222000dddffffffffffff888888888
-- 092:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddd000ccc222222222cccccc000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888
-- 093:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddd000ccc222222222cccccc000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888
-- 094:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddd000ccc222222222cccccc000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888
-- 095:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888dddddd000222222222222ccc000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888
-- 096:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee800000000000000000000000000008888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888dddddd000222222222222ccc000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888
-- 097:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee800000000000000000000000000008888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888dddddd000222222222222ccc000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888
-- 098:000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeee0000000000000000000000000000e000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000000222222222222ccc000000eeeeeeeeeeeeeee000ccccccccc222222ccccccddd000000eeeeeeeeeeeeeee000
-- 099:000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeee0000000000000000000000000000e000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000000222222222222ccc000000eeeeeeeeeeeeeee000ccccccccc222222ccccccddd000000eeeeeeeeeeeeeee000
-- 100:000000eeeeeeffffffffffffffff00eeeeeeeeeeeeeeffffffffffffffff000055556666666666666666666666660000000000eeeeeeffffffffffffffff00eeeeeeeeeeeeeeffffffffffffffff222222222ccc0000ffffffffffffffffe000ccccccccc222ffffffffffffffff00eeeeeeeeeeeeeeffff
-- 101:000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff000055556666666666666666666666660000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff2222222220000000ffffffffffffffff0000ddddddddd111ffffffffffffffff00eeeeeeeeeeee00ffff
-- 102:000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff000055556666666666666666666666660000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff2222222220000000ffffffffffffffff0000ddddddddd111ffffffffffffffff00eeeeeeeeeeee00ffff
-- 103:000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff000055556666666666666666666666660000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffffffffffffffff2222222220000000ffffffffffffffff0000ddddddddd111ffffffffffffffff00eeeeeeeeeeee00ffff
-- 104:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 105:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 106:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 107:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 108:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 109:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 110:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 111:0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 112:ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 113:ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 114:ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 115:ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 116:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 117:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 118:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 119:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 120:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 121:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 122:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 123:ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 124:00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee00000000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 125:00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee00000000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 126:00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee00000000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 127:00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee00000000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 128:00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee000000000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- 129:00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee000000000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- 130:00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee000000000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- 131:00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee000000000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- </SCREEN>

-- <PALETTE>
-- 000:1a1c485d4869b13e7def7d91ffcdc2a7f0be38b7be25719929596f3b85c941c6f673faf7d6f4f475b0c2446c86143c57
-- </PALETTE>

