--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Alien = Class{}

function Alien:init(world, alienShape, x, y, type)
    self.world = world
    self.type = type
    self.material = type -- in aliens, used only for sounds
    self.health = 1
    --self.impulseLimit = 20000
    self.alienShape = alienShape or 'square'

    self.body = love.physics.newBody(self.world, 
        x or math.random(VIRTUAL_WIDTH), y or math.random(VIRTUAL_HEIGHT - 35),
        'dynamic')

    -- different shape and sprite based on alienShape passed in
    if self.alienShape == 'square' then
        self.shape = love.physics.newRectangleShape(35*scale, 35*scale)
        self.sprite = math.random(5)
    else
        self.shape = love.physics.newCircleShape(17.5*scale)
        self.sprite = 9
    end
    
    

    self.fixture = love.physics.newFixture(self.body, self.shape, 10)
    --self.impulseLimit = 500*self.body:getMass()
    self.impulseLimit = 5000*scale + 100*self.body:getMass()
    
    self.fixture:setRestitution(0.9)
    self.body:setAngularDamping(1)

    self.fixture:setUserData(self)

    -- used to keep track of despawning the Alien and flinging it
    self.launched = false
    
    self.recentlyDamaged = false
    
    self.score = 2000
end

function Alien:render()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(gTextures['aliens'], gFrames['aliens'][self.sprite], math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(), 1*scale, 1*scale, 17.5, 17.5)
      
  drawBodyShape(self.body)
end