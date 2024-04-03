--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local hasKeySpawned = false
    levelColor = math.random(1,4)
    local tilenames = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end
    
    
    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end
        
        -- chance to just be emptiness
        if x > 4 and x < width - 2 and math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
            tilenames[x] = 'empty'
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end
            
            tilenames[x] = 'ground'

            -- chance to generate a pillar
            if (x == 1 or x == 3 or math.random(8) == 1) and not (x == 2) and x < width - 2 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                tilenames[x] = 'pillar'
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
                
            elseif x == 2 then
                table.insert(objects,
                    GameObject {
                        texture = 'buttons',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = levelColor,
                        collidable = true,
                        button = true,
                    }
                )
                
                table.insert(objects,
                    GameObject {
                        texture = 'keys',
                        x = (x - 1) * TILE_SIZE,
                        y = (5 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = 4 + levelColor,
                        collidable = true,
                        locked = true,
                        solid = true,
                    }
                )

            elseif x == width - 1 then
              table.insert(objects,
                GameObject {
                        texture = 'flags2',
                        x = (x - 1) * TILE_SIZE + 8,
                        y = (4 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = levelColor,
                        collidable = false,
                        solid = false,
                        animated = true,
                        flag = true,
                        invisible = true,
                        
                        
                    }
              )
              table.insert(objects,
                GameObject {
                        texture = 'flags1',
                        x = (x - 1) * TILE_SIZE,
                        y = (4 - 1) * TILE_SIZE,
                        width = 16,
                        height = 48,
                        frame = levelColor,
                        collidable = false,
                        solid = false,
                        flag = true,
                        pole = true,
                        invisible = true,
                        
                        onCollide = function(obj, player)
                          gSounds['pickup']:play()
                        end
                    }
              )

            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )

          
            end

            -- chance to spawn a block
            if (x > 4 and x < width - 2 and not (tilenames[x-1] == 'pillar') and math.random(10) == 1) or x == math.floor(0.9*width) then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        frame = 26,
                        collidable = true,
                        hit = false,
                        solid = true,
                        pieces = true,

                        -- collision function takes itself
                        onCollide = function(obj, player)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then
                              
                              if not hasKeySpawned and (math.random(width) < x or x > 0.7*width)then
                                local key = GameObject {
                                        texture = 'keys',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = levelColor,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.hasKey = true
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, key)
                                    
                                    
                                  hasKeySpawned = true
                              else
                                

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = 4,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:stop()
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                                
                              end
                              
                            end
                            gSounds['empty-block']:play()

                        end
                    }
                )
            end
        end
    end

    
    

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end