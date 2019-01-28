--[[
    PlayState Class
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.time = 120
    self.gameGrid = GameGrid(GRID_WIDTH, GRID_HEIGHT)

    Timer.every(1, function()
        self.time = self.time - 1

        if self.time == 0 then
            self.gameGrid:revealAll()
            gStateMachine:change('game-over', {
                gameGrid = self.gameGrid
            })
        end
    end)
end

function PlayState:update(dt)
    self.gameGrid:update(dt)
end

function PlayState:render()
    love.graphics.clear(0.2, 0.2, 0.2, 1)
    love.graphics.print(tostring(self.time))
    love.graphics.printf(tostring(self.gameGrid.score), 0, 0, VIRTUAL_WIDTH, 'right')

    self.gameGrid:render()
end