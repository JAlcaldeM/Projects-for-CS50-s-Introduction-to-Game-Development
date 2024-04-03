PlayerPickWalkState = Class{__includes = EntityWalkState}

function PlayerPickWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    
    self.entity:changeAnimation('pickwalk-' .. self.entity.direction)
end

function PlayerPickWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pickwalk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pickwalk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pickwalk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pickwalk-down')
    else
        self.entity:changeState('pickidle')
    end

    if love.keyboard.wasPressed('e') then
        
        self.entity.objectPicked:throw(self.entity.direction)
        self.entity.objectPicked = nil
        self.entity:changeState('idle')
    end
    

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

end