Window = Class{}

function Window:init(def)
  self.x = def.x
  self.y = def.y
  self.y0 = self.y
  self.width = def.width
  self.height = def.height
  self.onClick = function() end
  self.font = def.font or gFonts['small']
  self.subelements = {}
  
  self.volume = def.volume or false
  
  self.alignment = def.alignment or 'center'
  
  self.onHover = def.onHover or function() end
  self.onClick = def.onClick or function() end
  
  
  self.color1 = def.color1 or palette[2]
  self.color2 = def.color2 or palette[55]
  self.colorFont = def.colorFont or palette[1]
  self.colorFont2 = def.colorFont2 or self.colorFont
  --[[
  self.color2 = {}
  for i, color in ipairs(self.color1) do
    self.color2[i] = 0.8*self.color1[i]
  end
  ]]
  
  self.text1 = def.text1
  self.text2 = def.text2
  if self.text2 then
    self.textComplex = true
  elseif self.text1 then
    self.textSimple = true
    self.text = self.text1
  end
  
  self.borderRadius = 0--20*scale
  
  self.shadow = false

end

function Window:mouseIsOver(xMouse, yMouse)
    return (xMouse > self.x and xMouse < self.x + self.width and yMouse > self.y and yMouse < self.y + self.height)
end


function Window:render()

  
  if self.volume then
    local offset = 3*scale
    love.graphics.setColor(self.color2)
    love.graphics.rectangle('fill', self.x + offset, self.y + offset, self.width, self.height, self.borderRadius, self.borderRadius)
  end

  
  
  if self.shadow then
    love.graphics.setColor(self.color2)
  else
    love.graphics.setColor(self.color1)
  end
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.borderRadius, self.borderRadius)
  
  if self.textSimple then
    if self.shadow then
      love.graphics.setColor(self.colorFont2)
    else
      love.graphics.setColor(self.colorFont)
    end
    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, self.x + offsetBig, self.y + self.height/2 - self.font:getHeight()/2, self.width - 2*offsetBig, self.alignment)
  end
  
  --[[
  if self.textComplex then
    local vOffset = 3*scale
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.text1, self.x, self.y + vOffset, self.width, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(self.text2, self.x, self.y + vOffset + gFonts['large']:getHeight(), self.width, 'center')
  end
  ]]

  if self.icon then
    local iconScale = 16
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['icons'], gFrames['icons'][approachesTransparentIcon[self.approach]], self.x + self.width/2 - 10*iconScale/2, self.y + self.height/2 - 10*iconScale/2, 0, iconScale, iconScale)
    --gTextures['icons'], gFrames['icons'][statusIcon[status]]
  end
  
  --[[
  if self.shadow then
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.borderRadius, self.borderRadius)
  end
  ]]

end