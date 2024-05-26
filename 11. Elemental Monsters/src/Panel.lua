Panel = Class{}

function Panel:init(def)
  
  self.x = def.x
  self.y = def.y
  self.y0 = self.y
  self.width = def.width
  self.height = def.height
  self.offset = def.offset or offset
  self.subelements = def.subelements or {}
  self.centered = def.centered
  if self.centered == nil then
    self.centered = true
  end
  self.nameIcon = def.nameIcon or false
  self.notNameMargin = def.notNameMargin or false
  
  self.onHover = def.onHover or function() end
  self.onClick = def.onClick or function() end
  
  
  if self.color1 == nil then
    self.color1 = colorsPure.black
    self.color2 = colorsPure.white
  else
    self.color1 = def.color
    self.color2 = {}
    for i = 1, 3 do
      self.color2[i] = 0.8*self.color1[i]
    end
  end
  
  self.style = def.style or 'default'
  if self.style == 'default' then
    self.color1 = def.color1 or colorsPure.black
    self.color2 = def.color2 or colorsPure.white
    self.borderRadius = 0
    self.colorFont1 = def.colorFont1 or colorsPure.white
    self.colorFont2 = def.colorFont2 or colorsPure.black
  else
    self.color1 = def.color
    self.color2 = {}
    for i = 1, 3 do
      self.color2[i] = 0.8*self.color1[i]
      self.borderRadius = 20*scale
    end
    self.colorFont1 = colors.black
    self.colorFont2 = colors.black
  end
  

  
  self.name = def.name
  self.value = def.value
  self.font = def.font or gFonts['small']
  self.fontOffset = def.fontOffset or self.offset
  self.alignment = def.alignment or 'center'
  if self.vcenter == nil then
    self.vcenter = true
  end
  self.fontHeight = self.font:getHeight()
  
  if self.name then
    if self.notNameMargin then
      self.y2 = self.y + self.fontHeight
      self.height2 = self.height - self.offset - self.fontHeight
    else
      self.y2 = self.y + 2*self.offset + self.fontHeight
      self.height2 = self.height - 3*self.offset - self.fontHeight
    end
  else
    self.y2 = self.y + self.offset
    self.height2 = self.height - 2*self.offset
  end
  self.y20 = self.y2
  self.x2 = self.x + self.offset
  self.width2 = self.width - 2*self.offset
  
  if self.value then
    local _, wrappedText = self.font:getWrap(self.value, self.width2 - 10*self.fontOffset)
    local nLines = def.nLines or #wrappedText
    self.textHeight = (self.font:getLineHeight()*nLines-1)+(self.fontHeight*nLines)
  end


end

function Panel:mouseIsOver(xMouse, yMouse)
    return (xMouse > self.x and xMouse < self.x + self.width and yMouse > self.y and yMouse < self.y + self.height)
end

function Panel:render()

  


  love.graphics.setColor(self.color2)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.borderRadius, self.borderRadius)
  
  love.graphics.setColor(self.color1)
  love.graphics.rectangle('fill', self.x2, self.y2, self.width2, self.height2, self.borderRadius, self.borderRadius)
  
  
  love.graphics.setFont(self.font)
  if self.name then
    love.graphics.setColor(self.colorFont2)
    if self.nameIcon then
      love.graphics.printf(self.name, self.x + 40 + self.offset, self.y + (self.y2 - self.y)/2 - self.fontHeight/2, self.width, 'left')
    else
      love.graphics.printf(self.name, self.x, self.y + (self.y2 - self.y)/2 - self.fontHeight/2, self.width, 'center')
    end
  end
  
  if self.value then
    love.graphics.setColor(self.colorFont1)
    if self.centered then
      love.graphics.printf(self.value, self.x2 + self.fontOffset, self.y2 + self.height2/2 - self.textHeight/2, self.width2 - 2*self.fontOffset, self.alignment)
    else
      love.graphics.printf(self.value, self.x2 + self.fontOffset , self.y2 + self.fontOffset, self.width2 - 2*self.fontOffset, self.alignment)
    end
  end
  
  
  for _, subelement in pairs(self.subelements) do
    if subelement.isText then
      love.graphics.setColor(self.colorFont1)
      love.graphics.printf(subelement.text, subelement.x, subelement.y, self.width2 - 2*self.offset, subelement.alignment or 'left')
    else
      subelement:render()
    end
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
  --if self.icon then
    --local iconScale = 10
    --love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.draw(gTextures['icons'], gFrames['icons'][approachesIcon[self.approach]], self.x + self.width/2 - 10*iconScale/2, self.y + self.height/2 - 10*iconScale/2, 0, iconScale, iconScale)
    --gTextures['icons'], gFrames['icons'][statusIcon[status]]
  --end
  
  --[[
  if self.shadow then
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 10*scale, 10*scale)
  end
]]
end