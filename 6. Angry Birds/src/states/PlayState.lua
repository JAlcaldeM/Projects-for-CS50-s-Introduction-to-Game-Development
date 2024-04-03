--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(level)
    self.level = level or Level(1, 0)
    self.level.playstate = self
    self.levelTranslateX = 0
    

end

function PlayState:update(dt)
    
    if love.keyboard.wasPressed('r') then
      if self.level.ammo > 1 then
        local newAmmo = self.level.ammo - 1
        self.level = Level(1, 0)
        self.level.playstate = self
        self.level.ammo = newAmmo
      end
    elseif love.keyboard.wasPressed('space') then
      divideProjectile(self.level, 3 + self.level.upgrades.numberDivision)
    end
    

    -- update camera
    if not self.level.launchMarker.launched then
      if love.keyboard.isDown('left') then
        self.levelTranslateX = self.levelTranslateX + MAP_SCROLL_X_SPEED * dt
      elseif love.keyboard.isDown('right') then
          self.levelTranslateX = self.levelTranslateX - MAP_SCROLL_X_SPEED * dt
      end
    elseif not self.camLocked then
      for _, projectile in pairs(self.level.projectiles) do
        if not projectile.body:isDestroyed() then
          local xPos, yPos = projectile.body:getPosition()
            self.levelTranslateX = -xPos + VIRTUAL_WIDTH/4--+ self.level.launchMarker.baseX
        end
      end
      
    end
    
    if self.levelTranslateX > 0.25*VIRTUAL_WIDTH then
        self.levelTranslateX = 0.25*VIRTUAL_WIDTH
    elseif self.levelTranslateX < self.level.levelTranslateXmin then
      self.levelTranslateX = self.level.levelTranslateXmin
      self.camLocked = true
    else
      self.level.background.xOffset = self.levelTranslateX/2
      --self.level.background:update(dt)
    end

    self.level:update(dt)
end

function PlayState:render()

    -- render background separate from level rendering
    self.level.background:render()

    love.graphics.translate(math.floor(self.levelTranslateX), 0)
    self.level:render()
    
    self.level.launchMarker:render()
    
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Level '..self.level.levelNumber, 5*scale*camSize - math.ceil(self.levelTranslateX), 5*scale*camSize, VIRTUAL_WIDTH - 5*scale*camSize, 'left')
    love.graphics.printf(self.level.score, 5*scale*camSize - math.ceil(self.levelTranslateX), 5*scale*camSize, VIRTUAL_WIDTH - 5*scale*camSize, 'right')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Projectiles remaining: '..self.level.ammo, 5*scale*camSize - math.ceil(self.levelTranslateX), 36*scale*camSize, VIRTUAL_WIDTH - 5*scale*camSize, 'left')
    
    if not self.level.launchMarker.launched and self.level.levelNumber == 1 and self.level.ammo == 3 then

        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Objective:', math.ceil(-self.levelTranslateX), 88*scale*camSize, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Destroy all square aliens to pass the level.', math.ceil(-self.levelTranslateX), 104*scale*camSize, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Reach and pass level 20 to win the game!', math.ceil(-self.levelTranslateX), 120*scale*camSize, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Instructions:', math.ceil(-self.levelTranslateX), 148*scale*camSize, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Click and drag to shoot the projectile.', math.ceil(-self.levelTranslateX), 164*scale*camSize, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Then, you CAN press space to divide it.', math.ceil(-self.levelTranslateX), 180*scale*camSize, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- render victory text if all aliens are dead
    if #self.level.aliens == 0 then
        
        love.graphics.setFont(gFonts['huge'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('VICTORY', math.ceil(-self.levelTranslateX), VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    if self.level.gameOver then
        love.graphics.setFont(gFonts['huge'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('GAME OVER', math.ceil(-self.levelTranslateX), VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    if self.level.levelNumber == 20 then
      love.graphics.setFont(gFonts['large'])
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.printf('LAST LEVEL', math.ceil(-self.levelTranslateX), 5*scale*camSize, VIRTUAL_WIDTH, 'center')
    end
    
end