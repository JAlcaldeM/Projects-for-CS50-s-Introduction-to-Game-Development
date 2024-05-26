StartState = Class{__includes = BaseState}

function StartState:init(def)
    self.type = 'Start'
    
    playSound('battleTheme')
    
    self.bars = {}
    self.movements = {}
    self.panels = {}
    self.windows = {}
    self.monsters = {}
    self.movCoordinates = {}
    
    self.trainer1 = {}
    --self.trainer2 = {}
    self.trainer2 = false
    
    self.offset = 10*scale
    
    self.font = gFonts['medium']
    self.fontOffset = self.font:getHeight() + 2*self.offset
    
    self.extraInfo = def.extraInfo or false
    
    self.ffMode = false
    self.blockInput = false
    
    self.monster1 = def.monster or Monster{
  }

  --self.monster1.sprite = Chimera(10000, self.monster1.y, false, self.monster1.seed, 16, 6)
  
  
    --self.monster1.name = 'NAME1'

    self.combatColors = {
      sky = palette[1], --palette[7],
      grass = palette[1], --palette[44],
      monster1 = palette[2],
      monster2 = palette[2],
      trainer1 = palette[20],
      trainer2 = palette[20],
      instruction = palette[2],
      --monsterInfo = palette[4],
      monsterInfo = {0,0,0,0}, 
      log = palette[3],
    }
    
    
    self.movx = 0
    self.movy = 0
    self.movWidth = 530 --0.3*VIRTUAL_WIDTH
    self.movHeight = VIRTUAL_HEIGHT
    
    self.nInstructions = #approachNames
    self.instructionsHeight = VIRTUAL_HEIGHT/self.nInstructions
    self.instructionsWidth = self.instructionsHeight

    
    self.combatWidth = VIRTUAL_WIDTH - self.movWidth - self.instructionsWidth
    self.combatHeight = 700
    

    self.logHeight = (VIRTUAL_HEIGHT - self.combatHeight)/2
    self.trainerHeight = self.logHeight
    self.trainerWidth = self.trainerHeight
    self.log1Width = self.combatWidth - self.trainerWidth
    if self.trainer2 then
      self.log2Width = self.log1Width
    else
      self.log2Width = self.log1Width + self.logHeight
    end
    
    
    self.logx = self.movWidth
    self.log1y = self.logHeight + self.combatHeight
    self.log2y = 0
    
    self.trainerx = self.logx + self.log1Width
    self.trainer1y = self.log1y
    self.trainer2y = self.log2y
    
    self.combatx = self.movWidth
    self.combaty = self.logHeight
    
    self.instructionsx = self.combatx + self.combatWidth
    self.instructionsy = 0
    
    self.barHeight = 0.05*self.combatHeight
    self.barWidth = 0.3*self.combatWidth
    self.barOffset = 0.5*self.barHeight
    
    self.bar1x = self.combatx + 0.45*self.combatWidth
    self.bar1y = self.combaty + 0.75*self.combatHeight
    
    self.bar2x = self.combatx + 0.05*self.combatWidth 
    self.bar2y = self.combaty + 0.05*self.combatHeight
    
    self.mind1x = self.combatx + 0.01*self.combatWidth
    self.mind1y = self.combaty + 0.45*self.combatHeight
    self.mind2x = self.combatx + 0.7*self.combatWidth
    self.mind2y = self.combaty + 0.01*self.combatHeight
    self.mindWidth = 70
    self.mindHeight = 350
    
    
    self.instructionWidth = 0.14*self.combatWidth
    self.instructionHeight = 0.14*self.combatHeight
    
    self.instructionx = self.trainerx + 0.5*self.trainerWidth - 0.5*self.instructionWidth
    self.instruction1y = self.trainer1y - self.instructionHeight - 0.5*self.instructionHeight
    self.instruction2y = self.trainer2y + self.trainerHeight + 0.5*self.instructionHeight
    
    self.instruction1iconx = self.instructionx + 0.3*self.instructionWidth - 25*scale
    self.instruction2iconx = self.instructionx + 0.5*self.instructionWidth - 25*scale
    self.instruction1icony = self.instruction1y + 0.5*self.instructionHeight - 25*scale
    self.instruction2icony = self.instruction2y + 0.5*self.instructionHeight - 25*scale
    
    self.instructionIcon = Icon{
      x = self.instruction1iconx - 50,
      y = self.instruction1icony - 30,
      scale = 15,
      iconNumber = 345,
      
      
      }
    

    
    --self.monster1Par = {x = self.combatx + 0.15*self.combatWidth, y = self.combaty + 0.8*self.combatHeight, size = 0.4*self.combatHeight}
    --self.monster2Par = {x = self.combatx + 0.6*self.combatWidth, y = self.combaty + 0.4*self.combatHeight, size = 0.2*self.combatHeight}
    
    self.monster1spritex = self.combatx + 0.25*self.combatWidth
    self.monster1spritey = self.combaty + 1*self.combatHeight
    self.monster2spritex =self.combatx + 0.6*self.combatWidth
    self.monster2spritey = self.combaty + 0.35*self.combatHeight
    
   
    
    self.monster1spriteParams = {power = self.monster1.totalPower, monster = self.monster1}
    self.monster1.sprite = Chimera(self.monster1spritex, self.monster1spritey, false, self.monster1.seed, 10, 10, self.monster1spriteParams)

    self.monster1.width = 0.4*self.combatHeight
    self.monster1.height = 0.4*self.combatHeight
    self.monster1.color = self.combatColors.monster1
    self.monster1.origin = 'center'
    self.monster1.regenSP = 1
    
    self.movList = self.monster1.selectedMoves
    
    self.nMovements = #self.movList
    

    for i = 1, self.nMovements do
      createMovementPanel{
        movName = self.movList[i],
        menuState = self,
        i = i,
        extraInfo = self.extraInfo,
        nPanels = #self.movList,
      }
    end
    createInstinctPanel(self)
  
    self.HPbar1 = ProgressBar{
      x = self.bar1x,
      y = self.bar1y,
      width = self.barWidth,
      height = self.barHeight,
      color = palette[43],
      colorBackground =  palette[1],
      value = self.monster1.stats.currentHP.value,
      max = self.monster1.stats.maxHP.value,
      border = true,
      partitions = 40,
    }
    
    self.monster1.HPbar = self.HPbar1
    
    self.SPbar1 = ProgressBar{
      x = self.bar1x,
      y = self.bar1y + (self.barHeight + self.barOffset) + self.barHeight/4,
      width = self.barWidth,
      height = self.barHeight/2,
      color = palette[35],
      colorBackground = palette[1],
      value = self.monster1.currentSP,
      max = self.monster1.maxSP,
      partitions = 40,
    }
    self.monster1.SPbar = self.SPbar1
    
    self.SPbar1b = ProgressBar{
      x = self.bar1x,
      y = self.bar1y + (self.barHeight + self.barOffset),
      width = self.barWidth,
      height = self.barHeight,
      color = palette[35],
      colorBackground = {0,0,0,0},
      value = self.monster1.currentSP,
      max = self.monster1.maxSP,
      border = true,
      partitions = 10,
    }
    self.monster1.SPbarb = self.SPbar1b
    
    self.monsterMind1 = MonsterMind{
      x = self.mind1x + 10*scale,
      y = self.mind1y + 10*scale,
      size = 50*scale
    }
    self.monster1.mind = self.monsterMind1
    
    self.statusBar1 = StatusBar{
      x = self.bar1x,
      y = self.bar1y + 2*(self.barHeight + self.barOffset),
      size = 50*scale,
      monster = self.monster1
    }
    self.monster1.statusBar = self.statusBar1
    
    table.insert(self.monsters, self.monster1)
    table.insert(self.bars, self.HPbar1)
    table.insert(self.bars, self.SPbar1)
    table.insert(self.bars, self.SPbar1b)
    table.insert(self.bars, self.monsterMind1)
    table.insert(self.bars, self.statusBar1)
    
    
   
    
    
    self.monster2 = Monster{
      x = self.monster2spritex,
      y = self.monster2spritey,
    }
    
    self:increaseMonsterPower(encounterNumber)
    
    

    self.monster2spriteParams = {power = self.monster2.totalPower, monster = self.monster2}
    self.monster2.sprite = Chimera(self.monster2.x, self.monster2.y, true, nil, 10, 5, self.monster2spriteParams)
    self.monster2.name = self.monster2.sprite.name
    self.monster2.seed = self.monster2.sprite.seed
    
    
    self.monster2.width = 0.2*self.combatHeight
    self.monster2.height = 0.2*self.combatHeight
    self.monster2.color = self.combatColors.monster2
    self.monster2.origin = 'center'
    self.monster2.regenSP = 1
    --self.monster2.name = 'NAME2'
    
    
    --self.monster2.movements = self.movList
    if peacefulEnemy then
      self.monster2.selectedMoves = {}
    end
    
    self.HPbar2 = ProgressBar{
      x = self.bar2x,
      y = self.bar2y,
      width = self.barWidth,
      height = self.barHeight,
      color = palette[43],
      colorBackground = palette[1],
      value = self.monster2.stats.currentHP.value,
      max = self.monster2.stats.maxHP.value,
      border = true,
      partitions = 40,
    }
    self.monster2.HPbar = self.HPbar2
    
    self.SPbar2 = ProgressBar{
      x = self.bar2x,
      y = self.bar2y + (self.barHeight + self.barOffset) + self.barHeight/4,
      width = self.barWidth,
      height = self.barHeight/2,
      color = palette[35],
      colorBackground = palette[1],
      value = self.monster2.currentSP,
      max = self.monster2.maxSP,
      partitions = 40,
    }
    self.monster2.SPbar = self.SPbar2
    
    self.SPbar2b = ProgressBar{
      x = self.bar2x,
      y = self.bar2y + (self.barHeight + self.barOffset),
      width = self.barWidth,
      height = self.barHeight,
      color = palette[35],
      colorBackground = {0,0,0,0},
      value = self.monster2.currentSP,
      max = self.monster2.maxSP,
      border = true,
      partitions = 10
    }
    self.monster2.SPbarb = self.SPbar2b
    
    self.monsterMind2 = MonsterMind{
      x = self.mind2x + 10*scale,
      y = self.mind2y + 10*scale,
      size = 50*scale
    }
    self.monster2.mind = self.monsterMind2
    
    self.statusBar2 = StatusBar{
      x = self.bar2x,
      y = self.bar2y + 2*(self.barHeight + self.barOffset),
      size = 50*scale,
      monster = self.monster2
    }
    self.monster2.statusBar = self.statusBar2
      
    table.insert(self.monsters, self.monster2)
    table.insert(self.bars, self.HPbar2)
    table.insert(self.bars, self.SPbar2)
    table.insert(self.bars, self.SPbar2b)
    table.insert(self.bars, self.monsterMind2)
    table.insert(self.bars, self.statusBar2)
    
    for _, movement in pairs(self.movements) do
      movement.attacker = self.monster1
      movement.defender = self.monster2
    end
    
    self.monster1.opponent = self.monster2
    self.monster2.opponent = self.monster1
    
    self.trainerWindowSize = 0.2*self.combatWidth
    
    
    
    
    self.monsterInfoWidth = 240*scale
    self.monsterInfoHeight = 180*scale
    self.monsterInfox = self.combatx + 0.78*self.combatWidth
    self.monster1Infoy = self.combaty + 0.5*self.combatHeight
    self.monster2Infoy = self.combaty + 0.2*self.combatHeight
    local panelOffset = 10*scale
    
    self.monster1InfoPanel = Panel{
      x = self.monsterInfox,
      y = self.monster1Infoy,
      width = self.monsterInfoWidth,
      height = self.monsterInfoHeight,
      offset = panelOffset,
    }
    table.insert(self.panels, self.monster1InfoPanel)
    self.monster1.panelInfo = self.monster1InfoPanel
    
    self.monster1InfoPanel.subelements = {}
    local textHeight = gFonts['small']:getHeight()
    
    local name1 = {
      text = self.monster1.name,
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster1Infoy + 2*panelOffset,
      isText = true,
      alignment = 'center',
    }
    self.monster1InfoPanel.subelements.name = name1
    
    local iconScale = 4
    for i, trait in ipairs(self.monster1.traits) do
      local icon = Icon{
        x = self.monsterInfox + 2*panelOffset  + (10*iconScale + panelOffset)*(i-1),
        y = self.monster1Infoy + 2*panelOffset + textHeight,
        scale = iconScale,
        iconNumber = traitIcon[trait],
      }
      self.monster1InfoPanel.subelements['icon'..i] = icon
    end
    
    
    local power1 = {
      text = 'PW:',
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster1Infoy + 3*panelOffset + textHeight + 10*iconScale,
      isText = true,
    }
    self.monster1InfoPanel.subelements.power = power1
    
    local powerValue1 = {
      text = self.monster1.totalPower,
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster1Infoy + 3*panelOffset + textHeight + 10*iconScale,
      isText = true,
      alignment = 'right',
    }
    self.monster1InfoPanel.subelements.powerValue = powerValue1
    
    local HP1 = {
      text = 'HP',
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster1Infoy + 3*panelOffset + 2*textHeight + 10*iconScale,
      isText = true,
    }
    self.monster1InfoPanel.subelements.HP = HP1
    
    local HPValue1 = {
      text = self.monster1.stats.currentHP.value..'/'..self.monster1.stats.maxHP.value,
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster1Infoy + 3*panelOffset + 2*textHeight + 10*iconScale,
      isText = true,
      alignment = 'right',
    }
    self.monster1InfoPanel.subelements.HPValue = HPValue1
    
    
    
    self.monster2InfoPanel = Panel{
      x = self.monsterInfox,
      y = self.monster2Infoy,
      width = self.monsterInfoWidth,
      height = self.monsterInfoHeight,
      offset = panelOffset,
    }
    table.insert(self.panels, self.monster2InfoPanel)
    self.monster2.panelInfo = self.monster2InfoPanel
    
    self.monster2InfoPanel.subelements = {}
    
    local name2 = {
      text = self.monster2.name,
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster2Infoy + 2*panelOffset,
      isText = true,
      alignment = 'center',
    }
    self.monster2InfoPanel.subelements.name = name2
    
    for i, trait in ipairs(self.monster2.traits) do
      local icon = Icon{
        x = self.monsterInfox + 2*panelOffset  + (10*iconScale + panelOffset)*(i-1),
        y = self.monster2Infoy + 2*panelOffset + textHeight,
        scale = iconScale,
        iconNumber = traitIcon[trait],
      }
      self.monster2InfoPanel.subelements['icon'..i] = icon
    end
    
    
    local power2 = {
      text = 'PW:',
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster2Infoy + 3*panelOffset + textHeight + 10*iconScale,
      isText = true,
    }
    self.monster2InfoPanel.subelements.power = power2
    
    local powerValue2 = {
      text = self.monster2.totalPower,
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster2Infoy + 3*panelOffset + textHeight + 10*iconScale,
      isText = true,
      alignment = 'right',
    }
    self.monster2InfoPanel.subelements.powerValue = powerValue2
    
    local HP2 = {
      text = 'HP',
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster2Infoy + 3*panelOffset + 2*textHeight + 10*iconScale,
      isText = true,
    }
    self.monster2InfoPanel.subelements.HP = HP2
    
    local HPValue2 = {
      text = self.monster2.stats.currentHP.value..'/'..self.monster2.stats.maxHP.value,
      x = self.monsterInfox + 2*panelOffset,
      y = self.monster2Infoy + 3*panelOffset + 2*textHeight + 10*iconScale,
      isText = true,
      alignment = 'right',
    }
    self.monster2InfoPanel.subelements.HPValue = HPValue2
    
    
    
    
    
    
    for i, approach in ipairs(approachNames) do
      local window = Window{
        color = approaches[approach].color,
        x = self.instructionsx,
        y = self.instructionsy + self.instructionsWidth*(i-1),
        width = self.instructionsWidth,
        height = self.instructionsHeight,
        color1 = approachColors[approach].color1,
        color2 = approachColors[approach].color2,
      }
      window.approach = approach
      window.icon = true
      window.onClick = function()
        if self.monster1.status.instructionCD then
          self.instruction1 = approach
          self.instructionCD = true
        else
          self.instructionCD = false
          playSound('plon')
          local time = 1
          self.instruction1 = approach
          if not checkStatus(self.monster1, 'name', 'focused') then
            gainStatus(self.monster1, 'instructed', time*self.monster1.totalPower/100, function()
                self.instruction1 = nil
                gainApproach(self.monster1, approach, true)
                gainStatus(self.monster1, 'instructionCD', 5*time*self.monster1.totalPower/100, function()
                    self.instructionCD = false
                    self.instruction1 = nil
                    end)
              end)
          end
        end
        
        
      end
        
        
      table.insert(self.windows, window)
    end
    
    local panel1 = Panel{
      x = self.logx,
      y = self.log1y,
      width = self.log1Width,
      height = self.logHeight,
      offset = 10,
    }
    table.insert(self.panels, panel1)
    
    local panel2 = Panel{
      x = self.logx,
      y = self.log2y,
      width = self.log2Width,
      height = self.logHeight,
      offset = 10,
    }
    table.insert(self.panels, panel2)
    
    
    logSystem = LogSystem{
      logx = self.logx,
      log1y = self.log1y,
      log2y = self.log2y,
      logHeight = self.logHeight,
      log1Width = self.log1Width,
      log2Width = self.log2Width,
      monster1 = self.monster1,
      monster2 = self.monster2,
    }

    local decisionPower1 = decisionTime
    local decisionPower2 = decisionTime
    
    
    --print(0.05*self.monster1.totalPower)
    --print(decisionPower1, decisionPower2)
    local time = 5
    
    for i, trait in ipairs(self.monster1.traits) do
      gainStatus(self.monster1, trait, time, nil, {
          counter = 1,
          stat = determineTraitStat(self.monster1, trait),
          organs = determineTraitOrgans(self.monster1, trait),
          })
    end
    for i, trait in ipairs(self.monster2.traits) do
      gainStatus(self.monster2, trait, time, nil, {
          counter = 1,
          stat = determineTraitStat(self.monster2, trait),
          organs = determineTraitOrgans(self.monster2, trait),
          })
    end
    
    --function gainStatus(monster, statusName, durationPower, onEnd, statusPrev)

    gainStatus(self.monster1, 'subconscious', decisionPower1)
    gainStatus(self.monster2, 'subconscious', decisionPower2)
    
end

function StartState:update(dtReal)
  
  
  local ffMult = 1
  if self.ffMode then
    ffMult = 2
  end
  
  
  local dt = dtReal * dtMult * ffMult
  
  for i, monster in ipairs(self.monsters) do
    local statusIndexRemoved = {}
    --[[
    for k, status in ipairs(monster.status) do
      
      
      
      
      
      
      local powerMult
      local statusMult = monster.statusMultiplyers[status.name] or 1
      if statusToStats[status.name] == 'neutral' then
        powerMult = monster.totalPower/50 * statusMult
      end




      status.power = status.power - dt * powerMult
      status.radians = 2*math.pi * (status.power0 - status.power)/status.power0
      if status.power <= 0 then
        if status.onEnd then
          status.onEnd()
        end
        table.insert(statusIndexRemoved, k)
      end
    end
    for i = #statusIndexRemoved, 1, -1 do
      table.remove(monster.status,statusIndexRemoved[i])
    end
    ]]
    for k = #monster.statusList, 1, -1 do
      local statusName = monster.statusList[k]
      local durationMult
      local statusMult = monster.statusMultiplyers[statusName] or 1
      local statusInfo = monster.status[statusName]
      
      if statusInfo.counter then
        
        --if statusInfo.capped == nil then
        if statusInfo.counter < monster.counterLimit then
          local power = 0
          for _, organName in pairs(statusInfo.organs) do
            local organInfo = monster.organs[organName]
            --print(organInfo.powerTypeValues[statusInfo.stat])
            power = power + organInfo.powerTypeValues[statusInfo.stat]
          end
          --durationMult = 1000 / (power * 0.2*monster.totalPower)
          --durationMult = /power
          --print(statusInfo.duration,  0.2*monster.totalPower/power, monster.totalPower, power)
          --durationMult = 50/monster.totalPower * power * statusMult
          durationMult = 0.25 * monster.totalPower/power
        end
        
        
        
        
      else
        if statusToStats[statusName] == 'neutral' then
          durationMult = 50/monster.totalPower * statusMult
        else
          local statName = statusToStats[statusName]
          local statValue = monster.stats[statName].value
          -- duration mult divides the dt that substracts from the status duration, so it is a multiplyer of the duration (in a sense)
          if statusType[statusName] == 'buff' then
            durationMult = statValue/(50 + monster.totalPower/2) * statusMult * buffMultipl -- buffs are removed slower
          else
            durationMult = (50 + monster.totalPower/2)/statValue * statusMult * debuffMultipl --debuff are removed faster
          end
          --print(statusName, statValue, durationMult)
        end
      end
      
      
      
      

      if statusName == 'bleeding' then
        dealDamage(nil, monster, dt*monster.totalPower/50, 'blockLog')
      end
      if statusName == 'burning' then
        damageMult = 1
        if statusInfo.plus then
          damageMult = 1.5
        end
        dealDamage(nil, monster, damageMult*dt*monster.totalPower/20, 'blockLog')
      end
      if statusName == 'poisoned' then
        damageMult = 1
        if statusInfo.plus then
          damageMult = 1.2
        end
        if statusInfo.fastPoison then
          damageMult = 2*damageMult
        end
        dealDamage(nil, monster, damageMult*dt*monster.totalPower/100, 'blockLog')
      end
      if statusName == 'plant' then
        local plantCounter = nElementalCounters(monster, 'plant')
        local healValue = plantCounter * 0.001 * monster.stats.maxHP.value * dt
        if monster.status.plantPlus then
          healValue = 2*healValue
        end
        monster.stats.currentHP.value = math.min(monster.stats.currentHP.value + healValue, monster.stats.maxHP.value)
        monster.HPbar.value = monster.stats.currentHP.value
        monster.panelInfo.subelements.HPValue.text = math.floor(monster.stats.currentHP.value)..'/'..monster.stats.maxHP.value
      end
      
      

      if (statusInfo.counter == nil) or (statusInfo.counter < monster.counterLimit) then
        
        if statusName == 'poison' and monster.status.poisonPlus then
          durationMult = durationMult/1.2
        end
        
        if statusName == 'mineral' and monster.status.mineralPlus then
          durationMult = durationMult/1.5
        end
        
        
        statusInfo.duration = statusInfo.duration - dt/durationMult
        statusInfo.radians = 2*math.pi * (statusInfo.duration0 - statusInfo.duration)/statusInfo.duration0
      end
      
      
      
      if statusInfo.duration <= 0 then
        if statusInfo.onEnd then
          statusInfo.onEnd()
        end
        if statusInfo.logPos then
          logs[statusInfo.logPos] = '-'
        end
        local previousDuration0 = statusInfo.duration0
        
        if statusInfo.counter then
            statusInfo.counter = statusInfo.counter + 1
            statusInfo.duration = statusInfo.duration0
          if statusInfo.counter >= monster.counterLimit then
          --if statusInfo.counter >= maxElementalValues[statusName] then
            --statusInfo.capped = true
          end
        else
          stopStatus(monster, statusName)
        end
        
        
        if statusName == 'subconscious' then
          decideSubconsciousApproach(monster, previousDuration0)
        end
        
        
        
        
        
      end
    end
    
    
    
    
    
  end
  
  
  
  local x, y = push:toGame(love.mouse.getPosition())
  self.overWindow = false
  for i, window in ipairs(self.windows) do
    if window:mouseIsOver(x,y) then
      window.shadow = true
      self.overWindow = true
      if love.mouse.wasPressed(1) and (not self.instruction1) then
        window:onClick()
      end
    else
      window.shadow = false
    end
  end
  
  for _, monster in pairs(self.monsters) do
    monster.currentSP = math.min(monster.maxSP, monster.currentSP + regenRate*monster.regenSP*dt)
    monster.SPbar.value = monster.currentSP
    monster.SPbarb.value = monster.currentSP
  end
  
  
  logSystem:update(dt)
  
  --[[
  if love.keyboard.wasPressed('h') then
    self.monster2.stats.currentHP.value = 0
  elseif love.keyboard.wasPressed('b') then
    self.monster1.blink = 0
  elseif love.keyboard.wasPressed('n') then
    self.monster1.flash = 0
  end
  ]]
  
  local cicleTime = 0.15
  local timeLimit = 0.75
  
  for i, monster in ipairs(self.monsters) do
    
    if monster.blink then
      monster.flash = nil
      if monster.blink > timeLimit then
        monster.blink = nil
      else
        if monster.blink == 0 then
          monster.prevBlinkPair = false
        end
        monster.blink = monster.blink + dt
        local prevBlinkPairNew
        if  math.floor(monster.blink / cicleTime) % 2 == 0 then
          prevBlinkPairNew = true
        else
          prevBlinkPairNew = false
        end
        if not (monster.prevBlinkPair == prevBlinkPairNew) then
          local sizeF
          local rescaleF
          local front
          local inverted
          if monster.name == self.monster1.name then
            inverted = true
          end
          local animation
          if monster.blink < timeLimit - 0.05 then
            animation = 'defend'
          end
          local spriteParams = {blink = prevBlinkPairNew, monster = monster, power = monster.totalPower, animation = animation, inverted = inverted}
          local x
          local y
          if i == 1 then
            sizeF = 10
            rescaleF = 10
            front = false
            x = self.monster1spritex
            y = self.monster1spritey
          elseif i == 2 then
            sizeF = 10
            rescaleF = 5
            front = true
            x = self.monster2spritex
            y = self.monster2spritey
          end
          monster.sprite = Chimera(x, y, front, monster.seed, sizeF, rescaleF, spriteParams)
        end
        monster.prevBlinkPair = prevBlinkPairNew
      end
    end
    
    if monster.flash then
      monster.blink = nil
      if monster.flash > timeLimit then
        monster.flash = nil
      else
        if monster.flash == 0 then
          monster.prevFlashPair = false
        end
        monster.flash = monster.flash + dt
        local prevFlashPairNew
        if  math.floor(monster.flash / cicleTime) % 2 == 0 then
          prevFlashPairNew = true
        else
          prevFlashPairNew = false
        end
        if not (monster.prevFlashPair == prevFlashPairNew) then
          local sizeF
          local rescaleF
          local front
          local spriteParams = {flash = prevFlashPairNew, removeShadows = prevFlashPairNew, removeMouth = prevFlashPairNew, monster = monster, power = monster.totalPower}
          local x
          local y
          if i == 1 then
            sizeF = 10
            rescaleF = 10
            front = false
            x = self.monster1spritex
            y = self.monster1spritey
          elseif i == 2 then
            sizeF = 10
            rescaleF = 5
            front = true
            x = self.monster2spritex
            y = self.monster2spritey
          end
          monster.sprite = Chimera(x, y, front, monster.seed, sizeF, rescaleF, spriteParams)
        end
        monster.prevFlashPair = prevFlashPairNew
      end
    end
    
  end
  
  
  
  
  
  
  if math.floor(self.monster1.stats.currentHP.value) <= 0 then
    if deathAllowed then
      self.ffMode = false
      changeSoundSpeed(false)
      self.blockInput = true
      self.monster1.sprite = Chimera(self.monster1spritex, self.monster1spritey, false, self.monster1.seed, 10, 10, self.monster1spriteParams)
      self.monster2.sprite = Chimera(self.monster2spritex, self.monster2spritey, true, self.monster2.seed, 10, 5, self.monster2spriteParams)
      local newState = AfterBattleState({
            monster = self.monster1,
            moveSprite = self.monster1.sprite,
            victory = false,
          })
      gStateStack:push(newState)
    else
      self.monster1.stats.currentHP.value = self.monster1.stats.maxHP.value
      self.monster1.HPbar.value = self.monster1.stats.currentHP.value
      self.monster1.panelInfo.subelements.HPValue.text = self.monster1.stats.currentHP.value..'/'..self.monster1.stats.maxHP.value
    end
    
    
  elseif math.floor(self.monster2.stats.currentHP.value) <= 0 then
    if deathAllowed then
      self.ffMode = false
      changeSoundSpeed(false)
      self.blockInput = true
      self.monster1.sprite = Chimera(self.monster1spritex, self.monster1spritey, false, self.monster1.seed, 10, 10, self.monster1spriteParams)
      self.monster2.sprite = Chimera(self.monster2spritex, self.monster2spritey, true, self.monster2.seed, 10, 5, self.monster2spriteParams)
      local newState = AfterBattleState({
            monster = self.monster1,
            moveSprite = self.monster2.sprite,
            victory = true,
          })
      gStateStack:push(newState)
    else
      
      self.monster2.stats.currentHP.value = self.monster2.stats.maxHP.value
      self.monster2.HPbar.value = self.monster2.stats.currentHP.value
      self.monster2.panelInfo.subelements.HPValue.text = self.monster2.stats.currentHP.value..'/'..self.monster2.stats.maxHP.value
    end

end


  if self.blockInput then
    return
  end
  
  
  if love.keyboard.wasPressed('space') then
    pauseFromState = true
    --[[
  elseif love.keyboard.wasPressed('h') then
    self.monster2.stats.currentHP.value = 0
  elseif love.keyboard.wasPressed('b') then
    self.monster1.blink = 0
  elseif love.keyboard.wasPressed('n') then
    self.monster1.flash = 0
    ]]
  elseif love.keyboard.wasPressed('f') then
    self.ffMode = not self.ffMode
    changeSoundSpeed(self.ffMode)
  end
  
  
end

function StartState:render()
  
  love.graphics.setColor(palette[2])
  love.graphics.setFont(self.font)
  love.graphics.print('Fight '..encounterNumber..'/10', self.movx + self.offset, self.movy + self.offset)
  
  -- combat
  love.graphics.setColor(self.combatColors.sky)
  love.graphics.rectangle('fill', self.combatx, self.combaty, self.combatWidth, self.combatHeight)
  love.graphics.setColor(self.combatColors.grass)
  local grassHeight = 0.6
  love.graphics.rectangle('fill', self.combatx, self.combaty + (1-grassHeight)*self.combatHeight, self.combatWidth, grassHeight*self.combatHeight)
  
  
  for _, monster in pairs(self.monsters) do
    monster:render()
  end
  

  --love.graphics.setColor(self.combatColors.trainer1)
  --love.graphics.rectangle('fill', self.trainerx, self.trainer1y, self.trainerWidth, self.trainerHeight)
  local trainerIconScaleFactor = 10
  love.graphics.setColor(1,1,1)
  love.graphics.draw(gTextures['trainer'], self.trainerx, self.trainer1y, 0, trainerIconScaleFactor, trainerIconScaleFactor)
  if self.trainer2 then
    --love.graphics.setColor(self.combatColors.trainer2)
    --love.graphics.rectangle('fill', self.trainerx, self.trainer2y, self.trainerWidth, self.trainerHeight)
    love.graphics.draw(gTextures['trainer'], self.trainerx, self.trainer2y, 0, trainerIconScaleFactor, trainerIconScaleFactor)
  end
  
  
  
  love.graphics.setColor(self.combatColors.monsterInfo)
  love.graphics.rectangle('fill', self.bar1x, self.bar1y, self.barWidth, 3*self.barHeight + 2*self.barOffset)
  love.graphics.rectangle('fill', self.bar2x, self.bar2y, self.barWidth, 3*self.barHeight + 2*self.barOffset)
  love.graphics.rectangle('fill', self.mind1x, self.mind1y, self.mindWidth, self.mindHeight)
  love.graphics.rectangle('fill', self.mind2x, self.mind2y, self.mindWidth, self.mindHeight)
  
  
  
  for _, bar in pairs(self.bars) do
    bar:render()
  end
  
  
  
  -- attacks
  --[[
  for _, movement in pairs(self.movements) do
    movement:render()
  end
  ]]
  
  self.instinctPanel:render()
  
  for _, panel in pairs(self.panels) do
    panel:render()
  end

  -- instructions
  for _, window in pairs(self.windows) do
    window:render()
  end
  
  for _, bar in pairs(self.bars) do
    bar:render()
  end
  
  logSystem:render()
  
  
  if self.instruction1 then
    love.graphics.setColor(self.combatColors.instruction)
    self.instructionIcon:render()
    --love.graphics.rectangle('fill', self.instructionx, self.instruction1y, self.instructionWidth, self.instructionHeight)
    love.graphics.draw(gTextures['icons'], gFrames['icons'][approachesIcon[self.instruction1]], self.instruction1iconx, self.instruction1icony, 0, 5, 5)
    if self.instructionCD then
      love.graphics.draw(gTextures['icons'], gFrames['icons'][355], self.instruction1iconx, self.instruction1icony, 0, 5, 5)
    end
    --love.graphics.setColor(self.instruction1)
    --love.graphics.rectangle('fill', self.instructionx, self.instruction2y, self.instructionWidth, self.instructionHeight)
  end
  
  if self.instruction2 then
    love.graphics.setColor(self.combatColors.instruction)
    love.graphics.rectangle('fill', self.instructionx, self.instruction2y, self.instructionWidth, self.instructionHeight)
    love.graphics.draw(gTextures['icons'], gFrames['icons'][approachesIcon[self.instruction2]], self.instruction2iconx, self.instruction2icony, 0, 5, 5)
  end
  
  --lines
  --[[
  love.graphics.setLineWidth(3)
  love.graphics.setColor(colors.black)
  love.graphics.line(self.movWidth, 0, self.movWidth, VIRTUAL_HEIGHT)
  love.graphics.line(self.movWidth, self.combatHeight, VIRTUAL_WIDTH, self.combatHeight)
  ]]

end

--[[

function blinkMonster(monster)
  
  
  
  
  
  
end

function flashMonster(monster)
  
end
]]


function StartState:increaseMonsterPower(encounterNumber)
  
  local monster = self.monster2
  local template = instructionTemplates[encounterNumber]
  
  for i, element in ipairs(template) do
    if type(element) == 'number' then
      monster:distributePower(element)
    elseif type(element) == 'string' then
      local trait = smallTraitList[math.random(#smallTraitList)]
      local organ = organList[math.random(#organList)]
      monster:addTrait(trait, organ)
    end
  end
  
  monster:updateMovements()
  
end




