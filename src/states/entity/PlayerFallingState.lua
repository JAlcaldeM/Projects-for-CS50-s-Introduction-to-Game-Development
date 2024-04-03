--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerFallingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerFallingState = Class{__includes = BaseState}

function PlayerFallingState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
    self.player.currentAnimation = self.animation
    
end

function PlayerFallingState:update(dt)
  
  
    if love.keyboard.isDown('space') then
      self.animation.frames = {4}
    else
      self.animation.frames = {3}
    end
    
    
    self.player.currentAnimation:update(dt)
    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)
    
    
    

    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y + self.player.height)

    -- if we get a collision beneath us, go into either walking or idle
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        self.player.dy = 0
        
        if love.keyboard.isDown('space') then
            self.player:changeState('crouch')
        elseif love.keyboard.isDown('left') or love.keyboard.isDown('right') then
            gSounds['jumpcharging']:stop()
            self.player:changeState('walking')
        else
            gSounds['jumpcharging']:stop()
            self.player:changeState('idle')
        end

        self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height
    
    -- go back to start if we fall below the map boundary
    elseif self.player.y > VIRTUAL_HEIGHT then
        gSounds['death']:play()
        gStateMachine:change('start')
    
    -- check side collisions and reset position
    elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player.movespeed = math.max(-1*PLAYER_WALK_SPEED, self.player.movespeed - 0.7*PLAYER_ACCELERATION * dt)
        if math.abs(self.player.movespeed) < 5 then
          self.player.movespeed = -5
        end
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player.movespeed = math.min(1*PLAYER_WALK_SPEED, self.player.movespeed + 0.7*PLAYER_ACCELERATION * dt)
        if math.abs(self.player.movespeed) < 5 then
          self.player.movespeed = 5
        end
    end
    
    self.player.x = self.player.x + self.player.movespeed * dt
    
    
    if self.player.movespeed > 0 then
      self.player:checkRightCollisions(dt)
    elseif self.player.movespeed < 0 then
      self.player:checkLeftCollisions(dt)
    end
    

    -- check if we've collided with any collidable game objects
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) and object.collidable then
          
            if object.button then

                self.player.dy = -100
                object.frame = object.frame + 4
                object.collidable = false
                gSounds['dong']:play()
                self.player.seesFlag = true
                
                self.player.playstate.secondWave = true
                
                for _, object in pairs(self.player.level.objects) do
                  if object.flag then
                    object.invisible = false
                    if object.pole then
                      object.collidable = true
                    end
                    
                    
                  end
                end
                
                
            elseif object.locked and self.player.hasKey then
              gSounds['openlock']:play()
                table.remove(self.player.level.objects, k)
            elseif object.flag then
                gSounds['victory']:play()
                gStateMachine:change('play', {
                  previousScore = self.player.score,
                  currentLevel = self.player.playstate.currentLevel + 1,
                  timer = self.player.playstate.timer + 50
                  })
            elseif object.solid then
                self.player.dy = 0
                self.player.y = object.y - self.player.height

                
                if love.keyboard.isDown('space') then
                    self.player:changeState('crouch')
                elseif love.keyboard.isDown('left') or love.keyboard.isDown('right') then
                    self.player:changeState('walking')
                else
                    self.player:changeState('idle')
                end
            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
    end

    -- check if we've collided with any entities and kill them if so
    for k, entity in pairs(self.player.level.entities) do
      
        if entity:collides(self.player) then
          
            if entity.bounce then
              self.player.bouncing = true
              self.player:changeState('jump')
            end
            
            gSounds['kill']:play()
            gSounds['kill2']:play()
            self.player.score = self.player.score + 100
            table.remove(self.player.level.entities, k)
        end
    end
end