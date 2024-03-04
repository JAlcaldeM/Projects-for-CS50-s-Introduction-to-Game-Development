--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    
    -- table to assign adjacent colors
    self.adj = {}
    
    
    -- decide if shiny
    local shinyChance = 10
    if math.random(100) <= shinyChance then
      self.shiny = true
    else
      self.shiny = false
    end
    
    self.shineWidth = 10
    self.shineVPos = 0
    self.shiningAlpha = 0.8
    
    self.matched = false
    
end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
      
    -- draw if shiny
    if self.shiny then

      local function myStencilFunction()
        love.graphics.rectangle("fill", self.x + x, self.y + y, 32, 32, 8, 8)
      end
      love.graphics.stencil(myStencilFunction, "replace", 1)
      love.graphics.setStencilTest("greater", 0)
      love.graphics.setLineWidth(3)
      love.graphics.setColor(1,1,1,self.shiningAlpha)
      love.graphics.rectangle("line", self.x + x, self.y + y, 32, 32, 8, 8)
      love.graphics.setColor(1,1,1,self.shiningAlpha)
      love.graphics.push()
      love.graphics.translate(self.x+x-30, self.y+y-30)
      love.graphics.rotate(7*math.pi/4)
      love.graphics.rectangle('fill', -50, self.shineVPos -self.shineWidth/2, 100, self.shineWidth)
      love.graphics.pop()
      love.graphics.setStencilTest()
      
      if self.shineVPos == 100 then
        self.shineVPos = 0
      end
      

    end
      
end