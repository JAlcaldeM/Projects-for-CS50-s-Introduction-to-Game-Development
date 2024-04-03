--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.type = 'Play'
    self.level = Level()

    gSounds['field-music']:setLooping(true)
    gSounds['field-music']:play()

    self.dialogueOpened = false
end

function PlayState:update(dt)
    
    if love.keyboard.wasPressed('m') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
      gStateStack:push(FieldMenuState(self.level.player.party))
      gSounds['swap']:play()
    elseif love.keyboard.wasPressed('escape') then
      love.event.quit()
    end
    
    --[[
    --used for testing
    if love.keyboard.wasPressed('c') then
      self.level.player.party.pokemon[1].attack = 99
      self.level.player.party.pokemon[1].speed = 99
      gSounds['heal']:play()
    elseif love.keyboard.wasPressed('v') then
      self.level.player.party.pokemon[1].currentHP = 1
      self.level.player.party.pokemon[1].speed = 1
      gSounds['heal']:play()
    end
    ]]

    self.level:update(dt)
end

function PlayState:render()
    self.level:render()
end