--[[
    Dependencies
]]

love.graphics.setDefaultFilter('nearest', 'nearest')

Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/GameGrid'
require 'src/GridTile'
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/TitleState'
require 'src/states/VictoryState'

gTextures = {
    ['tile'] = love.graphics.newImage('graphics/tile.png'),
    ['tile-depressed'] = love.graphics.newImage('graphics/tile_depressed.png'),
    ['bomb'] = love.graphics.newImage('graphics/bomb.png'),
    ['flag'] = love.graphics.newImage('graphics/flag.png'),

    ['1'] = love.graphics.newImage('graphics/1.png'),
    ['2'] = love.graphics.newImage('graphics/2.png'),
    ['3'] = love.graphics.newImage('graphics/3.png'),
    ['4'] = love.graphics.newImage('graphics/4.png'),
    ['5'] = love.graphics.newImage('graphics/5.png'),
    ['6'] = love.graphics.newImage('graphics/6.png'),
    ['7'] = love.graphics.newImage('graphics/7.png'),
    ['8'] = love.graphics.newImage('graphics/8.png'),
}

gFonts = {
    ['poco'] = love.graphics.newFont('fonts/Poco.ttf', 20),
    ['pixeled'] = love.graphics.newFont('fonts/Pixeled.ttf', 10),
    ['start'] = love.graphics.newFont('fonts/start.ttf', 16),
    ['start-small'] = love.graphics.newFont('fonts/start.ttf', 8)
}