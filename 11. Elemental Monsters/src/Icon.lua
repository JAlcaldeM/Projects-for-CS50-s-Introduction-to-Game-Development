Icon = Class{}

function Icon:init(def)
  self.x = def.x
  self.y = def.y
  self.y0 = self.y
  self.scale = def.scale or 10
  self.iconNumber = def.iconNumber
  self.iconNumber0 = self.iconNumber
  self.onClick = def.onClick or function() end
  self.onHover = def.onClick or function() end

end

function Icon:mouseIsOver(xMouse, yMouse)
    return (xMouse > self.x and xMouse < self.x + 10*self.scale and yMouse > self.y and yMouse < self.y + 10*self.scale)
end


function Icon:render()
  --local iconScale = 10
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures['icons'], gFrames['icons'][self.iconNumber], self.x, self.y, 0, self.scale, self.scale)
end