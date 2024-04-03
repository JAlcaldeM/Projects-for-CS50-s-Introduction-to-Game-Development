--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.pieces = def.pieces or false
    self.button = def.button or false
    self.locked = def.locked or false
    self.animated = def.animated or false
    self.flag = def.flag or false
    self.invisible = def.invisible or false
    self.pole = def.pole or false
    
    if self.animated then
      
      self.animation = Animation {
        frames = {self.frame*2-1, self.frame*2},
        interval = 0.5
    }
    self.currentAnimation = self.animation
    end
    
end

function GameObject:collides(target)
  
    return not (target.x + 1 > self.x + self.width - 1 or self.x + 1 > target.x + target.width - 1 or
            target.y > self.y + self.height or self.y > target.y + target.height )
end

function GameObject:update(dt)
    if self.animated then
      self.currentAnimation:update(dt)
    end
    
end

function GameObject:render()
  
  if self.invisible then
    return
  end
  
  if self.animated then
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], self.x, self.y)
  else
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
  end
    
end