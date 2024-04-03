--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkingState = Class{__includes = BaseState}

function PlayerWalkingState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {10, 11},
        interval = 0.1
    }
    self.player.currentAnimation = self.animation
    
end

function PlayerWalkingState:update(dt)
    self.player.currentAnimation:update(dt)

    -- idle if we're not pressing anything at all
    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        self.player:changeState('idle')
    else
        local tileBottomLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y + self.player.height)
        local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y + self.player.height)

        -- temporarily shift player down a pixel to test for game objects beneath
        self.player.y = self.player.y + 1

        local collidedObjects = self.player:checkObjectCollisions()

        self.player.y = self.player.y - 1

        -- check to see whether there are any tiles beneath us
        if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
            self.player.dy = 0
            self.player:changeState('falling')
        elseif love.keyboard.isDown('left') then
            self.player.movespeed = math.max(-PLAYER_WALK_SPEED*0.7, self.player.movespeed - PLAYER_ACCELERATION * dt)
            self.player.direction = 'left'
        elseif love.keyboard.isDown('right') then
            self.player.movespeed = math.min(PLAYER_WALK_SPEED*0.7, self.player.movespeed + PLAYER_ACCELERATION * dt)
            self.player.direction = 'right'
            
        end
        
        -- we apply a fraction of the friction
        self.player.movespeed = math.max(0, math.abs(self.player.movespeed) - 0.5*PLAYER_FRICTION * dt) * sign(self.player.movespeed)
        
        self.player.x = self.player.x + self.player.movespeed * dt
        
        if self.player.movespeed > 0 then
          self.player:checkRightCollisions(dt)
        elseif self.player.movespeed < 0 then
          self.player:checkLeftCollisions(dt)
        end

  end
  
  for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) and object.collidable then
            if object.button then
                self.player.dy = -100
                object.frame = object.frame + 4
                object.collidable = false
            elseif object.locked and self.player.hasKey then
              gSounds['openlock']:play()
                table.remove(self.player.level.objects, k)
            elseif object.flag then
                gSounds['victory']:play()
                print('self.player.score:',self.player.score)
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
  
  
  
  

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end

    if love.keyboard.wasPressed('space') then
      self.player.jumping = true
      self.player:changeState('crouch')
    end
    
    
    
end