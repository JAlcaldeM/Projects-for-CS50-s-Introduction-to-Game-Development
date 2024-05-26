SpriteState = Class{__includes = BaseState}

function SpriteState:init()
  
  self.type = 'Sprite'

  --local spriteParams = {white = true, removeShadows = true, removeMouth = true}
  self.monster = Monster{}
  self.spriteParams = {power = 1000, monster = self.monster}
  
  
  self.front = true
  
  local chimera = Chimera(spawnX, spawnY, self.front, nil, 10, 8, self.spriteParams)
  table.insert(chimeras, chimera)
  self.seed = chimera.seed
  
  self.inverted = false
end


function SpriteState:update(dt)
  
  if love.keyboard.wasPressed('b') then
    chimeras = {}
    local params = {power = 1000, monster = self.monster, animation = 'defend', inverted = self.inverted}
    local chimera = Chimera(spawnX, spawnY, self.front, self.seed, 10, 8, params)
    table.insert(chimeras, chimera)
    self.inverted = not self.inverted
  end
  
  
  
  
  if love.keyboard.wasPressed('v') then
    visible = not visible
  elseif love.keyboard.wasPressed('l') then
    lines = not lines
  elseif love.keyboard.wasPressed('c') then
    for _, chimera in pairs(chimeras) do
      chimera.frontalCamera = not chimera.frontalCamera
    end
    frontalCamera = not frontalCamera
  elseif love.keyboard.wasPressed('s') then
    shadowsActive = not shadowsActive
  elseif love.keyboard.wasPressed('d') then
    directionalShadow = not directionalShadow
  elseif love.keyboard.wasPressed('m') then
    mouthOpen = not mouthOpen
  elseif love.keyboard.wasPressed('f') then
    local fullscreen = love.window.getFullscreen()
    love.window.setFullscreen(not fullscreen)
  elseif love.keyboard.wasPressed('p') then
    points = not points
  elseif love.keyboard.wasPressed('q') then
    self.growth = true
    Timer.after(0.5, function()
        self.growth = false
        end)
  elseif love.keyboard.wasPressed('r') then
    chimeras = {}
    local chimera = Chimera(spawnX, spawnY, self.front, nil, 10, 8, self.spriteParams)
    table.insert(chimeras, chimera)
    self.seed = chimera.seed
    --[[
  elseif love.keyboard.wasPressed('t') then
    local lowresModifier = nil
    if lowres then
      lowresModifier = 10
    else
      lowresModifier = 0.1
    end
    updateResolution(lowresModifier)
    lowres = not lowres
    ]]

  end
  
  
  if self.growth then
    chimeras = {}
    self.spriteParams.power = self.spriteParams.power + 200*dt
    local chimera = Chimera(spawnX, spawnY, true, self.seed, 10, 8, self.spriteParams)
    table.insert(chimeras, chimera)
  end
  
  
  
  
end



function SpriteState:render()
  -- sky
  love.graphics.setColor(0,1,1,1)
  --love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  -- grass
  love.graphics.setColor(0,1,0,1)
  --love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, VIRTUAL_HEIGHT/2)
  -- reduce brightness
  love.graphics.setColor(0,0,0,0.4)
  --love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  

  for _, chimera in pairs(chimeras) do
    chimera:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(chimera.name, 0, 3, VIRTUAL_WIDTH, "center")
  end

  -- after the render, we reset the stencil
  love.graphics.stencil(stencilClear, "replace", 0)
end


function stencilClear()
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end



