--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
    self.player.currentAnimation = self.animation
    
end

function PlayerJumpState:enter(params)
    gSounds['jump']:play()
    
    if self.player.timeCrouchY == nil then
      self.player.timeCrouchY = 0
      self.player.timeCrouchX = 0
    end
    
    
    if self.player.timeCrouchY < 0.15 then
      self.player.timeCrouchY = 0
    elseif self.player.timeCrouchY > self.player.maxTimeCrouch then
      self.player.timeCrouchY = self.player.maxTimeCrouch
    end
    
    if self.player.bouncing then
      self.player.dy = -9*GRAVITY
      self.player.bouncing = false
    else
      self.player.dy =  (self.player.dy + math.max(PLAYER_JUMP_VELOCITY, PLAYER_JUMP_VELOCITY * 0.6 + PLAYER_JUMP_VELOCITY * 0.4 * self.player.timeCrouchY / self.player.maxTimeCrouch))*GRAVITY/15
      self.player.timeCrouchY = 0
    end

    if self.player.direction == 'right' then
      self.player.timeCrouchX = -self.player.timeCrouchX
    end
    
    local directionX = sign(self.player.timeCrouchX)
    self.player.movespeed = self.player.movespeed + directionX*math.max(PLAYER_JUMP_VELOCITY, PLAYER_JUMP_VELOCITY * 0.3 + PLAYER_JUMP_VELOCITY * 0.2 * math.min(self.player.maxTimeCrouch, math.abs(self.player.timeCrouchX)) / self.player.maxTimeCrouch)
    self.player.timeCrouchX = 0 
    
    
end

function PlayerJumpState:update(dt)
    self.player.currentAnimation:update(dt)
    self.player.dy = self.player.dy + self.gravity * dt * 60
    self.player.y = self.player.y + (self.player.dy * dt)

    -- go into the falling state when y velocity is positive
    if self.player.dy >= 0 then
        self.player:changeState('falling')
    end

    self.player.y = self.player.y + (self.player.dy * dt)

    -- look at two tiles above our head and check for collisions; 3 pixels of leeway for getting through gaps
    local tileLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y)
    local tileRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y)

    -- if we get a collision up top, go into the falling state immediately
    if (tileLeft and tileRight) and (tileLeft:collidable() or tileRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')

    -- else test our sides for blocks
  elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player.movespeed = math.max(-1.5*PLAYER_WALK_SPEED, self.player.movespeed - 0.7*PLAYER_ACCELERATION * dt)
        if math.abs(self.player.movespeed) < 5 then
          self.player.movespeed = -5
        end
        
        
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player.movespeed = math.min(1.5*PLAYER_WALK_SPEED, self.player.movespeed + 0.7*PLAYER_ACCELERATION * dt)
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
        if object:collides(self.player) then
          
          if object.collidable and object.flag then
                gSounds['victory']:play()
                  gStateMachine:change('play', {
                    previousScore = self.player.score,
                    currentLevel = self.player.playstate.currentLevel + 1,
                    timer = self.player.playstate.timer + 50
                    })
          end
          
          
          if object.collidable and not object.consumable then
            object.onCollide(object, self)
          end
          
            if object.solid then
              
                

                if object.pieces then
                  for i = 1, 4 do
                    table.insert(self.player.level.pieces, Piece(object.x, object.y, i, self.player.movespeed))
                  end
                  gSounds['crack']:play()
                  table.remove(self.player.level.objects, k)
                  
                end
                

                self.player.y = object.y + object.height
                self.player.dy = 0
                self.player:changeState('falling')
            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
                
            end
        end
    end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end
end