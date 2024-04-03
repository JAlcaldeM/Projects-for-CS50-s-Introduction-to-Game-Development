--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleState = Class{__includes = BaseState}

function BattleState:init(player)
    self.type = 'Battle'
    self.player = player
    self.bottomPanel = Panel(0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64)

    -- flag for when the battle can take input, set in the first update call
    self.battleStarted = false
    
    math.randomseed(os.time())
    self.opponent = Opponent {
        party = Party {
            pokemon = {
                Pokemon(Pokemon.getRandomDef(), math.random(2, 6))
            }
        }
    }
    print(#self.opponent.party.pokemon)
    --[[
    self.playerSprite = BattleSprite(self.player.party.pokemon[1].battleSpriteBack, 
        -64, VIRTUAL_HEIGHT - 128)
    self.opponentSprite = BattleSprite(self.opponent.party.pokemon[1].battleSpriteFront, 
        VIRTUAL_WIDTH, 8)
    ]]
    self.opponentSprite = Chimera(1.25, 0.3, true, 1.2, self.opponent.party.pokemon[1].seed)
      

    -- health bars for pokemon
    self.opponentHealthBar = ProgressBar {
        x = 8,
        y = 8,
        width = 152,
        height = 6,
        color = {r = 189/255, g = 32/255, b = 32/255},
        colorBackground = {r = 0.2, g = 0.2, b = 0.2},
        value = self.opponent.party.pokemon[1].currentHP,
        max = self.opponent.party.pokemon[1].HP
    }

    -- flag for rendering health (and exp) bars, shown after pokemon slide in
    self.renderAllyHealthBar = false
    self.renderEnemyHealthBar = false

    -- circles underneath pokemon that will slide from sides at start
    self.playerCircleX = -0.25*VIRTUAL_WIDTH
    self.opponentCircleX = 1.25*VIRTUAL_WIDTH

    -- references to active pokemon
    self.opponentPokemon = self.opponent.party.pokemon[1]
end

function BattleState:enter(params)
    
end

function BattleState:exit()
    gSounds['battle-music']:stop()
    -- gSounds['field-music']:play()
end

function BattleState:update(dt)
    -- this will trigger the first time this state is actively updating on the stack
    if not self.battleStarted then
        self:triggerSlideIn()
    end
    
    
end

function BattleState:render()
    love.graphics.clear(214/255, 214/255, 214/255, 1)

    love.graphics.setColor(45/255, 184/255, 45/255, 124/255)
    love.graphics.ellipse('fill', self.opponentCircleX, 0.4*VIRTUAL_HEIGHT + 10, 72, 24)
    love.graphics.ellipse('fill', self.playerCircleX, 0.7*VIRTUAL_HEIGHT + 10, 72*1.2, 24*1.2)

    love.graphics.setColor(1, 1, 1, 1)
    
    if self.playerSprite then
      self.playerSprite:render()
    end
    self.opponentSprite:render()
    

    if self.renderEnemyHealthBar then
        
        self.opponentHealthBar:render()
        
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(gFonts['small'])

        love.graphics.printf(self.opponentPokemon.name, self.opponentHealthBar.x, self.opponentHealthBar.y + 8, 152, 'left')
        --love.graphics.printf(math.ceil(self.opponentPokemon.currentHP)..'/'..self.opponentPokemon.HP,self.opponentHealthBar.x, self.opponentHealthBar.y + 8, 152, 'center')
        love.graphics.printf('Lv. '..self.opponentPokemon.level, self.opponentHealthBar.x, self.opponentHealthBar.y + 8, 152, 'right')

    end
    
    if self.renderAllyHealthBar then
      self.playerHealthBar:render()
      self.playerExpBar:render()
      
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.setFont(gFonts['small'])
        
      love.graphics.printf(self.playerPokemon.name, self.playerHealthBar.x, self.playerHealthBar.y - 10, 152, 'left')
      love.graphics.printf(math.ceil(self.playerPokemon.currentHP)..'/'..self.playerPokemon.HP, self.playerHealthBar.x, self.playerHealthBar.y - 10, 152, 'center')
      love.graphics.printf('Lv. '..self.playerPokemon.level, self.playerHealthBar.x, self.playerHealthBar.y - 10, 152, 'right')
      
    end
    

    self.bottomPanel:render()
end

function BattleState:triggerSlideIn()
    self.battleStarted = true

    -- slide the sprites and circles in from the edges, then trigger first dialogue boxes
    Timer.tween(1, {
        [self.opponentSprite] = {x = VIRTUAL_WIDTH - 140},
        [self] = {playerCircleX = 140, opponentCircleX = VIRTUAL_WIDTH - 140}
    })
    :finish(function()
        self:triggerStartingDialogue()
        self.renderEnemyHealthBar = true
    end)
end

function BattleState:triggerStartingDialogue()
    
    -- display a dialogue first for the pokemon that appeared, then the one being sent out
    gStateStack:push(BattleMessageState('A wild ' .. tostring(self.opponent.party.pokemon[1].name ..
        ' appeared!'),
    
    -- callback for when the battle message is closed
    function()
      local readyPokemons = {}
      for i, pokemon in ipairs(self.player.party.pokemon) do
        if self.player.party.pokemon[i].currentHP > 0 then
          table.insert(readyPokemons, i)
        end
      end
      self:newAlliedPokemon(readyPokemons[1])
    end))
end

function BattleState:newAlliedPokemon(i)
  
  self:newPlayerSprite(i)
  self:newPlayerHealthBar(i)
  self:newPlayerExpBar(i)
  
  self.playerPokemon = self.player.party.pokemon[i]
  
  self.playerSprite.x = 140
  self.playerSprite.y = 70
  
  gStateStack:push(BattleMessageState('Go, ' .. tostring(self.player.party.pokemon[i].name .. '!'),
    
        -- push a battle menu onto the stack that has access to the battle state
        function()

        end, false))
        gSounds['spawn']:play()
        Timer.tween(0.3, {
        [self.playerSprite] = {scale = 1.8}
        }):finish(function()
          Timer.tween(0.15, {
          [self.playerSprite] = {y = 151}
          })
          :finish(function()
            gSounds['thud']:play()
            Timer.after(0.2, function()
                gStateStack:pop()
                self.renderAllyHealthBar = true
                gStateStack:push(BattleMenuState(self))
            end)
            
          end)
        end)
        

end

function BattleState:newPlayerSprite(i)
  self.playerSprite = Chimera(-0.25, 0.7, false, 0.001, self.player.party.pokemon[i].seed)
end

function BattleState:newPlayerHealthBar(i)
  self.playerHealthBar = ProgressBar {
    x = VIRTUAL_WIDTH - 160,
    y = VIRTUAL_HEIGHT - 80,
    width = 152,
    height = 6,
    color = {r = 189/255, g = 32/255, b = 32/255},
    colorBackground = {r = 0.2, g = 0.2, b = 0.2},
    value = self.player.party.pokemon[i].currentHP,
    max = self.player.party.pokemon[i].HP
  }
end

function BattleState:newPlayerExpBar(i)
  self.playerExpBar = ProgressBar {
    x = VIRTUAL_WIDTH - 160,
    y = VIRTUAL_HEIGHT - 73,
    width = 152,
    height = 6,
    color = {r = 32/255, g = 32/255, b = 189/255},
    value = self.player.party.pokemon[i].currentExp,
    max = self.player.party.pokemon[i].expToLevel
  }
end