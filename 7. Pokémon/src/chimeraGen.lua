
local rFact = 0.35

organInfoGlobal = {
  
  -- key = name, 1 = number of cells, 2 = x, 3 = xvar, 4 = y,
  -- 5 = yvar, 6 = rx, 7 = rxvar, 8 = ry, 9 = ryvar, 10 = hJoint, 11 = hJointvar, 12 = ang, 13 = angvar, 14 = front, 15 = shadow, 16 = line,17 = color
  

  
  body = {1, 0, 0, 0, 0, 1.2, rFact, 1.8, rFact, 0, 0, 0, 0, false, true, true, 1, },
  belly = {1, 0, 0, 0.25, 0, 0.6, rFact, 0.6, rFact, 0, 0, 0, 0, true, false, true, 2, },
  head = {1, 0, 0, -1, 0, 1, rFact, 1, rFact, 0.5, 0, 0, 0, true, true, true, 1, },
  arm = {2, 0.9, 0, -0.5, 0, 0.3, rFact, 0.8, rFact, 0.7, 0, 0.5, 1, true, true, true, 1, },
  leg = {2, 0.8, 0, 0.6, 0, 0.4, rFact, 0.8, rFact, 0.7, 0, 1, 0, true, true, true, 1, },
  wing = {2, 0.2, 0, -0.5, 0, 0.8, rFact, 2, rFact, 0.9, 0, 0.5, 0.5, false, true, true, 3, },
  tail = {1, 0, 0, 0.9, 0, 0.3, rFact, 1, rFact, 0.9, 0, 1/200, 25, false, true, true, 1, },
  eye = {2, 0.5, 0, -0.5, 0, 0.3, rFact, 0.3, rFact, 0, 0, 0, 0, true, false, false, 3, },
  ear = {2, 0.5, 0, -0.8, 0, 0.3, 0.75, 0.6, 0.75, 0.8, 0, 0.4, 1.2, false, true, true, 1, },
  mouth = {1, 0, 0, 0.5, 0, 0.3, rFact, 0.2, rFact, 0, 0, 0, 0, true, true, true, 4, },
  hand = {1, 0, 0, -0.8, 0, 0.3, rFact, 0.2, rFact, 0.5, 0, 0, 0, true, true, true, 1, },
  feet = {1, 0, 0, -0.8, 0, 0.4, rFact, 0.3, rFact, 0, 0, 0, 0, true, true, true, 1, },
  snout = {1, 0, 0, -1.1, 0, 0.5, 0, 0.5, 0, -0.8, 0, 0, 0, true, false, false, 1, },
  pupil = {1, 0, 0, 0, 0, 0.1, rFact, 0.1, rFact, 0, 0, 0, 0, true, false, false, 4, },
  claw = {3, 0.8, 0, -0.5, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, true, false, false, 3, },
  
}

function generateBody(chimera)


  math.randomseed(chimera.seed)
  
  chimera.color1 = {math.random(), math.random(), math.random(), 1}
  chimera.color2 = {math.random(), math.random(), math.random(), 1}
  
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

  
  if not chimera.frontalCamera then
    reverseParts(chimera)
  end
  
end

function generateName(chimera)
  
  local syllabNumber = math.random(3)
  
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
  
  name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)

  chimera.name = name
  
end



function addOrgan(chimeraObj, newOrganName, parentName)
  
  local organInfo = organInfoGlobal[newOrganName]
  
  
  local colorMatrix = {chimeraObj.color1, chimeraObj.color2, white, black, }
  local organColor = colorMatrix[organInfo[17]]
  
  
  local assymetricPostureOrgans = {}
  --local assymetricPostureOrgans = {'arm',}

  local rxMult = 1 + organInfo[7]*math.random(-100,100)/100
  local ryMult = 1 + organInfo[9]*math.random(-100,100)/100
  
  if parentName == nil then
    local organ = Cell {
      chimera = chimeraObj,
      parent = nil,
      name = newOrganName,
      x = 0,
      y = 0,
      rx = organInfo[6]*rxMult,
      ry = organInfo[8]*ryMult,
      hJoint = organInfo[10],
      ang = organInfo[12]*math.pi,
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
        
        
        

        local cellsAdded = 0
        
        while cellsAdded < organInfo[1] do
          
          local organ = Cell {
            chimera = chimeraObj,
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

          angSpawn = angSpawn + angSeparation
          
          if asymmetricAngle then
            for _, assymetricPostureOrgan in pairs(assymetricPostureOrgans) do
                if assymetricPostureOrgan == newOrganName then
                  angSpawn = 2*math.pi*math.random(100)/100
                end
            end
          end
          
          cellsAdded = cellsAdded + 1
          
        end
      end
    end
  end

end
