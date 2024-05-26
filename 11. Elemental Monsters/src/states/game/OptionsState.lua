OptionsState = Class{__includes = BaseState}

function OptionsState:init(def)
  
  self.type = 'Options'
  
  self.mainPanel = Panel{
    x = 0.23*VIRTUAL_WIDTH,
    y = 0.35*VIRTUAL_HEIGHT,
    width = 0.54*VIRTUAL_WIDTH,
    height = 0.3*VIRTUAL_HEIGHT,
    offset = offsetBig,
  }
  
  self.windows = {}
  self.panels = {}
  self.icons = {}
  
  self.mainWindow = Window{
    x = 0.26*VIRTUAL_WIDTH,
    y = 0.52*VIRTUAL_HEIGHT,
    width = 0.15*VIRTUAL_WIDTH,
    height = 0.1*VIRTUAL_HEIGHT,
    color1 = palette[12],
    color2 = palette[13],
    colorFont = palette[2],
    colorFont2 = palette[4],
    font = gFonts['medium'],
    text1 = 'GO BACK',
    onClick = function()
      playSound('out')
      gStateStack:pop()
      end
  }
  table.insert(self.windows, self.mainWindow)
  
  self.helpWindow = Window{
    x = 0.425*VIRTUAL_WIDTH,
    y = 0.52*VIRTUAL_HEIGHT,
    width = 0.1*VIRTUAL_WIDTH,
    height = 0.1*VIRTUAL_HEIGHT,
    color1 = palette[40],
    color2 = palette[41],
    colorFont = palette[2],
    colorFont2 = palette[4],
    font = gFonts['medium'],
    text1 = 'HELP',
    onClick = function()
      playSound('ok')
      gStateStack:push(AboutState({}))
      end
  }
  table.insert(self.windows, self.helpWindow)
  
  self.closeWindow = Window{
    x = 0.54*VIRTUAL_WIDTH,
    y = 0.52*VIRTUAL_HEIGHT,
    width = 0.2*VIRTUAL_WIDTH,
    height = 0.1*VIRTUAL_HEIGHT,
    color1 = palette[28],
    color2 = palette[29],
    colorFont = palette[2],
    colorFont2 = palette[4],
    font = gFonts['medium'],
    text1 = 'EXIT GAME',
    onClick = function()
      playSound('out')
      love.event.quit()
      end
  }
  table.insert(self.windows, self.closeWindow)
  
  local nameX = 0.28*VIRTUAL_WIDTH --0.38*VIRTUAL_WIDTH
  local minusX = 0.46*VIRTUAL_WIDTH --0.56*VIRTUAL_WIDTH
  local valueX = 0.47*VIRTUAL_WIDTH --0.57*VIRTUAL_WIDTH
  local plusX = 0.515*VIRTUAL_WIDTH --0.615*VIRTUAL_WIDTH
  
  local iconScale = 3
  
  local yValues = {music = 0.38*VIRTUAL_HEIGHT, effect = 0.44*VIRTUAL_HEIGHT}
  local names = {music = 'Music Volume:', effect = 'Effects Volume:'}
  
  local options = {'music', 'effect'}
  for i, option in ipairs(options) do
    local namePanel = Panel{
      x = nameX,
      y = yValues[option],
      width = 300,
      height = 60,
      font = gFonts['small'],
      value = names[option],
      nLines = 1,
      color2 = palette[1]
      }
    table.insert(self.panels, namePanel)
    
    local valuePanel = Panel{
      x = valueX,
      y = yValues[option],
      width = 100,
      height = 60,
      font = gFonts['small'],
      value = volumeValues[option],
      nLines = 1,
      color2 = palette[1]
      }
    table.insert(self.panels, valuePanel)
    
    local minusIcon = Icon{
      x = minusX,
      y = yValues[option] + 13,
      scale = iconScale,
      iconNumber = 348,
    }
    minusIcon.hoverChange = true
    minusIcon.onClick = function() valuePanel.value = self:changeVolume(option, '-') end
    table.insert(self.icons, minusIcon)
    
    local plusIcon = Icon{
      x = plusX,
      y = yValues[option] + 13,
      scale = iconScale,
      iconNumber = 349,
    }
    plusIcon.hoverChange = true
    plusIcon.onClick = function() valuePanel.value = self:changeVolume(option, '+') end
    table.insert(self.icons, plusIcon)
    
  end
  
  
  local optionX = 0.55*VIRTUAL_WIDTH
  local toggleX = 0.7*VIRTUAL_WIDTH
  
  local fullscreenPanel = Panel{
      x = optionX,
      y = 0.38*VIRTUAL_HEIGHT,
      width = 300,
      height = 60,
      font = gFonts['small'],
      value = 'Fullscreen:',
      nLines = 1,
      color2 = palette[1]
      }
  table.insert(self.panels, fullscreenPanel)
  
  local fpsPanel = Panel{
      x = optionX,
      y = 0.44*VIRTUAL_HEIGHT,
      width = 300,
      height = 60,
      font = gFonts['small'],
      value = 'FPS:',
      nLines = 1,
      color2 = palette[1]
      }
  table.insert(self.panels, fpsPanel)
  
  local fullscreenToggle = Icon{
      x = toggleX,
      y = 0.38*VIRTUAL_HEIGHT + 13,
      scale = iconScale,
      iconNumber = 343,
    }
    fullscreenToggle.toggled = love.window.getFullscreen()
    
  if fullscreenToggle.toggled then
    fullscreenToggle.iconNumber = 344
  end
    
  fullscreenToggle.onClick = function()
    love.window.setFullscreen(not love.window.getFullscreen())
      fullscreenToggle.toggled = not fullscreenToggle.toggled
      if fullscreenToggle.toggled then
        fullscreenToggle.iconNumber = 344
      else
        fullscreenToggle.iconNumber = 343
      end
    end
  table.insert(self.icons, fullscreenToggle)
  
  local fpsToggle = Icon{
      x = toggleX,
      y = 0.44*VIRTUAL_HEIGHT + 13,
      scale = iconScale,
      iconNumber = 343,
    }
    fpsToggle.toggled = showFPS
  if fpsToggle.toggled then
    fpsToggle.iconNumber = 344
  end
    
  fpsToggle.onClick = function()
      fpsToggle.toggled = not fpsToggle.toggled
      showFPS = not showFPS
      if fpsToggle.toggled then
        fpsToggle.iconNumber = 344
      else
        fpsToggle.iconNumber = 343
      end
    end
  table.insert(self.icons, fpsToggle)
  
  
  
  
  

end


function OptionsState:update(dt)
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
    
    for _, icon in pairs(self.icons) do
      if icon:mouseIsOver(x,y)  then
        if icon.hoverChange then
          icon.iconNumber = icon.iconNumber0 + 5
        end
        if love.mouse.wasPressed(1) then
          icon:onClick()
        end
      else
        if icon.hoverChange then
          icon.iconNumber = icon.iconNumber0
        end
      end
      
    end
    
end




function OptionsState:render()
  self.mainPanel:render()
  
  for _, window in pairs(self.windows) do
    window:render()
  end
  
  
  for _, panel in pairs(self.panels) do
    panel:render()
  end
  
  for _, icon in pairs(self.icons) do
    icon:render()
  end
  
end


function OptionsState:changeVolume(option, direction)
  
  local value = volumeValues[option]

  if direction == '+' then
    value = value + 1
  elseif direction == '-' then
    value = value - 1
  end
  
  local noClampValue = value
  
  value = clamp(value, 0, 10)
  
  volumeValues[option] = value

  
  for soundName, sound in pairs(gSounds) do
    if soundType[soundName] == option then
      sound:setVolume(value/10)
    end
  end
  
  if noClampValue == value then
    playSound('clang')
  else
    playSound('clong')
  end
  
  
  return value
  
  
end

