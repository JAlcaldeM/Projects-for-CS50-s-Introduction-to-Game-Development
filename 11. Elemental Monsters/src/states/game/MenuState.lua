

MenuState = Class{__includes = BaseState}

function MenuState:init(def)
  self.type = 'Menu'
  
  self.canInput = true
  
  
  
  
  
  self.startOffset = def.startOffset or 0
  self.extraInfo = def.extraInfo or false
  self.victory = def.victory or false
  self.currentIncrease = def.currentIncrease or 0
  self.giveTrait = def.giveTrait or false
  
  self.backgroundX = self.startOffset
  
  
  self.icons = {}
  self.windows = {}
  self.panels = {}
  self.panelBacks = {}
  self.hiddenPanels = {}
  self.lines = {}
  
  self.width = VIRTUAL_WIDTH
  self.height = VIRTUAL_HEIGHT
  self.offset = offset
  self.offsetBig = offsetBig
  self.font = gFonts['medium']
  self.fontOffset = self.font:getHeight() + 2*self.offset
  
  -- sprite
  self.spriteX = self.offsetBig + self.startOffset
  self.spriteY = self.offsetBig
  self.spriteWidth = 750
  self.spriteHeight = 750
  
  
  
  
  
  self.monster = def.monster or Monster{
      width = 100,
      height = 100,
      color = colors.white,
      origin = 'center',
      extraPower = 100,
  }
  self.monster.counterLimit = 3
  self.monster.hasTrainer = true
  --self.monster:addTrait('fire', 'head')
  self.movList = self.monster.selectedMoves
  
  self.monster.x = self.spriteX + self.spriteWidth/2
  self.monster.y = self.spriteY + self.spriteHeight/2 + 50*scale
  local seed
  if def.monster then
    seed = def.monster.seed
    self.prevPower = self.monster.totalPower
  end
  
  self.spriteParams = {power = self.monster.totalPower, monster = self.monster}
  self.monster.sprite = Chimera(self.monster.x, self.monster.y, true, seed, 10, 8, self.spriteParams)
  
  if not def.monster then
    self.monster.name = self.monster.sprite.name
    self.monster.seed = self.monster.sprite.seed
  end
  
  
  

  
  --characters
  self.characterFont = gFonts['small']
  self.character1Width = self.characterFont:getWidth(characterInfo[self.monster.character1].name)
  self.character2Width = self.characterFont:getWidth(characterInfo[self.monster.character2].name)
  self.characterHeight = self.characterFont:getHeight()
  
  self.character1X = self.spriteX + self.spriteWidth - self.character1Width - self.offset
  self.character1Y = self.spriteY + self.spriteHeight - 2*(self.characterHeight + self.offset)
  self.character2X = self.spriteX + self.spriteWidth - self.character2Width - self.offset
  self.character2Y = self.spriteY + self.spriteHeight - self.characterHeight - self.offset
  
  self.charPanel1 = Panel{
    x = self.character1X - 2*self.offsetBig,
    y = self.character1Y,
    width = self.character1Width + 4*self.offsetBig,
    height = self.characterHeight,
    offset = self.offsetBig,
    value = characterInfo[self.monster.character1].name,
    color1 = palette[1],
    color2 = palette[1],
    colorFont1 = palette[2],
    colorFont2 = palette[2],
    nLines = 1,
  }
  self.charPanel1.hasOnHover = true
  table.insert(self.panels, self.charPanel1)
  
  self.charPanel2 = Panel{
    x = self.character2X - 2*self.offsetBig,
    y = self.character2Y,
    width = self.character2Width + 4*self.offsetBig,
    height = self.characterHeight,
    offset = self.offsetBig,
    value = characterInfo[self.monster.character2].name,
    color1 = palette[1],
    color2 = palette[1],
    colorFont1 = palette[2],
    colorFont2 = palette[2],
    nLines = 1,
  }
  self.charPanel2.hasOnHover = true
  table.insert(self.panels, self.charPanel2)
  

  self.char1HiddenPanel = Panel{
    x = self.character1X - (4*self.offsetBig + 3*40*scale),
    y = self.character1Y - 2*self.offsetBig,
    width = 3*self.offsetBig + 3*40*scale,
    height = 6*self.offsetBig + 10*scale,
    offset = self.offsetBig,
    subelements = {},
  }

  self.charPanel1.hiddenPanel = self.char1HiddenPanel
  table.insert(self.hiddenPanels, self.char1HiddenPanel)
  
  local char1HiddenPanelIcon1 = Icon{
    x = self.character1X - (2*self.offsetBig + 3*40*scale),
    y = self.character1Y,
    scale = 3,
    iconNumber = moveTypeIcon[characterInfo[self.monster.character1].movType],
  }
  table.insert(self.char1HiddenPanel.subelements, char1HiddenPanelIcon1)
  
  local char1HiddenPanelIcon2 = Icon{
    x = self.character1X - (2*self.offsetBig + 2*40*scale),
    y = self.character1Y,
    scale = 3,
    iconNumber = 324,
  }
  table.insert(self.char1HiddenPanel.subelements, char1HiddenPanelIcon2)
  
  local char1HiddenPanelIcon3 = Icon{
    x = self.character1X - (2*self.offsetBig + 40*scale),
    y = self.character1Y,
    scale = 3,
    iconNumber = approachesIcon[characterInfo[self.monster.character1].approach],
  }
  table.insert(self.char1HiddenPanel.subelements, char1HiddenPanelIcon3)
  
  
  
  
  self.char2HiddenPanel = Panel{
    x = self.character2X - (4*self.offsetBig + 3*40*scale),
    y = self.character2Y - 2*self.offsetBig,
    width = 3*self.offsetBig + 3*40*scale,
    height = 6*self.offsetBig + 10*scale,
    offset = self.offsetBig,
    subelements = {},
  }

  self.charPanel2.hiddenPanel = self.char2HiddenPanel
  table.insert(self.hiddenPanels, self.char2HiddenPanel)
  
  
  local char2HiddenPanelIcon1 = Icon{
    x = self.character2X - (2*self.offsetBig + 3*40*scale),
    y = self.character2Y,
    scale = 3,
    iconNumber = moveTypeIcon[characterInfo[self.monster.character2].movType],
  }
  table.insert(self.char2HiddenPanel.subelements, char2HiddenPanelIcon1)
  
  local char2HiddenPanelIcon2 = Icon{
    x = self.character2X - (2*self.offsetBig + 2*40*scale),
    y = self.character2Y,
    scale = 3,
    iconNumber = 324,
  }
  table.insert(self.char2HiddenPanel.subelements, char2HiddenPanelIcon2)
  
  local char2HiddenPanelIcon3 = Icon{
    x = self.character2X - (2*self.offsetBig + 40*scale),
    y = self.character2Y,
    scale = 3,
    iconNumber = approachesIcon[characterInfo[self.monster.character2].approach],
  }
  table.insert(self.char2HiddenPanel.subelements, char2HiddenPanelIcon3)
  

  self.charPanel1.onHover = function()
    self.charPanel1.hiddenPanel:render()
  end
  
  self.charPanel2.onHover = function()
    self.charPanel2.hiddenPanel:render()
  end

  
  
  -- organs
  self.organsX = self.spriteX + self.spriteWidth + self.offsetBig
  self.organsY = self.offsetBig
  self.organsWidth = 600
  self.organsHeight = self.spriteHeight
  
  local iconScale = 5
  local iconX = self.organsX + self.organsWidth - self.offsetBig - 10*iconScale
  local iconY = self.organsY + self.offsetBig
  local icon = Icon{
    x = iconX,
    y = iconY,
    scale = iconScale,
    iconNumber = 240,
  }
  local hiddenPanelWidth = 500
  local hiddenPanelHeight = 280
  local hiddenPanel = Panel{
    x = iconX - self.offsetBig/2 - hiddenPanelWidth,
    y = iconY,
    width = hiddenPanelWidth,
    height = hiddenPanelHeight,
    value = 'Each organ has is own power value, divided in 4 different stats. Movements made by an organ scale with the power of some of the stats from that organ.',
    color = colors.green,
    offset = self.offsetBig,
    nLines = 7,
  }
  icon.hiddenPanel = hiddenPanel
  icon.onHover = function()
    icon.hiddenPanel:render()
  end
  table.insert(self.icons, icon)
  table.insert(self.hiddenPanels, hiddenPanel)
 
  -- stats
  self.statsX = self.spriteX
  self.statsY = self.spriteY + self.spriteHeight + self.offsetBig
  self.statsWidth = self.spriteWidth + self.organsWidth + self.offsetBig
  self.statsHeight = 240 --self.height - self.statsY - self.offset
  
  
  

  -- buttons
  self.button1X = self.spriteX
  self.buttonY = self.statsY + self.statsHeight + self.offsetBig
  self.button1Width = self.statsWidth
  self.buttonHeight = self.height - self.buttonY - self.offsetBig
  
  -- movements
  self.movX = self.organsX + self.organsWidth + self.offsetBig
  self.movY = self.offsetBig
  self.movWidth = self.width + self.startOffset - self.movX - self.offsetBig
  self.movHeight = self.height - 3*self.offsetBig - self.buttonHeight

  
  local iconXMath = self.movX + self.movWidth - self.offsetBig - 10*iconScale
  local iconYMath = self.movY + self.offsetBig
  local iconMath = Icon{
    x = iconXMath,
    y = iconYMath,
    scale = iconScale,
    iconNumber = 109,
  }
  
  iconMath.onClick = function()
    playSound('pow')
    self.extraInfo = not self.extraInfo
    --self.panels = {}
    self.movCoordinates = {}
    for i, movName in ipairs(self.movList) do
      createMovementPanel{
        movName = movName,
        menuState = self,
        i = i,
        extraInfo = self.extraInfo,
        nPanels = #self.movList,
        }
    end
    createInstinctPanel(self)
  end
  
  table.insert(self.icons, iconMath)
  
  local hiddenPanelWidthMath = 500
  local hiddenPanelHeightMath = 140
  local hiddenPanelMath = Panel{
    x = iconXMath - self.offsetBig/2 - hiddenPanelWidthMath,
    y = iconYMath,
    width = hiddenPanelWidthMath,
    height = hiddenPanelHeightMath,
    value = 'Click this icon to show or hide additional movement information.',
    offset = self.offsetBig,
  }
  iconMath.hiddenPanel = hiddenPanelMath
  iconMath.onHover = function()
    iconMath.hiddenPanel:render()
  end
  table.insert(self.hiddenPanels, hiddenPanelMath)
  
  
  
  local iconXLocked = self.movX + self.movWidth - 2*self.offsetBig - 20*iconScale
  local iconYLocked = self.movY + self.offsetBig
  local iconLocked = Icon{
    x = iconXLocked,
    y = iconYLocked,
    scale = iconScale,
    iconNumber = 253,
  }
  table.insert(self.icons, iconLocked)
  
  local hiddenPanelWidthLocked = 500
  local hiddenPanelHeightLocked = 160
  local hiddenPanelLocked = Panel{
    x = iconXLocked - self.offsetBig/2 - hiddenPanelWidthLocked,
    y = iconYLocked,
    width = hiddenPanelWidthLocked,
    height = hiddenPanelHeightLocked,
    value = 'Movements locked. To change the movement order, go to the Edit Moves menu.',
    offset = self.offsetBig,
  }
  iconLocked.hiddenPanel = hiddenPanelLocked
  iconLocked.onHover = function()
    iconLocked.hiddenPanel:render()
  end
  table.insert(self.hiddenPanels, hiddenPanelLocked)
  
  
  
  
  self.button2X = self.movX + self.offset
  self.button2Width = self.movWidth - 2*self.offset

  self.movCoordinates = {}
  for i, movName in ipairs(self.movList) do
    
    createMovementPanel{
        movName = movName,
        menuState = self,
        i = i,
        extraInfo = self.extraInfo,
        nPanels = #self.movList,
        }
  end
  createInstinctPanel(self)
  
  local organsPanelWidth = (self.organsWidth - 4*self.offset) / 3
  local organsPanelHeight = ((self.organsHeight - self.fontOffset - self.offset) / #organList) - self.offset
  for i, organ in ipairs(organList) do
    local organInfo = self.monster.organs[organ]
    local panelX = self.organsX + self.offset
    local panelY = self.organsY + self.fontOffset + self.offset*i + organsPanelHeight*(i-1)
    table.insert(self.panels, Panel{
        x = panelX,
        y = panelY,
        width = organsPanelWidth,
        height = organsPanelHeight,
        name = organInfo.name,
        value = math.ceil(organInfo.powerValue),
        nameIcon = true,
      })
    
    local iconScale = 3
    local icon = Icon{
      x = panelX + self.offset,
      y = panelY + self.offset,
      scale = iconScale,
      iconNumber = organIcon[organ],
    }
    table.insert(self.icons, icon)
    
    local hiddenPanelWidth = 140
    local hiddenPanelHeight = 190
    local hiddenPanel = Panel{
      x = panelX - self.offsetBig/2 - hiddenPanelWidth,
      y = panelY,
      width = hiddenPanelWidth,
      height = hiddenPanelHeight,
      offset = self.offsetBig,
    }
    
    table.insert(self.hiddenPanels, hiddenPanel)

    for i, powerType in ipairs(powerTypesList) do
      local iconType = Icon{
        x = hiddenPanel.x + 2*self.offsetBig,
        y = hiddenPanel.y2 + self.offsetBig + (10*iconScale + self.offsetBig)*(i-1),
        scale = iconScale,
        iconNumber = statsIcon[powerType],
      }
      table.insert(hiddenPanel.subelements, iconType)
      local textType = {
        text = math.ceil(organInfo.powerTypeValues[powerTypesList[i]]),
        x = hiddenPanel.x + 3*self.offsetBig + 10*iconScale,
        y = hiddenPanel.y2 + self.offsetBig + (10*iconScale + self.offsetBig)*(i-1),
        isText = true
        }
      table.insert(hiddenPanel.subelements, textType)
    end    
    icon.hiddenPanel = hiddenPanel
    icon.onHover = function()
      icon.hiddenPanel:render()
    end
  
    
    local trait1Name = '-' --'Trait Slot'
    local trait1Color1 = colorsPure.black
    local trait1Color2 = colorsPure.black
    local trait1PowerValue = '-'
    local trait1nameIcon = false
    if organInfo.traitSlot1 then
      trait1Name = organInfo.traitSlot1.name
      trait1PowerValue = math.ceil(organInfo.traitSlot1.powerValue)
      trait1nameIcon = true
      local icon = Icon{
      x = self.organsX + (organsPanelWidth + 2*self.offset),
      y = self.organsY + self.fontOffset + self.offset*(i+2) + organsPanelHeight*(i-1),
      scale = iconScale,
      iconNumber = traitIcon[organInfo.traitSlot1.key],
      }
      table.insert(self.icons, icon)
      
      trait1Color1 = traitColors[organInfo.traitSlot1.key].color1
      trait1Color2 = traitColors[organInfo.traitSlot1.key].color2
    end

    table.insert(self.panels, Panel{
        x = self.organsX + (organsPanelWidth + self.offset),
        y = self.organsY + self.fontOffset + self.offset*(i+1) + organsPanelHeight*(i-1),
        width = organsPanelWidth,
        height = organsPanelHeight - 2*self.offset,
        name = trait1Name,
        value = trait1PowerValue,
        color = colors.cyan,
        nameIcon = trait1nameIcon,
        color1 = trait1Color1,
        color2 = trait1Color2,
        colorFont2 = colorsPure.white,
      })
    
    local trait2Name = '-' --'Trait Slot'
    local trait2Color1 = colorsPure.black
    local trait2Color2 = colorsPure.black
    local trait2PowerValue = '-'
    local trait2nameIcon = false
    if organInfo.traitSlot2 then
      trait2Name = organInfo.traitSlot2.name
      trait2PowerValue = math.ceil(organInfo.traitSlot2.powerValue)
      trait2nameIcon = true
      local icon = Icon{
      x = self.organsX + (organsPanelWidth + self.offset)*2 + self.offset,
      y = self.organsY + self.fontOffset + self.offset*(i+2) + organsPanelHeight*(i-1),
      scale = iconScale,
      iconNumber = traitIcon[organInfo.traitSlot2.key],
      }
      table.insert(self.icons, icon)

      trait2Color1 = traitColors[organInfo.traitSlot2.key].color1
      trait2Color2 = traitColors[organInfo.traitSlot2.key].color2
    end
    
    table.insert(self.panels, Panel{
        x = self.organsX + (organsPanelWidth + self.offset)*2,
        y = self.organsY + self.fontOffset + self.offset*(i+1) + organsPanelHeight*(i-1),
        width = organsPanelWidth,
        height = organsPanelHeight - 2*self.offset,
        name = trait2Name,
        value = trait2PowerValue,
        color = colors.cyan,
        nameIcon = trait2nameIcon,
        color1 = trait2Color1,
        color2 = trait2Color2,
        colorFont2 = colorsPure.white,
      })
    
    table.insert(self.panelBacks, {
        x = self.organsX + self.offset,
        y = self.organsY + self.fontOffset + self.offset*i + organsPanelHeight*(i-1),
        width = self.organsWidth - 2*self.offset,
        height = organsPanelHeight
        })
  end  
  
  local statPanelWidth = ((self.statsWidth - self.offset) / #statList) - self.offset
  local statPanelHeight1 = self.statsHeight - self.fontOffset - self.offset
  local statPanelHeight2 = (self.statsHeight - 3*self.offset) / 2
  
  
  
  for i, stat in ipairs(statList) do
    local statInfo = self.monster.stats[stat]
    local statValue = math.ceil(statInfo.value)
    if statInfo.name == 'HP' then
      statValue = math.ceil(self.monster.stats['currentHP'].value)..'/'..math.ceil(statInfo.value)
    end
    if i > 1 then
      local panelX = self.statsX + self.offset*i + statPanelWidth*(i-1)
      --local panelY = self.statsY + self.statsHeight - statPanelHeight2 - self.offset
      local panelY = self.statsY + self.offset
      
      table.insert(self.panels, Panel{
        x = panelX,
        y = panelY,
        width = statPanelWidth,
        height = statPanelHeight2,
        name = statInfo.name,
        value = statValue,
        color = colors.green,
        nameIcon = true,
      })
      local iconScale = 3
      local icon = Icon{
        x = panelX + self.offset,
        y = panelY + self.offset,
        scale = iconScale,
        iconNumber = statsInfo[stat].iconNumber,
      }
      table.insert(self.icons, icon)
    end
  end
  
  for i, powerType in ipairs(powerTypesList) do
    local powerTypeInfo = self.monster.powerValues[powerType]
    local powerTypeValue = powerTypeInfo.value

    local panelX = self.statsX + self.offset*(i+1) + statPanelWidth*(i)
    local panelY = self.statsY + self.statsHeight - statPanelHeight2 - self.offset
    --local panelY = self.statsY + self.offset
    
    table.insert(self.panels, Panel{
      x = panelX,
      y = panelY,
      width = statPanelWidth,
      height = statPanelHeight2,
      name = powerTypeInfo.name,
      value = math.ceil(powerTypeValue),
      nameIcon = true,
    })
    local iconScale = 3
    local icon = Icon{
      x = panelX + self.offset,
      y = panelY + self.offset,
      scale = iconScale,
      iconNumber = powerTypesInfo[powerType].iconNumber,
    }
    table.insert(self.icons, icon)
    
    table.insert(self.lines, {
      x1 = panelX + statPanelWidth/2, y1 = panelY + statPanelHeight2/2,
      x2 = panelX + statPanelWidth/2, y2 = panelY - statPanelHeight2 + statPanelHeight2/2,
      })
  end
  
  local totalPowerPanelX = self.statsX + self.offset
  local totalPowerPanelY = self.statsY + self.statsHeight - statPanelHeight2 - self.offset
  table.insert(self.panels, Panel{
      x = totalPowerPanelX,
      y = totalPowerPanelY,
      width = statPanelWidth,
      height = statPanelHeight2,
      name = 'Total Power',
      value = math.ceil(self.monster.totalPower),
    })
  
  table.insert(self.lines, {
      x1 = totalPowerPanelX + statPanelWidth/2, y1 = totalPowerPanelY + statPanelHeight2/2,
      x2 = totalPowerPanelX + 4*statPanelWidth + statPanelWidth/2, y2 = totalPowerPanelY + statPanelHeight2/2,
      })
  
  
  
  local window1 = Window{
      x = self.button1X,
      y = self.buttonY,
      width = self.button1Width,
      height = self.buttonHeight,
      color1 = palette[28],
      color2 = palette[29],
      colorFont = palette[2],
      colorFont2 = palette[4],
      text1 = 'FIGHT',
    }
  window1.onClick = function()
    playSound('megaok')
    local newState = StartState({
          --movWidth = self.movWidth,
          --buttonHeight = self.buttonHeight,
          monster = self.monster,
          extraInfo = self.extraInfo,
        })
    gStateStack:clear()
    gStateStack:push(newState)
  end  
    
  table.insert(self.windows, window1)
  
  local window2 = Window{
      x = self.button2X,
      y = self.buttonY,
      width = self.button2Width,
      height = self.buttonHeight,
      color1 = palette[12],
      color2 = palette[13],
      colorFont = palette[2],
      colorFont2 = palette[4],
      text1 = 'EDIT MOVES',
    }
  window2.onClick = function()
    playSound('ok')
    self.canInput = false
    local moveDistance = self.movX - self.offset
    local moveTime = 0.5
    local newState = MovMenuState({
          startOffset = moveDistance,
          movWidth = self.movWidth,
          buttonHeight = self.buttonHeight,
          monster = self.monster,
          extraInfo = self.extraInfo,
        })
    newState.canInput = false
    gStateStack:push(newState)
    newState:move(-moveDistance, moveTime)
    self:move(-moveDistance, moveTime)
    Timer.after(moveTime, function()
        gStateStack:popPrevious()
        newState.canInput = true
      end)
  end
  table.insert(self.windows, window2)
  

end

function MenuState:update(dt)
  
  if self.startingFrame then
    self.startingFrame = false
  end
  
  if self.giveTrait then
    local newState = ChooseTraitState({
          monster = self.monster,
        })
    gStateStack:push(newState)
  end
  
  
  
  if self.victory and (not self.startingFrame) then
    
    self.canInput = false
    
    local transitionDuration = 0.5
    local powerIncrease = 100
    
    local frameIncrease = dt*powerIncrease/transitionDuration
    if self.currentIncrease + frameIncrease > powerIncrease then
      frameIncrease = powerIncrease - self.currentIncrease
      self.victory = false
      if encounterNumber == 3 or encounterNumber == 6 or encounterNumber == 9 then
        self.giveTrait = true
      end
    end
    
    self.monster:distributePower(frameIncrease)
    self.currentIncrease = self.currentIncrease + frameIncrease
    
    gStateStack:push(MenuState({victory = self.victory, currentIncrease = self.currentIncrease, monster = self.monster, giveTrait = self.giveTrait}))

  end
  
  
  
  if not self.canInput then
    return
  end
  
  
  
  
  --[[
  if love.keyboard.wasPressed('i') then
    local newState = ChooseTraitState({
          monster = self.monster,
        })
    gStateStack:push(newState)
  end
  ]]
  
  local x, y = push:toGame(love.mouse.getPosition())
  self.overWindow = false
  for i, window in ipairs(self.windows) do
    if window:mouseIsOver(x,y) then
      window.shadow = true
      self.overWindow = true
      if love.mouse.wasPressed(1) then
        window:onClick()
      end
    else
      window.shadow = false
    end
  end
  
  for _, icon in pairs(self.icons) do
    if icon:mouseIsOver(x,y) then
      icon.isMouseOver = true
      if love.mouse.wasPressed(1) then
        icon:onClick()
      end
    end
  end
  
  for _, panel in pairs(self.panels) do
    if panel:mouseIsOver(x,y) then
      panel.isMouseOver = true
    end
  end
  
  
end

function MenuState:render()
  
  love.graphics.setColor(palette[1])
  love.graphics.rectangle('fill', self.backgroundX, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  --[[
  love.graphics.setColor(colorsPure.black)
  love.graphics.rectangle('fill', self.movX, self.movY, self.movWidth, self.movHeight)
  love.graphics.rectangle('fill', self.spriteX, self.spriteY, self.spriteWidth, self.spriteHeight)
  love.graphics.rectangle('fill', self.organsX, self.organsY, self.organsWidth, self.organsHeight)
  love.graphics.rectangle('fill', self.statsX, self.statsY, self.statsWidth, self.statsHeight)
  ]]
  
  
  love.graphics.setColor(colorsPure.white)
  for _, panelBack in pairs(self.panelBacks) do
    love.graphics.rectangle('fill', panelBack.x, panelBack.y, panelBack.width, panelBack.height)
  end
  
  love.graphics.setColor(colorsPure.white)
  love.graphics.setLineWidth(4*scale)
  for _, line in pairs(self.lines) do
    love.graphics.line(line.x1, line.y1, line.x2, line.y2)
  end
  
  self.instinctPanel:render()
  
  self.monster:render()
  
  for _, panel in pairs(self.panels) do
    panel:render()
  end
  
  for _, window in pairs(self.windows) do
    window:render()
  end
  
  
  
  
  love.graphics.setColor(colorsPure.white)
  love.graphics.setFont(self.font)
  love.graphics.print('Movements', self.movX + self.offset, self.movY + self.offset)
  --love.graphics.print('Sprite', self.spriteX + self.offset, self.spriteY + self.offset)
  love.graphics.printf(self.monster.name, self.spriteX, self.spriteY + self.spriteHeight - 80*scale, self.spriteWidth, 'center')
  love.graphics.print('Organs', self.organsX + self.offset, self.organsY + self.offset)
  love.graphics.print('Stats', self.statsX + self.offset, self.statsY + self.offset)
  
  --[[
  love.graphics.setFont(self.characterFont)
  love.graphics.print(characterInfo[self.monster.character1].name, self.character1X, self.character1Y)
  love.graphics.print(characterInfo[self.monster.character2].name, self.character2X, self.character2Y)
  ]]
  
  
  
  
  for _, icon in pairs(self.icons) do
    icon:render()
  end
  
  for _, icon in pairs(self.icons) do
    if icon.isMouseOver then
      icon:onHover()
      icon.isMouseOver = false
    end
  end
  
  for _, panel in pairs(self.panels) do
    if panel.isMouseOver then
      panel:onHover()
      panel.isMouseOver = false
    end
  end
  
  
  --[[
  local x, y = push:toGame(love.mouse.getPosition())
  for _, icon in pairs(self.icons) do
    if icon:mouseIsOver(x,y) then
      icon:onHover()
    end
  end
  ]]
  

end

function MenuState:move(value, time)

  --local value = -100
  --local time = 1
  
  Timer.tween(time, {[self] = {movX = self.movX + value, spriteX = self.spriteX + value, organsX = self.organsX + value, statsX = self.statsX + value, character1X = self.character1X + value, character2X = self.character2X + value, backgroundX = self.backgroundX + value}})

  for _, panel in pairs(self.panels) do
    Timer.tween(time, {[panel] = {x = panel.x + value, x2 = panel.x2 + value}})
    for _, subelement in pairs(panel.subelements) do
      Timer.tween(time, {[subelement] = {x = subelement.x + value}})
    end
  end

  for _, window in pairs(self.windows) do
    Timer.tween(time, {[window] = {x = window.x + value}})
  end
  
  for _, panelBack in pairs(self.panelBacks) do
    Timer.tween(time, {[panelBack] = {x = panelBack.x + value}})
  end
  
  for _, panel in pairs(self.hiddenPanels) do
    Timer.tween(time, {[panel] = {x = panel.x + value, x2 = panel.x2 + value}})
    for _, subelement in pairs(panel.subelements) do
      Timer.tween(time, {[subelement] = {x = subelement.x + value}})
    end
  end
  
  for _, icon in pairs(self.icons) do
    Timer.tween(time, {[icon] = {x = icon.x + value}})
  end
  
  for _, line in pairs(self.lines) do
    Timer.tween(time, {[line] = {x1 = line.x1 + value, x2 = line.x2 + value}})
  end
  
  Timer.tween(time, {[self.instinctPanel] = {x = self.instinctPanel.x + value, x2 = self.instinctPanel.x2 + value}})
  
  Timer.tween(time, {[self.monster.sprite] = {canvasX = self.monster.sprite.canvasX + value}})
  
  Timer.tween(time, {[self.monster] = {x = self.monster.x + value}})
  
end


function MenuState:recalculateValues()
  
end
