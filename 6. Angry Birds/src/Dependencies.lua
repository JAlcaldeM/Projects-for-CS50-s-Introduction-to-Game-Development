--[[
    GD50
    Angry Birds
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Alien'
require 'src/AlienLaunchMarker'
require 'src/Background'
require 'src/constants'
require 'src/Level'
require 'src/Obstacle'
require 'src/StateMachine'
require 'src/Util'
require 'src/Window'
require 'src/Explosion'
require 'src/obstacleGenerator'

require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/UpgradeState'


gTextures = {
    -- backgrounds
    ['blue-desert'] = love.graphics.newImage('graphics/blue_desert.png'),
    ['blue-grass'] = love.graphics.newImage('graphics/blue_grass.png'),
    ['blue-land'] = love.graphics.newImage('graphics/blue_land.png'),
    ['blue-shroom'] = love.graphics.newImage('graphics/blue_shroom.png'),
    ['colored-land'] = love.graphics.newImage('graphics/colored_land.png'),
    ['colored-desert'] = love.graphics.newImage('graphics/colored_desert.png'),
    ['colored-grass'] = love.graphics.newImage('graphics/colored_grass.png'),
    ['colored-shroom'] = love.graphics.newImage('graphics/colored_shroom.png'),

    -- aliens
    ['aliens'] = love.graphics.newImage('graphics/aliens.png'),

    -- tiles
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),

    -- obstacles
    ['wood'] = love.graphics.newImage('graphics/wood.png'),
    ['glass'] = love.graphics.newImage('graphics/glass.png'),
    ['stone'] = love.graphics.newImage('graphics/stone.png'),
    ['metal'] = love.graphics.newImage('graphics/metal.png'),
    ['explosive'] = love.graphics.newImage('graphics/explosive.png'),

    -- arrow for trajectory
    ['arrow'] = love.graphics.newImage('graphics/arrow.png')
}


for _, texture in pairs(gTextures) do
    texture:setFilter('nearest', 'nearest')
end

--[[

gTextures['tiles']:setFilter('nearest', 'nearest')
gTextures['aliens']:setFilter('nearest', 'nearest')
for _, material in pairs(materialsList) do
  gTextures[material]:setFilter('nearest', 'nearest')
end
]]

gSounds = {
    ['bounce'] = love.audio.newSource('sounds/bounce.wav', 'static'),
    ['1k'] = love.audio.newSource('sounds/1k.wav', 'static'),
    ['2k'] = love.audio.newSource('sounds/2k.wav', 'static'),
    ['fanfare1'] = love.audio.newSource('sounds/fanfare1.mp3', 'static'),
    ['fanfare2'] = love.audio.newSource('sounds/fanfare2.mp3', 'static'),
    ['clapping'] = love.audio.newSource('sounds/clapping.wav', 'static'),
    ['score'] = {
      love.audio.newSource('sounds/score1.wav', 'static'),
      love.audio.newSource('sounds/score2.wav', 'static'),
      love.audio.newSource('sounds/score3.wav', 'static'),
      love.audio.newSource('sounds/score4.wav', 'static'),
      love.audio.newSource('sounds/score5.wav', 'static'),
      love.audio.newSource('sounds/score6.wav', 'static'),
      love.audio.newSource('sounds/score7.wav', 'static'),
      love.audio.newSource('sounds/score8.wav', 'static'),
    },
    
    ['Alien'] = {
      love.audio.newSource('sounds/kill.wav', 'static'),
      },

    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    
    ['wood'] = {
      love.audio.newSource('sounds/break1.wav', 'static'),
      love.audio.newSource('sounds/break2.wav', 'static'),
      love.audio.newSource('sounds/break3.mp3', 'static'),
      love.audio.newSource('sounds/break4.wav', 'static'),
      love.audio.newSource('sounds/break5.wav', 'static'),
    },
    
    ['glass'] = {
      love.audio.newSource('sounds/mixkit-glass-break-with-hammer-thud-759.wav', 'static'),
      love.audio.newSource('sounds/mixkit-glass-hitting-a-metal-2183.wav', 'static'),
    },
    
    ['stone'] = {
      love.audio.newSource('sounds/stone1.wav', 'static'),
      love.audio.newSource('sounds/stone2.wav', 'static'),
    },
    
    ['metal'] = {
      love.audio.newSource('sounds/mixkit-metal-hammer-hit-833.wav', 'static'),
      love.audio.newSource('sounds/mixkit-metal-tool-drop-835.wav', 'static'),
    },
    
    ['explosive'] = {
      love.audio.newSource('sounds/mixkit-classic-click-1117.wav', 'static'),
      love.audio.newSource('sounds/mixkit-handgun-click-1660.mp3', 'static'),
    },
    
    ['explosion'] = {
      love.audio.newSource('sounds/explosion1.wav', 'static'),
      love.audio.newSource('sounds/explosion2.wav', 'static'),
      love.audio.newSource('sounds/explosion3.wav', 'static'),
      love.audio.newSource('sounds/explosion4.wav', 'static'),
      },
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8*scale*camSize),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16*scale*camSize),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32*scale*camSize),
    ['huge'] = love.graphics.newFont('fonts/font.ttf', 64*scale*camSize)
}





function dim() return 512, 512 end
local offset = 0.1
gFrames = {
    ['aliens'] = GenerateQuads(gTextures['aliens'], 35, 35),
    ['tiles'] = GenerateQuads(gTextures['tiles'], 35, 35),
    
    ['wood'] = {
      ['31'] = {
        [3] = love.graphics.newQuad(0+offset, 35+offset, 110-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 140+offset, 110-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 0+offset, 110-offset, 35-offset, dim()),
      },
      ['13'] = {
        [3] = love.graphics.newQuad(355+offset, 355+offset, 35-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(320+offset, 0+offset, 35-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 180+offset, 35-offset, 110-offset, dim()),
      },
      ['32'] = {
        [3] = love.graphics.newQuad(0+offset, 315+offset, 110-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 420+offset, 110-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 175+offset, 110-offset, 70-offset, dim()),
      },
      ['23'] = {
        [3] = love.graphics.newQuad(250+offset, 175+offset, 70-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 390+offset, 70-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 35+offset, 70-offset, 110-offset, dim()),
      },
      ['22'] = {
        [3] = love.graphics.newQuad(250+offset, 70+offset, 70-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 180+offset, 70-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 180+offset, 70-offset, 70-offset, dim()),
      },
      ['21'] = {
        [3] = love.graphics.newQuad(250+offset, 285+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 140+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 395+offset, 70-offset, 35-offset, dim()),
      },
      ['12'] = {
        [3] = love.graphics.newQuad(320+offset, 110+offset, 35-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 215+offset, 35-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(390+offset, 0+offset, 35-offset, 70-offset, dim()),
      },
      ['triangle'] = {
        [3] = love.graphics.newQuad(110+offset, 360+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 250+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 145+offset, 70-offset, 35-offset, dim()),
      },
      ['square'] = {
        [3] = love.graphics.newQuad(320+offset, 470+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(320+offset, 290+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(285+offset, 460+offset, 35-offset, 35-offset, dim()),
      },
      ['circle'] = {
        [3] = love.graphics.newQuad(285+offset, 320+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 180+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(285+offset, 355+offset, 35-offset, 35-offset, dim()),
      },
      ['balancer'] = {
        [3] = love.graphics.newQuad(0+offset, 507+offset, 180-offset, 5-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 507+offset, 180-offset, 5-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 507+offset, 180-offset, 5-offset, dim()),
      },
    },
    
    ['glass'] = {
      ['31'] = {
        [3] = love.graphics.newQuad(0+offset, 70+offset, 110-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 245+offset, 110-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 280+offset, 110-offset, 35-offset, dim()),
      },
      ['13'] = {
        [3] = love.graphics.newQuad(355+offset, 105+offset, 35-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 320+offset, 35-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 215+offset, 35-offset, 110-offset, dim()),
      },
      ['32'] = {
        [3] = love.graphics.newQuad(0+offset, 0+offset, 110-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 175+offset, 110-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 105+offset, 110-offset, 70-offset, dim()),
      },
      ['23'] = {
        [3] = love.graphics.newQuad(250+offset, 210+offset, 70-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 145+offset, 70-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 250+offset, 70-offset, 110-offset, dim()),
      },
      ['22'] = {
        [3] = love.graphics.newQuad(180+offset, 255+offset, 70-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 395+offset, 70-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 180+offset, 70-offset, 70-offset, dim()),
      },
      ['21'] = {
        [3] = love.graphics.newQuad(220+offset, 0+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 140+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 35+offset, 70-offset, 35-offset, dim()),
      },
      ['12'] = {
        [3] = love.graphics.newQuad(390+offset, 0+offset, 35-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 0+offset, 35-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 0+offset, 35-offset, 70-offset, dim()),
      },
      ['triangle'] = {
        [3] = love.graphics.newQuad(250+offset, 35+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 175+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 430+offset, 70-offset, 35-offset, dim()),
      },
      ['square'] = {
        [3] = love.graphics.newQuad(320+offset, 395+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(320+offset, 180+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(355+offset, 285+offset, 35-offset, 35-offset, dim()),
      },
      ['circle'] = {
        [3] = love.graphics.newQuad(355+offset, 355+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 70+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(285+offset, 390+offset, 35-offset, 35-offset, dim()),
      },
    },
    
    ['stone'] = {
      ['31'] = {
        [3] = love.graphics.newQuad(0+offset, 35+offset, 110-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 140+offset, 110-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 0+offset, 110-offset, 35-offset, dim()),
      },
      ['31frame'] = {
        [3] = love.graphics.newQuad(110+offset, 0+offset, 110-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 385+offset, 110-offset, 35-offset, dim()),
      },
      ['13'] = {
        [3] = love.graphics.newQuad(355+offset, 355+offset, 35-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(320+offset, 0+offset, 35-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 180+offset, 35-offset, 110-offset, dim()),
      },
      ['32'] = {
        [3] = love.graphics.newQuad(0+offset, 315+offset, 110-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 420+offset, 110-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 175+offset, 110-offset, 70-offset, dim()),
      },
      ['32frame'] = {
        [3] = love.graphics.newQuad(0+offset, 245+offset, 110-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 70+offset, 110-offset, 70-offset, dim()),
      },
      ['23'] = {
        [3] = love.graphics.newQuad(250+offset, 175+offset, 70-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 390+offset, 70-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 35+offset, 70-offset, 110-offset, dim()),
      },
      ['22'] = {
        [3] = love.graphics.newQuad(250+offset, 70+offset, 70-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 180+offset, 70-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 180+offset, 70-offset, 70-offset, dim()),
      },
      ['21'] = {
        [3] = love.graphics.newQuad(250+offset, 285+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 140+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 395+offset, 70-offset, 35-offset, dim()),
      },
      ['21frame'] = {
        [3] = love.graphics.newQuad(180+offset, 35+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(220+offset, 0+offset, 70-offset, 35-offset, dim()),
      },
      ['12'] = {
        [3] = love.graphics.newQuad(320+offset, 110+offset, 35-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 215+offset, 35-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(390+offset, 0+offset, 35-offset, 70-offset, dim()),
      },
      ['triangle'] = {
        [3] = love.graphics.newQuad(110+offset, 360+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 250+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 145+offset, 70-offset, 35-offset, dim()),
      },
      ['triangleframe'] = {
        [3] = love.graphics.newQuad(250+offset, 35+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 355+offset, 70-offset, 35-offset, dim()),
      },
      ['square'] = {
        [3] = love.graphics.newQuad(320+offset, 470+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(320+offset, 290+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(285+offset, 460+offset, 35-offset, 35-offset, dim()),
      },
      ['squareframe'] = {
        [3] = love.graphics.newQuad(250+offset, 320+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 390+offset, 35-offset, 35-offset, dim()),
      },
      ['circle'] = {
        [3] = love.graphics.newQuad(285+offset, 320+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 180+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(285+offset, 355+offset, 35-offset, 35-offset, dim()),
      },
      ['circleframe'] = {
        [3] = love.graphics.newQuad(355+offset, 320+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 0+offset, 35-offset, 35-offset, dim()),
      },
    },
    
    ['metal'] = {
      ['31'] = {
        [3] = love.graphics.newQuad(0+offset, 70+offset, 110-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 175+offset, 110-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 420+offset, 110-offset, 35-offset, dim()),
      },
      ['31frame'] = {
        [3] = love.graphics.newQuad(110+offset, 0+offset, 110-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 455+offset, 110-offset, 35-offset, dim()),
      },
      ['13'] = {
        [3] = love.graphics.newQuad(320+offset, 110+offset, 35-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 180+offset, 35-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 395+offset, 35-offset, 110-offset, dim()),
      },
      ['32'] = {
        [3] = love.graphics.newQuad(0+offset, 350+offset, 110-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 105+offset, 110-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 210+offset, 110-offset, 70-offset, dim()),
      },
      ['32frame'] = {
        [3] = love.graphics.newQuad(0+offset, 0+offset, 110-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 280+offset, 110-offset, 70-offset, dim()),
      },
      ['23'] = {
        [3] = love.graphics.newQuad(250+offset, 70+offset, 70-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 140+offset, 70-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 245+offset, 70-offset, 110-offset, dim()),
      },
      ['22'] = {
        [3] = love.graphics.newQuad(250+offset, 0+offset, 70-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 215+offset, 70-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 35+offset, 70-offset, 70-offset, dim()),
      },
      ['21'] = {
        [3] = love.graphics.newQuad(180+offset, 35+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 285+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 105+offset, 70-offset, 35-offset, dim()),
      },
      ['21frame'] = {
        [3] = love.graphics.newQuad(180+offset, 360+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 180+offset, 70-offset, 35-offset, dim()),
      },
      ['12'] = {
        [3] = love.graphics.newQuad(320+offset, 325+offset, 35-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(285+offset, 425+offset, 35-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 220+offset, 35-offset, 70-offset, dim()),
      },
      ['triangle'] = {
        [3] = love.graphics.newQuad(180+offset, 395+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(110+offset, 175+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 210+offset, 70-offset, 35-offset, dim()),
      },
      ['triangleframe'] = {
        [3] = love.graphics.newQuad(110+offset, 465+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(110+offset, 140+offset, 70-offset, 35-offset, dim()),
      },
      ['square'] = {
        [3] = love.graphics.newQuad(355+offset, 290+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 110+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(285+offset, 320+offset, 35-offset, 35-offset, dim()),
      },
      ['squareframe'] = {
        [3] = love.graphics.newQuad(320+offset, 290+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 360+offset, 35-offset, 35-offset, dim()),
      },
      ['circle'] = {
        [3] = love.graphics.newQuad(250+offset, 320+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 430+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(250+offset, 390+offset, 35-offset, 35-offset, dim()),
      },
      ['circleframe'] = {
        [3] = love.graphics.newQuad(390+offset, 35+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 325+offset, 35-offset, 35-offset, dim()),
      },
      ['balancer'] = {
        [3] = love.graphics.newQuad(0+offset, 507+offset, 180-offset, 5-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 507+offset, 180-offset, 5-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 507+offset, 180-offset, 5-offset, dim()),
      },
    },
    
    ['explosive'] = {
      ['31'] = {
        [3] = love.graphics.newQuad(0+offset, 70+offset, 110-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 245+offset, 110-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 35+offset, 110-offset, 35-offset, dim()),
      },
      ['13'] = {
        [3] = love.graphics.newQuad(355+offset, 255+offset, 35-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 110+offset, 35-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(355+offset, 0+offset, 35-offset, 110-offset, dim()),
      },
      ['32'] = {
        [3] = love.graphics.newQuad(0+offset, 350+offset, 110-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(0+offset, 420+offset, 110-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(0+offset, 105+offset, 110-offset, 70-offset, dim()),
      },
      ['23'] = {
        [3] = love.graphics.newQuad(180+offset, 35+offset, 70-offset, 110-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 145+offset, 70-offset, 110-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 35+offset, 70-offset, 110-offset, dim()),
      },
      ['22'] = {
        [3] = love.graphics.newQuad(250+offset, 175+offset, 70-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 70+offset, 70-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 145+offset, 70-offset, 70-offset, dim()),
      },
      ['21'] = {
        [3] = love.graphics.newQuad(180+offset, 255+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(250+offset, 280+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 215+offset, 70-offset, 35-offset, dim()),
      },
      ['12'] = {
        [3] = love.graphics.newQuad(320+offset, 250+offset, 35-offset, 70-offset, dim()),
        [2] = love.graphics.newQuad(320+offset, 0+offset, 35-offset, 70-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 320+offset, 35-offset, 70-offset, dim()),
      },
      ['triangle'] = {
        [3] = love.graphics.newQuad(250+offset, 245+offset, 70-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(180+offset, 470+offset, 70-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(110+offset, 250+offset, 70-offset, 35-offset, dim()),
      },
      ['square'] = {
        [3] = love.graphics.newQuad(320+offset, 460+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(320+offset, 425+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 180+offset, 35-offset, 35-offset, dim()),
      },
      ['circle'] = {
        [3] = love.graphics.newQuad(390+offset, 35+offset, 35-offset, 35-offset, dim()),
        [2] = love.graphics.newQuad(355+offset, 400+offset, 35-offset, 35-offset, dim()),
        [1] = love.graphics.newQuad(320+offset, 390+offset, 35-offset, 35-offset, dim()),
      },
    },
    

}

-- tweak circular alien quad
--gFrames['aliens'][9]:setViewport(105.5, 35.5, 35, 34.2)
