--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    
    self.balls = {}
    self.ball = params.ball
    
    self.level = params.level
    
    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = -50 -5*self.level
    table.insert(self.balls, self.ball)

    
    
    self.streak = false
    self.streakValue = 0
    self.streakHits = 3
    self.streakTime = 0
    self.streakTimeLimit = 1.5
    self.streaktoGrowPaddle = 3
    
    self.powerupTime = 10
    self.powerupTimeLimit = 10
    
    
    local needs0Key = true
    
    for k, brick in pairs(self.bricks) do
      if not brick.unlocked then
        needs0Key = false
      end
    end
    
    self.key = params.key or needs0Key
    self.keyTime = 0
    self.keyTimeLimit = 5
    
    
    self.powerups = {}

    highscore = false
    maxHighscore = self.highScores[1].score
    if self.score > maxHighscore then
      highscore = true
    end
    
    
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['music']:play()
            gSounds['music']:seek(musicPosition)
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        musicPosition = gSounds['music']:tell()
        love.audio.pause(gSounds['music'])
        gSounds['pause']:play()
        return
    end
    
    if love.keyboard.wasPressed ('z') then
      hasCheated = true
      self.paddle.size = 4
      self.paddle.width = 128
      self.health = 3
    end
    
    
    if not self.key then
      self.keyTime = self.keyTime + dt
      if self.keyTime >= self.keyTimeLimit then
        self.keyTime = 0
        local newBrick = Brick(VIRTUAL_WIDTH/2 - 16,VIRTUAL_HEIGHT/2 - 8)
        newBrick.keyed = true
        newBrick.color = 3
        newBrick.tier = 0
        table.insert(self.bricks, newBrick)
        self.key = true
        
        gSounds['brickappears']:play()
      end
      
    end
    
    self.powerupTime = self.powerupTime + dt
    if self.powerupTime >= self.powerupTimeLimit then
      table.insert(self.powerups, Powerup(9))
      self.powerupTime = 0
    end
    
    
    
    -- check how much time has passed since last hit and end streak if superior to the limit
    if self.streak then
      self.streakTime = self.streakTime + dt
      if self.streakTime >= self.streakTimeLimit then
        self:stopStreak()
      end
    end
    
      

    -- update positions based on velocity
    self.paddle:update(dt)
    
    if #self.powerups > 0 then
      for k, powerup in pairs(self.powerups) do
        if powerup:collides(self.paddle) then
          gSounds['powerup']:play()
          powerup.remove = true
          if powerup.effect == 9 then
            for k, ball in pairs(self.balls) do
              if ball.original then
                self:cloneSpawn(ball.x, ball.y, ball.dx, ball.dy, 'left')
                self:cloneSpawn(ball.x, ball.y, ball.dx, ball.dy, 'right')
              end
            end
          elseif powerup.effect == 10 then
            local notUsedYet = true
            for k, brick in pairs(self.bricks) do
              if notUsedYet and (not brick.unlocked) then
                brick.tier = brick.tier - 1
                brick.unlocked = true
                notUsedYet = false
                self.key = true
                self.keyTime = 0
              elseif (not notUsedYet) and (not brick.unlocked) then
                self.key = false
              end
              
            end
          end
        end
      end
    end
    

    -- apply the ball logic to each ball
    if #self.balls > 0 then
      for k, ball in pairs(self.balls) do
        ball:update(dt)
        
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy*1.02

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
            
            -- end streak mode and reset the ball streak
            if ball.original then
              if self.streak then
                self:stopStreak()
              else
                self.streakValue = 0
              end
            end
            
            
            
            gSounds['paddle-hit']:stop()
            gSounds['paddle-hit']:play()
        end

        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

              -- logic for unlocked bricks
              if brick.unlocked then
                
                local scoreGained = brick.tier * 200 + brick.color * 25
                
                if brick.color == 6 then
                  scoreGained = 1000
                elseif brick.keyed then
                  scoreGained = 0
                end
                
                  -- add to score
                self.score = self.score + scoreGained
                
                if brick.keyed and brick.color == 1 then
                  local newKey = Powerup(10)
                  newKey.x = brick.x + 8
                  newKey.y = brick.y
                  table.insert(self.powerups, newKey)
                  self.key = false
                end
                

                -- trigger the brick's hit function, which removes it from play
                brick:hit()
                
                if ball.original then
                  -- add to the ball streak
                  self.streakValue = self.streakValue + 1
                  
                  -- reset streak time
                  self.streakTime = 0
                  
                  -- if enough streak hits, enter streak mode
                  if self.streakValue == self.streakHits then
                    self.streak = true
                    ball.skin = 5
                    gSounds['enterstreak']:play()
                  end
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()
                    
                    self.paddle.size = 2
                    self.paddle.width = 64

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = math.min(3, self.health + 1),
                        score = self.score,
                        highScores = self.highScores,
                        ball = self:selectMainBall(),
                        recoverPoints = self.recoverPoints
                    })
                end
              
              else
                gSounds['wall-hit']:play()
                if brick.alive then
                  brick.hp = brick.hp - 1
                  if brick.hp == 0 then
                    brick.unlocked = true
                  end
                  
                end
                
              end
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end

        -- if main ball goes below bounds, revert to serve state and decrease health
        if ball.y >= VIRTUAL_HEIGHT then
          if ball.original then
            self.health = self.health - 1
            gSounds['hurt']:play()
            
            if self.paddle.size > 1 then
              self.paddle.size = self.paddle.size - 1
              self.paddle.width = self.paddle.width - 32
              self.paddle.x = self.paddle.x + 16
            end

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints,
                    key = self.key
                })
            end
          else
            table.remove(self.balls, k)
            gSounds['destroyedball']:play()
          end

        end
      end
    end


    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end
    
    -- delete powerups after collision with paddle or exit screen
    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)
        
        if powerup.y >= VIRTUAL_HEIGHT then
          gSounds['destroyedball']:play()
          powerup.remove = true
          if powerup.effect == 10 then
              self.key = false
            end
        end
        
        
        if powerup.remove then            
            table.remove(self.powerups, k)
        end
    end
    
    if self.score > maxHighscore and not highscore then
      highscore = true
      gSounds['newhighscore']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    
    
end

function PlayState:render()
  
    -- print the streak score
    if self.streak then
        love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 32 + 6*self.streakValue))
        love.graphics.setColor(1,1,1)
        love.graphics.printf(tostring(self.streakValue), 0, VIRTUAL_HEIGHT / 2 + 16 - 3*self.streakValue, VIRTUAL_WIDTH, 'center')
    end
  
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    
    if #self.balls > 0 then
      for k, ball in pairs(self.balls) do
        ball:render()
      end
    end
    

    for k, powerup in pairs(self.powerups) do
      powerup:render()
    end

    renderScore(self.score)
    renderHealth(self.health)
  

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end

function PlayState:stopStreak()
    self.score = self.score + self.streakValue*100
    self.streak = false
    for k, ball in pairs(self.balls) do
      if ball.original then
        ball.skin = self.paddle.skin
      end
    end
    
    if self.streakValue >= self.streaktoGrowPaddle then
      if self.paddle.size < 4 then
        self.paddle.size = self.paddle.size + 1
        self.paddle.width = self.paddle.width + 32
        self.paddle.x = self.paddle.x - 16
      else
        self.score = self.score + 500
      end
    end

    self.streakValue = 0
    self.streakTime = 0
    
    gSounds['exitstreak']:play()
end

function PlayState:selectMainBall()
  for k, ball in pairs(self.balls) do
    if ball.original then
      return ball
    end
  end
end

function PlayState:cloneSpawn(x, y, dx, dy, direction)

  local dxVariation = 5
  
  local alpha = math.pi/4
  
  local newBall = Ball(6)
  newBall.x = x
  newBall.y = y
  

  if direction == 'left' then
    newBall.dx = dx - dxVariation
  elseif direction == 'right' then
    newBall.dx = dx + dxVariation
  end
  
  newBall.dy =math.sqrt(math.abs(dx^2 + dy^2 - newBall.dx^2))*dy/math.abs(dy)*(dx^2 + dy^2 - newBall.dx^2)/math.abs(dx^2 + dy^2 - newBall.dx^2)

  newBall.original = false
  table.insert(self.balls, newBall)
end






