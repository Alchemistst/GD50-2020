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
require 'src/Projectile'

require 'src/world/Doorway'
require 'src/world/Dungeon'
require 'src/world/Room'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/EntityDieState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerSwingSwordState'
require 'src/states/entity/player/PlayerCatchingState'
require 'src/states/entity/player/PlayerWalkingPotState'
require 'src/states/entity/player/PlayerIdlePotState'
require 'src/states/entity/player/PlayerWalkState'
require 'src/states/entity/player/PlayerThrowingState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['character-walk'] = love.graphics.newImage('graphics/character_walk.png'),
    ['character-lift-pot'] = love.graphics.newImage('graphics/character_pot_lift.png'),
    ['character-walk-pot'] = love.graphics.newImage('graphics/character_pot_walk.png'),
    ['character-swing-sword'] = love.graphics.newImage('graphics/character_swing_sword.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['switches'] = love.graphics.newImage('graphics/switches.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['hearts_consumable'] = love.graphics.newImage('graphics/hearts_consumable.png'),
    ['breaking_pot'] = love.graphics.newImage('graphics/breaking_pot.png'),
    ['die_skeleton'] = love.graphics.newImage('graphics/die_skeleton.png'),
    ['die_spider'] = love.graphics.newImage('graphics/die_spider.png'),
    ['die_slime'] = love.graphics.newImage('graphics/die_slime.png'),
    ['die_ghost'] = love.graphics.newImage('graphics/die_ghost.png'),
    ['die_bat'] = love.graphics.newImage('graphics/die_bat.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 32),
    ['character-lift-pot'] = GenerateQuads(gTextures['character-lift-pot'], 16, 32),
    ['character-walk-pot'] = GenerateQuads(gTextures['character-walk-pot'], 16, 32),
    ['character-swing-sword'] = GenerateQuads(gTextures['character-swing-sword'], 32, 32),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['switches'] = GenerateQuads(gTextures['switches'], 16, 18),
    ['hearts_consumable'] = GenerateQuads(gTextures['hearts_consumable'], 7, 7),
    ['breaking_pot'] = GenerateQuads(gTextures['breaking_pot'], 16, 16),
    ['die_skeleton'] = GenerateQuads(gTextures['die_skeleton'], 16, 16),
    ['die_spider'] = GenerateQuads(gTextures['die_spider'], 16, 16),
    ['die_slime'] = GenerateQuads(gTextures['die_slime'], 16, 16),
    ['die_ghost'] = GenerateQuads(gTextures['die_ghost'], 16, 16),
    ['die_bat'] = GenerateQuads(gTextures['die_bat'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3'),
    ['sword'] = love.audio.newSource('sounds/sword.wav'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav'),
    ['door'] = love.audio.newSource('sounds/door.wav'),
    ['recover'] = love.audio.newSource('sounds/recover.wav'),
    ['pot_breaks'] = love.audio.newSource('sounds/pot_breaks.wav')
}