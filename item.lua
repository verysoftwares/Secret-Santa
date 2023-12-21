-- 'pack' has your sock, cane, and tree counts.
-- you start with 4 of each and can pick up
-- a maximum of 15.
pack={}
for i=SP_SOCK,SP_TREE do
  pack[i]=4
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
    table.insert(labels,{x=giftshot.x,y=giftshot.y,id=giftshot.sp,count=0,t=t})
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
  elseif is_elf(step) then
    table.insert(labels,{x=giftshot.x,y=giftshot.y,id=giftshot.sp,count=0,t=t})
    giftshot.x=nil; giftshot.y=nil; giftshot.dx=nil
  elseif step~=SP_EMPTY then 
    lanes[giftshot.y][giftshot.x]=SP_EMPTY; 
    table.insert(labels,{x=giftshot.x,y=giftshot.y,id=giftshot.sp,count=0,t=t})
    giftshot.x=nil; giftshot.y=nil; giftshot.dx=nil
  elseif step==SP_EMPTY then
    spawn_item(giftshot.x,giftshot.y)
  end
  end
end

function gift_count()
  local out=0
  for i=1,4 do
    for j,v in ipairs(lanes[i]) do
      if v==SP_GIFT then out=out+1 end
      if v==SP_BOSSGIFTR or v==SP_BOSSGIFTL then out=out+1 end
    end
  end
  if gift then out=out+gift end
  if giftshot.x then out=out+1 end
  if bossgiftshot.x then out=out+1 end
  return out
end

function spawn_item(sx,sy)
  local rng=math.random(1,10)
  local item=0
  if rng>=7 then item=SP_CANE
  elseif rng>=4 then item=SP_TREE
  elseif rng>=2 then item=SP_SOCK
  else item=SP_GIFT end
  lanes[sy][sx]=item
end

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