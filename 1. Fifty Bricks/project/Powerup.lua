Powerup = Class{}

local POWERUP_IMAGE1 = love.graphics.newImage('powerup.png')
local POWERUP_IMAGE2 = love.graphics.newImage('powerup2.png')
local POWERUP_IMAGE3 = love.graphics.newImage('powerup3.png')
local POWERUP_IMAGE4 = love.graphics.newImage('powerup4.png')
local POWERUP_IMAGE5 = love.graphics.newImage('powerup5.png')

function Powerup:init(y, mode)
    self.image = love.graphics.newImage('powerup.png')
    
     if mode == 1 then
      self.image = POWERUP_IMAGE1
    elseif mode == 2 then
      self.image = POWERUP_IMAGE2
    elseif mode == 3 then
      self.image = POWERUP_IMAGE3
    elseif mode == 4 then
      self.image = POWERUP_IMAGE4
    elseif mode == 5 then
      self.image = POWERUP_IMAGE5
    end
    
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    
    self.x = VIRTUAL_WIDTH + 70
    self.y = y - self.height / 2

end

function Powerup:collides(bird)
      if (self.x) + (self.width) >= bird.x and self.x <= bird.x + BIRD_WIDTH then
        if (self.y) + (self.height) >= bird.y and self.y <= bird.y + BIRD_HEIGHT then
            return true
        end
    end

    return false
end

function Powerup:update(dt, bird)
  
  if self.x < bird.x + bird.width + 50 then
    self.x = self.x + 100 * dt *(bird.x - self.x) / math.abs(bird.x - self.x)
    self.y = self.y + 100 * dt *(bird.y - self.y) / math.abs(bird.y - self.y)
  end
    
  self.x = self.x - PIPE_SPEED * speedMultiplyer * dt
end

function Powerup:render()  
  love.graphics.draw(self.image, self.x, self.y)
end