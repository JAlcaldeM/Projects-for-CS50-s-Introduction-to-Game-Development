Powerup = Class{}

function Powerup:init(effect)
  
  self.effect = effect
  
  self.width = 16
  self.height = 16
  
  -- x is placed in a random space in the middle
  self.x = math.random(0.5*(VIRTUAL_WIDTH / 2 - 8), 1.5*(VIRTUAL_WIDTH / 2 - 8))

  -- y is placed where the streak score was
  self.y = VIRTUAL_HEIGHT / 2 + 8

  -- start us off with no velocity
  self.dy = 50
  
end

  
  function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:update(dt)
  
  self.y = self.y + self.dy * dt
  
  if self.y > VIRTUAL_HEIGHT then
    self.remove = true
  end

end


function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.effect],
        self.x, self.y)
end