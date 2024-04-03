Piece = Class{}

function Piece:init(x, y, frame, playerspeed)
    self.x = x
    self.y = y
    self.frame = frame
    self.delete = false
    self.playerspeed = playerspeed or 0
    
    if frame > 2 then
      self.y = self.y + 8
      self.dy = -100
    else
      self.dy = -120
    end

    
    if frame % 2 == 0 then
      self.x = self.x + 8
      self.dx = 20 + self.playerspeed/4
    else
      self.dx = -20 + self.playerspeed/4
    end
    
end

function Piece:update(dt)
  
  self.dy = self.dy + 1000*dt
  
  self.x = self.x + self.dx*dt
  self.y = self.y + self.dy*dt
  
  if self.y > VIRTUAL_HEIGHT then
    self.delete = true
  end
  
end

function Piece:render()
    love.graphics.draw(gTextures['pieces'], gFrames['pieces'][self.frame], self.x, self.y)
end