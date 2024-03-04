--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 120 -- originally 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

-- size of the gap between pipes
GAP_HEIGHT = 80

local musicPosition = 0

local spawnPowerup = false

function PlayState:init()
    
    self.birdMode = 1
    self.pipeMode = 1
  
    self.bird = Bird(self.birdMode)
    self.pipePairs = {}
    
    self.score = 0
    
    self.pause = 0
    
    self.timer = 1
    self.pipeSpawnTimer = 1.1
    
    self.timerLevel = 0
    self.levelChangeTimer = 11
    
    self.lastLevel = 0
    
    heightRandomizer = 30
    
    shielded = false
    self.shieldEndTime = self.timerLevel + 2
    cheatMode = false
    self.shieldDuration = 2.4
    

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    -- self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    -- self.lastY = -PIPE_HEIGHT + math.random(-40, 40) + VIRTUAL_HEIGHT/2
    self.lastY = VIRTUAL_HEIGHT/2
    
    createLayout()
end

function PlayState:update(dt)
  if self.pause == 0 then
    -- update timer for pipe spawning
    self.timer = self.timer + dt
    self.timerLevel = self.timerLevel + dt
    
    if self.timerLevel > self.levelChangeTimer then
      spawnPowerup = true
      self.timerLevel = 0
      -- GAP_HEIGHT = 90
    end
    
    -- spawn a new pipe pair every second and a half
    if self.timer > self.pipeSpawnTimer then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local max = 70 + GAP_HEIGHT/2
        local min = VIRTUAL_HEIGHT - (70 + GAP_HEIGHT/2)
        
        
        local yChange = math.random(-heightRandomizer, heightRandomizer)
        
        local y = self.lastY + yChange
        
        if y < max or y > min then
          y = self.lastY - yChange/2
        end

          self.lastY = y
            -- self.lastY = -180
            
          -- add a new pipe pair at the end of the screen at our new Y
          table.insert(self.pipePairs, PipePair(y, self.pipeMode))
        
        
        
        if spawnPowerup then
          
          if self.pipeMode == 1 then
            
            local levelSelect = math.random(3)
          
            if levelSelect == 1 then
              self.pipeMode = 2
            elseif levelSelect == 2 then
              self.pipeMode = 3
            elseif levelSelect == 3 then
              self.pipeMode = 4
            end
            
            if levelSelect == self.lastLevel then
              self.pipeMode = 5
              self.lastLevel = 0
            else
              self.lastLevel = levelSelect
            end

          else
            self.pipeMode = 1
          end
          
          
          
          
 
          self.powerup = Powerup(self.lastY, self.pipeMode)
          spawnPowerup = false
          
          
          if self.pipeMode == 5 then
            self.pipeSpawnTimer = 0.5
          elseif self.pipeMode == 4 then
            self.pipeSpawnTimer = 1.2
          else
            self.pipeSpawnTimer = 1
          end
          
          -- add extra delay until next pipe
          self.timer = self.timer - 1/self.pipeMode
          
          
          --self.lastY = VIRTUAL_HEIGHT/2
          
        end
        
        -- reset timer (with some chance to slightly increase time until next pair)
          self.timer = self.timer - self.pipeSpawnTimer * (1 + math.random(100) / 200)
        
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
                
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- simple collision between bird and all pipes in pairs
      for k, pair in pairs(self.pipePairs) do
          for l, pipe in pairs(pair.pipes) do
              if self.bird:collides(pipe) then

                  if (not shielded) and (not cheatMode) then
                  sounds['explosion']:play()
                  sounds['hurt']:play()
                  gStateMachine:change('score', {
                      score = math.floor(self.score),
                      bird = self.bird,
                      pipePairs = self.pipePairs,
                      pipeDeath = true
                  })
                  else
                    sounds['shieldhit']:play()
                  end
                 
              end
                
          end
      end
    

    -- reset if we get to the ground or ceiling
    if (self.bird.y + self.bird.height >= VIRTUAL_HEIGHT - 16 or self.bird.y <= 0) and not cheatMode then
      
      if shielded then
        sounds['shieldhit']:play()
      else      
        sounds['explosion']:play()
        sounds['hurt']:play()
        
        self.bird.death = true

        gStateMachine:change('score', {
            score = math.floor(self.score),
            bird = self.bird,
            pipePairs = self.pipePairs,
            pipeDeath = false
        })
      end
    end
    

    -- if we take a powerup, parameters change
    if self.powerup ~= nil then
      self.powerup:update(dt, self.bird)
      
      if self.powerup:collides(self.bird) then
        shielded = true
        self.shieldEndTime = self.timerLevel + self.shieldDuration
        -- local self.oldMode = self.birdMode
        self.birdMode = self.pipeMode
        self.bird:birdAppearance(self.birdMode)
        self.powerup = nil
        sounds['music']:setPitch(speedMultiplyer)
        sounds['powerup']:play()
      end
    end
    
    if shielded then
      if self.timerLevel > self.shieldEndTime then
        shielded = false
      end
    end
    
    if love.keyboard.wasPressed('z') then
      
      if cheatMode then
        cheatMode = false
      else
        cheatMode = true
      end

    end
    
    
    
    
    
    
    
    end
        
    if love.keyboard.wasPressed('p') then
        if self.pause == 0 then
          self.pause = 1
          scrolling = false
          musicPosition = sounds['music']:tell()
          love.audio.pause(sounds['music'])
          sounds['pause']:play()
        else
          self.pause = 0
          scrolling = true
          sounds['music']:play()
          sounds['music']:seek(musicPosition)
          sounds['pause']:play()
        end
    end
    
end

function PlayState:render()
    

    
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(math.floor(self.score)), 8, 8)
    
   
    if shielded then
      love.graphics.setColor(0, 0.6, 1, 0.8)
      love.graphics.rectangle('fill', self.bird.x - 8, self.bird.y - 8, self.bird.width + 16, self.bird.height + 16, 4, 4)
      love.graphics.setColor(0, 1, 1, 0.6)
      love.graphics.setLineWidth(9)
      love.graphics.rectangle('line', self.bird.x - 8, self.bird.y - 8, self.bird.width + 16, self.bird.height + 16, 4, 4)
      love.graphics.setColor(1, 1, 1, 1)
    end
    
    if cheatMode then
      local cheatIconSide = 22
      love.graphics.setColor(0, 0.6, 1, 0.8)
      love.graphics.rectangle('fill', cheatIconSide, VIRTUAL_HEIGHT - 2*cheatIconSide, cheatIconSide, cheatIconSide, 2, 2)
      love.graphics.setColor(0, 1, 1, 0.6)
      love.graphics.setLineWidth(cheatIconSide/3)
      love.graphics.rectangle('line', cheatIconSide, VIRTUAL_HEIGHT - 2*cheatIconSide, cheatIconSide, cheatIconSide, 2, 2)
      love.graphics.setColor(1, 1, 1, 1)
    end
    
      

    self.bird:render()
    

    
    
    if self.powerup ~= nil then
      self.powerup:render()
    end
    
    if self.pause == 1 then
      love.graphics.setFont(mediumFont)
      love.graphics.printf('Press P to resume the game', 0, 0.8*VIRTUAL_HEIGHT, VIRTUAL_WIDTH, 'center')
      
      love.graphics.setColor(1, 1, 1, 0.8)
      love.graphics.rectangle('fill', 0.5*VIRTUAL_WIDTH - 40, 0.5*VIRTUAL_HEIGHT - 50, 30, 100)
      love.graphics.rectangle('fill', 0.5*VIRTUAL_WIDTH + 10, 0.5*VIRTUAL_HEIGHT - 50, 30, 100)
    end
end

function createLayout()
  local levelLayout = {2,3,4,5}

  for i = #levelLayout, 2, -1 do
        local j = math.random(i)
        levelLayout[i], levelLayout[j] = levelLayout[j], levelLayout[i]
    end
    
  table.insert(levelLayout, 1, 1)

end

--[[
function transform()
  print(tostring(self.timerLevel))
  local time0 = self.timerLevel
  local transformationTime = 1
  local timeBetweenForms = 0.2
  cheatMode = 1
  
  while self.timerLevel < time0 + transformationTime do
    if self.timerLevel < time0 + timeBetweenForms then
      self.bird.trasnparent = -self.bird.transparent
      time0 = self.timerLevel
    end
  end

  cheatMode = 0
end

]]

  

-- lista de parámetros a cambiar cuando se crea el powerup: GAP_HEIGHT                              
-- lista de parámetros a cambiar cuando se recoge el powerup: self.bird.gravMultiplier, self.bird.jumpForce       


--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
    sounds['music']:play()
    sounds['music']:seek(0)
    sounds['music']:setPitch(speedMultiplyer)
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
    love.audio.pause(sounds['music'])
    speedMultiplyer = 1
end