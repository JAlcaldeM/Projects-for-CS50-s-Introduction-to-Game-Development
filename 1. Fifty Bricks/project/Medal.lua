Medal = Class{}

function Medal:init(score)
  self.score = score
  
  if self.score >= 30 then
      self.type = 'gold'
      self.image = love.graphics.newImage('goldmedal.png')
    elseif self.score >= 20 then
      self.type = 'silver'
      self.image = love.graphics.newImage('silvermedal.png')
    elseif self.score >= 10 then
      self.type = 'bronze'
      self.image = love.graphics.newImage('bronzemedal.png')
    else
      self.type = 'none'
      return
    end

    self.scalingFactor = 3
    
    self.width = self.scalingFactor * self.image:getWidth()
    self.height = self.scalingFactor * self.image:getHeight()
    
    self.x = VIRTUAL_WIDTH*0.6
    self.y = VIRTUAL_HEIGHT / 6
    
end

function Medal:render()
  if self.type ~= 'none' then  
    love.graphics.draw(self.image, self.x, self.y, 0, self.scalingFactor, self.scalingFactor)
  end
end