-- title:   1SSANTA.EXE
-- author:  verysoftwares
-- desc:    for Secret Santa Jam
-- site:    https://verysoftwares.itch.io
-- license: MIT
-- script:  lua
-- saveid:  1SSANTA
-- menu:    ClearSaveFile

-- developer mode: 
-- you can clear your save file
-- from Esc -> Game Menu,
-- removing the Challenge mode.
function MENU(i)
  for j=0,255 do pmem(j,0); flag_empty_pmem=true end
  for k=1,5 do
    records[k]=partimes[k]
  end
end

partimes={
--446,842,2498,1934,20*60
10*60,20*60,50*60,40*60,60*60-5*60
}

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
SP_EMPTY_HL=101
SP_BOSSL=67
SP_BOSSR=SP_BOSSL-16
SP_BOSSGIFTL=SP_BOSSL+1
SP_BOSSGIFTR=SP_BOSSL+1-16
SP_GIFT2=SP_GIFT-16+1

t=0
x=96
y=24
santax=1
santay=4
santadx=1
santas=3

function generate()
  lanes={
    {},
    {},
    {},
    {},
  }
  for i=1,4 do
  local c=0
  local rpos
  if lvl==1 then    
    -- insert random elf
    while i==1 and c<1 do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_ELFR+math.random(0,1)*16
      c=c+1
    end
    
    c=0
    -- insert two random gifts
    -- on separate lanes
    while (i==2 or i==3) and c<1 do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_GIFT
      c=c+1
    end
  end
  if lvl==2 then
    while (i==1 and c<2) or (i==2 and c<1) do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_ELFR+math.random(0,1)*16
      c=c+1
    end
    
    c=0
    while ((i==1 or i==2) and c<2) or ((i==3 or i==4) and c<1) do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_GIFT
      c=c+1
    end    
  end
  if lvl==3 then
    -- old method of generation
    --for j=0,240/i-1,8 do
      --local sp=SP_EMPTY
      --if math.random()<0.15 then sp=SP_GIFT
      --elseif math.random()<0.15 then sp=SP_ELFL-math.random(0,1)*16 end
      --table.insert(lanes[i],sp)
    --end
    
    -- new method of generation

    -- insert random elves
    -- 3 in lane 1, 2 in lane 2, 1 in lane 3, 0 in lane 4
    while c<4-i do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_ELFR+math.random(0,1)*16
      c=c+1
    end
  
    -- insert random gifts
    -- 4 in lane 1, 3 in lane 2, 2 in lane 3, 1 in lane 4
    c=0
    while c<4-i+1 do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_GIFT
      c=c+1
    end
  end
  if lvl==4 then
    while c<4-i+1 do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_ELFR+math.random(0,1)*16
      -- no instakills
      if i==4 and rpos==2 and lanes[i][rpos]==SP_ELFL then lanes[i][rpos]=SP_ELFR end
      if i==4 and rpos==8 and lanes[i][rpos]==SP_ELFR then lanes[i][rpos]=SP_ELFL end
      c=c+1
    end
    
    c=0
    while (i==4 and c<1) do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_GIFT
      c=c+1
    end    
  end
  if lvl==5 then
    while i==4 and c<1 do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_BOSSR+math.random(0,1)*16
      -- no instakills
      if i==4 and rpos==2 and lanes[i][rpos]==SP_BOSSL then lanes[i][rpos]=SP_BOSSR end
      if i==4 and rpos==8 and lanes[i][rpos]==SP_BOSSR then lanes[i][rpos]=SP_BOSSL end
      boss={x=rpos,y=i,hp=4}
      c=c+1
    end
    
    c=0
    while ((i<4 and c<4) or (i==4 and c<3)) do
      repeat
      rpos=math.random(1,math.floor(240/8/i+0.5))
      until not lanes[i][rpos] and not (i==santay and rpos==santax)
      lanes[i][rpos]=SP_GIFT
      c=c+1
    end    
  end
  -- fill the rest with SP_EMPTYs
  for j=1,math.floor(240/8/i+0.5) do
    if not lanes[i][j] then lanes[i][j]=SP_EMPTY end
  end
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

  if giftshot.x and t%6==0 then
    gift_advance(giftshot)
  end
  if bossgiftshot.x and t%6==0 then
    gift_advance(bossgiftshot)
  end

  if timer<8 then hilightx=nil; hilighty=nil end
  
  global_timer_events()
  
  --t2=t2+1
end

function global_timer_events()
  if fail and t-fail==80 then
    santas=santas-1
    if santas>0 then
      santax=1; santay=4; santadx=1; gift=nil
      for i=SP_SOCK,SP_TREE do pack[i]=4 end
      local step=lanes[santay][santax]
      if step>=SP_SOCK and step<=SP_TREE then
        add_pack(step,1)
        lanes[santay][santax]=SP_EMPTY
        sfx(7,'A-4',10,3)
      end
      fail=nil
    else 
      TIC=infotext('Game over')
    end
  end
  
  if pmem(0)==0 and loaded and not info0 then
    TIC=infotext('Merry Xmas! Press Z to advance these hints.')
    pmem(0,1)
    info0=true
  elseif info0 and pmem(2)==0 and not info2 then
    TIC=infotext('While Santa moves, help him with arrow keys.')
    pmem(2,1)
    info2=true
  elseif TIC==ssanta and (info3 or info4 or info6) and pmem(5)==0 and (not info5) then
    TIC=infotext('Keep an eye out for resources at the top.')
    pmem(5,1)
    info5=true
  elseif TIC==ssanta and info6 and pmem(7)==0 and not info7 then
    TIC=infotext('Oh, and you can throw gifts with Z!')
    pmem(7,1)
    info7=true
  end
  
  if elf_count()==0 then
    if records[lvl]==0 or t<records[lvl] then records[lvl]=t end
    if pmem(255-lvl)==0 or records[lvl]<pmem(255-lvl) then pmem(255-lvl,records[lvl]) end
    if pmem(255)==0 then
    TIC=infotext('No elves left - you win!')
    else
      if t<60*60 then
      TIC=infotext(string.format('No elves left - you win! (%.2d:%.2d)',t//60,math.floor(t%60*100/60)))
      else
      TIC=infotext(string.format('No elves left - you win! (%.2d:%.2d:%.2d)',t/60//60,t//60%60,math.floor(t%60*100/60)))
      end
    end
  end
  
  reset_save()
end

function reset_save()
  -- for actual clearing of memory
  -- press Shift+R
  if flag_empty_pmem or (key(18) and key(64)) then
    for j=0,255 do pmem(j,0) end
    for i=1,5 do records[i]=pmem(255-i) end
    trace('Save reset.',8)
    flag_empty_pmem=false
    reset()
  end
end

t3=0
function infotext(msg)
  if msg~='Game over' and string.sub(msg,1,13)~='No elves left' then sfx(3,'A-6',30,2) end
  return function() 
    if msg~='Game over' and string.sub(msg,1,13)~='No elves left' then music2() end
    
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
      if msg=='Game over' then pmem(99,lvl); reset() end 
      if string.sub(msg,1,13)=='No elves left' then nextlevel() end 
    end
  end
end

function nextlevel()
  lvl=lvl+1
  santax=1; santay=4; santadx=1; santas=3
  for i=SP_SOCK,SP_TREE do pack[i]=4 end
  gift=nil; giftshot.x=nil; giftshot.y=nil; giftshot.dx=nil
  bossgiftshot.x=nil; bossgiftshot.y=nil; bossgiftshot.dx=nil
  if pmem(255)==0 then
    if lvl>5 then
    pmem(255,1); TIC=credits; tt2=0
    else
    generate(); TIC=modal; t=-1; tt2=0
    end
  else TIC=challenge; t=-1; tt2=0; tt3=0; return end
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
          pmem(1,1)
          info1=true
        end
        table.insert(labels,{x=colli,y=i,id=SP_SANTA,count=0,t=t})
        sfx(8,'A-3',30,3)
      elseif coll==SP_EMPTY and lanes[i][colli]==SP_EMPTY then
        -- you're good to walk forward!
        -- but in later levels, the AI might
        -- decide to pivot.
        if lvl>=3 then
        local intent=math.random(0,8)
        local px
        if intent==0 then
          -- move further
          if i>1 then
          px=parallax_shift(-1,j,i,dx)
          if old_lanes[i-1][px]==SP_EMPTY and lanes[i-1][px]==SP_EMPTY then lanes[i][j]=SP_EMPTY; lanes[i-1][px]=v; coroutine.yield() 
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          coroutine.yield()
          end
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          coroutine.yield()
          end
        elseif intent==1 then
          -- move closer
          if i<4 then
          px=parallax_shift(1,j,i,dx)
          if old_lanes[i+1][px]==SP_EMPTY and lanes[i+1][px]==SP_EMPTY then lanes[i][j]=SP_EMPTY; lanes[i+1][px]=v; coroutine.yield()
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          coroutine.yield()
          end
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          coroutine.yield()
          end
        elseif intent==2 then
          -- turn around
          if v==SP_ELFL then
          lanes[i][j]=SP_ELFR
          elseif v==SP_ELFR then
          lanes[i][j]=SP_ELFL
          end
          coroutine.yield()
        else
        lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
        coroutine.yield()
        end
        else
        lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
        coroutine.yield()
        end
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
      if v==SP_BOSSL or v==SP_BOSSR or v==SP_BOSSGIFTL or v==SP_BOSSGIFTR then
      local coll,colli
      local dx
      if v==SP_BOSSL or v==SP_BOSSGIFTL then
        dx=-1
        if j+dx<1 then
        colli=#old_lanes[i]
        else 
        colli=j+dx
        end
      elseif v==SP_BOSSR or v==SP_BOSSGIFTR then 
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
          pmem(1,1)
          info1=true
        end
        table.insert(labels,{x=colli,y=i,id=SP_SANTA,count=0,t=t})
        sfx(8,'A-3',30,3)
      elseif (v==SP_BOSSGIFTL or v==SP_BOSSGIFTR) and santay==i then
        if santax>j and v==SP_BOSSGIFTL then lanes[i][j]=SP_BOSSGIFTR 
        elseif santax<j and v==SP_BOSSGIFTR then lanes[i][j]=SP_BOSSGIFTL 
        else
        -- throw gift
        bossgiftshot.x=j; bossgiftshot.y=i
        if v==SP_BOSSGIFTL then bossgiftshot.dx=-1 else bossgiftshot.dx=1 end
        if v==SP_BOSSGIFTL then lanes[i][j]=SP_BOSSL end
        if v==SP_BOSSGIFTR then lanes[i][j]=SP_BOSSR end
        end
      elseif coll==SP_EMPTY and lanes[i][colli]==SP_EMPTY then
        -- you're good to walk forward!
        local intent=math.random(0,6)
        local px
        if (v==SP_BOSSGIFTL or v==SP_BOSSGIFTR) and santay<i then intent=0 end
        if (v==SP_BOSSGIFTL or v==SP_BOSSGIFTR) and santay>i then intent=1 end
        if intent==0 then
          -- move further
          if i>1 then
          px=parallax_shift(-1,j,i,dx)
          if old_lanes[i-1][px]==SP_EMPTY and lanes[i-1][px]==SP_EMPTY then lanes[i][j]=SP_EMPTY; lanes[i-1][px]=v
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          end
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          end
        elseif intent==1 then
          -- move closer
          if i<4 then
          px=parallax_shift(1,j,i,dx)
          if old_lanes[i+1][px]==SP_EMPTY and lanes[i+1][px]==SP_EMPTY then lanes[i][j]=SP_EMPTY; lanes[i+1][px]=v 
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          end
          else
          lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
          end
        else
        lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
        end
        coroutine.yield()
      elseif (v==SP_BOSSR or v==SP_BOSSL) and coll==SP_GIFT then
        lanes[i][colli]=SP_EMPTY
        if v==SP_BOSSR then lanes[i][j]=SP_BOSSGIFTR end
        if v==SP_BOSSL then lanes[i][j]=SP_BOSSGIFTL end
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
          if v==SP_BOSSL then
          lanes[i][j]=SP_BOSSR
          elseif v==SP_BOSSR then
          lanes[i][j]=SP_BOSSL
          elseif v==SP_BOSSGIFTL then
          lanes[i][j]=SP_BOSSGIFTR
          elseif v==SP_BOSSGIFTR then
          lanes[i][j]=SP_BOSSGIFTL
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
      if is_elf(v) then out=out+1 end
    end
  end
  for j,l in ipairs(labels) do
    if is_elf(l.id) then
      out=out+1
    end
  end
  return out
end

function is_elf(v)
  return v==SP_ELFL or v==SP_ELFR or v==SP_BOSSL or v==SP_BOSSR or v==SP_BOSSGIFTL or v==SP_BOSSGIFTR
end

giftshot={x=nil,y=nil,sp=SP_GIFT,dx=nil}
bossgiftshot={x=nil,y=nil,sp=SP_GIFT2,dx=nil}
function gift_count()
  local out=0
  for i=1,4 do
    for j,v in ipairs(lanes[i]) do
      if v==SP_GIFT then out=out+1 end
    end
  end
  if gift then out=out+gift end
  if giftshot.x then out=out+1 end
  return out
end

function gift_advance(giftshot)
  giftshot.x=giftshot.x+giftshot.dx; 
  sfx(5,'D-4',30,3)
  if giftshot.x>#lanes[giftshot.y] then giftshot.x=1--giftshotx=nil; giftshoty=nil
  elseif giftshot.x<1 then giftshot.x=#lanes[giftshot.y] end
  local step=lanes[giftshot.y][giftshot.x]
  if giftshot.sp==SP_GIFT then
  if step~=SP_EMPTY then 
    local elf= is_elf(step)
    local hit=false
    if elf then
      hit= ((step==SP_ELFL or step==SP_BOSSL or step==SP_BOSSGIFTL) and giftshot.dx>0) or ((step==SP_ELFR or step==SP_BOSSR or step==SP_BOSSGIFTR) and giftshot.dx<0)
    end
    if elf and hit then
    		if step==SP_ELFL or step==SP_ELFR then
      spawn_item(giftshot.x,giftshot.y)
      table.insert(labels,{x=giftshot.x,y=giftshot.y,id=step,count=0,t=t})
      if pmem(8)==0 and not info8 then
        TIC=infotext('Nice, you hit an elf! Get \'em all!')
        pmem(8,1)
        info8=true
      end
      else -- boss
        boss.hp=boss.hp-1
        if boss.hp<=0 then
        table.insert(labels,{x=giftshot.x,y=giftshot.y,id=step,count=0,t=t})
        lanes[giftshot.y][giftshot.x]=SP_EMPTY
        else
        table.insert(labels,{x=giftshot.x,y=giftshot.y,id=118+boss.hp-1,count=1,t=t})
        end
        giftshot.x=nil; giftshot.y=nil; giftshot.dx=nil
      end
    end
    if elf and not hit then
      if pmem(9)==0 and not info9 then
        TIC=infotext('Elves can\'t be hit from behind.')
        pmem(9,1)
        info9=true
      end
    end
    if not elf then
      lanes[giftshot.y][giftshot.x]=SP_EMPTY; 
    end
    if (not elf) or (not hit) then
    table.insert(labels,{x=giftshot.x,y=giftshot.y,id=SP_GIFT,count=0,t=t})
    giftshot.x=nil; giftshot.y=nil; giftshot.dx=nil
    end
  elseif step==SP_EMPTY then 
    spawn_item(giftshot.x,giftshot.y)
  end
  elseif giftshot.sp==SP_GIFT2 then
  if not fail and giftshot.x==santax and giftshot.y==santay then
    fail=t
    table.insert(labels,{x=giftshot.x,y=giftshot.y,id=SP_SANTA,count=0,t=t})
    sfx(8,'A-3',30,3)  
    giftshot.x=nil; giftshot.y=nil; giftshot.dx=nil
  elseif step~=SP_EMPTY then 
    lanes[giftshot.y][giftshot.x]=SP_EMPTY; 
    giftshot.x=nil; giftshot.y=nil; giftshot.dx=nil
  elseif step==SP_EMPTY then
    spawn_item(giftshot.x,giftshot.y)
  end
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
      local sp=v
      -- preview back tile
      if not fail and i==santay-1 and j==parallax_shift(-1,santax,santay,santadx) then
        --rect((j-1)*(8*i)+offx,ly,i*8,i*8,4)
        sp=SP_EMPTY_HL
      end
      -- preview front tile
      if not fail and i==santay+1 and j==parallax_shift(1,santax,santay,santadx) then
        --rect((j-1)*(8*i)+offx,ly,i*8,i*8,5)
        sp=SP_EMPTY_HL
      end
      spr(sp,(j-1)*(8*i),ly,0,i)
      coroutine.yield()
      end
    end
    for j,v in ipairs(lanes[i]) do
      if v~=SP_EMPTY or (i==santay and j==santax and not fail) then
      local offx=0--t*(i*0.25)%(8*i)
      local flip=0
      local sp=v
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
      if v==SP_BOSSGIFTL or v==SP_BOSSGIFTR then
        for i=0,15 do pal(i,0) end
        spr(SP_GIFT2,(j-1)*(8*i)+offx-i+i,ly-8*i-i,0,i)
        spr(SP_GIFT2,(j-1)*(8*i)+offx-i-i,ly-8*i-i,0,i)
        spr(SP_GIFT2,(j-1)*(8*i)+offx-i,ly-8*i-i+i,0,i)
        spr(SP_GIFT2,(j-1)*(8*i)+offx-i,ly-8*i-i-i,0,i)
        pal()
        spr(SP_GIFT2,(j-1)*(8*i)+offx-i,ly-8*i-i,0,i)
      end
      if giftshot.y==i and giftshot.x==j then sp=SP_GIFT end
      if bossgiftshot.y==i and bossgiftshot.x==j then sp=SP_GIFT2 end
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
  print(string.format('%X',math.min(count,15)),64+(i-1)*xdist+offx+10,1+offy,2+i-1)
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
  tt2=tt2 or 0
  if tt2%4==0 and tt2<4*4*8-4*2 then
    sfx(1,12*3+tt2%15,6,0)
  end
  if tt2%6==0 and tt2>=4*4*8-4*2 and tt2<4*4*8-4*2+6*8*28 then
    sfx(1,12*3+tt2%20+tt2%22,6,0)
  end
  if tt2%7==0 and tt2>=4*4*8-4*2+6*8*28 then
    sfx(1,12*3+(tt2-6*8*28)%20+(tt2-6*8*28)%22,6,0)
  end
  if tt2==4*4*8-4*2+6*8*28+7*8*16-1 then tt2=-1 end
  tt2=tt2+1
end

function credits()
  cls(0)
  music3()

  local pos={}    
  for sp=SP_GIFT,SP_TREE do
    local a=t*0.065+(sp-SP_GIFT)*1.5
    table.insert(pos,{sp,a})
  end
  table.sort(pos,function(a,b) return a[2]%(2*math.pi)<b[2]%(2*math.pi) end)
  for i,v in ipairs(pos) do
    local sp=v[1]
    for i=0,15 do pal(i,0) end
    spr(sp,240/2-12+math.cos(v[2])*48+4,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2,0,4)
    spr(sp,240/2-12+math.cos(v[2])*48-4,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2,0,4)
    spr(sp,240/2-12+math.cos(v[2])*48,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2+4,0,4)
    spr(sp,240/2-12+math.cos(v[2])*48,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2-4,0,4)
    pal()
    spr(sp,240/2-12+math.cos(v[2])*48,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2,0,4)
    if v[2]%(2*math.pi)<math.pi then 
    for i=0,15 do pal(i,0) end
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2+4,136/2-32-8+2,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2-4,136/2-32-8+2,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2+4,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2-4,0,4)
    pal()
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2,0,4) 
    end
  end
  
  local tx=0
  local msg='-=* Credits *=-'
  mt=mt or 0
  local tw=print(msg,0,-6*2,0,false,2,false)
  for i=1,math.min(mt//8,#msg) do
    tx=tx+print(string.sub(msg,i,i),240/2-tw/2+tx,0,11,false,2,false)
  end
  msg='Game by Leonard Somero. This is my 20th\nreleased game this year! 2023 has been\ncrazy, I started my own game company\nand am now making games full-time. :)\n\nWishing you the best of Xmas from Oulu,\nFinland. Greets to all you fine folks at\nthe Secret Santa Jam Discord.'
  print(string.sub(msg,1,math.max(0,(mt-8*16)//2)),12,136/2+16,11)
  mt=mt+1
    
  if btnp(4) then 
    TIC=cm_unlock
  end
    
  t=t+1
end
--TIC=credits

function cm_unlock()
  cls(8)
  local msg='Challenge mode unlocked!'
  local tw=print(msg,0,-6)
  print(msg,240/2-tw/2,136/2-3,11)
  if btnp(4) then reset() end
  t=t+1
end

lvl=1
function modal()
  cls(1)
  
  if t>=12*7 then
  music3()
  else
  if t%12==0 and t>0 then 
    local note='A-4'
    if t==12*6 then note='A-5' end
    sfx(9,note,12,0) 
  end
  end

  local pos={}    
  for sp=SP_GIFT,math.min(SP_GIFT-1+(t-12)//12,SP_TREE) do
    local a=t*0.065+(sp-SP_GIFT)*1.5
    table.insert(pos,{sp,a})
  end
  if t>=12 then 
    for i=0,15 do pal(i,0) end
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2+4,136/2-32-8+2-8,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2-4,136/2-32-8+2-8,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2-8+4,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2-8-4,0,4) 
    pal()
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2-8,0,4) 
  end
  table.sort(pos,function(a,b) return a[2]%(2*math.pi)<b[2]%(2*math.pi) end)
  for i,v in ipairs(pos) do
    local sp=v[1]
    for i=0,15 do pal(i,0) end
    spr(sp,240/2-12+math.cos(v[2])*48-4,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2-8,0,4)
    spr(sp,240/2-12+math.cos(v[2])*48+4,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2-8,0,4)
    spr(sp,240/2-12+math.cos(v[2])*48,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2-8-4,0,4)
    spr(sp,240/2-12+math.cos(v[2])*48,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2-8+4,0,4)
    pal()
    spr(sp,240/2-12+math.cos(v[2])*48,136/2-40+math.sin(t*0.1+(sp-SP_GIFT)*1.5)*18+2-8,0,4)
    if v[2]%(2*math.pi)<math.pi then 
    for i=0,15 do pal(i,0) end
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2+4,136/2-32-8+2-8,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2-4,136/2-32-8+2-8,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2-8+4,0,4) 
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2-8-4,0,4) 
    pal()
    spr(SP_SANTA+math.floor(t*0.06)%2*16,240/2-8*2,136/2-32-8+2-8,0,4) 
    end
  end

  if t>=12*6 then
  --poke(0x3FF8,12+t*0.15%4)
  local msg=string.format('Level %d * Level %d * Level %d',lvl,lvl,lvl)
  local tw=print(msg,0,-6*2,0,false,2,false)
  print(msg,240/2-tw/2,136/2+8,12+t*0.15%4,false,2,false)
  msg='Press Z to start.'
  tw=print(msg,0,-6,0,false,1,true)
  print(msg,240/2-tw/2,136-8-1,12,false,1,true)
  if lvl==1 then
  msg='AI: idle'
  elseif lvl==2 then
  msg='AI: naive'
  elseif lvl==3 then
  msg='AI: medium'
  elseif lvl==4 then
  msg='AI: intelligent'
  elseif lvl==5 then
  if t%maxtimer<maxtimer/2 then msg='AI: boss' else msg='' end
  end
  tw=print(msg,0,-6)
  print(msg,240/2-tw/2,136-8-32,12)
  rectb(240/2-20*2,136-8-12-12,18*2,10*2,12)
  rectb(240/2+2,136-8-12-12,18*2,10*2,12)
  local sp=SP_ELFR
  if lvl==5 then sp=SP_BOSSR end
  spr(sp,240/2-20*2+2,136-8-12-12+2,0,2)
  spr(SP_GIFT,240/2+2+2,136-8-12-12+2,0,2)
  print(string.format('x%X',elf_count()),240/2-20*2+2+16+2+1,136-8-12-12+2+6,12)
  print(string.format('x%X',gift_count()),240/2+2+2+16+2+1,136-8-12-12+2+6,12)
  end
  if btnp(4) then loaded=false; t=-1; tt=0; labels={}; TIC=ssanta end
  t=t+1
end

records={
}
for i=1,5 do records[i]=pmem(255-(i)) end

cha=1
t4=0
function challenge()
  local cha_cor= coroutine.create(function()
  cls(8)
  music4()
  local msg='-=* Challenge mode *=-'
  local tw=print(msg,0,-6*2,0,false,2,false)
  print(msg,240/2-tw/2-2,4-2,0,false,2,false)
  coroutine.yield()
  print(msg,240/2-tw/2+2,4-2,0,false,2,false)
  coroutine.yield()
  print(msg,240/2-tw/2,4-2-2,0,false,2,false)
  coroutine.yield()
  print(msg,240/2-tw/2,4+2-2,0,false,2,false)
  coroutine.yield()
  print(msg,240/2-tw/2,4-2,12,false,2,false)
  coroutine.yield()
  
  if btnp(0) then cha=cha-1; if cha<1 then cha=5 end; lvl=cha; generate() end
  if btnp(1) then cha=cha+1; if cha>5 then cha=1 end; lvl=cha; generate() end
  
  for i=1,5 do
    lvl=i; generate()
    local offx=(i-1)*22-36
    local offy=-4+3-2
    local msg=string.format('Level %d',i)
    local col=12
    if cha==i then msg='>'..msg; col=15 end
    print(msg,40+2+offx,24+(i-1)*24+offy,1+i-1,false,2,false)
    coroutine.yield()
    print(msg,40-2+offx,24+(i-1)*24+offy,1+i-1,false,2,false)
    coroutine.yield()
    print(msg,40+offx,24+(i-1)*24+offy+2,1+i-1,false,2,false)
    coroutine.yield()
    print(msg,40+offx,24+(i-1)*24+offy-2,1+i-1,false,2,false)
    coroutine.yield()
    local tw=print(msg,40+offx,24+(i-1)*24+offy,col,false,2,false)
    coroutine.yield()
    if records[i]<60*60 then
    print(string.format('Best: %.2d:%.2d',records[i]//60,math.floor(records[i]%60*100/60)),48+offx,24+(i-1)*24+14+offy,col,false,1,true)
    else
    print(string.format('Best: %.2d:%.2d:%.2d',records[i]/60//60,records[i]//60%60,math.floor(records[i]%60*100/60)),48+offx,24+(i-1)*24+14+offy,col,false,1,true)
    end
    msg=string.format('Par: %.2d:%.2d',partimes[i]//60,math.floor(partimes[i]%60*100/60))
    print(msg,40+offx+tw+6-40+1+6,24+14+(i-1)*24+offy,col,false,1,true)
    coroutine.yield()
    --if cha==i then
    rectb(40+tw+8+offx,24+(i-1)*24-4-1+offy,18*2,10*2,12)
    coroutine.yield()
    rectb(40+tw+8+18*2+4+offx,24+(i-1)*24-4-1+offy,18*2,10*2,12)
    coroutine.yield()
    local sp=SP_ELFR
    if i==5 then sp=SP_BOSSR end
    spr(sp,40+tw+8+1+1+offx,24+(i-1)*24+1-4+1-1+offy,0,2)
    coroutine.yield()
    spr(SP_GIFT,40+tw+8+18*2+4+1+1+offx,24+(i-1)*24+1-4+1-1+offy,0,2)
    coroutine.yield()
    print(string.format('x%X',elf_count()),40+tw+8+1+20+offx,24+(i-1)*24+1+6-4-1+offy,12)
    coroutine.yield()
    print(string.format('x%X',gift_count()),40+tw+8+18*2+4+1+20+offx,24+(i-1)*24+1+6-4-1+offy,12)
    coroutine.yield()
    --end
  end
  
  if btnp(4) or (t>0 and keyp(50)) then lvl=cha; generate(); t=0; tt=0; loaded=false; labels={}; TIC=ssanta; t4=-1 end

  end)

  local i=0
  while i<t4//2 do
    if not coroutine.resume(cha_cor) then
      cha_loaded=true
      break
    end
    i=i+1
  end
  t4=t4+1
end

function music4()
  tt3=tt3 or 0
  rt3=rt3 or 1
  if (tt3<90 and tt3%1==0) or (tt3>=90 and tt3%9==0) then
    sfx(1,12*3+tt3%20+tt3%22,9,0)
  end
  if tt3==90-1 and rt3<1 then tt3=0; rt3=rt3+1 end
  if tt3==90+9*8*4*4-9*8*2-9*4-1 then tt3=-1; rt3=0 end
  tt3=tt3+1
end

-- palette swapping by borbware
  function pal(c0,c1)
    if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i) end
    else poke4(0x3FF0*2+c0,c1) end
  end

if pmem(99)>0 then
  lvl=pmem(99)
  pmem(99,0)
end
generate()

if pmem(255)>0 then
  TIC=challenge
else
  TIC=modal
end
-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 008:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 023:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 024:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 037:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 038:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 051:5999999009999444099996460099944405599955055999950559999500099990
-- 052:5999999005599444055996460559944400599955000999950009999500099990
-- 053:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 054:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 065:566666600666644406666a4a0066644405566655055666650556666500066660
-- 066:566666600556644405566a4a0556644400566655000666650006666500066660
-- 067:0999999544499990646999904449990055999550599995505999955009999000
-- 068:0999999544499550646995504449955055999500599990005999900009999000
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
-- 118:000cc0000cccc0000cccc000000cc000000cc000000cc0000cccccc00cccccc0
-- 119:00cccc000cccccc00cc00cc00000ccc0000ccc0000ccc0000cccccc00cccccc0
-- 120:00cccc000cccccc00cc00cc00000ccc00000cc000cc00cc00cccccc000cccc00
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 004:009bbddeeff899aaaa00000000000000
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- 001:010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100000000000000
-- 002:046004d10403040304040404040404040404040504050406040704070407040704070400040004000400040004000400040004000400040004000400b09000000300
-- 003:040004300460049004d00400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400d49000000000
-- 004:04000400040f040e040c0409040804000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400a09000000000
-- 005:0400040c0408040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400b42000000021
-- 006:049004300490043004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400452000000400
-- 007:0400049004e0040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400309000000300
-- 008:0400f4000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400269000000000
-- 009:0300037003d003f003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300389000003100
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
-- 002:222222222222222222222222222222222222222222222222222222222222222222220222244400222220230666644400000000340220022000000000450000ddd000005500562212200000006600670066650000007700777777777777777777777777777777777777777777777777777777777777777777
-- 003:2222222222222222222222222222222222222222222222222222222222222222222202222e4e000002202306666a4a000333303402c22c200004444045000012100005550056cc0cc10000066600670765567000077700777777777777777777777777777777777777777777777777777777777777777777
-- 004:222cccccccccccccccc2222222222222222cccccccccccccccc222222222222222220022244400002200230066644400300330340222222000400440450000ded000550500560c0022000066060067005667000077070077777777777777777777777777777777777777777777777777777ccccccccccccc
-- 005:222cccccccccccccccc2222222222222222cccccccccccccccc222222222222222220cc222cc0020022023055666550030033034ccc22ccd004004404500dd1210005555505600002c100066666067066665600077777077777777777777777777777777777777777777777777777777777ccccccccccccc
-- 006:222cccccccccccccccc2222222222222222cccccccccccccccc222222222222222220cc2222c0002220023055666650003333034ccc22ccd00044440450deeeed0000005005600000c210000060067576556750000070077777777777777777777777777777777777777777777777777777ccccccccccccc
-- 007:222cccccccccccccccc2222222222222222cccccccccccccccc222222222222222220cc2222c0000000023055666650000000034ccc22ccd0000000045012222100000000056000000220000000067005117000000000077777777777777777777777777777777777777777777777777777ccccccccccccc
-- 008:ccccccccccccccccccccccc22222222cccccccccccccccccccccccc2222222222222000222200000000023000666600000000034ddd11ddd000000004500dddd0000000000560000000c000000006700011000000000007777777777777777777777777777777777777777777777777ccccccccccccccccc
-- 009:ccccccccccccccccccccccc22222222cccccccccccccccccccccccc222222222222222222222222222222333333333333333333444444444444444444555555555555555555666666666666666666777777777777777777777777777777777777777777777777777777777777777777ccccccccccccccccc
-- 010:ccccccccccccccccccccccc00000000cccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccc
-- 011:ccccccccccccccccccccccc00000000cccccccccccccccccccccccc000000000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccc
-- 012:ccccccccccccccccccccccc0000cccccccccccccccccccccccccccc000000000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb00000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc
-- 013:ccccccccccccccccccccccc0000cccccccccccccccccccccccccccc000000000000000000000000000000bbbbbb000000000000000000000000000000000000000000000000000000bbb00000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc
-- 014:ccccccccccccccccccccccc0000cccccccccccccccccccccccccccc000000000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc
-- 015:ccccccccccccccccccccccc0000cccccccccccccccccccccccccccc000000000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc
-- 016:ccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000bbb000000000000bbbbbb000000bbbbbb000bbb000bbb000000bbbbbb000bbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccc
-- 017:ccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb0000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccc
-- 018:ccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb0000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccc
-- 019:ccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000000bbb000000bbb000bbb000bbb000000000bbbbbb000000bbb000bbb000000bbb0000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccc
-- 020:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb00000000cccccccccccc000000000000cccccccccccc000000000000cccccccccccccccccccccccddddddddccccc
-- 021:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb00000000cccccccccccc000000000000cccccccccccc000000000000cccccccccccccccccccccccddddddddccccc
-- 022:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000000000000000000000000000bbb000bbbbbb000000bbb000000000bbb000000000bbbbbb000000000bbb00000000cccccccccccc000000000000cccccccccccc000000000000cccccccccccccccccccccccddddddddccccc
-- 023:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb00cccccccccccccccccc000000cccccccccccccccccc000000ccccccccccccccccccccccccccddddddddccccc
-- 024:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb00cccccccccccccccccc000000cccccccccccccccccc000000ccccccccccccccccccccccccccddddddddccccc
-- 025:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc000000000000000000000000000bbbbbb000000000bbbbbb000000bbbbbb000bbb000000000000bbbbbb000000000bbb00cccccccccccccccccc000000cccccccccccccccccc000000ccccccccccccccccccccccccccddddddddccccc
-- 026:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000cccccccccccccccccccccccccccccddddddddccccc
-- 027:cccddddddddccccccccccccccccccccccccddddddddcccccccccccc0000000000000bbbb00000000000000000000bb0000000000000000cccc000000cccc00cccc0000cccc000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000cccccccccccccccccccccccccccccddddddddccccc
-- 028:cccddddddddddddccccccccccccccccccccdddddddddddd000000000000000000000bbbb00000000000000000000bb0000000000000000cccc000000cccc00cccc0000cccc000000000000ccccccccccccccccccccc000ccccccccccccccccccccc000cccccccccccccccccccccccccccccddddddddddddc
-- 029:cccddddddddddddccccccccccccccccccccdddddddddddd0000000000000000000bb000000bbbb0000bbbb0000bbbbbb00bbbb000000000000cc00cc00cc000000cc000000cc0000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddddddddc
-- 030:cccddddddddddddccccccccccccccccccccdddddddddddd0000000000000000000bb000000bbbb0000bbbb0000bbbbbb00bbbb000000000000cc00cc00cc000000cc000000cc0000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddddddddc
-- 031:cccddddddddddddccccccccccccccccccccdddddddddddd000000000000000000000bb000000bbbb00bb00bb0000bb000000bbbb00000000cc0000cc00cc0000cc000000cc000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddddddddc
-- 032:ccccccccccccddddddccccccccc00000000000000000000000000000000000000000bb000000bbbb00bb00bb0000bb000000bbbb00000000cc0000cc00cc0000cc000000cc000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccccc
-- 033:ccccccccccccddddddccccccccc0000000000000000000000000000000000000000000bb00bb00bb00bb00bb0000bb0000bb00bb000000cc000000cc00cc00cc0000000000cc0000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccccc
-- 034:ccccccccccccddddddccccccccc0000000000000000000000000000000000000000000bb00bb00bb00bb00bb0000bb0000bb00bb000000cc000000cc00cc00cc0000000000cc0000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccccc
-- 035:ccccccccccccddddddccccccccc000000000000000000000000000000000000000bbbb0000bbbbbb00bb00bb000000bb00bbbbbb000000cccccc00cccc0000cccccc00cccc000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccccc
-- 036:ccccccccccccddddddccccccccc000000000000000000000000000000000000000bbbb0000bbbbbb00bb00bb000000bb00bbbbbb000000cccccc00cccc0000cccccc00cccc000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccccc
-- 037:ccccccccccccddddddccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddccccccccccccccccccddddddcccccc
-- 038:cccc00ccccccddddddddd00000000000000000000000c000000000c0000000000000000000000000c0000cc00000000000000000000cccccccc00000000cccccccc00000000cccccccc000ccccccddddddddd000000cccccccccdddddddddcccccc000ccccccddddddddd000000cccccccccdddddddddccc
-- 039:cccc00ccccccddddddddd00000000000000000000000cc00c0c000c0000cc00c00cc00cc00c0c00cc000c0000000000000000000000cccccccc00000000cccccccc00000000cccccccc000ccccccddddddddd000000cccccccccdddddddddcccccc000ccccccddddddddd000000cccccccccdddddddddccc
-- 040:ccccccccccccddddddddd00000000000000000000000c0c0c0c000c000c0c0c0c0c0c00cc0cc00c0c0000c0000000000000000000cccccccccccc0000cccccccccccc0000cccccccccccc0ccccccddddddddd0000cccccccccccdddddddddcccccccc0ccccccddddddddd0000cccccccccccdddddddddccc
-- 041:cccccc000cccccccccccc00000000000000000000000c0c00cc000c000cc00c0c0c0c0c0c0c000c0c00000c000000000000000000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000cccccccccccc0000ccccccc
-- 042:cccccc0cccccccccccccc00000000000000000000000cc0000c000ccc00cc00c00c0c0ccc0c0000cc000cc00c00000000000000cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00ccccccccc
-- 043:cccccc0cccccccccccccc0000000000000000000000000000c00000000000000000000000000000000000000000000000000000cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00cccccccccccccc00ccccccccc
-- 044:ccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 045:ccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 046:cccccccccccddddcccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddc
-- 047:cccccccccccddddcccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddc
-- 048:cccccccccccddddcccccc00000000000000000000000000000000cccc0000cccc0000cccc0000cccc0000cccc0000cccc0000ccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddc
-- 049:cccccccccccddddcccccc0000000000000000000000000000000cccccc00cccccc00cccccc00cccccc00cccccc00cccccc00cccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddccccccccccccddddc
-- 050:ddcccccccccdddddd0000000000000000000000000000000000ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0ccccccc0ccccccccddddddc0ccccccccddddddc0ccccccccddddddc0ccccccccddddddc0ccccccccddddddc0ccccccccddddddc0ccccccccddddddc0ccccccccddddddc0ccccccccddddd
-- 051:ddcccccccccdddddd000000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddddccccccccccddddd
-- 052:cccccddccc0000000000000000000000000000000000000000cccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddc
-- 053:cccccddccc0000000000000000000000000000000000000000cccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddccccccddc
-- 054:d00ccddd0000000000000000000000000000000000000000000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd000ccddd
-- 057:006606600000000000000000000000000000660060000000000000000000660000066660000000000000000000000000000006666600000066000000000000000000000066000000000000000000000000000000000000660006600000000000000000000000000660000660000000066000000000000000
-- 058:006666600666006666006666006006600000660060660600066660066660660000066006066660006660006666006666000000066000000666660066600000006666006666066006006666066660006666006660000006666606666000666000666600666000000666600000666600666660066660000000
-- 059:006666606606606600606600606006600000066600666660600660666000660000066006066006066066066600066600000000660000000066000660060000060066060066066006060066066006066600066066000000660006600606606606660006606600000660060660660060066000666000000000
-- 060:006060606660006600006600000666600000660060606060600660006660000000066660066000066600000666000666000006600000000066000660060000060066060066006660060066066006066600066600000000660006600606660000066606660000000660060660660060066000006660660000
-- 061:006000600666006600006600000006600000660060606060066660666600660000066000066000006660066660066660000006666600000006660066600000006666006666000600006666066006006666006660000000066606600600666006666000666000000660060660660060006660666600660000
-- 062:000000000000000000000000000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:000ffff0000ffff0000ffff0000ffff056666660000ffff0000ffff000000000000000005666666056666660000ffff0000ffff0000ffff0000ffff0000ffff0000ffff000000000000ffff0000ffff0000ffff0000ffff0000ffff056666660000ffff0000ffff0000ffff0000ffff0000ffff000000000
-- 065:0ffffff00ffffff00ffffff00ffffff0066664440ffffff00ffffff0022002200220022006666444066664440ffffff00ffffff00ffffff00ffffff00ffffff00ffffff0022002200ffffff00ffffff00ffffff00ffffff00ffffff0066664440ffffff00ffffff00ffffff00ffffff00ffffff002200220
-- 066:0ffffff00ffffff00ffffff00ffffff006666a4a0ffffff00ffffff002c22c2002c22c2006666a4a06666a4a0ffffff00ffffff00ffffff00ffffff00ffffff00ffffff002c22c200ffffff00ffffff00ffffff00ffffff00ffffff006666a4a0ffffff00ffffff00ffffff00ffffff00ffffff002c22c20
-- 067:dffff888dffff888dffff888dffff888006664440ffff888dffff888022222200222222000666444006664440ffff888dffff888dffff888dffff888dffff888dffff88802222220dffff888dffff888dffff888dffff888dffff888006664440ffff888dffff888dffff888dffff888dffff88802222220
-- 068:0000000000000088ddeee888ddeee888055666550deee888ddeee880ccc22cc0ccc22ccd05566655055666550deee888ddeee888ddeee8880000000000000088ddeee880ccc22ccd0d00000000000000ddeee888ddeee888ddeee888055666550deee888ddeee888ddeee888ddeee888ddeee880ccc22ccd
-- 069:0000000000000088ddeee888ddeee888055666650deee888ddeee880ccc22cc0ccc22ccd05566665055666650deee888ddeee888ddeee8880000000000000088ddeee880ccc22ccd0d00000000000000ddeee888ddeee888ddeee888055666650deee888ddeee888ddeee888ddeee888ddeee880ccc22ccd
-- 070:5566666666666600000000e0000000e0055666ffffffffe000eeeeffffffffc0ccc22cffffffff65055666ffffffffe000eeeeffffffff00556666666666660000eeeeffffffffcd006666666666665500eeeeffffffffe0000000e00500006500eeeeffffffffe0000000e0000000e000eeeeffffffffcd
-- 071:55666666666666000000000000000000000666ffffffff0000eeeeffffffffd0ddd11dffffffff60000666ffffffff0000eeeeffffffff00556666666666660000eeeeffffffffdd006666666666665500eeeeffffffff00000000000000006000eeeeffffffff00000000000000000000eeeeffffffffdd
-- 072:0066666666444444002222000022220000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff00006666666644444400ffffffffffff00444444666666660000ffffffffffff00002222000022220000ffffffffffff00002222000022220000ffffffffffff00
-- 073:0066666666444444002222000022220000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff00006666666644444400ffffffffffff00444444666666660000ffffffffffff00002222000022220000ffffffffffff00002222000022220000ffffffffffff00
-- 074:0066666666aa44aa0022cc2222cc220000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff000066666666aa44aa00ffffffffffff00aa44aa666666660000ffffffffffff000022cc2222cc220000ffffffffffff000022cc2222cc220000ffffffffffff00
-- 075:0066666666aa44aa0022cc2222cc220000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff0000ffffffffffff000066666666aa44aa00ffffffffffff00aa44aa666666660000ffffffffffff000022cc2222cc220000ffffffffffff000022cc2222cc220000ffffffffffff00
-- 076:00006666664444440022222222222200ddffffffff888888ddffffffff888888ddffffffff888888ddffffffff888888ddffffffff888888000066666644444400ffffffff8888004444446666660000ddffffffff8888880022222222222200ddffffffff8888880022222222222200ddffffffff888888
-- 077:00006666664444440022222222222200ddffffffff888888000000000000000000000fffff888888ddffffffff8888880000000000000000000006666644444400ffffffff8888004444446666660000ddffffffff8888880022222222222200ddffffffff8888880022222222222200ddffffffff888888
-- 078:0055556666665500cccccc2222ccccdd00ddeeeeee888888000000000000000000000eeeee888888ddddeeeeee8888880000000000000000000005666666555500ddeeeeee8888005555666666555500ddddeeeeee888800cccccc2222ccccdd00ddeeeeee888800cccccc2222ccccdd00ddeeeeee888888
-- 079:0055556666665500cccccc2222ccccdd00ddeeeeee888888000000000000000000000eeeee888888ddddeeeeee8888880000000000000000000005666666555500ddeeeeee8888005555666666555500ddddeeeeee888800cccccc2222ccccdd00ddeeeeee888800cccccc2222ccccdd00ddeeeeee888888
-- 080:005555666ffffffffffffc2222ccccdd0ffffffffffff000555666666666666666666000ee8000000dddeee000000000555666666666666666666000666666550ffffffffffff800556000000655550000000eeeee888800cffffffffffffcdd00ddeeeeeffffffffffffc2222ccccdd0ffffffffffff888
-- 081:005555666ffffffffffffc2222ccccdd0ffffffffffff000555666666666666666666000ee8000000dddeee000000000555666666666666666666000666666550ffffffffffff800556000000655550000000eeeee888800cffffffffffffcdd00ddeeeeeffffffffffffc2222ccccdd0ffffffffffff888
-- 082:005555666ffffffffffffc2222ccccdd0ffffffffffff000555666666666666666666000eee000000000eee000000000555666666666666666666000666666550ffffffffffffe00556000000655550000000eeeeeeeee00cffffffffffffcdd0000eeeeeffffffffffffc2222ccccdd0ffffffffffffe00
-- 083:005ffffffffffffffffffc2222cffffffffffffffffffe00000666666666666444444444000222222000000222222000000666666666666444444444000ffffffffffffffffffe00000222222000000222222000eeeffffffffffffffffffcdd000ffffffffffffffffffc2222cffffffffffffffffffe00
-- 084:000ffffffffffffffffffd1111dffffffffffffffffff000000666666666666444444444000222222000000222222000000666666666666444444444000ffffffffffffffffff000000222222000000222222000eeeffffffffffffffffffddd000ffffffffffffffffffd1111dffffffffffffffffff000
-- 085:000ffffffffffffffffffd1111dffffffffffffffffff000000666666666666444444444000222222000000222222000000666666666666444444444000ffffffffffffffffff000000222222000000222222000eeeffffffffffffffffffddd000ffffffffffffffffffd1111dffffffffffffffffff000
-- 086:000ffffffffffffffffff000000ffffffffffffffffff000000666666666666aaa444aaa000222ccc222222ccc222000000666666666666aaa444aaa000ffffffffffffffffff000000222ccc222222ccc222000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000
-- 087:000ffffffffffffffffff000000ffffffffffffffffff000000666666666666aaa444aaa000222ccc222222ccc222000000666666666666aaa444aaa000ffffffffffffffffff000000222ccc222222ccc222000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000
-- 088:000ffffffffffffffffff000000ffffffffffffffffff000000666666666666aaa444aaa000222ccc222222ccc222000000666666666666aaa444aaa000ffffffffffffffffff000000222ccc222222ccc222000000ffffffffffffffffff000000ffffffffffffffffff000000ffffffffffffffffff000
-- 089:dddffffffffffff888888888dddffffffffffff888888888000000666666666444444444000222222222222222222000000000666666666444444444000ffffffffffff888888888000222222222222222222000dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888
-- 090:dddffffffffffff888888888dddffffffffffff888888888000000666666666444444444000222222222222222222000000000666666666444444444000ffffffffffff888888888000222222222222222222000dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888
-- 091:dddffffffffffff888888888dddffffffffffff888888888000000666666666444444444000222222222222222222000000000666666666444444444000ffffffffffff888888888000222222222222222222000dddffffffffffff888888888dddffffffffffff888888888dddffffffffffff888888888
-- 092:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666555000ccccccccc222222ccccccddd000555555666666666555555000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 093:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666555000ccccccccc222222ccccccddd000555555666666666555555000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 094:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666555000ccccccccc222222ccccccddd000555555666666666555555000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 095:ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888000555555666666666666000ccccccccc222222ccccccddd000555555666666666666555000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 096:0000000000000000000000000000ddee0000000000000000000000000000666666666000ccccccccc222222ccccccddd000555555666666666666555000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 097:0000000000000000000000000000ddee0000000000000000000000000000666666666000ccccccccc222222ccccccddd000555555666666666666555000dddeeeeeeeee888888000ccccccccc222222ccccccddd000dddeeeeeeeee888888888ddddddeeeeeeeee888888888ddddddeeeeeeeee888888888
-- 098:000000000000000000000000000000ee0000000000000000000000000000666666666000ccccccccc222222ccccccddd000555555666666666666555000000eeeeeeeeeeeeeee000ccccccccc222222ccccccddd000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000
-- 099:000000000000000000000000000000ee0000000000000000000000000000666666666000ccccccccc222222ccccccddd000555555666666666666555000000eeeeeeeeeeeeeee000ccccccccc222222ccccccddd000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000000000eeeeeeeeeeeeeee000
-- 100:cccc22222222222222222222222200005555666666666666666666666666000066666000ccccffffffffffffffffcddd000555555666ffffffffffffffff00eeeeee00000000e000cccc00000000222ccccccddd0000ffffffffffffffffe000000000eeeeeeffffffffffffffff00eeeeeeeeeeeeeeffff
-- 101:cccc22222222222222222222222200005555666666666666666666666666000066666000ddddffffffffffffffffdddd000000000666ffffffffffffffff00eeeeee000000000000dddd00000000111ddddddddd0000ffffffffffffffff0000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffff
-- 102:cccc22222222222222222222222200005555666666666666666666666666000066666000ddddffffffffffffffffdddd000000000666ffffffffffffffff00eeeeee000000000000dddd00000000111ddddddddd0000ffffffffffffffff0000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffff
-- 103:cccc22222222222222222222222200005555666666666666666666666666000066666000ddddffffffffffffffffdddd000000000666ffffffffffffffff00eeeeee000000000000dddd00000000111ddddddddd0000ffffffffffffffff0000000000eeeeeeffffffffffffffff00eeeeeeeeeeee00ffff
-- 104:00002222222222222222444444444444000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 105:00002222222222222222444444444444000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 106:00002222222222222222444444444444000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 107:00002222222222222222444444444444000066666666666666664444444444440000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff0000000022222222000000002222222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 108:00002222222222222222eeee4444eeee00006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 109:00002222222222222222eeee4444eeee00006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 110:00002222222222222222eeee4444eeee00006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 111:00002222222222222222eeee4444eeee00006666666666666666aaaa4444aaaa0000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff000000002222cccc22222222cccc222200000000ffffffffffffffffffffffff00000000ffffffffffffffffffffffff00000000ffffffffffff
-- 112:dddd0000222222222222444444444444000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 113:dddd0000222222222222444444444444000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 114:dddd0000222222222222444444444444000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 115:dddd0000222222222222444444444444000000006666666666664444444444440000ffffffffffffffff888888888888ddddffffffffffffffff88888888888800002222222222222222222222220000ddddffffffffffffffff888888888888ddddffffffffffffffff888888888888ddddffffffffffff
-- 116:0000cccccccc222222222222cccccccc000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 117:0000cccccccc222222222222cccccccc000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 118:0000cccccccc222222222222cccccccc000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 119:0000cccccccc222222222222cccccccc000055555555666666666666555555550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 120:0000cccccccc2222222222222222cccc000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 121:0000cccccccc2222222222222222cccc000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 122:0000cccccccc2222222222222222cccc000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 123:0000cccccccc2222222222222222cccc000055555555666666666666666655550000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888880000cccccccccccc22222222ccccccccdddd0000ddddeeeeeeeeeeee888888888888ddddddddeeeeeeeeeeee888888888888ddddddddeeeeeeee
-- 124:0000cccccccc2222222222222222cccc0000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 125:0000cccccccc2222222222222222cccc0000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 126:0000cccccccc2222222222222222cccc0000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 127:0000cccccccc2222222222222222cccc0000555555556666666666666666555500000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee0000cccccccccccc22222222ccccccccdddd00000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeeeeeeeeeeeeeee000000000000eeeeeeee
-- 128:000000000000222222222222222200000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- 129:000000000000222222222222222200000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- 130:000000000000222222222222222200000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- 131:000000000000222222222222222200000000000000006666666666666666000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee00000000dddddddddddd11111111dddddddddddd00000000eeeeeeeeeeeeeeee0000000000000000eeeeeeeeeeeeeeee0000000000000000eeeeeeee
-- </SCREEN>

-- <PALETTE>
-- 000:1a1c485d4869b13e7def7d91ffcdc2a7f0be38b7be25719929596f3b85c941c6f673faf7d6f4f475b0c2446c86143c57
-- </PALETTE>

