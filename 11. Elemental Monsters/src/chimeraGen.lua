
local rFact = 0.35

organInfoGlobal = {
  
  -- key = name, 1 = number of cells, 2 = x, 3 = xvar, 4 = y,
  -- 5 = yvar, 6 = rx, 7 = rxvar, 8 = ry, 9 = ryvar, 10 = hJoint, 11 = hJointvar, 12 = ang, 13 = angvar, 14 = front, 15 = shadow, 16 = line,17 = color
  --18 = organName, 19 = isSkin (determines if changes color with element),

  
  body = {1, 0, 0, 0, 0, 1.2, rFact, 1.8, rFact, 0, 0, 0, 0, false, true, true, 1, 'body', true, },
  belly = {1, 0, 0, 0.25, 0, 0.4, rFact, 0.4, rFact, 0, 0, 0, 0, true, false, true, 2, 'body', false, },
  head = {1, 0, 0, -1, 0, 1, rFact, 1, rFact, 0.5, 0, 0, 0, true, true, true, 1, 'head', true, },
  arm = {2, 0.9, 0, -0.5, 0, 0.3, rFact, 0.8, rFact, 0.7, 0, 0.5, 1, true, true, true, 1, 'arms', true, },
  leg = {2, 0.8, 0, 0.6, 0, 0.4, rFact, 0.8, rFact, 0.7, 0, 1, 0, true, true, true, 1, 'legs', true, },
  wing = {2, 0.2, 0, -0.5, 0, 0.8, rFact, 2, rFact, 0.9, 0, 0.5, 0.5, false, true, true, 3, },
  tail = {1, 0, 0, 0.9, 0, 0.3, rFact, 1, rFact, 0.9, 0, 1/200, 25, false, true, true, 1, 'tail', true, },
  eye = {2, 0.5, 0, -0.5, 0, 0.3, rFact, 0.3, rFact, 0, 0, 0, 0, true, false, false, 3, 'head', false, },
  ear = {2, 0.5, 0, -0.8, 0, 0.3, 0.75, 0.6, 0.75, 0.8, 0, 0.4, 1.2, false, true, true, 1, 'head', true, },
  mouth = {1, 0, 0, 0.5, 0, 0.4, rFact, 0.3, rFact, 0, 0, 0, 0, true, true, true, 4, 'head', false, },
  hand = {1, 0, 0, -0.8, 0, 0.3, rFact, 0.2, rFact, 0.5, 0, 0, 0, true, true, true, 1, 'arms', true, },
  feet = {1, 0, 0, -0.8, 0, 0.4, rFact, 0.3, rFact, 0, 0, 0, 0, true, true, true, 1, 'legs', true, },
  snout = {1, 0, 0, -1.1, 0, 0.5, 0, 0.5, 0, -0.8, 0, 0, 0, true, false, false, 1, 'head', true, },
  pupil = {1, 0, 0, 0, 0, 0.15, rFact, 0.15, rFact, 0, 0, 0, 0, true, false, false, 4, 'head', false, },
  claw = {3, 0.8, 0, -0.5, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, true, false, false, 3, 'legs', false, },
  
}

function generateBody(chimera)

  local prevSeed = math.random()
  math.randomseed(chimera.seed)
  
  --chimera.color1 = {math.random(), math.random(), math.random(), 1}
  --chimera.color2 = {math.random(), math.random(), math.random(), 1}
  
  local colorList1 = {2,6,7,10,11,14,15,18,19,22,23,26,27,30,31,34,38,42,43,46,47,50,51}
  --local colorList2 = {}

  
  local color1 = colorList1[math.random(#colorList1)]
  --local color2 = colorList2[math.random(#colorList2)]
  local color2 = math.random(55)
  
  chimera.color1 = palette[color1]
  chimera.color2 = palette[color2]
  
  chimera.seedList = {}
  for i = 1, 20 do
    table.insert(chimera.seedList, math.random())
  end
  
  
  addOrgan(chimera,'body')
  addOrgan(chimera, 'belly', 'body')
  addOrgan(chimera, 'head', 'body')
  addOrgan(chimera, 'arm', 'body')
  addOrgan(chimera, 'leg', 'body')
  --addOrgan(chimera, 'wing', 'body')
  addOrgan(chimera, 'tail', 'body')
  addOrgan(chimera, 'eye', 'head')
  addOrgan(chimera, 'ear', 'head')
  addOrgan(chimera, 'mouth', 'head')
  addOrgan(chimera, 'hand', 'arm')
  addOrgan(chimera, 'feet', 'leg')
  addOrgan(chimera, 'snout', 'mouth')
  addOrgan(chimera, 'pupil', 'eye')
  addOrgan(chimera, 'claw', 'feet')

  math.randomseed(prevSeed)
  
  if not chimera.frontalCamera then
    reverseParts(chimera)
  end
  
end

function generateName(chimera)
  
  local syllabNumber = 1 + math.floor((math.random(2)+math.random(2))/2)
  
  local consonants = {"b", "b", "c", "c", "c", "d", "d", "d", "f", "g", "h", "j", "k", "l", "l", "l", "m", "m", "n", "n", "n", "p", "p", "p", "q", "r", "r", "r", "s", "s", "s", "t", "t", "t", "v", "w", "x", "y", "z"}
  local vowels = {"a","a","a", "e", "e", "e", "i", "i", "o", "o", "u"}
  
  local name = ''
  
  for i = 1, syllabNumber do
    local syllab = ''
    if math.random() < 0.5 then
        syllab = syllab .. vowels[math.random(#vowels)]
    end
    syllab = syllab .. consonants[math.random(#consonants)]
    syllab = syllab .. vowels[math.random(#vowels)]
    if math.random() < 0.5 then
        syllab = syllab .. consonants[math.random(#consonants)]
    end
    name = name .. syllab
  end
  
  while #name > 10 do
    local removedIndex = math.random(1, #name)
    name = name:sub(1, removedIndex - 1) .. name:sub(removedIndex + 1)
  end
  
  
  
  
  
  
  name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)
  
  --print(name)
  chimera.name = name
  

  
end



function addOrgan(chimeraObj, newOrganName, parentName)
  
  local organInfo = organInfoGlobal[newOrganName]
  
  
  local colorMatrix = {chimeraObj.color1, chimeraObj.color2, white, black, }
  local organColor = colorMatrix[organInfo[17]]
  
  local monsterOrgan = organInfo[18]

  if chimeraObj.monster.organs[monsterOrgan].traitSlot2 then
    
    if organInfo[19] then
      local trait1 = chimeraObj.monster.organs[monsterOrgan].traitSlot1.key
      local trait2 = chimeraObj.monster.organs[monsterOrgan].traitSlot2.key
      local trait1ColorNumber = traitMonsterColors[trait1]
      local trait2ColorNumber = traitMonsterColors[trait2]
      local trait1Color = palette[trait1ColorNumber]
      local trait2Color = palette[trait2ColorNumber]
      
      
      local newColor = {}
      for i = 1, 3 do 
        newColor[i] = 0.2*organColor[i]+0.4*trait1Color[i]+0.4*trait2Color[i]
      end
      organColor = newColor
      
    end
  elseif chimeraObj.monster.organs[monsterOrgan].traitSlot1 then
    if organInfo[19] then
      local trait1 = chimeraObj.monster.organs[monsterOrgan].traitSlot1.key
      local trait1ColorNumber = traitMonsterColors[trait1]
      local trait1Color = palette[trait1ColorNumber]

      local newColor = {}
      for i = 1, 3 do 
        newColor[i] = 0.3*organColor[i]+0.7*trait1Color[i]
      end
      organColor = newColor
      
    end
  end

  
  
  
  if chimeraObj.spriteParams.flash then
    organColor = {1,1,1,1}
  elseif chimeraObj.spriteParams.blink then
    organColor = {1,1,1,0}
  end
  
  
  
  
  local assymetricPostureOrgans = {}
  --local assymetricPostureOrgans = {'arm',}
  
  -- changes in power alter the random factors unless we use a seed set before the influence of power
  local seedList = chimeraObj.seedList
  math.randomseed(seedList[#seedList])
  table.remove(seedList, #seedList)

  local rxMult = 1 + organInfo[7]*math.random(-100,100)/100
  local ryMult = 1 + organInfo[9]*math.random(-100,100)/100
  
  
  if parentName == nil then
    local angSpawnBody = organInfo[12]*math.pi
    local isAnimated
        local animationAng
        if chimeraObj.spriteParams.animation then
          local animation = chimeraObj.spriteParams.animation
          local animationInfo = gAnimations[animation]
          if animationInfo[newOrganName] then
            animationAng = animationInfo[newOrganName]
            isAnimated = true
            angSpawnBody = animationAng
            if chimeraObj.spriteParams.inverted then
              angSpawnBody = - angSpawnBody
            end
          end
        end
    local organ = Cell {
      chimera = chimeraObj,
      monsterOrgan = monsterOrgan,
      parent = nil,
      name = newOrganName,
      x = chimeraObj.canvasSize/2,
      y = chimeraObj.canvasSize/2,
      rx = organInfo[6]*rxMult,
      ry = organInfo[8]*ryMult,
      hJoint = organInfo[10],
      ang = angSpawnBody,
      front = organInfo[14],
      shadow = organInfo[15],
      line = organInfo[16],
      color = organColor,
    }
    chimeraObj[newOrganName] = organ
    table.insert(chimeraObj.parts, organ)
  else
    for _, cell in pairs(chimeraObj.parts) do
      if cell.name == parentName then
        
        local xSpawn = math.abs(organInfo[2])
        local xSeparation = 0
        if organInfo[1] > 1 then
          xSeparation = 2*xSpawn/(organInfo[1]-1)
        end
        
        local angSpawn = math.random(100*(organInfo[12]*(1-organInfo[13])),100*(organInfo[12]*(1+organInfo[13])))*math.pi/100
        local angSeparation = 2*(math.pi-angSpawn)/(organInfo[1]-1)
        
        local isAnimated
        local animationAng
        if chimeraObj.spriteParams.animation then
          local animation = chimeraObj.spriteParams.animation
          local animationInfo = gAnimations[animation]
          if animationInfo[newOrganName] then
            animationAng = animationInfo[newOrganName]
            isAnimated = true
            angSpawn = animationAng
            if chimeraObj.spriteParams.inverted then
              angSpawn = - angSpawn
            end
          end
        end
        
        
        

        local cellsAdded = 0
        
        while cellsAdded < organInfo[1] do
          
          local organ = Cell {
            chimera = chimeraObj,
            monsterOrgan = monsterOrgan,
            parent = cell,
            name = newOrganName,
            x = xSpawn,
            y = organInfo[4],
            rx = organInfo[6]*rxMult,
            ry = organInfo[8]*ryMult,
            hJoint = organInfo[10],
            ang = angSpawn,
            front = organInfo[14],
            shadow = organInfo[15],
            line = organInfo[16],
            color = organColor,
          }
          table.insert(cell.parts, organ)
          cell[newOrganName] = organ
          table.insert(chimeraObj.parts, organ) -- all cells must be added to the chimera itself (in addition to adding them to its parent)
          
          xSpawn = xSpawn - xSeparation
          
          if not isAnimated then
            angSpawn = angSpawn + angSeparation
          
            if asymmetricAngle then
              for _, assymetricPostureOrgan in pairs(assymetricPostureOrgans) do
                  if assymetricPostureOrgan == newOrganName then
                    angSpawn = 2*math.pi*math.random(100)/100
                  end
              end
            end
          end
          
          
          
          cellsAdded = cellsAdded + 1
          
        end
      end
    end
  end

end
