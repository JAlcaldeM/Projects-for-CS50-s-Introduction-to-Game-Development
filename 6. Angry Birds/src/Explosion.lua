Explosion = Class{}

function Explosion:init(level, x, y, r, force)

  self.level = level
  self.world = self.level.world
  self.force = force
  self.x = x
  self.y = y
  self.r = r
  
  self.type = 'Explosion'
  
  self.r = r
  self.rVisual = 0
  self.opacity = 1
  Timer.tween(0.3, {
      [self] = {rVisual = 0.8*self.r , opacity = 0}
      })
  
  self.body = love.physics.newBody(self.world, self.x, self.y, 'dynamic')
  self.shape = love.physics.newCircleShape(self.r)
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  
  self.visible = true
  Timer.after(1, function()
      self.visible = false
      end)
  
  
  for _, body in ipairs(self.world:getBodies()) do
        local bodyX, bodyY = body:getPosition()
        local distance = math.sqrt((x - bodyX)^2 + (y - bodyY)^2)
        if distance < r then
            local forceX = (bodyX - x) * force
            local forceY = (bodyY - y) * force
            body:applyLinearImpulse(forceX, forceY, x, y)
        end
    end
  
  self.body:destroy()
  
  gSounds['explosion'][math.random(#gSounds['explosion'])]:play()
  
end

function Explosion:render()
  -- draw explosion
  if self.visible then
    love.graphics.setColor(1,1,1, self.opacity)
    love.graphics.circle("fill", self.x, self.y, self.rVisual)
  end
end
