--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    self.type = 'Start'
    gSounds['intro-music']:play()

    self.sprite = Chimera(0.5, 0.55, true, 1.2)


    self.tween = Timer.every(3, function()
        Timer.tween(0.2, {
            [self.sprite] = {x = - VIRTUAL_WIDTH / 4}
        })
        :finish(function()
            self.sprite = Chimera(1.25, 0.55, true, 1.2)

            Timer.tween(0.2, {
                [self.sprite] = {x = VIRTUAL_WIDTH / 2}
            })
        end)
    end)
end

function StartState:update(dt)
  if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('e') or love.keyboard.wasPressed('return') then
      
        gStateStack:push(FadeInState({
            r = 1, g = 1, b = 1
        }, 1,
        function()
            gSounds['intro-music']:stop()
            self.tween:remove()

            gStateStack:pop()
            
            gStateStack:push(PlayState())
            gStateStack:push(DialogueState(
                "Welcome to the world of 50Mon! To start fighting monsters with your own party of 3 procedurally generated monsters, " ..
                "just walk in the tall grass! If you want to heal or check your monsters, open the menu with 'Space'! " ..
                "Good luck! (Press Space)"
            ))
            gStateStack:push(FadeOutState({
                r = 1, g = 1, b = 1
            }, 1,
            function() end))
        end))
    
      gSounds['entergame']:play()
    
  elseif love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function StartState:render()
    love.graphics.clear(188/255, 188/255, 188/255, 1)

    love.graphics.setColor(24/255, 24/255, 24/255, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('50-Mon!', 0, VIRTUAL_HEIGHT / 2 - 92, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 78, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])

    love.graphics.setColor(45/255, 184/255, 45/255, 124/255)
    love.graphics.ellipse('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 42, 72, 24)

    love.graphics.setColor(1, 1, 1, 1)
    self.sprite:render()
end