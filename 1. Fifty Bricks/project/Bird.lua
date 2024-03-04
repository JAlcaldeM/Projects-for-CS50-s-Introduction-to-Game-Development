--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 20 

local BIRD_IMAGE1 = love.graphics.newImage('bird.png')
local BIRD_IMAGE2 = love.graphics.newImage('bird2.png')
local BIRD_IMAGE3 = love.graphics.newImage('bird3.png')
local BIRD_IMAGE4 = love.graphics.newImage('bird4.png')
local BIRD_IMAGE5 = love.graphics.newImage('bird5.png')

function Bird:init(mode)
  
  self.dy = 0
  
  self.oldMode = mode
  
  self.x = VIRTUAL_WIDTH / 2 - 8
  self.y = VIRTUAL_HEIGHT / 2 - 8
  
  self:birdAppearance(mode)
  
  self.death = false
end

function Bird:birdAppearance(mode)
  print('birdappearance mode: ' .. tostring(mode))
  if mode == 1 then
      self.image = BIRD_IMAGE1
      self.gravMultiplier = 1
      self.jumpForce = -5
      speedMultiplyer = 1
    elseif mode == 2 then
      self.image = BIRD_IMAGE2
      self.gravMultiplier = 1
      self.jumpForce = -5
      speedMultiplyer = 2.2
    elseif mode == 3 then
      self.image = BIRD_IMAGE3
      self.gravMultiplier = 0.15
      self.jumpForce = -1.5
      speedMultiplyer = 1.6
    elseif mode == 4 then
      self.image = BIRD_IMAGE4
      self.gravMultiplier = 1.8
      self.jumpForce = -8
      speedMultiplyer = 0.6
    elseif mode == 5 then
      self.image = BIRD_IMAGE5
      self.gravMultiplier = 1.4
      self.jumpForce = -4
      speedMultiplyer = 0.65
    end

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    
    BIRD_WIDTH =  self.width
    BIRD_HEIGHT = self.height
    
    self.dy = 0
    
    
  
    self.y = self.y - (self.height - self.oldMode)
    
    self.oldMode = mode

end


--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 3) + (self.width - 6) >= pipe.x and self.x + 3 <= pipe.x + pipe.width then
        if (self.y + 3) + (self.height - 6) >= pipe.y and self.y + 3 <= pipe.y + pipe.height then
            return true
        end
    end

    return false
end
 

function Bird:update(dt)
    self:jump()
  
    self.dy = self.dy + GRAVITY * self.gravMultiplier * dt
    self.y = self.y + self.dy
    
    if self.y < 0 then
      self.y = 0
    elseif self.y > (VIRTUAL_HEIGHT - self.height - 16) then
      self.y = VIRTUAL_HEIGHT - self.height - 16
    end
    
end

function Bird:jump()
  if self.death == true then
    return
  end
  -- burst of anti-gravity when space or left mouse are pressed
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = self.jumpForce
        sounds['jump']:play()
    end
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
