ProgressBar = Class{}

function ProgressBar:init(def)
    self.x = def.x
    self.y = def.y
    
    self.width = def.width
    self.height = def.height
    
    self.color = def.color
    self.colorBackground = def.colorBackground or {r = 1, g = 1, b = 1}

    self.value = def.value
    self.max = def.max
    
    self.bars = def.bars or false
    self.border = def.border or false
    
    self.borderRadius = 0 --3*scale
    self.lineWidthExt = 5*scale
    self.lineWidthInt = 0 --5*scale
    self.lineColor = palette[2]
    
    self.partitions = def.partitions or false
    if self.partitions then
      self.partitionWidth = self.width / self.partitions
    end
    
    
    
    
end
--[[
function ProgressBar:setMax(max)
    self.max = max
end

function ProgressBar:setValue(value)
    self.value = value
end
]]

function ProgressBar:update()
  
end

function ProgressBar:render()
    local renderWidth = (self.value / self.max) * self.width
    
    love.graphics.setColor(self.colorBackground)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.borderRadius)

    love.graphics.setColor(self.color)
    
    if self.value > 0 then
      if not self.partitions then
        love.graphics.rectangle('fill', self.x, self.y, renderWidth, self.height, self.borderRadius)
      else
        local nPartitions = math.floor(self.value/self.max*self.partitions)
        love.graphics.rectangle('fill', self.x, self.y, nPartitions*self.partitionWidth, self.height, self.borderRadius)
      end
    end
    
    if self.border then
      love.graphics.setColor(self.lineColor)
      love.graphics.setLineWidth(self.lineWidthExt)
      love.graphics.rectangle('line', self.x, self.y, self.width, self.height, self.borderRadius)
    end
    
    
    
    if self.bars then
      for i = 1, (self.max - 1) do
        love.graphics.setColor(self.lineColor)
        love.graphics.setLineWidth(self.lineWidthInt)
        local xLine = self.x + i*(self.width/self.max)
        love.graphics.line(xLine, self.y, xLine, self.y + self.height)
      end
    end
    
    
end