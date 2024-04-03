--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    An Obstacle is any physics-based construction that forms the current level,
    usually shielding the aliens the player is trying to kill; they can form houses,
    boxes, anything the developer wishes. Depending on what kind they are, they are
    typically rectangular or polygonal.
]]

Obstacle = Class{}

function Obstacle:init(world, material, shape, x, y, sizeModifier)
    self.shape = shape
    self.health = 3
    self.material = material
    --self.impulseLimit = impulseLimitMaterials[self.material]
    --self.impulseLimit = 10000
    self.type = 'Obstacle'
    --print(self.shape, self.health)
    
    self.sizeModifier = sizeModifier or 1

    self.startX = x
    self.startY = y

    self.world = world

    self.body = love.physics.newBody(self.world, self.startX or math.random(VIRTUAL_WIDTH), self.startY or math.random(VIRTUAL_HEIGHT - 35), 'dynamic')

    self.texture = gFrames[material][shape]
    
    local xText, yText, widthText, heightText = self.texture[self.health]:getViewport()
    self.width, self.height = widthText*scale*self.sizeModifier, heightText*scale*self.sizeModifier
    
    --if self.original
    
    if self.shape == 'circle' then
      self.shapeFix = love.physics.newCircleShape(self.width/2)
    elseif self.shape == 'triangle' then
      self.shapeFix = love.physics.newPolygonShape(-self.width/2,self.height/2,0,-self.height/2, self.width/2, self.height/2) 
    else
      self.shapeFix = love.physics.newRectangleShape(self.width, self.height)
    end
    
    

    self.density = densityMaterials[self.material]
    
   
    
    self.fixture = love.physics.newFixture(self.body, self.shapeFix, self.density)
    
    self.impulseLimit = 2500*scale + 75*self.body:getMass()
    
    if self.material == 'explosive' then
      self.impulseLimit = 1000*scale
    end
    
    self.fixture:setRestitution(0.4)
    self.body:setAngularDamping(1)
    
    self.fixture:setUserData(self)
    
    self.recentlyDamaged = false
    
    self.isThrown = false
    self.hasCollided = false
    
    self.onDamage = function()
      print('i have been damaged!')
    end
    
    self.score = 50 * shapeToScore[self.shape] * materialToScore[self.material]
    self.showScore = false
end

function Obstacle:update(dt)

end

function Obstacle:render()
  love.graphics.setColor(1,1,1,1)
  if not self.body:isDestroyed() then
    love.graphics.draw(gTextures[self.material], self.texture[self.health], math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(), 1*scale*self.sizeModifier, 1*scale*self.sizeModifier, self.width/2/scale/self.sizeModifier, self.height/2/scale/self.sizeModifier)
    
    if self.framed then
      love.graphics.draw(gTextures[self.frame], gFrames[self.frame][self.shape..'frame'][math.max(2,self.health)], math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(), 1*scale*self.sizeModifier, 1*scale*self.sizeModifier, self.width/2/scale/self.sizeModifier, self.height/2/scale/self.sizeModifier)
    end
    
    if self.isThrown then
      love.graphics.setColor(1,1,1,0.6)
      love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(), 1*scale*self.sizeModifier, 1*scale*self.sizeModifier, 17.5, 17.5)
    end
    
    
  end
  
  
  drawBodyShape(self.body)
end