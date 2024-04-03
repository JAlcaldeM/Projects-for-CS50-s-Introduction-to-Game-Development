function GenerateQuads(atlas, tilewidth, tileheight)
    
    local offset = 0.001 -- used to fix some visual aberrations
  
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth + offset, y * tileheight + offset, tilewidth - offset,
                tileheight - offset, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function drawBodyShape(body)
  if renderShapes then
    local shape = body:getFixtures()[1]:getShape() -- Obtiene la forma del primer accesorio del cuerpo
    local bodyType = body:getType() -- Obtiene el tipo de cuerpo (estático, dinámico, cinemático)

    love.graphics.setColor(1, 1, 1, 0.8) -- Establece el color de renderizado

    if shape:getType() == 'polygon' then -- Verifica si la forma es un polígono
        love.graphics.polygon('fill', body:getWorldPoints(shape:getPoints())) -- Renderiza el polígono
    elseif shape:getType() == 'circle' then -- Verifica si la forma es un círculo
        local x, y = body:getWorldPoints(shape:getPoint()) -- Obtiene las coordenadas del centro del círculo
        local radius = shape:getRadius() -- Obtiene el radio del círculo
        love.graphics.circle('fill', x, y, radius) -- Renderiza el círculo
    end
    love.graphics.setColor(1, 1, 1, 1)
  end

end

function divideProjectile(level, nProj)
  for _, object in pairs(level.projectiles) do
    if (not object.body:isDestroyed()) and object.isOriginal and (not object.hasCollided) then
      local xPos, yPos = object.body:getPosition()
      local xVel, yVel = object.body:getLinearVelocity()
      local angle = object.body:getAngle()
      local oldMass = object.body:getMass()
      local oldDensity = object.fixture:getDensity()
      local oldArea = object.body:getMass()/oldDensity
      object.body:destroy()
      local sizeModifier = (0.75 + 0.125*level.upgrades.sizeDivision) * (1 + 0.2*level.upgrades.size)
      local newHeight = sizeModifier*object.height
      local newWidth = sizeModifier*object.width
      local xNewProj = xPos + (newWidth/2)*math.cos(angle) + (newHeight/4*(nProj-1))*math.sin(angle)
      local yNewProj = yPos - (newHeight/4*(nProj-1))*math.cos(angle) + (newWidth/2)*math.sin(angle)
      for i = 1, nProj do
        local newMaterial = object.material
        if math.random() < 0.2*level.upgrades.explosiveDivision then
          newMaterial = 'explosive'
        end
        local newProjectile = Obstacle(level.world, newMaterial, object.shape, xNewProj, yNewProj, sizeModifier)
        newProjectile.fixture:setDensity(oldDensity)
        if object.framed and not (newMaterial == 'explosive') then
          newProjectile.framed = true
          newProjectile.frame = object.frame
          newProjectile.fixture:setDensity(newProjectile.fixture:getDensity()*1.5)
          newProjectile.impulseLimit = newProjectile.impulseLimit + 5000          
        end

        newProjectile.isThrown = true
        newProjectile.body:applyLinearImpulse(xVel*newProjectile.body:getMass(), yVel*newProjectile.body:getMass())
        newProjectile.fixture:setRestitution(0.4)
        newProjectile.body:setAngularDamping(1)
        
        table.insert(level.obstacles, newProjectile)
        table.insert(level.projectiles, newProjectile)
        xNewProj = xNewProj - (newHeight/2 + 2)*math.sin(angle) 
        yNewProj = yNewProj + (newHeight/2 + 2)*math.cos(angle)
      end -- originally 2 in the explosion range instead of 0
      table.insert(level.explosions, Explosion(level, xPos, yPos, 4*oldArea*scale*(1+0.5*level.upgrades.explosiveArea), 40*oldDensity*(1+0.5*level.upgrades.explosiveForce)))
    end
  end
end

function swap(array, i, j)
    local temp = array[i]
    array[i] = array[j]
    array[j] = temp
end

function bubbleSort(array)
    local n = #array
    for i = 1, n - 1 do
        for j = 1, n - i do
            if array[j] < array[j + 1] then
                swap(array, j, j + 1)
            end
        end
    end
end
