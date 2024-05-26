MovMenuState = Class{__includes = BaseState}

function MovMenuState:init(def)
  self.type = 'MovMenu'
  
  self.canInput = true
  
  self.startOffset = def.startOffset or 0
  self.extraInfo = def.extraInfo or false
  
  self.icons = {}
  self.panels = {}
  self.hiddenPanels = {}
  self.windows = {}
  
  self.backgroundX = self.startOffset
  
  self.monster = def.monster or Monster{
      x = 0,
      y = 0,
      width = 100,
      height = 100,
      color = colors.white,
      origin = 'center',
  }
  
  self.width = VIRTUAL_WIDTH
  self.height = VIRTUAL_HEIGHT
  self.offset = 4*scale
  self.offsetBig = 10*scale
  self.font = gFonts['medium']
  self.fontOffset = self.font:getHeight() + 2*self.offset


  self.buttonHeight = def.buttonHeight or 100

  -- movements
  self.movX = self.offsetBig + self.startOffset
  self.movY = self.offsetBig
  self.movWidth = def.movWidth or 470
  self.movHeight = self.height - 3*self.offsetBig - self.buttonHeight
  self.movList = self.monster.selectedMoves or {'punch', 'block'}
  
  local iconScale = 5
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
    self.panels = {}
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
    x = iconXMath + 10*iconScale + self.offsetBig/2,
    y = iconYMath,
    width = hiddenPanelWidthMath,
    height = hiddenPanelHeightMath,
    value = 'Click this icon to show or hide additional movement information.',
    alpha = 0,
    color = colors.green,
    offset = 10*scale,
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
    iconNumber = 254,
  }
  table.insert(self.icons, iconLocked)
  
  iconLocked.onClick = function()
    playSound('powapo')
    self.monster:chooseMovements()
    self.movList = self.monster.selectedMoves
    self.panels = {}
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
    for i, window in pairs(self.lmovWindows) do
      window.isTicked = false
      for j, movName in pairs(self.movList) do
        local moveInfo = MOV_DEFS[movName] or MOV_DEFS[self.monster.moveToKey[movName]]
        if window.text1 == moveInfo.name then
          window.isTicked = true
        end
      end
    end
    
  end
  
  local hiddenPanelWidthLocked = 500
  local hiddenPanelHeightLocked = 180
  local hiddenPanelLocked = Panel{
    x = iconXLocked + 10*iconScale + self.offsetBig/2,
    y = iconYLocked,
    width = hiddenPanelWidthLocked,
    height = hiddenPanelHeightLocked,
    value = 'Clic and drag a movement to change its position. To reset the default movements, click this icon.',
    alpha = 0,
    offset = 10*scale,
    nLines = 4,
    color = colors.green,
  }
  iconLocked.hiddenPanel = hiddenPanelLocked
  iconLocked.onHover = function()
    iconLocked.hiddenPanel:render()
  end
  table.insert(self.hiddenPanels, hiddenPanelLocked)
  

  -- learnt movements
  self.lmovX = self.movX + self.movWidth + self.offsetBig
  self.lmovY = self.offsetBig
  self.lmovWidth = self.width + self.startOffset - self.lmovX - self.offsetBig
  self.lmovHeight = self.height - 2*self.offsetBig
  
  
  --self.buttonWidth = (self.movWidth - self.offsetBig)/2 - self.offsetBig
  self.buttonWidth = self.movWidth - 2*self.offsetBig
  
  self.button1X = self.movX + self.offsetBig
  --self.button2X = self.button1X + self.buttonWidth + self.offsetBig
  self.buttonY = self.movY + self.movHeight + self.offsetBig

  -- scrollBar
  self.scrollWidth = 50
  self.scrollBigHeight = self.lmovHeight - self.fontOffset - self.offsetBig
  
  self.scrollX = self.lmovX + self.lmovWidth - self.scrollWidth - self.offsetBig
  self.scroll1Y = self.lmovY + self.fontOffset
  self.scroll2Y = self.lmovY + self.fontOffset
  self.scrollColor1 = palette[56]
  self.scrollColor2notOver = palette[4]
  self.scrollColor2Over = palette[5]
  self.scrollClicked = false
  
  -- lmoves window
  self.lmovLimitX = self.lmovX + self.offsetBig
  self.lmovLimitY = self.scroll1Y
  self.lmovLimitWidth = self.lmovWidth - self.scrollWidth - 3*self.offsetBig
  self.lmovLimitHeight = self.scrollBigHeight
  self.lmovList = self.monster.knownMoves
  self.lmovWindows = {}
  self.windowHeight = 100
  self.boxSize = 50
  self.boxOffset = (self.windowHeight - self.boxSize)/2
  
  
  
  self.lmovListHeight = self.offsetBig
  for i, movName in ipairs(self.lmovList) do
    local movData = MOV_DEFS[movName] or MOV_DEFS[self.monster.moveToKey[movName]]
    
    local element = movData.element
    local color1, color2
    if element == '' then
      color1 = palette[1]
      color2 = palette[5]
    else
      color1 = traitColors[element].color1
      color2 = traitColors[element].color2
    end
    
    local windowX = self.lmovLimitX + self.offsetBig
    local windowY = self.lmovLimitY + self.offsetBig + (self.windowHeight + self.offsetBig)*(i-1)
    local window = Window{
      x = windowX,
      y = windowY,
      width = self.lmovLimitWidth - 2*self.offsetBig,
      height = self.windowHeight,
      color1 = color1, -- palette[1],
      color2 = color2,--palette[13],
      colorFont = palette[2],
      text1 = movData.name,
      alignment = 'left',
    }

    --local iconsPanel = createPanelIcons(self, windowX, windowY, movData, self.windowHeight, self.lmovLimitWidth - 2*self.offsetBig, 'empty')
    local iconsPanel = createPanelIcons(self, windowX + 250*scale, windowY + 0.5*self.windowHeight, movData, 1, 1, 'extraInfo', 'empty')
    table.insert(window.subelements, iconsPanel)
    
    local descriptionPanel = Panel{
      x = windowX + 740*scale,
      y =  windowY + 10,
      width = 430,
      height = 80,
      value = movData.description,
      offset = 0,
      color1 = {0,0,0,0},
      color2 = {0,0,0,0},
    }

    table.insert(window.subelements, descriptionPanel)

    
    
    window.isTicked = false
    for _, movName2 in pairs(self.movList) do
      if movName == movName2 then
        window.isTicked = true
      end
    end
    window.onClick = function()
      if not window.isTicked then
        if #self.movList < 6 then
          playSound('ok')
          window.isTicked = true
          --table.insert(self.movList, movName)
          local newMoveList = {}
          for j, move in ipairs(self.movList) do
           newMoveList[j+1] = self.movList[j]
          end
          newMoveList[1] = movName
          self.movList = newMoveList
        else
          playSound('clong')
        end
        
      else
        if #self.movList > 1 then
          playSound('out')
          window.isTicked = false
          for i, currentMov in ipairs(self.movList) do
            if currentMov == movName then
              table.remove(self.movList, i)
            end
          end
        else
          playSound('clong')
        end
        
      end
      
      
      
      self:updateCurrentMovements()
    end
    table.insert(self.lmovWindows, window)
    self.lmovListHeight = self.lmovListHeight + self.windowHeight + self.offsetBig
  end
  
  self.scrollToSize = self.lmovListHeight / self.scrollBigHeight
  
  if self.lmovListHeight > self.lmovLimitHeight then
    self.scrollSmallHeight = self.lmovLimitHeight / self.scrollToSize
  else
    self.scrollSmallHeight = self.scrollBigHeight
  end
  
  
  --[[
  self.color1 = colors.green
  self.color2 = {}
  for i = 1, 3 do
    self.color2[i] = 0.8*self.color1[i]
  end
  ]]
  
  self:updateCurrentMovements()
  
  local window = Window{
      x = self.button1X,
      y = self.buttonY,
      width = self.buttonWidth,
      height = self.buttonHeight,
      color1 = palette[12],
      color2 = palette[13],
      colorFont = palette[2],
      colorFont2 = palette[4],
      text1 = 'BACK',
    }
  window.onClick = function()
    playSound('ok')
    self.canInput = false
    self.monster.selectedMoves = self.movList
    local moveDistance = self.width - self.movWidth - 2*self.offsetBig
    local moveTime = 0.5
    local newState = MenuState({
          startOffset = -moveDistance,
          --movWidth = self.movWidth,
          --buttonHeight = self.buttonHeight,
          monster = self.monster,
          extraInfo = self.extraInfo,
        })
    newState.canInput = false
    gStateStack:push(newState)
    newState:move(moveDistance, moveTime)
    self:move(moveDistance, moveTime)
    Timer.after(moveTime, function()
        gStateStack:popPrevious()
        newState.canInput = true
      end)
  end
  table.insert(self.windows,window)
  
  --[[
  table.insert(self.windows, Window{
      x = self.button2X,
      y = self.buttonY,
      width = self.buttonWidth,
      height = self.buttonHeight,
      color = colors.red,
      text1 = 'GO BACK',
    })
    ]]

end

function MovMenuState:update(dt)
  
  if not self.canInput then
    return
  end
  
  --[[
  if love.keyboard.wasPressed('i') then
    self:move()
  end
  ]]
  
  
  local x, y = push:toGame(love.mouse.getPosition())
  if not x then
    x = 0
  end
  if not y then
    y = 0
  end
  
  --self.overWindow = false
  for i, window in ipairs(self.windows) do
    if window:mouseIsOver(x,y) then
      window.shadow = true
      --self.overWindow = true
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
  
  
  local inMovLimits = false
      if x > self.lmovLimitX and x < self.lmovLimitX + self.lmovLimitWidth and y > self.lmovLimitY and y < self.lmovLimitY + self.lmovLimitHeight then
        inMovLimits = true
      end
  
  for i, window in ipairs(self.lmovWindows) do
    if window:mouseIsOver(x,y) and inMovLimits then
      window.shadow = true
      --self.overWindow = true

      if love.mouse.wasPressed(1) then
        window:onClick()
      end
    else
      window.shadow = false
    end
  end
  
  for i, panel in ipairs(self.panels) do
    if panel:mouseIsOver(x,y) and love.mouse.wasPressed(1) then
      playSound('plin')
      panel.dragging = true
      panel.offsetDrag = y - panel.y
      panel.y1to2 = panel.y2 - panel.y
      for _, subelement in pairs(panel.subelements) do
        subelement.y0 = subelement.y
        subelement.offsetDrag = y - subelement.y
      end
    end
    if panel.dragging then
      panel.y = y - panel.offsetDrag
      panel.y2 = panel.y + panel.y1to2
      for _, subelement in pairs(panel.subelements) do
        subelement.y = y - subelement.offsetDrag
      end
      
      if i > 1 then
        --check if y is inferior to the y of the previous panel
        local prevPanel = self.panels[i-1]
        if panel.y < prevPanel.y then
          local distanceBetweenPanels = math.abs(panel.y0 - prevPanel.y0)
          panel.y0 = panel.y0 - distanceBetweenPanels
          prevPanel.y0 = prevPanel.y + distanceBetweenPanels
          for _, subelement in pairs(panel.subelements) do
            subelement.y0 = subelement.y0 - distanceBetweenPanels
          end
          for _, subelement in pairs(prevPanel.subelements) do
            subelement.y0 = subelement.y + distanceBetweenPanels
          end
          Timer.tween(0.02, {
            [prevPanel] = {y = prevPanel.y0, y2 = prevPanel.y0 + panel.y1to2}
          })
          for _, subelement in pairs(prevPanel.subelements) do
            Timer.tween(0.02, {
              [subelement] = {y = subelement.y0}
            })
          end
          swap(self.movList, i, i-1)
          swap(self.panels, i, i-1)
        end
      end
      
      if i < #self.panels then
        --check if y is superior to the y of the next panel
        local nextPanel = self.panels[i+1]
        if panel.y > nextPanel.y then
          local distanceBetweenPanels = math.abs(panel.y0 - nextPanel.y0)
          panel.y0 = panel.y0 + distanceBetweenPanels
          nextPanel.y0 = nextPanel.y - distanceBetweenPanels
          for _, subelement in pairs(panel.subelements) do
            subelement.y0 = subelement.y0 + distanceBetweenPanels
          end
          for _, subelement in pairs(nextPanel.subelements) do
            subelement.y0 = subelement.y - distanceBetweenPanels
          end
          Timer.tween(0.02, {
            [nextPanel] = {y = nextPanel.y0, y2 = nextPanel.y0 + panel.y1to2}
          })
          for _, subelement in pairs(nextPanel.subelements) do
            Timer.tween(0.02, {
              [subelement] = {y = subelement.y0}
            })
          end
          swap(self.movList, i, i+1)
          swap(self.panels, i, i+1)
        end
      end
      
    end
  end
  
  
  
  
  
  if x > self.scrollX and x < self.scrollX + self.scrollWidth and y > self.scroll2Y and y < self.scroll2Y + self.scrollSmallHeight then
    self.mouseOverScroll = true
  else
    self.mouseOverScroll = false
  end
  
  if love.mouse.wasPressed(1) and self.mouseOverScroll then
    self.dragging = true
    self.dragOffset = y - self.scroll2Y
  end
  
  if love.mouse.wasReleased(1) then
    self.dragging = false
    for i, panel in ipairs(self.panels) do
      if panel.dragging then
        playSound('plon')
        panel.dragging = false
        panel.y = panel.y0
        panel.y2 = panel.y + panel.y1to2
        for _, subelement in pairs(panel.subelements) do
          subelement.y = subelement.y0
        end
      end

    end
  end
  
  if self.dragging then
    self.scroll2Y = math.max(self.scroll1Y, math.min(self.scroll1Y + self.scrollBigHeight - self.scrollSmallHeight,y - self.dragOffset))
    local scrollDiff = self.scroll2Y - self.scroll1Y
    for _, window in pairs(self.lmovWindows) do
      window.y = window.y0 - scrollDiff*self.scrollToSize
      for _, subelement in pairs(window.subelements) do
        subelement.y = subelement.y0 - scrollDiff*self.scrollToSize
        if subelement.y2 then
          subelement.y2 = subelement.y20 - scrollDiff*self.scrollToSize
        end
        for _, subelement2 in pairs(subelement.subelements) do
          subelement2.y = subelement2.y0 - scrollDiff*self.scrollToSize
        end
      end
    end
  end
  
  if wheelMovY and wheelMovY ~= 0 then
    local dispBaseLength = 20*scale
    local disp = wheelMovY*dispBaseLength
    self.scroll2Y = math.max(self.scroll1Y, math.min(self.scroll1Y + self.scrollBigHeight - self.scrollSmallHeight, self.scroll2Y - disp/self.scrollToSize))
    for _, window in pairs(self.lmovWindows) do
      window.y = math.max(window.y0 - (self.lmovListHeight - self.lmovLimitHeight), math.min(window.y0, window.y + disp))
      for _, subelement in pairs(window.subelements) do
        subelement.y = math.max(subelement.y0 - (self.lmovListHeight - self.lmovLimitHeight), math.min(subelement.y0, subelement.y + disp))
        if subelement.y2 then
          subelement.y2 = math.max(subelement.y20 - (self.lmovListHeight - self.lmovLimitHeight), math.min(subelement.y20, subelement.y2 + disp))
        end
        for _, subelement2 in pairs(subelement.subelements) do
          subelement2.y = math.max(subelement2.y0 - (self.lmovListHeight - self.lmovLimitHeight), math.min(subelement2.y0, subelement2.y + disp))
        end
      end
    end
    wheelMovY = 0
  end
  
  
  
end



function MovMenuState:render()
  
  love.graphics.setColor(palette[1])
  love.graphics.rectangle('fill', self.backgroundX, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  --[[
  love.graphics.setColor(palette[1])
  love.graphics.rectangle('fill', self.movX, self.movY, self.movWidth, self.movHeight)
  love.graphics.rectangle('fill', self.lmovX, self.lmovY, self.lmovWidth, self.lmovHeight)
  ]]
  
  
  love.graphics.setColor(palette[2])
  love.graphics.setFont(self.font)
  love.graphics.print('Movements', self.movX + self.offset, self.movY + self.offset)
  love.graphics.print('Learnt Movements', self.lmovX + self.offset, self.lmovY + self.offset)
  
  --scroll
  love.graphics.setColor(self.scrollColor1)
  love.graphics.rectangle('fill', self.scrollX, self.scroll1Y, self.scrollWidth, self.scrollBigHeight)
  love.graphics.setColor(self.scrollColor2notOver)
  if self.mouseOverScroll then
    love.graphics.setColor(self.scrollColor2Over)
  else
    love.graphics.setColor(self.scrollColor2notOver)
  end
  love.graphics.rectangle('fill', self.scrollX, self.scroll2Y, self.scrollWidth, self.scrollSmallHeight)
  
  --area for learnt movements
  love.graphics.setColor(palette[2])
  love.graphics.rectangle('fill', self.lmovLimitX, self.lmovLimitY, self.lmovLimitWidth, self.lmovLimitHeight)

  
  self.instinctPanel:render()
  
  for _, panel in pairs(self.panels) do
    if not panel.dragging then
      panel:render()
    end
  end
  
  for _, window in pairs(self.windows) do
    window:render()
  end
  
  love.graphics.stencil(function()
        love.graphics.rectangle("fill", self.lmovLimitX, self.lmovLimitY, self.lmovLimitWidth, self.lmovLimitHeight)
    end, "replace", 1)
  love.graphics.setStencilTest("greater", 0)
  for _, window in pairs(self.lmovWindows) do
    window:render()
    for _, subelement in pairs(window.subelements) do
      subelement:render()
    end
    love.graphics.setColor(palette[3])
    local boxX = window.x + window.width - self.boxOffset - self.boxSize
    local boxY = window.y + self.boxOffset
    love.graphics.rectangle('fill', boxX, boxY, self.boxSize, self.boxSize)
    if window.isTicked then
      local tickOffset = 10
      --love.graphics.setColor(palette[43])
      love.graphics.setColor(palette[43])
      love.graphics.rectangle('fill', boxX + tickOffset, boxY + tickOffset, self.boxSize - 2*tickOffset, self.boxSize - 2*tickOffset)
    end
  end
  love.graphics.setStencilTest()
  
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
    if panel.dragging then
      panel:render()
    end
  end

end

function MovMenuState:updateCurrentMovements()
  self.panels = {}
  local movPanelWidth = self.movWidth - 2*self.offsetBig
  local movPanelHeight = ((self.movHeight - self.fontOffset - self.offsetBig) / #self.movList) - self.offsetBig
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

function MovMenuState:move(value, time)

  --local value = -100
  --local time = 1
  
  Timer.tween(time, {[self] = {movX = self.movX + value, lmovX = self.lmovX + value, lmovLimitX = self.lmovLimitX + value, scrollX = self.scrollX + value, backgroundX = self.backgroundX + value}})

  for _, panel in pairs(self.panels) do
    Timer.tween(time, {[panel] = {x = panel.x + value, x2 = panel.x2 + value}})
    for _, subelement in pairs(panel.subelements) do
      Timer.tween(time, {[subelement] = {x = subelement.x + value}})
    end
  end

  for _, window in pairs(self.windows) do
    Timer.tween(time, {[window] = {x = window.x + value}})
  end

  for _, window in pairs(self.lmovWindows) do
    Timer.tween(time, {[window] = {x = window.x + value}})
    for _, subelement in pairs(window.subelements) do
      Timer.tween(time, {[subelement] = {x = subelement.x + value}})
      if subelement.x2 then
        Timer.tween(time, {[subelement] = {x2 = subelement.x2 + value}})
      end
      for _, subelement2 in pairs(subelement.subelements) do
        Timer.tween(time, {[subelement2] = {x = subelement2.x + value}})
      end
    end
  end
  
  for _, panel in pairs(self.hiddenPanels) do
    Timer.tween(time, {[panel] = {x = panel.x + value, x2 = panel.x2 + value}})
    for _, subelement in pairs(panel.subelements) do
      Timer.tween(time, {[subelement] = {x = subelement.x + value}})
    end
  end
  
  Timer.tween(time, {[self.instinctPanel] = {x = self.instinctPanel.x + value, x2 = self.instinctPanel.x2 + value}})
  
  for _, icon in pairs(self.icons) do
    Timer.tween(time, {[icon] = {x = icon.x + value}})
  end

end
