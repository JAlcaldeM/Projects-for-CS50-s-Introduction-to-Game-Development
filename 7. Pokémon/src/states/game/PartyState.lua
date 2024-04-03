PartyState = Class{__includes = BaseState}

function PartyState:init(party, battle)
  self.type = 'Party'
  self.party = party
  
  self.over = 1
  self.selected = false
  self.overBack = false
  self.overPrevious = nil
  
  self.battle = battle or false
  
  self.chimeras = {}
  
  self.slotLength = 160
  self.slotHeight = 30

  for i = 1, #self.party.pokemon do
    self:generateSpriteAndBar(i)    
  end
    
end

function PartyState:update(dt)
    if love.keyboard.wasPressed('up') then
      if not self.overBack and not (self.over == 1) then
        self.over = self.over - 1
        gSounds['blip']:play()
      else
        gSounds['nope']:play()
      end
    elseif love.keyboard.wasPressed('down') then
      if not self.overBack and not (self.over == #self.party.pokemon) then
        self.over = self.over + 1
        gSounds['blip']:play()
      else
        gSounds['nope']:play()
      end
    elseif love.keyboard.wasPressed('backspace') or love.keyboard.wasPressed('escape') then
      if self.battle then
        gSounds['nope']:play()
      else
        self:back()
        gSounds['back']:play()
      end
    elseif love.keyboard.wasPressed('left') then
      if self.overBack and (not self.battle) then
        self.overBack = false
        self.over = self.overPrevious
        self.overPrevious = nil
        gSounds['blip']:play()
      else
        gSounds['nope']:play()
      end
    elseif love.keyboard.wasPressed('right') then
      if not self.overBack and (not self.battle) then
        self.overBack = true
        self.overPrevious = self.over
        self.over = nil
        gSounds['blip']:play()
      else
        gSounds['nope']:play()
      end
    elseif love.keyboard.wasPressed('space') or love.keyboard.wasPressed('e') or love.keyboard.wasPressed('return') then
      if self.battle and self.party.pokemon[self.over].currentHP == 0 then
        gSounds['nope']:play()
      elseif self.battle and self.party.pokemon[self.over].currentHP > 0 then
        self:back()
        gSounds['ok']:play()
      elseif self.overBack then
        self:back()
        gSounds['back']:play()
      else
        if not self.selected then
          self.selected = self.over
          gSounds['ok']:play()
        elseif self.selected == self.over then
          self.selected = false
          gSounds['back']:play()
        else
          self:swapPositions(self.over, self.selected)
          gSounds['swap']:play()
        end
        
      end
    end
    
    

end

function PartyState:render()

    love.graphics.setColor(0.6, 0.6, 0, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    local squareRadius = 10
    local slotLength = self.slotLength
    local slotHeight = self.slotHeight
    
    if not self.battle then
      --back button
      love.graphics.setColor(0, 0.2, 0.4, 1)
      love.graphics.rectangle('fill', VIRTUAL_WIDTH - 55, VIRTUAL_HEIGHT - 25, 50, 20, squareRadius, squareRadius)
      love.graphics.setColor(0.2, 0.8, 0.8, 1)
      love.graphics.setFont(gFonts['medium'])
      love.graphics.print('BACK', VIRTUAL_WIDTH - 48, VIRTUAL_HEIGHT - 22)
    end
    
    
    
    if self.overBack then
      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.setLineWidth(3)
      love.graphics.setLineStyle('rough')
      love.graphics.rectangle('line', VIRTUAL_WIDTH - 55, VIRTUAL_HEIGHT - 25, 50, 20, squareRadius, squareRadius)
    end
    
    --panel for sprite and info
    love.graphics.setColor(0.9, 0.9, 0.9, 1)
    love.graphics.rectangle('fill', 170, 5, 125, VIRTUAL_HEIGHT - 35, squareRadius, squareRadius)
    love.graphics.rectangle('fill', 300, 5, 80, VIRTUAL_HEIGHT - 35, squareRadius, squareRadius)
    
    for i = 1, 6 do
      love.graphics.setColor(0, 0.6, 0.6, 1)
      love.graphics.rectangle('fill', 5, -slotHeight + (slotHeight+5)*i, slotLength, slotHeight, squareRadius, squareRadius)
      
      if i == self.selected then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.rectangle('fill', 5, -slotHeight + (slotHeight+5)*i, slotLength, slotHeight, squareRadius, squareRadius)
      end
      

      if i == self.over or i == self.overPrevious then
        
        if i == self.over then
          love.graphics.setLineWidth(3)
          love.graphics.setLineStyle('rough')
          love.graphics.setColor(1, 0, 0, 1)
          love.graphics.rectangle('line', 5, -slotHeight + (slotHeight+5)*i, slotLength, slotHeight, squareRadius, squareRadius)
        end

        love.graphics.setColor(1, 1, 1, 1)
        self.chimeras[i]:render()
        
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Level', 300, 10, 80, 'center')
        love.graphics.printf(self.party.pokemon[i].level, 300, 23, 80, 'center')
        love.graphics.printf('HP', 300, 45, 80, 'center')
        love.graphics.printf(self.party.pokemon[i].currentHP..'/'..self.party.pokemon[i].HP, 300, 58, 80, 'center')
        love.graphics.printf('Attack', 300, 80, 80, 'center')
        love.graphics.printf(self.party.pokemon[i].attack, 300, 93, 80, 'center')
        love.graphics.printf('Defense', 300, 115, 80, 'center')
        love.graphics.printf(self.party.pokemon[i].defense, 300, 128, 80, 'center')
        love.graphics.printf('Speed', 300, 150, 80, 'center')
        love.graphics.printf(self.party.pokemon[i].speed, 300, 163, 80, 'center')

      end

      if self.party.pokemon[i] then
          love.graphics.setColor(1, 1, 1, 1)

          love.graphics.setFont(gFonts['small'])
          love.graphics.printf(self.party.pokemon[i].name, 12, -slotHeight + (slotHeight+5)*i + 5, self.slotLength - 10, 'left')
          love.graphics.printf(self.party.pokemon[i].currentHP..'/'..self.party.pokemon[i].HP, 12, -slotHeight + (slotHeight+5)*i + 5, self.slotLength - 10, 'center')
          love.graphics.printf('Lv. '..self.party.pokemon[i].level, 12, -slotHeight + (slotHeight+5)*i + 5, self.slotLength - 10, 'right')
          self.chimeras[i].healthBar:render()
      end

    end

end

function PartyState:back()
  gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 0.5,
        function()
            gStateStack:pop()
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 0.5,
            function() 
              if self.battle then
                self.battle:newAlliedPokemon(self.over)
              end
            end))
        end))
end

function PartyState:generateSpriteAndBar(i)
  self.chimeras[i] = Chimera(0.61, 0.47, true, 1.2, self.party.pokemon[i].seed)
    
  self.chimeras[i].healthBar = ProgressBar {
      x = 10,
      y = -self.slotHeight + (self.slotHeight+5)*i + 17,
      width = self.slotLength - 10,
      height = 8,
      color = {r = 189/255, g = 32/255, b = 32/255},
      colorBackground = {r = 0.2, g = 0.2, b = 0.2},
      value = self.party.pokemon[i].currentHP,
      max = self.party.pokemon[i].HP
  }
end

function PartyState:swapPositions(n1, n2)
  
  local temp = self.party.pokemon[n1]
  
  self.party.pokemon[n1] = self.party.pokemon[n2]
  self.party.pokemon[n2] = temp
  
  self:generateSpriteAndBar(n1)
  self:generateSpriteAndBar(n2)
  
  self.selected = false
  
end


  