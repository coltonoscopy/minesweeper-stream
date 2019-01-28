--[[
    GameOverState Class
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function GameOverState:enter(params)
    self.gameGrid = params.gameGrid
end

function GameOverState:render()
    love.graphics.clear(0.4, 0, 0, 1)
    self.gameGrid:render()

    love.graphics.printf('Game Over', 0, 16, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to Play', 0, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')
end