ChooseTraitState = Class{__includes = BaseState}

function ChooseTraitState:init(def)
  
  self.type = 'ChooseTrait'
  
  self.monster = def.monster or Monster{}
  

  self.traitIcons = {}
  self.organIcons = {}
  self.icons = {}
  self.highlightPanels = {}
  
  self.panel = Panel{
    x = 0.25*VIRTUAL_WIDTH,
    y = 0.25*VIRTUAL_HEIGHT,
    width = 0.5*VIRTUAL_WIDTH,
    height = 0.6*VIRTUAL_HEIGHT,
    offset = offsetBig,
    font = gFonts['large'],
    nLines = 3,
    colorFont = palette[2],
  }
  
  self.traitIconX = 0.37*VIRTUAL_WIDTH
  self.traitIconY = 0.3*VIRTUAL_HEIGHT
  
  self.organIconX = 0.3*VIRTUAL_WIDTH
  self.organIconY = 0.55*VIRTUAL_HEIGHT
  
  local trait1number = math.random(#smallTraitList)
  local trait2number = math.random(#smallTraitList)
  while trait1number == trait2number do
    trait2number = math.random(#smallTraitList)
  end
  
  local trait1 = smallTraitList[trait1number]
  local trait2 = smallTraitList[trait2number]
  
  local traitsChosen = {trait1, trait2}
  
  local iconScale = 10
  
  self.hOffset = 10
  
  for i = 1, 2 do
    local traitName = traitsChosen[i]
    local icon = Icon{
      x = self.traitIconX + 300*(i-1),
      y = self.traitIconY,
      scale = iconScale*2,
      iconNumber = traitIcon[traitName],
      
    }
    icon.name = traitName
    icon.confirmed = false
    table.insert(self.traitIcons, icon)
    table.insert(self.icons, icon)
    
    local hPanel = Panel{
      x = self.traitIconX + 300*(i-1) -self.hOffset,
      y = self.traitIconY - self.hOffset,
      width = 20*iconScale + 2*self.hOffset,
      height = 20*iconScale + 2*self.hOffset,
      color1 = palette[35],
      color2 = palette[35],
    }
    icon.hPanel = hPanel
    table.insert(self.highlightPanels, hPanel)
    
    local hiddenPanel = Panel{
      x = self.traitIconX + 300*(i-1) - 35*iconScale - 2*self.hOffset + 10*iconScale,
      y = self.traitIconY + 2*self.hOffset + 20*iconScale,
      width = 70*iconScale + 2*self.hOffset,
      height = 25*iconScale + 2*self.hOffset,
      offset = offsetBig,
      value = elementPassives[traitName],
      color1 = traitColors[traitName].color1,
      color2 = traitColors[traitName].color2,
      nLines = 7,
    }
    icon.hiddenPanel = hiddenPanel
    
    
    
  end
  
  for i = 1, 5 do
    local organName = organList[i]
    local icon = Icon{
      x = self.organIconX + 168*(i-1),
      y = self.organIconY,
      scale = iconScale,
      iconNumber = organIcon[organName],
      
    }
    icon.name = organName
    icon.confirmed = false
    if self.monster.organs[organName].traitSlot2 == nil then
      table.insert(self.organIcons, icon)
      table.insert(self.icons, icon)
    end
    
    
    
    local hPanel = Panel{
      x = self.organIconX + 168*(i-1) -self.hOffset,
      y = self.organIconY - self.hOffset,
      width = 10*iconScale + 2*self.hOffset,
      height = 10*iconScale + 2*self.hOffset,
      color1 = palette[35],
      color2 = palette[35],
    }
    table.insert(self.highlightPanels, hPanel)
    
    icon.hPanel = hPanel
  end
  
  self.nookIcon = Icon{
    x = 0.475*VIRTUAL_WIDTH,
    y = 0.7*VIRTUAL_HEIGHT,
    scale = iconScale,
    iconNumber = 343,
  }
  
  self.okIcon = Icon{
    x = 0.475*VIRTUAL_WIDTH,
    y = 0.7*VIRTUAL_HEIGHT,
    scale = iconScale,
    iconNumber = 344,
  }
  
  self.okIcon.onClick = function()
    self.monster:addTrait(self.traitConfirmed,self.organConfirmed)
      local newState = MenuState({
            monster = self.monster,
          })
      gStateStack:clear()
      gStateStack:push(newState)
  end
  
  
  
  self.bothConfirmed = false
  
  
  
  
  
  

end


function ChooseTraitState:update(dt)
  
  local x, y = push:toGame(love.mouse.getPosition())
  
  for i, icon in ipairs(self.traitIcons) do
    if icon:mouseIsOver(x,y) then
      icon.isMouseOver = true
      icon.hPanel.selected = true
      if love.mouse.wasPressed(1) then
        self.traitConfirmed = icon.name
        icon.confirmed = not icon.confirmed
        if icon.confirmed then
          playSound('ok')
        else
          playSound('out')
        end
        for j, icon2 in ipairs(self.traitIcons) do
          if j ~= i then
            icon2.confirmed = false
          end
        end
      end
    else
      icon.isMouseOver = false
      icon.hPanel.selected = false
    end
    
  end
  
  for i, icon in ipairs(self.organIcons) do
    if icon:mouseIsOver(x,y) then
      icon.hPanel.selected = true
      if love.mouse.wasPressed(1) then
        self.organConfirmed = icon.name
        icon.confirmed = not icon.confirmed
        if icon.confirmed then
          playSound('ok')
        else
          playSound('out')
        end
        for j, icon2 in ipairs(self.organIcons) do
          if j ~= i then
            icon2.confirmed = false
          end
        end
      end
    else
      icon.hPanel.selected = false
    end
  end
  
  for _, icon in pairs(self.icons) do
    if icon.confirmed then
      icon.hPanel.selected = true
    end
  end
  
  
  
  local traitConfirmed = false
  local organConfirmed = false
  
  for _, icon in pairs(self.traitIcons) do
    if icon.confirmed then
      traitConfirmed = true
    end
  end
  
  for _, icon in pairs(self.organIcons) do
    if icon.confirmed then
      organConfirmed = true
    end
  end
  
  if traitConfirmed and organConfirmed then
    self.bothConfirmed = true
  else
    self.bothConfirmed = false
  end
  
  
  if self.okIcon:mouseIsOver(x,y) and self.bothConfirmed and love.mouse.wasPressed(1) then
    playSound('megaok')
    self.okIcon.onClick()
  end
  
  
  
end




function ChooseTraitState:render()


  self.panel:render()

  for _, hPanel in pairs(self.highlightPanels) do
    if hPanel.selected then
      hPanel:render()
    end
  end
  
  
  
  
  for _, icon in pairs(self.icons) do
    icon:render()
  end
  
  
  if self.bothConfirmed then
    self.okIcon:render()
  else
    self.nookIcon:render()
  end
  
  
  for _, icon in pairs(self.traitIcons) do
    if icon.isMouseOver and icon.hiddenPanel then
      icon.hiddenPanel:render()
    end
  end
  
  
  
  
  

end
