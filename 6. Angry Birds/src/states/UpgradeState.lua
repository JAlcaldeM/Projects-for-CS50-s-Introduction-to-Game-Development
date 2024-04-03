UpgradeState = Class{__includes = BaseState}

function UpgradeState:enter(params)
  self.level = params.level
  self.upgrades = params.upgrades
  
  self.windows = {}
  self.tipsUsed = {}
  
  local windowWidth = 0.8*VIRTUAL_WIDTH
  local windowHeight = 0.15*VIRTUAL_HEIGHT
  local offset = 10*scale
  
  if self.level.levelNumber <= 10 then
    self.normalText = 'Select an upgrade:'
    local possibleUpgrades = {}
    local chosenUpgrades = {}
    for key, value in pairs(self.upgrades) do
      if value < upgradesInfo[key].maxLevel then
        table.insert(possibleUpgrades, key)
      end
    end
    
    for i = 1, 3 do
      local randomIndex = math.random(#possibleUpgrades)
      local chosenUpgrade = possibleUpgrades[randomIndex]
      table.insert(chosenUpgrades, chosenUpgrade)
      table.remove(possibleUpgrades, randomIndex)
    end

    for i = 1, 3 do
        local window = Window(0.1*VIRTUAL_WIDTH , 0.21*VIRTUAL_HEIGHT + (windowHeight + offset)*(i-1), windowWidth, windowHeight)
        window.textComplex = true
        window.text1 = upgradesInfo[chosenUpgrades[i]].cleanName..' '..self.upgrades[chosenUpgrades[i]]+1
        window.text2 = upgradesInfo[chosenUpgrades[i]].description
        window.onClick = function()
          self.upgrades[chosenUpgrades[i]] = self.upgrades[chosenUpgrades[i]]+1
          self.level = Level(self.level.levelNumber + 1, self.level.score, self.upgrades)
          gStateMachine:change('play', self.level)
        end
        table.insert(self.windows, window)
    end
  elseif self.level.levelNumber == 20 then
    gSounds['music']:stop()
    gSounds['fanfare1']:play()
    gSounds['fanfare2']:play()
    --gSounds['clapping']:play()
    self.normalText = 'CONGRATULATIONS! YOU BEAT THE GAME!'
    self.gameBeat = true
    local window = Window(0.1*VIRTUAL_WIDTH , 0.6*VIRTUAL_HEIGHT, windowWidth, windowHeight)
        window.textSimple = true
        window.text = 'Go back to main menu'
        window.onClick = function()
          gStateMachine:change('start')
        end
    table.insert(self.windows, window)
  else
    local window = Window(0.1*VIRTUAL_WIDTH , 0.22*VIRTUAL_HEIGHT, windowWidth, 3*windowHeight + 2*offset)
    self.normalText = 'No more upgrades available'
        window.textSimple = true
        window.text = 'Go to the next level'
        window.onClick = function()
          self.level = Level(self.level.levelNumber + 1, self.level.score + 100, self.upgrades)
          gStateMachine:change('play', self.level)
        end
    table.insert(self.windows, window)
  end
  
  
  local tipNumber = math.random(#tips)
  local tipUsed = true
  while tipUsed do
    tipUsed = false
    for _, number in ipairs(self.tipsUsed) do
      if number == tipNumber then tipUsed = true end
    end
  end
  self.tip = tips[tipNumber]
  
end

function UpgradeState:update(dt)
  
  local x, y = push:toGame(love.mouse.getPosition())
  for _, window in pairs(self.windows) do
    if window:mouseIsOver(x,y) then
      window.shadow = true
      if love.mouse.wasPressed(1) then
        window:onClick()
      end
    else
      window.shadow = false
    end
  end
  
end

function UpgradeState:render()
  self.level.background:render()
  self.level:render()

  for _, window in pairs (self.windows) do
    window:render()
  end


  if self.gameBeat then
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,0,0,1)
    love.graphics.printf(self.normalText, 0.25*VIRTUAL_WIDTH, 0.3*VIRTUAL_HEIGHT, 0.5*VIRTUAL_WIDTH, 'center')
    love.graphics.printf('SCORE: '..self.level.score, 0.25*VIRTUAL_WIDTH, 0.5*VIRTUAL_HEIGHT, 0.5*VIRTUAL_WIDTH, 'center')
  else
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0,0,0,1)
    love.graphics.printf(self.normalText, 0, 0.1*VIRTUAL_HEIGHT, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf('Tip: '..self.tip, 0.1*VIRTUAL_WIDTH + 2*scale, 0.75*VIRTUAL_HEIGHT + 2*scale, 0.8*VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0,0,0,1)
    love.graphics.printf('Tip: '..self.tip, 0.1*VIRTUAL_WIDTH, 0.75*VIRTUAL_HEIGHT, 0.8*VIRTUAL_WIDTH, 'center')
  end
  
  
  
  
end

