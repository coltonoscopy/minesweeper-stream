--[[
    GameGrid Class
]]

GameGrid = Class{}

local xPos, yPos

function GameGrid:init(width, height)
    self.width = width
    self.height = height
    self.leftOffset = (VIRTUAL_WIDTH - (self.width * TILE_SIZE)) / 2

    self.grid = {}
    self.score = 0

    self.isHighlighting = false
    self.highlightingTile = {x = 0, y = 0}

    for y = 1, self.height do
        table.insert(self.grid, {})

        for x = 1, self.width do
            local isBomb = math.random(10) == 1 and true or false
            local gridTile = GridTile(isBomb)
            
            table.insert(self.grid[y], gridTile)
            
            local isHidden = true
            gridTile.isHidden = isHidden
        end
    end

    self:calculateNumbers()
    -- self:revealAll()
end

function GameGrid:revealAll()
    for y = 1, self.height do
        for x = 1, self.width do
            self.grid[y][x].isHidden = false
        end
    end
end

function GameGrid:isVictory()
    local won = true

    for y = 1, self.height do
        for x = 1, self.width do
            if self.grid[y][x].isHidden and not self.grid[y][x].isBomb then
                won = false 
            end
        end
    end

    return won
end

function GameGrid:calculateNumbers()
    for y = 1, self.height do
        for x = 1, self.width do
            
            if not self.grid[y][x].isBomb then
                
                -- store all bombs we see around tile, checking all neighbors
                local numBombNeighbors = 0
                
                -- check top left
                if x > 1 and y > 1 then
                    if self.grid[y-1][x-1].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- check top
                if y > 1 then
                    if self.grid[y-1][x].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- check top right
                if y > 1 and x < self.width then
                    if self.grid[y-1][x+1].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- check left
                if x > 1 then
                    if self.grid[y][x-1].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- check right
                if x < self.width then
                    if self.grid[y][x+1].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- check bottom left
                if x > 1 and y < self.height then
                    if self.grid[y+1][x-1].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- check bottom
                if y < self.height then
                    if self.grid[y+1][x].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- check bottom right
                if y < self.height and x < self.width then
                    if self.grid[y+1][x+1].isBomb then
                        numBombNeighbors = numBombNeighbors + 1
                    end
                end

                -- store number at that tile
                self.grid[y][x].numBombNeighbors = numBombNeighbors
            end
        end
    end
end

function GameGrid:update(dt)
    xPos, yPos = push:toGame(love.mouse.getPosition())

    local highlightingSomething = false

    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.grid[y][x]

            if xPos >= self.leftOffset + (x - 1) * TILE_SIZE and xPos <= self.leftOffset + (x - 1) * TILE_SIZE + TILE_SIZE then
                if yPos >= TOP_OFFSET + (y - 1) * TILE_SIZE and yPos <= TOP_OFFSET + (y - 1) * TILE_SIZE + TILE_SIZE then
                    if self.grid[y][x].isHidden then
                        self.isHighlighting = true
                    else
                        self.isHighlighting = false
                    end
                    self.highlightingTile = {x = x, y = y}

                    if love.mouse.wasPressed(1) and not self.grid[y][x].isFlagged then
                        
                        if self.grid[y][x].isBomb then
                            self.grid[y][x].isHidden = false
                            self:revealAll()
                            gStateMachine:change('game-over', {
                                gameGrid = self    
                            })
                        elseif self:isVictory() then
                            gStateMachine:change('victory', {
                                gameGrid = self
                            })
                        end

                        self:revealTile(x, y)
                    elseif love.mouse.wasPressed(2) and self.grid[y][x].isHidden then
                        self.grid[y][x].isFlagged = not self.grid[y][x].isFlagged
                    end

                    highlightingSomething = true
                end
            end
        end
    end

    if not highlightingSomething then
        self.isHighlighting = false
    end
end

function GameGrid:revealTile(x, y)
    local tile = self.grid[y][x]

    -- immediately exit if bomb; no recursion or reveal
    if tile.isBomb or not tile.isHidden then return end

    tile.isHidden = false
    tile.isFlagged = false
    self.score = self.score + 5

    -- don't recurse if this is a number tile or bomb
    if tile.numBombNeighbors == 0 then
        
        -- top tile
        if y > 1 then
            self:revealTile(x, y - 1)
        end

        -- bottom tile
        if y < GRID_HEIGHT then
            self:revealTile(x, y + 1)
        end

        -- left tile
        if x > 1 then
            self:revealTile(x - 1, y)
        end

        -- right tile
        if x < GRID_WIDTH then
            self:revealTile(x + 1, y)
        end
    end
end

function GameGrid:render()
    for y = 1, self.height do
        for x = 1, self.width do
            self.grid[y][x]:render(self.leftOffset + (x - 1) * TILE_SIZE, TOP_OFFSET + (y - 1) * TILE_SIZE)
        end
    end

    if self.isHighlighting then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.rectangle('fill', self.leftOffset + (self.highlightingTile.x - 1) * TILE_SIZE, 
            TOP_OFFSET + (self.highlightingTile.y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
        love.graphics.setColor(1, 1, 1, 1)
    end
end