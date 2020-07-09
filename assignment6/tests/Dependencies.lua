Class = require 'lib/class'
Timer = require 'lib/knife.timer'
push = require 'lib/push'


-- Classes
require 'LetterBody'
require 'AlienBody'
require 'Util'

--Assets
    --Fonts
    titleFont = love.graphics.newFont('Bangers-Regular.ttf', 30)

    gTextures = {
        --* round aliens
        ['round_aliens'] = love.graphics.newImage('round_aliens.png'),
    }
    
    gFrames = {
        ['round_aliens'] = GenerateQuads(gTextures['round_aliens'], 35, 35),
    }

    gSounds = {
        ['bounce'] = love.audio.newSource('bounce.wav'),
        ['bounce1'] = love.audio.newSource('bounce1.wav'),
        ['bounce2'] = love.audio.newSource('bounce2.wav'),
        ['bounce3'] = love.audio.newSource('bounce3.wav')
    }