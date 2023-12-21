function credits()
  cls(0)
  loadermusic()

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
    sfx(2,'A-4',60,0); TIC=cm_unlock
  end

  reset_save()
    
  t=t+1
end