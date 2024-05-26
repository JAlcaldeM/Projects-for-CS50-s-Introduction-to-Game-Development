MonsterMind = Class{}

function MonsterMind:init(def)
    self.x = def.x
    
    self.y = def.y
    self.y0 = def.y
    self.size = def.size
    
    self.offset = 5*scale
    
    
    self.approaches = {}

end

function MonsterMind:update()
  
end

function MonsterMind:render()
  for i, approach in ipairs(self.approaches) do
    love.graphics.setColor(1,1,1,1)
    --love.graphics.draw(gTextures['icons'], gFrames['icons'][approachesIcon[approach]], self.x + (i-1)*(self.size + self.offset), self.y, 0, 5, 5)
    love.graphics.draw(gTextures['icons'], gFrames['icons'][approachesIcon[approach]], self.x, self.y + (i-1)*(self.size + self.offset), 0, 5, 5)
  end
end