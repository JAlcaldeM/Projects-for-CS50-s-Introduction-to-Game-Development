--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

AlienLaunchMarker = Class{}

function AlienLaunchMarker:init(world, level)
    self.world = world
    self.level = level
    -- starting coordinates for launcher used to calculate launch vector
    self.baseX = 200*scale
    self.baseY = (VIRTUAL_HEIGHT - 200*scale)

    -- shifted coordinates when clicking and dragging launch alien
    self.shiftedX = self.baseX
    self.shiftedY = self.baseY

    -- whether our arrow is showing where we're aiming
    self.aiming = false

    -- whether we launched the alien and should stop rendering the preview
    self.launched = false

    -- our alien we will eventually spawn
    self.projectile = nil
    
    self.throwAlien = true
    
    self.windows = {}
    
    self.initialThrowStrength = 10
    
    
    self.material = upgradeToMaterial[self.level.upgrades.material]
    self.shape = upgradeToShape[self.level.upgrades.shape]
    
    local frameCode = self.level.upgrades.material
    if frameCode == 1 or frameCode == 3 then
      self.framed = true
      self.frame = upgradeToFrame[self.level.upgrades.material]
    end
    
    
    
    --[[
    local window = Window(self, 50, 50, 50, 50)
    window.material = 'wood'
    window.texture = gFrames[window.material]['circle'][3]
    table.insert(self.windows, window)
    ]]
    --[[
    local offset = 5*scale
    local windowSize = 50*scale
    for i = 0, #materialsList - 1 do
      local window = Window(3*windowSize + (windowSize + offset)*i, 10*scale, windowSize, windowSize)
      window.icon = true
      window.playstate = self.level.playstate
      window.material = materialsList[i+1]
      window.shape = 'circle'
      window.onClick = function()
        if not window.goBack then
          self.throwMaterial = window.material
          self.throwShape = window.shape
          self.throwAlien = false
          window.goBack = true
        else
          self.throwAlien = true
          window.goBack = false
        end
      end
      table.insert(self.windows, window)
    end
    ]]
    
    self.overWindow = false
    self.angThrow = 0
    
    self.sizeModifier = 1 + 0.2*self.level.upgrades.size
    
    self.texture = gFrames[self.material][self.shape]
    
end

function AlienLaunchMarker:update(dt)
  
  
    
    -- perform everything here as long as we haven't launched yet
    if not self.launched then
      
      if #self.level.aliens == 0 then
        Timer.after(1, function()
          self.level:checkVictory()
        end)
      end

        -- grab mouse coordinates
        local x, y = push:toGame(love.mouse.getPosition())
        
        self.overWindow = false
        for i, window in ipairs(self.windows) do
          --window:update(dt)
          if window:mouseIsOver(x,y) then
            window.shadow = true
            self.overWindow = true
            if love.mouse.wasPressed(1) then
              for k, window in ipairs(self.windows) do
                if not (i == k) then
                  window.goBack = false
                end
              end
              window:onClick()
            end
          else
            window.shadow = false
          end

      end

        self.angThrow = math.atan2( self.shiftedY - self.baseY, self.shiftedX - self.baseX)
        if math.cos(self.angThrow) < 0 then self.angThrow = self.angThrow + math.pi end
        
        -- if we click the mouse and haven't launched, show arrow preview
        if love.mouse.wasPressed(1) and (not self.launched) and (not self.overWindow) then
            self.aiming = true
        
        elseif love.mouse.wasPressed(2) and self.aiming then
          self.aiming = false
          self.shiftedX = self.baseX
          self.shiftedY = self.baseY
          
          
          
        -- if we release the mouse, launch an Alien
        elseif love.mouse.wasReleased(1) and self.aiming then
            self.launched = true
            
            if self.throwAlien then
              -- spawn new alien in the world, passing in user data of player
              --self.projectile = Alien(self.world, 'round', self.shiftedX, self.shiftedY, 'Player')
              self.projectile = Obstacle(self.world, self.material, self.shape, self.shiftedX, self.shiftedY, self.sizeModifier)
            else
              self.projectile = Obstacle(self.world, self.throwMaterial, 'circle', self.shiftedX, self.shiftedY, self.sizeModifier)
            end
            if self.framed then
              self.projectile.framed = true
              self.projectile.frame = self.frame
              self.projectile.fixture:setDensity(self.projectile.fixture:getDensity()*1.5)
              self.projectile.impulseLimit = self.projectile.impulseLimit + 5000
            end
            
            self.projectile.impulseLimit = self.projectile.impulseLimit
            self.projectile.isThrown = true
            self.projectile.body:setAngle(self.angThrow)
            table.insert(self.level.obstacles,self.projectile)
            table.insert(self.level.projectiles, self.projectile)
            self.projectile.isOriginal = true
            Timer.after(1, function()
              self.level.newLauncher = false
                end)
            
            self.level.ammo = self.level.ammo - 1

            -- apply the difference between current X,Y and base X,Y as launch vector impulse
            self.projectile.body:setLinearVelocity((self.baseX - self.shiftedX) * self.initialThrowStrength, (self.baseY - self.shiftedY) * self.initialThrowStrength)

            -- make the alien pretty bouncy
            self.projectile.fixture:setRestitution(0.4)
            self.projectile.body:setAngularDamping(1)

            -- we're no longer aiming
            self.aiming = false
            
            -- camera movement
            --self.level.playstate.levelTranslateX = 0

        elseif self.aiming then
              function distance(x1, y1, x2, y2)
                  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
              end
              local circleRadius = 30 * scale * (1 + 0.5 * self.level.upgrades.strengthThrow)
              local distToCenter = distance(self.baseX, self.baseY, x, y)
              if distToCenter <= circleRadius then
                  self.shiftedX = x
                  self.shiftedY = y
              else
                  local angle = math.atan2(y - self.baseY, x - self.baseX)
                  self.shiftedX = self.baseX + circleRadius * math.cos(angle)
                  self.shiftedY = self.baseY + circleRadius * math.sin(angle)
              end
        end
    end
end

function AlienLaunchMarker:render()
    if not self.launched then
      
        for _, window in pairs (self.windows) do
          window:render()
        end
        
        --love.graphics.printf(self.angThrow, 0, 0.8*VIRTUAL_HEIGHT, VIRTUAL_WIDTH, 'center')
        
        -- render base alien, non physics based
        love.graphics.setColor(1,1,1,1)
        
        if self.throwAlien then
          --[[
          --love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], self.shiftedX - 17.5*scale, self.shiftedY - 17.5*scale, 0, 1*scale, 1*scale)
          
                    love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], math.floor(self.shiftedX), math.floor(self.shiftedY), self.angThrow, 1*scale*self.sizeModifier, 1*scale*self.sizeModifier, 17.5, 17.5)
        ]]

        local xText, yText, widthText, heightText = self.texture[3]:getViewport()
        love.graphics.push()
        
        love.graphics.translate(self.shiftedX, self.shiftedY)
        love.graphics.scale(self.sizeModifier*scale)
        love.graphics.rotate(self.angThrow)
        love.graphics.draw(gTextures[self.material], self.texture[3], -widthText/2, -heightText/2)
        if self.framed then
          love.graphics.draw(gTextures[self.frame], gFrames[self.frame][self.shape..'frame'][3], -widthText/2, -heightText/2)
        end
        love.graphics.setColor(1,1,1,0.6)
        love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], -17.5, -17.5)-- -17.5/2*scale, -17.5*0.5*scale)
        love.graphics.pop()


          
          
        else
          love.graphics.draw(gTextures[self.throwMaterial], gFrames[self.throwMaterial][self.throwShape][3], math.floor(self.shiftedX - 17.5*scale), math.floor(self.shiftedY - 17.5*scale), 0, 1*scale*self.sizeModifier, 1*scale*self.sizeModifier)
          love.graphics.setColor(1,1,1,0.6)
          love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], math.floor(self.shiftedX), math.floor(self.shiftedY), self.angThrow, 1*scale*self.sizeModifier, 1*scale*self.sizeModifier, 17.5, 17.5)

        end
        
        

        if self.aiming then
            
            -- render arrow if we're aiming, with transparency based on slingshot distance
            local impulseX = (self.baseX - self.shiftedX) * self.initialThrowStrength
            local impulseY = (self.baseY - self.shiftedY) * self.initialThrowStrength

            -- draw 18 circles simulating trajectory of estimated impulse
            local trajX, trajY = self.shiftedX, self.shiftedY
            local gravX, gravY = self.world:getGravity()

            -- http://www.iforce2d.net/b2dtut/projected-trajectory
            for i = 1, 90 do
                
                -- magenta color that starts off slightly transparent
                love.graphics.setColor(255/255, 80/255, 255/255, ((255 / 24) * i) / 255)
                
                -- trajectory X and Y for this iteration of the simulation
                trajX = self.shiftedX + i * 1/60 * impulseX
                trajY = self.shiftedY + i * 1/60 * impulseY + 0.5 * (i * i + i) * gravY * 1/60 * 1/60

                -- render every fifth calculation as a circle
                if i % 5 == 0 then
                    love.graphics.circle('fill', trajX, trajY, 3*scale*camSize)
                end
            end
        end
        
        love.graphics.setColor(1, 1, 1, 1)
    else
      if self.projectile.type == 'Player' then
        self.projectile:render()
      end
    end
end