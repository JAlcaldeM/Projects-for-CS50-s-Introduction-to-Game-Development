PlayerCrouchState = Class{__includes = BaseState}

function PlayerCrouchState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {4},
        interval = 1
    }

    self.player.currentAnimation = self.animation
    
    gSounds['jumpcharging']:play()
    
end

function PlayerCrouchState:update(dt)
  
    
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y + self.player.height)
    
    self.player.y = self.player.y + 1

    local collidedObjects = self.player:checkObjectCollisions()

    self.player.y = self.player.y - 1
  
    
    if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
      self.player.dy = 0
      self.player:changeState('falling')
    end 
    

    self.player.timeCrouchY = self.player.timeCrouchY + dt
    
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
      self.player.timeCrouchX = self.player.timeCrouchX + dt
    end
    
    if love.keyboard.wasPressed('left') then
      self.player.direction = 'left'
    elseif love.keyboard.wasPressed('right') then
      self.player.direction = 'right'
    end
  
    if self.player.timeCrouchY > self.player.maxTimeCrouch then
      gSounds['jumpcharging']:stop()
    end
    
    
    if love.keyboard.wasReleased('space') then
      self.player.jumping = false
      gSounds['jumpcharging']:stop()
      self.player:changeState('jump')
    end
    
    self.player.movespeed = math.max(0, math.abs(self.player.movespeed) - PLAYER_FRICTION * dt) * sign(self.player.movespeed)
    self.player.x = self.player.x + self.player.movespeed * dt
    
    if self.player.movespeed > 0 then
      self.player:checkRightCollisions(dt)
    elseif self.player.movespeed < 0 then
      self.player:checkLeftCollisions(dt)
    end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['jumpcharging']:stop()
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end
end