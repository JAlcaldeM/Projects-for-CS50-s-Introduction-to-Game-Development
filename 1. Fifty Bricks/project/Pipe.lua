--[[
    Pipe Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Pipe class represents the pipes that randomly spawn in our game, which act as our primary obstacles.
    The pipes can stick out a random distance from the top or bottom of the screen. When the player collides
    with one of them, it's game over. Rather than our bird actually moving through the screen horizontally,
    the pipes themselves scroll through the game to give the illusion of player movement.
]]

Pipe = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local PIPE_IMAGE1 = love.graphics.newImage('pipe.png')
local PIPE_IMAGE2 = love.graphics.newImage('pipe2.png')
local PIPE_IMAGE3 = love.graphics.newImage('pipe3.png')
local PIPE_IMAGE4 = love.graphics.newImage('pipe4.png')
local PIPE_IMAGE5 = love.graphics.newImage('pipe5.png')

function Pipe:init(orientation, y, mode)

    if mode == 1 then
      self.PIPE_IMAGE = PIPE_IMAGE1
      GAP_HEIGHT = math.random(70, 110)
      heightRandomizer = 40
    elseif mode== 2 then
      self.PIPE_IMAGE = PIPE_IMAGE2
      GAP_HEIGHT = math.random(50, 60)
      heightRandomizer = 30
    elseif mode == 3 then
      self.PIPE_IMAGE = PIPE_IMAGE3
      GAP_HEIGHT = math.random(70, 80)
      heightRandomizer = 30
    elseif mode == 4 then
      self.PIPE_IMAGE = PIPE_IMAGE4
      GAP_HEIGHT = math.random(110, 120)
      heightRandomizer = 130
    elseif mode == 5 then
      self.PIPE_IMAGE = PIPE_IMAGE5
      GAP_HEIGHT = math.random(180, 190)
      heightRandomizer = 15
    end
    
    self.x = VIRTUAL_WIDTH + 64
    self.y = y

    self.width = self.PIPE_IMAGE:getWidth()
    self.height = 288

    self.orientation = orientation   
    
end

function Pipe:update(dt)
    
end

function Pipe:render()

    love.graphics.draw(self.PIPE_IMAGE, self.x, 

        -- shift pipe rendering down by its height if flipped vertically
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 

        -- scaling by -1 on a given axis flips (mirrors) the image on that axis
        0, 1, self.orientation == 'top' and -1 or 1)

end