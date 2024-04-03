--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid
    
    self.pickable = def.pickable

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end
    self.onDestroy = function() end
    
    self.consumed = false
    self.picked = false
    self.shadow = false
    self.thrown = false
    self.destroyed = false
    self.pieces = {}
    self.magnetic = def.magnetic or false
    
    
end

function GameObject:update(dt)
  if self.thrown and not self.destroyed then
    self.airOffset = 13 - self.airOffsetReducerSqrt^2
    
    self.distanceThrownX = self.distanceThrownX + self.dx*dt
    self.distanceThrownY = self.distanceThrownY + self.dy*dt
    
    self.x = math.floor(self.throwX + self.distanceThrownX)
    self.y = math.floor(self.throwY + self.distanceThrownY + (13 - self.airOffset))
  end
  
  if self.destroyed and #self.pieces > 0 then
    self.piecesGravity = math.max(0, self.piecesGravity - 400*dt)
    for i, piece in ipairs(self.pieces) do
      
      
      piece.dy = piece.dy + self.piecesGravity*dt
      
      piece.x = piece.x + piece.dx*dt
      piece.y = piece.y + piece.dy*dt
      
      local margin = 34
      local marginOffset = 10
      
      if piece.y > VIRTUAL_HEIGHT - margin - marginOffset then
        piece.y = VIRTUAL_HEIGHT - margin - marginOffset
      elseif piece.y < margin - marginOffset then
        piece.y = margin - marginOffset
      end
      
      if piece.x > VIRTUAL_WIDTH - margin - marginOffset then
        piece.x = VIRTUAL_WIDTH - margin - marginOffset
      elseif piece.x < margin - marginOffset then
        piece.x = margin - marginOffset
      end

    end
    
  end

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if self.shadow and (not self.destroyed) then
      love.graphics.setColor(0,0,0,0.3)
      love.graphics.ellipse('fill', self.x + adjacentOffsetX + 0.5*self.width, self.y + adjacentOffsetY + 0.8*self.height + self.airOffset, 8, 4)
      love.graphics.setColor(1,1,1,1)
    end
    
  if not self.destroyed then
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame], self.x + adjacentOffsetX, self.y + adjacentOffsetY)
  elseif #self.pieces > 0 then
    for i, piece in ipairs(self.pieces) do
      local sprite = gTextures['potpieces']
      local frame = gFrames['potpieces'][i]
      sprite:setFilter("nearest", "nearest")
      love.graphics.draw(sprite, frame, piece.x + adjacentOffsetX, piece.y + adjacentOffsetY)
    end
  end

end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:isClose(target)
  local extraDistance = 12
    return not (self.x + extraDistance + self.width < target.x or self.x - extraDistance > target.x + target.width or
                self.y + extraDistance + self.height < target.y or self.y - extraDistance > target.y + target.height)
end

function GameObject:throw(direction)
  self.solid = true
  self.picked = false
  self.throwX = self.x
  self.throwY = self.y
  self.throwDirection = direction
  
  local throwSpeed = 256
  if direction == 'up' then
    self.dxStart = 0
    self.dyStart = -throwSpeed
  elseif direction == 'down' then
    self.dxStart = 0
    self.dyStart = throwSpeed
  elseif direction == 'left' then
    self.dxStart = -throwSpeed
    self.dyStart = 0
  elseif direction == 'right' then
    self.dxStart = throwSpeed
    self.dyStart = 0
  end
  
  self.dx = self.dxStart
  self.dy = self.dyStart
  
  self.thrown = true
  self.airOffset = 13
  self.airOffsetReducerSqrt = 0
  self.distanceThrownX = 0
  self.distanceThrownY = 0
  

  Timer.after(0.2,
        function ()
          Timer.after(0.1,
            function ()
              if not self.destroyed then
                self:destroy('ground')
              end
            end)
          Timer.tween(0.1,{
              [self] = {airOffsetReducerSqrt = math.sqrt(13)},
              })
        end)
  
end

function GameObject:destroy(cause)
  self.solid = false
  self.thrown = false
  self.destroyed = true
  
  self.piecesGravity = 800
  
  self:onDestroy()
  

  for i = 1, 6 do

    self.pieces[i] = {
      x = self.x,
      y = self.y,
      dx = math.random(-40, 40),
      dy = math.random(-140, -120)
    }
    
    local reduceImpact = 5
    if cause == 'ground' then
      -- x always follows direction
      self.pieces[i].dx = self.pieces[i].dx + self.dxStart/reduceImpact
      self.pieces[i].dy = self.pieces[i].dy + self.dyStart/reduceImpact
    elseif cause == 'wall' then
      -- small random x contrary to wall, random y
      self.pieces[i].dx = self.pieces[i].dx + randomSign(self.dyStart)/reduceImpact - self.dxStart/reduceImpact
      self.pieces[i].dy = self.pieces[i].dy + randomSign(self.dxStart)/reduceImpact - self.dyStart/reduceImpact
    elseif cause == 'enemy' then
      -- small random x, random y
      self.pieces[i].dx = self.pieces[i].dx + randomSign(self.dyStart)/reduceImpact
      self.pieces[i].dy = self.pieces[i].dy + randomSign(self.dxStart)/reduceImpact
    end
    
    
    Timer.after(math.random(20, 40)/100,
      function ()
          for i = 1, #self.soundPiece do
            self.soundPiece[i]:stop()
          end
          
          self.soundPiece[math.random(#self.soundPiece)]:play()
          self.pieces[i].dy = self.pieces[i].dy - 200
        
      end)
    Timer.after(0.6,
      function ()
          for i = 1, #self.soundPiece do
            self.soundPiece[i]:stop()
          end
          self.soundPiece[math.random(#self.soundPiece)]:play()
          self.pieces[i].dy = 0
          self.pieces[i].dx = 0

      end)

  end

  Timer.after(0.6,
        function ()
          self.piecesGravity = 0
        end)
      
  Timer.after(1,
        function ()
          self.pieces = {}
        end)

end
