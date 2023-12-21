santax=1
santay=4
santadx=1
santas=3
giftshot={x=nil,y=nil,sp=SP_GIFT,dx=nil}

function santa_input()
  if fail then return end
  if not loaded then return end
  -- up to go further into the parallax
  if btnp(0) and santay>1 then
    local moved=santa_parallax(-1)
    if moved and pmem(3)==0 and not info3 then
      TIC=infotext('Moving vertically consumes Christmas trees.')
      pmem(3,1)
      info3=true
    end
  end
  -- down to get closer in the parallax
  if btnp(1) and santay<4 then 
    local moved=santa_parallax(1)
    if moved and pmem(3)==0 and not info3 then
      TIC=infotext('Moving vertically consumes Christmas trees.')
      pmem(3,1)
      info3=true
    end
  end
  -- throw with Z
  if btnp(4) and gift then
    if pack[SP_CANE]>0 then
      if giftshot.x and pmem(11)==0 and not info11 then
      TIC=infotext('You can only throw 1 gift at a time.')
      pmem(11,1)
      info11=true
      end
      giftshot.x=santax; giftshot.y=santay; giftshot.dx=santadx
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
    if pmem(4)==0 and not info4 then
      TIC=infotext('Turning around consumes wooly socks.')
      pmem(4,1)
      info4=true
    end
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
  if is_elf(step) then
    hilightx=santax; hilighty=santay
    santax=prevx; santay=santay-dir
    return false
  elseif step==SP_GIFT then
    if not gift and pack[SP_CANE]>0 then gift=1; lanes[santay][santax]=SP_EMPTY; santax=prevx; santay=santay-dir; add_pack(SP_CANE,-1); if pmem(6)==0 and not info6 then TIC=infotext('Picking up gifts consumes candy canes.'); pmem(6,1); info6=true end; sfx(6,'D-5',30,3)
    else hilightx=santax; hilighty=santay; santax=prevx; santay=santay-dir; if not gift and pack[SP_CANE]<=0 then table.insert(labels,{x=santax,y=santay,id=SP_CANE,count=0,t=t}) end end
    return false
  elseif pack[SP_TREE]>0 and step>=SP_SOCK and step<=SP_TREE then
    add_pack(step,1)
    lanes[santay][santax]=SP_EMPTY
    sfx(7,'A-4',10,3)
    add_pack(SP_TREE,-1)
  elseif pack[SP_TREE]>0 then
    add_pack(SP_TREE,-1)
  else
    santax=prevx; santay=santay-dir
    table.insert(labels,{x=santax,y=santay,id=SP_TREE,count=0,t=t})
    return false
  end
  return true
end

function santa_advance()
  if fail then return end
  local prevx=santax; santax=santax+santadx; local border=false
  if santax>=240/8/santay+1 then santax=1; border=true end
  if santax<1 then santax=#lanes[santay]; border=true end
  local step=lanes[santay][santax]
  if step==SP_GIFT then 
    if not gift and pack[SP_CANE]>0 then gift=1; lanes[santay][santax]=SP_EMPTY; santax=prevx; add_pack(SP_CANE,-1); if pmem(6)==0 and not info6 then TIC=infotext('Picking up gifts consumes candy canes.'); pmem(6,1); info6=true end; sfx(6,'D-5',30,3)
    else hilightx=santax; hilighty=santay; santax=prevx; if not gift and pack[SP_CANE]<=0 then table.insert(labels,{x=santax,y=santay,id=SP_CANE,count=0,t=t}) end end
  elseif is_elf(step) then
    hilightx=santax; hilighty=santay
    santax=prevx
  elseif step>=SP_SOCK and step<=SP_TREE then
    add_pack(step,1)
    lanes[santay][santax]=SP_EMPTY
    sfx(7,'A-4',10,3)
  end
  if border and santax~=prevx then if gift then gift=gift-1; if gift<=0 then gift=nil; table.insert(labels,{x=santax,y=santay,id=SP_GIFT,count=0,t=t}); if pmem(10)==0 and not info10 then TIC=infotext('You can\'t wrap gifts around the screen.'); pmem(10,1); info10=true end end end end
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