--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}

    --Get the level so we can generate tiles accordingly
    self.level = level
    
    self:initializeTiles()
    
    -- board's width and height
    self.width = 256
    self.height = 256
end

function Board:initializeTiles()
    self.tiles = {}
    self.tilesWithAnimation = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            local isShiny = math.random(1,20) == 1
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(1, math.min(self.level, 6)), isShiny))
        end
    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
    if not self:findMatches(self.tiles) then
        self:initializeTiles()
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    return self:tilesIterationAndMatches(self.tiles, self.matches)
end

function Board:tilesIterationAndMatches(tiles, selfMatches)
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        
                        -- add each tile to the match that's in that match
                        table.insert(match, tiles[y][x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- Table to stage the destroyed lines to be counted as matches
    local linesToBeDestroyed = {}

    for i, match in pairs(matches) do
        for j, tile in pairs(match) do
            if tile.isShiny then
                -- Check for horizontal match; if so, destroy whole row
                if match[1].gridY == match[#match].gridY then
                -- Take the match so is not counted twice and add stage it to be added to matches on linesToBeDestroyed
                    table.insert(linesToBeDestroyed, trim(tiles[match[1].gridY], match[#match].gridX, match[1].gridX))
                end
                -- Check for vertical match; if so, destroy whole column
                if match[1].gridX == match[#match].gridX then
                    -- Extract the column first
                    local tempColumn = {}
                    for i = 1, #tiles do
                        tempColumn[#tempColumn + 1] = tiles[i][match[1].gridX]
                    end
                    -- Take the match so is not counted twice and add stage it to be added to matches on linesToBeDestroyed
                    table.insert(linesToBeDestroyed, trim(tempColumn, match[#match].gridY, match[1].gridY))
                end
            end
        end
    end

    -- Iterate over the table adding to matches also the tiles destroyed by the shiny tile
    for i = 1, #linesToBeDestroyed do
        table.insert(matches, linesToBeDestroyed[i])
    end
    
    -- store matches for later reference
    for i,match in pairs(matches) do
        table.insert( selfMatches, match )
    end
    

    -- return matches table if > 0, else just return false
    return #matches > 0 and matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = {}
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local isShiny = math.random(1,20) == 1 
                local tile = Tile(x, y, math.random(18), math.random(1, math.min(self.level,6)), isShiny)
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end

-- Splice table
function splice(t, start, finish, step)
    local slice = {}
    
    for i = start or 1, finish or #t, step or 1 do
        slice[#slice + 1] = t[i]    
    end
    
    return slice
end
-- Trim your tables
function trim (t, start, finish)
    trimmed = {}
    for i = 1, #t do
        if i < start or i > finish then
            trimmed[#trimmed + 1] = t[i]
        end
    end
    return trimmed
end
-- Check if a movement result in a match
function Board:closeMatchesImproved(selectedTile, sx, sy)
    local matchesFound = false
    -- Do the swap
    local temp = self.tiles[selectedTile.gridY][selectedTile.gridX] 
    self.tiles[selectedTile.gridY][selectedTile.gridX] = self.tiles[sy][sx]
    self.tiles[sy][sx] = temp
    -- Look for matches
    if self:tilesIterationAndMatches(self.tiles, {}) then
        matchesFound = true
    end
    -- Undo the swap
    temp = self.tiles[selectedTile.gridY][selectedTile.gridX] 
    self.tiles[selectedTile.gridY][selectedTile.gridX] = self.tiles[sy][sx]
    self.tiles[sy][sx] = temp
    -- Return true if any matches were found in the previous state. If so, the move results in a match.
    return matchesFound
end

-- Check for matches on the board
function Board:findMatches(tiles)
    for i=1, #tiles do
        for j=1, #tiles[i] do
            local x = tiles[i][j].gridX
            local y = tiles[i][j].gridY
            local colorToCheck = tiles[i][j].color

            if self:checkRight(colorToCheck, x, y, tiles) then
                return true
            elseif self:checkLeft(colorToCheck, x, y, tiles) then
                return true
            elseif self:checkDown(colorToCheck, x, y, tiles) then
                return true
            elseif self:checkUp(colorToCheck, x, y, tiles) then
                return true
            end
        end
    end
    return false
end
--[[
    Helper functions to check for matches on the right, left, down and up of certain tile. 
    This way, all these functions can be reuse to also check for matches on the whole board.
]]
function Board:checkRight(colorToCheck, x, y, tiles)
    if x+1 <= 8 then
        if y+1 <= 7 then
            if colorToCheck == tiles[y+1][x+1].color then
                if colorToCheck == tiles[y+2][x+1].color then
                    return true
                end
            end
        end
        if y-1 > 1 then
            if colorToCheck == tiles[y-1][x+1].color then
                if colorToCheck == tiles[y-2][x+1].color then
                    return true
                end
            end
        end
        if y-1 > 0 and y+1 <= 8 then
            if colorToCheck == tiles[y-1][x+1].color and colorToCheck == tiles[y+1][x+1].color then
             return true
            end
        end
        if x+2 <= 7 then
            if colorToCheck == tiles[y][x+2].color then
                if colorToCheck == tiles[y][x+3].color then
                    return true
                end
            end
        end
    end
    return false
end
function Board:checkLeft(colorToCheck, x, y, tiles)
    if x-1 > 0 then
        if y+1 <= 7 then
            if colorToCheck == tiles[y+1][x-1].color then
                if colorToCheck == tiles[y+2][x-1].color then
                    return true
                end
            end
        end
        if y-1 > 1 then
            if colorToCheck == tiles[y-1][x-1].color then
                if colorToCheck == tiles[y-2][x-1].color then
                    return true
                end
            end
        end
        if y+1 <= 8 and  y-1 > 0 then
            if colorToCheck == tiles[y-1][x-1].color and colorToCheck == tiles[y+1][x-1].color then
                return true
            end
        end
        if x-2 > 1 then
            if colorToCheck == tiles[y][x-2].color then
                if colorToCheck == tiles[y][x-3].color then
                    return true
                end
            end
        end
    end
    return false
end
function Board:checkDown(colorToCheck, x, y, tiles)
    if y+1 <= 8 then
        if x+1 <= 7 then
            if colorToCheck == tiles[y+1][x+1].color then
                if colorToCheck == tiles[y+1][x+2].color then
                    return true
                end
            end
        end
        if x-1 > 1 then
            if colorToCheck == tiles[y+1][x-1].color then
                if colorToCheck == tiles[y+1][x-2].color then
                    return true
                end
            end
        end
        if x+1 <= 8 and  x-1 > 0 then
            if colorToCheck == tiles[y+1][x+1].color and colorToCheck == tiles[y+1][x-1].color then
                return true
            end
        end
        if y+2 <= 7 then
            if colorToCheck == tiles[y+2][x].color then
                if colorToCheck == tiles[y+3][x].color then
                    return true
                end
            end
        end
    end
    return false
end
function Board:checkUp(colorToCheck, x, y, tiles)
    if y-1 > 0 then
        if x+1 <= 7 then
            if colorToCheck == tiles[y-1][x+1].color then
                if colorToCheck == tiles[y-1][x+2].color then
                    return true
                end
            end
        end
        if x-1 > 1 then
            if colorToCheck == tiles[y-1][x-1].color then
                if colorToCheck == tiles[y-1][x-2].color then
                    return true
                end
            end
        end
        if x+1 <= 8 and  x-1 > 0 then
            if colorToCheck == tiles[y-1][x+1].color and colorToCheck == tiles[y-1][x-1].color then
                return true
            end
        end
        if y-2 > 1 then
            if colorToCheck == tiles[y-2][x].color then
                if colorToCheck == tiles[y-3][x].color then
                    return true
                end
            end
        end
    end
    return false
end
function Board:checkAdjacents (colorToCheck, x, y, tiles)
    if x+1 <= 7 then
        if colorToCheck == tiles[y][x+1] then
            return colorToCheck == tiles[y][x+2]
        end
    end
    if x-1 > 1 then
        if colorToCheck == tiles[y][x-1] then
            return colorToCheck == tiles[y][x-2]
        end
    end
    if y+1 <= 7 then
        if colorToCheck == tiles[y+1][x] then
            return colorToCheck == tiles[y+2][x]
        end
    end
    if y-1 > 1 then
        if colorToCheck == tiles[y-1][x] then
            return colorToCheck == tiles[y-2][x]
        end
    end

    return false
end