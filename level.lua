lvl=1

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
  else TIC=challenge; t=-1; tt2=0; tt3=0; rt3=1; return end
end

-- an update function for level transitions
function modal()
  cls(1)
  
  if t>=12*7 then
  loadermusic()
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

  if btnp(4) then loaded=false; t=-1; tt=0; rt=0; labels={}; TIC=ssanta end

  reset_save()

  t=t+1
end