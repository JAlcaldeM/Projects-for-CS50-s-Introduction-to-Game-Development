--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/animations'
require 'src/constants'
require 'src/Party'
require 'src/Pokemon'
require 'src/pokemon_defs'
require 'src/StateMachine'
require 'src/Util'

require 'src/Cell'
require 'src/Chimera'
require 'src/chimeraGen'

require 'src/battle/BattleSprite'
require 'src/battle/Opponent'

require 'src/entity/entity_defs'
require 'src/entity/Entity'
require 'src/entity/Player'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/BattleState'
require 'src/states/game/BattleMenuState'
require 'src/states/game/BattleMessageState'
require 'src/states/game/DialogueState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/TakeTurnState'
require 'src/states/game/FieldMenuState'
require 'src/states/game/PartyState'

require 'src/world/Level'
require 'src/world/tile_ids'
require 'src/world/Tile'
require 'src/world/TileMap'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/sheet.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    ['field-music'] = love.audio.newSource('sounds/field_music.wav', 'static'),
    ['battle-music'] = love.audio.newSource('sounds/battle_music.mp3', 'static'),
    ['blip'] = love.audio.newSource('sounds/blip.wav', 'static'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav', 'static'),
    ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
    ['run'] = love.audio.newSource('sounds/run.wav', 'static'),
    ['heal'] = love.audio.newSource('sounds/heal.wav', 'static'),
    ['exp'] = love.audio.newSource('sounds/exp.wav', 'static'),
    ['levelup'] = love.audio.newSource('sounds/levelup.wav', 'static'),
    ['victory-music'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['intro-music'] = love.audio.newSource('sounds/intro.mp3', 'static'),
    ['ok'] = love.audio.newSource('sounds/ok.wav', 'static'),
    ['back'] = love.audio.newSource('sounds/back.wav', 'static'),
    ['swap'] = love.audio.newSource('sounds/swap.wav', 'static'),
    ['nope'] = love.audio.newSource('sounds/nope.wav', 'static'),
    ['continue'] = love.audio.newSource('sounds/continue.wav', 'static'),
    ['thud'] = love.audio.newSource('sounds/thud.wav', 'static'),
    ['entergame'] = love.audio.newSource('sounds/entergame.wav', 'static'),
    ['faint'] = love.audio.newSource('sounds/faint.wav', 'static'),
    ['spawn'] = love.audio.newSource('sounds/spawn.wav', 'static'),
}