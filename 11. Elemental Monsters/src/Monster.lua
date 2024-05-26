Monster = Class{}

function Monster:init(def)
  self.x = def.x
  self.y = def.y
  
  self.startPower = def.startPower or 100
  self.extraPower = def.extraPower or 0

  
  self.width = def.width
  self.height = def.height
  
  self.color = def.color
  
  self.origin = def.origin
  
  
  self.maxHP = def.HP or 0
  self.currentHP = def.HP or self.maxHP
  
  self.maxSP = 10
  self.currentSP = self.maxSP/2
  self.regenSP = def.regenSP
  self.attack = def.attack
  
  self.status = {}
  self.statusList = {}
  
  --self.traits = {}
  self.traits = {}
  
  self.class = def.class or 'mammal'
  self.parts = def.parts
  
  self.lastMoveType = ''
  
  self.statusMultiplyers = {
    subconscious = 1,
    }
  
  self.approaches = {
    offensive = 0,
    defensive = 0,
    agile = 0,
    tactical = 0, 
    elemental = 0
  }
  
  self.approachWeights = {
    offensive = 2,
    defensive = 1, 
    agile = 0, 
    tactical = 0,
    elemental = 0
  }
  
  self.powerValues = {
    size = {name = 'Size', value = 0},
    speed = {name = 'Speed', value = 0},
    int = {name = 'Intelligence', value = 0},
    met = {name = 'Metabolism', value = 0},
  }
  
  self.totalPower = 0
  
  self.counterLimit = 3

  self.stats = {}
  
  for i, stat in ipairs(statList) do
    self.stats[stat] = {name = statsInfo[stat].name, value = 0}
  end
  
  
  self.organs = {
    head = {name = 'Head', powerValue = 0, powerTypeValues = {}, powerTypeValuesBase = {},},
    body = {name = 'Body', powerValue = 0, powerTypeValues = {}, powerTypeValuesBase = {},},
    arms = {name = 'Arms', powerValue = 0, powerTypeValues = {}, powerTypeValuesBase = {},},
    legs = {name = 'Legs', powerValue = 0, powerTypeValues = {}, powerTypeValuesBase = {},},
    tail = {name = 'Tail', powerValue = 0, powerTypeValues = {}, powerTypeValuesBase = {},},
  }

  for organKey, organInfo in pairs(self.organs) do
    for pullKey, pullValue in pairs(organPowerPullInfo[organKey]) do
      organInfo[pullKey] = pullValue
    end
  end
  
  self.character1 = nil
  self.character2 = nil
  --self.characters = {self.character1, self.character2}
  self:chooseCharacters()
  

  
  self.movToOrgan = {}
  self.moveToKey = {}
  
  

  
  --self:distributePower(self.startingPower)
  self:generateStartingStats(self.startPower)

  self:distributePower(self.extraPower)


  --[[
  self:addTrait('plant', 'head')
  self:addTrait('fire', 'head')
  self:addTrait('ice', 'body')
  self:addTrait('poison', 'body')
  self:addTrait('insect', 'arms')
  self:addTrait('electro', 'arms')
  self:addTrait('metal', 'legs')
  self:addTrait('mineral', 'legs')
  ]]



  self.knownMoves = {}
  self.knownMovesPower = {}
  self.selectedMoves = {}


  self:updateMovements()
  self:chooseMovements()

 
  --print(self.stats.cognition.value)
  

end




function Monster:update()

end

function Monster:render()
  if sprites then
    self.sprite:render()
  else
    if self.origin == 'corner' then
      love.graphics.setColor(self.color)
      love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
      love.graphics.setColor(colors.black)
      love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    elseif self.origin == 'center' then
      love.graphics.setColor(self.color)
      love.graphics.rectangle('fill', self.x - self.width/2, self.y - self.height/2, self.width, self.height)
      love.graphics.setColor(colors.black)
      love.graphics.rectangle('line', self.x - self.width/2, self.y - self.height/2, self.width, self.height)
    end
  end
  
    
end


function Monster:addTrait(traitName, organName)
  
  local traitInfo = {powerValue = 0, powerTypeValues = {size = 0, speed = 0, int = 0, met = 0}}
  local organ = self.organs[organName]
  local pullInfo = traitPowerPullInfo[traitName]
  
  local startingPower = 50
  
  for pullKey, pullValue in pairs(traitPowerPullInfo[traitName]) do
    traitInfo[pullKey] = pullValue
  end
  
  for i, powerType in ipairs(powerTypesList) do
    local key = powerType..'Pull'
    traitInfo.powerTypeValues[powerType] = startingPower * pullInfo[key]
  end
  
  traitInfo.powerValue = startingPower
  
  
  if organ.traitSlot1 == nil then
    organ.traitSlot1 = traitInfo
  elseif organ.traitSlot2 == nil then
    organ.traitSlot2 = traitInfo
  end
  
  table.insert(self.traits, traitName)
  
  self:recalculateStats()
  
  self:updateMovements()

end


function Monster:updateMovements()
  local movementList = {}
  
  for i, organName in ipairs(organList) do
    local organInfo = self.organs[organName]
    for _, movement in ipairs(organMovements[organName]) do
      table.insert(movementList, movement)
    end
    if organInfo.traitSlot1 then
      for _, movement in ipairs(traitMovements[organInfo.traitSlot1.key]) do
        local newMovName = movement..organName
        table.insert(movementList, newMovName)
        self.movToOrgan[newMovName] = organName
        self.moveToKey[newMovName] = movement
        self.moveToKey[movement] = newMovName
      end
    end
    if organInfo.traitSlot2 then
      for _, movement in ipairs(traitMovements[organInfo.traitSlot2.key]) do
        local newMovName = movement..organName
        table.insert(movementList, newMovName)
        self.movToOrgan[newMovName] = organName
        self.moveToKey[newMovName] = movement
        self.moveToKey[movement] = newMovName
      end
    end
  end

  self.knownMoves = movementList
  
  
end


function Monster:chooseCharacters()
  local list = copyTable(characterList)
  local random1 = math.random(#list)
  self.character1 = list[random1]
  table.remove(list, random1)
  local random2 = math.random(#list)
  self.character2 = list[random2]
end



function Monster:distributePower(powerDistributed)
  
  local oldPower = self.totalPower
  local newPower = oldPower + powerDistributed
  local proportionIncrease = newPower/oldPower
  
  for i, organ in ipairs(organList) do
    local organInfo = self.organs[organ]
    for j = 1, 4 do 
      local powerType = powerTypesList[j]
      organInfo.powerTypeValuesBase[powerType] = organInfo.powerTypeValuesBase[powerType] * proportionIncrease
    end
    
    if organInfo.traitSlot1 then
      for j = 1, 4 do 
        local powerType = powerTypesList[j]
        organInfo.traitSlot1.powerTypeValues[powerType] = organInfo.traitSlot1.powerTypeValues[powerType] * proportionIncrease
      end
      organInfo.traitSlot1.powerValue = organInfo.traitSlot1.powerValue * proportionIncrease
    end
    
    if organInfo.traitSlot2 then
      for j = 1, 4 do 
        local powerType = powerTypesList[j]
        organInfo.traitSlot2.powerTypeValues[powerType] = organInfo.traitSlot2.powerTypeValues[powerType] * proportionIncrease
      end
      organInfo.traitSlot2.powerValue = organInfo.traitSlot2.powerValue * proportionIncrease
    end
    
    self.organs[organ].powerValue = self.organs[organ].powerValue * proportionIncrease
    
  end
  
  self:recalculateStats()
  
end








function Monster:generateStartingStats(power)
  
  local startingPower = power or 100
  
  local repeatLoop = true
  local powerValues = {}
  while repeatLoop do
    local totalAssignedPower = 0
    for i = 1, 4 do
      local organPower = startingPower/10 + math.random(math.ceil(startingPower/5))
      powerValues[i] = organPower
      totalAssignedPower = totalAssignedPower + organPower
    end
    powerValues[5] = startingPower - totalAssignedPower
    if powerValues[5] > startingPower/10 then
      repeatLoop = false
    end
  end
  
  shuffleArray(powerValues)
  
  
  for i, organ in ipairs(organList) do
    local organInfo = self.organs[organ]
    local organPower = powerValues[i]
    organInfo.powerValue = organPower
    
    repeatLoop = true
    local typePowerValues = {}

    while repeatLoop do
      local totalAssignedPower = 0
      for j = 1, 3 do
        --local typePower = math.random(math.ceil(organPower/3))
        local typePower = organPower/4 + math.random(-0.5*organPower/4, 0.5*organPower/4)
        typePowerValues[j] = typePower
        totalAssignedPower = totalAssignedPower + typePower
      end
      typePowerValues[4] = organPower - totalAssignedPower
      if typePowerValues[4] > 0 then
        repeatLoop = false
      end
    end
    shuffleArray(typePowerValues)
    for j = 1, 4 do 
      local powerType = powerTypesList[j]
      organInfo.powerTypeValuesBase[powerType] = typePowerValues[j]
    end

  end
  
  self:recalculateStats()
  
end

function Monster:recalculateStats()
  for i, powerType in ipairs(powerTypesList) do
    local totalPowerType = 0
    for organName, organInfo in pairs(self.organs) do
      local totalPowerTypeOrgan = organInfo.powerTypeValuesBase[powerType]
      if organInfo.traitSlot1 then
        totalPowerTypeOrgan = totalPowerTypeOrgan + organInfo.traitSlot1.powerTypeValues[powerType]
      end
      if organInfo.traitSlot2 then
        totalPowerTypeOrgan = totalPowerTypeOrgan + organInfo.traitSlot2.powerTypeValues[powerType]
      end
      organInfo.powerTypeValues[powerType] = totalPowerTypeOrgan
      totalPowerType = totalPowerType + totalPowerTypeOrgan
    end
    self.powerValues[powerType].value = totalPowerType
  end
  
  
  local newTotalPower = 0
  for i, powerType in ipairs(powerTypesList) do
    newTotalPower = newTotalPower + self.powerValues[powerType].value
  end
  self.totalPower = newTotalPower
  
  local minStat = self.totalPower/2

  local newMaxHP = math.ceil(minStat + 2*self.powerValues['size'].value)
  local newCurrentHP = self.stats['currentHP'].value + (newMaxHP - self.stats['maxHP'].value)
  local newDexterity = minStat + 50 * 4*(self.powerValues['speed'].value/self.totalPower)
  local newCognition = minStat + 50 * 4*(self.powerValues['int'].value/self.totalPower)
  local newRecovery = minStat + 50 * 4*(self.powerValues['met'].value/self.totalPower)


  
  local newStats = {newCurrentHP, newMaxHP, newDexterity, newCognition, newRecovery}
  
  for i, statName in ipairs(statList) do
    self.stats[statName].value = newStats[i]
    --print(statName, newStats[i])
  end

end



function Monster:chooseMovements()
  
  self.knownMovesPower = {}
  local movesInfo = {}
  local movesOrgan = {}
  for i, movName in ipairs(self.knownMoves) do
    self:calculateMovPower(movName)
    movesInfo[movName] = MOV_DEFS[movName] or MOV_DEFS[self.moveToKey[movName]]
    local organ = movesInfo[movName].source
    if organ == 'trait' then
      organ = self.movToOrgan[movName]
    end
    movesOrgan[movName] = organ
  end
  
  local char1Info = characterInfo[self.character1]
  local char2Info = characterInfo[self.character2]
  
  -- if any character gives defense status, purely reactive defensive moves are banned
  if char1Info.approach == 'defensive' or char2Info.approach == 'defensive' then
    local forbiddenMoves = {}
    
    for _, move in pairs(self.knownMoves) do
      local movInfo = movesInfo[move]
      if isStringInArray('reaction', movInfo.tags) or isStringInArray('protection', movInfo.tags) then
        table.insert(forbiddenMoves, move)
      end
    end

    for _, move in pairs(forbiddenMoves) do
      self.knownMovesPower[move] = 0
    end
    
  end
  
  
  -- moves that get approaches due to character are buffed
  for moveName, movePower in pairs(self.knownMovesPower) do
    local movType = movesInfo[moveName].type
    if movType == char1Info.movType or movType == char2Info.movType then
      self.knownMovesPower[moveName] = self.knownMovesPower[moveName]*2
    end
  end
  
  --[[
  print('before mov1')
  for moveName, movePower in pairs(self.knownMovesPower) do
    print(moveName, movePower)
  end
  ]]
  
  
  local mov1 = getKeyMax(self.knownMovesPower)
  self.knownMovesPower[mov1] = 0
  local mov1Info = movesInfo[mov1]
  
  local mov1approachesGiven = {}
  if mov1Info.type == char1Info.movType then
    table.insert(mov1approachesGiven, char1Info.approach)
  end
  if mov1Info.type == char2Info.movType then
    table.insert(mov1approachesGiven, char2Info.approach)
  end
  
  
  -- moves that buff stats greatly buff moves that use those stats
  -- each move slightly buff the chances for the corresponding buff movements
  local isMov1Buff = false
  if mov1Info.type == 'buff' then
    isMov1Buff = true
  end
  
  for moveName, movePower in pairs(self.knownMovesPower) do
    
    local currentMovePower = movePower
    local currentMoveInfo = movesInfo[moveName]
    
    -- moves from the same organ are banned
    if movesOrgan[mov1] == movesOrgan[moveName] then
      currentMovePower = 0
    end
    
    -- moves with the same type are debuffed (counters character buff from the beginning)
    if mov1Info.type == currentMoveInfo.type then
      currentMovePower = currentMovePower*0.5
    end
    
    -- after a move is selected if gives approaches due to characters, movements that have that approach are buffed
    for i, approach in pairs(mov1approachesGiven) do
      if currentMoveInfo.approachRequirements[approach] then
        currentMovePower = currentMovePower*1.5
      end
    end
    
    -- moves that buff stats greatly buff moves that use those stats
    -- each move slightly buff the chances for the corresponding buff movements
    if isMov1Buff and (mov1Info.stat1 == currentMoveInfo.stat1 or mov1Info.stat1 == currentMoveInfo.stat2) then
      currentMovePower = currentMovePower*2
    elseif currentMoveInfo.type == 'buff' and (currentMoveInfo.stat1 == mov1Info.stat1 or currentMoveInfo.stat1 == mov1Info.stat2) then
      currentMovePower = currentMovePower*1.5
    end
    
    -- if has the tag reaction (taunt, instinct...), increase the chance of moves with the protection tag (dodge, block...) 
    if isStringInArray('reaction', mov1Info.tags) and isStringInArray('protection', currentMoveInfo.tags) then
      currentMovePower = currentMovePower*3
    end
    
    --if has the protecion tag, ban other elements with protecion tag
    if isStringInArray('protection', mov1Info.tags) and isStringInArray('protection', currentMoveInfo.tags) then
      currentMovePower = 0
    end
    
    
    
    self.knownMovesPower[moveName] = currentMovePower
    
  end
  
  --[[
  print('before mov2')
  for moveName, movePower in pairs(self.knownMovesPower) do
    print(moveName, movePower)
  end
  ]]
  

  local mov2 = getKeyMax(self.knownMovesPower)
  self.knownMovesPower[mov2] = 0
  local mov2Info = movesInfo[mov2]
  
  local mov2approachesGiven = {}
  if mov2Info.type == char1Info.movType then
    table.insert(mov2approachesGiven, char1Info.approach)
  end
  if mov2Info.type == char2Info.movType then
    table.insert(mov2approachesGiven, char2Info.approach)
  end
  
  -- moves that buff stats greatly buff moves that use those stats
  -- each move slightly buff the chances for the corresponding buff movements
  local isMov2Buff = false
  if mov2Info.type == 'buff' then
    isMov2Buff = true
  end
  
  
  local isAttackMandatory = false
  -- if mov1 and mov2 are not attacks, 3rd move must be an attack
  if (not (mov1Info.type == 'attack')) and (not (mov2Info.type == 'attack')) then
    isAttackMandatory = true
  end
  
  local isReactionBanned = false
  -- if mov1 and mov2 do not have protection tag (dodge, block...), reaction movements (taunt, instinct...) are banned
  if (not isStringInArray('protection', mov1Info.tags)) and (not isStringInArray('protection', mov2Info.tags)) then
    isReactionBanned = true
  end
  

  for moveName, movePower in pairs(self.knownMovesPower) do
    
    local currentMovePower = movePower
    local currentMoveInfo = movesInfo[moveName]
    
    -- movements from the same organ are banned
    if movesOrgan[mov2] == movesOrgan[moveName] then
      currentMovePower = 0
    end
    
    -- moves with the same type are debuffed (counters character buff from the beginning)
    if mov2Info.type == currentMoveInfo.type then
      currentMovePower = currentMovePower*0.5
    end
    
    -- after a move is selected if gives approaches due to characters, movements that have that approach are buffed
    for i, approach in pairs(mov2approachesGiven) do
      if currentMoveInfo.approachRequirements[approach] then
        currentMovePower = currentMovePower*1.5
      end
    end
    
    -- moves that buff stats greatly buff moves that use those stats
    -- each move slightly buff the chances for the corresponding buff movements
    if isMov2Buff and (mov2Info.stat1 == currentMoveInfo.stat1 or mov2Info.stat1 == currentMoveInfo.stat2) then
      currentMovePower = currentMovePower*2
    elseif currentMoveInfo.type == 'buff' and (currentMoveInfo.stat1 == mov2Info.stat1 or currentMoveInfo.stat1 == mov2Info.stat2) then
      currentMovePower = currentMovePower*1.5
    end
    
    -- if has the tag reaction (taunt, instinct...), increase the chance of moves with the protection tag (dodge, block...) 
    if isStringInArray('reaction', mov2Info.tags) and isStringInArray('protection', currentMoveInfo.tags) then
      currentMovePower = currentMovePower*3
    end
    
    --if has the protecion tag, ban other elements with protecion tag
    if isStringInArray('protection', mov2Info.tags) and isStringInArray('protection', currentMoveInfo.tags) then
      currentMovePower = 0
    end
    
    -- if mov1 and mov2 are not attacks, 3rd move must be an attack
    if isAttackMandatory and (not (currentMoveInfo.type == 'attack')) then
      currentMovePower = 0
    end
    
    
    -- if mov1 and mov2 do not have protection tag (dodge, block...), reaction movements (taunt, instinct...) are banned
    if isReactionBanned and isStringInArray('reaction', currentMoveInfo.tags) then
      currentMovePower = 0
    end
    
    
    
    self.knownMovesPower[moveName] = currentMovePower
    
  end
  
  --[[
  print('before mov3')
  for moveName, movePower in pairs(self.knownMovesPower) do
    print(moveName, movePower)
  end
  ]]
  
  
  local mov3 = getKeyMax(self.knownMovesPower)
  self.knownMovesPower[mov3] = 0
  
  --[[
  for i, move in ipairs(self.selectedMoves) do
    print(move)
  end
  ]]
  
  self.selectedMoves = {mov1, mov2, mov3}
  
  
  -- if any move has protection, move it to first place to use as a reaction to enemy attacks
  if isStringInArray('protection', movesInfo[mov2].tags) then
    swap(self.selectedMoves, 1, 2)
  elseif isStringInArray('protection', movesInfo[mov3].tags) then
    swap(self.selectedMoves, 1, 3)
  end
  
  -- if mov3 is the only attack, move it to second place to increase its usage
  if isAttackMandatory then
    swap(self.selectedMoves, 2, 3)
  end
  

end




function Monster:calculateMovPower(movName)
  
  
  local movInfo = MOV_DEFS[movName] or MOV_DEFS[self.moveToKey[movName]]
  
  local powerDivFactor = 1
  
  local organs = {}
  if movInfo.complete then
    organs = organList
    powerDivFactor = powerDivFactor * 5
  else
    local organ = movInfo.source
    if organ == 'trait' then
      organ = self.movToOrgan[movName]
    end
    table.insert(organs, organ)
  end
  
  local powerTypes = {}
  if movInfo.mixed then
    powerTypes = powerTypesList
    powerDivFactor = powerDivFactor * 2
  else
    table.insert(powerTypes, movInfo.stat1)
    table.insert(powerTypes, movInfo.stat2)
  end
  
  local movPower = 0
  for i, organ in ipairs(organs) do
    for j, powerType in ipairs(powerTypes) do
      movPower = movPower + self.organs[organ].powerTypeValues[powerType]
    end
  end
  
  movPower = movPower / powerDivFactor
  
  self.knownMovesPower[movName] = movPower
end



