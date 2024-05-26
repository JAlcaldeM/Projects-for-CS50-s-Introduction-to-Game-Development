StatusBar = Class{}

function StatusBar:init(def)
    self.x = def.x
    self.y = def.y
    self.size = def.size
    
    self.offset = 5*scale
    
    self.monster = def.monster
    self.monster.statusBar = self
    
    --[[
    self.canvas = love.graphics.newCanvas(100, 100)
    
    love.graphics.setCanvas(self.canvas)
      love.graphics.setColor(palette[1])
      love.graphics.rectangle('fill', 0, 0, 100, 100)
    love.graphics.setCanvas()
    ]]

end

function StatusBar:update()
  
end

function StatusBar:render()
--[[
  for i = #self.monster.statusList, 1, -1 do
    local statusName = self.monster.statusList[i]
    local statusInfo = self.monster.status[statusName]
    local icon = statusIcon[statusName]
    local upscale = 5
    local nOffset = (i-1)*(self.size + self.offset)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(gTextures['icons'], gFrames['icons'][icon], self.x + nOffset, self.y, 0, upscale, upscale)

    love.graphics.setColor(0,0,0,1)

    local function myStencilFunction()
      love.graphics.rectangle("fill", self.x + nOffset, self.y, self.size, self.size)
    end
    love.graphics.stencil(myStencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    
    love.graphics.setLineStyle('rough')
    love.graphics.setLineWidth(3)
    love.graphics.line(self.x + nOffset + self.size/2, self.y + self.size/2, self.x + nOffset + self.size/2, self.y)
    local x = self.x + nOffset + self.size/2 + math.sin(statusInfo.radians)*self.size
    local y = self.y + self.size/2 - math.cos(statusInfo.radians)*self.size
    love.graphics.line(self.x + nOffset + self.size/2, self.y + self.size/2, x, y)
    
    love.graphics.setStencilTest()
  end
  ]]
  --[[
  for i = #self.monster.statusList, 1, -1 do
    local statusName = self.monster.statusList[i]
    local statusInfo = self.monster.status[statusName]
    local icon = statusIcon[statusName]
    local upscale = 5
    local nOffset = (i-1)*(self.size + self.offset)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(gTextures['icons'], gFrames['icons'][icon], self.x + nOffset, self.y, 0, upscale, upscale)
    
   
    love.graphics.setColor(0,0,0,1)
    love.graphics.push()
    love.graphics.translate(self.x + nOffset + self.size/2, self.y + self.size/2)
    love.graphics.scale(upscale,upscale)
    
    local function myStencilFunction()
      love.graphics.rectangle("fill", -self.size/2/upscale, -self.size/2/upscale, self.size/upscale, self.size/upscale)
    end
    love.graphics.stencil(myStencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    
    love.graphics.setLineStyle('rough')
    love.graphics.setLineWidth(1.5)
    love.graphics.line(0, 1, 0, -self.size/2)

    local x = math.sin(statusInfo.radians)*10
    local y = - math.cos(statusInfo.radians)*10
    love.graphics.line(0, 0, x, y)
    love.graphics.pop()
    love.graphics.setStencilTest()
    
  end
  ]]
  
  
  

  for i = #self.monster.statusList, 1, -1 do
    local statusName = self.monster.statusList[i]
    local statusInfo = self.monster.status[statusName]
    local icon = statusIcon[statusName]
    local upscale = 5
    local nOffset = (i-1)*(self.size + self.offset)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(gTextures['icons'], gFrames['icons'][icon], self.x + nOffset, self.y, 0, upscale, upscale)
    --if statusInfo.capped == nil then
    if (statusInfo.counter == nil) or (statusInfo.counter < self.monster.counterLimit) then
      local timeIcon = 326 + math.floor(16*statusInfo.radians/(2*math.pi))
      love.graphics.draw(gTextures['icons'], gFrames['icons'][timeIcon], self.x + nOffset, self.y, 0, upscale, upscale)
    end
    local counter = self.monster.status[statusName].counter
    if counter then
      love.graphics.draw(gTextures['icons'], gFrames['icons'][356+counter], self.x + nOffset, self.y, 0, upscale, upscale)
    end
  end

  
  
  
  
--[[
  love.graphics.setLineStyle('rough')
  love.graphics.setLineWidth(1.5)
  local upscale = 5
  for i = #self.monster.statusList, 1, -1 do
    local statusName = self.monster.statusList[i]
    local statusInfo = self.monster.status[statusName]
    
    local nOffset = (i-1)*(self.size + self.offset)
    local icon = statusIcon[statusName]

    local canvas = love.graphics.newCanvas(10, 10)
    
    love.graphics.setCanvas(canvas)
      love.graphics.setColor(palette[2])
      love.graphics.draw(gTextures['icons'], gFrames['icons'][icon], 0, 0)
      love.graphics.setColor(palette[1])
      love.graphics.line(5.5, 5.5, 5.5, 0)
      local x = 5.5 + math.sin(statusInfo.radians)*10
      local y = 5.5 - math.cos(statusInfo.radians)*10
      love.graphics.line(5.5, 5.5, x, y)
    love.graphics.setCanvas()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(canvas, self.x + nOffset,self.y, 0, upscale, upscale)
  end
]]
  
  
  
  
  
end