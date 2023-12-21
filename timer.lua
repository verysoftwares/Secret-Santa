t2=0
function advance_timer()
  global_timer_events()
  
  if not loaded then return end
    
  timer=timer-1

  if timer<=0 then
    if elf_load then
      if timer==0 then elf_cor=elf_advance() end
      timer=0
      if t2%8==0 and not coroutine.resume(elf_cor) then
      timer=maxtimer 
      santa_advance()
      elf_cor=nil
      end
    else
      santa_advance()
      elf_cor=elf_advance()
      while coroutine.resume(elf_cor) do end
      timer=maxtimer
      elf_cor=nil
    end
  end

  if t%6==0 and not (elf_load and elf_cor) then
    if giftshot.x then gift_advance(giftshot) end
    if bossgiftshot.x then gift_advance(bossgiftshot) end
  end

  if timer<8 then hilightx=nil; hilighty=nil end
  
  t2=t2+1
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