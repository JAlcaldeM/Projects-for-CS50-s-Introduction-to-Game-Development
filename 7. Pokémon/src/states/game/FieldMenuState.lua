
FieldMenuState = Class{__includes = BaseState}

function FieldMenuState:init(party)
  self.type = 'FieldMenu'
  self.party = party
  
  self.fieldMenu = Menu {
        x = VIRTUAL_WIDTH - 84,
        y = 0.25*VIRTUAL_HEIGHT,
        width = 64,
        height = 0.5*VIRTUAL_HEIGHT,
        font = gFonts['medium'],
        items = {
            {
                text = 'Party',
                onSelect = function()
                    gSounds['ok']:play()
                    gStateStack:push(FadeInState({
                        r = 0, g = 0, b = 0
                    }, 0.5,
                    function()
                      
                        gStateStack:pop()
                        gStateStack:push(PartyState(party))
                        gStateStack:push(FadeOutState({
                            r = 0, g = 0, b = 0
                        }, 0.5,
                        function() 

                        end))
                    end))
                    
                end
            },
            
            {
                text = 'Heal',
                onSelect = function()
                    gStateStack:pop()
                    gSounds['ok']:play()
                    gSounds['heal']:play()
                    for _, pokemon in pairs(self.party.pokemon) do
                      pokemon.currentHP = pokemon.HP
                    end
                    gStateStack:push(DialogueState('Your Pokemon have been healed!',
                
                    function()
                        self.dialogueOpened = false
                    end))
                end
            },
            
            {
                text = 'Back',
                onSelect = function()
                    gSounds['back']:play()
                    gStateStack:pop()
                end
            },
            
            {
                text = 'Exit',
                onSelect = function()
                    love.event.quit()
                end
            },
            
        }
    }
    
end

function FieldMenuState:update(dt)
  if love.keyboard.wasPressed('m') or love.keyboard.wasPressed('escape') then
    gSounds['back']:play()
    gStateStack:pop()
  end
  

  self.fieldMenu:update(dt)
end

function FieldMenuState:render()
  self.fieldMenu:render()
end