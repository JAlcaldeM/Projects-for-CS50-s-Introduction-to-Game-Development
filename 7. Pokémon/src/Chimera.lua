Chimera = Class{}

function Chimera:init(x, y, frontalCameraSpawn, scale, seed)
  self.x0 = x
  self.y0 = y
  self.x = x*VIRTUAL_WIDTH
  self.y = y*VIRTUAL_HEIGHT
  self.ang = 0
  self.scale = scale or 1
  
  self.visible = true
  self.shadow = true
  
  self.blink = false
  self.blinkColor = nil
  
  self.parts = {}

  self.frontalCamera = frontalCameraSpawn
  
  self.seed = seed or math.random(1, 2^40)  
  
  generateBody(self)

  generateName(self)

end

function Chimera:update(dt) 
  self.body:update(dt)
end


function Chimera:render()
  
  self.transform = love.math.newTransform()
  
  self.transform:translate(self.x, self.y)
  self.transform:scale(self.scale)
  self.transform:rotate(self.ang)
  self.inverse = self.transform:inverse()
  love.graphics.applyTransform(self.transform)
  
  self.body:render()

  love.graphics.applyTransform(self.inverse)
  
  love.graphics.stencil(stencilClear, "replace", 0)
  
end

