bossgiftshot={x=nil,y=nil,sp=SP_GIFT2,dx=nil}

-- if set to true, makes it so that time pauses
-- during elf turn to animate each elf individually.
elf_load=false

function elf_advance()
  return coroutine.create(function()
  local old_lanes={{},{},{},{}}
  for i=1,4 do
    for j,v in ipairs(lanes[i]) do
      if i==santay and j==santax then old_lanes[i][j]=SP_SANTA 
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
      dx,colli=elf_walk(v,j,i,old_lanes)
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
          elf_parallax(-1,v,i,j,colli,old_lanes,dx,true)
          coroutine.yield()
        elseif intent==1 then
          -- move closer
          elf_parallax(1,v,i,j,colli,old_lanes,dx,true)
          coroutine.yield()
        elseif intent==2 then
          -- turn around
          elf_turn(v,i,j)
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
          elf_parallax(-1,v,i,j,colli,old_lanes,dx,false)
        elseif intent==1 then
          elf_parallax(1,v,i,j,colli,old_lanes,dx,false)
        elseif intent==2 then
          elf_turn(v,i,j)
        end
        coroutine.yield()
      end
      end
      if v==SP_BOSSL or v==SP_BOSSR or v==SP_BOSSGIFTL or v==SP_BOSSGIFTR then
      local coll,colli
      local dx
      dx,colli=elf_walk(v,j,i,old_lanes)
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
          elf_parallax(-1,v,i,j,colli,old_lanes,dx,true)
        elseif intent==1 then
          elf_parallax(1,v,i,j,colli,old_lanes,dx,true)
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
          elf_parallax(-1,v,i,j,colli,old_lanes,dx,false)
        elseif intent==1 then
          elf_parallax(1,v,i,j,colli,old_lanes,dx,false)
        elseif intent==2 then
          elf_turn(v,i,j)
        end
        coroutine.yield()
      end
      end
    end
  end
  end)
end

function elf_walk(v,j,i,old_lanes)
  local dx,colli
  if v==SP_ELFL or v==SP_BOSSL or v==SP_BOSSGIFTL then
    dx=-1
    if j+dx<1 then
    colli=#old_lanes[i]
    else 
    colli=j+dx
    end
  elseif v==SP_ELFR or v==SP_BOSSR or v==SP_BOSSGIFTR then 
    dx=1
    if j+dx>#old_lanes[i] then
    colli=1
    else
    colli=j+dx 
    end
  end
  return dx,colli
end

function elf_turn(v,i,j)
  if v==SP_ELFL then
  lanes[i][j]=SP_ELFR
  elseif v==SP_ELFR then
  lanes[i][j]=SP_ELFL
  elseif v==SP_BOSSL then
  lanes[i][j]=SP_BOSSR
  elseif v==SP_BOSSR then
  lanes[i][j]=SP_BOSSL
  elseif v==SP_BOSSGIFTL then
  lanes[i][j]=SP_BOSSGIFTR
  elseif v==SP_BOSSGIFTR then
  lanes[i][j]=SP_BOSSGIFTL
  end
end

function elf_parallax(dir,v,i,j,colli,old_lanes,dx,safe_walk)
  local px
  if (dir<0 and i>1) or (dir>0 and i<4) then
  px=parallax_shift(dir,j,i,dx)
  if old_lanes[i+dir][px]==SP_EMPTY and lanes[i+dir][px]==SP_EMPTY then lanes[i][j]=SP_EMPTY; lanes[i+dir][px]=v
  else
  if safe_walk then lanes[i][j]=SP_EMPTY; lanes[i][colli]=v end
  end
  else
  if safe_walk then lanes[i][j]=SP_EMPTY; lanes[i][colli]=v end
  end
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