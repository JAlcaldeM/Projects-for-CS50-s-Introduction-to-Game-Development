function generateObstacleSet(level, xOrig, yOrig, diff) -- diff = difficulty
  

  local diffRemaining = diff
  local posAllowed = {
    {x = xOrig, y = yOrig}
  }
  
  --local posAlreadyUsed = {}
  
  local tileSize = 35*scale
  
  local diffLevels = {}
  local firstDiff = true
  local posBoxes = {}
  local posCosmetics = {
    {x = xOrig - 3*tileSize, y = yOrig}
  }
  local cosmeticPosRemoved = {}
  
  local nColumns = 0
  
  while diffRemaining > 0 do
    -- decide position of the obstacle
    local posAllowedChosen = math.random(#posAllowed)
    local posBox = posAllowed[posAllowedChosen]
    
    if posBox then
      -- check if the position to the right is available. if it is, put this box in the intermediate position (diagonal)
      
      if posBox.y == yOrig then
        nColumns = nColumns + 1
      end
      
      local diagonal = false
      local posToDelete = nil
      for i, pos in ipairs(posAllowed) do
        if pos.x == posBox.x + 6*tileSize and pos.y == posBox.y then
          diagonal = true
        end
      end
      if diagonal then
        for i, pos in ipairs(posAllowed) do
          if pos.x == posBox.x + 6*tileSize and pos.y == posBox.y then
            table.remove(posAllowed, i)
          end
        end
        posBox.x = posBox.x + 3*tileSize
      end
      table.insert(posBoxes, posBox)
      for i, pos in ipairs(posAllowed) do
          if pos.x == posBox.x and pos.y then
            table.remove(posAllowed, i)
          end
      end
      -- if this box is first or second (not third) floor, add the upper position to allowed, since a new box can spawn there now
      if posBox ~= nil and (posBox.y == yOrig) or (posBox.y == yOrig - 5*tileSize) then
        table.insert(posAllowed, {x = posBox.x, y = posBox.y - 5*tileSize})
      end
      -- if this box is grounded and in the first or second column, the position to the right can be used and a cosmetic appears there
      if posBox ~= nil and (posBox.x == xOrig or posBox.x == xOrig + 6*tileSize) and posBox.y == yOrig then
        table.insert(posAllowed, {x = posBox.x + 6*tileSize, y = posBox.y})
        table.insert(posCosmetics, {x = posBox.x + 6*tileSize, y = posBox.y})
      end
      
      -- this box destroys 2 positions for cosmetics and creates 2 new positions
      for i, pos in ipairs(posCosmetics) do
        if (pos.x == posBox.x or pos.x == posBox.x + 3*tileSize) and pos.y == posBox.y then
          --table.remove(posCosmetics, i)
          table.insert(cosmeticPosRemoved, i)
        end        
      end
      table.insert(posCosmetics, {x = posBox.x , y = posBox.y - 5*tileSize})
      table.insert(posCosmetics, {x = posBox.x + 3*tileSize, y = posBox.y - 5*tileSize})
      
      
      
      
      -- decide difficulty of the obstacle
      --local diffBox = 1
      local diffBox = math.random(math.min(4, diffRemaining))
      if firstDiff then
        diffBox = math.min(4, level.levelNumber)
        firstDiff = false
      end
      table.insert(diffLevels, diffBox)
      diffRemaining = diffRemaining - diffBox
      
    else
      diffRemaining = 0
    end
    
    
    
    
    
  end
  
    if nColumns == 3 then
      level.levelTranslateXmin = -0.2*VIRTUAL_WIDTH
    elseif nColumns == 2 then
      level.levelTranslateXmin = -0.15*VIRTUAL_WIDTH
    elseif nColumns == 1 then
      level.levelTranslateXmin = -0.05*VIRTUAL_WIDTH
    end
  
  bubbleSort(cosmeticPosRemoved)
  for _, key in pairs(cosmeticPosRemoved) do
    table.remove(posCosmetics, key)
  end

  bubbleSort(diffLevels)
  
  local nBoxes = math.min(#posBoxes, #diffLevels)
  
  local boxNames = {}
  for boxName, _ in pairs(boxList) do
    table.insert(boxNames, boxName)
  end
  
  for i = 1, nBoxes do
    local posBox = posBoxes[i]
    --print('Level', level.levelNumber, 'obstacle', i ,'posBox x', (posBox.x-xOrig)/tileSize, 'posBox y', (posBox.y-yOrig)/tileSize)
    
    -- choose the box to spawn in the position determined
    local chosenBoxName = boxNames[math.random(#boxNames)]
    local chosenBox = boxList[chosenBoxName]
    
    for _, item in pairs(chosenBox) do
      --print(item.x, item.y, item.material, item.shape, item.isAlien)
      if item.isAlien then
        table.insert(level.aliens, Alien(level.world, 'square', posBox.x + (item.x-0.5)*tileSize, posBox.y - (item.y-0.5)*tileSize, 'Alien'))
      else
        local material = item.material
        if diffLevels[i] > 1 then
          for k = 1, diffLevels[i] - 1 do
            if material == 'wood' and math.random() > 0.5 and item.shape ~= 'balancer' then
              material = 'stone'
            elseif material == 'stone' and math.random() > 0.5 and item.shape ~= 'balancer' then
              material = 'metal'
            end
          end
        end
        table.insert(level.obstacles, Obstacle(level.world, material, item.shape, posBox.x + (item.x-0.5)*tileSize, posBox.y - (item.y-0.5)*tileSize))
      end
    end
    
    
  end
  
  -- now, the basic structure has been created. spawn cosmetics in the designated positions
  --[[
  local cosmeticNames = {}
  for cosmeticName, _ in pairs(cosmeticList) do
    table.insert(cosmeticNames, cosmeticName)
  end
  for i, pos in ipairs(posCosmetics) do
    local cosmeticChosen = math.random(#cosmeticNames)
    local item = cosmeticList[cosmeticChosen]
    table.insert(level.obstacles, Obstacle(level.world, item.material, item.shape, posBox.x + (item.x-0.5)*tileSize, posBox.y - (item.y-0.5)*tileSize))
  end
  ]]
  local cosmeticNames = {}
  for cosmeticName, _ in pairs(cosmeticList) do
    table.insert(cosmeticNames, cosmeticName)
  end
  for i, pos in ipairs(posCosmetics) do
    if math.random() < 0.2 then
      table.insert(level.aliens, Alien(level.world, 'square', pos.x + 1*tileSize, pos.y - 1*tileSize, 'Alien'))
    else
      local randomIndex = math.random(#cosmeticNames)
      local cosmeticName = cosmeticNames[randomIndex]
      local item = cosmeticList[cosmeticName]
      table.insert(level.obstacles, Obstacle(level.world, item.material, item.shape, pos.x + (item.x - 0.5) * tileSize, pos.y - (item.y - 0.5) * tileSize))
    end
  end

end

-- in obstacleList, each value represents a possible difficulty from 1 to 4 and is a table that contains n possible boxes of that difficulty, each box being a group of obstacles with
-- values for x, y (both relative to the start of the obstacle, and represent the position in the 5x5 grid that is a box), shape and material, and if it is roofed.
-- REMEMBER THAT OBJECTS SPAWN IN THE CENTER OF THE COORDINATES GIVEN

function generateTestBox(level, xOrig, yOrig, diff)
  
  local chosenBox = {
      ['wall1'] = {x = 1.5, y = 1.5, material = 'wood', shape = '22'},
      ['wall2'] = {x = 4.5, y = 1.5, material = 'wood', shape = '12'},
      ['wall3'] = {x = 2, y = 3, material = 'wood', shape = '31'},
      ['window1'] = {x = 1, y = 4, material = 'glass', shape = '21'},
      ['wall4'] = {x = 4.5, y = 3.5, material = 'wood', shape = '22'},
      ['ceiling1'] = {x = 2, y = 5, material = 'wood', shape = '21'},
      ['ceiling2'] = {x = 4, y = 5, material = 'wood', shape = '21'},
      ['balancer'] = {x = 3, y = 5.6, material = 'metal', shape = 'balancer'},
      ['alien1'] = {x = 3.5, y = 1.9, isAlien = true},
      ['alien2'] = {x = 3, y = 4, isAlien = true},
    }
    
    local tileSize = 35*scale
    
    for _, item in pairs(chosenBox) do
      --print(item.x, item.y, item.material, item.shape, item.isAlien)
      if item.isAlien then
        table.insert(level.aliens, Alien(level.world, 'square', xOrig + (item.x-0.5)*tileSize, yOrig - (item.y-0.5)*tileSize, 'Alien'))

      else
        local material = item.material
        if diff > 1 then
          for k = 1, diff - 1 do
            if material == 'wood' and math.random() > 0.5 and item.shape ~= 'balancer' then
              material = 'stone'
            elseif material == 'stone' and math.random() > 0.5 and item.shape ~= 'balancer' then
              material = 'metal'
            end
          end
        end
        table.insert(level.obstacles, Obstacle(level.world, material, item.shape, xOrig + (item.x-0.5)*tileSize, yOrig - (item.y-0.5)*tileSize))
      end
    end
  
end



-- código para detectar los huecos para añadir cosméticos y añadirlos


cosmeticList = {
  ['box'] = {x = 1.5, y = 1, material = 'wood', shape = 'square'},
  ['explosive'] = {x = 1.5, y = 1, material = 'explosive', shape = 'square'},
  ['triangle'] = {x = 1.5, y = 1, material = 'wood', shape = 'triangle'},
  ['circle'] = {x = 1.5, y = 1, material = 'wood', shape = 'circle'},
  ['21'] = {x = 1.5, y = 1, material = 'wood', shape = '21'},
  ['12'] = {x = 1.5, y = 1.5, material = 'wood', shape = '12'},
}

--[[
cosmeticList = {
  ['explosive'] = {x = 1.5, y = 1, material = 'explosive', shape = 'square'},
}
]]

boxList = {
  ['omega'] = {
      ['base1'] = {x = 1.5, y = 1, material = 'wood', shape = '21'},
      ['base2'] = {x = 4.5, y = 1, material = 'wood', shape = '21'},
      ['ground'] = {x = 3, y = 2, material = 'wood', shape = '31'},
      ['wall1'] = {x = 1.6, y = 3.5, material = 'wood', shape = '12'},
      ['wall2'] = {x = 4.4, y = 3.5, material = 'wood', shape = '12'},
      ['roof1'] = {x = 2, y = 5.1, material = 'wood', shape = '21'},
      ['roof2'] = {x = 4, y = 5.1, material = 'wood', shape = '21'},
      ['balancer'] = {x = 3, y = 5.6, material = 'metal', shape = 'balancer'},
      ['alien1'] = {x = 3, y = 3.5, isAlien = true},
    },
    ['doubleflat'] = {
      ['ground1'] = {x = 2, y = 1, material = 'wood', shape = '21'},
      ['ground2'] = {x = 4, y = 1, material = 'wood', shape = '21'},
      ['window1'] = {x = 1.5, y = 2, material = 'glass', shape = '21'},
      ['wall1'] = {x = 4.5, y = 2, material = 'wood', shape = '21'},
      ['ground3'] = {x = 2, y = 3, material = 'wood', shape = '21'},
      ['ground4'] = {x = 4, y = 3, material = 'wood', shape = '21'},
      ['window2'] = {x = 1.5, y = 4, material = 'glass', shape = '21'},
      ['wall2'] = {x = 4.5, y = 4, material = 'wood', shape = '21'},
      ['roof1'] = {x = 2, y = 5, material = 'wood', shape = '21'},
      ['roof2'] = {x = 4, y = 5, material = 'wood', shape = '21'},
      ['balancer'] = {x = 3, y = 5.6, material = 'metal', shape = 'balancer'},
      ['alien1'] = {x = 3, y = 2, isAlien = true},
      ['alien2'] = {x = 3, y = 4, isAlien = true},
    },
    ['reinforcedglass'] = {
      ['base1'] = {x = 1.5, y = 1, material = 'wood', shape = '31'},
      ['base2'] = {x = 4.5, y = 1, material = 'wood', shape = '31'},
      ['window1'] = {x = 1, y = 3, material = 'glass', shape = '13'},
      ['window2'] = {x = 2, y = 3, material = 'glass', shape = '13'},
      ['window3'] = {x = 5, y = 3, material = 'glass', shape = '13'},
      ['window4'] = {x = 4, y = 3, material = 'glass', shape = '13'},
      ['roof1'] = {x = 2, y = 5.1, material = 'wood', shape = '21'},
      ['roof2'] = {x = 4, y = 5.1, material = 'wood', shape = '21'},
      ['alien1'] = {x = 3, y = 1.5, isAlien = true},
    },
    ['twocolumns'] = {
      ['ground1'] = {x = 1.6, y = 1, material = 'wood', shape = '21'},
      ['ground2'] = {x = 4.4, y = 1, material = 'wood', shape = '21'},
      ['support'] = {x = 3, y = 2, material = 'wood', shape = '21'},
      ['wall1'] = {x = 1.5, y = 3, material = 'wood', shape = '13'},
      ['wall2'] = {x = 4.5, y = 3, material = 'wood', shape = '13'},
      ['ceiling1'] = {x = 1.6, y = 5, material = 'wood', shape = '21'},
      ['ceiling2'] = {x = 4.4, y = 5, material = 'wood', shape = '21'},
      ['alien1'] = {x = 3, y = 3, isAlien = true},
    },
    ['phalanx'] = {
      ['ground1'] = {x = 3, y = 1, material = 'wood', shape = '31'},
      ['ground2'] = {x = 1, y = 1, material = 'wood', shape = 'square'},
      ['ground3'] = {x = 5, y = 1, material = 'wood', shape = 'square'},
      ['wall1'] = {x = 1.5, y = 2.5, material = 'wood', shape = '12'},
      ['wall2'] = {x = 4.5, y = 2.5, material = 'wood', shape = '12'},
      ['ceiling1'] = {x = 1.5, y = 4, material = 'wood', shape = '21'},
      ['ceiling2'] = {x = 4.5, y = 4, material = 'wood', shape = '21'},
      ['ceiling3'] = {x = 1, y = 5, material = 'wood', shape = 'square'},
      ['ceiling4'] = {x = 5, y = 5, material = 'wood', shape = 'square'},
      ['ceiling5'] = {x = 3, y = 5, material = 'wood', shape = '31'},
      ['balancer'] = {x = 3, y = 5.6, material = 'metal', shape = 'balancer'},
      ['alien1'] = {x = 2.5, y = 2, isAlien = true},
      ['alien2'] = {x = 3.5, y = 2, isAlien = true},
      ['alien3'] = {x = 2.5, y = 3, isAlien = true},
      ['alien4'] = {x = 3.5, y = 3, isAlien = true},
    },
    ['exhaustport'] = {
      ['ground1'] = {x = 1, y = 1.5, material = 'wood', shape = '22'},
      ['ground2'] = {x = 4.5, y = 1, material = 'wood', shape = '31'},
      ['wall1'] = {x = 1.5, y = 4, material = 'wood', shape = '23'},
      ['wall2'] = {x = 4.5, y = 3, material = 'wood', shape = '23'},
      ['ceiling2'] = {x = 4.5, y = 5, material = 'wood', shape = '21'},
      ['alien1'] = {x = 3.5, y = 2, isAlien = true},
    },
    ['boxpusher'] = {
      ['ground1'] = {x = 4, y = 1, material = 'wood', shape = '31'},
      ['wall1'] = {x = 1.5, y = 2, material = 'wood', shape = '23'},
      ['wall2'] = {x = 4, y = 3, material = 'wood', shape = '13'},
      ['wall3'] = {x = 5, y = 2.5, material = 'wood', shape = '12'},
      ['box1'] = {x = 1.5, y = 4, material = 'wood', shape = 'square'},
      ['ceiling1'] = {x = 1.5, y = 5, material = 'wood', shape = '21'},
      ['ceiling2'] = {x = 4, y = 5, material = 'wood', shape = '21'},
      ['alien1'] = {x = 3, y = 2.5, isAlien = true},
    },
    ['modernhouse'] = {
      ['wall1'] = {x = 1.5, y = 1.5, material = 'wood', shape = '22'},
      ['wall2'] = {x = 4.5, y = 1.5, material = 'wood', shape = '12'},
      ['wall3'] = {x = 2, y = 3, material = 'wood', shape = '31'},
      ['window1'] = {x = 1.2, y = 4, material = 'glass', shape = '21'},
      ['wall4'] = {x = 4.5, y = 3.5, material = 'wood', shape = '22'},
      ['ceiling1'] = {x = 2, y = 5, material = 'wood', shape = '21'},
      ['ceiling2'] = {x = 4, y = 5, material = 'wood', shape = '21'},
      ['balancer'] = {x = 3, y = 5.6, material = 'metal', shape = 'balancer'},
      ['alien1'] = {x = 3.5, y = 1.5, isAlien = true},
      ['alien2'] = {x = 3, y = 4, isAlien = true},
    },
  
  }