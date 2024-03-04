--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.pipeDeath = params.pipeDeath
    
    self.medal = Medal(self.score)
    
    self.delay = 0
    self.delayLimit = 0.5
    self.delayHasPassed = false
end

function ScoreState:update(dt)

    if not self.delayHasPassed then
      
      self.delay = self.delay + dt
    
      if self.delay > self.delayLimit then
        self.delayHasPassed = true
      end
      
    else
      
      if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        gStateMachine:change('countdown')
      end
      
    end

end

function ScoreState:render()
  
  -- Render pipes
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- Render bird
    self.bird:render()
    
    -- Render medal
    self.medal:render()
    
    -- Render powerup (if any)
    if self.powerup ~= nil then
      self.powerup:render()
    end
    
  
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH*0.7, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH*0.7, 'center')
    
    if self.medal.type == 'none' then
      love.graphics.printf('You did not win any medal this time...', 0, 130, VIRTUAL_WIDTH*0.7, 'center')
    else
      love.graphics.printf('Congrats! You won a ' .. tostring(self.medal.type) .. ' medal!', 0, 130, VIRTUAL_WIDTH*0.7, 'center')
    end
    
    if self.delayHasPassed then
      love.graphics.printf('Press Space to Play Again!', 0, 160, VIRTUAL_WIDTH*0.7, 'center')
    end
    
    
end