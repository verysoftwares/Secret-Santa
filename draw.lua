labels={}

function render_background()
  local bg_cor=coroutine.create(function()
  local bg=0
  if (lvl-1)%2==1 then bg=1 end
  if lvl==5 then bg=8 end
  cls(bg)

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
  -- TIC's scanline function
  -- used for animating text
  poke(0x3FC0+11*3,0xA4+(i*8+t)%64)
  poke(0x3FC0+11*3+1,0x24+(i*12+t)%164)
  poke(0x3FC0+11*3+2,0x24+(i*6+t)%64)
end