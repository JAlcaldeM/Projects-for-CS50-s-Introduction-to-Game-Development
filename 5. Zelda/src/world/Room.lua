--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Room = Class{}

function Room:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT
    
    self.xFilledValues = {}
    self.yFilledValues = {}

    self.tiles = {}
    self:generateWallsAndFloors()
    
    -- reference to player for collisions, etc.
    self.player = player
    
    self.entities = {}
    self.objects = {}
    
    -- entities in the room
    self:generateEntities()

    -- game objects in the room
    self:generateObjects()

    -- doorways that lead to other dungeon rooms
    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))
    table.insert(self.doorways, Doorway('bottom', false, self))
    table.insert(self.doorways, Doorway('left', false, self))
    table.insert(self.doorways, Doorway('right', false, self))

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    for i = 1, 10 do
        local type = types[math.random(#types)]
        
        local insertX, insertY = self:generateAllowedCoordinates()

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = insertX,
            y = insertY,
            
            width = 16,
            height = 16,

            health = 1,
            
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i]) end,
            ['idle'] = function() return EntityIdleState(self.entities[i]) end
        }

        self.entities[i]:changeState('walk')
    end
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    
    local insertX, insertY = self:generateAllowedCoordinates()
    
    local switch = GameObject(GAME_OBJECT_DEFS['switch'], insertX, insertY)

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'
            
            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end

            gSounds['door']:play()
        end
    end

    -- add to list of objects in scene (only one switch for now)
    table.insert(self.objects, switch)
    
    for i = 1, 8 do

      local insertX, insertY = self:generateAllowedCoordinates()
      
      local pot = GameObject(GAME_OBJECT_DEFS['pot'], insertX, insertY)
      pot.shadow = true
      pot.airOffset = 0
      pot.soundPiece = {gSounds['piece'],gSounds['piece2'],gSounds['piece3']}
      pot.onDestroy = function()
        gSounds['potbreak2']:stop()
        gSounds['potbreak2']:play()
        local minirupee = GameObject(GAME_OBJECT_DEFS['minirupee'], pot.x + pot.width/2 - 4, pot.y + pot.height/2)
              minirupee.onCollide = function()
                  if not minirupee.consumed then
                      minirupee.consumed = true
                      gSounds['rupee']:play()
                      self.player.rupees = self.player.rupees + 5
                  end
              end
              if math.random(2) == 1 then
                table.insert(self.objects, minirupee)
              end
              
              
      end
      
      
      
      table.insert(self.objects, pot)
    end
    
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:update(dt)
    
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0
        if entity.health <= 0 then
            if not entity.dead and math.random(4) == 1 then
              local miniheart = GameObject(GAME_OBJECT_DEFS['miniheart'], entity.x + entity.width/2 - 4, entity.y + entity.height/2 - 4)
              miniheart.onCollide = function()
                  if not miniheart.consumed then
                      miniheart.consumed = true
                      self.player.health = math.min(self.player.maxHealth, self.player.health + 1)
                      gSounds['heal']:play()
                  end
              end
              table.insert(self.objects, miniheart)
            end          
            entity.dead = true
        elseif not entity.dead then
            entity:processAI({room = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the room
        if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
            gSounds['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                gStateMachine:change('game-over')
            end
        end
        
        
    end

    for k, object in pairs(self.objects) do
        object:update(dt)
        
        if object.magnetic and object:isClose(self.player) and (not object.consumed) then
          object.x = object.x + 10*dt*clamp(self.player.x - object.x + 4, -5, 5)
          object.y = object.y + 10*dt*clamp(self.player.y - object.y + 12, -5, 5)
        end
          
        
        if object.thrown then
          self:checkWallHit(object)
        end
        


        -- trigger collision callback on object
        if self.player:collides(object) then
            object:onCollide()
        end
        
        if self.player:collides(object) and object.solid then
            self.player.x = self.player.xPrevious
            self.player.y = self.player.yPrevious
        end
        
        for n, entity in pairs(self.entities) do
          if entity:collides(object) and (not entity.dead) and object.thrown then
            entity:damage(1)
            object:destroy('enemy')
            gSounds['hit-enemy']:play()
          end
          
          
          if entity:collides(object) and object.solid then
              entity.x = entity.xPrevious
              entity.y = entity.yPrevious
          end
        end
        
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        if (not object.consumed) and (not object.picked) and (not object.thrown) then object:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE),
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)
    
    if self.player then
        self.player:render()
    end
    

    love.graphics.setStencilTest()
    
    if self.player then
        
        if self.player.objectPicked and (self.player.objectPicked.picked or self.player.objectPicked.picking) then
          
          if self.player.objectPicked.picked then
            self.player.objectPicked.x = self.player.x - 1
            self.player.objectPicked.y = self.player.y - 7
          end

          self.player.objectPicked:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end
    
    for k, object in pairs(self.objects) do
        if (not object.consumed) and (not object.picked) and (object.thrown or #object.pieces > 0) then object:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end
    

    --
    -- DEBUG DRAWING OF STENCIL RECTANGLES
    --

    -- love.graphics.setColor(255, 0, 0, 100)
    
    -- -- left
    -- love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
    -- TILE_SIZE * 2 + 6, TILE_SIZE * 2)

    -- -- right
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE),
    --     MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)

    -- -- top
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
    --     -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

    -- --bottom
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
    --     VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    
    -- love.graphics.setColor(255, 255, 255, 255)
end

function Room:generateAllowedCoordinates()
  
  local x, y = nil, nil
  local overlaps = true
  
  while overlaps do
    
    x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE, VIRTUAL_WIDTH - TILE_SIZE * 2 - 16)
    y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    
    overlaps = false
    
    if x > self.player.x - 16 and x < self.player.x + 16 and y > self.player.y - 16 and y < self.player.y + 32 then
        overlaps = true
    end
    
    for _, entity in pairs(self.entities) do
      if x > entity.x - 16 and x < entity.x + 16 and y > entity.y - 16 and y < entity.y + 16 then
        overlaps = true
      end
    end
    
    for _, object in pairs(self.objects) do
      if x > object.x - 16 and x < object.x + 16 and y > object.y - 16 and y < object.y + 16 then
        overlaps = true
      end
    end
    
    
  end
  
  return x, y
end




function Room:checkWallHit(object)

    if object.throwDirection == 'left'  and object.x <= MAP_RENDER_OFFSET_X + TILE_SIZE - 8 then
      object:destroy('wall')
    elseif object.throwDirection == 'right' and object.x + object.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 + 8 then
      object:destroy('wall')
    elseif object.throwDirection == 'up' and object.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - object.height / 2 - 8 then
      object:destroy('wall')
    elseif object.throwDirection == 'down' and object.y + object.height >= VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE + 8 then
      object:destroy('wall')
    end

end
