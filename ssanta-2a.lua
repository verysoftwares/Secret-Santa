-- title:   1SSANTA.EXE
-- author:  verysoftwares
-- desc:    for Secret Santa Jam
-- site:    https://verysoftwares.itch.io
-- license: MIT
-- script:  lua

SP_ELFL=81
SP_ELFR=81-16
SP_SANTA=97
SP_SANTAGIFT=97+16
SP_EMPTY=83
SP_GIFT=86
SP_SOCK=87
SP_CANE=88
SP_TREE=89
SP_CLOUD=84

t=0
x=96
y=24
santax=1
santay=4
santadx=1

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
  if btnp(0) and santay>1 and pack[SP_TREE]>0 then
    local prevx=santax 
    santax=parallax_shift(-1,santax,santay,santadx)
    santay=santay-1; 
    timer=maxtimer; hilightx=nil; hilighty=nil 
    local step=lanes[santay][santax]
    if step==SP_ELFL or step==SP_ELFL or step==SP_GIFT then
      hilightx=santax; hilighty=santay
      santax=prevx; santay=santay+1
    elseif step>=SP_SOCK and step<=SP_TREE then
      pack[step]=pack[step]+1
      --if step==88 then pack[step]=pack[step]+1 end
      lanes[santay][santax]=SP_EMPTY
      sub_pack(SP_TREE)
    else
      sub_pack(SP_TREE)
    end
  end
  if btnp(1) and santay<4 and pack[SP_TREE]>0 then 
    local prevx=santax
    santax=parallax_shift(1,santax,santay,santadx); 
    santay=santay+1;
    timer=maxtimer; hilightx=nil; hilighty=nil 
    local step=lanes[santay][santax]
    if step==SP_ELFL or step==SP_ELFR or step==SP_GIFT then
      hilightx=santax; hilighty=santay
      santax=prevx; santay=santay-1
    elseif step>=SP_SOCK and step<=SP_TREE then
      pack[step]=pack[step]+1
      --if step==88 then pack[step]=pack[step]+1 end
      lanes[santay][santax]=SP_EMPTY
      sub_pack(SP_TREE)
    else
      sub_pack(SP_TREE)
    end
  end
  -- throw with Z
  if btnp(4) and gift and pack[SP_CANE]>0 then
    giftshotx=santax; giftshoty=santay; giftshotdx=santadx
    gift=gift-1
    if gift<=0 then gift=nil end
    timer=maxtimer
    sub_pack(SP_CANE)
  end
  -- turn with X or arrows
  if (btnp(5) or (santadx>0 and btnp(2)) or (santadx<0 and btnp(3))) and pack[SP_SOCK]>0 then
    santadx=-santadx
    timer=maxtimer
    sub_pack(SP_SOCK)
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

function advance_timer()
  timer=timer-1

  if timer<=0 then
    --if timer==0 then elf_cor=elf_advance() end
    --timer=0
    --if t%8==0 and not coroutine.resume(elf_cor) then
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
end

function santa_advance()
  local prevx=santax; santax=santax+santadx; local border=false
  if santax>=240/8/santay+1 then santax=1; border=true end
  if santax<1 then santax=#lanes[santay]; border=true end
  local step=lanes[santay][santax]
  if step==SP_GIFT then 
    if not gift and pack[SP_CANE]>0 then gift=1; lanes[santay][santax]=83; santax=prevx; sub_pack(88)
    else hilightx=santax; hilighty=santay; santax=prevx end
  elseif step==SP_ELFL or step==SP_ELFR then
    hilightx=santax; hilighty=santay
    santax=prevx
  elseif step>=SP_SOCK and step<=SP_TREE then
    pack[step]=pack[step]+1
    --if step==88 then pack[step]=pack[step]+1 end
    lanes[santay][santax]=SP_EMPTY
  end
  if border and santax~=prevx then if gift then gift=gift-1; if gift<=0 then gift=nil end end end
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
        coll=old_lanes[i][colli] 
      elseif v==SP_ELFR then 
        dx=1
        if j+dx>#old_lanes[i] then
        colli=1
        else
        colli=j+dx 
        end
        coll=old_lanes[i][colli]
      end
      if coll==SP_EMPTY and lanes[i][colli]==SP_EMPTY then
        lanes[i][j]=SP_EMPTY; lanes[i][colli]=v
        coroutine.yield()
      else
        local px
        if i>1 then
        px=parallax_shift(-1,j,i,dx)
        if old_lanes[i-1][px]==SP_EMPTY and lanes[i-1][px]==SP_EMPTY then lanes[i][j]=83; lanes[i-1][px]=v; coroutine.yield() end
        end
        --[[if i<4 and lanes[i][j]==v then
        px=parallax_shift(1,j,i,dx)
        if old_lanes[i+1][px]==83 and lanes[i+1][px]==83  then lanes[i][j]=83; lanes[i+1][px]=v; coroutine.yield() end
        end]]
      end
      end
    end
  end
  end)
end

function gift_advance()
  giftshotx=giftshotx+giftshotdx; 
  if giftshotx>#lanes[giftshoty] then giftshotx=1--giftshotx=nil; giftshoty=nil
  elseif giftshotx<1 then giftshotx=#lanes[giftshoty] end
  local step=lanes[giftshoty][giftshotx]
  if step~=SP_EMPTY then 
    if (step~=SP_ELFL and step~=SP_ELFR) or ((step==SP_ELFL and giftshotdx>0) or (step==SP_ELFR and giftshotdx<0)) then
      lanes[giftshoty][giftshotx]=SP_EMPTY; 
    end
    giftshotx=nil; giftshoty=nil; giftshotdx=nil
  elseif step==SP_EMPTY then 
    local rng=math.random(1,10)
    local item=0
    if rng>=7 then item=88
    elseif rng>=4 then item=89
    elseif rng>=2 then item=87
    else item=86 end
    lanes[giftshoty][giftshotx]=item
  end
end

labels={}
function sub_pack(i)
  pack[i]=pack[i]-1
  if pack[i]<0 then pack[i]=0 end
  table.insert(labels,{x=santax,y=santay,id=i,t=t})
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
      if i==santay-1 and j==parallax_shift(-1,santax,santay,santadx) then
        --rect((j-1)*(8*i)+offx,ly,i*8,i*8,4)
      end
      -- preview front tile
      if i==santay+1 and j==parallax_shift(1,santax,santay,santadx) then
        --rect((j-1)*(8*i)+offx,ly,i*8,i*8,5)
      end
      if santay==i and j==santax then 
        if v==SP_GIFT and not gift then lanes[i][j]=SP_EMPTY; gift=1 end
        sp=SP_SANTA 
        if gift then
        sp=SP_SANTAGIFT
        spr(SP_GIFT,(j-1)*(8*i)+offx-i,ly-8*i,0,i)
        end
      end
      if giftshoty==i and giftshotx==j then sp=SP_GIFT end
      if (sp==SP_SANTA or sp==SP_SANTAGIFT) and santadx<0 then flip=1 end
      if hilightx==j and hilighty==i and v~=SP_EMPTY then for i=0,15 do pal(i,2) end end
      spr(sp,(j-1)*(8*i)+offx,ly,0,i,flip)
      pal()
    end
  end
end

function render_foreground()
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
    if l.y==1 then ly=136/2-4 end
    if l.y==2 then ly=136/2-4+8-2 end
    if l.y==3 then ly=136/2-4+8+16-4-4 end
    if l.y==4 then ly=136/2-4+8+16+24-8-4 end
    spr(l.id,(l.x-1)*(8*l.y),ly-(t-l.t)*0.2*l.y,0,l.y)
    if t-l.t>60 then table.remove(labels,i) end
  end

  -- item icons
  for i=0,3-1 do
  rectb(240/2+40+i*12-1,0,10,16,12)
  spr(SP_SOCK+i,240/2+40+i*12,1,0)
  local col=12
  if pack[SP_SOCK+i]<=0 then col=2 end
  print(math.min(pack[SP_SOCK+i],9),240/2+40+i*12+1+1,16-1-6+1,col)
  end

  print('Secret',32+32+16,6,11,false,3,true)
  print('Santa 2023',32+32+16-32+8+8,6+16,11,false,2,true)
  print('by Leonard S.',32+32+16-32+8-16+2,6+16+16,12,false,1,true)
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
  --if tt%24==0 then
    --sfx(1,12*3-tt//6%12+tt//2%16-tt//3%9,20,1)
  --end
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

