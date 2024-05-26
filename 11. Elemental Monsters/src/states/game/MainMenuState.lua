MainMenuState = Class{__includes = BaseState}

function MainMenuState:init(def)
  
  self.type = 'MainMenu'
  
  self.panels = {}
  
  self.titleFont = gFonts['title']
  self.optionFont = gFonts['medium']
  
  self.mainMenuInfo = {
    list = {'play', 'options', 'about', 'quit'},
    play = {
      name = 'Play',
      onClick = function()
        playSound('megaok')
        playSound('menuMusic')
        gStateStack:push(MenuState({}))
      end,
      
      },
    options = {
      name = 'Options',
      onClick = function()
        playSound('ok')
        gStateStack:push(OptionsState({}))
      end,
      
      },
    about = {
      name = 'Instructions',
      onClick = function()
        playSound('ok')
        gStateStack:push(AboutState({}))
      end,
      
      },
    quit = {
      name = 'Quit',
      onClick = function()
        playSound('out')
        love.event.quit()
      end,
      
      },
    }
    
  for i, key in ipairs(self.mainMenuInfo.list) do
    local info = self.mainMenuInfo[key]
    local text = info.name
    local panelLength = self.optionFont:getWidth(text)
    local panelHeight = self.optionFont:getHeight(text)
    local panel = Panel{
      x = VIRTUAL_WIDTH/2 - panelLength/2,
      y = 0.6*VIRTUAL_HEIGHT + 1.4*panelHeight*(i-1),
      value = text,
      color2 = palette[1],
      width = panelLength + 20,
      height = panelHeight,
      font = self.optionFont,
      nLines = 1,
      onClick = info.onClick
    }
    table.insert(self.panels, panel)
  end

  self.icons = {}
  
  local iconScale = 20
  
  local iconRow1Y = 0.05*VIRTUAL_HEIGHT
  local iconRow2Y = 0.3*VIRTUAL_HEIGHT
  local iconRow3Y = 0.55*VIRTUAL_HEIGHT
  local iconRow4Y = 0.8*VIRTUAL_HEIGHT
  
  local iconColumn1X = 0.08*VIRTUAL_WIDTH
  local iconColumn2X = 0.8*VIRTUAL_WIDTH
  
  local iconColumn3X = 0.12*VIRTUAL_WIDTH
  local iconColumn4X = 0.76*VIRTUAL_WIDTH
  
  
  self.iconCoordinates = {
    {x = iconColumn3X, y = iconRow1Y},
    {x = iconColumn4X, y = iconRow1Y},
    {x = iconColumn1X, y = iconRow2Y},
    {x = iconColumn2X, y = iconRow2Y},
    {x = iconColumn1X, y = iconRow3Y},
    {x = iconColumn2X, y = iconRow3Y},
    {x = iconColumn3X, y = iconRow4Y},
    {x = iconColumn4X, y = iconRow4Y},
  }
  
  self.iconNames = copyTable(smallTraitList)
  shuffleArray(self.iconNames)
  
  for i, name in ipairs(self.iconNames) do
    local coord = self.iconCoordinates[i]
    local icon = Icon{
      x = coord.x,
      y = coord.y,
      scale = iconScale,
      iconNumber = traitIcon[name],
    }
    icon.revealed = false
    table.insert(self.icons, icon)
  end
  
  self.timer = 0
  self.timePeriod = 0.3
  self.timePeriod2 = 1
  self.complete = false
  self.nIconRevealed = 0
  self.music = false
end


function MainMenuState:update(dt)
  
  
  if self.nIconRevealed == 9 then
    self.complete = true
  end
  
  if not self.complete then
    self.timer = self.timer + dt
    if self.timer > self.timePeriod and self.nIconRevealed < 9 then
      playSound('pow')
      self.nIconRevealed = self.nIconRevealed + 1
      if self.icons[self.nIconRevealed] then
        self.icons[self.nIconRevealed].revealed = true
      end
      self.timer = 0
    end
  end
  
  if self.complete and (not self.music) then
    self.timer = self.timer + dt
    if self.timer > self.timePeriod2 then
      self.music = true
      playSound('mainTheme')
    end
  end
  
  
  if self.complete and self.music then
    local x, y = push:toGame(love.mouse.getPosition())
  
    for i, panel in ipairs(self.panels) do
      if panel:mouseIsOver(x,y) then
        panel.colorFont1 = palette[35]
        if love.mouse.wasPressed(1) then
          panel:onClick()
        end
      else
        panel.colorFont1 = palette[2]
      end
      
    end

  end
  
  
  if love.mouse.wasPressed(1) then
    self.complete = true
    self.timer = self.timePeriod2
    for _, icon in pairs(self.icons) do
      icon.revealed = true
    end
  end

  
end




function MainMenuState:render()
  
  if self.complete then
    love.graphics.setColor(palette[2])
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('ELEMENTAL MONSTERS', 0, 200, VIRTUAL_WIDTH, 'center')
  end
  
  if self.music then
    for _, panel in pairs(self.panels) do
      panel:render()
    end
  end
  
  
  
  for _, icon in pairs(self.icons) do
    if icon.revealed then
      icon:render()
    end
  end

  

end