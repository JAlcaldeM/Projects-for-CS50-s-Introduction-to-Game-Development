AfterBattleState = Class{__includes = BaseState}

function AfterBattleState:init(def)
  
  self.type = 'AfterBattle'
  
  gSounds.battleTheme:stop()
  
  self.monster = def.monster
  
  if not self.monster then
    self.monster = Monster{x = 500, y = 500}
    self.monster.sprite = Chimera(self.monster.x, self.monster.y, true, nil, 10, 8, {monster = self.monster})
    self.monster.name = self.monster.sprite.name
    self.monster.seed = self.monster.sprite.seed
  end
  
  for _, organ in pairs(organList) do
    self.monster.organs[organ].committed = false
  end
  
  
  
  self.monster.stats.currentHP.value = self.monster.stats.maxHP.value
  
  self.sprite = def.moveSprite
  
  self.sprite.speedY = -1000
  
  
  self.victory = def.victory
  --self.victory = true

  --local spriteParams = {white = true, removeShadows = true, removeMouth = true, monster = self.monster}
  
  
  self.spriteRender = true
  
  
  
  local windowText
  local panelText
  local onClick
  local windowColor
  
  if self.victory and encounterNumber == 10 then
    self.supremeVictory = true
  end
  
  
  if self.supremeVictory then
      windowText = 'BACK TO MAIN SCREEN'
      panelText = 'CONGRATULATIONS! YOU COMPLETED THE GAME!'
      windowColor = 40
      self.gameComplete = true
      onClick = function()
        playSound('ok')
        encounterNumber = 1
        gStateStack:clear()
        gStateStack:push(MainMenuState({}))
      end
  elseif self.victory then
    windowText = 'CONTINUE'
    panelText = 'VICTORY!'
    windowColor = 40
    onClick = function()
      playSound('ok')
      playSound('menuMusic')
      for _, status in pairs(self.monster.statusList) do
        self.monster.status[status] = nil
      end
      self.monster.statusList = {}
      encounterNumber = encounterNumber + 1
      local newState = MenuState({
            monster = self.monster,
            victory = true,
          })
      gStateStack:clear()
      gStateStack:push(newState)
    end
  else
    windowText = 'BACK TO MAIN SCREEN'
    panelText = 'GAME OVER...'
    windowColor = 28
    onClick = function()
      playSound('ok')
      encounterNumber = 1
      gStateStack:clear()
      gStateStack:push(MainMenuState({}))
    end
  end

  if self.gameComplete then
    self.panelX = 0.1*VIRTUAL_WIDTH
    self.panelWidth = 0.8*VIRTUAL_WIDTH
    self.nLines = 3
  else
    self.panelX = 0.25*VIRTUAL_WIDTH
    self.panelWidth = 0.5*VIRTUAL_WIDTH
    self.nLines = 2
  end

  
  

  self.window = Window{
    x = 0.3*VIRTUAL_WIDTH,
    y = 0.6*VIRTUAL_HEIGHT,
    width = 0.4*VIRTUAL_WIDTH,
    height = 0.1*VIRTUAL_HEIGHT,
    color1 = palette[windowColor],
    color2 = palette[windowColor + 1],
    colorFont = palette[2],
    colorFont2 = palette[4],
    font = gFonts['medium'],
    text1 = windowText,
  }
  
  self.panel = Panel{
    x = self.panelX,
    y = 0.25*VIRTUAL_HEIGHT,
    width = self.panelWidth,
    height = 0.5*VIRTUAL_HEIGHT,
    offset = offsetBig,
    font = gFonts['large'],
    nLines = self.nLines,
    colorFont = palette[2],
    value = panelText,
    }
  
  self.window.onClick = onClick

  
  self.windows = {}
  table.insert(self.windows, self.window)
  
end


function AfterBattleState:update(dt)
  if self.sprite then
    self.sprite.canvasY = self.sprite.canvasY + self.sprite.speedY*dt
    self.sprite.speedY = self.sprite.speedY + 2000*dt
    if self.spriteRender and self.sprite.canvasY > 2*VIRTUAL_HEIGHT then
      self.spriteRender = false
      self.panelRender = true
      if self.supremeVictory then
        playSound('supremeVictory')
      elseif self.victory then
        playSound('victory')
      else
        playSound('defeat')
      end
    end
  end
  
  
  local x, y = push:toGame(love.mouse.getPosition())
  self.overWindow = false
  for _, window in pairs(self.windows) do
    if window:mouseIsOver(x,y) then
      window.shadow = true
      self.overWindow = true
      if love.mouse.wasPressed(1) and self.panelRender then
        window:onClick()
      end
    else
      window.shadow = false
    end
  end
  
  
end




function AfterBattleState:render()
  --[[
  if self.spriteRender then
    self.sprite:render()
  end
  ]]
  
  if self.panelRender then
    self.panel:render()
    self.window:render()
  end
end
