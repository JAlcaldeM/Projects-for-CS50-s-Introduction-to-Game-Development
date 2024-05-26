Chimera = Class{}

function Chimera:init(x, y, frontalCameraSpawn, seed, sizeF, rescaleF, spriteParams)
  
  self.spriteParams = spriteParams or {}
  if self.spriteParams.removeShadows then
    shadowsActive = false
  else
    shadowsActive = true
  end
  self.power = self.spriteParams.power or 1000
  
  self.monster = self.spriteParams.monster
  
  self.canvasX = x
  self.canvasY = y

  self.x0 = 0
  self.y0 = 0
  --self.x = x*VIRTUAL_WIDTH
  --self.y = y*VIRTUAL_HEIGHT
  self.ang = 0
  
  
  self.canvasSize = 200
  
  self.parts = {}
  
  --self.frontalCamera = frontalCamera
  self.frontalCamera = frontalCameraSpawn
  
  if seed then
    self.seed = seed
  else
    self.seed = math.random(1, 2^40)
  end
  
  sizeFactor = sizeF or sizeFactor0
  shadowDistance = sizeFactor/5
  rescaleFactor = rescaleF or rescaleFactor0
  self.scale = rescaleFactor
  
  generateBody(self)

  generateName(self)
  
  self:generateCanvas()
  
end

function Chimera:update(dt)
  
  --[[
  if love.keyboard.wasPressed('c') then
    reverseParts(self)
  end
  ]]
  
  self.body:update(dt)
end


function Chimera:render()
  self.transform = love.math.newTransform()
  
  self.transform:rotate(self.ang)
  self.inverse = self.transform:inverse()

  love.graphics.applyTransform(self.transform)
  
  love.graphics.setColor(1,1,1,1)
  
  love.graphics.draw(self.canvas,self.canvasX - self.x*self.scale, self.canvasY - self.y*self.scale, 0, self.scale, self.scale)
  --print(self.canvasX - self.x*self.scale, self.canvasY - self.y*self.scale)
  --print(self.canvasX, self.canvasY, self.x, self.y)

  love.graphics.applyTransform(self.inverse)
  
end


function Chimera:generateCanvas()
  
  self.canvas = love.graphics.newCanvas(self.canvasSize, self.canvasSize)
  
  -- now, self.x and self.y are the movement that the starting point has in the canvas, so it must be substracted from the coordinates during the draw
  self.x = self.canvasSize/2
  self.y = self.canvasSize/2
  
  
  love.graphics.setCanvas({self.canvas, stencil = true})
  
    love.graphics.setColor(1,0,1,1)
    self.body:render()
  
  love.graphics.setCanvas()
  
  
  
  
end












function reverseParts(chimera)

  local newParts = {}
  for i = #chimera.parts, 1, -1 do
    local cell = chimera.parts[i]
    table.insert(newParts, cell)
  end
  chimera.parts = newParts
  
  for _, cell in pairs(chimera.parts) do
    reverseParts(cell)
  end

end
--[[
function changeAnimation(chimera, animation)
  
  if animation == 'default' then
    for _, cell in pairs(chimera.parts) do
      cell.ang = cell.startAng
    end
  else
    local newAnimation = animations[animation]
    for _, cell in pairs(chimera.parts) do
      cell.ang = newAnimation[cell.name]
      if cell.ang == nil then
        cell.ang = cell.startAng
      elseif not cell.chimera.frontalCamera then
        cell.ang = -cell.ang
      end
    end
  end

end
]]
function changeMouth(chimera)
  for _, cell in pairs(chimera.parts) do
    if cell.name == 'mouth' then
      local mouthSizeRatio = 0.8
      if not cell.open then
        cell.rx = cell.rx*mouthSizeRatio 
        cell.ry = cell.ry*mouthSizeRatio 
        cell.snout.ry = cell.snout.ry * 1/5
        cell.snout.yCenter = cell.snout.yCenter * 1/5
        cell.open = true
      else
        cell.rx = cell.rx/mouthSizeRatio 
        cell.ry = cell.ry/mouthSizeRatio 
        cell.snout.ry = cell.snout.ry * 5
        cell.snout.yCenter = cell.snout.yCenter * 5
        cell.open = false
      end
    end
  end
end