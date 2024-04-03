--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    self.background = Background()
    self.world = love.physics.newWorld(0, 300*scale)

    -- ground
    self.groundBody = love.physics.newBody(self.world, 0, VIRTUAL_HEIGHT, 'static')
    self.groundShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH, 0)
    self.groundFixture = love.physics.newFixture(self.groundBody, self.groundShape)

    -- walls
    self.leftWallBody = love.physics.newBody(self.world, 0, 0, 'static')
    self.rightWallBody = love.physics.newBody(self.world, VIRTUAL_WIDTH, 0, 'static')
    self.wallShape = love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT)
    self.leftWallFixture = love.physics.newFixture(self.leftWallBody, self.wallShape)
    self.rightWallFixture = love.physics.newFixture(self.rightWallBody, self.wallShape)

    -- lots of aliens
    self.aliens = {}

    for i = 1, 400 do
      local alien = Alien(self.world)
      alien.fixture:setRestitution(0.2)
      alien.body:setAngularDamping(10)
      table.insert(self.aliens, alien)
    end
    
    gSounds['music']:setLooping(true)
    gSounds['music']:play()
end

function StartState:update(dt)
    self.world:update(dt)

    if love.mouse.wasPressed(1) then
        gStateMachine:change('play')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    self.background:render()

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    -- title text
    love.graphics.setColor(64/255, 64/255, 64/255, 200/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 164*scale*camSize, VIRTUAL_HEIGHT / 2 - 40*scale*camSize,
        328*scale*camSize, 108*scale*camSize, 3*scale*camSize)
    
    love.graphics.setColor(200/255, 200/255, 200/255, 1)
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('Angry 50', 0, VIRTUAL_HEIGHT / 2 - 40*scale*camSize, VIRTUAL_WIDTH, 'center')

    -- instruction text
    -- love.graphics.setColor(64, 64, 64, 200)
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 164, VIRTUAL_HEIGHT / 2 + 56,
    --     328, 64, 3)
    
    love.graphics.setColor(200/255, 200/255, 200/255, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press F to activate fullscreen!', 0, VIRTUAL_HEIGHT / 2 + 30*scale*camSize, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Click to start!', 0, VIRTUAL_HEIGHT / 2 + 50*scale*camSize, VIRTUAL_WIDTH, 'center')
end