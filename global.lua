-- developer mode: 
-- you can clear your save file
-- from Esc -> Game Menu,
-- removing the Challenge mode.
function MENU(i)
  flag_empty_pmem=true
  for k=1,5 do
    records[k]=partimes[k]
  end
end

function reset_save()
  -- for actual clearing of memory
  -- press Shift+R
  if flag_empty_pmem or (key(64) and keyp(18)) then
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
    if msg~='Game over' and string.sub(msg,1,13)~='No elves left' then gamemusic() end
    
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

-- palette swapping by borbware
  function pal(c0,c1)
    if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i) end
    else poke4(0x3FF0*2+c0,c1) end
  end