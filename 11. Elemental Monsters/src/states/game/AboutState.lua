AboutState = Class{__includes = BaseState}

function AboutState:init(def)
  
  self.type = 'About'
  
  self.mainPanel = Panel{
    x = 0.2*VIRTUAL_WIDTH,
    y = 0.15*VIRTUAL_HEIGHT,
    width = 0.6*VIRTUAL_WIDTH,
    height = 0.75*VIRTUAL_HEIGHT,
    offset = offsetBig,
    font = gFonts['small'],
    value = instructions[1],
    nLines = 22,
  }
  
  self.mainPanel2 = Panel{
    x = 0.3*VIRTUAL_WIDTH,
    y = 0.66*VIRTUAL_HEIGHT,
    width = 0.4*VIRTUAL_WIDTH,
    height = 80,
    offset = offsetBig,
    color2 = palette[1],
    font = gFonts['small'],
    value = instructions[10],
  }
  
  self.mainWindow = Window{
    x = 0.45*VIRTUAL_WIDTH,
    y = 0.75*VIRTUAL_HEIGHT,
    width = 0.1*VIRTUAL_WIDTH,
    height = 0.1*VIRTUAL_HEIGHT,
    color1 = palette[12],
    color2 = palette[13],
    colorFont = palette[2],
    colorFont2 = palette[4],
    font = gFonts['medium'],
    text1 = 'BACK',
    onClick = function()
      playSound('out')
      gStateStack:pop()
      end
  }
  
  self.panels = {}
  for i = 2, 9 do
    local panel = Panel{
      x = 0.3*VIRTUAL_WIDTH,
      y = 0.42*VIRTUAL_HEIGHT,
      width = 0.4*VIRTUAL_WIDTH,
      height = 0.22*VIRTUAL_HEIGHT,
      value = instructions[i],
      color2 = palette[1],
      }
    table.insert(self.panels, panel)
  end
  
  self.instruction = 1
  
  local iconScale = 10
  
  self.icons = {}
  
  self.prevIcon = Icon{
    x = 0.225*VIRTUAL_WIDTH,
    y = 0.47*VIRTUAL_HEIGHT,
    scale = iconScale,
    iconNumber = 346,
    }
  
  self.nextIcon = Icon{
    x = 0.725*VIRTUAL_WIDTH,
    y = 0.47*VIRTUAL_HEIGHT,
    scale = iconScale,
    iconNumber = 347,
  }
  
  self.prevIcon.onClick = function()
    self.instruction = self.instruction - 1
    local prev = self.instruction
    self.instruction = clamp(self.instruction, 1, 8)
    if self.instruction == prev then
      playSound('clang')
    end
    
  end
  
  self.nextIcon.onClick = function()
    self.instruction = self.instruction + 1
    local prev = self.instruction
    self.instruction = clamp(self.instruction, 1, 8)
    if self.instruction == prev then
      playSound('clang')
    end
  end
  
  table.insert(self.icons, self.prevIcon)
  table.insert(self.icons, self.nextIcon)
  
end


function AboutState:update(dt)
  
  local x, y = push:toGame(love.mouse.getPosition())
  
    if self.mainWindow:mouseIsOver(x,y) then
      self.mainWindow.shadow = true
      if love.mouse.wasPressed(1) then
        self.mainWindow:onClick()
      end
    else
      self.mainWindow.shadow = false
    end
    
  for _, icon in pairs(self.icons) do
    if icon:mouseIsOver(x, y) then
      icon.iconNumber = icon.iconNumber0 + 5
      if love.mouse.wasPressed(1) then
        icon:onClick()
      end
    else
      icon.iconNumber = icon.iconNumber0
    end
    
  end
  
    
    --[[
    if self.instruction ~= 1 then
      self.prevIcon:render()
    end
    
    if self.instruction ~= 7 then
      self.nextIcon:render()
    end
    ]]
    
    
end




function AboutState:render()
  self.mainPanel:render()
  self.mainPanel2:render()
  self.mainWindow:render()
  
  for i, panel in ipairs(self.panels) do
    if i == self.instruction then
      panel:render()
    end
  end
  
  if self.instruction ~= 1 then
    self.prevIcon:render()
  end
  
  if self.instruction ~= 8 then
    self.nextIcon:render()
  end


end