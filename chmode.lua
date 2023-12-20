-- Challenge mode code

partimes={
--446,842,2498,1934,20*60
10*60,20*60,50*60,40*60,60*60-5*60
}

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
  
  end)

  local i=0
  while i<t4//2 do
    if not coroutine.resume(cha_cor) then
      cha_loaded=true
      break
    end
    i=i+1
  end
  
  if btnp(4) or (t>0 and keyp(50)) then lvl=cha; generate(); t=0; tt=0; rt=0; loaded=false; labels={}; TIC=ssanta; t4=-1 end

  reset_save()
  
  t4=t4+1
end

function cm_unlock()
  cls(8)
  local msg='Challenge mode unlocked!'
  local tw=print(msg,0,-6)
  print(msg,240/2-tw/2,136/2-3,11)
  if btnp(4) then reset() end
  reset_save()
  t=t+1
end

