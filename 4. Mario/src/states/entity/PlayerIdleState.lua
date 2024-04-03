--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
    
end

function PlayerIdleState:update(dt)
  
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)
  
    self.player.y = self.player.y + 1

    local collidedObjects = self.player:checkObjectCollisions()

    self.player.y = self.player.y - 1
  
    if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
      self.player.dy = 0
      self.player:changeState('falling')
    end
    
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
      self.player.jumping = true
      self.player:changeState('crouch')
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
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end
end