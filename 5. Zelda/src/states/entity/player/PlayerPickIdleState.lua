PlayerPickIdleState = Class{__includes = EntityIdleState}

function PlayerPickIdleState:enter(params)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    
    self.entity:changeAnimation('pickidle-' .. self.entity.direction)
end

function PlayerPickIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pickwalk')
    end

    if love.keyboard.wasPressed('e') then
        
        self.entity.objectPicked:throw(self.entity.direction)
        self.entity.objectPicked = nil
        self.entity:changeState('idle')
    end
end