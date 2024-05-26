Cell = Class{}

function Cell:init(params)
  self.chimera = params.chimera
  self.parent = params.parent
  self.name = params.name
  self.monsterOrgan = params.monsterOrgan
  -- x and y are the position relative to the center of the parent cell
  self.x0 = params.x
  self.y0 = params.y
  
  if self.parent == nil then
    self.x = self.x0
    self.y = self.y0
  else
    self.x = self.parent.xCenter + self.x0*self.parent.rx
    self.y = self.parent.yCenter + self.y0*self.parent.ry
  end
  
  --[[
  if self.name == 'head' or self.name == 'eye' or self.name == 'pupil' or self.name == 'ear' or self.name == 'mouth' or self.name == 'snout'then
    self.growthMult = (800 + 0.2*self.chimera.power)/1000--1
  else
    self.growthMult = (400 + self.chimera.power)/1000
  end
  ]]

  if self.monsterOrgan == 'head' then
    self.growthMult = (1000 + 0.2*self.chimera.power)/1500--1
  else
    self.growthMult = (500 + self.chimera.power)/1500
  end
  
  
  self.rx0 = params.rx*self.growthMult
  self.ry0 = params.ry*self.growthMult
  self.rx = self.rx0*sizeFactor
  self.ry = self.ry0*sizeFactor
  self.hJoint = params.hJoint
  self.xCenter = 0
  self.yCenter = -self.hJoint*self.ry
  self.ang = params.ang
  self.front = params.front
  self.shadow = params.shadow
  self.line = params.line
  self.color = params.color
  

  
  if not (self.parent == nil) then
    
    --local distanceToParent = math.sqrt(self.x^2 + self.y^2) / math.sqrt(self.parent.rx^2 + self.parent.ry^2) 
    self.shadowAng = math.atan2(self.x, - self.y) - self.ang
    --print(self.name,'self.shadowAng',self.shadowAng,'in ang:',math.deg(self.shadowAng))
    self.shadowX = shadowDistance * -math.sin(self.shadowAng) * (distanceToParent or 1)
    self.shadowY = shadowDistance * math.cos(self.shadowAng) * (distanceToParent or 1)
    --print(self.name,'shadowDistance x and y:',self.shadowX,self.shadowY)

    --[[
    math.atan2(0, 200) + math.pi
    math.atan2(50, -50) + math.pi
    
    self.shadowY = shadowDistance * -math.cos(self.shadowAng)
    print(math.cos(math.pi))
    ]]
  end
  
  
  
  
  self.parts = {}  
  
  
  if self.name == 'mouth' then
    self.open = false
  elseif self.name == 'snout' then
    
    local x1 = self.rx*0.4
    local x2 = self.rx*0.4
    
    local y1 = self.yCenter + self.ry*(25-math.random(-50, 50))/100
    local y2 = self.yCenter + self.ry*(25-math.random(-50, 50))/100
    local y3 = self.yCenter + self.ry*(25-math.random(-50, 50))/100
    
    self.nose1 = love.math.newBezierCurve( -x1 -x2, y1, -x1, y2, 0, y3)
    self.nose2 = love.math.newBezierCurve( x1 + x2, y1, x1, y2, 0, y3)
  elseif self.name == 'belly' then
    self.rx = self.rx0 * self.parent.rx
    self.ry = self.ry0 * self.parent.ry
  end
  
  
  
  
  -- start animations
  local animations = false
  if animations then
    if self.name == 'wing' then
      Timer.every(2, function()
          Timer.tween(1, {
                [self] = {ang = self.ang + math.pi}
              })
      end)
    end
  end

  

end

function Cell:update(dt)
  
  if self.name == 'mouth' then
    if mouthOpen and not self.open then
      self.snout.ry = self.snout.ry * 1/5
      self.snout.yCenter = self.snout.yCenter * 1/5
      --self.snout.ang = self.snout.ang + math.pi
      self.open = true
    elseif self.open and not mouthOpen then
      self.snout.ry = self.snout.ry * 5
      self.snout.yCenter = self.snout.yCenter * 5
      --self.snout.ang = self.snout.ang + math.pi
      self.open = false
    end
    
  end
  
  
  for _, part in pairs(self.parts) do
    part:update(dt)
  end
  
end


function Cell:render()
  
  self.transform = love.math.newTransform()
  self.transform:translate(self.x, self.y)
  self.transform:rotate(self.ang)
  self.inverse = self.transform:inverse()
  love.graphics.applyTransform(self.transform)
  
  for _, part in pairs(self.parts) do
    
    if self.chimera.frontalCamera == not part.front then
      part:render()
    end
  end
  
  if shadowsActive and self.shadow then
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(shadowColor)
    
    local dimensionalIncrement = shadowDistance
    
    if directionalShadow then

      if not (self.chimera.frontalCamera == self.front) or self.name == 'body' then
        love.graphics.ellipse('fill', self.xCenter, self.yCenter, self.rx + dimensionalIncrement, self.ry + dimensionalIncrement)
      else
        love.graphics.ellipse('fill', self.shadowX or 0, (self.shadowY or 0) + self.yCenter, self.rx, self.ry)
      end
      
      
      
    else
      love.graphics.ellipse('fill', self.xCenter, self.yCenter, self.rx + dimensionalIncrement, self.ry + dimensionalIncrement)
    end

    love.graphics.setStencilTest()

    local function myStencilFunction()
      love.graphics.ellipse('fill', self.xCenter, self.yCenter, self.rx, self.ry)
    end
    
    love.graphics.stencil(myStencilFunction, "replace", 1, true)
  end
  
  
  

  -- render the element
  if visible then
    
    love.graphics.setColor(self.color)
    love.graphics.ellipse('fill', self.xCenter, self.yCenter, self.rx, self.ry)
    
    if self.name == 'snout' and not self.parent.open and (not self.chimera.spriteParams.removeMouth) then
      love.graphics.setLineWidth(sizeFactor/10)
      love.graphics.setLineStyle('rough')
      love.graphics.setColor(black)
      love.graphics.line(self.nose1:render())
      love.graphics.line(self.nose2:render())
    end    
    
    if lines and self.line then
      love.graphics.setLineWidth(sizeFactor/10)
      love.graphics.setLineStyle('rough')
      love.graphics.setColor(black05)
      love.graphics.ellipse('line', self.xCenter, self.yCenter, self.rx - sizeFactor/20, self.ry - sizeFactor/20)
    end
    
    if points then
      love.graphics.setColor(black)
      love.graphics.circle('fill', 0, 0, sizeFactor/10)
    end
    
    
    
  end
  
  
  
  for _, part in pairs(self.parts) do
    if self.chimera.frontalCamera == part.front then
      part:render()
    end
  end

  
  love.graphics.applyTransform(self.inverse)
  
end
