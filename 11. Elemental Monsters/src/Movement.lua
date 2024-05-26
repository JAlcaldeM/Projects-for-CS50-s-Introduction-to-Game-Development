Movement = Class{}

function Movement:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.color = def.color or colors.grey
    
    self.offsetBorder = 3*scale
    self.offsetText = self.offsetBorder + 10*scale
    
    self.name = def.name
    self.description = def.description
    
    self.SPRequirement = def.SPRequirement
    self.approachRequirements = def.approachRequirements
 
    self.approachUI = MonsterMind{
      x = self.x + 220,
      y = self.y + self.offsetText + 65,
      size = 50
    }
 
    for i, approach in ipairs(approachNames) do
      local approachValue = self.approachRequirements[approach]
      if approachValue then
        for j = 1, approachValue do 
          table.insert(self.approachUI.approaches, approach)
        end
      end
    end

    --[[
    self.attacker = def.attacker
    self.defender = def.defender
    ]]

    self.onUse = def.onUse
end


function Movement:update()
  
end

function Movement:render()
 
  love.graphics.setColor(colors.black)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x + self.offsetBorder, self.y + self.offsetBorder, self.width - 2*self.offsetBorder, self.height - 2*self.offsetBorder)
  love.graphics.setColor(colors.white)
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf(self.name, self.x + self.offsetText, self.y + self.offsetText, self.width - 2*self.offsetBorder, 'center')
  love.graphics.setColor(colors.yellow)
  love.graphics.printf(self.SPRequirement..' SP', self.x + 2*self.offsetText, self.y + 2*self.offsetText + 50, self.width - 2*self.offsetBorder, 'left')
  
  --love.graphics.printf(, self.x + self.offsetText, self.y + self.offsetText + 100, self.width - 2*self.offsetBorder, 'center')
  love.graphics.setColor(colors.white)
  love.graphics.setFont(gFonts['small'])
  --love.graphics.printf('Deal '..self.damage..' damage', self.x + self.offsetText, self.y + self.offsetText + 150, self.width - 2*self.offsetBorder, 'center')
  love.graphics.printf(self.description, self.x + self.offsetText, self.y + self.offsetText + 150, self.width - 2*self.offsetBorder, 'center')
  self.approachUI:render()
end