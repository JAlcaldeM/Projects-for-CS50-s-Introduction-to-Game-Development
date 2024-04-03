--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Hitbox'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Doorway'
require 'src/world/Dungeon'
require 'src/world/Room'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerSwingSwordState'
require 'src/states/entity/player/PlayerWalkState'
require 'src/states/entity/player/PlayerPickState'
require 'src/states/entity/player/PlayerPickIdleState'
require 'src/states/entity/player/PlayerPickWalkState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['character-walk'] = love.graphics.newImage('graphics/character_walk.png'),
    ['character-swing-sword'] = love.graphics.newImage('graphics/character_swing_sword.png'),
    ['character-pick'] = love.graphics.newImage('graphics/character_pot_lift.png'),
    ['character-pickwalk'] = love.graphics.newImage('graphics/character_pot_walk.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['switches'] = love.graphics.newImage('graphics/switches.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['potpieces'] = love.graphics.newImage('graphics/potpieces.png'),
    ['miniheart'] = love.graphics.newImage('graphics/miniheart.png'),
    ['rupee'] = love.graphics.newImage('graphics/rupee.png'),
    ['minirupee'] = love.graphics.newImage('graphics/minirupee.png'),
}

for _, texture in pairs(gTextures) do
    texture:setFilter('nearest', 'nearest')
end

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 32),
    ['character-swing-sword'] = GenerateQuads(gTextures['character-swing-sword'], 32, 32),
    ['character-pick'] = GenerateQuads(gTextures['character-pick'], 16, 32),
    ['character-pickwalk'] = GenerateQuads(gTextures['character-pickwalk'], 16, 32),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['switches'] = GenerateQuads(gTextures['switches'], 16, 18),
    ['potpieces'] = GenerateQuads(gTextures['potpieces'], 16, 16),
    ['miniheart'] = GenerateQuads(gTextures['miniheart'], 8, 8),
    ['rupee'] = GenerateQuads(gTextures['rupee'], 16, 16),
    ['minirupee'] = GenerateQuads(gTextures['minirupee'], 8, 8),
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['zelda-vsmall'] = love.graphics.newFont('fonts/zelda.otf', 16)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['sword'] = love.audio.newSource('sounds/sword.wav', 'static'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav', 'static'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav', 'static'),
    ['door'] = love.audio.newSource('sounds/door.wav', 'static'),
    ['heal'] = love.audio.newSource('sounds/heal.wav', 'static'),
    ['pick'] = love.audio.newSource('sounds/pick.wav', 'static'),
    ['piece'] = love.audio.newSource('sounds/piece.wav', 'static'),
    ['piece2'] = love.audio.newSource('sounds/piece2.wav', 'static'),
    ['piece3'] = love.audio.newSource('sounds/piece3.wav', 'static'),
    ['potbreak'] = love.audio.newSource('sounds/potbreak.wav', 'static'),
    ['potbreak2'] = love.audio.newSource('sounds/potbreak2.wav', 'static'),
    ['rupee'] = love.audio.newSource('sounds/rupee.wav', 'static'),
}