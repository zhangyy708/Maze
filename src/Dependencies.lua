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
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Maze'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

gTextures = {
    ['characters'] = love.graphics.newImage('graphics/characters.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['switches'] = love.graphics.newImage('graphics/switches.png'),
    ['floor'] = love.graphics.newImage('graphics/floor.png'),
    ['wall-side'] = love.graphics.newImage('graphics/wall_side.png'),
    ['wall-top'] = love.graphics.newImage('graphics/wall_top.png'),
    ['background'] = love.graphics.newImage('graphics/background.png')
}

gFrames = {
    ['characters'] = GenerateQuads(gTextures['characters'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['switches'] = GenerateQuads(gTextures['switches'], 16, 16),
    ['floor'] = GenerateQuads(gTextures['floor'], 16, 16), 
    ['wall-side'] = GenerateQuads(gTextures['wall-side'], 16, 16), 
    ['wall-top'] = GenerateQuads(gTextures['wall-top'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/Blacknorthdemo-mLE25.otf', 16),
    ['medium'] = love.graphics.newFont('fonts/Blacknorthdemo-mLE25.otf', 32),
    ['large'] = love.graphics.newFont('fonts/Blacknorthdemo-mLE25.otf', 96)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['music-menu'] = love.audio.newSource('sounds/music_start.mp3', 'static'),
    ['game-over'] = love.audio.newSource('sounds/gameover.wav', 'static'),
    ['level-up'] = love.audio.newSource('sounds/levelup.wav', 'static'),
    ['new-player'] = love.audio.newSource('sounds/new_player.wav', 'static'),
    ['pick-up'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['reset'] = love.audio.newSource('sounds/reset.wav', 'static')    
}