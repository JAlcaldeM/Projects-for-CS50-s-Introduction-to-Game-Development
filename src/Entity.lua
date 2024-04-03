--[[
    GD50
    Super Mario Bros. Remake

    -- Entity Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def)
    -- position
    self.x = def.x
    self.y = def.y

    -- velocity
    self.dx = 0
    self.dy = 0

    -- dimensions
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.stateMachine = def.stateMachine

    self.direction = 'left'

    -- reference to tile map so we can check collisions
    self.map = def.map

    -- reference to level for tests against other entities + objects
    self.level = def.level
    
    self.bounce = def.bounce or false
    

end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:collides(entity)
    return not (self.x + 1 > entity.x + entity.width - 1 or entity.x + 1 > self.x + self.width - 1 or
                self.y + 1 > entity.y + entity.height - 1 or entity.y + 1 > self.y + self.height - 1)
end

function Entity:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1, 1, 8, 10)
end