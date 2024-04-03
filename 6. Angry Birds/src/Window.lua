Window = Class{}

function Window:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.onClick = function() end
  
  self.color1 = {0, 0.8, 0.6, 1}
  self.color2 = {0, 0.6, 0.4, 1}
  
  self.shadow = false
  
  self.goBack = false
end
--[[
function Window:update(dt)

end
]]

function Window:mouseIsOver(xMouse, yMouse)
    return (xMouse > self.x and xMouse < self.x + self.width and yMouse > self.y and yMouse < self.y + self.height)
end


function Window:render()
  
  local translate = 0
  if self.playstate then
    math.ceil(-self.playstate.levelTranslateX )
  end

  local offset = 2*scale
  love.graphics.setColor(self.color2)
  love.graphics.rectangle('fill', self.x + offset + translate, self.y + offset, self.width, self.height, 10*scale, 10*scale)
  
  love.graphics.setColor(self.color1)
  love.graphics.rectangle('fill', self.x + translate, self.y, self.width, self.height, 10*scale, 10*scale)
  
  if self.icon then
    if self.goBack then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], self.x + self.width/2 - 17.5*scale + translate, self.y + self.height/2 - 17.5*scale, 0, 1*scale, 1*scale)
    else
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(gTextures[self.material], gFrames[self.material][self.shape][3], math.floor(self.x + self.width/2 - 17.5*scale + translate), math.floor(self.y + self.height/2 - 17.5*scale), 0, 1*scale, 1*scale)
    end
  end
  
  if self.textSimple then
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.text, self.x, self.y + self.height/2 - gFonts['large']:getHeight()/2, self.width, 'center')
  end
  
  if self.textComplex then
    local vOffset = 3*scale
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.text1, self.x, self.y + vOffset, self.width, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(self.text2, self.x, self.y + vOffset + gFonts['large']:getHeight(), self.width, 'center')
  end
  
  

  if self.shadow then
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle('fill', self.x + translate, self.y, self.width, self.height, 10*scale, 10*scale)
  end
  

end