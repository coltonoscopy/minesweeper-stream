--[[
    GridTile Class
]]

GridTile = Class{}

function GridTile:init(isBomb, isHidden)
    self.isBomb = isBomb
    self.isHidden = isHidden
    self.numBombNeighbors = 0
    self.isFlagged = false
end

function GridTile:update(dt)

end

function GridTile:render(x, y)
    if self.isHidden then
        love.graphics.draw(gTextures['tile'], x, y)
    else
        if self.isBomb then
            love.graphics.draw(gTextures['bomb'], x, y)
        else
            if self.numBombNeighbors > 0 then
                love.graphics.draw(gTextures[tostring(self.numBombNeighbors)], x, y)
            else
                love.graphics.draw(gTextures['tile-depressed'], x, y)
            end
        end
    end

    if self.isFlagged then
        love.graphics.draw(gTextures['flag'], x, y)
    end
end