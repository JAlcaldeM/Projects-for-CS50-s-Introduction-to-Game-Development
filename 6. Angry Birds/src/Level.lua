--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Level = Class{}

function Level:init(levelNumber, score, upgrades)
    self.levelNumber = levelNumber
    self.score = score
    self.upgrades = upgrades or {
      material = 0,
      size = 0,
      shape = 0,
      numberDivision = 0,
      sizeDivision = 0,
      explosiveDivision = 0,
      explosiveArea = 0,
      explosiveForce = 0,
      strengthThrow = 0,
      extraProjectile = 0
    }
    
    self.scores = {}
    self.nscores = 0
    
    self.ammo = 3 + self.upgrades.extraProjectile
    
    self.victory = false
    -- create a new "world" (where physics take place), with no x gravity
    -- and 30 units of Y gravity (for downward force)
    self.world = love.physics.newWorld(0, 150*scale)

    -- bodies we will destroy after the world update cycle; destroying these in the
    -- actual collision callbacks can cause stack overflow and other errors
    self.destroyedBodies = {}
    
    -- define collision callbacks for our world; the World object expects four,
    -- one for different stages of any given collision
    function beginContact(a, b, coll)
      
    end

    function endContact(a, b, coll)
        
    end

    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)
      
      local aEntity = a:getUserData()
      local bEntity = b:getUserData()
      
      local aDensity = a:getDensity()
      local bDensity = b:getDensity()
      
      if (aEntity.type == 'Obstacle' or aEntity.type == 'Alien') and (not aEntity.recentlyDamaged) and self.breakAllowed then
        local aImpulse = normalImpulse * (1 - aDensity/(aDensity+bDensity))
        self:damage(aEntity, aImpulse)
      end
      
      if (bEntity.type == 'Obstacle' or bEntity.type == 'Alien') and (not bEntity.recentlyDamaged) and self.breakAllowed then
        local bImpulse = normalImpulse * (1 - bDensity/(aDensity+bDensity))
        self:damage(bEntity, bImpulse)
      end
    end

    -- register just-defined functions as collision callbacks for world
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- shows alien before being launched and its trajectory arrow
    self.launchMarker = AlienLaunchMarker(self.world, self)

    -- aliens in our scene
    self.aliens = {}

    -- obstacles guarding aliens that we can destroy
    self.obstacles = {}
    
    self.explosions = {}
    self.newExplosions = {}
    self.projectiles = {}

    -- simple edge shape to represent collision for ground
    self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH * 3, 0)

--[[
    -- spawn an alien to try and destroy
    table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_WIDTH - 80*scale, VIRTUAL_HEIGHT - TILE_SIZE - ALIEN_SIZE / 2, 'Alien'))

    -- spawn a few obstacles
    table.insert(self.obstacles, Obstacle(self.world, 'wood', '13', VIRTUAL_WIDTH - 120*scale, VIRTUAL_HEIGHT + (- 35 - 110 / 2)*scale))
    table.insert(self.obstacles, Obstacle(self.world, 'wood', '13', VIRTUAL_WIDTH - 35*scale, VIRTUAL_HEIGHT + (- 35 - 110 / 2)*scale))
    table.insert(self.obstacles, Obstacle(self.world,'wood', '31', VIRTUAL_WIDTH - 80*scale, VIRTUAL_HEIGHT + (- 35 - 110 - 35 / 2)*scale))
    -- materialsList[math.random(#materialsList)]
    
    ]]
    
    generateObstacleSet(self, 0.5*VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 35*scale, self.levelNumber)
    
    --generateTestBox(self, 0.5*VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 35*scale, 4)
    
    -- ground data
    self.groundBody = love.physics.newBody(self.world, -VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 35*scale, 'static')
    self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape, 5)
    self.groundFixture:setFriction(0.5)
    self.groundFixture:setUserData({
        ['type'] = 'Ground'
    })
  
  

    -- background graphics
    self.background = Background()
    
    -- stop collisions from damaging objects for a small amount of time, to stop them breaking at load
    self.breakAllowed = false
    Timer.after(1, function()
      self.breakAllowed = true
    end)
end

function Level:update(dt)

    -- update launch marker, which shows trajectory
    self.launchMarker:update(dt)
    
    for _, projectile in pairs(self.projectiles) do
      if (not projectile.body:isDestroyed()) and (not projectile.hasCollided) then
        local xVel, yVel = projectile.body:getLinearVelocity()
        local angMovement = math.atan2(yVel, xVel)
        if math.cos(angMovement) < 0 then angMovement = angMovement + math.pi end
        projectile.body:setAngle(angMovement)
      end
    end
    

    -- Box2D world update code; resolves collisions and processes callbacks
    self.world:update(dt)
    
    for _, newExplosionParams in pairs(self.newExplosions) do
      local explosion = Explosion(unpack(newExplosionParams))
      table.insert(self.explosions, explosion)
    end
    self.newExplosions = {}

    -- destroy all bodies we calculated to destroy during the update call
    for k, body in pairs(self.destroyedBodies) do
        if not body:isDestroyed() then 
            body:destroy()
        end
    end

    -- reset destroyed bodies to empty table for next update phase
    self.destroyedBodies = {}

    -- remove all destroyed obstacles from level
    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].body:isDestroyed() then
            table.remove(self.obstacles, i)
        end
    end

    -- remove all destroyed aliens from level
    for i = #self.aliens, 1, -1 do
        if self.aliens[i].body:isDestroyed() then
            table.remove(self.aliens, i)
        end
    end


    -- replace launch marker if original alien stopped moving
    if self.launchMarker.launched then
      local allProjectilesOut = true
      local allProjectilesStop = true
      for _, projectile in pairs(self.projectiles) do
        local xPos, yPos, xVel, yVel, projectileSpeed = 0,0,0,0,0


        if not projectile.body:isDestroyed() then
          xPos, yPos = projectile.body:getPosition()
          xVel, yVel = projectile.body:getLinearVelocity()
          projectileSpeed = math.abs(xVel) + math.abs(yVel)
          
          if xPos > 0 - 17.5*scale*camSize and xPos < VIRTUAL_WIDTH + 17.5*scale*camSize then
            allProjectilesOut = false
            
            if projectileSpeed > 10*scale and (yPos < VIRTUAL_HEIGHT - 55*scale or projectileSpeed > 50*scale) then
              allProjectilesStop = false
            end
          end
        end
    end

        -- if we fired our alien to the left or it's almost done rolling, respawn
        if #self.aliens == 0 or allProjectilesOut or allProjectilesStop then
          Timer.after(1, function()
            local allObstaclesStop = true
            for _, obstacle in pairs(self.obstacles) do
              
              if (not obstacle.isThrown) and (not obstacle.body:isDestroyed()) then
                local xPos, yPos = obstacle.body:getPosition()
                local xVel, yVel = obstacle.body:getLinearVelocity()
                if xPos > 0 - 17.5*scale*camSize and xPos < VIRTUAL_WIDTH + 17.5*scale*camSize and math.abs(xVel) + math.abs(yVel) > 5*scale then
                  allObstaclesStop = false
                end
              end
            end
            if allObstaclesStop and (not self.newLauncher) then
              
              
              for _, projectile in pairs(self.projectiles) do
                if not projectile.body:isDestroyed() then
                  projectile.body:destroy()
                end
              end
              self:killOutsideAliens()
              -- re-initialize level if we have no more aliens
              self:checkVictory()
            end
          end)
        end
    end
end

function Level:checkVictory()
  if #self.aliens == 0 and not self.victory then
                  self.victory = true
                  local params = {
                      level = self,
                      upgrades = self.upgrades
                    }
                    
                    Timer.every(0.8, function()
                        if self.ammo > 0 then
                          self.ammo = self.ammo - 1
                          self.score = self.score + 1000
                          gSounds['1k']:play()
                        end
                    end)
                    :limit(self.ammo + 1)
                    :finish(function()
                        gStateMachine:change('upgrade',params)
                        end)
              elseif self.ammo == 0 and not self.victory and not self.gameOver then
                self.gameOver = true
                Timer.after(2, function()
                    gStateMachine:change('start')
                    end)
  elseif not self.victory and not self.gameOver then
    self.launchMarker = AlienLaunchMarker(self.world, self)
    self.playstate.levelTranslateX = 0
    self.newLauncher = true
    self.playstate.camLocked = false
  end
  
end

function Level:render()
    
    -- render ground tiles across full scrollable width of the screen
    for x = -VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2, 35*scale do
        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12], x, VIRTUAL_HEIGHT - 35*scale, 0, 1*scale, 1*scale)
    end

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    for k, obstacle in pairs(self.obstacles) do
        obstacle:render()
    end
    
    for k, explosion in pairs(self.explosions) do
        explosion:render()
    end
    
    for k, score in ipairs(self.scores) do
      if score.printable then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf(score.points, score.x - 500 +2*scale, score.y - 50*scale + 2*scale, 1000 + 2*scale, 'center')
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf(score.points, score.x - 500, score.y - 50*scale, 1000, 'center')
      end
    end

end

function Level:damage(entity, impulse)
  entity.hasCollided = true
  if impulse > entity.impulseLimit then
    
    entity.health = entity.health - 1
    entity.recentlyDamaged = true
    Timer.after(0.5, function()
      entity.recentlyDamaged = false
    end)
    
    if entity.health == 0 then
      local body = entity.fixture:getBody()
      if not entity.isThrown then
        local xPos, yPos = body:getPosition() 
        local scorePos = #self.scores + 1
        local points = entity.score
        table.insert(self.scores, {points = points, x = xPos, y = yPos, printable = true})
        Timer.after(1, function()
            self.scores[scorePos].printable = false
            self.score = self.score + points
            if points == 2000 then
              gSounds['2k']:play()
            else
              local scoreMult = math.floor(points/100)
              scoreMult = math.max(1, math.min(8, scoreMult))
              gSounds['score'][scoreMult]:play()
            end
            
            
          end)
      end
      
      
      table.insert(self.destroyedBodies, body)
      if entity.material == 'explosive' then
        local xPos, yPos = entity.body:getPosition()
        local density = entity.fixture:getDensity()
        local area = body:getMass()/density
        --local newExplosionParams = {self, xPos, yPos, 0.4*(100+body:getMass())*scale*(1+0.2*self.upgrades.explosiveArea), 2*(100+body:getMass())*(1+0.2*self.upgrades.explosiveForce)}
        local newExplosionParams = {self, xPos, yPos, 8*area*scale, 80*density}
        if entity.isThrown then
          newExplosionParams[4] = newExplosionParams[4]*(1+0.5*self.upgrades.explosiveArea)
          newExplosionParams[5] = newExplosionParams[5]*(1+0.5*self.upgrades.explosiveForce)
        end
        table.insert(self.newExplosions, newExplosionParams)
      end
    else
      local newImpulse = impulse - entity.impulseLimit
      self:damage(entity, newImpulse)
    end

   gSounds[entity.material][math.random(#gSounds[entity.material])]:play()

  end
end

function Level:killOutsideAliens()
  for _, alien in pairs(self.aliens) do
    if not alien.body:isDestroyed() then
      local xPos, yPos = alien.body:getPosition()
      if xPos < 0.25*VIRTUAL_WIDTH - 17.5*scale*camSize or xPos > 1.25*VIRTUAL_WIDTH + 17.5*scale*camSize then
        table.insert(self.destroyedBodies, alien.fixture:getBody())
      end
    end
  end
end
