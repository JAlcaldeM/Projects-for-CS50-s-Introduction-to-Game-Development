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
    self.level = level or 1
    
    self.allowedColors = {2, 3, 6, 9, 11, 12, 14, 17}
    --allowedColors = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}

    self:initializeTiles()
    
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do

            self.variety = nil
            if math.random(100) <= math.min(50, 15 + 5*self.level) then
              self.variety = math.min(6,math.random(self.level))
            else
              self.variety = 1
            end
          
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, self.allowedColors[math.random(#self.allowedColors)], self.variety))

        end
    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
    
    -- check if no possible matches, if that is the case reset the board
    self:calculatePossibleMatches()
    if solutions == 0 then
      self:initializeTiles()
    end
    
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- check if any of the blocks are shiny
                    local matchChecked = self:checkShinyTiles(match, true)
                    table.insert(matches, matchChecked)
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
                table.insert(match, self.tiles[y][x])
            end
            
            local matchChecked = self:checkShinyTiles(match, true)
                    table.insert(matches, matchChecked)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end
                    
                    local matchChecked = self:checkShinyTiles(match, false)
                    table.insert(matches, matchChecked)
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
                table.insert(match, self.tiles[y][x])
            end
            local matchChecked = self:checkShinyTiles(match, false)
                    table.insert(matches, matchChecked)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
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

    self.matches = nil
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
                
                if math.random(100) <= math.min(50, 15 + 5*self.level) then
                  self.variety = math.min(6,math.random(self.level))
                else
                  self.variety = 1
                end
                
                local tile = Tile(x, y, self.allowedColors[math.random(#self.allowedColors)], self.variety)
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


function Board:calculatePossibleMatches()
  -- first, we assignate each tile a list with the colors of all the adjacent tiles
  for y = 1, 8 do
        for x = 1, 8 do
            self.tiles[y][x].adj = {} -- reset table
            
            if y > 1 then
                table.insert(self.tiles[y][x].adj, self.tiles[y-1][x].color) -- Up
            end

            if x > 1 then
                table.insert(self.tiles[y][x].adj, self.tiles[y][x-1].color) -- Left
            end

            if x < #self.tiles[y] then
                table.insert(self.tiles[y][x].adj, self.tiles[y][x+1].color) -- Right
            end

            if y < #self.tiles then
                table.insert(self.tiles[y][x].adj, self.tiles[y+1][x].color) -- Down
            end
            
        end
  end
  
  local possibleMatches = 0
  
  local color1 = nil -- current color
  local color2 = nil -- next color
  local color3 = nil -- next next color

  -- horizontal possible matches
  for y = 1,8 do
    for x = 1,7 do
      color1 = self.tiles[y][x].color
      color2 = self.tiles[y][x+1].color
      if color1 == color2 then -- if this and the next color are the same...
        if x > 1 then -- and only if there is a previous tile...
          local adjMatches = 0
          for _, color in pairs(self.tiles[y][x-1].adj) do -- check how many colors in [tile to the left].adj are also this color...
            if color == color1 then
              adjMatches = adjMatches + 1
            end
          end
          if adjMatches > 1 then -- and if the number is > 1 (always is at least 1 because of the adjacency to the current tile, which is of the current color) a move can make a match.
            possibleMatches = possibleMatches + adjMatches - 1
            cheatx = x-1
            cheaty = y
            cheatType = 'left'
          end
        end
        if x < 7 then -- then repeat for the tile to the right
          local adjMatches = 0
          for _, color in pairs(self.tiles[y][x+2].adj) do
            if color == color1 then
              adjMatches = adjMatches + 1
            end
          end
          if adjMatches > 1 then
            possibleMatches = possibleMatches + adjMatches - 1
            cheatx = x+2
            cheaty = y
            cheatType = 'right'
          end
        end
      end
      
      if x <= 6 then -- is possible that two tiles of the same color separated by a tile of a different color can match
          color3 = self.tiles[y][x+2].color
          local adjMatches = 0
          for _, color in pairs(self.tiles[y][x+1].adj) do
            if color == color1 then
              adjMatches = adjMatches + 1
            end
          end
          if adjMatches > 2 then -- 2 is the minimum since both adjacents are from this color, needs to be 3 or 4
            possibleMatches = possibleMatches + adjMatches - 2
            cheatx = x+1
            cheaty = y
            cheatType = 'right'
          end
      end
    end
  end
  
  -- vertical possible matches, similar but swapping x for y
  for y = 1,7 do
    for x = 1,8 do
      color1 = self.tiles[y][x].color
      color2 = self.tiles[y+1][x].color
      if color1 == color2 then -- if this and the next color are the same...
        if y > 1 then -- and only if there is a previous tile...
          local adjMatches = 0
          for _, color in pairs(self.tiles[y-1][x].adj) do -- check how many colors in [previous tile].adj are also this color...
            if color == color1 then
              adjMatches = adjMatches + 1
            end
          end
          if adjMatches > 1 then -- and if the number is > 1 (always is at least 1 because of the adjacency to the current tile, which is of the current color) a move can make a match.
            possibleMatches = possibleMatches + adjMatches - 1
            cheatx = x
            cheaty = y-1
            cheatType = 'up'
          end
        end
        if y < 7 then -- then repeat for the next next tile
          local adjMatches = 0
          for _, color in pairs(self.tiles[y+2][x].adj) do
            if color == color1 then
              adjMatches = adjMatches + 1
            end
          end
          if adjMatches > 1 then
            possibleMatches = possibleMatches + adjMatches - 1
            cheatx = x
            cheaty = y+2
            cheatType = 'down'
          end
        end
      end
      
      if y <= 6 then -- is possible that two tiles of the same color separated by a tile of a different color can match
          color3 = self.tiles[y+2][x].color
          local adjMatches = 0
          for _, color in pairs(self.tiles[y+1][x].adj) do
            if color == color1 then
              adjMatches = adjMatches + 1
            end
          end
          if adjMatches > 2 then -- 2 is the minimum since both adjacents are from this color, needs to be 3 or 4
            possibleMatches = possibleMatches + adjMatches - 2
            cheatx = x
            cheaty = y+1
            cheatType = 'down'
          end
      end
    end
  end
  
  solutions = possibleMatches
  
end


function Board:checkShinyTiles(match, horizMatch)
                        -- if any of the tiles is shiny, add all tiles from the same row to the match
                        local shinyInMatch = false
                        local othersMatch = {}
                        for _, tile in pairs(match) do
                          
                          if tile.shiny and not tile.matched then
                            --tile.shiny = false -- deactivate shiny status to evade repetition
                            shinyInMatch = true
                            
                            local shinyRow = tile.gridY
                            local shinyCol = tile.gridX
                            -- create a new match table with all the tiles in the match that are not from the same row...
                            
                            if horizMatch then
                              
                                for row = 1, 8 do
                                  local tile2 = self.tiles[row][shinyCol]
                                  if not (row == shinyRow) and not tile2.matched then
                                    table.insert(othersMatch, tile2)
                                  end
                                end

                            else

                                for col = 1, 8 do
                                  local tile2 = self.tiles[shinyRow][col]
                                  if not (col == shinyCol) and not tile2.matched then
                                    table.insert(othersMatch, tile2)
                                  end
                                end  

                            end
                            
                            
                          end
                          
                          tile.matched = true
                          
                        end
                        
                        if shinyInMatch then
                          -- check the other tiles in the other orientation
                          newMatch = self:checkShinyTiles(othersMatch, not horizMatch)
                          for _, tile in pairs(newMatch) do
                            table.insert(match, tile)
                          end
                          
                        end

                        return match

end
