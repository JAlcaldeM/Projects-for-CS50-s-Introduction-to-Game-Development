--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

TakeTurnState = Class{__includes = BaseState}

function TakeTurnState:init(battleState)
    self.type = 'TakeTurn'
    self.battleState = battleState
    self.playerPokemon = self.battleState.playerPokemon
    self.opponentPokemon = self.battleState.opponent.party.pokemon[1]

    self.playerSprite = self.battleState.playerSprite
    self.opponentSprite = self.battleState.opponentSprite

    -- figure out which pokemon is faster, as they get to attack first
    if self.playerPokemon.speed > self.opponentPokemon.speed then
        self.firstPokemon = self.playerPokemon
        self.secondPokemon = self.opponentPokemon
        self.firstSprite = self.playerSprite
        self.secondSprite = self.opponentSprite
        self.firstBar = self.battleState.playerHealthBar
        self.secondBar = self.battleState.opponentHealthBar
    else
        self.firstPokemon = self.opponentPokemon
        self.secondPokemon = self.playerPokemon
        self.firstSprite = self.opponentSprite
        self.secondSprite = self.playerSprite
        self.firstBar = self.battleState.opponentHealthBar
        self.secondBar = self.battleState.playerHealthBar
    end
end

function TakeTurnState:enter(params)
    self:attack(self.firstPokemon, self.secondPokemon, self.firstSprite, self.secondSprite, self.firstBar, self.secondBar,

    function()

        -- remove the message
        gStateStack:pop()

        -- check to see whether the player or enemy died (is out of pokemon)
        if self:checkDeaths() then
            self:checkSwap()
            gStateStack:pop()
            return
        end

        self:attack(self.secondPokemon, self.firstPokemon, self.secondSprite, self.firstSprite, self.secondBar, self.firstBar,
    
        function()

            -- remove the message
            gStateStack:pop()

            -- check to see whether the player or enemy died (is out of pokemon)
            if self:checkDeaths() then
                self:checkSwap()
                gStateStack:pop()
                return
            end

            -- remove the last attack state from the stack
            gStateStack:pop()
            gStateStack:push(BattleMenuState(self.battleState))
        end)
    end)
end

function TakeTurnState:attack(attacker, defender, attackerSprite, defenderSprite, attackerkBar, defenderBar, onEnd)
    
    -- first, push a message saying who's attacking, then flash the attacker
    -- this message is not allowed to take input at first, so it stays on the stack
    -- during the animation
    gStateStack:push(BattleMessageState(attacker.name .. ' attacks ' .. defender.name .. '!',
        function() end, false))

    -- pause for half a second, then play attack animation
    Timer.after(0.5, function()
        
        
        -- attack sound
        gSounds['powerup']:stop()
        gSounds['powerup']:play()

        
        changeMouth(attackerSprite)
        Timer.after(1, function()
            changeMouth(attackerSprite)
          end)
        
        changeAnimation(attackerSprite, 'attack')
        Timer.after(1, function()
            changeAnimation(attackerSprite, 'default')
          end)
        -- blink the attacker sprite three times (turn on and off blinking 6 times)
        Timer.every(0.1, function()
            attackerSprite.blink = not attackerSprite.blink
            attackerSprite.blinkColor = white
            attackerSprite.shadow = not attackerSprite.shadow
        end)
        :limit(6)
        :finish(function()
            
            -- after finishing the blink, play a hit sound and flash the opacity of
            -- the defender a few times
            gSounds['hit']:stop()
            gSounds['hit']:play()
            
            
            
            changeMouth(defenderSprite)
            Timer.after(1, function()
                changeMouth(defenderSprite)
              end)
            changeAnimation(defenderSprite, 'defend')
            Timer.after(1, function()
                changeAnimation(defenderSprite, 'default')
              end)
            Timer.every(0.1, function()
                defenderSprite.visible = not defenderSprite.visible
                defenderSprite.shadow = not defenderSprite.shadow
            end)
            :limit(6)
            :finish(function()
                
                -- shrink the defender's health bar over half a second, doing at least 1 dmg
                local dmg = math.max(1, attacker.attack - defender.defense)
                
                local timer = 0.5
                if dmg > defender.currentHP then
                  timer = timer*(defender.currentHP/dmg)
                end
                
                
                Timer.tween(timer, {
                    [defenderBar] = {value = math.max(0, defender.currentHP - dmg)},
                    [defender] = {currentHP = math.max(0, defender.currentHP - dmg)}
                })
                :finish(function()
                    onEnd()
                end)
            end)
        end)
    end)
end

function TakeTurnState:checkDeaths()
    if self.playerPokemon.currentHP <= 0 then
        self:faint()
        return true
    elseif self.opponentPokemon.currentHP <= 0 then
        self:victory()
        return true
    end

    return false
end

function TakeTurnState:checkSwap()
  
  if self.playerPokemon.currentHP <= 0 then
    
    local remainingPokemon = false
    
    for _, pokemon in pairs(self.battleState.player.party.pokemon) do
      if pokemon.currentHP > 0 then
        remainingPokemon = true
      end
    end
    
    if remainingPokemon then
      gStateStack:push(FadeInState({
        r = 0, g = 0, b = 0
      }, 0.5,
      function()
        self.battleState.renderAllyHealthBar = false
        gStateStack:push(PartyState(self.battleState.player.party, self.battleState))
        
        gStateStack:push(FadeOutState({
            r = 0, g = 0, b = 0
        }, 0.5,
        function() 
          
        end))
      end))
    end
  end
end


function TakeTurnState:faint()

    -- drop player sprite down below the window
    gSounds['faint']:play()
    Timer.tween(0.2, {
        [self.playerSprite] = {y = 1.5*VIRTUAL_HEIGHT}
    })
    :finish(function()
        
        -- when finished, push a loss message
        gStateStack:push(BattleMessageState('You fainted!',
    
        function()

            -- fade in black
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                
                -- restore player pokemon to full health
                self.playerPokemon.currentHP = self.playerPokemon.HP

                -- resume field music
                gSounds['battle-music']:stop()
                gSounds['field-music']:play()
                
                -- pop off the battle state and back into the field
                gStateStack:popUntil('Play')
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1, function() 
                    gStateStack:push(DialogueState('Your Pokemon has been fully restored; try again!'))
                end))
            end))
        end))
    end)
end

function TakeTurnState:victory()

    -- drop enemy sprite down below the window
    gSounds['faint']:play()
    Timer.tween(0.3, {
        [self.opponentSprite] = {y = 1.5*VIRTUAL_HEIGHT}
    })
    :finish(function()
        -- play victory music
        gSounds['battle-music']:stop()

        gSounds['victory-music']:setLooping(true)
        gSounds['victory-music']:play()
        
        -- sum all IVs and multiply by level to get exp amount
        local exp = (self.opponentPokemon.HPIV + self.opponentPokemon.attackIV +
            self.opponentPokemon.defenseIV + self.opponentPokemon.speedIV) * self.opponentPokemon.level

        -- when finished, push a victory message
        gStateStack:push(BattleMessageState('Victory!', 
            function()
              self:expGain(exp, true)
            end
            ))
    end)
end

function TakeTurnState:fadeOutWhite()
    -- fade in
    gStateStack:push(FadeInState({
        r = 1, g = 1, b = 1
    }, 1, 
    function()

        -- resume field music
        gSounds['victory-music']:stop()
        gSounds['field-music']:play()
        
        -- pop off the battle state
        gStateStack:popUntil('Play')
        gStateStack:push(FadeOutState({
            r = 1, g = 1, b = 1
        }, 1, function() end))
    end))
end

function TakeTurnState:expGain(exp, original)
  


    gStateStack:push(BattleMessageState('You earned ' .. tostring(exp) .. ' experience points!',
        function() end, false))

    Timer.after(1.5, function()
        gSounds['exp']:play()

        -- animate the exp filling up
        Timer.tween(0.5, {
            [self.battleState.playerExpBar] = {value = math.min(self.playerPokemon.currentExp + exp, self.playerPokemon.expToLevel)}
        })
        :finish(function()
            
            -- pop exp message off
            gStateStack:pop()

            self.playerPokemon.currentExp = self.playerPokemon.currentExp + exp

            -- level up if we've gone over the needed amount
            if self.playerPokemon.currentExp > self.playerPokemon.expToLevel then
                
              
                local extraExp = math.ceil(self.playerPokemon.currentExp - self.playerPokemon.expToLevel)

                gSounds['levelup']:play()
                
                local HPPrevious, attackPrevious, defensePrevious, speedPrevious = self.playerPokemon.HP, self.playerPokemon.attack, self.playerPokemon.defense, self.playerPokemon.speed
                local HPIncrease, attackIncrease, defenseIncrease, speedIncrease = self.playerPokemon:levelUp()
                self.battleState.playerHealthBar.value = self.playerPokemon.currentHP
                self.battleState.playerHealthBar.max = self.playerPokemon.HP
                self.battleState.playerExpBar.value = 0
                self.battleState.playerExpBar.max = self.playerPokemon.expToLevel
                
                gStateStack:push(BattleMessageState(
                    'MAX. HP: ' .. HPPrevious .. ' + ' .. HPIncrease .. ' = ' .. HPPrevious + HPIncrease .. '                                                                           ' ..
                    'ATTACK:  ' .. attackPrevious .. ' + ' .. attackIncrease .. ' = ' .. attackPrevious + attackIncrease .. '                                                                           ' ..
                    'DEFENSE: ' .. defensePrevious .. ' + ' .. defenseIncrease .. ' = ' .. defensePrevious + defenseIncrease .. '                                                                           ' ..
                    'SPEED:   ' .. speedPrevious .. ' + ' .. speedIncrease .. ' = ' .. speedPrevious + speedIncrease
                  ,
                  function()
                    self:expGain(extraExp, false)
                  end), false)
                gStateStack:push(BattleMessageState('Congratulations! ' .. self.playerPokemon.name .. ' has leveled up!',
                  function()
                  end), false)

            else
                self:fadeOutWhite()

            end
        end)
    end)
end
