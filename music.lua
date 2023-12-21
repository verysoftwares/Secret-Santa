function music1()
  -- unused
  if t%49%24==7 and t%6~=0 then
    sfx(1,12*4+t//6%12-t//2%16,20,0)
  end
  if t%49==7 then
    sfx(1,12*3+t//6%12-t//2%16,60,1)
  end
end

function gamemusic()
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

function loadermusic()
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

function chmodemusic()
  tt3=tt3 or 0
  rt3=rt3 or 1
  if (tt3<90 and tt3%1==0) or (tt3>=90 and tt3%9==0) then
    sfx(1,12*3+tt3%20+tt3%22,9,0)
  end
  if tt3==90-1 and rt3<1 then tt3=0; rt3=rt3+1 end
  if tt3==90+9*8*4*4-9*8*2-9*4-1 then tt3=-1; rt3=0 end
  tt3=tt3+1
end

function bossmusic()
  tt=tt or 0
  rt=rt or 0
  if tt%(tt%12+1)%24==0 then
    sfx(1,12*3+tt%15+tt%17,20,0)
  end
  tt=tt+1
end