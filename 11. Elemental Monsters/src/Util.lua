function randomColor(type)
  local colorType = type or 'choose'
  local color = {}
  for i = 1, 3 do
    table.insert(color, math.random())
  end
  table.insert(color, 1)
  
  if colorType == 'set' then
    love.graphics.setColor(color)
  elseif colorType == 'choose' then
    return color
  end
  
end


function calculateDamage(user, movInfo, organName)
  local organScalingPower = 0
  local organInfo = user.organs[organName]
  for i, powerType in ipairs(movInfo.stats) do
    organScalingPower = organScalingPower + organInfo.powerTypeValues[powerType]
  end
  local potency = movInfo.potency
  local damage = potency * organScalingPower
  return damage
end


function dealDamage(author, monster, damage, blockLog)
  
  if author then
    local authorMineralCounters = nElementalCounters(author, 'mineral')
    if authorMineralCounters > 0 and author.status.rockyCrust and blockLog == nil then
      damage = 1.2*damage
      author.status.mineral.counter = authorMineralCounters - 1
      authorMineralCounters = authorMineralCounters - 1
      if authorMineralCounters > 0 and author.status.mineralPlus then
        damage = 1.2*damage
        author.status.mineral.counter = authorMineralCounters - 1
      end
    end
  end
  
  
  
  
  local blocking = checkStatus(monster, 'name', 'blocking')
  if blocking then
    damage = damage - getStatusValue(monster, 'name', 'blocking')
  end
  
  if checkStatus(monster, 'name', 'dodging') then
    damage = 0
    LogSystem:newLog(monster, monster.name..' dodged the attack!')
  end
  
  if not monster.status.dodging and damage < 0 then
    damage = 0
    if not blockLog then
      LogSystem:newLog(monster, monster.name..' blocked all the damage!')
    end
  else
    
    local iceCounters = nElementalCounters(monster, 'ice')
    if iceCounters > 0 then
      local mitigatedDamage = damage * 0.1 * iceCounters
      damage = math.max(0, damage - mitigatedDamage)
      if monster.status.icySpikes then
        dealDamage(monster, author, iceCounters*monster.totalPower/50, 'blockLog')
      end
      if monster.status.icePlus then
        monster.status.ice.counter = iceCounters - 1
      else
        monster.status.ice.counter = 0
      end
    end
    
    local mineralCounters = nElementalCounters(monster, 'mineral')
    if mineralCounters > 0 then
      local mitigatedDamage = monster.totalPower * 0.02
      monster.status.mineral.counter = mineralCounters - 1
      mineralCounters = mineralCounters - 1
      if monster.status.mineralPlus and mineralCounters > 0 then
        mitigatedDamage = 2*mitigatedDamage
        monster.status.mineral.counter = mineralCounters - 1
      end
      damage = math.max(0, damage - mitigatedDamage)
      
    end
    
    
    
    monster.stats.currentHP.value = math.max(monster.stats.currentHP.value - damage, 0)
    monster.HPbar.value = monster.stats.currentHP.value
    monster.panelInfo.subelements.HPValue.text = math.floor(monster.stats.currentHP.value)..'/'..monster.stats.maxHP.value
    if not blockLog then
      monster.blink = 0
      LogSystem:newLog(monster, monster.name..' received '..math.ceil(damage)..' damage!')
    end
    
    
  end
  
  if author and (damage > 0) and (not blocking) then
    local fireCounters = nElementalCounters(author, 'fire')
    if fireCounters > 0 then
      local statusPrev = {plus = false}
      if author.status.firePlus then
        statusPrev = {plus = true}
      end
      gainStatus(monster, 'burning', monster.totalPower/100, nil, statusPrev)
      author.status.fire.counter = fireCounters - 1
    end
    
    local poisonCounters = nElementalCounters(author, 'poison')
    if poisonCounters > 0 then
      local statusPrev = {plus = false}
      if author.status.poisonPlus then
        statusPrev = {plus = true}
      end
      gainStatus(monster, 'poisoned', poisonCounters*monster.totalPower/20, nil, statusPrev)
      if author.status.hallucinogen then
        gainStatus(monster, 'scared', poisonCounters*monster.totalPower/20)
      end
      author.status.poison.counter = 0
    end
    
    
  end
  
  
  if author and monster.status.electroPlus then
    local electroCounters = nElementalCounters(author, 'electro')
    if electroCounters > 0 then
      monster.currentSP = math.min(10, monster.currentSP + electroCounters)
      monster.SPbar.value = monster.currentSP
      monster.SPbarb.value = monster.currentSP
      monster.status.electro.counter = 0
      dealDamage(monster, author, electroCounters*monster.totalPower/50, 'blockLog')
    end
  end

end

function nElementalCounters(monster, element)
  if monster.status[element] then
    return monster.status[element].counter
  else
    return 0
  end
end



--[[

function activateStatus(monster, statusName)
  monster.status.statusName = true
end

function deactivateStatus(monster, statusName)
  monster.status.statusName = false
end

function changeStatus(monster, statusName)
  if monster.status.statusName then
    deactivateStatus(monster, statusName)
  else
    activateStatus(monster, statusName)
  end
end
]]

function nElements(table)
  local count = 0
  for _, _ in pairs(table) do
      count = count + 1
  end
  return count
end

function copyTable(table)
  local newTable = {}
  for key, value in pairs(table) do
    newTable[key] = value
  end
  return newTable
end

function copyArray(array)
  local newArray = {}
    for i, v in ipairs(array) do
        newArray[i] = v
    end
    return newArray
end



function checkMovementRequirements(movementName, monster, objective)
  local meetsApproachRequirements = true
  local movement = MOV_DEFS[movementName] or MOV_DEFS[monster.moveToKey[movementName]]
  for approach, number in pairs(movement.approachRequirements) do
    if monster.approaches[approach] < number then
      meetsApproachRequirements = false
    end
  end
  local organ = movement.source
  if organ == 'trait' then
    organ = monster.movToOrgan[movementName]
  end
  --[[
  if monster.hasTrainer then
    print(movementName, 'isAllowed', isMovementAllowed(monster, movementName))
  end
  ]]
  
  if isMovementAllowed(monster, movementName) and meetsApproachRequirements and monster.currentSP >= movement.SPRequirement then
  --if meetsApproachRequirements and monster.currentSP >= movement.SPRequirement then

    monster.organs[organ].committed = true
    monster.currentSP = monster.currentSP - movement.SPRequirement
    monster.SPbar.value = monster.currentSP
    monster.SPbarb.value = monster.currentSP
    approachPop(movement.approachRequirements, monster)
    local powerDelay = delayMult * movement.speed * monster.totalPower/50
    local powerRecovery = recoveryMult * movement.speed * monster.totalPower/50
    
    
    
    
    
    
    local powerOrgans
    if movement.complete then
      powerOrgans = organList
    else
      powerOrgans = {organ}
    end

    local powerStats1
    local powerStats2
    if movement.mixed then
      powerStats1 = powerTypesList
      powerStats2 = powerTypesList
    else
      powerStats1 = {movement.stat1}
      powerStats2 = {movement.stat2}
    end
    
    local divFactor = #powerOrgans * #powerStats1
    local power1 = 0
    local power2 = 0
    
    local metalMovement
    local metalCharges = nElementalCounters(monster, 'metal')
    if metalCharges > 0 then
      if movement.key == 'bladeAttack' then
        monster.status.metal.counter = 0
      else
        monster.status.metal.counter = monster.status.metal.counter - 1
      end
      metalMovement = true
    end
    
    for _, powerOrgan in pairs(powerOrgans) do
      for _, powerStat in pairs(powerStats1) do
        local powerIncrease = monster.organs[powerOrgan].powerTypeValues[powerStat] * movement.potency / divFactor
        if metalMovement and (monster.status.liquidMetal or (powerStat == 'size' or powerStat == 'speed')) then
          local metalMult = 1
          if movement.key == 'bladeAttack' then
            metalMult = metalCharges
          end
          if monster.status.metalPlus then
            powerIncrease = 1.2*powerIncrease*metalMult
          else
            powerIncrease = 1.1*powerIncrease*metalMult
          end
        end
        power1 = power1 + powerIncrease
      end
      for _, powerStat in pairs(powerStats2) do
        local powerIncrease = monster.organs[powerOrgan].powerTypeValues[powerStat] * movement.potency / divFactor
        if metalMovement and (powerStat == 'size' or powerStat == 'speed') then
          powerIncrease = 1.1*powerIncrease
        end
        power2 = power2 + powerIncrease
      end
    end

    
    if monster.status.combo then
      power1 = power1 + monster.status.combo.power
      power2 = power2 + monster.status.combo.power
      stopStatus(monster, 'combo')
    end
    
    
    
    
    local statusPrev = {power = power1}
    local onEnd
    
    
    --[[
    if movement.type == 'attack' then
      onEnd = function()
        gainStatus(monster, 'attacking', power1, function()
            movement.onUse(monster, objective, statusPrev.power, power2)
            showRecovery(monster, organ, powerRecovery)
          end,
          statusPrev)
      end
    else
      onEnd = function()
        movement.onUse(monster, objective, power1, power2)
        showRecovery(monster, organ, powerRecovery)
      end
    end
    
    gainStatus(monster, movement.type, powerDelay, onEnd)
    ]]
      
      
    local chargeStatus = movement.type..'Charge'
    local useStatus = movement.type..'Use'
    
    local logColor = movTypeColors[movement.type]
    local logText
    if movement.type == 'attack' then
      logText = monster.name..' is preparing an attack!'
    elseif movement.type == 'buff' then
      logText = monster.name..' is preparing a buff!'
    elseif movement.type == 'utility' then
      logText = monster.name..' is preparing an utility movement!'
    end

    local logPos = LogSystem:newLog(monster, logText, logColor, 'permanent')
    
    
    
    
    
    local additionalUserEffects = function() end
    
    local additionalEnemyEffects = function() end
    if nElementalCounters(monster, 'insect') > 0 and (not objective.status.blocking) and (not objective.status.dodging) then
      monster.status.insect.counter = monster.status.insect.counter - 1
      additionalEnemyEffects = function()
        local power = monster.totalPower/50
        changeStatValue(objective, (1/1.2), 'speed', 'mixed', 'mult')
        local onEnd = function() changeStatValue(objective, 1.2, 'speed', 'mixed', 'mult') end
        local duration = monster.totalPower/50
        if monster.status.insectPlus then
          duration = 2*duration
        end
      gainStatus(objective, 'webbed', duration, onEnd)  
      end
      
    end
    
    if nElementalCounters(monster, 'electro') > 0 and movement.key ~= 'discharge' then
      monster.status.electro.counter = monster.status.electro.counter - 1
      monster.currentSP = math.min(10, monster.currentSP + 1)
      monster.SPbar.value = monster.currentSP
      monster.SPbarb.value = monster.currentSP
    end
    
    
    
    onEnd = function()
      monster.flash = 0
      logs[logPos] = '-'
      LogSystem:newLog(monster, monster.name..' is using '..movement.name..'!', logColor)
      gainStatus(monster, useStatus, monster.totalPower/50, function()
          movement.onUse(monster, objective, statusPrev.power, power2)
          showRecovery(monster, organ, powerRecovery)
          additionalUserEffects()
          additionalEnemyEffects()
          local soundKey = gMovementSounds[movement.key]
          playSound(soundKey)
        end,
        statusPrev)
    end
    gainStatus(monster, chargeStatus, powerDelay, onEnd)
    
    
    
    monster.lastMoveType = movement.type
    monster.lastMoveDefensive = movement.approachRequirements.defensive
    
    if charactersAllowed then
      for i = 1, 2 do
        local charKey = 'character'..i
        
        local info = characterInfo[monster[charKey]]
        if info.movType == movement.type then
          gainApproach(monster, info.approach)
        end
      end
    end
    
    playSound('powapo')
    
    
  end
end



function showRecovery(user, organ, powerRecovery)
  local recoveryType = 'recovery'..organ
  gainStatus(user, recoveryType, powerRecovery, function()
  user.organs[organ].committed = false
  decideMovement(user)
  end)
end


function approachPop(approachPops, monster)
  for approach, number in pairs(approachPops) do
    monster.approaches[approach] = math.max(0, monster.approaches[approach] - number)
  end
  local newApproachPops = copyTable(approachPops)
  local newApproachList = {}
  for i, approach in ipairs(monster.mind.approaches) do
    if newApproachPops[approach] and newApproachPops[approach] > 0 then
      newApproachPops[approach] = newApproachPops[approach] - 1
    else
      table.insert(newApproachList, approach)
    end
  end
  monster.mind.approaches = newApproachList
  
end

function tileMap(source, tileWidth, tileHeight)
    
    local offset = 0.001
    local totalWidth = source:getWidth()
    local totalHeight = source:getHeight()
    local nRows = totalWidth / tileWidth
    local nColumns = totalHeight / tileHeight
  
    local sheetNumber = 1
    local spriteSheet = {}

    for y = 0, nColumns - 1 do
        for x = 0, nRows - 1 do
            spriteSheet[sheetNumber] = love.graphics.newQuad(x * tileWidth + offset, y * tileHeight + offset, tileWidth - offset, tileHeight - offset, totalWidth, totalHeight)
            sheetNumber = sheetNumber + 1
        end
    end

    return spriteSheet
end

function gainStatus(monster, statusName, durationPower, onEnd, statusPrev)
  

  if statusType[statusName] == 'debuff' and checkDebuffShield(monster) then
    LogSystem:newLog(monster, monster.name..' has '..checkDebuffShield(monster)..' the status effect!')
    return
  end
  
  --print(monster.name, statusName, durationPower)
  local status
  if monster.status[statusName] then
    status = monster.status[statusName]
    status.duration0 = status.duration0 + durationPower
    status.duration = status.duration + durationPower
    local onEnd = status.onEnd
    if onEnd then
      onEnd()
    end
  else
    status = statusPrev or {}
    status.name = statusName
    status.duration0 = durationPower
    status.duration = durationPower
    status.radians = 0
    status.onEnd = onEnd or (function() end)
    monster.status[statusName] = status
    table.insert(monster.statusList, statusName)
    --print(statusName, status.duration)
  end
  if monster.stats.currentHP.value > 0 and (not status.counter) and (not (statusType[statusName] == 'neutral')) and (not (statusType[statusName] == 'debuff-neutral')) then
    --print(not (statusType[statusName] == 'neutral'),not (statusType[statusName] == 'debuff-neutral'))
    monster.status[statusName].logPos = LogSystem:newLog(monster, monster.name..' is '..statusName..'!', 'default', 'permanent')
  end
  
  
  
  
  --[[
  local animationChanged = false
  if statusName == 'attacking' then
    monster.color = colors.red
    animationChanged = true
  elseif statusName == 'blocking' then
    monster.color = colors.blue
    animationChanged = true
  elseif statusName == 'dodging' then
    monster.color = colors.green
    animationChanged = true
  end
  ]]

end

function checkDebuffShield(monster)
  if checkStatus(monster, 'name', 'blocking') then
    return 'blocked'
  elseif checkStatus(monster, 'name', 'dodging') then
    return 'dodged'
  else
    return false
  end
end


function gainApproach(monster, approachName, instructed)
  
  playSound('plin')
  
  table.insert(monster.mind.approaches, approachName)
  monster.approaches[approachName] = monster.approaches[approachName] + 1
  local maxApproaches = 5
  if #monster.mind.approaches == maxApproaches + 1 then
    local approachRemoved = monster.mind.approaches[1]
    monster.approaches[approachRemoved] = monster.approaches[approachRemoved] - 1
    table.remove(monster.mind.approaches, 1)
    monster.mind.y = monster.mind.y + monster.mind.size + monster.mind.offset
    Timer.tween(0.5, {
        [monster.mind] = {y = monster.mind.y0}
        })
  end  
  
  decideMovement(monster, instructed)
  
end

function decideMovement(monster, instructed)
  
  local isInstructed = instructed or false
  local candidateMovements = {}
  if isInstructed then
    candidateMovements = monster.selectedMoves
  else
    for i = math.max(1, #monster.selectedMoves - 2), #monster.selectedMoves do
      table.insert(candidateMovements, monster.selectedMoves[i])
    end
  end

  
  if not checkStatus(monster, 'name', 'deciding') then
    gainStatus(monster, 'deciding', 0.5*monster.totalPower/50, function()
        for i, movement in ipairs(candidateMovements) do
          checkMovementRequirements(movement, monster, monster.opponent)
        end
    end)
  end
  
  local monster2 = monster.opponent
  if checkStatus(monster2, 'name', 'prepared') and checkStatus(monster2, 'name', 'subconscious') then
    local power = getStatusValue(monster2, 'name', 'prepared')
    changeStatusDuration(monster2, 'subconscious', -power)
  end

end



function decideSubconsciousApproach(monster, decisionDuration)

  local forbiddenApproaches = {}
  
  local receivingAttack = (monster.opponent.status.attack or monster.opponent.status.attacking) or false
  local conditions = {
    not monster.status.taunted,
    receivingAttack,
    }
  local isDefensiveAllowed = true
  for _, condition in pairs(conditions) do
    if not condition then
      isDefensiveAllowed = false
    end
  end
  
  if not isDefensiveAllowed then
    forbiddenApproaches.defensive = true
  end
  
  
  if monster.status.scared then
    forbiddenApproaches.offensive = true
  end
  
  
  local chosenApproach = chooseApproach(monster, forbiddenApproaches)
  
  if not monster.status.taunted then
    table.remove(forbiddenApproaches, 1)
  end
  
  --[[
  if (monster.opponent.status.attack or monster.opponent.status.attacking) and (not monster.status.taunted) and (not monster.lastApproach == 'defensive') then
  --if (monster.opponent.status.attack or monster.opponent.status.attacking) and (not monster.status.taunted) and (not monster.lastMoveDefensive) then
    chosenApproach = 'defensive'
  end
  ]]
  
  if monster.status.confused then
    local confusedPossibleApproaches = {}
    for _, approach in ipairs(approachNames) do
      if not forbiddenApproaches[approach] then
        table.insert(confusedPossibleApproaches, approach)
      end
    end
    chosenApproach = confusedPossibleApproaches[math.random(#confusedPossibleApproaches)]
  end
  
  if not chosenApproach then
    for i, movement in ipairs(monster.selectedMoves) do
      --print('hi', i, movement, isMovementAllowed(monster, movement))
    end
    chosenApproach = 'offensive'
    --chosenApproach = 'elemental' 
  end
  
  gainApproach(monster, chosenApproach, false)
  gainStatus(monster, 'subconscious', decisionDuration)
  monster.lastApproach = chosenApproach
end


function chooseApproach(monster, forbiddenApproaches)
  
  local candidateMovements = {}
  for i = math.max(1, #monster.selectedMoves - 2), #monster.selectedMoves do
    table.insert(candidateMovements, monster.selectedMoves[i])
  end
  
  for i, movement in ipairs(candidateMovements) do
    local movInfo = MOV_DEFS[movement] or MOV_DEFS[monster.moveToKey[movement]]
    local organ = movInfo.source
    if organ == 'trait' then
      organ = monster.movToOrgan[movementName]
    end

    for k, approach in ipairs(approachNames) do
      local approachValue = movInfo.approachRequirements[approach] or 0
      local approachNeeded = false
      if approachValue and  approachValue > monster.approaches[approach] then
        approachNeeded = true
      end
      
      local conditions = {
        isMovementAllowed(monster, movement),
        approachNeeded,
        not forbiddenApproaches[approach],
      }
      --print(isMovementAllowed(monster, movement), approachNeeded, not forbiddenApproaches[approach])
      approachAllowed = true
      for _, condition in ipairs(conditions) do
        if (not condition) then
          approachAllowed = false
        end
      end
      
      if approachAllowed then
        return approach
      end
    end
  end
end



function isMovementAllowed(monster, movName)
  local movInfo = MOV_DEFS[movName] or MOV_DEFS[monster.moveToKey[movName]]
  local organ = movInfo.source
  if organ == 'trait' then
    organ = monster.movToOrgan[movName]
  end
  --[[
  local meetsApproachRequirements = true
  for approach, number in pairs(movInfo.approachRequirements) do
    if monster.approaches[approach] < number then
      print('hi')
      meetsApproachRequirements = false
    end
  end
  ]]
  local conditions = {
    not monster.organs[organ].committed,
    --meetsApproachRequirements,
    --monster.currentSP >= movInfo.SPRequirement,
    not (monster.status.coordinated and monster.lastMoveType == movInfo.type),
    not (monster.status.strengthened and movInfo.type ~= 'attack'),
    not statusRepeated(monster, movName),
  }
  --print('statusRepeated'..movName, statusRepeated(monster, movName))

  
  for _, condition in pairs(conditions) do
    if not condition then
      return false
    end
  end
  return true
end


function statusRepeated(monster, movName)
  local movInfo = MOV_DEFS[movName] or MOV_DEFS[monster.moveToKey[movName]]
  
  for _, status in pairs(movInfo.status) do
    --print(movName, statusType[status], status, monster.status[status] ~= nil)
    if (statusType[status] == 'buff') and (monster.status[status] ~= nil) then
      --print('buff repeated')
      return true
    end
    if (statusType[status] == 'debuff') and (monster.opponent.status[status]) then
      --print('debuff repeated')
      return true
    end
    
  end
  
  return false
  
end



function swap(array, pos1, pos2)
    local temp = array[pos1]
    array[pos1] = array[pos2]
    array[pos2] = temp
end

function shuffleArray(array)
    local n = #array
    for i = 1, n do
        local j = math.random(n)
        array[i], array[j] = array[j], array[i]
    end
end

function clamp(value, min, max)
    return math.min(math.max(value, min), max)
end





function createMovementPanel(def)
  
  local movName = def.movName
  local menuState = def.menuState
  local monsterActive = menuState.monster or menuState.monster1
  local i = def.i
  local extraInfo = def.extraInfo
  local nPanels = def.nPanels
  
  local movInfo = MOV_DEFS[movName] or MOV_DEFS[monsterActive.moveToKey[movName]]
  local movPanelWidth = menuState.movWidth - 2*offsetBig
  local movPanelHeight = ((menuState.movHeight - (menuState.fontOffset or 0) - offsetBig) / #menuState.movList) - offsetBig
  
  menuState.movPanelHeight = movPanelHeight
  
  local notMargin = false
  if nPanels > 5 then
    notMargin = true
  end
  
  
  local panelsToRemove = {}
  for i, panel in ipairs(menuState.panels) do
    if panel.name and panel.name == movInfo.name then
      table.insert(panelsToRemove, i)
    end
  end
  
  for i = #panelsToRemove, 1, -1 do
    table.remove(menuState.panels, panelsToRemove[i])
  end
  
  local panelx = (menuState.movX or 0) + offsetBig
  local panely = (menuState.movY or 0) + (menuState.fontOffset or 0) + offsetBig*i + movPanelHeight*(i-1)
  menuState.movCoordinates[i] = panely
  
  
  createPanelIcons(menuState, panelx, panely, movInfo, movPanelHeight, movPanelWidth, extraInfo)
  
  
end

function createPanelIcons(menuState, panelx, panely, movInfo, movPanelHeight, movPanelWidth, extraInfo, empty)
  
  local name
  if not empty then
    name = movInfo.name
  end
  
  local color1
  local color2
  local offset = offsetBig
  if empty then
    color1 = {0,0,0,0}
    color2 = {0,0,0,0}
    offset = 0
  end
  
  local element = movInfo.element
  local panelColor1
  local panelColor2
  if not (element == '') then
    panelColor1 = traitColors[element].color1
    panelColor2 = traitColors[element].color2
  end

  local panel = Panel{
      x = panelx,
      y = panely,
      width = movPanelWidth,
      height = movPanelHeight,
      name = name,
      color1 = panelColor1,
      color2 = panelColor2,--palette[20], --color,
      notNameMargin = notMargin,
      offset = offset,
    }
  table.insert(menuState.panels, panel)
  
  
  local baseScale = 8
  local baseIconHeight = panel.y2 + panel.height2/2 - 10*baseScale/2
  
  local extraSpace = baseScale * 5
  
  local iconSP = Icon{
  x = panel.x2 + offsetBig + extraSpace,
  y = baseIconHeight,
  scale = baseScale,
  iconNumber = 240 + movInfo.SPRequirement,
  }
  table.insert(panel.subelements, iconSP)
  local iconCoords = {
    {x = panel.x2 + 10*baseScale + 2*offsetBig + extraSpace, y = baseIconHeight},
    {x = panel.x2 + 10*baseScale + 2*offsetBig + extraSpace, y = baseIconHeight + 5*baseScale},
    {x = panel.x2 + 15*baseScale + 2*offsetBig + extraSpace, y = baseIconHeight},
    {x = panel.x2 + 15*baseScale + 2*offsetBig + extraSpace, y = baseIconHeight + 5*baseScale},
    --[[
    {x = panel.x2 + 20*baseScale + 2*offsetBig, y = baseIconHeight},
    {x = panel.x2 + 20*baseScale + 2*offsetBig, y = baseIconHeight + 5*baseScale},
    ]]
  }
  local iconValues = {}
  for k, approach in ipairs(approachNames) do
    local approachValue = movInfo.approachRequirements[approach]
    if approachValue then
      for j = 1, approachValue do 
        table.insert(iconValues, approachesIcon[approach])
      end
    end
  end
  for k, iconValue in ipairs(iconValues) do
    local iconApproach = Icon{
      x = iconCoords[k].x,
      y = iconCoords[k].y,
      scale = baseScale/2,
      iconNumber = iconValue,
    }
    table.insert(panel.subelements, iconApproach)
  end
  
  local iconTypeX = panel.x2 + 25*baseScale + 3*offsetBig
  local iconNumber
  --[[
  if movInfo.type == 'attack' then
    iconNumber = 265 + movInfo.potency
  else
    iconNumber = moveTypeIcon[movInfo.type]
  end
  ]]
  iconNumber = moveTypeIcon[movInfo.type]
  local iconType = Icon{
      x = iconTypeX,
      y = baseIconHeight,
      scale = baseScale,
      iconNumber = iconNumber,
  }
  if extraInfo then
    table.insert(panel.subelements, iconType)
  end
  
  
  local iconStatX = iconTypeX + 10*baseScale + offsetBig
  local iconStatPositions = {
    {x = iconStatX, y = baseIconHeight},
    {x = iconStatX, y = baseIconHeight + 10*baseScale/2},
  }
  --[[
  for k, stat in ipairs(movInfo.stats) do
    local iconStat = Icon{
      x = iconStatPositions[k].x,
      y = iconStatPositions[k].y,
      scale = baseScale/2,
      iconNumber = statsIcon[stat],
    }
    if extraInfo then
      table.insert(panel.subelements, iconStat)
    end
  end
  ]]
  
  local iconNumber1 = statsIcon[movInfo.stat1]
  local iconNumber2 = statsIcon[movInfo.stat2]
  if movInfo.mixed then
    iconNumber1 = 45
    iconNumber2 = 45
  end
  
  
  local iconStat1 = Icon{
      x = iconStatPositions[1].x,
      y = iconStatPositions[1].y,
      scale = baseScale/2,
      iconNumber = iconNumber1,
    }
  
  local iconStat2 = Icon{
      x = iconStatPositions[2].x,
      y = iconStatPositions[2].y,
      scale = baseScale/2,
      iconNumber = iconNumber2,
    }
    if extraInfo then
      table.insert(panel.subelements, iconStat1)
      table.insert(panel.subelements, iconStat2)
    end
    
  
  
  
  local monster = menuState.monster or menuState.monster1
  
  local movKey = movInfo.key
  local movName = monster.moveToKey[movKey]

  local source = movInfo.source
  if source == 'trait' then
    source = monster.movToOrgan[movName]
  end
  
  local iconOrgan = Icon{
      x = iconStatX + 10*baseScale/2,
      y = baseIconHeight,
      scale = baseScale,
      iconNumber = organIcon[source],
    }
  table.insert(panel.subelements, iconOrgan)
  
  if monster.organs[source].traitSlot1 then
    local iconTrait1 = Icon{
      x = iconStatX + 30*baseScale/2,
      y = baseIconHeight,
      scale = baseScale/2,
      iconNumber = traitIcon[monster.organs[source].traitSlot1.key],
    }
    if extraInfo then
      table.insert(panel.subelements, iconTrait1)
    end
  end
  if monster.organs[source].traitSlot2 then
    local iconTrait2 = Icon{
      x = iconStatX + 30*baseScale/2,
      y = baseIconHeight + 10*baseScale/2,
      scale = baseScale/2,
      iconNumber = traitIcon[monster.organs[source].traitSlot2.key],
    }
    if extraInfo then
      table.insert(panel.subelements, iconTrait2)
    end
  end
  
  return panel
end










function love.wheelmoved(x, y)
  wheelMovY = y or 0
end


--[[

function checkStatus(monster, key, value)
  
  for i, status in ipairs(monster.status) do
    --print(key, value, status[key])
    if status[key] == value then
      return true
    end
  end
  return false
end

function getStatusValue(monster, key, value)
  local statusValue = 0
  for i, status in ipairs(monster.status) do
    if status[key] == value then
      local localValue = status.value or 0
      statusValue = statusValue + localValue
    end
  end
  return statusValue
end

function changeStatusPower(monster, key, value, powerModifier, operation)
  for i, status in ipairs(monster.status) do
    if status[key] == value then
      if operation == 'mult' then
        organInfo.powerTypeValues[statName] = value * valueModifier
      else
        organInfo.powerTypeValues[statName] = value + valueModifier
      end
    end
  end
end

]]

function stopStatus(monster, name)
  for i = #monster.statusList, 1, -1 do
    if monster.statusList[i] == name then
      table.remove(monster.statusList, i)
    end
  end
  monster.status[name] = nil
end


function checkStatus(monster, key, name)
  if monster.status[name] then
    return true
  end
  return false
end

function getStatusValue(monster, key, name)
  return monster.status[name].power
end




function changeStatusDuration(monster, name, powerMod, operation)

  if operation == 'mult' then
    monster.status[name].duration = monster.status[name].duration * powerMod
  else
    monster.status[name].duration = monster.status[name].duration + powerMod
  end
  
  if monster.status[name].duration < 0 then
    monster.status[name].duration = 0
  end
  

end


function changeStatValue(monster, valueModifier, stat, organ, operation)
  for organName, organInfo in pairs(monster.organs) do
    if organ == organName or organ == 'mixed' then
      for statName, value in pairs(organInfo.powerTypeValues) do
        if stat == statName or stat == 'complete' then
          if operation == 'mult' then
            organInfo.powerTypeValues[statName] = value * valueModifier
          else
            organInfo.powerTypeValues[statName] = value + valueModifier
          end
        end
      end
    end
  end
  monster:recalculateStats()
end



function getKeyMax(array)
  local maxKey
  local maxValue = -math.huge

  for key, value in pairs(array) do
    if value > maxValue then
      maxValue = value
      maxKey = key
    end
  end
  
  return maxKey
end

function isStringInArray(stringSearched, array)
  for _, string in pairs(array) do
    if string == stringSearched then
      return true
    end
  end
  return false
end

function createInstinctPanel(state)

  
  local color = palette[34]
  
  local nMoves = #state.movList
  
  local y = state.movCoordinates[math.max(1, nMoves - 2)] - 5*scale
  local height = (math.min(3, nMoves))*(state.movPanelHeight + 10*scale)
  
  
  local panel = Panel{
    x = (state.movX or state.movx) + offset,
    y = y,
    width = state.movWidth - 2*offset,
    height = height,
    color1 = color,
    color2 = color,
  }
  
  state.instinctPanel = panel
  
end


function playSound(name)
  
  local sound = gSounds[name]
  local type = soundType[name]
  local volume = volumeValues[type]/10
  
  
  
  for soundName, soundFile in pairs(gSounds) do
    if soundType[soundName] == type then
      soundFile:stop()
    end
  end
  --sound:stop()
  
  sound:setVolume(volume)
  
  if type == 'music' and musicLoop[name] then
    sound:setLooping(true)
  end
  
  love.audio.play(sound)
  
end

function changeSoundSpeed(ffmode)
  local speed = 1
  if ffmode then
    speed = 2
  end
  for _, sound in pairs(gSounds) do
    sound:setPitch(speed)
  end
end



function determineTraitStat(monster, trait)
  local statList = traitStats[trait]
  local chosenStat
  local chosenStatPower = 0
  for i, stat in ipairs(statList) do
    local power = monster.powerValues[stat].value
    if power > chosenStatPower then
      chosenStat = stat
      chosenStatPower = power
    end
  end
  --print(chosenStat)
  return chosenStat
end

function determineTraitOrgans(monster, trait)
  local organList = {}
  for organName, organ in pairs(monster.organs) do
    if (organ.traitSlot1 and organ.traitSlot1.key == trait) or (organ.traitSlot1 and organ.traitSlot1.key == trait) then
      table.insert(organList, organName)
    end
    if (organ.traitSlot2 and organ.traitSlot2.key == trait) or (organ.traitSlot2 and organ.traitSlot2.key == trait) then
      table.insert(organList, organName)
    end
    
  end
  
  return organList
  
  
end


