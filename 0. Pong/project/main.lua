--[[
    GD50 2018
    Pong Remake

    -- Main Program --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'

-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Ball'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


sumPar = 200
divPar = 1.5

ballDispersion = 50

  
--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Pong')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    titleFont = love.graphics.newFont('font.ttf', 72)
    love.graphics.setFont(smallFont)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['menu_move'] = love.audio.newSource('sounds/menu_move.wav', 'static'),
        ['menu_select'] = love.audio.newSource('sounds/menu_select.wav', 'static'),
        ['menu_back'] = love.audio.newSource('sounds/menu_back.wav', 'static')
    }
    
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
  
  resetGame()
  
  end

--[[
    Called when we want to start a gamemode.
]]
function gameLoad(gameMode)
    gameMode = gameMode
    print('game is loaded' .. tostring(gameMode))
      -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    if gameMode == 'classic' then
      paddleHeight = 20
      paddleWidth = 5
      ballSize = 4
      PADDLE_SPEED = 200
      paddle1Start = 30
      paddle2Start = VIRTUAL_HEIGHT - 1.5*paddleHeight
    else
      paddleHeight = 40
      paddleWidth = 8
      ballSize = 6
      PADDLE_SPEED = 300
      paddle1Start = (VIRTUAL_HEIGHT / 2) - (paddleHeight / 2)
      paddle2Start = paddle1Start
    end
        
    player1 = Paddle(10, paddle1Start, paddleWidth, paddleHeight)
    
    if gameMode == 'practice' then
      player2 = Paddle(VIRTUAL_WIDTH - 2*paddleWidth, 0, 2*paddleWidth, VIRTUAL_HEIGHT)
    else
      player2 = Paddle(VIRTUAL_WIDTH - 2*paddleWidth, paddle2Start, paddleWidth, paddleHeight)
    end
   
    ball = Ball(VIRTUAL_WIDTH / 2 - ballSize / 2, VIRTUAL_HEIGHT / 2 - ballSize / 2, ballSize, ballSize)

    -- initialize score variables
    player1Score = 0
    player2Score = 0

    -- either going to be 1 or 2; whomever is scored on gets to serve the
    -- following turn
    if gameMode == 'PVE' then
      -- load PVE variables:
      setDelay = 0.5*delayMult
      currentDelay = 0
      botState = 'wait'
    end
    
    servingPlayer = 1
    
    idealPosition = 0
    -- player who won the game; not set to a proper value until we reach
    -- that state in the game
    winningPlayer = 0

    -- the state of our game; can be any of the following:
    -- 1. 'start' (the beginning of the game, before first serve)
    -- 2. 'serve' (waiting on a key press to serve the ball)
    -- 3. 'play' (the ball is in play, bouncing between paddles)
    -- 4. 'done' (the game is over, with a victor, ready for restart)
    inGame = 1
    gameState = 'start'
end
  
function gameLogic(dt)

  
    if gameState == 'serve' then

    idealPosition = 0
    numberBounces = 0
       
    elseif gameState == 'play' then
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position
        -- at which it collided, then playing a sound effect
        if ball:collides(player1) then

            oldBallXSpeed = math.abs(ball.dx)
            oldBallYSpeed = math.abs(ball.dy)
              
             -- ball.dy logic
            if gameMode == 'classic' then
              ball.dy = math.random(10, 150) * ball.dy/math.abs(ball.dy)
            else
              if player1Direction == 'up' and player1.y ~= 0 then
                ball.dy = ((ball.dy - sumPar) / divPar) + math.random(-ballDispersion, ballDispersion) / 2
              elseif player1Direction == 'down' and player1.y ~= (VIRTUAL_HEIGHT - player1.height) then
                ball.dy = ((ball.dy + sumPar) / divPar) + math.random(-ballDispersion, ballDispersion) / 2
              else
                if ball.dy > 0 then
                ball.dy = math.max(ball.dy * math.abs(ball.dx) / math.abs(ball.dy) / 2, ball.dy / 2) + math.random(0, ballDispersion)
                else
                ball.dy = math.min(ball.dy * math.abs(ball.dx) / math.abs(ball.dy) / 2, ball.dy / 2) - math.random(0, ballDispersion)
                end
              
                
              end
            end
            
            if player1Direction == 'stop' then
              maxSpeed = 1
            else
              maxSpeed = 2
            end            
            
            -- ball.dx logic
            if gameMode == 'classic' then
              ball.dx = -ball.dx * 1.03
              ball.x = player1.x + 5
            else
              ball.dx = math.min(math.max(oldBallYSpeed + oldBallXSpeed - math.abs(ball.dy), 0.9*oldBallXSpeed), 1.8*oldBallXSpeed*maxSpeed) + 15
              ball.x = player1.x + paddleWidth
            end
            

            if gameMode == 'practice' then
              player1Score = player1Score + 1
            end
            
    
            -- idealPosition calculations (FOR PVE)
            
            idealPositionCalc()
            
            sounds['paddle_hit']:play()
            
        end            

          if ball:collides(player2) then

            oldBallXSpeed = math.abs(ball.dx)
            oldBallYSpeed = math.abs(ball.dy)
              
             -- ball.dy logic

            if gameMode == 'classic' then
              ball.dy = math.random(10, 150) * ball.dy/math.abs(ball.dy)
            elseif gameMode == 'practice' then
              --print('bounces: ' .. tostring(numberBounces) .. '; idealPosition: ' .. tostring(idealPosition) .. '; collision y: ' .. tostring(ball.y) .. '; first bounce: ' .. tostring(firstBounce))
            else
              if player2Direction == 'up' and player2.y ~= 0 then
                ball.dy = ((ball.dy - sumPar) / divPar) + math.random(-ballDispersion, ballDispersion) / 2
              elseif player2Direction == 'down' and player2.y ~= (VIRTUAL_HEIGHT - player2.height) then
                ball.dy = ((ball.dy + sumPar) / divPar) + math.random(-ballDispersion, ballDispersion) / 2
              else
                if ball.dy > 0 then
                ball.dy = math.max(ball.dy * math.abs(ball.dx) / math.abs(ball.dy) / 2, ball.dy / 2) + math.random(0, ballDispersion)
                else
                ball.dy = math.min(ball.dy * math.abs(ball.dx) / math.abs(ball.dy) / 2, ball.dy / 2) - math.random(0, ballDispersion)
                end
              end
            end
            
            if player2Direction == 'stop' then
              maxSpeed = 1
            else
              maxSpeed = 2
            end
            
            -- ball.dx logic
            if gameMode == 'classic' then
              ball.dx = -ball.dx * 1.03
            elseif gameMode == 'practice' then
              ball.dx = -ball.dx
            else
              ball.dx = -math.min(math.max(oldBallYSpeed + oldBallXSpeed - math.abs(ball.dy), 0.9*oldBallXSpeed), 1.8*oldBallXSpeed*maxSpeed) + 15
            end
            ball.x = player2.x - ballSize

            sounds['paddle_hit']:play()
          
            idealPosition = 0
          
          end
          
          
        -- detect upper and lower screen boundary collision, playing a sound
        -- effect and reversing dy if true
        if ball.y <= 0 then
          if gameMode == 'classic' then
            ball.y = 0
          else
            ball.y = -ball.y
          end
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- -4 to account for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - ballSize then
          if gameMode == 'classic' then
            ball.y = VIRTUAL_HEIGHT - ballSize
          else
            ball.y = ball.y - 2*(ball.y - (VIRTUAL_HEIGHT - ballSize))
          end
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- if we reach the left edge of the screen, go back to serve
        -- and update the score and serving player
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            if gameMode == 'practice' then
            player1Score = 0
            end

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                -- places the ball in the middle of the screen, no velocity
                ball:reset()
            end
            
        end

        -- if we reach the right edge of the screen, go back to serve
        -- and update the score and serving player
        if ball.x > VIRTUAL_WIDTH and gameMode ~= 'practice' then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                -- places the ball in the middle of the screen, no velocity
                ball:reset()
            end
        end
    end

    --
    -- paddles can move no matter what state we're in
    --
    -- player 1
    if love.keyboard.isDown('w') then
        player1Direction = 'up'
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1Direction = 'down'
        player1.dy = PADDLE_SPEED
    else
        player1Direction = 'stop'
        player1.dy = 0
    end

    -- player 2
    if gameMode == 'PVP' or gameMode == 'classic' then
      if love.keyboard.isDown('up') then
          player2Direction = 'up'
          player2.dy = -PADDLE_SPEED
      elseif love.keyboard.isDown('down') then
          player2Direction = 'down'
          player2.dy = PADDLE_SPEED
      else
          player2Direction = 'stop'
          player2.dy = 0
      end
    else
      if love.keyboard.isDown('up') then
        player1Direction = 'up'
        player1.dy = -PADDLE_SPEED
      elseif love.keyboard.isDown('down') then
        player1Direction = 'down'
        player1.dy = PADDLE_SPEED
      end
    end
    
    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        ball:update(dt)
    end
    
    if gameMode == 'PVE' then
      PVElogic(difficulty, dt)
    end

    player1:update(dt)
    player2:update(dt)
end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]
function love.update(dt)

  if inGame == 1 then
    gameLogic(dt)
  end

end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)

    -- `key` will be whatever key this callback detected as pressed
    
    if key == 'f' then
      local fullscreen = love.window.getFullscreen()
      love.window.setFullscreen(not fullscreen)
    end

    if key == 'z' and gameMode == 'PVE' then
      if devMode == 1 then
        devMode = 0
      else
        devMode = 1
      end
    end
    
    if inGame == 0 then
      if key == 'escape' then
        if menu == 'play' then
          love.event.quit()
        elseif menu == 'PVE' then
          menu = 'play'
        else
          resetGame()
        end
        sounds['menu_back']:play()
      elseif key == 'enter' or key == 'return' then
        if menu == 'play' then
          if menuSelection == 1 then
          menu = 'PVE'
          elseif menuSelection == 2 then
          gameMode = 'PVP'
          gameLoad(gameMode)
          elseif menuSelection == 3 then
          gameMode = 'practice'
          gameLoad(gameMode)
          elseif menuSelection == 4 then
          gameMode = 'classic'
          gameLoad(gameMode)
          end
        elseif menu == 'PVE' then
          if menuSelection == 1 then
            difficulty = 'easy'
            delayMult = 1.3
          elseif menuSelection == 2 then
            difficulty = 'medium'
            delayMult = 1
          elseif menuSelection == 3 then
            difficulty = 'hard'
            delayMult = 0.8
          elseif menuSelection == 4 then
            difficulty = 'vhard'
            delayMult = 0.6
          end
          gameMode = 'PVE'
          gameLoad(gameMode)
        end
        sounds['menu_select']:play()
      elseif key == 's' or key == 'down' then
        menuSelection = math.min(menuSelection + 1, maxMenu)
        sounds['menu_move']:play()

      elseif key == 'w' or key == 'up' then
        menuSelection = math.max(menuSelection - 1, 1)
        sounds['menu_move']:play()
      end
      
    elseif inGame == 1 then
      if key == 'escape' then
        resetGame()
      elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            botState = 'return'
            gameState = 'serve'
        elseif gameState == 'serve' then
            calculateServe()
            gameState = 'play'
        elseif gameState == 'done' then
            -- game is simply in a restart phase here, but will set the serving
            -- player to the opponent of whomever won for fairness!
            gameState = 'serve'

            ball:reset()

            -- reset scores to 0
            player1Score = 0
            player2Score = 0

            -- decide serving player as the opposite of who won
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
            
        end
      end
    end
    
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    if inGame == 0 then
      drawMenu(menu)
    elseif inGame == 1 then
      if gameState == 'start' then
        -- UI messages
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
      elseif gameState == 'serve' then
        -- UI messages
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
      elseif gameState == 'play' then
        -- no UI messages to display in play
      elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
      end
    
      -- show the score before ball is rendered so it can move over the text
      displayScore()
      
      player1:render()
      player2:render()
      ball:render()
      
      if devMode == 1 then
        displayFPS()
        displayDevTools()
      end
     
    end   
     -- end our drawing to push
      push:apply('end')
end

--[[
    Simple function for rendering the scores.
]]
function displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    if gameMode == 'practice' then
      love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 8,
        VIRTUAL_HEIGHT / 3)
    else
      love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
      love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
    end
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayDevTools()
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print('botState: ' .. tostring(botState), 10, 20)
  love.graphics.print('idealPosition: ' .. tostring(idealPosition), 10, 30)
  if idealPosition ~= 0 then
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 20, idealPosition - 1, 3, 3)
  end
end

function drawMenu(menu)
    love.graphics.setFont(titleFont)
    love.graphics.printf('PONG 50', 0, 25, VIRTUAL_WIDTH, 'center')
  if menu == 'play' then
    maxMenu = 4
    love.graphics.rectangle('fill', 180, VIRTUAL_HEIGHT / 2 - 30 + menuSelection * 25, 6, 6)
    love.graphics.setFont(largeFont)
    love.graphics.printf('PVE', 190, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('PVP', 190, VIRTUAL_HEIGHT / 2 + 15, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Practice', 190, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Classic', 190, VIRTUAL_HEIGHT / 2 + 65, VIRTUAL_WIDTH, 'left')
    
  elseif menu == 'PVE' then
    maxMenu = 4
    
    love.graphics.rectangle('fill', 180, VIRTUAL_HEIGHT / 2 - 30 + menuSelection * 25, 6, 6)
    love.graphics.setFont(largeFont)
    love.graphics.printf('Easy', 190, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Normal', 190, VIRTUAL_HEIGHT / 2 + 15, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Hard', 190, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Very Hard', 190, VIRTUAL_HEIGHT / 2 + 65, VIRTUAL_WIDTH, 'left')

  end
end

function resetGame()
  inGame = 0
  menu = 'play'
  menuSelection = 1
  devMode = 0
end

function idealPositionCalc()
  timeUntilPaddle = (VIRTUAL_WIDTH - 2*paddleWidth - ball.x) / math.abs(ball.dx)
  if ball.dy > 0 then
    ballHeight = VIRTUAL_HEIGHT - ball.y - ballSize
    firstBounce = 'down'
  else
    ballHeight = ball.y
    firstBounce = 'up'
  end
  timeUntilWall = ballHeight / math.abs(ball.dy)
  idealPosition = ball.y + ballSize / 2 + math.min(timeUntilPaddle, timeUntilWall) * ball.dy
  ballDirection = 1
  numberBounces = 0
  while timeUntilPaddle > timeUntilWall do
    timeUntilPaddle = timeUntilPaddle - timeUntilWall
    ballHeight = VIRTUAL_HEIGHT - ballSize
    timeUntilWall = ballHeight / math.abs(ball.dy)
    ballDirection = -ballDirection
    idealPosition = idealPosition + math.min(timeUntilPaddle, timeUntilWall) * ball.dy * ballDirection
    numberBounces = numberBounces + 1
  end
end

function PVElogic(difficulty, dt)
  
  if botState == 'wait' then
    if idealPosition ~= 0 then
      delay(setDelay, 'move', dt)
    end
  elseif botState == 'move' then
    if idealPosition == 0 then
      botState = 'return'
    elseif (idealPosition < (player2.y + 3 * paddleHeight / 5) and idealPosition > (player2.y + 2 * paddleHeight / 5)) or player2.y == 0 or player2.y == VIRTUAL_HEIGHT - paddleHeight then
      botState = 'ready'
      player2Direction = 'stop'
      player2.dy = 0
    elseif idealPosition < (player2.y + 3 * paddleHeight / 5) then
      player2Direction = 'up'
      player2.dy = -PADDLE_SPEED
    elseif idealPosition > (player2.y + 2 * paddleHeight / 5) then
      player2Direction = 'down'
      player2.dy = PADDLE_SPEED
    end
  elseif botState == 'ready' then

    if idealPosition == 0 then
      delay(setDelay, 'return', dt)
    end
  elseif botState == 'return' then
    if player2.y > paddle2Start + 15 then
      player2Direction = 'up'
      player2.dy = -PADDLE_SPEED
    elseif player2.y < paddle2Start - 15 then
      player2Direction = 'down'
      player2.dy = PADDLE_SPEED
    else
      botState = 'wait'
      player2Direction = 'stop'
      player2.dy = 0
    end
  end
end


function delay(delayTime, newState, dt)
  currentDelay = currentDelay + dt
  
  delayLimit = delayTime + 0.8*delayTime*(numberBounces or 0)
  
  if currentDelay > delayLimit then
    currentDelay = 0
    botState = newState
  end
end

function calculateServe()
  
  ball.dx = math.random(140, 200)
  ball.dy = math.random(-50, 50)

  if gameMode ~= 'classic' then
    ball.dy = ball.dy + 20 * ball.dy / math.abs(ball.dy)
    ball.dx = ball.dx + (60 - math.abs(ball.dy)) * ball.dx / math.abs(ball.dx)
  end
  
  if servingPlayer == 2 then
    ball.dx = -ball.dx
  else
    idealPosition = ball.y + ball.dy * ((VIRTUAL_WIDTH - ball.x - 2*paddleWidth - ballSize) / ball.dx)
  end  
end