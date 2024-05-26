
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
tween = require 'lib/tween'

require 'src/StateMachine'
require 'src/Util'
require 'src/constants'

require 'src/Window'
require 'src/Panel'
require 'src/ProgressBar'
require 'src/Monster'
require 'src/MonsterMind'
--require 'src/Movement'
require 'src/StatusBar'
require 'src/movement_defs'
require 'src/Icon'
require 'src/LogSystem'

require 'src/Cell'
require 'src/Chimera'
require 'src/chimeraGen'



require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/game/StartState'
require 'src/states/game/MenuState'
require 'src/states/game/MovMenuState'
require 'src/states/game/SpriteState'
require 'src/states/game/AfterBattleState'
require 'src/states/game/ChooseTraitState'
require 'src/states/game/MainMenuState'
require 'src/states/game/OptionsState'
require 'src/states/game/AboutState'

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 64),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 128),
    ['title'] = love.graphics.newFont('fonts/font.ttf', 192),
}

gTextures = {
    ['icons'] = love.graphics.newImage('graphics/icons.png'),
    ['trainer'] = love.graphics.newImage('graphics/trainer.png'), 
}

gSounds = {
    ['ok'] = love.audio.newSource('sounds/ok.mp3', 'static'),
    ['out'] = love.audio.newSource('sounds/out.mp3', 'static'),
    ['battleTheme'] = love.audio.newSource('sounds/battleTheme.mp3', 'static'),
    ['pow'] = love.audio.newSource('sounds/pow.mp3', 'static'),
    ['clang'] = love.audio.newSource('sounds/clang.mp3', 'static'),
    ['clong'] = love.audio.newSource('sounds/clong.mp3', 'static'),
    ['powapo'] = love.audio.newSource('sounds/powapo.mp3', 'static'),
    ['megaok'] = love.audio.newSource('sounds/megaok.mp3', 'static'),
    ['plin'] = love.audio.newSource('sounds/plin.mp3', 'static'),
    ['plon'] = love.audio.newSource('sounds/plon.mp3', 'static'),
    ['menuMusic'] = love.audio.newSource('sounds/menuMusic.mp3', 'static'),
    ['defeat'] = love.audio.newSource('sounds/defeat.mp3', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.mp3', 'static'),
    ['supremeVictory'] = love.audio.newSource('sounds/supremeVictory.mp3', 'static'),
    ['mainTheme'] = love.audio.newSource('sounds/mainTheme.mp3', 'static'),
    ['protected'] = love.audio.newSource('sounds/protected.mp3', 'static'),
    ['steps'] = love.audio.newSource('sounds/steps.mp3', 'static'),
    ['hehehe'] = love.audio.newSource('sounds/hehehe.mp3', 'static'),
    ['prang'] = love.audio.newSource('sounds/prang.mp3', 'static'),
    ['prong'] = love.audio.newSource('sounds/prong.mp3', 'static'),
    ['chomp'] = love.audio.newSource('sounds/chomp.mp3', 'static'),
    ['roar'] = love.audio.newSource('sounds/roar.mp3', 'static'),
    ['hit'] = love.audio.newSource('sounds/hit.mp3', 'static'),
    ['cut'] = love.audio.newSource('sounds/cut.mp3', 'static'),
    ['happy'] = love.audio.newSource('sounds/happy.mp3', 'static'),
    ['fire'] = love.audio.newSource('sounds/fire.mp3', 'static'),
    ['electro'] = love.audio.newSource('sounds/electro.mp3', 'static'),
    ['poison'] = love.audio.newSource('sounds/poison.mp3', 'static'),
    ['ice'] = love.audio.newSource('sounds/ice.mp3', 'static'),
    ['plant'] = love.audio.newSource('sounds/plant.mp3', 'static'),
    ['metal'] = love.audio.newSource('sounds/metal.mp3', 'static'),
    ['insect'] = love.audio.newSource('sounds/insect.mp3', 'static'),
    ['mineral'] = love.audio.newSource('sounds/mineral.mp3', 'static'),
}

for _, texture in pairs(gTextures) do
    texture:setFilter('nearest', 'nearest')
end

gFrames = {
    ['icons'] = tileMap(gTextures['icons'], 10, 10),
}
