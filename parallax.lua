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