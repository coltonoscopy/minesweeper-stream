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
                    self.isHighlighting = true
                    self.highlightingTile = {x = x, y = y}
                    highlightingSomething = true
                end
            end
        end
    end

    if not highlightingSomething then
        self.isHighlighting = false
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

    love.graphics.setFont(gFonts['start-small'])
    love.graphics.print('X: ' .. tostring(xPos) .. ', Y: ' .. tostring(yPos), 0, VIRTUAL_HEIGHT - 48)
    love.graphics.print('Highlighting Tile: ' .. tostring(self.isHighlighting), 0, VIRTUAL_HEIGHT - 36)
    love.graphics.print('Highlighting X: ' .. tostring(self.highlightingTile.x) .. ', Y: ' .. tostring(self.highlightingTile.y), 
        0, VIRTUAL_HEIGHT - 24)
    love.graphics.setFont(gFonts['start'])
end